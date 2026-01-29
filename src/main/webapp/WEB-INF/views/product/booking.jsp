<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="결제하기" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/booking.css">

<div class="booking-page">
    <div class="container">
        <!-- 결제 단계 -->
        <div class="booking-steps">
            <div class="booking-step active">
                <div class="step-icon">1</div>
                <span>결제 정보</span>
            </div>
            <div class="booking-step">
                <div class="step-icon">2</div>
                <span>결제</span>
            </div>
            <div class="booking-step">
                <div class="step-icon">3</div>
                <span>완료</span>
            </div>
        </div>

        <div class="booking-container">
            <!-- 결제 정보 입력 -->
            <div class="booking-main">
                <form id="bookingInfoForm">
                
                	<!-- ========== 장바구니 모드: 결제 상품 목록 ========== -->
                    <c:if test="${type eq 'cart'}">
					    <div class="booking-section" id="cartItemsSection">
					        <div class="d-flex justify-content-between align-items-center mb-3">
					            <h3 class="mb-0"><i class="bi bi-cart-check me-2"></i>결제 상품 (<span id="cartItemCount">0</span>개)</h3>
					            <button type="button" class="btn btn-sm" onclick="fillDemoData()">
					                <i class="bi bi-magic me-1"></i>
					            </button>
					        </div>
					        <div class="cart-booking-items" id="cartBookingItems">
					            <!-- JavaScript로 렌더링 -->
					        </div>
					    </div>
					</c:if>
                    
                    <!-- ========== 단일 상품 모드: 이용일 선택 ========== -->
                    <c:if test="${type ne 'cart'}">
	                    <div class="booking-section">
	                        <h3><i class="bi bi-calendar-event me-2"></i>이용일 선택</h3>
	                        <div class="row">
	                            <div class="col-md-6">
	                                <div class="form-group">
	                                    <label class="form-label">이용 날짜 <span class="text-danger">*</span></label>
	                                    <input type="text" class="form-control booking-date" id="useDate"
	                                           placeholder="날짜를 선택하세요" required>
	                                </div>
	                            </div>
	                            <div class="col-md-6">
	                                <div class="form-group">
	                                    <label class="form-label">희망 시간 <span class="text-danger">*</span></label>
	                                    <select class="form-control form-select" id="useTime" required>
								            <option value="">시간을 선택하세요</option>
								            <c:choose>
								                <c:when test="${not empty availableTimes}">
								                    <c:forEach items="${availableTimes}" var="timeInfo">
								                        <option value="${timeInfo.rsvtAvailableTime}">${timeInfo.rsvtAvailableTime}</option>
								                    </c:forEach>
								                </c:when>
								                <c:otherwise>
								                    <option value="09:00">09:00</option>
								                    <option value="10:00">10:00</option>
								                    <option value="11:00">11:00</option>
								                    <option value="14:00">14:00</option>
								                    <option value="15:00">15:00</option>
								                    <option value="16:00">16:00</option>
								                </c:otherwise>
								            </c:choose>
								        </select>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                    
	                    <!-- 요청사항 -->
	                    <div class="booking-section">
	                        <h3><i class="bi bi-chat-text me-2"></i>요청사항</h3>
	                        <div class="form-group mb-0">
	                            <textarea class="form-control" id="requests" rows="3"
	                                      placeholder="업체에 전달할 요청사항을 입력해주세요. (선택)"></textarea>
	                        </div>
	                    </div>
                    </c:if>

                    <!-- 결제자 정보 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-person me-2"></i>결제자 정보</h3>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">이름 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="bookerName"
                                           value="${member.memName}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">연락처 <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" id="bookerPhone"
                                           value="${memUser.tel}" placeholder="010-0000-0000" required>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-group mb-0">
                                    <label class="form-label">이메일 <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="bookerEmail"
                                           value="${member.memEmail}" required>
                                    <small class="text-muted">결제 확인 메일이 발송됩니다.</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 포인트 사용 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-coin me-2"></i>포인트 사용</h3>
                        <div class="point-use-container">
                            <div class="point-balance">
                                <span class="point-label">보유 포인트</span>
                                <span class="point-value" id="availablePoints">
                                	<fmt:formatNumber value="${member.point}" pattern="#,###"/> P
                                </span>
                            </div>
                            <div class="point-input-group">
                                <div class="input-group">
                                    <input type="number" class="form-control" id="usePointInput"
                                           placeholder="0" min="0" max="${member.point}" value="0">
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

                    <!-- 결제 수단 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-credit-card me-2"></i>결제 수단</h3>
                        <div class="payment-container">
						    <div id="payment-method"></div>
						</div>
                    </div>

                    <!-- 약관 동의 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-check-square me-2"></i>약관 동의</h3>
                        <div class="agreement-list">
                            <label class="agreement-item all">
                                <input type="checkbox" id="agreeAll" onchange="toggleAllAgree()">
                                <span><strong>전체 동의</strong></span>
                            </label>
                            <div class="agreement-divider"></div>
                            <label class="agreement-item">
                                <input type="checkbox" class="agree-item" required>
                                <span>[필수] 이용약관 동의</span>
                                <a href="#" class="agreement-link">보기</a>
                            </label>
                            <label class="agreement-item">
                                <input type="checkbox" class="agree-item" required>
                                <span>[필수] 개인정보 수집 및 이용 동의</span>
                                <a href="#" class="agreement-link">보기</a>
                            </label>
                            <label class="agreement-item">
                                <input type="checkbox" class="agree-item" required>
                                <span>[필수] 취소/환불 규정 동의</span>
                                <a href="#" class="agreement-link">보기</a>
                            </label>
                            <label class="agreement-item">
                                <input type="checkbox" id="agreeMarketing">
                                <span>[선택] 마케팅 정보 수신 동의</span>
                            </label>
                        </div>
                    </div>

                    <button type="submit" id="payment-button" class="btn btn-primary btn-lg w-100 pay-btn">
                        <i class="bi bi-lock me-2"></i><span id="payBtnText">0원 결제하기</span>
                    </button>
                </form>
            </div>

            <!-- 결제 요약 -->
            <aside class="booking-summary">
                <div class="summary-card">
                    <h4>결제 정보</h4>

					<!-- 단일 상품 모드 -->
                    <c:if test="${type ne 'cart'}">
	                    <div class="summary-product-single">
						    <c:choose>
						        <c:when test="${not empty productImages}">
						            <img src="${pageContext.request.contextPath}/upload${productImages[0].filePath}" 
						                 alt="${tp.tripProdTitle}">
						        </c:when>
						        <c:otherwise>
						            <img src="https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=300&fit=crop&q=80"
						                 alt="상품 이미지">
						        </c:otherwise>
						    </c:choose>
						    <div class="summary-product-info">
						        <h5>${tp.tripProdTitle}</h5>
						        <p><i class="bi bi-geo-alt"></i> ${tp.ctyNm}</p>
						    </div>
						</div>
					</c:if>
					
					<!-- 장바구니 모드: 상품 목록 -->
					<c:if test="${type eq 'cart'}">
						<div class="summary-items" id="summaryItems">
	                        <!-- JavaScript로 렌더링 -->
	                    </div>
					</c:if>

                    <div class="summary-details">
                        <!-- 단일 상품 모드 -->
                        <c:if test="${type ne 'cart'}">
	                        <div class="summary-row" id="useDateRow" style="display: none;">
	                            <span class="summary-label">이용일</span>
	                            <span class="summary-value" id="summaryDate">-</span>
	                        </div>
	                        <div class="summary-row" id="useTimeRow" style="display: none;">
	                            <span class="summary-label">이용시간</span>
	                            <span class="summary-value" id="summaryTime">-</span>
	                        </div>
	                        <div class="summary-row">
	                            <span class="summary-label">인원</span>
	                            <span class="summary-value" id="summaryPeople">2명</span>
	                        </div>
	                        <div class="summary-row">
	                            <span class="summary-label">상품 금액</span>
	                            <span class="summary-value" id="summaryProductPrice">68,000원 x 2</span>
	                        </div>
                        </c:if>
                        
                        <!-- 장바구니 모드 -->
                        <c:if test="${type eq 'cart'}">
	                        <div class="summary-row">
	                            <span class="summary-label">상품 금액</span>
	                            <span class="summary-value" id="subtotal">0원</span>
	                        </div>
                        </c:if>
                        
                        <div class="summary-row">
                            <span class="summary-label">할인</span>
                            <span class="summary-value text-danger">-0원</span>
                        </div>
                        <div class="summary-row" id="pointDiscountRow" style="display: none;">
                            <span class="summary-label">포인트 사용</span>
                            <span class="summary-value text-primary" id="summaryPointDiscount">-0원</span>
                        </div>
                        <div class="summary-row total">
                            <span class="summary-label">총 결제금액</span>
                            <span class="summary-value" id="totalAmount">0원</span>
                        </div>
                    </div>

                    <div class="summary-notice">
                        <i class="bi bi-info-circle me-2"></i>
                        <small>결제 확정 후 24시간 내 취소 시 전액 환불됩니다.</small>
                    </div>
                </div>
            </aside>
        </div>
    </div>
</div>

<script>
var CONTEXT_PATH = '${pageContext.request.contextPath}';
var availablePoints = ${member.point}; // 보유 포인트
var appliedPoints = 0; // 적용된 포인트
var totalPrice = 0;
var subtotalPrice = 0;
let widgets = null;
var cartItems = [];

//단일 상품 모드 전용 변수
<c:if test="${type ne 'cart'}">
	var pricePerPerson = ${sale.price};
	var peopleCount = 2;
	var saleEndDt = '<fmt:formatDate value="${tp.saleEndDt}" pattern="yyyy-MM-dd"/>';
</c:if>

//장바구니 모드 전용 변수
<c:if test="${type eq 'cart'}">
    // 상품별 판매종료일
    var saleEndMap = {
        <c:forEach items="${productMap}" var="entry" varStatus="status">
            '${entry.key}': '<fmt:formatDate value="${entry.value.saleEndDt}" pattern="yyyy-MM-dd"/>'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    };
    
    // 상품별 예약 가능 시간
    var timesMap = {
        <c:forEach items="${timesMap}" var="entry" varStatus="status">
            '${entry.key}': [
                <c:forEach items="${entry.value}" var="timeInfo" varStatus="tStatus">
                    '${timeInfo.rsvtAvailableTime}'<c:if test="${!tStatus.last}">,</c:if>
                </c:forEach>
            ]<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    };
</c:if>

// 페이지 로드
document.addEventListener('DOMContentLoaded', async function() {
    <c:if test="${type eq 'cart'}">
	 	// 판매불가 상품 처리 (품절, 판매중지 등)
	    <c:if test="${not empty unavailableProducts}">
	        var unavailableIds = [
	            <c:forEach items="${unavailableProducts}" var="prodId" varStatus="status">
	                '${prodId}'<c:if test="${!status.last}">,</c:if>
	            </c:forEach>
	        ];
	        
	        // sessionStorage에서 해당 상품 제거
	        var savedCart = sessionStorage.getItem('tourCart');
	        if (savedCart) {
	            var cart = JSON.parse(savedCart);
	            cart = cart.filter(function(item) {
	                return !unavailableIds.includes(item.id);
	            });
	            sessionStorage.setItem('tourCart', JSON.stringify(cart));
	        }
	        
	        // tourCartCheckout도 업데이트
	        var checkoutCart = sessionStorage.getItem('tourCartCheckout');
	        if (checkoutCart) {
	            var checkout = JSON.parse(checkoutCart);
	            checkout = checkout.filter(function(item) {
	                return !unavailableIds.includes(item.id);
	            });
	            sessionStorage.setItem('tourCartCheckout', JSON.stringify(checkout));
	        }
	        
	        showToast('품절된 상품이 장바구니에서 제거되었습니다.', 'warning');
	    </c:if>
    
    	loadCartData();
    </c:if>
    
    <c:if test="${type ne 'cart'}">
    	initSingleProductMode();
    </c:if>
    
    await main();
});

//==================== 단일 상품 모드 ====================
<c:if test="${type ne 'cart'}">
	function initSingleProductMode() {
	    // URL 파라미터에서 정보 가져오기
	    var urlParams = new URLSearchParams(window.location.search);
	    var date = urlParams.get('date');
	    var time = urlParams.get('time');
	    var people = urlParams.get('people');
	
	    initDatePicker(date);
	
	    if (date) {
	        document.getElementById('useDateRow').style.display = 'flex';
	        document.getElementById('summaryDate').textContent = date;
	    }
	
	    if (time) {
	        document.getElementById('useTime').value = time;
	        document.getElementById('useTimeRow').style.display = 'flex';
	        document.getElementById('summaryTime').textContent = time;
	    }
	
	    if (people) {
	        peopleCount = parseInt(people);
	        document.getElementById('summaryPeople').textContent = peopleCount + '명';
	    }
	
	    updateTotalPrice();
	}
	
	// 날짜 선택 초기화 (단일 상품)
	function initDatePicker(defaultDate) {
	    var dateInput = document.getElementById('useDate');
	    if (dateInput && typeof flatpickr !== 'undefined') {
	        flatpickr(dateInput, {
	            dateFormat: 'Y-m-d',
	            minDate: 'today',
	            maxDate: saleEndDt,
	            defaultDate: defaultDate || null,
	            locale: 'ko',
	            onChange: function(selectedDates, dateStr) {
	                document.getElementById('useDateRow').style.display = 'flex';
	                document.getElementById('summaryDate').textContent = dateStr;
	            }
	        });
	    }
	
	    // 시간 선택 이벤트
	    document.getElementById('useTime').addEventListener('change', function() {
	        if (this.value) {
	            document.getElementById('useTimeRow').style.display = 'flex';
	            document.getElementById('summaryTime').textContent = this.value;
	        }
	    });
	}
</c:if>

// ==================== 장바구니 모드 ====================
<c:if test="${type eq 'cart'}">
	function loadCartData() {
	    var checkoutData = sessionStorage.getItem('tourCartCheckout');
	
	    if (!checkoutData) {
	        checkoutData = localStorage.getItem('tourCart');
	    }
	
	    try {
	        cartItems = JSON.parse(checkoutData);
	
	        document.getElementById('cartItemCount').textContent = cartItems.length;
	        renderCartBookingItems();
	        renderSummaryItems();
	        updateTotalPrice();
	        
	        // 날짜 선택기 초기화
	        initCartDatePickers();
	    } catch (e) {
	        console.error('장바구니 데이터 파싱 오류:', e);
	    }
	}
	
	function renderCartBookingItems() {
	    var container = document.getElementById('cartBookingItems');
	    var html = '';
	
	    cartItems.forEach(function(item, index) {
	        var itemTotal = item.price * item.quantity;
	        var times = timesMap[item.id];
	        if (!times || times.length === 0) {
	            times = ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'];
	        }
	        
            var timeOptions = '<option value="">시간을 선택하세요</option>';
            times.forEach(function(time) {
                timeOptions += '<option value="' + time + '">' + time + '</option>';
            });
            
	        html += '<div class="cart-booking-item" data-index="' + index + '" data-prod-id="' + item.id + '">' +
	            '<div class="cart-item-header">' +
	                '<div class="cart-item-image">' +
	                    '<img src="' + item.image + '" alt="' + item.name + '">' +
	                '</div>' +
	                '<div class="cart-item-info">' +
	                    '<div class="cart-item-name">' + item.name + '</div>' +
	                    '<div class="cart-item-location"><i class="bi bi-geo-alt"></i>' + (item.location || '위치 정보 없음') + '</div>' +
	                    '<div class="cart-item-price-info">' +
	                        '<span class="cart-item-quantity">' + item.price.toLocaleString() + '원 x ' + item.quantity + '명</span>' +
	                        '<span class="cart-item-price">' + itemTotal.toLocaleString() + '원</span>' +
	                    '</div>' +
	                '</div>' +
	            '</div>' +
	            '<div class="cart-item-booking-info">' +
	                '<div class="form-group">' +
	                    '<label class="form-label">이용 날짜 <span class="text-danger">*</span></label>' +
	                    '<input type="text" class="form-control cart-date-picker" id="cartUseDate_' + index + '" ' +
		                    'data-index="' + index + '" data-prod-id="' + item.id + '" ' +
	                        'placeholder="날짜를 선택하세요" required>' +
	                '</div>' +
	                '<div class="form-group">' +
		                '<label class="form-label">희망 시간 <span class="text-danger">*</span></label>' +
	                    '<select class="form-control form-select" id="cartUseTime_' + index + '" data-index="' + index + '" required>' +
	                        timeOptions +
	                    '</select>' +
	                '</div>' +
	                '<div class="form-group full-width">' +
	                    '<label class="form-label">요청사항</label>' +
	                    '<textarea class="form-control" id="cartRequests_' + index + '" rows="2" ' +
	                              'placeholder="업체에 전달할 요청사항을 입력해주세요. (선택)"></textarea>' +
	                '</div>' +
	            '</div>' +
	        '</div>';
	    });
	
	    container.innerHTML = html;
	}
	
	function renderSummaryItems() {
	    var container = document.getElementById('summaryItems');
	    var html = '';
	
	    cartItems.forEach(function(item) {
	        var itemTotal = item.price * item.quantity;
	        html += '<div class="summary-product">' +
	            '<img src="' + item.image + '" alt="' + item.name + '">' +
	            '<div class="summary-product-info">' +
	                '<h5>' + item.name + '</h5>' +
	                '<p>' + item.quantity + '명 · ' + itemTotal.toLocaleString() + '원</p>' +
	            '</div>' +
	        '</div>';
	    });
	
	    container.innerHTML = html;
	}
	
	function initCartDatePickers() {
	    document.querySelectorAll('.cart-date-picker').forEach(function(input) {
	        if (typeof flatpickr !== 'undefined') {
	        	var prodId = input.dataset.prodId;
                var saleEndDt = saleEndMap[prodId] || null;
	        	
	            flatpickr(input, {
	                dateFormat: 'Y-m-d',
	                minDate: 'today',
                    maxDate: saleEndDt,
	                locale: 'ko'
	            });
	        }
	    });
	}
	
	// ==================== 시연용 자동 입력 ====================
	function fillDemoData() {
	    // 고정 날짜
	    var demoDate = '2026-02-25';
	    
	    // 상품별 시간 선택 인덱스 (1부터 시작 - 0은 "시간을 선택하세요")
	    var timeIndexMap = [1, 3]; // 상품1: 첫 번째(1), 상품2: 세 번째(3)
	    
	    // 요청사항 샘플 메시지
	    var sampleRequests = [
	        '픽업 장소에서 만나요! 감사합니다.',
	        '천천히 진행해주시면 감사하겠습니다.'
	    ];
	    
	    cartItems.forEach(function(item, index) {
	        // 1. 날짜 자동 입력 (2026-02-25 고정)
	        var dateInput = document.getElementById('cartUseDate_' + index);
	        if (dateInput && dateInput._flatpickr) {
	            dateInput._flatpickr.setDate(demoDate);
	        }
	        
	        // 2. 시간 자동 선택
	        var timeSelect = document.getElementById('cartUseTime_' + index);
	        if (timeSelect) {
	            var targetIndex = timeIndexMap[index] || 1;
	            // 옵션이 충분하지 않으면 마지막 옵션 선택
	            if (targetIndex >= timeSelect.options.length) {
	                targetIndex = timeSelect.options.length - 1;
	            }
	            timeSelect.selectedIndex = targetIndex;
	        }
	        
	        // 3. 요청사항 자동 입력
	        var requestsInput = document.getElementById('cartRequests_' + index);
	        if (requestsInput) {
	            requestsInput.value = sampleRequests[index] || '';
	        }
	    });
	}
</c:if>

// 총 금액 업데이트
function updateTotalPrice() {
    <c:if test="${type eq 'cart'}">
        // 장바구니 모드
        subtotalPrice = cartItems.reduce(function(sum, item) {
            return sum + (item.price * item.quantity);
        }, 0);
        
        totalPrice = subtotalPrice - appliedPoints;
        if (totalPrice < 0) totalPrice = 0;

        document.getElementById('subtotal').textContent = subtotalPrice.toLocaleString() + '원';
    </c:if>
    
    <c:if test="${type ne 'cart'}">
        // 단일 상품 모드
        subtotalPrice = pricePerPerson * peopleCount;
        totalPrice = subtotalPrice - appliedPoints;
        if (totalPrice < 0) totalPrice = 0;

        // 상품 금액 업데이트
        document.getElementById('summaryProductPrice').textContent =
            pricePerPerson.toLocaleString() + '원 x ' + peopleCount;
    </c:if>

    document.getElementById('totalAmount').textContent = totalPrice.toLocaleString() + '원';
    document.getElementById('payBtnText').textContent = totalPrice.toLocaleString() + '원 결제하기';
    
    if (widgets) {
        widgets.setAmount({
            currency: "KRW",
            value: totalPrice
        });
    }
}

// ==================== 포인트 관련 함수 ====================

// 전액 사용
function useAllPoints() {
    var maxUsable = Math.min(availablePoints, subtotalPrice);
    document.getElementById('usePointInput').value = maxUsable;
}

// 포인트 적용
function applyPoints() {
    var inputPoints = parseInt(document.getElementById('usePointInput').value) || 0;

    // 유효성 검사
    if (inputPoints < 0) {
        showToast('올바른 포인트를 입력해주세요.', 'error');
        return;
    }

    if (inputPoints > 0 && inputPoints < 1000) {
        showToast('최소 1,000P 이상부터 사용 가능합니다.', 'warning');
        return;
    }

    if (inputPoints > availablePoints) {
        showToast('보유 포인트를 초과할 수 없습니다.', 'error');
        document.getElementById('usePointInput').value = availablePoints;
        return;
    }

    if (inputPoints > subtotalPrice) {
        showToast('결제 금액을 초과할 수 없습니다.', 'warning');
        inputPoints = subtotalPrice;
        document.getElementById('usePointInput').value = inputPoints;
    }

    // 포인트 적용
    appliedPoints = inputPoints;

    if (appliedPoints > 0) {
        // UI 업데이트
        document.getElementById('pointAppliedInfo').style.display = 'flex';
        document.getElementById('appliedPointText').textContent = appliedPoints.toLocaleString() + ' P';
        document.getElementById('pointDiscountRow').style.display = 'flex';
        document.getElementById('summaryPointDiscount').textContent = '-' + appliedPoints.toLocaleString() + '원';

        showToast(appliedPoints.toLocaleString() + 'P가 적용되었습니다.', 'success');
    } else {
        cancelPoints();
    }

    updateTotalPrice();
}

// 포인트 취소
function cancelPoints() {
    appliedPoints = 0;
    document.getElementById('usePointInput').value = 0;
    document.getElementById('pointAppliedInfo').style.display = 'none';
    document.getElementById('pointDiscountRow').style.display = 'none';

    updateTotalPrice();
    showToast('포인트 적용이 취소되었습니다.', 'info');
}

async function main() {
	const button = document.getElementById("payment-button");

  	// ------  결제위젯 초기화 ------
	const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
	const customerKey = "MyKgi0HwDJKFeRDGmc_wM";

	const tossPayments = TossPayments(clientKey);
	widgets = tossPayments.widgets({
	  customerKey,
	});
	
	// ------ 주문의 결제 금액 설정 ------
	await widgets.setAmount({
	  currency: "KRW",
	  value: totalPrice,
	});
	
	console.log("totalPrice : ", totalPrice);
	await Promise.all([
	  // ------  결제 UI 렌더링 ------
	  widgets.renderPaymentMethods({
	    selector: "#payment-method",
	    variantKey: "DEFAULT",
	  })
	]);
	
	// 결제 form
	const bookingForm = document.querySelector("#bookingInfoForm");
	bookingForm.addEventListener("submit", async function(e){
		e.preventDefault();
		
		var timeStamp = new Date().getTime();
	    var tripProdList = [];
	    var orderId = "TOUR-" + ${member.memNo} + "-" + timeStamp;
	    var orderName = "";

	    <c:if test="${type eq 'cart'}">
		    for (var i = 0; i < cartItems.length; i++) {
	            var dateInput = document.getElementById('cartUseDate_' + i);
	            if (!dateInput.value) {
	                dateInput.focus();
	                dateInput._flatpickr.open();
	                return;
	            }
	        }
	    
	    	for (var i = 0; i < cartItems.length; i++) {
	            var item = cartItems[i];
	            tripProdList.push({
	                tripProdNo: item.id,
	                unitPrice: item.price,
	                quantity: item.quantity,
	                discountAmt: 0,
	                payPrice: item.price * item.quantity,
	                resvDt: document.getElementById('cartUseDate_' + i).value,
	                useTime: document.getElementById('cartUseTime_' + i).value,
	                rsvMemo: document.getElementById('cartRequests_' + i).value
	            });
	        }
	        orderName = cartItems.length > 1 
	        ? cartItems[0].name + ' 외 ' + (cartItems.length - 1) + '건'
	        : cartItems[0].name;
        </c:if>
        
        <c:if test="${type ne 'cart'}">
	        tripProdList.push({
	            tripProdNo: ${tp.tripProdNo},
	            unitPrice: pricePerPerson,
	            quantity: peopleCount,
	            discountAmt: 0,
	            payPrice: totalPrice,
	            resvDt: document.getElementById('useDate').value,
	            useTime: document.getElementById('useTime').value,
	            rsvMemo: document.getElementById('requests').value
	        });
    		orderName = "${tp.tripProdTitle}";
    	</c:if>
	    
	    // 투어 결제 데이터
	    const tourPaymentData = {
	        memNo: ${member.memNo},
	        usePoint: appliedPoints,
	        tripProdList: tripProdList,
	        mktAgreeYn: document.getElementById('agreeMarketing').checked ? 'Y' : null
	    };

	    sessionStorage.setItem("tourPaymentData", JSON.stringify(tourPaymentData));
		
		await widgets.requestPayment({
			orderId: orderId,												// 결제번호
			orderName: orderName,
			// paymentKey, paymentType, amount는 기본적으로 포함되어 있음
			successUrl: window.location.origin + "/product/payment/tour",	// 성공 위치 - 리다이렉트로 이동
			failUrl: window.location.origin + "/product/payment/error",		// 실패 위치 - 같은곳으로 보내자
			customerEmail: "${member.memEmail}",							// 결제자 이메일
			customerName: "${member.memName}",								// 결제자 이름
			customerMobilePhone: "${memUser.tel}".replace(/-/g, ''),		// 결제자 전화번호
			// 포인트용 // 다른 정보 담아도 됨. string타입만 담을수 있음
			metadata: {
		        usedPoints: appliedPoints.toString() // 포인트를 여기에 실어 보냅니다.
		    }
		});
	});
}

// 전체 동의 토글
function toggleAllAgree() {
    var allCheckbox = document.getElementById('agreeAll');
    document.querySelectorAll('.agree-item').forEach(function(item) {
        item.checked = allCheckbox.checked;
    });
    document.getElementById('agreeMarketing').checked = allCheckbox.checked;
}

// 개별 약관 체크 시 전체 동의 업데이트
document.querySelectorAll('.agree-item').forEach(function(item) {
    item.addEventListener('change', updateAllAgreeStatus);
});

function updateAllAgreeStatus() {
    var requiredCount = document.querySelectorAll('.agree-item').length;
    var checkedCount = document.querySelectorAll('.agree-item:checked').length;
    var marketingChecked = document.getElementById('agreeMarketing') ?
                           document.getElementById('agreeMarketing').checked : true;

    document.getElementById('agreeAll').checked = (checkedCount === requiredCount && marketingChecked);
}
</script>

<%@ include file="../common/footer.jsp" %>
