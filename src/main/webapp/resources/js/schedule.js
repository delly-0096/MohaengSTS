/**
 * schedule.js - 여행 플래너 통합 관리 스크립트
 * (카카오 맵 API 및 드래그 앤 드롭 기능 포함)
 */

class KakaoMapHelper {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        this.map = null;
        this.markers = [];
        this.ps = new kakao.maps.services.Places();
        this.geocoder = new kakao.maps.services.Geocoder();
        this.infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });
        
        // 거리 측정 관련 상태
        this.polyline = null; 
        this.distanceOverlay = null; 
        this.lastClickedMarker = null; 
    }

    // 1. 지도 초기화
    init(lat = 37.566826, lng = 126.9786567, level = 3) {
        if (!this.container) return;
        const options = {
            center: new kakao.maps.LatLng(lat, lng),
            level: level
        };
        this.map = new kakao.maps.Map(this.container, options);

        this.map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
        this.map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
    }

    // 2. 마커 추가 및 토글 로직 연결
    addMarker(lat, lng, title, category, data = null) {
        const position = new kakao.maps.LatLng(lat, lng);
        const markerImage = this.getMarkerImage(category);

        const marker = new kakao.maps.Marker({
            position: position,
            map: this.map,
            title: title,
            image: markerImage
        });

        if (data) marker.customData = data;

        // 마커 클릭 시 선택/해제 토글
        kakao.maps.event.addListener(marker, 'click', () => {
            this.toggleMarkerSelection(marker, title);
        });

        this.markers.push(marker);
        return marker;
    }
	
/*	getMarkerImage(category) {
	    const colors = {
	        'tour': '#FF0000', // 빨강
	        'food': '#FFA500', // 주황
	        'cafe': '#FF69B4', // 핑크
	        'default': '#0000FF' // 파랑
	    };
	    const color = colors[category] || colors['default'];

	    // SVG로 마커 모양 만들기 (동그라미 핀 모양)
	    const svgMarker = `
	        <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24">
	            <path fill="${color}" stroke="white" stroke-width="2" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
	            <circle fill="white" cx="12" cy="9" r="2.5"/>
	        </svg>
	    `;

	    const imageSrc = 'data:image/svg+xml;base64,' + btoa(svgMarker);
	    const imageSize = new kakao.maps.Size(30, 30);
	    
	    return new kakao.maps.MarkerImage(imageSrc, imageSize);
	}*/

    // 3. 마커 선택 토글 및 거리 측정 로직
    toggleMarkerSelection(marker, title) {
        // [취소] 이미 선택된 마커를 다시 클릭한 경우
        if (this.lastClickedMarker === marker) {
            this.clearRouteDisplay();
            this.infowindow.close();
            this.lastClickedMarker = null;
            return;
        }

        // [선택] 이전 마커가 있다면 거리 계산
        if (this.lastClickedMarker) {
            this.drawRouteBetween(this.lastClickedMarker, marker);
        }

        // 상태 업데이트 및 정보창 표시
        this.showInfoWindow(marker, title);
        this.lastClickedMarker = marker;
    }

    // [거리 계산] 선 그리기 및 오버레이 표시
    drawRouteBetween(startMarker, endMarker) {
        const startPos = startMarker.getPosition();
        const endPos = endMarker.getPosition();

        this.clearRouteDisplay();

        this.polyline = new kakao.maps.Polyline({
            path: [startPos, endPos],
            strokeWeight: 4,
            strokeColor: '#FF4E50',
            strokeOpacity: 0.8,
            strokeStyle: 'dash'
        });
        this.polyline.setMap(this.map);

        const distance = Math.round(this.polyline.getLength());
        const midPos = new kakao.maps.LatLng(
            (startPos.getLat() + endPos.getLat()) / 2,
            (startPos.getLng() + endPos.getLng()) / 2
        );

        this.distanceOverlay = new kakao.maps.CustomOverlay({
            map: this.map,
            position: midPos,
            content: `<div class="dotOverlay">거리: <span class="number">${distance}</span>m</div>`,
            yAnchor: 1.5
        });

        // 실제 도로 길찾기 컨펌
/*        setTimeout(() => {
            if (confirm(`직선 거리 ${distance}m 확인되었습니다.\n실제 도로 기준 길찾기를 보시겠습니까?`)) {
                const sLat = startPos.getLat(), sLng = startPos.getLng();
                const eLat = endPos.getLat(), eLng = endPos.getLng();
                const sName = encodeURIComponent(startMarker.getTitle());
                const eName = encodeURIComponent(endMarker.getTitle());
                window.open(`https://map.kakao.com/?sName=${sName}&sX=${sLng}&sY=${sLat}&eName=${eName}&eX=${eLng}&eY=${eLat}`, '_blank');
            }
        }, 100);*/
    }

    clearRouteDisplay() {
        if (this.polyline) this.polyline.setMap(null);
        if (this.distanceOverlay) this.distanceOverlay.setMap(null);
    }

    showInfoWindow(marker, content) {
        const html = `<div style="padding:10px; min-width:150px;">
                        <div style="font-weight:bold; margin-bottom:5px;">${content}</div>
                      </div>`;
/*                        <div style="font-size:11px; color:#666;">한 번 더 클릭하면 선택이 해제됩니다.</div>*/
        this.infowindow.setContent(html);
        this.infowindow.open(this.map, marker);
    }

    clearMarkers() {
        this.clearRouteDisplay();
        this.markers.forEach(m => m.setMap(null));
        this.markers = [];
        this.lastClickedMarker = null;
    }

    fitBounds() {
        if (this.markers.length === 0) return;
        const bounds = new kakao.maps.LatLngBounds();
        this.markers.forEach(m => bounds.extend(m.getPosition()));
        this.map.setBounds(bounds);
    }

    getMarkerImage(category) {
        let imageSrc = ''; 
        switch(category) {
            case '맛집': case 'FD6': imageSrc = '/images/icon_food.png'; break;
            case '카페': case 'CE7': imageSrc = '/images/icon_cafe.png'; break;
            case '관광지': case 'AT4': imageSrc = '/images/icon_spot.png'; break;
            default: return null;
        }
        return new kakao.maps.MarkerImage(imageSrc, new kakao.maps.Size(34, 39));
    }
}