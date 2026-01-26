/**
 * schedule.js - 여행 플래너 통합 관리 스크립트
 * (Kakao Maps API)
 */

// 전역 색상 설정
const colors = {
    'default': 'black',
    '0': 'black',
    '1': '#0000FF', // 파랑
    '2': '#FF0000', // 빨강
    '3': '#FFA500', // 주황
    '4': '#FF69B4', // 핑크
    '5': '#228B22', // 초록
    '6': '#800080', // 보라
    '7': '#00CED1', // 민트
    '8': '#FFD700', // 골드
    '9': '#8B4513', // 브라운
    '10': '#2F4F4F' // 다크그레이
};

class KakaoMapHelper {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        this.map = null;
        this.markers = []; // 전체 마커 저장
        
        // 상태 관리 변수들
        this.pathLine = null;        // 현재 그려진 경로 선 (Polyline)
        this.distanceOverlays = [];  // 거리 표시 오버레이 배열 (지우기 위해 저장)
        this.activeOverlay = null;   // 현재 열린 인포윈도우 (CustomOverlay)
    }

    // 1. 지도 초기화
    init(lat = 37.566826, lng = 126.9786567, level = 3) {
        if (!this.container) return;
        const options = {
            center: new kakao.maps.LatLng(lat, lng),
            level: level
        };
        this.map = new kakao.maps.Map(this.container, options);

        // 컨트롤 추가
        this.map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
        this.map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
		
		// [추가됨] 지도 빈 공간을 클릭하면 열려있는 오버레이 닫기
	    kakao.maps.event.addListener(this.map, 'click', () => {
	        if (this.activeOverlay) {
	            this.activeOverlay.setMap(null);
	            this.activeOverlay = null;
	        }
	    });
    }

    // 2. 마커 추가
    addMarker(lat, lng, title, category, data = null) {
        const position = new kakao.maps.LatLng(lat, lng);
        
        // 초기 마커 이미지 (기본)
        const markerImage = this.getMarkerImage(category);

        const marker = new kakao.maps.Marker({
            position: position,
            map: this.map,
            title: title,
            image: markerImage
        });

        // 마커 객체에 데이터 저장
        marker.category = category;
        marker.originalTitle = title; // 타이틀 보존
        if (data) marker.customData = data;

        // 클릭 이벤트 리스너 등록
        kakao.maps.event.addListener(marker, 'click', () => {
            // 1) 카테고리 경로 그리기 및 거리 계산 로직 실행
            this.handleCategorySelection(category);
            
            // 2) 클릭한 마커 위에 커스텀 인포윈도우 토글
            this.toggleInfoWindow(marker, title);
        });

        this.markers.push(marker);
        return marker;
    }

    // [핵심 로직] 카테고리별 경로 연결 및 거리 표시
    handleCategorySelection(category) {
        // 1. 기존 오버레이(거리 표시) 및 선 제거
        this.clearOverlays();
        if (this.pathLine) this.pathLine.setMap(null);

        // 2. 해당 카테고리 마커들 필터링
        const sameCategoryMarkers = this.markers.filter(m => m.category === category);
        const path = [];
        
        // 3. 순회하며 번호 매기기 및 거리 계산
        sameCategoryMarkers.forEach((m, index) => {
            const currentPos = m.getPosition();
            path.push(currentPos);

            // 3-1. 순서가 적힌 마커 이미지로 변경
            m.setImage(this.getMarkerForIndexImage(category, index));

            // 3-2. 이전 노드와 거리 계산 (index > 0 일 때만)
            if (index > 0) {
                const prevPos = sameCategoryMarkers[index - 1].getPosition();
                const line = new kakao.maps.Polyline({ path: [prevPos, currentPos] });
                const distance = line.getLength(); // 미터 단위

                // 중간 지점 좌표 계산
                const midPos = new kakao.maps.LatLng(
                    (prevPos.getLat() + currentPos.getLat()) / 2,
                    (prevPos.getLng() + currentPos.getLng()) / 2
                );

                this.drawDistanceOverlay(midPos, distance);
            }
        });

        // 4. 경로 선 그리기
        this.pathLine = new kakao.maps.Polyline({
            map: this.map,
            path: path,
            strokeWeight: 3,
            strokeColor: colors[category] || '#FF0000',
            strokeOpacity: 0.8,
            strokeStyle: 'solid'
        });
    }

    // 거리 텍스트 오버레이 그리기
    drawDistanceOverlay(position, distance) {
        const distanceText = distance < 1000 
            ? Math.round(distance) + 'm' 
            : (distance / 1000).toFixed(1) + 'km';

        const content = `
            <div style="
                background: white; 
                border: 1px solid #777; 
                padding: 2px 6px; 
                border-radius: 4px; 
                font-size: 11px; 
                font-weight: bold; 
                color: #333;
                box-shadow: 1px 1px 3px rgba(0,0,0,0.2);
            ">
                ${distanceText}
            </div>`;

        const overlay = new kakao.maps.CustomOverlay({
            position: position,
            content: content,
            yAnchor: 1.5,
            zIndex: 3
        });
        
        overlay.setMap(this.map);
        this.distanceOverlays.push(overlay);
    }

    // 정보창(커스텀 오버레이) 토글
    toggleInfoWindow(marker, content) {
        // 이미 열려있는 창이 있다면 닫기
        if (this.activeOverlay) {
            this.activeOverlay.setMap(null); // 지도에서 제거
            
            // 방금 클릭한 게 이미 열려있던 그 마커라면? -> 닫고 끝냄 (토글)
            if (this.activeOverlay.marker === marker) {
                this.activeOverlay = null;
                return;
            }
        }

        // 새 오버레이 생성
        const html = `
            <div class="custom-infowindow" style="
                position: relative;
                background: #fff;
                border: 2px solid #333;
                border-radius: 8px;
                padding: 10px;
                min-width: 120px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.3);
                bottom: 45px;
                text-align: center;
            ">
                <div style="font-weight:bold; font-size:13px; margin-bottom: 2px;">${content}</div>
                <div style="font-size:10px; color:#888;">한 번 더 클릭 시 닫기</div>
                
                <div style="
                    position: absolute;
                    bottom: -10px;
                    left: 50%;
                    transform: translateX(-50%);
                    width: 0; height: 0;
                    border-top: 10px solid #333;
                    border-left: 8px solid transparent;
                    border-right: 8px solid transparent;
                "></div>
                <div style="
                    position: absolute;
                    bottom: -7px;
                    left: 50%;
                    transform: translateX(-50%);
                    width: 0; height: 0;
                    border-top: 10px solid #fff;
                    border-left: 8px solid transparent;
                    border-right: 8px solid transparent;
                "></div>
            </div>`;

        const overlay = new kakao.maps.CustomOverlay({
            content: html,
            map: this.map,
            position: marker.getPosition(),
            yAnchor: 1,
            zIndex: 5
        });

        // 현재 오버레이 상태 저장
        overlay.marker = marker;
        this.activeOverlay = overlay;
    }

    // 초기 마커 이미지 생성
    getMarkerImage(category) {
        const color = colors[category] || colors['default'];
        const svgMarker = `
            <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24">
                <path fill="${color}" stroke="white" stroke-width="1.5" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
                <text x="12" y="12" fill="white" font-size="8" font-family="Arial" text-anchor="middle" font-weight="bold">${category}</text>
            </svg>`;
        
        return new kakao.maps.MarkerImage(
            'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgMarker))),
            new kakao.maps.Size(36, 36),
            { offset: new kakao.maps.Point(18, 36) }
        );
    }

    // 순서 번호 마커 이미지 생성
    getMarkerForIndexImage(category, index) {
        const color = colors[category] || '#000000';
        const svgMarker = `
            <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 24 24">
                <path fill="${color}" stroke="white" stroke-width="1.5" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
                <text x="12" y="12" fill="white" font-size="8" font-family="Arial" text-anchor="middle" font-weight="bold">${index + 1}</text>
            </svg>`;

        return new kakao.maps.MarkerImage(
            'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgMarker))),
            new kakao.maps.Size(36, 36),
            { offset: new kakao.maps.Point(18, 36) }
        );
    }

    // 유틸리티: 거리 오버레이 및 데이터 초기화
    clearOverlays() {
        if (this.distanceOverlays) {
            this.distanceOverlays.forEach(o => o.setMap(null));
        }
        this.distanceOverlays = [];
    }
	
	// 지도 범위 재설정 (인자가 없으면 전체, 있으면 해당 카테고리만)
	fitBounds(category = null) {
	    const bounds = new kakao.maps.LatLngBounds();
	    let targets = this.markers;

	    // 1. 특정 카테고리가 지정되었다면 필터링
	    if (category) {
	        targets = this.markers.filter(m => m.category === category);
	    }

	    // 2. 마커가 하나도 없으면 실행하지 않음
	    if (targets.length === 0) return;

	    // 3. 마커들의 좌표를 빈(bounds) 영역에 모두 포함시킴
	    targets.forEach(marker => {
	        bounds.extend(marker.getPosition());
	    });

	    // 4. 지도 범위를 재설정 (약간의 여백과 함께 이동)
	    this.map.setBounds(bounds);
	}
	
	
}