<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="결제하기" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>

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
                                    <label class="form-label">희망 시간 <span class="text-danger">*</span></label>
                                    <select class="form-control form-select" id="useTime" required>
                                        <option value="">시간을 선택하세요</option>
                                        <option value="09:00">09:00</option>
                                        <option value="10:00">10:00</option>
                                        <option value="11:00">11:00</option>
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

                    <!-- 포인트 사용 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-coin me-2"></i>포인트 사용</h3>
                        <div class="point-use-container">
                            <div class="point-balance">
                                <span class="point-label">보유 포인트</span>
                                <span class="point-value" id="availablePoints">15,000 P</span>
                            </div>
                            <div class="point-input-group">
                                <div class="input-group">
                                    <input type="number" class="form-control" id="usePointInput"
                                           placeholder="0" min="0" max="15000" value="0">
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
                        <i class="bi bi-lock me-2"></i><span id="payBtnText">136,000원 결제하기</span>
                    </button>
                </form>
            </div>

            <!-- 결제 요약 -->
            <aside class="booking-summary">
                <div class="summary-card">
                    <h4>결제 정보</h4>

                    <div class="summary-product-single">
                        <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=300&h=200&fit=crop&q=80" alt="상품 이미지">
                        <div class="summary-product-info">
                            <h5>제주 스쿠버다이빙 체험 (초보자 가능)</h5>
                            <p><i class="bi bi-geo-alt"></i> 제주 서귀포시 중문</p>
                        </div>
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
                            <span class="summary-label">인원</span>
                            <span class="summary-value" id="summaryPeople">2명</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">상품 금액</span>
                            <span class="summary-value" id="summaryProductPrice">68,000원 x 2</span>
                        </div>
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
                            <span class="summary-value" id="totalAmount">136,000원</span>
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

/* 포인트 사용 */
.point-use-container {
    background: #f8fafc;
    border-radius: 12px;
    padding: 20px;
}

.point-balance {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    padding-bottom: 16px;
    border-bottom: 1px solid #e2e8f0;
}

.point-label {
    font-size: 14px;
    color: #666;
}

.point-value {
    font-size: 20px;
    font-weight: 700;
    color: var(--primary-color);
}

.point-input-group {
    display: flex;
    gap: 12px;
    align-items: center;
    margin-bottom: 12px;
}

.point-input-group .input-group {
    flex: 1;
    max-width: 200px;
}

.point-input-group .input-group input {
    text-align: right;
    font-weight: 600;
}

.point-input-group .input-group-text {
    background: white;
    font-weight: 600;
    color: var(--primary-color);
}

.point-buttons {
    display: flex;
    gap: 8px;
}

.point-info {
    margin-top: 12px;
}

.point-note {
    font-size: 13px;
    color: #666;
    margin: 0;
    display: flex;
    align-items: center;
}

.point-note i {
    color: #999;
}

.point-applied {
    font-size: 14px;
    color: #10b981;
    margin: 8px 0 0;
    display: flex;
    align-items: center;
    gap: 8px;
    font-weight: 500;
}

.point-cancel-btn {
    background: none;
    border: none;
    color: #ef4444;
    font-size: 12px;
    cursor: pointer;
    padding: 2px 8px;
    border-radius: 4px;
    margin-left: 8px;
}

.point-cancel-btn:hover {
    background: #fee2e2;
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

.summary-product-single {
    margin-bottom: 20px;
}

.summary-product-single img {
    width: 100%;
    height: 150px;
    object-fit: cover;
    border-radius: 12px;
    margin-bottom: 12px;
}

.summary-product-single h5 {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 8px;
}

.summary-product-single p {
    font-size: 13px;
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
var pricePerPerson = 68000;
var peopleCount = 2; // URL 파라미터에서 가져올 수 있음
var availablePoints = 15000; // 보유 포인트 (서버에서 가져올 값)
var appliedPoints = 0; // 적용된 포인트

// 페이지 로드
document.addEventListener('DOMContentLoaded', function() {
    // URL 파라미터에서 정보 가져오기
    var urlParams = new URLSearchParams(window.location.search);
    var date = urlParams.get('date');
    var time = urlParams.get('time');
    var people = urlParams.get('people');

    if (date) {
        document.getElementById('useDate').value = date;
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
        updateTotalPrice();
    }

    initDatePicker();
});

// 총 금액 업데이트
function updateTotalPrice() {
    var subtotal = pricePerPerson * peopleCount;
    var total = subtotal - appliedPoints;
    if (total < 0) total = 0;

    document.getElementById('totalAmount').textContent = total.toLocaleString() + '원';
    document.getElementById('payBtnText').textContent = total.toLocaleString() + '원 결제하기';

    // 상품 금액 업데이트
    document.getElementById('summaryProductPrice').textContent =
        pricePerPerson.toLocaleString() + '원 x ' + peopleCount;
}

// ==================== 포인트 관련 함수 ====================

// 전액 사용
function useAllPoints() {
    var subtotal = pricePerPerson * peopleCount;
    var maxUsable = Math.min(availablePoints, subtotal);
    document.getElementById('usePointInput').value = maxUsable;
}

// 포인트 적용
function applyPoints() {
    var inputPoints = parseInt(document.getElementById('usePointInput').value) || 0;
    var subtotal = pricePerPerson * peopleCount;

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

    if (inputPoints > subtotal) {
        showToast('결제 금액을 초과할 수 없습니다.', 'warning');
        inputPoints = subtotal;
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
        }
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

// 폼 제출
document.getElementById('bookingInfoForm').addEventListener('submit', function(e) {
    e.preventDefault();

    // 필수 입력값 검증
    var bookerName = document.getElementById('bookerName').value;
    var bookerPhone = document.getElementById('bookerPhone').value;
    var bookerEmail = document.getElementById('bookerEmail').value;
    var useDate = document.getElementById('useDate').value;
    var useTime = document.getElementById('useTime').value;

    if (!bookerName || !bookerPhone || !bookerEmail) {
        showToast('결제자 정보를 모두 입력해주세요.', 'error');
        return;
    }

    if (!useDate || !useTime) {
        showToast('이용 날짜와 시간을 선택해주세요.', 'error');
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
        // 결제 완료
        document.querySelectorAll('.booking-step')[1].classList.remove('active');
        document.querySelectorAll('.booking-step')[1].classList.add('completed');
        document.querySelectorAll('.booking-step')[2].classList.add('active');

        showToast('결제가 완료되었습니다!', 'success');

        setTimeout(function() {
            window.location.href = '${pageContext.request.contextPath}/product/tour/complete/1';
        }, 500);
    }, 1500);
});
</script>

<%@ include file="../common/footer.jsp" %>
