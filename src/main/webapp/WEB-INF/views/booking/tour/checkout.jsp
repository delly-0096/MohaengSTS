<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="결제하기" />
<c:set var="pageCss" value="product" />

<%@ include file="../../common/header.jsp" %>

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
                    <!-- 결제 상품 (장바구니에서 온 경우) -->
                    <div class="booking-section" id="cartItemsSection">
                        <h3><i class="bi bi-cart-check me-2"></i>결제 상품</h3>
                        <div class="booking-items" id="bookingItems">
                            <!-- JavaScript로 렌더링 -->
                        </div>
                    </div>

                    <!-- 이용일 선택 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-calendar-event me-2"></i>이용일 선택</h3>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">이용 날짜 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control date-picker" id="useDate"
                                           placeholder="날짜를 선택하세요" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">희망 시간</label>
                                    <select class="form-control form-select" id="useTime">
                                        <option value="">시간 선택 (선택사항)</option>
                                        <option value="09:00">09:00</option>
                                        <option value="10:00">10:00</option>
                                        <option value="11:00">11:00</option>
                                        <option value="13:00">13:00</option>
                                        <option value="14:00">14:00</option>
                                        <option value="15:00">15:00</option>
                                        <option value="16:00">16:00</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 결제자 정보 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-person me-2"></i>결제자 정보</h3>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">이름 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="bookerName"
                                           value="${sessionScope.loginUser.userName}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">연락처 <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" id="bookerPhone"
                                           value="${sessionScope.loginUser.phone}" placeholder="010-0000-0000" required>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-group mb-0">
                                    <label class="form-label">이메일 <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="bookerEmail"
                                           value="${sessionScope.loginUser.email}" required>
                                    <small class="text-muted">결제 확인 메일이 발송됩니다.</small>
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

                    <!-- 결제 수단 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-credit-card me-2"></i>결제 수단</h3>
                        <div class="payment-methods">
                            <label class="payment-method">
                                <input type="radio" name="paymentMethod" value="card" checked>
                                <div class="payment-method-content">
                                    <i class="bi bi-credit-card"></i>
                                    <span>신용/체크카드</span>
                                </div>
                            </label>
                            <label class="payment-method">
                                <input type="radio" name="paymentMethod" value="kakao">
                                <div class="payment-method-content">
                                    <i class="bi bi-chat-fill" style="color: #FEE500;"></i>
                                    <span>카카오페이</span>
                                </div>
                            </label>
                            <label class="payment-method">
                                <input type="radio" name="paymentMethod" value="naver">
                                <div class="payment-method-content">
                                    <i class="bi bi-n-circle" style="color: #03C75A;"></i>
                                    <span>네이버페이</span>
                                </div>
                            </label>
                            <label class="payment-method">
                                <input type="radio" name="paymentMethod" value="bank">
                                <div class="payment-method-content">
                                    <i class="bi bi-bank"></i>
                                    <span>계좌이체</span>
                                </div>
                            </label>
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

                    <button type="submit" class="btn btn-primary btn-lg w-100 pay-btn">
                        <i class="bi bi-lock me-2"></i><span id="payBtnText">0원 결제하기</span>
                    </button>
                </form>
            </div>

            <!-- 결제 요약 -->
            <aside class="booking-summary">
                <div class="summary-card">
                    <h4>결제 정보</h4>

                    <div class="summary-items" id="summaryItems">
                        <!-- JavaScript로 렌더링 -->
                    </div>

                    <div class="summary-details">
                        <div class="summary-row" id="useDateRow" style="display: none;">
                            <span class="summary-label">이용일</span>
                            <span class="summary-value" id="summaryDate">-</span>
                        </div>
                        <div class="summary-row" id="useTimeRow" style="display: none;">
                            <span class="summary-label">이용시간</span>
                            <span class="summary-value" id="summaryTime">-</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">상품 금액</span>
                            <span class="summary-value" id="subtotal">0원</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">할인</span>
                            <span class="summary-value text-danger" id="discount">-0원</span>
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

<!-- 빈 장바구니 안내 모달 -->
<div class="empty-cart-overlay" id="emptyCartOverlay">
    <div class="empty-cart-modal">
        <i class="bi bi-cart-x"></i>
        <h3>장바구니가 비어있습니다</h3>
        <p>결제할 상품을 먼저 장바구니에 담아주세요.</p>
        <a href="${pageContext.request.contextPath}/product/tour" class="btn btn-primary">
            <i class="bi bi-arrow-left me-2"></i>상품 둘러보기
        </a>
    </div>
</div>

<style>
/* 결제 단계 */
.booking-steps {
    display: flex;
    justify-content: center;
    gap: 60px;
    margin-bottom: 40px;
    padding: 20px 0;
}

.booking-step {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    position: relative;
    color: #999;
}

.booking-step:not(:last-child)::after {
    content: '';
    position: absolute;
    top: 18px;
    left: calc(100% + 10px);
    width: 40px;
    height: 2px;
    background: #ddd;
}

.booking-step.active {
    color: var(--primary-color);
}

.booking-step.active .step-icon {
    background: var(--primary-color);
    color: white;
}

.booking-step.completed {
    color: #10b981;
}

.booking-step.completed .step-icon {
    background: #10b981;
    color: white;
}

.step-icon {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: #eee;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    font-size: 14px;
}

.booking-step span {
    font-size: 14px;
    font-weight: 500;
}

/* 레이아웃 */
.booking-container {
    display: grid;
    grid-template-columns: 1fr 380px;
    gap: 32px;
    align-items: start;
}

.booking-section {
    background: white;
    border-radius: 16px;
    padding: 24px;
    margin-bottom: 24px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

.booking-section h3 {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 20px;
    padding-bottom: 12px;
    border-bottom: 1px solid #eee;
    display: flex;
    align-items: center;
}

.booking-section h3 i {
    color: var(--primary-color);
}

/* 결제 상품 아이템 */
.booking-items {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.booking-item {
    display: flex;
    gap: 16px;
    padding: 16px;
    background: #f8fafc;
    border-radius: 12px;
}

.booking-item-image {
    width: 100px;
    height: 75px;
    border-radius: 8px;
    overflow: hidden;
    flex-shrink: 0;
}

.booking-item-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.booking-item-info {
    flex: 1;
}

.booking-item-name {
    font-size: 15px;
    font-weight: 600;
    color: #333;
    margin-bottom: 4px;
}

.booking-item-quantity {
    font-size: 13px;
    color: #666;
    margin-bottom: 8px;
}

.booking-item-price {
    font-size: 16px;
    font-weight: 700;
    color: var(--primary-color);
}

/* 결제 수단 */
.payment-methods {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 12px;
}

.payment-method {
    cursor: pointer;
}

.payment-method input {
    position: absolute;
    opacity: 0;
}

.payment-method-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    padding: 16px 12px;
    border: 2px solid #eee;
    border-radius: 12px;
    transition: all 0.2s ease;
}

.payment-method-content i {
    font-size: 24px;
    color: #666;
}

.payment-method-content span {
    font-size: 12px;
    font-weight: 500;
    color: #666;
}

.payment-method input:checked + .payment-method-content {
    border-color: var(--primary-color);
    background: rgba(74, 144, 217, 0.05);
}

.payment-method input:checked + .payment-method-content i,
.payment-method input:checked + .payment-method-content span {
    color: var(--primary-color);
}

/* 약관 동의 */
.agreement-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.agreement-item {
    display: flex;
    align-items: center;
    gap: 12px;
    cursor: pointer;
    padding: 8px 0;
}

.agreement-item.all {
    padding-bottom: 12px;
}

.agreement-divider {
    height: 1px;
    background: #eee;
    margin-bottom: 4px;
}

.agreement-item input[type="checkbox"] {
    width: 20px;
    height: 20px;
    accent-color: var(--primary-color);
    flex-shrink: 0;
}

.agreement-item span {
    flex: 1;
    font-size: 14px;
}

.agreement-link {
    font-size: 13px;
    color: var(--primary-color);
    text-decoration: underline;
}

/* 결제 버튼 */
.pay-btn {
    padding: 16px;
    font-size: 18px;
    font-weight: 600;
}

/* 결제 요약 사이드바 */
.booking-summary {
    position: sticky;
    top: 100px;
}

.summary-card {
    background: white;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

.summary-card h4 {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 20px;
    padding-bottom: 12px;
    border-bottom: 1px solid #eee;
}

.summary-items {
    max-height: 250px;
    overflow-y: auto;
    margin-bottom: 16px;
}

.summary-product {
    display: flex;
    gap: 12px;
    padding: 12px;
    background: #f8fafc;
    border-radius: 10px;
    margin-bottom: 10px;
}

.summary-product img {
    width: 70px;
    height: 52px;
    object-fit: cover;
    border-radius: 6px;
}

.summary-product-info h5 {
    font-size: 13px;
    font-weight: 600;
    margin-bottom: 2px;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.summary-product-info p {
    font-size: 12px;
    color: #666;
    margin: 0;
}

.summary-details {
    padding-top: 16px;
    border-top: 1px solid #eee;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    padding: 8px 0;
    font-size: 14px;
}

.summary-label {
    color: #666;
}

.summary-value {
    font-weight: 500;
}

.summary-row.total {
    margin-top: 12px;
    padding-top: 12px;
    border-top: 1px solid #eee;
    font-size: 18px;
    font-weight: 700;
}

.summary-row.total .summary-value {
    color: var(--primary-color);
}

.summary-notice {
    margin-top: 16px;
    padding: 12px;
    background: #e0f2fe;
    border-radius: 8px;
    color: #0369a1;
    font-size: 13px;
    display: flex;
    align-items: flex-start;
}

/* 빈 장바구니 모달 */
.empty-cart-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0,0,0,0.5);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 2000;
}

.empty-cart-overlay.active {
    display: flex;
}

.empty-cart-modal {
    background: white;
    border-radius: 20px;
    padding: 48px;
    text-align: center;
    max-width: 400px;
}

.empty-cart-modal i {
    font-size: 64px;
    color: #ccc;
    margin-bottom: 20px;
}

.empty-cart-modal h3 {
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 12px;
}

.empty-cart-modal p {
    color: #666;
    margin-bottom: 24px;
}

/* 반응형 */
@media (max-width: 992px) {
    .booking-container {
        grid-template-columns: 1fr;
    }

    .booking-summary {
        position: static;
        order: -1;
    }

    .payment-methods {
        grid-template-columns: repeat(2, 1fr);
    }

    .booking-steps {
        gap: 30px;
    }

    .booking-step:not(:last-child)::after {
        width: 20px;
        left: calc(100% + 5px);
    }
}

@media (max-width: 576px) {
    .booking-steps {
        gap: 20px;
    }

    .booking-step span {
        font-size: 12px;
    }

    .step-icon {
        width: 32px;
        height: 32px;
        font-size: 13px;
    }

    .booking-section {
        padding: 16px;
    }

    .payment-methods {
        grid-template-columns: 1fr 1fr;
    }
}
</style>

<script>
var cartItems = [];
var totalAmount = 0;
var totalQuantity = 0;

// 페이지 로드
document.addEventListener('DOMContentLoaded', function() {
    loadCheckoutData();
    initDatePicker();
    initPaymentMethods();
});

// 장바구니 데이터 불러오기
function loadCheckoutData() {
    var checkoutData = sessionStorage.getItem('tourCartCheckout');

    if (!checkoutData) {
        checkoutData = localStorage.getItem('tourCart');
    }

    if (!checkoutData) {
        document.getElementById('emptyCartOverlay').classList.add('active');
        return;
    }

    try {
        cartItems = JSON.parse(checkoutData);
        if (cartItems.length === 0) {
            document.getElementById('emptyCartOverlay').classList.add('active');
            return;
        }

        // 총 수량 계산
        totalQuantity = cartItems.reduce(function(sum, item) {
            return sum + item.quantity;
        }, 0);

        renderBookingItems();
        renderSummaryItems();
        updateSummary();
    } catch (e) {
        document.getElementById('emptyCartOverlay').classList.add('active');
    }
}

// 예약 상품 렌더링
function renderBookingItems() {
    var bookingItemsEl = document.getElementById('bookingItems');
    var html = '';

    cartItems.forEach(function(item) {
        var itemTotal = item.price * item.quantity;
        html += '<div class="booking-item">' +
            '<div class="booking-item-image">' +
                '<img src="' + item.image + '" alt="' + item.name + '">' +
            '</div>' +
            '<div class="booking-item-info">' +
                '<div class="booking-item-name">' + item.name + '</div>' +
                '<div class="booking-item-quantity">수량: ' + item.quantity + '개</div>' +
                '<div class="booking-item-price">' + itemTotal.toLocaleString() + '원</div>' +
            '</div>' +
        '</div>';
    });

    bookingItemsEl.innerHTML = html;
}

// 요약 상품 렌더링
function renderSummaryItems() {
    var summaryItemsEl = document.getElementById('summaryItems');
    var html = '';

    cartItems.forEach(function(item) {
        html += '<div class="summary-product">' +
            '<img src="' + item.image + '" alt="' + item.name + '">' +
            '<div class="summary-product-info">' +
                '<h5>' + item.name + '</h5>' +
                '<p>' + item.quantity + '개 · ' + (item.price * item.quantity).toLocaleString() + '원</p>' +
            '</div>' +
        '</div>';
    });

    summaryItemsEl.innerHTML = html;
}

// 요약 정보 업데이트
function updateSummary() {
    totalAmount = cartItems.reduce(function(sum, item) {
        return sum + (item.price * item.quantity);
    }, 0);

    document.getElementById('subtotal').textContent = totalAmount.toLocaleString() + '원';
    document.getElementById('discount').textContent = '-0원';
    document.getElementById('totalAmount').textContent = totalAmount.toLocaleString() + '원';
    document.getElementById('payBtnText').textContent = totalAmount.toLocaleString() + '원 결제하기';
}

// 날짜 선택 초기화
function initDatePicker() {
    var dateInput = document.getElementById('useDate');
    if (dateInput && typeof flatpickr !== 'undefined') {
        flatpickr(dateInput, {
            dateFormat: 'Y-m-d',
            minDate: 'today',
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
        } else {
            document.getElementById('useTimeRow').style.display = 'none';
        }
    });
}

// 결제 수단 초기화
function initPaymentMethods() {
    document.querySelectorAll('.payment-method input').forEach(function(input) {
        input.addEventListener('change', function() {
            // 이미 CSS로 처리됨
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
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.agree-item').forEach(function(item) {
        item.addEventListener('change', updateAllAgreeStatus);
    });
    document.getElementById('agreeMarketing').addEventListener('change', updateAllAgreeStatus);
});

function updateAllAgreeStatus() {
    var requiredCount = document.querySelectorAll('.agree-item').length;
    var checkedCount = document.querySelectorAll('.agree-item:checked').length;
    var marketingChecked = document.getElementById('agreeMarketing').checked;

    document.getElementById('agreeAll').checked = (checkedCount === requiredCount && marketingChecked);
}

// 폼 제출
document.getElementById('bookingInfoForm').addEventListener('submit', function(e) {
    e.preventDefault();

    // 필수 입력값 검증
    var bookerName = document.getElementById('bookerName').value;
    var bookerPhone = document.getElementById('bookerPhone').value;
    var bookerEmail = document.getElementById('bookerEmail').value;
    var useDate = document.getElementById('useDate').value;

    if (!bookerName || !bookerPhone || !bookerEmail) {
        showToast('결제자 정보를 모두 입력해주세요.', 'error');
        return;
    }

    if (!useDate) {
        showToast('이용 날짜를 선택해주세요.', 'error');
        return;
    }

    // 필수 약관 체크 확인
    var requiredAgrees = document.querySelectorAll('.agree-item');
    var allAgreed = true;

    requiredAgrees.forEach(function(agree) {
        if (!agree.checked) {
            allAgreed = false;
        }
    });

    if (!allAgreed) {
        showToast('필수 약관에 동의해주세요.', 'error');
        return;
    }

    // 결제 처리
    showToast('결제를 진행합니다...', 'info');

    // 결제 단계 업데이트
    document.querySelectorAll('.booking-step')[0].classList.remove('active');
    document.querySelectorAll('.booking-step')[0].classList.add('completed');
    document.querySelectorAll('.booking-step')[1].classList.add('active');

    setTimeout(function() {
        // 장바구니 비우기
        localStorage.removeItem('tourCart');
        sessionStorage.removeItem('tourCartCheckout');

        // 결제 완료
        document.querySelectorAll('.booking-step')[1].classList.remove('active');
        document.querySelectorAll('.booking-step')[1].classList.add('completed');
        document.querySelectorAll('.booking-step')[2].classList.add('active');

        showToast('결제가 완료되었습니다!', 'success');

        setTimeout(function() {
            // 결제 완료 페이지로 이동
            window.location.href = '${pageContext.request.contextPath}/product/tour/complete/1';
        }, 500);
    }, 1500);
});
</script>

<%@ include file="../../common/footer.jsp" %>
