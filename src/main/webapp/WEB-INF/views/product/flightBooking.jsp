<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="항공권 결제" />
<c:set var="pageCss" value="product" />

<!-- position: absolute -->

<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product-flightBooking.css">

<!-- 회원 이름, 회원 번호, 회원 이메일, 회원 전화번호 가져오기 위해서 -->
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="user" />
</sec:authorize>
<!-- ${user.username} = id -->

<div class="booking-page flight-booking-page">
    <div class="container">
        <!-- 결제 단계 -->
        <div class="booking-steps">
            <div class="booking-step active">
                <div class="step-icon">1</div>
                <span>탑승객 정보</span>
            </div>
            <div class="booking-step">
                <div class="step-icon">2</div>
                <span>결제</span>
            </div>
            <div class="booking-step">
                <div class="step-icon">3</div>
                <span>결제 완료</span>
            </div>
        </div>

        <div class="booking-container">
            <!-- 결제 정보 입력 -->
            <div class="booking-main">
                <form id="flightBookingForm">
                    <!-- 항공편 정보 요약 -->
                    <div class="booking-section flight-info-section">
                        <h3><i class="bi bi-airplane me-2"></i>선택한 항공편 <span class="trip-type-badge" id="tripTypeBadge" style="color: #ffffff;">왕복</span></h3>
                        <!-- 동적 항공편 카드 컨테이너 -->
                        <div id="flightCardsContainer">
                            <!-- JavaScript로 동적 생성 -->
                        </div>
                    </div>

                    <!-- 결제자 정보 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-person me-2"></i>결제자 정보</h3>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">이름 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="bookerName" required disabled>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">연락처 <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" id="bookerPhone" placeholder="010-0000-0000" required disabled/>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-group mb-0">
                                    <label class="form-label">이메일 <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="bookerEmail" required disabled/>
                                    <small class="text-muted">결제 확인 및 탑승권이 발송됩니다.</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 탑승객 정보 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-people me-2"></i>탑승객 정보</h3>

                        <!-- 탑승인원 설정 -->
                        <div class="passenger-count-setting">
                            <div class="passenger-count-row">
                                <div class="passenger-count-info">
                                    <span class="passenger-type-label">성인</span>
                                    <span class="passenger-type-desc">만 12세 이상</span>
                                </div>
                                <div class="passenger-count-control">
                                    <button type="button" class="count-btn minus" onclick="changepassengerType('adult', -1)">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                    <span class="count-value" id="adultCount">1</span>
                                    <button type="button" class="count-btn plus" onclick="changepassengerType('adult', 1)">
                                        <i class="bi bi-plus"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="passenger-count-row">
                                <div class="passenger-count-info">
                                    <span class="passenger-type-label">소아</span>
                                    <span class="passenger-type-desc">만 2세 ~ 11세</span>
                                </div>
                                <div class="passenger-count-control">
                                    <button type="button" class="count-btn minus" onclick="changepassengerType('child', -1)">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                    <span class="count-value" id="childCount">0</span>
                                    <button type="button" class="count-btn plus" onclick="changepassengerType('child', 1)">
                                        <i class="bi bi-plus"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="passenger-count-row">
                                <div class="passenger-count-info">
                                    <span class="passenger-type-label">유아</span>
                                    <span class="passenger-type-desc">만 2세 미만 (좌석 없음)</span>
                                </div>
                                <div class="passenger-count-control">
                                    <button type="button" class="count-btn minus" onclick="changepassengerType('infant', -1)">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                    <span class="count-value" id="infantCount">0</span>
                                    <button type="button" class="count-btn plus" onclick="changepassengerType('infant', 1)">
                                        <i class="bi bi-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="passenger-notice">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>신분증에 기재된 이름과 동일하게 입력해주세요. 이름이 다를 경우 탑승이 거부될 수 있습니다.</span>
                        </div>
                        <div id="passengersContainer">
                            <!-- JavaScript로 동적 생성 -->
                        </div>
                    </div>

                    <!-- 좌석 선택 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-grid-3x3 me-2"></i>좌석 선택 <span class="optional-badge">선택사항</span></h3>
                        <div class="seat-selection-info">
                            <p>좌석 선택은 선택사항입니다. 미선택 시 자동 배정됩니다.</p>
                            <button type="button" class="btn btn-outline" onclick="openSeatSelection()">
                                <i class="bi bi-grid-3x3 me-1"></i>좌석 선택하기
                            </button>
                        </div>
                    </div>

                    <div class="booking-section">
                        <h3><i class="bi bi-coin me-2"></i>포인트 사용</h3>
                        <div class="point-use-container">
                            <div class="point-balance">
                                <span class="point-label">보유 포인트</span>
                                <span class="point-value" id="availablePoints"></span>P
                            </div>
                            <div class="point-input-group">
                                <div class="input-group">
                                    <input type="number" class="form-control" id="usePointInput"
                                           placeholder="0" min="0" max="15000" value="0" disabled><!-- 1000이 넘으면 사용가능하도록 설정 -->
                                    <span class="input-group-text">P</span>
                                </div>
                                <div class="point-buttons">
                                    <button type="button" class="btn btn-outline btn-sm" onclick="useAllPoints()">전액 사용</button>
                                    <button type="button" class="btn btn-primary btn-sm" onclick="applyPoints()">적용</button>
                                </div>
                            </div>
                            <div class="point-info">
                                <p class="point-note"><i class="bi bi-info-circle me-1"></i>최소 1,000P 이상부터 사용 가능합니다.</p>
                                <p class="point-applied" id="pointAppliedInfo" style="display: none;">
                                    <i class="bi bi-check-circle-fill me-1"></i>
                                    <span id="appliedPointText">0 P</span> 적용됨
                                    <button type="button" class="point-cancel-btn" onclick="cancelPoints()">취소</button>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- 결제 수단 (토스페이먼츠)-->
                    <div class="booking-section" style="position: relative;">
                        <h3><i class="bi bi-credit-card me-2"></i>결제 수단</h3>
                        <div class="payment-container">
						    <div id="payment-method"></div>
						</div>
                    </div>

                    <!-- 약관 동의 -->
                    <div class="booking-section">
                        <h3><!-- <i class="bi bi-check-square me-2"></i> -->약관 동의</h3>
                        <div class="agreement-list">
                            <label class="agreement-item all">
                                <input type="checkbox" id="agreeAll" onchange="toggleAllAgree()">
                                <span><strong>전체 동의</strong></span>
                            </label>
                            <div class="agreement-divider">
	                            <label class="agreement-item">
	                                <input type="checkbox" class="agree-item" required>
	                                <span>[필수] 항공권 구매 약관 동의</span>
	                                <a href="#" class="agreement-link">보기</a>
	                            </label><br/>
	                            <label class="agreement-item">
	                                <input type="checkbox" class="agree-item" required>
	                                <span>[필수] 개인정보 수집 및 이용 동의</span>
	                                <a href="#" class="agreement-link">보기</a>
	                            </label><br/>
	                            <label class="agreement-item">
	                                <input type="checkbox" class="agree-item" required>
	                                <span>[필수] 취소/환불 규정 동의</span>
	                                <a href="#" class="agreement-link">보기</a>
	                            </label><br/>
	                            <label class="agreement-item">
	                                <input type="checkbox" id="agreeMarketing">
	                                <span>[선택] 마케팅 정보 수신 동의</span>
	                            </label>
                            </div>
                        </div>
                    </div>

                    <button type="submit" id="payment-button" class="btn btn-primary btn-lg w-100 pay-btn">
    					<i class="bi bi-lock me-2"></i><span id="payBtnText"></span>원 결제하기
					</button>
                </form>
            </div>

            <!-- 결제 요약 사이드바 -->
            <aside class="booking-summary">
                <div class="summary-card">
                    <h4>결제 정보</h4>

                    <div class="summary-flight-info">
                        <div class="summary-trip-type" id="summaryTripType">왕복</div>
                    </div>

                    <!-- 구간별 요금 표시 -->
                    <div class="summary-segments" id="summarySegments">
                        <!-- JavaScript로 동적 생성 -->
                    </div>

                    <div class="summary-details">
                        <div class="summary-row">
                            <span class="summary-label">탑승객</span>
                            <span class="summary-value" id="summaryPassengers">성인 n명</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">좌석 등급</span>
                            <span class="summary-value" id="summaryCabin">좌석</span>
                        </div>
                        <div class="summary-row" id="summarySeatsRow" style="display: none;">
                            <span class="summary-label">선택 좌석</span>
                            <span class="summary-value" id="summarySeats">-</span>
                        </div>
                        <div class="summary-divider"></div>
                        <div class="summary-row">
                            <span class="summary-label">항공 운임 합계</span>
                            <span class="summary-value" id="summaryFare"> 원 x 1</span>
                        </div>
                        <div class="summary-row detail" style="margin-left:15px;">
                            <span class="summary-label">유류할증료</span>
                            <span class="summary-value" id="summaryFuel">12100원으로 갈지??</span>
                        </div>
                        <div class="summary-row detail" style="margin-left:15px;">
                            <span class="summary-label">세금 및 수수료</span>
                            <span class="summary-value" id="summaryTax">4000원 고정</span>
                        </div>
                        <div class="summary-row extra" style="margin-left:15px; display: none;">
                            <span class="summary-label">추가 요금</span>
                            <span class="summary-value" id="summaryExtra"></span>
                        </div>
                        <div class="summary-row total">
                            <span class="summary-label">총 결제금액</span>
                            <span class="summary-value" id="totalAmount"> 원</span>
                        </div>
                    </div>

                    <div class="summary-notice">
                        <i class="bi bi-info-circle me-2"></i>
                        <small>항공권은 출발 24시간 전까지 무료 취소 가능합니다.</small>
                    </div>
                </div>
            </aside>
        </div>
    </div>
</div>

<!-- 좌석 선택 모달 -->
<div class="modal fade" id="seatSelectionModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-grid-3x3 me-2"></i>좌석 선택</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="seat-map-container">
                    <div class="seat-legend">
                        <span class="legend-item"><span class="seat-sample available"></span> 선택 가능</span>
                        <span class="legend-item"><span class="seat-sample selected"></span> 선택됨</span>
                        <span class="legend-item"><span class="seat-sample occupied"></span> 선택 불가</span>
                        <span class="legend-item"><span class="seat-sample extra"></span> 비즈니스 클래스</span>
                        <!-- <span class="legend-item"><span class="seat-sample extra-selected"></span> 추가요금 선택</span> -->
                    </div>
                    <div class="seat-map" id="seatMap">
                        <!-- JavaScript로 좌석 배치 생성 -->
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="confirmSeatBtn" onclick="confirmSeatSelection()">
                    <i class="bi bi-check-lg me-1"></i>선택 완료
                </button>
            </div>
        </div>
    </div>
</div>

<script>
let passengerType = { adult: 1, child: 0, infant: 0 };
let totalPassengerCount = 0;
let basePrice = 0;
let fuelSurcharge = 9900;
let taxAndFees = 4000;
let seatSelectionModal;

let currentSegmentSelection = 0; // 0: 가는편, 1: 오는편
let selectedSeatsBySegment = [[], []]; // 구간별 좌석 저장

// 항공편 예약 데이터
let bookingData = null;
let totalFlightPrice = 0;
let amount = 0;

let widgets = null;

let cabin = null;	// 좌석 등급

let customData = null;	// 사용자 정보
let availablePoints = null; // 포인트

async function main() {
	const button = document.getElementById("payment-button");
//   const coupon = document.getElementById("coupon-box");

  // ------  결제위젯 초기화 ------
	const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
	const customerKey = "MyKgi0HwDJKFeRDGmc_wM";

	const tossPayments = TossPayments(clientKey);
	widgets = tossPayments.widgets({
	  customerKey,
	});
	
	// 비회원 결제 const widgets = tossPayments.widgets({ customerKey: TossPayments.ANONYMOUS });
	
	// ------ 주문의 결제 금액 설정 ------
	await widgets.setAmount({
	  currency: "KRW",
	  value: totalFlightPrice,
	});
	
	console.log("totalFlightPrice : ", totalFlightPrice);
	await Promise.all([
	  // ------  결제 UI 렌더링 ------
	  widgets.renderPaymentMethods({
	    selector: "#payment-method",
	    variantKey: "DEFAULT",
	  }),
	  // ------  이용약관 UI 렌더링 ------
// 	  widgets.renderAgreement({ selector: "#agreement", variantKey: "AGREEMENT" }),
	]);
	
	
	// 사용자 정보 호출
	console.log("user.username : ", "${user.username}");
	const userData = await fetch("/product/flight/user", {
		method : "post",
		headers : {"Content-Type" : "application/json"},
		body : JSON.stringify({memId : "${user.username}"})
	});
	
	console.log("userData : ", userData);
	
	customData = await userData.json();
	console.log("customData : ", customData);		// 이 정보로 입력, session에도 저장?
	
	
	const bookerName = document.querySelector("#bookerName");
	const bookerPhone = document.querySelector("#bookerPhone");
	const bookerEmail = document.querySelector("#bookerEmail");
	const availablePoints = document.querySelector("#availablePoints");
	
	bookerName.value = customData.memName;
	bookerPhone.value = customData.tel.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
	bookerEmail.value = customData.memEmail;
	availablePoints.innerHTML = customData.point;
	
	if(customData.point >= 1000){
		document.querySelector("#usePointInput").disabled = false;
	}
	
	// 결제 form
	const bookingForm = document.querySelector("#flightBookingForm");
	bookingForm.addEventListener("submit", async function(e){
		e.preventDefault();

		// 결제 하기전에 탑승객 데이터좀 넣자
		const passengerInputs = document.querySelectorAll('.passenger-card');
		
// 		selectedSeats // 좌석 정보가 담긴 list
		
	    const passengerData = Array.from(passengerInputs).map(card => {
	        return {
	            type: card.querySelector('.passenger-type-badge').textContent,
	            lastName: card.querySelector('input[name^="lastName"]').value,
	            firstName: card.querySelector('input[name^="firstName"]').value,
	            gender: card.querySelector('select[name^="gender"]').value,
	            birthDate: card.querySelector('input[name^="birthDate"]').value,
	            extraBaggage: card.querySelector('select[name^="extraBaggage"]').value
	            // 좌석 - 
	        };
	    });
	    
		console.log("passengers : ", passengerData);
		sessionStorage.setItem("passengers", JSON.stringify(passengerData));
		
	    // 필수 약관 체크 확인 - 이것도 테이블에 담기
	    let allAgreed = true;
	    document.querySelectorAll('.agree-item').forEach(function(agree) {
	        if (!agree.checked) allAgreed = false;
	    });

	    if (!allAgreed) {
	        showToast('필수 약관에 동의해주세요.', 'error');
	        return;
	    }
		
		// "flt" + bookingData.flights[0].startDt + "11"
		console.log("bookingData : ", bookingData.flights[0].startDate )
		await widgets.requestPayment({
			orderId: "test" + bookingData.flights[0].startDt + "1",			// 결제번호 - 일단 임의
			orderName: "1",													// 상품명
			// paymentKey, paymentType, amount는 기본적으로 포함되어 있음
			successUrl: window.location.origin + "/product/payment/flight",	// 성공 위치 - 리다이렉트로 이동
			failUrl: window.location.origin + "/product/payment/error",		// 실패 위치 - 같은곳으로 보내자
			customerEmail: customData.memEmail,								// 결제자 이메일
			customerName: customData.memName,								// 결제자 이름
			customerMobilePhone: customData.tel,							// 결제자 전화번호
		});
		
	});
}

document.addEventListener('DOMContentLoaded', async function() {
	const storedData = sessionStorage.getItem('flightProduct');
	amount = document.querySelector("#payBtnText");
	cabin = document.querySelector("#summaryCabin");
	
	if (storedData) {
	    bookingData = JSON.parse(storedData);
	    cabin.innerHTML = bookingData.flights[0].cabinClass;
	    initFlightDisplay();
	}
	
	// 탑승객 정보 초기 세팅
	passengerType.adult = bookingData.flights[0].adult;
    passengerType.child = bookingData.flights[0].child;
    passengerType.infant = bookingData.flights[0].infant;
	
    initPassengers();		// 탑승객 정보 초기화
    updateCountButtons();	// 탑승인원 버튼 상태 초기화
    seatSelectionModal = new bootstrap.Modal(document.getElementById('seatSelectionModal'));	// 좌석 선택 모달 초기화
    initSeatMap();
    calculateTotal();
    
    await main();
});

// 항공편 표시 초기화
function initFlightDisplay() {
    if (!bookingData) return;

    // 여행 유형 배지 업데이트
    var tripTypeBadge = document.getElementById('tripTypeBadge');
    var summaryTripType = document.getElementById('summaryTripType');
    var tripTypeText = bookingData.tripType === 'round' ? '왕복' : '편도';
    
    tripTypeBadge.textContent = tripTypeText;
    summaryTripType.textContent = tripTypeText;

    // 항공편 카드 생성
    var cardsContainer = document.getElementById('flightCardsContainer');
    var segmentsContainer = document.getElementById('summarySegments');
    var cardsHtml = '';
    var segmentsHtml = '';
    totalFlightPrice = 0;

    bookingData.flights.forEach(function(flight, index) {
        totalFlightPrice += parseInt(flight.price);

        // 라벨 클래스 결정
        var labelClass = '';
        if (bookingData.tripType === 'round') {
            labelClass = index === 0 ? '' : 'return';
        } else {
            labelClass = 'segment';
        }

        // 항공편 카드 HTML
        cardsHtml += createFlightCardHtml(flight, labelClass);

        // 사이드바 구간 HTML
        segmentsHtml += createSummarySegmentHtml(flight, labelClass);
    });

    cardsContainer.innerHTML = cardsHtml;
    segmentsContainer.innerHTML = segmentsHtml;

    // 기본 가격 업데이트
    basePrice = totalFlightPrice;
}

// 항공편 카드 HTML 생성
function createFlightCardHtml(flight, labelClass) {
    return '<div class="flight-summary-card">' +
        '<div class="flight-summary-label ' + labelClass + '">' + flight.segmentLabel + '</div>' +
        '<div class="flight-summary-content">' + flight.startDate + '(' + flight.domesticDays + ')' +
            '<div class="flight-summary-route">' +
                '<div class="flight-summary-point">' +
                    '<span class="time">' + flight.depTimeFormmater + '</span>' +
                    '<span class="airport">' + flight.depAirportNm + ' (' + flight.depIata + ')</span>' +
                '</div>' +
                '<div class="flight-summary-arrow">' +
                    '<span class="duration">' + flight.duration + '</span>' +
                    '<div class="arrow-line"><i class="bi bi-airplane"></i></div>' +
                '</div>' +
                '<div class="flight-summary-point">' +
                    '<span class="time">' + flight.arrTimeFormmater + '</span>' +
                    '<span class="airport">' + flight.arrAirportNm + ' (' + flight.arrIata + ')</span>' +
                '</div>' +
            '</div>' +
            '<div class="flight-summary-details">' +
                '<span class="flight-airline">' + flight.airlineNm + '</span>' +
                '<span class="flight-price">' + (flight.price).toLocaleString() + '원</span>' +
            '</div>' +
        '</div>' +
    '</div>';
}

// 사이드바 구간 HTML 생성
function createSummarySegmentHtml(flight, labelClass) {
	// 가격은 클래스에 따라서 바꿈
    return '<div class="summary-segment-item">' +
        '<div class="summary-segment-label">' +
            '<span class="summary-segment-badge ' + labelClass + '">' + flight.segmentLabel + '</span>' +
            '<span class="summary-segment-route">' + flight.depIata + ' → ' + flight.arrIata + '</span>' +
        '</div>' +
        '<span class="summary-segment-price">' + (flight.price).toLocaleString() + '원</span>' +
    '</div>';
}

// 탑승객 정보 초기화 - 탑승객 줄거나 늘어날 때는 기존거 남기고 했으면 좋겠다. 예약자랑 탑승객이랑 정보 같을수도 있잖슴
function initPassengers() {
    var container = document.getElementById('passengersContainer');
    totalPassengerCount = passengerType.adult + passengerType.child + passengerType.infant;
    container.innerHTML = '';
    
    // adultCount
    
	// bookingData.flights[1].adult // 가져오면 적용됨
	
	for(let i = 1; i <= totalPassengerCount; i++){
		console.log("수정");
	}
	
    // 성인 탑승객
    for (var i = 1; i <= passengerType.adult; i++) {
        addPassengerCard(container, 'adult', i);
    }

    // 소아 탑승객
    for (var j = 1; j <= passengerType.child; j++) {
        addPassengerCard(container, 'child', j);
    }

    // 유아 탑승객
    for (var k = 1; k <= passengerType.infant; k++) {
        addPassengerCard(container, 'infant', k);
    }
}

// 탑승객 카드 추가 - 탑승객 정보도 담아야될지??
function addPassengerCard(container, type, num) {
    var typeLabels = { adult: '성인', child: '소아', infant: '유아' };
    var typeLabel = typeLabels[type];

    var div = document.createElement('div');
    div.className = 'passenger-card';
    // type num은 빼기
    div.innerHTML =
	        `<div class="passenger-card-header">
	            <h6><i class="bi bi-person-fill me-2"></i>탑승객 \${num}</div><span class="passenger-type-badge" style="color: #ffffff;">\${typeLabel}</span></h6>
	        </div>
	        <input type="hidden" name="passengerId" value="\${num}"/>
	        <input type="hidden" name="passengersType" value="\${typeLabel}"/>
	        <div class="row">
	            <div class="col-md-4">
	                <div class="form-group">
	                    <label class="form-label">성 <span class="text-danger">*</span></label>
	                    <input type="text" class="form-control" name="lastName" placeholder="홍" required>
	                </div>
	            </div>
	            <div class="col-md-4">
	                <div class="form-group">
	                    <label class="form-label">이름 <span class="text-danger">*</span></label>
	                    <input type="text" class="form-control" name="firstName" placeholder="길동" required>
	                </div>
	            </div>
	            <div class="col-md-4">
	                <div class="form-group">
	                    <label class="form-label">성별 <span class="text-danger">*</span></label>
	                    <select class="form-control form-select" name="gender" required>
	                        <option value="">선택</option>
	                        <option value="M">남성</option>
	                        <option value="F">여성</option>
	                    </select>
	                </div>
	            </div>
	            <div class="col-md-4">
	                <div class="form-group mb-0">
	                    <label class="form-label">생년월일 <span class="text-danger">*</span></label>
	                    <input type="date" class="form-control" name="birthDate" required>
	                </div>
	            </div>
	            <div class="col-md-4">
	            <div class="form-group mb-0">
	                <label class="form-label">추가 수하물 <span class="text-danger">*</span></label>
	                <select class="form-control form-select" name="extraBaggage" onchange="calculateTotal()" required>
		                <option value="0">추가없음</option>
		                <option value="5">5kg (10,000원)</option>
		                <option value="10">10kg (20,000원)</option>
		            </select>
	            </div>
	        </div>
        </div>`;
        // calculateTotal 말고 다른거 실행 -> calculateTotal 전달하기 
    container.appendChild(div);
}


// 탑승인원 변경
function changepassengerType(type, delta) {
    var newCount = passengerType[type] + delta;
    var totalPassengers = passengerType.adult + passengerType.child + passengerType.infant;

    // 유효성 검사
    if (type === 'adult') {
        if (newCount < 1) {
            showToast('성인은 최소 1명 이상이어야 합니다.', 'warning');
            return;
        }
        if (newCount > 9) {
            showToast('성인은 최대 9명까지 가능합니다.', 'warning');
            return;
        }
        // 유아는 성인 수보다 많을 수 없음
        if (newCount < passengerType.infant) {
            showToast('유아 수가 성인 수보다 많을 수 없습니다.', 'warning');
            return;
        }
    } else if (type === 'child') {
        if (newCount < 0) return;
        if (newCount > 9) {
            showToast('소아는 최대 9명까지 가능합니다.', 'warning');
            return;
        }
    } else if (type === 'infant') {
        if (newCount < 0) return;
        if (newCount > passengerType.adult) {
            showToast('유아는 성인 수를 초과할 수 없습니다.', 'warning');
            return;
        }
    }

    // 총 인원 제한
    var newTotal = totalPassengers + delta;
    if (newTotal > 9) {
        showToast('총 탑승객은 9명을 초과할 수 없습니다.', 'warning');
        return;
    }

    // 인원 변경
    passengerType[type] = newCount;

    // UI 업데이트
    document.getElementById(type + 'Count').textContent = newCount;
    updateCountButtons();

    // 탑승객 카드 재생성
    initPassengers();	// 초기화 x

    // 좌석 선택 초기화 (인원 변경 시)
    if (selectedSeatsBySegment.length > 0) {
    	selectedSeatsBySegment = [[], []];
        document.getElementById('summarySeatsRow').style.display = 'none';
        document.querySelector('.seat-selection-info').innerHTML =
            `<p>좌석 선택은 선택사항입니다. 미선택 시 자동 배정됩니다.</p>
            <button type="button" class="btn btn-outline" onclick="openSeatSelection()">
                <i class="bi bi-grid-3x3 me-1"></i>좌석 선택하기
            </button>`;
        initSeatMap();
    }

    // 총 금액 재계산
    calculateTotal();
}

// 버튼 상태 업데이트
function updateCountButtons() {
    // 성인 마이너스 버튼
    var adultMinus = document.querySelector('.passenger-count-row:nth-child(1) .count-btn.minus');
    adultMinus.disabled = passengerType.adult <= 1;

    // 소아 마이너스 버튼
    var childMinus = document.querySelector('.passenger-count-row:nth-child(2) .count-btn.minus');
    childMinus.disabled = passengerType.child <= 0;

    // 유아 마이너스 버튼
    var infantMinus = document.querySelector('.passenger-count-row:nth-child(3) .count-btn.minus');
    infantMinus.disabled = passengerType.infant <= 0;

    // 총 인원 9명 제한
    var totalPassengers = passengerType.adult + passengerType.child + passengerType.infant;
    var plusButtons = document.querySelectorAll('.count-btn.plus');
    plusButtons.forEach(function(btn) {
        btn.disabled = totalPassengers >= 9;
    });

    // 유아 플러스 버튼 (성인 수 제한)
    var infantPlus = document.querySelector('.passenger-count-row:nth-child(3) .count-btn.plus');
    if (passengerType.infant >= passengerType.adult) {
        infantPlus.disabled = true;
    }
}

// 총 금액 계산 - 짐 까지 정해야됨
function calculateTotal() {
	// 이거 고쳐야됨
	
	let adultCount = document.querySelector("#adultCount");
	let childCount = document.querySelector("#childCount");
	let infantCount = document.querySelector("#infantCount");
		
	adultCount.innerHTML = passengerType.adult;
	childCount.innerHTML = passengerType.child;
	infantCount.innerHTML = passengerType.infant;
	
	const totalPeople = passengerType.adult + passengerType.child;
    // const infantCount = passengerType.infant;
//     var totalPassengers = passengerType.adult + passengerType.child;
    segmentCount = bookingData ? bookingData.flights.length : 1;

    // Math.floor(basePrice * 0.75); = 아이 요금 적용하기
    
    
   	// 2. 수하물 추가 요금 합산 (DOM에서 현재 선택된 값들 수집)
   	let extraFeeView = document.querySelector(".summary-row.extra");
    let summaryExtra = document.querySelector("#summaryExtra");
    let extraBaggageFee = 0;
    document.querySelectorAll('select[name="extraBaggage"]').forEach(select => {
        const weight = parseInt(select.value);
        if (weight === 5) {
        	extraBaggageFee += 10000;
        }
        else if (weight === 10){
        	extraBaggageFee += 20000;
        }
    });
    if(extraBaggageFee !== 0) extraFeeView.style.display = 'flex';
    summaryExtra.innerHTML = extraBaggageFee;
    
						// 처음에 받은 토탈
    totalFlightPrice = (basePrice + extraBaggageFee) * passengerType.adult;	
    // basePrice

    // 요금 표시 업데이트
    document.getElementById('summaryFare').textContent = (basePrice).toLocaleString() + '원 x ' + totalPeople + '명';
    document.getElementById('summaryFuel').textContent = (fuelSurcharge * segmentCount).toLocaleString() + '원 x ' + totalPeople + '명';
    document.getElementById('summaryTax').textContent = (taxAndFees * segmentCount).toLocaleString() + '원 x ' + totalPeople + '명';
    
    document.getElementById('totalAmount').textContent = (totalFlightPrice).toLocaleString()  + '원';			// 원래는 총 인원수 맞춰서 계산해야됨
    document.getElementById('payBtnText').textContent = (totalFlightPrice).toLocaleString();

    
    if (widgets) {
        widgets.setAmount({
            currency: "KRW",
            value: totalFlightPrice,
        }).then(() => {
            console.log("위젯 금액 업데이트 완료: ", totalFlightPrice);
        }).catch(err => {
            console.error("위젯 금액 업데이트 실패: ", err);
        });
    }
     
    // 탑승객 정보 업데이트 - 이것 또한
    var passengerText = [];
    if (passengerType.adult > 0) passengerText.push('성인 ' + passengerType.adult + '명');
    if (passengerType.child > 0) passengerText.push('소아 ' + passengerType.child + '명');
    if (passengerType.infant > 0) passengerText.push('유아 ' + passengerType.infant + '명');
    document.getElementById('summaryPassengers').textContent = passengerText.join(', ');
}

// 좌석 선택 모달 열기
function openSeatSelection() {
	currentSegmentSelection = 0; // 시작은 무조건 가는편
    updateSeatModalTitle();
    initSeatMap();
    seatSelectionModal.show();
}

function updateSeatModalTitle() {
    const title = currentSegmentSelection === 0 ? "가는 편 좌석 선택" : "오는 편 좌석 선택";
    document.querySelector('#seatSelectionModal .modal-title').textContent = title;
    
    const btn = document.querySelector('#confirmSeatBtn'); // 모달의 확인버튼
    if (bookingData.tripType === 'round' && currentSegmentSelection === 0) {
        btn.textContent = "다음 여정 선택";
        btn.onclick = () => {
            currentSegmentSelection = 1;
            updateSeatModalTitle();
            initSeatMap();
        };
    } else {
        btn.textContent = "선택 완료";
        btn.onclick = confirmSeatSelection; // 최종 저장
    }
}

// 좌석 배치 초기화 -- 2번 할 수 있도록 수정해야됨 / 좌석 등급 따른 보여줄 화면 조정
function initSeatMap() {
    var seatMap = document.getElementById('seatMap');
    var columns = ['A', 'B', 'C', '', 'D', 'E', 'F'];
    var rows = 20;
    var html = ``;

    // 열 헤더
    html += `<div class="seat-row">`;
    html += `<div class="seat-row-number"></div>`;
    columns.forEach(function(col) {
        if (col === '') {
            html += `<div class="seat-aisle"></div>`;
        } else {
            html += `<div class="seat" style="background: none; cursor: default; color: var(--gray-medium);">\${col}</div>`;
        }
    });
    html += `</div>`;

    // 좌석 행 -- 여기서 좌석 조정해야됨 
    // 안되는 좌석 불러오기 db 
    // cabinCalss 등급따라서 앞좌석 선택 못하도록 막기
    for (var i = 1; i <= rows; i++) {
        html += `<div class="seat-row">`;
        html += `<div class="seat-row-number">\${i}</div>`;

        columns.forEach(function(col) {
            if (col === '') {	// 통로
                html += `<div class="seat-aisle"></div>`;
            } else {
                var seatId = i + col;	// a1 같이
                var occupied = Math.random() < 0.3;
                var extra = i <= 3;		// business
                var seatClass = occupied ? 'occupied' : (extra ? 'extra available' : 'available');

                html += '<button type="button" class="seat ' + seatClass + '" data-seat="' + seatId + '" ' +
                        (occupied ? 'disabled' : 'onclick="toggleSeat(this)"') + '>' +
                        (occupied ? '' : seatId) + '</button>';
            }
        });

        html += `</div>`;
    }
    seatMap.innerHTML = html;
}

// 좌석 토글
function toggleSeat(btn) {
    let seatId = btn.dataset.seat;
    let currentSeats = selectedSeatsBySegment[currentSegmentSelection];
    
    if (btn.classList.contains('selected')) {
        btn.classList.remove('selected');
        btn.classList.add('available');
        selectedSeatsBySegment[currentSegmentSelection] = currentSeats.filter(s => s !== seatId);
    } else {
        if (currentSeats.length >= (passengerType.adult + passengerType.child)) {
            showToast('탑승객 수만큼만 좌석을 선택할 수 있습니다.', 'warning');
            return;
        }
        btn.classList.remove('available');
        btn.classList.add('selected');
        selectedSeatsBySegment[currentSegmentSelection].push(seatId);
    }
}

// 좌석 선택 - 왕복에서는 선택버튼 누르면 오는편 좌석 정하게 하기
function confirmSeatSelection() {
    // 결제 요약에 좌석 정보 반영
    
    var seatsRow = document.getElementById('summarySeatsRow');
//     var seatFeeRow = document.getElementById('summarySeatFeeRow');
    var summarySeats = document.getElementById('summarySeats');
    var summarySeatFee = document.getElementById('summarySeatFee');
    var seatSelectionInfo = document.querySelector('.seat-selection-info');

    if (selectedSeats.length === 0) {
        seatsRow.style.display = 'none';
//         seatFeeRow.style.display = 'none';
        seatSelectionInfo.innerHTML =
            `<p>좌석 선택은 선택사항입니다. 미선택 시 자동 배정됩니다.</p>
            <button type="button" class="btn btn-outline" onclick="openSeatSelection()">
                <i class="bi bi-grid-3x3 me-1"></i>좌석 선택하기
            </button>`;
    } else {
        // 추가요금 좌석 개수 계산 (1~3열)
//         var extraSeatCount = 0;
//         selectedSeats.forEach(function(seat) {
//             var rowNum = parseInt(seat);
//             if (rowNum <= 3) extraSeatCount++;
//         });

        // 좌석 정보 표시
        seatsRow.style.display = 'flex';
        summarySeats.textContent = selectedSeats.join(', ');

        // 좌석 선택 영역 업데이트 - 가는 편, 오는 편 두개가 있어야 됨. 1명이면 1개만 선택되도록, 이전 좌석은 사라지도록 설정하기
		seatSelectionInfo.innerHTML = `
            <div class="selected-seats-display">
                <div class="selected-seats-info">
                    <i class="bi bi-check-circle-fill text-success me-2"></i>
                    <span>선택된 좌석 : <strong>\${selectedSeats.join(', ')}</strong></span>
                </div>
                <button type="button" class="btn btn-outline btn-sm" onclick="openSeatSelection()">
                    <i class="bi bi-pencil me-1"></i>변경
                </button>
            </div>`;
        showToast('좌석 ' + selectedSeats.join(', ') + '이(가) 선택되었습니다.', 'success');
    }

    // 총 금액 재계산
    calculateTotal();
    
    // modal close, 왕복일때는 한번더 열기
    seatSelectionModal.hide();
}

// 전체 동의
function toggleAllAgree() {
    var allCheckbox = document.getElementById('agreeAll');
    document.querySelectorAll('.agree-item').forEach(function(item) {
        item.checked = allCheckbox.checked;
    });
    document.getElementById('agreeMarketing').checked = allCheckbox.checked;
}

// 개별 약관 체크 시 전체 동의 업데이트 - 마케팅 정보 선택안되면 전체 동의 체크박스 해제하기
document.querySelectorAll('.agree-item').forEach(function(item) {
    item.addEventListener('change', function() {
        var requiredCount = document.querySelectorAll('.agree-item').length;
        var checkedCount = document.querySelectorAll('.agree-item:checked').length;
        var marketingChecked = document.getElementById('agreeMarketing').checked;
        document.getElementById('agreeAll').checked = (checkedCount === requiredCount && marketingChecked);
    });
});
</script>

<%-- <c:set var="pageJs" value="product" /> --%>
<%@ include file="../common/footer.jsp" %>