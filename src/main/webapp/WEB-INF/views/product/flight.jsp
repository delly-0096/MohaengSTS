<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="항공권 검색" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product-flight.css">

<div class="product-page">
	<!-- 헤더 -->
	<div class="product-header">
		<div class="container">
			<h1>
				<i class="bi bi-airplane me-3"></i>항공권 검색
			</h1>
			<p>국내 항공권을 한 번에 비교하고 최저가를 찾아보세요</p>
			<br/>
		</div>
	</div>
	
	<div class="container">
		<!-- 검색 박스 -->
		<div class="search-box">
			<div class="search-tabs">
				<button class="search-tab active" data-type="round">왕복</button>
				<button class="search-tab" data-type="oneway">편도</button>
			</div>
			
			
			
			<form id="flightSearchForm">
				<!-- 왕복/편도 검색 폼 -->
				<div id="normalSearchForm">
					<div class="search-form-row">
						<div class="form-group">
							<label class="form-label">출발지</label>
							<div class="search-input-group">
								<span class="input-icon"><i class="bi bi-geo-alt"></i></span> <input
									type="text" class="form-control location-autocomplete"
									id="departure" placeholder="도시 또는 공항" autocomplete="off">
								<div class="autocomplete-dropdown" id="departureDropdown"></div>
							</div>
							<input type="hidden" name="depAirportId" id="depAirportId" />
							<input type="hidden" name="depIataCode" id="depIataCode"/> 
						</div>
						
						<div class="form-group">
							<label class="form-label">도착지</label>
							<div class="search-input-group">
								<span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>
								<input type="text" class="form-control location-autocomplete"
									id="destination" placeholder="도시 또는 공항" autocomplete="off">
								<div class="autocomplete-dropdown" id="destinationDropdown"></div>
							</div>
							<input type="hidden" name="arrAirportId" id="arrAirportId" />
							<input type="hidden" name="arrIataCode" id="arrIataCode"/> 
						</div>
						
						<div class="form-group">
							<label class="form-label">가는날</label> <input type="text"
								class="form-control date-picker" id="departDate"
								placeholder="날짜 선택">
						</div>
						<div class="form-group" id="returnDateGroup">
							<label class="form-label">오는날</label> <input type="text"
								class="form-control date-picker" id="returnDate"
								placeholder="날짜 선택">
						</div>
						<button type="submit" class="btn btn-primary btn-search">
							<i class="bi bi-search me-2"></i>검색
						</button>
					</div>
				</div>

				<!-- 승객 정보 -->
				<div class="search-form-row mt-3">
					<div class="form-group passenger-dropdown">
						<label class="form-label">승객</label> <input type="text"
							class="form-control passenger-input" id="passengerInput"
							value="성인 1명" readonly onclick="togglePassengerPanel()">
						<div class="passenger-panel" id="passengerPanel">
							<div class="passenger-row">
								<div class="passenger-label">
									성인 <span>만 12세 이상</span>
								</div>
								<div class="passenger-counter">
									<button type="button" class="counter-btn"
										onclick="updatePassenger('adult', -1)">-</button>
									<span class="counter-value" id="adultCount">1</span>
									<button type="button" class="counter-btn"
										onclick="updatePassenger('adult', 1)">+</button>
								</div>
							</div>
							<div class="passenger-row">
								<div class="passenger-label">
									소아 <span>만 2~11세</span>
								</div>
								<div class="passenger-counter">
									<button type="button" class="counter-btn"
										onclick="updatePassenger('child', -1)">-</button>
									<span class="counter-value" id="childCount">0</span>
									<button type="button" class="counter-btn"
										onclick="updatePassenger('child', 1)">+</button>
								</div>
							</div>
							<div class="passenger-row">
								<div class="passenger-label">
									유아 <span>만 2세 미만</span>
								</div>
								<div class="passenger-counter">
									<button type="button" class="counter-btn"
										onclick="updatePassenger('infant', -1)">-</button>
									<span class="counter-value" id="infantCount">0</span>
									<button type="button" class="counter-btn"
										onclick="updatePassenger('infant', 1)">+</button>
								</div>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="form-label">좌석 등급</label> <select
							class="form-control form-select" id="cabinClass">
							<option value="economy">일반석</option>
							<option value="business">비즈니스석</option>
						</select>
					</div>
				</div>
			</form>
		</div>

		<!-- 선택한 항공편 표시 영역 -->
		<div class="selected-flights-container" id="selectedFlightsContainer"
			style="display: none;">
			<div class="selected-flights-header">
				<h5>
					<i class="bi bi-check-circle-fill me-2"></i>선택한 항공편
				</h5>
				<button type="button" class="btn btn-outline-secondary btn-sm"
					onclick="resetFlightSelection()">
					<i class="bi bi-arrow-counterclockwise me-1"></i>다시 선택
				</button>
			</div>
			<div class="selected-flights-list" id="selectedFlightsList"></div>
		</div>

		<!-- 현재 선택 단계 표시 -->
		<div class="selection-step-indicator" id="selectionStepIndicator"
			style="display: none;">
			<div class="step-badge">
				<span id="currentStepText">오는날 선택</span>
			</div>
		</div>

		<!-- 검색 결과 -->
		<div class="flight-results" id="flightResults">
			<div class="results-header">
				<p class="results-count">
					<!-- 검색 결과 출력 -->
<!-- 					<button type="button" onclick="getMember()">정보</button> -->
				</p>
				<div class="sort-options">
					<button class="sort-btn active" data-sort="price">최저가순</button>
					<button class="sort-btn" data-sort="duration">최단시간순</button>
					<button class="sort-btn" data-sort="departure">출발시간순</button>
				</div>
			</div>

			<div class="flight-result">
				<!-- 항공권 출력 -->
			</div>
			<!-- 로딩 인디케이터 -->
			<div class="infinite-scroll-loader" id="flightScrollLoader" style="display: none;">
				<div class="loader-spinner">
					<div class="spinner-border text-primary" role="status">
						<span class="visually-hidden">Loading...</span>
					</div>
				</div>
			</div>

			<!-- 더 이상 데이터 없음 -->
			<div class="infinite-scroll-end" id="flightScrollEnd"
				style="display: none;">
				<p>모든 항공편을 불러왔습니다</p>
			</div>
		</div>
	</div>
</div>

<script>
// 승객 정보 - 2번제 결제하기 누르면 이동하기
let passengers = { adult: 1, child: 0, infant: 0 };
// session 저장을 여기서도 하고 받을지
// ==================== 항공편 선택 상태 관리 ====================
let currentSearchType = 'round'; // round - 왕복, oneway - 편도, multi
let currentSelectionStep = 0; // 현재 선택 단계 (0: 가는편, 1: 오는편)
let selectedFlights = []; // 선택된 항공편 목록
let totalSegments = 2; // 총 선택해야 할 구간 수 (왕복: 2, 편도: 1)

let storedData = null;	// storage에 저장된 정보


const list = document.getElementById('selectedFlightsList');

let selectedFlightList = [];	// 선택한 항공권 저장

// 검색 타입 탭 전환
document.querySelectorAll('.search-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        document.querySelectorAll('.search-tab').forEach(t => t.classList.remove('active'));
        this.classList.add('active');

        const type = this.dataset.type;
        currentSearchType = type;
//         resetFlightSelection();
		
        if (type === 'oneway') {
            document.getElementById('returnDateGroup').style.display = 'none';
            totalSegments = 1;
        } else {
            document.getElementById('returnDateGroup').style.display = 'block';
            totalSegments = 2;
        }

        updateFlightButtons();				// 버튼 텍스트 업데이트
        updateSelectionStepIndicator(); 	// 선택 단계 표시 업데이트
    });
});

// 버튼 텍스트 업데이트
function updateFlightButtons() {
    const buttons = document.querySelectorAll('.flight-action-btn');
    const isLastStep = (currentSelectionStep >= totalSegments - 1);

    buttons.forEach(btn => {
        if (currentSearchType === 'oneway') {
            btn.textContent = '결제하기';
        } else {
            btn.textContent = isLastStep ? '결제하기' : '선택';
        }
    });
}

// 선택 단계 표시 업데이트
function updateSelectionStepIndicator() {
    const indicator = document.getElementById('selectionStepIndicator');
    const stepText = document.getElementById('currentStepText');

    if (currentSearchType === 'oneway') {
        indicator.style.display = 'none';
        return;
    }

    indicator.style.display = 'block';

    if (currentSearchType === 'round') {
        stepText.textContent = currentSelectionStep === 0 ? '가는편 선택' : '오는편 선택';
    }
}

// 항공편 선택 처리 - id, data, searchData, startDate, duration, 
// function selectFlight(id, airline, flightSymbol, depTime, arrTime, startDate, domesticDays, depAirport, arrAirport, price, duration, checkedBaggage) {
function selectFlight(jsonSendData) {
	cabinClass = document.querySelector("#cabinClass");
	
	const flightData = JSON.parse(jsonSendData); 
	console.log("jsonData : ", flightData.airlineId);
	
//     const flightData = {
//         id: sendData.id,							// id - 조정
//         airline: sendData.airline,				// 항공사
//         flightSymbol: sendData.flightSymbol,		// 항공사 iata코드
//         departureTime: sendData.depTime,			// 출발 시간
//         arrivalTime: sendData.arrTime,			// 도착 시간
//         startDate : sendData.startDate,			// 자체
//         domesticDays : sendData.domesticDays,	// 출발일
//         departureAirport: sendData.depAirport,	// 출발 공항 코드
//         arrivalAirport: sendData.arrAirport,		// 출발 공항 코드
//         price: sendData.price,					// 가격 - 결제 || 예약 정보에 들어갈 것들
//         duration : sendData.duration,			// 걸린 시간
//         step: currentSelectionStep,		// 숫자 낮은것 부터 insert
//         adult : passengers.adult,		
//         child : passengers.child,
//         infant : passengers.infant,
//         cabinClass : cabinClass.value == "economy" ? "일반석" : "비즈니스"
//         checkedBaggage : sendData.checkedBaggage   // 짐 무게?
//         id: id,							// id - 조정
//         airline: airline,				// 항공사
//         flightSymbol: flightSymbol,		// 항공사 iata코드
//         departureTime: depTime,			// 출발 시간
//         arrivalTime: arrTime,			// 도착 시간
//         startDate : startDate,			// 자체
//         domesticDays : domesticDays,	// 출발일
//         departureAirport: depAirport,	// 출발 공항 코드
//         arrivalAirport: arrAirport,		// 출발 공항 코드
//         price: price,					// 가격 - 결제 || 예약 정보에 들어갈 것들
//         duration : duration,			// 걸린 시간
//         step: currentSelectionStep,		// 숫자 낮은것 부터 insert
//         adult : passengers.adult,		
//         child : passengers.child,
//         infant : passengers.infant,
//         cabinClass : cabinClass.value == "economy" ? "일반석" : "비즈니스",
//         checkedBaggage : checkedBaggage   // 짐 무게?
//     };
	console.log("flightData : ", flightData);
    
    
    selectedFlights.push(flightData);
    currentSelectionStep++;
    
    // 편도인 경우 바로 결제 페이지로 이동
    if (currentSearchType === 'oneway' || currentSelectionStep === 2) {
        goToBooking();
        return;
    }
    
	
    // 선택한 항공편 표시 업데이트
    updateSelectedFlightsDisplay();
// 	console.log("selectFlight currentSelectionStep : ", currentSelectionStep);
	
    /////////////////////////////////////////////
    // 3번쨰일때 실행할 것
    if(currentSelectionStep > totalSegments){
    	resetFlightSelection();
    	selectedFlights.push(flightData);
        currentSelectionStep = 1;
    	console.log("selectFlight currentSelectionStep 몇번째인지 : ", currentSelectionStep);
    }
    
    // 다음 구간 선택을 위해 버튼 및 표시 업데이트
    updateFlightButtons();
    updateSelectionStepIndicator();

    // axios 실행
    searchFlights();
    
    // 스크롤을 검색 결과 상단으로 이동
	document.getElementById('flightResults').scrollIntoView({ behavior: 'smooth', block: 'start' });
    
}

// 선택한 항공편 표시 업데이트
function updateSelectedFlightsDisplay() {
    const container = document.getElementById('selectedFlightsContainer');
 
    if (selectedFlights.length === 0) {
        container.style.display = 'none';
        return;
    }

    container.style.display = 'block';

    let html = '';
    let totalPrice = 0;

    selectedFlights.forEach((flight, index) => {
    	const label = 
    		(currentSearchType === 'round') ? (index === 0 ? '가는편' : '오는편') : '편도';
        console.log("flight 객체 : ", flight);
		// 날짜 넣기??
        totalPrice += parseInt(flight.price);
        html += '<div class="selected-flight-item">' +
            '<div class="selected-flight-info">' +
                '<span class="selected-flight-label">' + label + '</span>' +
                '<div class="selected-flight-detail">' + flight.startDate + '(' + flight.domesticDays + ')' + 
                    '<span class="selected-flight-time">' + flight.depTimeFormmater + ' → ' + flight.arrTimeFormmater + '</span>' +
                    '<span class="selected-flight-route">' + flight.depIata + ' → ' + flight.arrIata + '</span>' +
                '</div>' +
                '<span class="selected-flight-airline">' + flight.airlineNm + ' (' + flight.flightSymbol + ')</span>' +
            '</div>' +
            '<span class="selected-flight-price">' + flight.price + '원</span>' +
        '</div>';
    });

    // 모든 구간 선택 완료 시 총 금액 및 결제 버튼 표시
    if (currentSelectionStep >= totalSegments) {
        html += '<div class="selected-flights-total">' +
            '<div>' +
                '<span class="total-price-label">총 금액</span>' +
                '<span class="total-price-value ms-3">' + totalPrice + '원</span>' +
            '</div>' +
            '<div class="btn btn-primary btn-lg" onclick="goToBooking()">' +
                '<i class="bi bi-credit-card me-2"></i>결제하기' +
            '</div>' +
        '</div>';
    }
    list.innerHTML = html;
}

// 선택 초기화
function resetFlightSelection() {
    selectedFlights = [];
    currentSelectionStep = 0;

    document.getElementById('selectedFlightsContainer').style.display = 'none';
    document.getElementById('selectedFlightsList').innerHTML = '';

    updateFlightButtons();
    updateSelectionStepIndicator();
}

// 결제 페이지로 이동
function goToBooking() {
	console.log("selectedFlights length : ",selectedFlights.length);
	if (!selectedFlights || selectedFlights.length === 0) return;
	
    const bookingData = {
        tripType: currentSearchType,
        totalSegments: totalSegments,
        flights: selectedFlights.map((f, index) => ({
            ...f,
            segmentIndex: index,
            segmentLabel: getSegmentLabel(index)
        }))
    };
    
    // 항공편 데이터를 sessionStorage에 저장
//     sessionStorage.removeItem('flightProduct');
    sessionStorage.setItem('flightProduct', JSON.stringify(bookingData));
    
    const flightIds = selectedFlights.map(f => f.id).join(',');
    window.location.href = '/product/flight/booking'/* ?flightIds=' + flightIds + '&type=' + currentSearchType */;
}

// 구간 라벨 생성
function getSegmentLabel(index) {
	if (currentSearchType === 'oneway') return '편도';
    return index === 0 ? '가는편' : '오는편';
}

// 승객 패널 토글
function togglePassengerPanel() {
    document.getElementById('passengerPanel').classList.toggle('active');
}


// 패널 외부 클릭 시 닫기
document.addEventListener('click', function(e) {
    // 일반 검색 승객 드롭다운
    const dropdown = document.querySelector('.search-form-row.mt-3 .passenger-dropdown');
    if (dropdown && !dropdown.contains(e.target)) {
        document.getElementById('passengerPanel').classList.remove('active');
    }
});

// 승객 수 업데이트
function updatePassenger(type, delta) {
    const newValue = passengers[type] + delta;

    if (type === 'adult' && newValue < 1) return;
    if (newValue < 0) return;
    if (newValue > 9) return;

    passengers[type] = newValue;
    document.getElementById(type + 'Count').textContent = newValue;

    // 입력 필드 업데이트
    let text = [];
    if (passengers.adult > 0) text.push('성인 ' + passengers.adult + '명');
    if (passengers.child > 0) text.push('소아 ' + passengers.child + '명');
    if (passengers.infant > 0) text.push('유아 ' + passengers.infant + '명');
    document.getElementById('passengerInput').value = text.join(', ');
}


// 정렬 옵션
document.querySelectorAll('.sort-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        document.querySelectorAll('.sort-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        // 실제 구현 시 정렬 로직
    });
});

// ==================== 인피니티 스크롤 ====================
var flightCurrentPage = 1;
var flightIsLoading = false;
var flightHasMore = false;	// 인피니티 스크롤 적용시
var flightTotalPages = 4;

// 추가 항공편 데모 데이터 - 인피니티
var additionalFlights = [
    {
        airline: '아시아나',
        flightNo: 'OZ8905',
        departureTime: '09:30',
        departureAirport: 'GMP 김포',
        arrivalTime: '10:40',
        arrivalAirport: 'CJU 제주',
        duration: '1시간 10분',
        type: '직항',
        price: 62000,
        fuel: 28000,
        tax: 24000,
    }
];

// 스크롤 초기화
function initFlightInfiniteScroll() {
    var loader = document.getElementById('flightScrollLoader');
    if (!loader) return;

    var observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting && !flightIsLoading && flightHasMore) {
                loadMoreFlights();
            }
        });
    }, {
        root: null,
        rootMargin: '100px',
        threshold: 0
    });

    observer.observe(loader);
}

// infinity scroll - 같은 정보를 page늘려서 보내기
function loadMoreFlights() {
    if (flightIsLoading || !flightHasMore) return;

    flightIsLoading = true;
    document.getElementById('flightScrollLoader').style.display = 'flex';

    setTimeout(function() {
        flightCurrentPage++;

        if (flightCurrentPage > flightTotalPages) {
            flightHasMore = false;
            document.getElementById('flightScrollLoader').style.display = 'none';
            document.getElementById('flightScrollEnd').style.display = 'block';
            flightIsLoading = false;
            return;
        }

        var resultsList = document.getElementById('flightResults');
        var loader = document.getElementById('flightScrollLoader');
        var flightsToAdd = getFlightsForPage(flightCurrentPage);		// 넘길 것? 그다음 페이지로 보여주기??

        flightsToAdd.forEach(function(flight, index) {
            var flightHtml = createFlightCard(flight, flightCurrentPage * 10 + index);	// 
            var tempDiv = document.createElement('div');
            tempDiv.innerHTML = flightHtml;
            var newCard = tempDiv.firstElementChild;

            newCard.style.opacity = '0';
            newCard.style.transform = 'translateY(20px)';
            resultsList.insertBefore(newCard, loader);

            setTimeout(function() {
                newCard.style.transition = 'all 0.4s ease';
                newCard.style.opacity = '1';
                newCard.style.transform = 'translateY(0)';
            }, index * 100);
        });

        flightIsLoading = false;
    }, 800);
}

// 전체를 불러오고 id를 10개씩 나눠서 인피니티 적용
function getFlightsForPage(page) {
    var flights = [];
    for (var i = 0; i < 3; i++) {
        var dataIndex = ((page - 2) * 3 + i) % additionalFlights.length;
        flights.push(Object.assign({}, additionalFlights[dataIndex]));
    }
    return flights;
}

// - infiniteScroll 받을때
function createFlightCard(data, searchData, id) {
	cabinClass = document.querySelector("#cabinClass");
	
	let fltProdId = searchData.startDt + "" + id;	// 일단 항공권 id = 일자 + id
	
	// 버튼 텍스트 결정
    let isLastStep = (currentSelectionStep >= totalSegments - 1);
    let buttonText = (currentSearchType === 'oneway' || isLastStep) ? '결제하기' : '선택';
    
    if(data.economyCharge === 0 || (data.airlineNm == '/' || data.airlineNm === null)) return '';
	
    let startDate = searchData.startDt.substring(0, 4) + "년 " + searchData.startDt.substring(4, 6) + "월 " + searchData.startDt.substring(6, 8) + "일 "; 
	
	let depTimeSet = data.depTime.split(" ");	// 날짜 시간 분리
	let arrTimeSet = data.arrTime.split(" ");
	
	let depAp = depTimeSet[1].split(":");	// 시 분 분리	
	let arrAp = arrTimeSet[1].split(":");
	
	let depTimeFormmater = parseInt(depAp[0]) > 12 ? 
			"오후 " + (parseInt(depAp[0]) - 12) + ":" + depAp[1] :
			"오전 " + depTimeSet[1];
	let arrTimeFormmater = parseInt(arrAp[0]) > 12 ?
			"오후 " + (parseInt(arrAp[0]) - 12) + ":" + arrAp[1] :
			"오전 " + arrTimeSet[1];
			
	
	let timeSet = (parseInt(arrAp[0] * 60) + parseInt(arrAp[1]))
	- (parseInt(depAp[0] * 60) + parseInt(depAp[1]));
	
	let duration = parseInt(timeSet / 60) + "시간 " + (timeSet % 60) + "분"; 
	
	let cabin = cabinClass.value == "economy" ? "일반석" : "비즈니스";
	
	let price = cabin == "일반석" ? data.economyCharge : data.prestigeCharge;
	
	const sendData = {
		...data,
		...searchData,
		fltProdId : parseInt(fltProdId),	
		startDate : startDate,
		duration : duration,
		step: currentSelectionStep,		// 숫자 낮은것 부터 insert
	    adult : passengers.adult,		
	    child : passengers.child,
	    infant : passengers.infant,
	    cabinClass : cabin,
	    price : price,					// 가격 세팅
	    depTimeFormmater : depTimeFormmater,
	    arrTimeFormmater : arrTimeFormmater
	};
	
	const jsonSendData = JSON.stringify(sendData).replace(/"/g, '&quot;');
	
	
	// id에 돌아오는것, 가는것 알파벳 추가?
	// 선택한 클래스에 따라 요금을 economey, prestige로 변경하기
			
    return `<div class="flight-card" data-flight-id="\${fltProdId}">
        <div class="flight-card-content">
            <div class="flight-info">
                <div class="flight-time">
                    <div class="time">\${depTimeFormmater}</div>
                    <div class="airport">\${searchData.depAirportNm}</div>
                </div>
            </div>
            <div class="flight-duration">
                <div class="duration-text">\${duration}</div>
                <div class="duration-line">
                    <i class="bi bi-airplane"></i>
                </div>
                <div class="flight-airline">\${data.airlineNm} \${data.flightSymbol}</div>
            </div>
            <div class="flight-info">
                <div class="flight-time">
                    <div class="time">\${arrTimeFormmater}</div>
                    <div class="airport">\${searchData.arrAirportNm}</div>
                </div>
            </div>
            <div class="flight-baggage">
				<i class="bi bi-luggage-fill"></i><span>\${data.checkedBaggage} kg</span>
			</div>
            <div class="flight-price">
                <div class="price">\${price}<span class="price-unit">원</span></div>
                <button type="button" class="btn btn-primary btn-sm flight-action-btn" 
                    onclick="selectFlight('\${jsonSendData}')">
                    \${buttonText}
                </button>
            </div>
        </div>
    </div>`;
}

// onclick="selectFlight('\${id}', '\${data.airlineNm}', '\${data.flightSymbol}',
//     '\${data.depTime}', '\${data.arrTime}', '\${startDate}' , '\${data.domesticDays}', '\${searchData.depIata}', '\${searchData.arrIata}',
//     '\${data.economyCharge}', '\${duration}', '\${data.checkedBaggage}')">

// id, data, searchData, startDate, duration, 

// 도착지는 출발지와 같을수 없음 필터
document.querySelector('#destination').addEventListener("click", function(e){
	let dp = document.querySelector('#departure').value;
	let ds = document.querySelector('#destination').value;
	if(dp === ds){
		// 같은 것 삭제
		document.querySelector('#returnDate').value = "";
		showToast('도착지는 출발지와 같을 수 없습니다.', 'error');
	}
});

// 날짜 필터
document.querySelector('#returnDate').addEventListener("change", function(e){
	let stDt = document.querySelector('#departDate').value.replaceAll("-","");
	let edDt = document.querySelector('#returnDate').value.replaceAll("-","");
	if(parseInt(stDt) > parseInt(edDt)){
		document.querySelector('#returnDate').value = "";
		showToast('오는날은 가는날 보다 빠를 수 없습니다.', 'error');
	}
});

// 검색 폼 제출
document.getElementById('flightSearchForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    // 초기화
	console.log("submit reset 전 currentSelectionStep : ", currentSelectionStep);
//    	selectedFlights = [];
//    	currentSelectionStep = 1;
//    	list.innerHTML = "";
  	resetFlightSelection();
    
    searchFlights();
});

function searchFlights() {
    
	const result = document.querySelector('.flight-result');
    result.innerHTML = ``;
    const searchCount = document.querySelector(".results-count");
    searchCount.innerHTML = ``;
    
    const activeTab = document.querySelector('.search-tab.active');
    const searchType = activeTab ? activeTab.dataset.type : 'round';	// 왕복, 편도
    
    const departure = document.querySelector('#departure').value;
    const destination = document.querySelector('#destination').value;
    const depAirportId = document.querySelector('#depAirportId').value;
    const arrAirportId = document.querySelector('#arrAirportId').value;
    const depIata = document.querySelector('#depIataCode').value;
    const arrIata = document.querySelector('#arrIataCode').value;
	const startDt = document.querySelector('#departDate').value;
    const endDt = document.querySelector('#returnDate').value;
	
    if (!departure) {
        showToast('출발지를 입력해주세요.', 'error');
        return;
    }
    
    if (!destination) {
        showToast('도착지를 입력해주세요.', 'error');
        return;
    }
    
    if(!startDt){
    	showToast('가는날을 입력해주세요.', 'error');
    	return;
    }
    
    if(currentSearchType === 'round' && !endDt){
    	showToast('오는날을 입력해주세요.', 'error');
    	return;
    }
    
	// 출발시간 = vo에 매칭할 정보
    const searchData = {
    	type : searchType,
    	depAirportNm : (currentSelectionStep === 0) ? departure : destination, 		// 출발지
    	depAirportId : (currentSelectionStep === 0) ? depAirportId : arrAirportId,	// 출발지 코드
    	depIata : (currentSelectionStep === 0) ? depIata : arrIata,					// 출발지 3글자 코드
    	startDt : (currentSelectionStep === 0) ? startDt.replaceAll("-", "") : endDt.replaceAll("-", ""), 	// 뭔가 조건 걸기
    	arrAirportNm : (currentSelectionStep === 0) ? destination : departure, 		// 도착지  
    	arrAirportId : (currentSelectionStep === 0) ? arrAirportId : depAirportId,	// 도착지 코드
    	arrIata : (currentSelectionStep === 0) ? arrIata : depIata					// 도착지 3글자 코드
    	// 탑승자 정보 - 성인, 유아
    }
    
    // 왕복/편도 검색
    showToast('항공편을 검색하고 있습니다...', 'info');
    
    // 실제 구현 시 API 호출 또는 검색 결과 페이지로 이동 - axios 설정
    axios.post(`/product/flight/searchFlight`, searchData
    ).then(res => {
    	const flight = res.data;
	    let searchSize = flight.length;
    	let noMoney = 0;  // 금액 안나올때
    	if(flight != null && searchSize > 0){
	    	console.log("결과", flight);
	    	// 출력하기
	    	for(let i = 0; i < searchSize; i++){
	    		if(flight[i].economyCharge === 0 || (flight[i].airlineNm === '/' || flight[i].airlineNm === null)) {
	    			noMoney++;
	    		}
	    		else{
// 	    			flight.prestigeCharge = flight.economyCharge + (flight.economyCharge * );
		    		result.innerHTML += createFlightCard(flight[i], searchData, i);
	    		}
	    	}
	  		flightHasMore = true;
    	} else{
    		result.innerHTML = `<div>검색결과가 없습니다.</div>`;
    		flightHasMore = false;
    	}
    	
    	
    	let resultSize = searchSize - noMoney;
   		searchCount.innerHTML = `<strong>\${searchData.depAirportNm} (\${searchData.depIata})</strong> → <strong>\${searchData.arrAirportNm} (\${searchData.arrIata})</strong> 검색 결과 <strong>\${resultSize}</strong>개`;
    })
    .catch(error => {
    	console.log("error 발생 : ", error);
  		flightHasMore = false;
    });
}


// 출발지, 도착지 검색
function showSegmentAutocomplete(dropdown, query) {
	
	// 그냥 여기서 indexOf나 valueOf를 가져오는게 나을수도??
	
	axios.get(`/product/flight/search`,{
		params : {
			keyword : query
		}
	})
	.then(res =>{
		const data = res.data;
	    let html = '';
	    
	    if(data && data.length > 0){
	        html += data.map(function(airport) {
	            return createAutocompleteItemHtml(airport, query);
	        }).join('');
	    	
	    }else{
    		html = '<div class="autocomplete-empty"><i class="bi bi-search"></i>"' + query + '"에 대한 검색 결과가 없습니다.</div>';
	    }
	
	    dropdown.innerHTML = html;
	    dropdown.classList.add('active');
	    
	    // 클릭 이벤트 바인딩
	    dropdown.querySelectorAll('.autocomplete-item').forEach(function(item) {
	        item.addEventListener('click', function() {
	        	
	        	selectAirportItem(this, dropdown);
	        });
	    });
	})
	.catch(error => {
		console.log("에러 발생", error);
	});
}

// 출발지 도착지 클릭
function selectAirportItem(item, dropdown) {
    const input = dropdown.previousElementSibling;
    const parent = input.closest('.form-group');
    
    input.value = item.dataset.name;
    
    const idInput = parent.querySelector('input[name*="AirportId"]');	// hidden태그에 값 입력
    const iataInput = parent.querySelector('input[name*="IataCode"]');	// hidden태그에 값 입력
    
    if (idInput) {
    	idInput.value = item.dataset.id;
    }
    if (iataInput) {
    	iataInput.value = item.dataset.code;
    }
    dropdown.classList.remove('active');
}

// 자동완성 아이템 HTML 생성 -> 검색창에 들어갈 데이터 입력
function createAutocompleteItemHtml(location, query) {
    const highlightedName = query ? location.airportNm.replace(new RegExp('(' + query + ')', 'gi'), '<mark>$1</mark>') : location.airportNm;
    // 이전에 선택되었으면 없어짐 if(??) return "";
    
    return '<div class="autocomplete-item" data-name="' + location.airportNm + '" data-code="' + location.iataCode + '" data-id="' + location.airportId + '">' +
           		'<div class="autocomplete-item-icon"><i class="bi-geo-alt"></i></div>' +
          		'<div class="autocomplete-item-info"><div class="autocomplete-item-name">' + highlightedName + '</div>' +
           '<div class="autocomplete-item-sub">' + location.cityName + '</div></div></div>';
}

function renderStoredData(storedData) {
	console.log("storedData : ", storedData);
}

document.addEventListener('DOMContentLoaded', function() {
    // 모든 자동완성 인풋 박스를 찾습니다.
    
	// session에 담아놓을지?
	storedData = sessionStorage.getItem('flightBookingData');
    if(storedData){
    	storedData = JSON.parse(storedData);
    	console.log("저장 데이터 : ", storedData);
    	renderStoredData(storedData);
    }
    
    // 받는 것은 성공. 그런데 어떻게 뿌릴지는 모르겠다
    
    const autoInputs = document.querySelectorAll('.location-autocomplete');

    autoInputs.forEach(input => {
        const dropdown = input.nextElementSibling; // 바로 뒤에 있는 .autocomplete-dropdown

        // 1. 글자를 입력할 때 실행
        input.addEventListener('input', function() {
            const query = this.value.trim();
            showSegmentAutocomplete(dropdown, query);
        });

        // 2. 입력창을 클릭(포커스)했을 때 실행
        input.addEventListener('focus', function() {
            const query = this.value.trim();
            showSegmentAutocomplete(dropdown, query);
        });
    });
	
    // 일반 검색 날짜 선택기 - flatpickr함수. 한번 선택하면 today를 아닌걸로 바꿀까?
    if (typeof flatpickr !== 'undefined') {
        flatpickr('.date-picker', {
            dateFormat: 'Y-m-d',
            minDate: 'today',
            locale: 'ko'
        });
    }
    
});

// async function getMember(){
// 	console.log("user.username : ", "${user.username}");
// 	const userData = await fetch("/product/flight/user", {
// 		method : "post",
// 		headers : {"Content-Type" : "application/json"},
// 		body : JSON.stringify({memId : "${user.username}"})
// 	});
	
// 	console.log("userData : ", userData);
	
// 	const customData = await userData.json();
// 	console.log("customData : ", customData);
// }

// //페이지 로드시 초기화
// document.addEventListener('DOMContentLoaded', function() {
//     initFlightInfiniteScroll();
//     // 항공편 선택 버튼 및 표시 초기화
//     updateFlightButtons();
//     updateSelectionStepIndicator();
// });
</script>

<%-- <c:set var="pageJs" value="product" /> --%>
<%@ include file="../common/footer.jsp"%>
