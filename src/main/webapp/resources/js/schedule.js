/**
 * 
 */

/**
 * Kakao Map Helper Class
 * 여행 프로젝트용 올인원 맵 매니저
 */
class KakaoMapHelper {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        this.map = null;
        this.markers = []; // 마커 관리용 배열
        this.clusterer = null;
        this.ps = new kakao.maps.services.Places(); // 장소 검색 객체
        this.geocoder = new kakao.maps.services.Geocoder(); // 주소-좌표 변환 객체
        this.infowindow = new kakao.maps.InfoWindow({zIndex:1});
    }

    // 1. 지도 초기화 및 컨트롤 추가
    init(lat = 37.566826, lng = 126.9786567, level = 3) {
        const options = {
            center: new kakao.maps.LatLng(lat, lng),
            level: level
        };
        this.map = new kakao.maps.Map(this.container, options);

        // 줌 컨트롤 & 지도 타입 컨트롤 추가 (기본 장착)
        const mapTypeControl = new kakao.maps.MapTypeControl();
        this.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
        const zoomControl = new kakao.maps.ZoomControl();
        this.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        // 클러스터러 세팅 (마커 많을 때 뭉쳐서 보여줌)
        this.clusterer = new kakao.maps.MarkerClusterer({
            map: this.map, 
            averageCenter: true, 
            minLevel: 6 
        });
        
        console.log("Kakao Map Initialized!");
    }

    // 2. 마커 추가 (클릭 이벤트 포함)
	addMarker(lat, lng, title, category, data = null) {
	    const position = new kakao.maps.LatLng(lat, lng);
	    
	    // 이미지 설정
	    const markerImage = this.getMarkerImage(category);

	    const marker = new kakao.maps.Marker({
	        position: position,
	        map: this.map,
	        title: title,
	        image: markerImage // 이미지 적용
	    });

        // 마커에 커스텀 데이터 심기 (ex: 여행지 ID, 타입 등)
        if(data) marker.customData = data;

        // 마커 클릭 이벤트 (인포윈도우 오픈)
        kakao.maps.event.addListener(marker, 'click', () => {
            this.showInfoWindow(marker, title);
            // 필요 시 여기서 상세 페이지 이동 로직 호출 가능
            console.log("Clicked Marker Data:", marker.customData); 
        });

        this.markers.push(marker);
        this.clusterer.addMarker(marker); // 클러스터러에도 추가
        return marker;
    }

    // 3. 인포윈도우 표시
    showInfoWindow(marker, content) {
        const html = `<div style="padding:5px; z-index:1;">${content}</div>`;
        this.infowindow.setContent(html);
        this.infowindow.open(this.map, marker);
    }

    // 4. 모든 마커 삭제 (새로운 검색 등을 위해)
    clearMarkers() {
        this.clusterer.clear(); // 클러스터 비우기
        this.markers.forEach(marker => marker.setMap(null));
        this.markers = [];
    }

    // 5. 키워드로 장소 검색 (Places)
    searchPlaces(keyword, callback) {
        if (!keyword.replace(/^\s+|\s+$/g, '')) {
            alert('키워드를 입력해주세요!');
            return false;
        }
        // 장소검색 객체를 통해 키워드로 장소검색 요청
        this.ps.keywordSearch(keyword, (data, status, pagination) => {
            if (status === kakao.maps.services.Status.OK) {
                // 검색 성공 시 콜백함수 실행 (데이터 넘겨줌)
                if(callback) callback(data, pagination);
            } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
                alert('검색 결과가 존재하지 않습니다.');
            } else if (status === kakao.maps.services.Status.ERROR) {
                alert('검색 결과 중 오류가 발생했습니다.');
            }
        });
    }

    // 6. 주소로 좌표 검색 후 이동
    searchAddress(address, title = "검색된 위치") {
        this.geocoder.addressSearch(address, (result, status) => {
            if (status === kakao.maps.services.Status.OK) {
                const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                
                // 결과값으로 마커를 찍고
                this.addMarker(result[0].y, result[0].x, title);
                
                // 지도의 중심을 결과값으로 받은 위치로 이동
                this.map.setCenter(coords);
            } 
        });
    }

    // 7. 마커들이 다 보이게 지도 범위 재설정 (Bounds)
    fitBounds() {
        if (this.markers.length === 0) return;

        const bounds = new kakao.maps.LatLngBounds();
        this.markers.forEach(marker => {
            bounds.extend(marker.getPosition());
        });
        this.map.setBounds(bounds);
    }
    
    // 8. 지도 중심 이동
    moveTo(lat, lng) {
        const moveLatLon = new kakao.maps.LatLng(lat, lng);
        this.map.panTo(moveLatLon); // 부드럽게 이동
    }
	
	// 9. 경로 선 그리기 (좌표 배열을 받아서 선을 그음)
    drawPath(places) {
        // 기존 선이 있다면 지우기
        if (this.polyline) {
            this.polyline.setMap(null);
        }

        const linePath = places.map(p => new kakao.maps.LatLng(p.y, p.x));

        this.polyline = new kakao.maps.Polyline({
            path: linePath, // 선을 구성하는 좌표배열
            strokeWeight: 5, // 선의 두께
            strokeColor: '#00C73C', // 선 색깔 (모행 포인트 컬러에 맞춤)
            strokeOpacity: 0.8, // 선의 불투명도
            strokeStyle: 'solid' // 선의 스타일
        });

        this.polyline.setMap(this.map);
    }
	
	// 10. 커스텀 오버레이 (예쁜 말풍선)
    addCustomOverlay(lat, lng, content) {
        // content는 HTML 문자열 (div, img 등 자유롭게)
        const overlay = new kakao.maps.CustomOverlay({
            position: new kakao.maps.LatLng(lat, lng),
            content: content,
            yAnchor: 1 // 마커 바로 위에 찍히도록 좌표 조정
        });
        
        overlay.setMap(this.map);
        return overlay;
    }
	
/*	const content = `
	    <div class="custom-overlay">
	        <span class="title">협재 해수욕장</span>
	        <button onclick="deletePlace(1)">삭제</button>
	    </div>
	`;
	myMap.addCustomOverlay(33.39, 126.23, content);*/
	
	// 11. 카테고리별 마커 이미지 설정
	    getMarkerImage(category) {
	        let imageSrc = ''; 
	        
	        switch(category) {
	            case 'FD6': // 음식점 (카카오 코드 기준)
	            case '맛집':
	                imageSrc = '/images/icon_food.png'; 
	                break;
	            case 'CE7': // 카페
	            case '카페':
	                imageSrc = '/images/icon_cafe.png'; 
	                break;
	            case 'AT4': // 관광명소
	            case '관광지':
	                imageSrc = '/images/icon_spot.png'; 
	                break;
	            default:
	                return null; // 기본 마커 사용
	        }

	        const imageSize = new kakao.maps.Size(34, 39); 
	        const imageOption = {offset: new kakao.maps.Point(17, 39)}; 
	        
	        return new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
	    }

/*	    // (기존 addMarker 수정)
	    addMarker(lat, lng, title, category, data = null) {
	        const position = new kakao.maps.LatLng(lat, lng);
	        
	        // 이미지 설정
	        const markerImage = this.getMarkerImage(category);

	        const marker = new kakao.maps.Marker({
	            position: position,
	            map: this.map,
	            title: title,
	            image: markerImage // 이미지 적용
	        });
	        
	        // ... (이하 동일)
	    }*/
		
		
}

// 5. (옵션) 키워드 검색 기능 사용 예시
function searchBtnClicked(keywordValue) {
    const keyword = keywordValue;
    
    // 기존 마커 지우기
    myMap.clearMarkers();
    
    // 검색 실행
    myMap.searchPlaces(keyword, (data) => {
        // 검색 결과(data)를 받아서 마커 찍기
        data.forEach((place) => {
            myMap.addMarker(place.y, place.x, place.place_name, { id: place.id });
        });
        // 검색된 곳들로 지도 범위 조정
        myMap.fitBounds();
    });
}

$(".search-result-item").on("click", function() {
	let searchValue = $(this).find(".search-result-name").text();
	
	// 키워드로 장소를 검색합니다
	searchBtnClicked(searchValue);

})