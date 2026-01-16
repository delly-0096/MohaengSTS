<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
								<span class="input-icon"><i class="bi bi-geo-alt"></i></span> 
								<input type="text" class="form-control airport-autocomplete"
									id="departure" placeholder="도시 또는 공항" autocomplete="off"/>
								<div class="autocomplete-dropdown" id="departureDropdown"></div>
							</div>
							<input type="hidden" name="depAirportId" id="depAirportId"/>
							<input type="hidden" name="depIataCode" id="depIataCode"/> 
						</div>
						
						<div class="form-group">
							<label class="form-label">도착지</label>
							<div class="search-input-group">
								<span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>
								<input type="text" class="form-control airport-autocomplete"
									id="destination" placeholder="도시 또는 공항" autocomplete="off"/>
								<div class="autocomplete-dropdown" id="destinationDropdown"></div>
							</div>
							<input type="hidden" name="arrAirportId" id="arrAirportId" />
							<input type="hidden" name="arrIataCode" id="arrIataCode"/> 
						</div>
						
						<div class="form-group">
							<label class="form-label">가는날</label> <input type="text"
								class="form-control date-picker" id="departDate"
								placeholder="날짜 선택"/>
						</div>
						<div class="form-group" id="returnDateGroup">
							<label class="form-label">오는날</label> <input type="text"
								class="form-control date-picker" id="returnDate"
								placeholder="날짜 선택"/>
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
							value="성인 1명" readonly onclick="togglePassengerPanel()"/>
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
						<label class="form-label">좌석 등급</label> 
						<select class="form-control form-select" id="cabinClass">
							<option value="economy">일반석</option>
							<option value="business">비즈니스석</option>
						</select>
					</div>
				</div>
			</form>
		</div>
		
		<div style="width: 300px;">국토교통부_(TAGO)_국내항공운항정보 api</div>

		<!-- 선택한 항공편 표시 영역 -->
		<div class="selected-flights-container" id="selectedFlightsContainer"
			style="display: none;">
			<div class="selected-flights-header">
				<h5>
					<i class="bi bi-check-circle-fill me-2"></i>선택한 항공편
				</h5>
				<button type="button" class="btn btn-outline-secondary btn-sm"
					onclick="resetFlightSelection()"><!-- 이거 누르면 초기 상태로 돌아가야됨 - 아니면 첫번쨰 검색한결과를 조회해줘야됨 -->
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
				</p>
				<div class="sort-options">
					<button class="sort-btn active" data-sort="price">최저가순</button>
					<button class="sort-btn" data-sort="departure">출발시간순</button>
					<button class="sort-btn" data-sort="duration">최단시간순</button>
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
let passengers = { adult: 1, child: 0, infant: 0 };
let currentSearchType = 'round'; 	// round - 왕복, oneway - 편도
let currentSelectionStep = 0; 		// 현재 선택 단계 (0: 가는편, 1: 오는편)
let selectedFlights = []; 			// 선택된 항공편 목록
let totalSegments = 2; 				// 총 선택해야 할 구간 수 (왕복: 2, 편도: 1)

let storedData = null;				// storage에 저장된 정보
let airportList = [];				// 항공 목록

const list = document.getElementById('selectedFlightsList');
let currentSearchState = null;		// 현재 상태?
let loader = null;		// 인피니티 스크롤
		
// session데이터 가져오기 
function restoreSearchForm() {
//     const saved = sessionStorage.getItem('flightProduct');
//     if (!saved) return;

//     const data = JSON.parse(saved);
//     currentSearchState = data.flights[0]; // 상태 복원

//     console.log("복원 코드 : ", currentSearchState);
//     // UI 필드 복원
//     document.querySelector('#departure').value = currentSearchState.depAirportNm;
//     document.querySelector('#depAirportId').value = currentSearchState.depAirportId;
//     document.querySelector('#depIataCode').value = currentSearchState.depIata;
//     document.querySelector('#destination').value = currentSearchState.arrAirportNm;
//     document.querySelector('#arrAirportId').value = currentSearchState.arrAirportId;
//     document.querySelector('#arrIataCode').value = currentSearchState.arrIata;
//     document.querySelector('#departDate').value = currentSearchState.startDt;
//     document.querySelector('#returnDate').value = data.flights[1].startDt;
    
//     // 선택한 항목 보여줘야됨
//     // update로 그것도 보여줘야됨 (오는 편) 그래야지 가능
    
//     currentSelectionStep = 1;
    
//     // 복원 후 즉시 검색 실행 (선택 사항)
//     searchFlights();
// 아직 좀 조정해야됨

}

// 검색 타입 탭 전환
document.querySelectorAll('.search-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        document.querySelectorAll('.search-tab').forEach(t => t.classList.remove('active'));
        this.classList.add('active');

        const type = this.dataset.type;
        currentSearchType = type;
        // 탭 전환시에는 어떻게 할까??
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
	console.log("isLastStep : ", isLastStep);
    
    buttons.forEach(btn => {
        if (currentSearchType === 'oneway') btn.textContent = '결제하기';
        else btn.textContent = isLastStep ? '결제하기' : '선택';
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

    if (currentSearchType === 'round') stepText.textContent = currentSelectionStep === 0 ? '가는편 선택' : '오는편 선택';
}

// 항공편 선택 처리 - id, data, searchData, startDate, duration, 
function selectFlight(jsonSendData) {
	const flightData = JSON.parse(jsonSendData); 
    console.log("flightData : ", flightData)
    
    selectedFlights[currentSelectionStep] = flightData;
    
    // 편도인 경우 바로 결제 페이지로 이동
    if (currentSearchType === 'oneway' || currentSelectionStep === 1) {
        goToBooking();
        return;
    } else {
	    currentSelectionStep = 1;
	    
	    // ui 업데이트
	    updateSelectedFlightsDisplay();
	    updateSelectionStepIndicator();
	    updateFlightButtons();
	    
	    searchFlights();
		document.getElementById('flightResults').scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
}

// 선택한 항공편 검색 창 밑에 업데이트 
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
    	const label = currentSearchType === 'round' ? (index === 0 ? '가는편' : '오는편') : '편도';
    		
        totalPrice += parseInt(flight.price);
        html += `
        <div class="selected-flight-item">
             <div class="selected-flight-info">
                 <span class="selected-flight-label">\${label}</span>
                 <div class="selected-flight-detail">\${flight.startDate} (\${flight.domesticDays}) 
                     <span class="selected-flight-time">\${flight.depTimeFormmater} → \${flight.arrTimeFormmater}</span>
                     <span class="selected-flight-route">\${flight.depIata} → \${flight.arrIata}</span>
                 </div>
                 <span class="selected-flight-airline">\${flight.airlineNm} (\${flight.flightSymbol})</span>
 				 <i class="bi bi-luggage-fill"></i>
                 <div class="selected-flight-airline">
	 				<span> 무료 위탁 수하물 \${flight.checkedBaggage} kg<span><br/>
					<span> 기내 수하물 \${flight.carryOnBaggage} kg</span>
	 			</div>
             </div>
             <span class="selected-flight-price">\${flight.price.toLocaleString()}원</span>
        </div>`;
    });

    // 모든 구간 선택 완료 시 총 금액 및 결제 버튼 표시
    if (currentSelectionStep >= totalSegments) {
        html += `<div class="selected-flights-total">
            <div>
                <span class="total-price-label">총 금액</span>
                <span class="total-price-value ms-3">\${totalPrice}원</span>
            </div>
            <div class="btn btn-primary btn-lg" onclick="goToBooking()">
                <i class="bi bi-credit-card me-2"></i>결제하기
            </div>
        </div>`;
    }
    list.innerHTML = html;
}

// 1번째 검색한 부분으로 돌아감
function resetFlightSelection() {
    currentSelectionStep = 0;

    document.getElementById('selectedFlightsContainer').style.display = 'none';
    list.innerHTML = '';
    document.querySelector(".flight-result").innerHTML = '';
    
    updateFlightButtons();
    updateSelectionStepIndicator();
    searchFlights();
}

// 결제 페이지로 이동
function goToBooking() {
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
    sessionStorage.setItem('flightProduct', JSON.stringify(bookingData));
    window.location.href = `/product/flight/booking`;
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
    if (dropdown && !dropdown.contains(e.target)) document.getElementById('passengerPanel').classList.remove('active');
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

// ==================== 인피니티 스크롤 ====================
let flightFullData = [];      // API로부터 받은 전체 항공권 데이터 저장소
let flightCurrentPage = 1;    // 현재 페이지
let flightItemsPerPage = 10;  // 한 번에 보여줄 개수
let flightIsLoading = false;  // 로딩 중복 방지 플래그
let flightHasMore = false;    // 더 가져올 데이터가 있는지 여부
let currentSearchData = null; // 검색 조건 저장 (카드 생성용)

// 추가 항공편 데모 데이터 - 인피니티
// var additionalFlights = [
//     {
//         airline: '아시아나',
//         flightNo: 'OZ8905',
//         departureTime: '09:30',
//         departureAirport: 'GMP 김포',
//         arrivalTime: '10:40',
//         arrivalAirport: 'CJU 제주',
//         duration: '1시간 10분',
//         type: '직항',
//         price: 62000,
//         fuel: 28000,
//         tax: 24000,
//     }
// ];

// 인피니티 스크롤 초기화
function initFlightInfiniteScroll() {
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
    loader.style.display = 'flex';

    setTimeout(function() {
        flightCurrentPage++;

        if (flightCurrentPage > flightTotalPages) {
            flightHasMore = false;
            loader.style.display = 'none';
            document.getElementById('flightScrollEnd').style.display = 'block';
            flightIsLoading = false;
            return;
        }

        var resultsList = document.getElementById('flightResults');
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
//     var flights = [];  // flightFullData이거 사용
    for (var i = 0; i < 3; i++) {
//         var dataIndex = ((page - 2) * 3 + i) % 항공리스트.length;
//         flights.push(Object.assign({}, 항공리스트[dataIndex]));
    }
//     return flights;
}

// 조건에 맞는 항공권 카드 생성
function createFlightCard(data, searchData, cabin, id) {
	
	// 버튼 텍스트 결정
    let isLastStep = (currentSelectionStep >= totalSegments - 1);
    let buttonText = (currentSearchType === 'oneway' || isLastStep) ? '결제하기' : '선택';
	
    // 시간
    let startDate = searchData.startDt.substring(0, 4) + "년 " + searchData.startDt.substring(4, 6) + "월 " + searchData.startDt.substring(6, 8) + "일 "; 
	
	// 출발 시간 가져오기
	let timeFormmater = durationFormmater(data.depTime, data.arrTime, "timeFormmater").split("split");
	let depTimeFormmater = timeFormmater[0];
	let arrTimeFormmater = timeFormmater[1];
	
	// 소요시간 가져오기
	let timeSet = durationFormmater(data.depTime, data.arrTime, "duration"); 
	let duration = parseInt(timeSet / 60) + "시간 " + (timeSet % 60) + "분"; 
	
	let price = cabin === "economy" ? data.economyCharge : data.prestigeCharge;
	let pirceFormat = price.toLocaleString(); 
	
	const sendData = {
		...data,
		...searchData,
		id : id,	
		startDate : startDate,
		duration : duration,
		step: currentSelectionStep,		// 숫자 낮은것 부터 insert
	    adult : passengers.adult,		
	    child : passengers.child,
	    infant : passengers.infant,
	    cabinClass : cabin === "economy" ? "일반석" : "비즈니스",
	    price : price,					// 가격 세팅 1개 가격
	    depTimeFormmater : depTimeFormmater,
	    arrTimeFormmater : arrTimeFormmater
	};
	
	const jsonSendData = JSON.stringify(sendData).replace(/"/g, '&quot;');
	
    return `<div class="flight-card" data-flight-id="\${id}">
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
                <div class="price">\${pirceFormat}<span class="price-unit">원</span></div>
                <button type="button" class="btn btn-primary btn-sm flight-action-btn" 
                    onclick="selectFlight('\${jsonSendData}')">
                    \${buttonText}
                </button>
            </div>
        </div>
    </div>`;
}

// 도착지는 출발지와 같을수 없음 필터 - 설정
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

// 검색 폼 제출 (1번만 함)
document.getElementById('flightSearchForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    // 초기화
   	currentSelectionStep = 0;
   	
   	updateFlightButtons();
 	updateSelectionStepIndicator();
   	selectedFlights = [];	// 검색 한번해서 
   	updateSelectedFlightsDisplay();		// 선택된 거 없애줌
    searchFlights();
});

// 항공권 조회
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
	
    const cabin = document.querySelector("#cabinClass").value;	// 좌석 등급
    
    const activeSortBtn = document.querySelector('.sort-btn.active');
    const sorted = activeSortBtn ? activeSortBtn.dataset.sort : 'departure';
    
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
    	arrIata : (currentSelectionStep === 0) ? arrIata : depIata,					// 도착지 3글자 코드
		cabin : cabin		// 중복되지만 일단 넣자
    }
    
    // 왕복/편도 검색
    showToast('항공편을 검색하고 있습니다...', 'info');
    
	// 피젯? 로더?
	
			
    axios.post(`/product/flight/searchFlight`, searchData
    ).then(res => {
    	const flight = res.data;	// 데이터 조회
    	console.log("항공권 조회 : ", flight)
    	let html = '';
    	let validCount = 0;
    	
    	// 금액 sorting
    	if(sorted === "price") flight.sort((a, b) => a.economyCharge - b.economyCharge);
    	
    	// 소요시간 sorting
    	if(sorted === "duration") {
    		flight.sort((a, b) => durationFormmater(a.depTime, a.arrTime, "duration") - durationFormmater(b.depTime, b.arrTime, "duration"));
    	}
    	
    	// 인핀니티 적용
		flightFullData = flight; 
        currentSearchData = searchData;
        flightHasMore = flightFullData.length > flightItemsPerPage;

        
        
    	// api 기본 호출 값은 출발시간 순 
    	if(flight != null && flight.length > 0){
    		flight.forEach((item, i) => {
                // 유효성 검사 (금액이 있고 항공사 이름이 제대로 된 경우만)
                if (item.airlineNm && item.airlineNm !== '/' && timeCheck(item.depTime)) {	// 이거를 먼저 필터링하고 price, duration.. 등을 필터링 하기
					let isPriceValid = false;
					if (cabin === "economy") isPriceValid = item.economyCharge > 0;
	                else isPriceValid = item.prestigeCharge > 0;

	                if (isPriceValid) {
	                    html += createFlightCard(item, searchData, cabin, i);
	                    validCount++;
	                }
                }
            });
    	} 
    	
    	if (validCount > 0) {
            result.innerHTML = html;
            flightHasMore = true;
        } else {
            result.innerHTML = `<div class="no-results-msg">조회된 조건에 맞는 항공편이 없습니다.</div>`;
            flightHasMore = false;
        }
    	
   		searchCount.innerHTML = `<strong>\${searchData.depAirportNm} (\${searchData.depIata})</strong> → <strong>\${searchData.arrAirportNm} (\${searchData.arrIata})</strong> 검색 결과 <strong>\${validCount}</strong>개`;
    })
    .catch(error => {
    	console.log("error 발생 : ", error);
  		flightHasMore = false;
    });
}

// 출발 시간이 이미 지난시간인지 확인
function timeCheck(time){
	const year = parseInt(time.substring(0, 4));
	const month = parseInt(time.substring(4, 6));
	const day = parseInt(time.substring(6, 8));
	const hour = parseInt(time.substring(9, 11));
	const minute = parseInt(time.substring(12, 14));
	
	const targetDate = new Date(year, month - 1, day, hour, minute);
	
	const now = new Date();
	return targetDate > now ? true : false;	// 지난 시간
}

// 소요시간 가져오기
function durationFormmater(depTime, arrTime, indentifer) {
	
	let depTimeSet = depTime.split(" ");	// 날짜 시간 분리
	let arrTimeSet = arrTime.split(" ");
	
	let depAp = depTimeSet[1].split(":");	// 시 분 분리	
	let arrAp = arrTimeSet[1].split(":");
	
	let depTimeFormmater = parseInt(depAp[0]) > 12
			? "오후 " + (parseInt(depAp[0]) - 12) + ":" + depAp[1]
			: "오전 " + depTimeSet[1];
	let arrTimeFormmater = parseInt(arrAp[0]) > 12 
			? "오후 " + (parseInt(arrAp[0]) - 12) + ":" + arrAp[1]
			: "오전 " + arrTimeSet[1];
	
	if(indentifer === "duration") {
		return (parseInt(arrAp[0] * 60) + parseInt(arrAp[1])) - (parseInt(depAp[0] * 60) + parseInt(depAp[1]));
	}

	else return depTimeFormmater + "split" + arrTimeFormmater;	//	split으로 분리	
			
}


// 출발지, 도착지 검색
function showSegmentAutocomplete(dropdown, query) {

	// 중복 방지
	const checkData = (dropdown.id === 'departureDropdown') ? 
	document.querySelector('#destination').value : document.querySelector('#departure').value;
	
	const filteredData = airportList.filter(airport => {
		const isMatch = airport.airportNm.includes(query) || airport.cityName.includes(query) ;
	    const isNotDuplicate = airport.airportNm !== checkData;
	    return isMatch && isNotDuplicate;
	});
	
    let html = '';
    if(filteredData.length > 0){
        html += filteredData.map(function(airport) {
            return createAutocompleteItemHtml(airport, query);
        }).join('');
    } else html = `<div class="autocomplete-empty"><i class="bi bi-search"></i>\${query}에 대한 검색 결과가 없습니다.</div>`;

    dropdown.innerHTML = html;
    dropdown.classList.add('active');
    
    // 클릭 이벤트 바인딩
    dropdown.querySelectorAll('.autocomplete-item').forEach(function(item) {
        item.addEventListener('click', function() {
        	selectAirportItem(this, dropdown);
        });
    });
}

// 출발지 도착지 선택
function selectAirportItem(item, dropdown) {
    const input = dropdown.previousElementSibling;
    const parent = input.closest('.form-group');
    
    input.value = item.dataset.name;
    
    const idInput = parent.querySelector('input[name*="AirportId"]');	// hidden태그에 값 입력
    const iataInput = parent.querySelector('input[name*="IataCode"]');	// hidden태그에 값 입력
    
    if (idInput) idInput.value = item.dataset.id;
    if (iataInput) iataInput.value = item.dataset.code;
    dropdown.classList.remove('active');
}

// 자동완성 아이템 HTML 생성 -> 검색창에 들어갈 데이터 입력
function createAutocompleteItemHtml(location, query) {
    const highlightedName = query ? location.airportNm.replace(new RegExp('(' + query + ')', 'gi'), '<mark>$1</mark>') : location.airportNm;
    
    return `<div class="autocomplete-item" data-name="\${location.airportNm}" data-code="\${location.iataCode}" data-id="\${location.airportId}">
				<div class="autocomplete-item-icon"><i class="bi-geo-alt"></i></div>
		  		<div class="autocomplete-item-info">
			  		<div class="autocomplete-item-name">\${highlightedName}</div>
			    	<div class="autocomplete-item-sub">\${location.cityName}</div>
		    	</div>
	    	</div>`;
}

function renderStoredData(storedData) {
	console.log("storedData : ", storedData);
}

document.addEventListener('DOMContentLoaded', function() {

	airportList = JSON.parse('${airportList}');	// 공항 목록 받은 것
    
    restoreSearchForm();
    
    document.querySelectorAll('.sort-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.sort-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });
    loader = document.querySelector("#flightScrollLoader");	// 인피니티 스크롤 객체
    
    const autoInputs = document.querySelectorAll('.airport-autocomplete');
    
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
    //     initFlightInfiniteScroll();
});

</script>

<%-- <c:set var="pageJs" value="product" /> --%>
<%@ include file="../common/footer.jsp"%>