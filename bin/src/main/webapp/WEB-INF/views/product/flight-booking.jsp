<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="항공권 결제" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>

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
                        <h3><i class="bi bi-airplane me-2"></i>선택한 항공편 <span class="trip-type-badge" id="tripTypeBadge">왕복</span></h3>

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
                                    <button type="button" class="count-btn minus" onclick="changePassengerCount('adult', -1)">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                    <span class="count-value" id="adultCount">1</span>
                                    <button type="button" class="count-btn plus" onclick="changePassengerCount('adult', 1)">
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
                                    <button type="button" class="count-btn minus" onclick="changePassengerCount('child', -1)">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                    <span class="count-value" id="childCount">0</span>
                                    <button type="button" class="count-btn plus" onclick="changePassengerCount('child', 1)">
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
                                    <button type="button" class="count-btn minus" onclick="changePassengerCount('infant', -1)">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                    <span class="count-value" id="infantCount">0</span>
                                    <button type="button" class="count-btn plus" onclick="changePassengerCount('infant', 1)">
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
                                <span>[필수] 항공권 구매 약관 동의</span>
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
                        <i class="bi bi-lock me-2"></i><span id="payBtnText">104,000원 결제하기</span>
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
                            <span class="summary-value" id="summaryPassengers">성인 1명</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">좌석 등급</span>
                            <span class="summary-value" id="summaryCabin">일반석</span>
                        </div>
                        <div class="summary-row" id="summarySeatsRow" style="display: none;">
                            <span class="summary-label">선택 좌석</span>
                            <span class="summary-value" id="summarySeats">-</span>
                        </div>
                        <div class="summary-row" id="summarySeatFeeRow" style="display: none;">
                            <span class="summary-label">좌석 추가요금</span>
                            <span class="summary-value" id="summarySeatFee">0원</span>
                        </div>
                        <div class="summary-divider"></div>
                        <div class="summary-row">
                            <span class="summary-label">항공 운임 합계</span>
                            <span class="summary-value" id="summaryFare">52,000원 x 1</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">유류할증료</span>
                            <span class="summary-value" id="summaryFuel">28,000원</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">세금 및 수수료</span>
                            <span class="summary-value" id="summaryTax">24,000원</span>
                        </div>
                        <div class="summary-row total">
                            <span class="summary-label">총 결제금액</span>
                            <span class="summary-value" id="totalAmount">104,000원</span>
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
                        <span class="legend-item"><span class="seat-sample extra"></span> 추가요금</span>
                        <span class="legend-item"><span class="seat-sample extra-selected"></span> 추가요금 선택</span>
                    </div>
                    <div class="seat-map" id="seatMap">
                        <!-- JavaScript로 좌석 배치 생성 -->
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="confirmSeatSelection()">
                    <i class="bi bi-check-lg me-1"></i>선택 완료
                </button>
            </div>
        </div>
    </div>
</div>

<style>
/* 항공편 요약 카드 */
.flight-info-section {
    background: linear-gradient(135deg, #f0f7ff 0%, #e8f4fd 100%);
}

.flight-summary-card {
    background: white;
    border-radius: 12px;
    padding: 20px;
    margin-bottom: 16px;
    border: 1px solid #e2e8f0;
}

.flight-summary-card:last-child {
    margin-bottom: 0;
}

.flight-summary-label {
    display: inline-block;
    background: var(--primary-color);
    color: white;
    font-size: 12px;
    font-weight: 600;
    padding: 4px 12px;
    border-radius: 20px;
    margin-bottom: 16px;
}

.flight-summary-label.return {
    background: #6366f1;
}

.flight-summary-label.segment {
    background: #8b5cf6;
}

/* 여행 유형 배지 */
.trip-type-badge {
    font-size: 12px;
    font-weight: 500;
    padding: 4px 10px;
    border-radius: 12px;
    background: var(--primary-light);
    color: var(--primary-color);
    margin-left: 8px;
}

/* 사이드바 구간별 요금 */
.summary-segments {
    padding: 16px 0;
    border-bottom: 1px solid #eee;
    margin-bottom: 16px;
}

.summary-segment-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 12px;
    background: #f8fafc;
    border-radius: 8px;
    margin-bottom: 8px;
    font-size: 13px;
}

.summary-segment-item:last-child {
    margin-bottom: 0;
}

.summary-segment-label {
    display: flex;
    align-items: center;
    gap: 8px;
}

.summary-segment-badge {
    font-size: 11px;
    padding: 2px 8px;
    border-radius: 10px;
    background: var(--primary-color);
    color: white;
    font-weight: 500;
}

.summary-segment-badge.return {
    background: #6366f1;
}

.summary-segment-badge.segment {
    background: #8b5cf6;
}

.summary-segment-route {
    color: var(--gray-dark);
}

.summary-segment-price {
    font-weight: 600;
    color: var(--text-color);
}

.summary-divider {
    height: 1px;
    background: #eee;
    margin: 12px 0;
}

.flight-summary-route {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px;
}

.flight-summary-point {
    text-align: center;
}

.flight-summary-point .time {
    display: block;
    font-size: 28px;
    font-weight: 700;
    color: var(--text-color);
}

.flight-summary-point .airport {
    display: block;
    font-size: 14px;
    color: var(--gray-dark);
    margin-top: 4px;
}

.flight-summary-arrow {
    flex: 1;
    text-align: center;
}

.flight-summary-arrow .duration {
    display: block;
    font-size: 13px;
    color: var(--gray-medium);
    margin-bottom: 8px;
}

.flight-summary-arrow .arrow-line {
    position: relative;
    height: 2px;
    background: linear-gradient(90deg, var(--primary-color), #6366f1);
    margin: 0 20px;
}

.flight-summary-arrow .arrow-line i {
    position: absolute;
    right: -8px;
    top: 50%;
    transform: translateY(-50%);
    color: #6366f1;
    font-size: 16px;
}

.flight-summary-arrow .flight-type {
    display: block;
    font-size: 12px;
    color: var(--success-color);
    font-weight: 500;
    margin-top: 8px;
}

.flight-summary-details {
    display: flex;
    justify-content: space-between;
    margin-top: 16px;
    padding-top: 16px;
    border-top: 1px dashed #e2e8f0;
    font-size: 14px;
    color: var(--gray-dark);
}

.flight-summary-details .flight-price {
    font-weight: 700;
    font-size: 16px;
    color: var(--primary-color);
}

/* 탑승인원 설정 */
.passenger-count-setting {
    background: #f8fafc;
    border-radius: 12px;
    padding: 16px;
    margin-bottom: 20px;
    border: 1px solid #e2e8f0;
}

.passenger-count-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 0;
    border-bottom: 1px solid #e2e8f0;
}

.passenger-count-row:last-child {
    border-bottom: none;
    padding-bottom: 0;
}

.passenger-count-row:first-child {
    padding-top: 0;
}

.passenger-count-info {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.passenger-type-label {
    font-weight: 600;
    font-size: 15px;
    color: var(--text-color);
}

.passenger-type-desc {
    font-size: 12px;
    color: var(--gray-medium);
}

.passenger-count-control {
    display: flex;
    align-items: center;
    gap: 12px;
}

.count-btn {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: 1px solid #e2e8f0;
    background: white;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s ease;
    color: var(--gray-dark);
}

.count-btn:hover:not(:disabled) {
    border-color: var(--primary-color);
    color: var(--primary-color);
}

.count-btn:disabled {
    opacity: 0.4;
    cursor: not-allowed;
}

.count-value {
    font-size: 18px;
    font-weight: 600;
    min-width: 24px;
    text-align: center;
    color: var(--text-color);
}

/* 탑승객 안내 */
.passenger-notice {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 12px 16px;
    background: #fef3c7;
    border-radius: 8px;
    margin-bottom: 20px;
    font-size: 13px;
    color: #92400e;
}

.passenger-notice i {
    font-size: 16px;
    flex-shrink: 0;
    margin-top: 2px;
}

/* 탑승객 카드 */
.passenger-card {
    background: #f8fafc;
    border-radius: 12px;
    padding: 20px;
    margin-bottom: 16px;
    border: 1px solid #e2e8f0;
}

.passenger-card:last-child {
    margin-bottom: 0;
}

.passenger-card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
}

.passenger-card-header h6 {
    font-size: 15px;
    font-weight: 600;
    margin: 0;
    display: flex;
    align-items: center;
    gap: 8px;
}

.passenger-type-badge {
    font-size: 11px;
    padding: 2px 8px;
    border-radius: 10px;
    background: var(--primary-light);
    color: var(--primary-color);
}

/* 선택사항 배지 */
.optional-badge {
    font-size: 12px;
    font-weight: 400;
    color: var(--gray-medium);
    background: var(--gray-lighter);
    padding: 2px 8px;
    border-radius: 4px;
    margin-left: 8px;
}

/* 좌석 선택 정보 */
.seat-selection-info {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.seat-selection-info p {
    margin: 0;
    color: var(--gray-dark);
    font-size: 14px;
}

.selected-seats-display {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
}

.selected-seats-info {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
}

.seat-extra-fee {
    color: #d97706;
    font-weight: 600;
    margin-left: 4px;
}

/* 결제 요약 - 항공편 정보 */
.summary-flight-info {
    text-align: center;
    padding: 20px 0;
    border-bottom: 1px solid #eee;
    margin-bottom: 20px;
}

.summary-route {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 16px;
    font-size: 20px;
    font-weight: 700;
    margin-bottom: 8px;
}

.summary-route i {
    color: var(--primary-color);
}

.summary-trip-type {
    font-size: 13px;
    color: var(--gray-medium);
}

/* 좌석 선택 모달 */
.seat-map-container {
    padding: 20px;
}

.seat-legend {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 16px 24px;
    margin-bottom: 24px;
}

.legend-item {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 13px;
    color: var(--gray-dark);
}

.seat-sample {
    width: 24px;
    height: 24px;
    border-radius: 4px;
}

.seat-sample.available {
    background: #e2e8f0;
    border: 1px solid #cbd5e1;
}

.seat-sample.selected {
    background: var(--primary-color);
}

.seat-sample.occupied {
    background: #94a3b8;
}

.seat-sample.extra {
    background: #fef3c7;
    border: 1px solid #fcd34d;
}

.seat-sample.extra-selected {
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
}

.seat-map {
    max-width: 400px;
    margin: 0 auto;
}

.seat-row {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    margin-bottom: 8px;
}

.seat-row-number {
    width: 24px;
    text-align: center;
    font-size: 12px;
    color: var(--gray-medium);
}

.seat {
    width: 36px;
    height: 36px;
    border-radius: 6px;
    border: none;
    cursor: pointer;
    font-size: 11px;
    font-weight: 500;
    transition: all 0.2s ease;
}

.seat.available {
    background: #e2e8f0;
    color: #64748b;
}

.seat.available:hover {
    background: var(--primary-light);
    color: var(--primary-color);
}

.seat.selected {
    background: var(--primary-color);
    color: white;
}

.seat.occupied {
    background: #94a3b8;
    color: #64748b;
    cursor: not-allowed;
}

.seat.extra {
    background: #fef3c7;
    color: #92400e;
}

.seat.extra:hover {
    background: #fde68a;
}

.seat.extra.selected {
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    color: white;
    box-shadow: 0 2px 8px rgba(245, 158, 11, 0.4);
}

.seat-aisle {
    width: 24px;
}

/* 로그인 필요 안내 */
.login-required-box {
    background: white;
    border-radius: 16px;
    padding: 60px 40px;
    text-align: center;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

.login-required-icon {
    width: 100px;
    height: 100px;
    background: linear-gradient(135deg, #f0f7ff 0%, #e8f4fd 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 24px;
}

.login-required-icon i {
    font-size: 48px;
    color: var(--primary-color);
}

.login-required-box h3 {
    font-size: 24px;
    font-weight: 700;
    margin-bottom: 12px;
    color: var(--text-color);
}

.login-required-box p {
    font-size: 16px;
    color: var(--gray-dark);
    margin-bottom: 32px;
    line-height: 1.6;
}

.login-required-buttons {
    display: flex;
    justify-content: center;
    gap: 16px;
    margin-bottom: 24px;
}

.login-required-buttons .btn {
    min-width: 160px;
}

.back-link {
    display: inline-block;
    color: var(--gray-medium);
    text-decoration: none;
    font-size: 14px;
    transition: color 0.2s ease;
}

.back-link:hover {
    color: var(--primary-color);
}

/* 반응형 */
@media (max-width: 768px) {
    .login-required-box {
        padding: 40px 20px;
    }

    .login-required-buttons {
        flex-direction: column;
    }

    .login-required-buttons .btn {
        width: 100%;
    }

    .flight-summary-route {
        flex-direction: column;
        gap: 16px;
    }

    .flight-summary-arrow {
        width: 100%;
    }

    .flight-summary-arrow .arrow-line {
        width: 100%;
        margin: 0;
    }

    .seat-selection-info {
        flex-direction: column;
        gap: 12px;
        text-align: center;
    }
}
</style>

<script>
var passengerCount = { adult: 1, child: 0, infant: 0 };
var basePrice = 52000;
var fuelSurcharge = 28000;
var taxAndFees = 24000;
var selectedSeats = [];
var seatExtraFee = 0;
var seatSelectionModal;

// 항공편 예약 데이터
var bookingData = null;
var totalFlightPrice = 0;

// 로그인 여부 확인
var isLoggedIn = ${not empty sessionScope.loginUser};
var userType = '${sessionScope.loginUser.userType}';

document.addEventListener('DOMContentLoaded', function() {
    // 비회원 접근 시 로그인 안내
    if (!isLoggedIn) {
        showLoginRequired();
        return;
    }

    // 기업회원 접근 제한
    if (userType === 'BUSINESS') {
        showBusinessRestricted();
        return;
    }

    // URL 파라미터에서 정보 가져오기
    var urlParams = new URLSearchParams(window.location.search);

    // sessionStorage에서 항공편 데이터 가져오기
    var storedData = sessionStorage.getItem('flightBookingData');
    if (storedData) {
        bookingData = JSON.parse(storedData);
        initFlightDisplay();
    } else {
        // 기본 데모 데이터 (sessionStorage가 없는 경우)
        bookingData = {
            tripType: urlParams.get('type') || 'round',
            totalSegments: 2,
            flights: [
                {
                    id: 1,
                    airline: '대한항공 KE1201',
                    departureTime: '07:00',
                    arrivalTime: '08:05',
                    departureAirport: 'GMP',
                    arrivalAirport: 'CJU',
                    price: 52000,
                    baggage: '15kg',
                    segmentLabel: '가는편'
                }
            ]
        };
        if (bookingData.tripType === 'round') {
            bookingData.flights.push({
                id: 2,
                airline: '대한항공 KE1202',
                departureTime: '18:00',
                arrivalTime: '19:10',
                departureAirport: 'CJU',
                arrivalAirport: 'GMP',
                price: 52000,
                baggage: '15kg',
                segmentLabel: '오는편'
            });
        }
        initFlightDisplay();
    }

    // 탑승객 정보 초기화
    initPassengers();

    // 탑승인원 버튼 상태 초기화
    updateCountButtons();

    // 좌석 선택 모달 초기화
    seatSelectionModal = new bootstrap.Modal(document.getElementById('seatSelectionModal'));
    initSeatMap();

    // 총 금액 계산
    calculateTotal();
});

// 항공편 표시 초기화
function initFlightDisplay() {
    if (!bookingData) return;

    // 여행 유형 배지 업데이트
    var tripTypeBadge = document.getElementById('tripTypeBadge');
    var summaryTripType = document.getElementById('summaryTripType');
    var tripTypeText = getTripTypeText(bookingData.tripType);
    tripTypeBadge.textContent = tripTypeText;
    summaryTripType.textContent = tripTypeText;

    // 항공편 카드 생성
    var cardsContainer = document.getElementById('flightCardsContainer');
    var segmentsContainer = document.getElementById('summarySegments');
    var cardsHtml = '';
    var segmentsHtml = '';
    totalFlightPrice = 0;

    bookingData.flights.forEach(function(flight, index) {
        totalFlightPrice += flight.price;

        // 라벨 클래스 결정
        var labelClass = '';
        if (bookingData.tripType === 'round') {
            labelClass = index === 0 ? '' : 'return';
        } else if (bookingData.tripType === 'multi') {
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

// 여행 유형 텍스트
function getTripTypeText(type) {
    switch(type) {
        case 'round': return '왕복';
        case 'oneway': return '편도';
        case 'multi': return '다구간';
        default: return '왕복';
    }
}

// 항공편 카드 HTML 생성
function createFlightCardHtml(flight, labelClass) {
    var airportNames = {
        'GMP': '김포',
        'CJU': '제주',
        'ICN': '인천',
        'PUS': '부산',
        'TAE': '대구',
        'CJJ': '청주',
        'KWJ': '광주',
        'RSU': '여수',
        'USN': '울산',
        'MWX': '무안'
    };

    var depName = airportNames[flight.departureAirport] || flight.departureAirport;
    var arrName = airportNames[flight.arrivalAirport] || flight.arrivalAirport;

    return '<div class="flight-summary-card">' +
        '<div class="flight-summary-label ' + labelClass + '">' + flight.segmentLabel + '</div>' +
        '<div class="flight-summary-content">' +
            '<div class="flight-summary-route">' +
                '<div class="flight-summary-point">' +
                    '<span class="time">' + flight.departureTime + '</span>' +
                    '<span class="airport">' + flight.departureAirport + ' ' + depName + '</span>' +
                '</div>' +
                '<div class="flight-summary-arrow">' +
                    '<span class="duration">약 1시간</span>' +
                    '<div class="arrow-line"><i class="bi bi-airplane"></i></div>' +
                    '<span class="flight-type">직항</span>' +
                '</div>' +
                '<div class="flight-summary-point">' +
                    '<span class="time">' + flight.arrivalTime + '</span>' +
                    '<span class="airport">' + flight.arrivalAirport + ' ' + arrName + '</span>' +
                '</div>' +
            '</div>' +
            '<div class="flight-summary-details">' +
                '<span class="flight-airline">' + flight.airline + '</span>' +
                '<span class="flight-price">' + flight.price.toLocaleString() + '원</span>' +
            '</div>' +
        '</div>' +
    '</div>';
}

// 사이드바 구간 HTML 생성
function createSummarySegmentHtml(flight, labelClass) {
    return '<div class="summary-segment-item">' +
        '<div class="summary-segment-label">' +
            '<span class="summary-segment-badge ' + labelClass + '">' + flight.segmentLabel + '</span>' +
            '<span class="summary-segment-route">' + flight.departureAirport + ' → ' + flight.arrivalAirport + '</span>' +
        '</div>' +
        '<span class="summary-segment-price">' + flight.price.toLocaleString() + '원</span>' +
    '</div>';
}

// 로그인 필요 안내
function showLoginRequired() {
    var mainContent = document.querySelector('.booking-main');
    var summaryContent = document.querySelector('.booking-summary');

    if (mainContent) {
        mainContent.innerHTML =
            '<div class="login-required-box">' +
                '<div class="login-required-icon"><i class="bi bi-person-lock"></i></div>' +
                '<h3>로그인이 필요합니다</h3>' +
                '<p>항공권 결제는 회원만 이용할 수 있습니다.<br>로그인 후 다시 시도해주세요.</p>' +
                '<div class="login-required-buttons">' +
                    '<a href="${pageContext.request.contextPath}/member/login" class="btn btn-primary btn-lg">' +
                        '<i class="bi bi-box-arrow-in-right me-2"></i>로그인</a>' +
                    '<a href="${pageContext.request.contextPath}/member/join" class="btn btn-outline btn-lg">' +
                        '<i class="bi bi-person-plus me-2"></i>회원가입</a>' +
                '</div>' +
                '<a href="${pageContext.request.contextPath}/product/flight" class="back-link">' +
                    '<i class="bi bi-arrow-left me-1"></i>항공권 검색으로 돌아가기</a>' +
            '</div>';
    }

    if (summaryContent) {
        summaryContent.style.display = 'none';
    }

    // 현재 URL 저장 (로그인 후 돌아오기 위해)
    sessionStorage.setItem('returnUrl', window.location.href);
}

// 기업회원 접근 제한 안내
function showBusinessRestricted() {
    var mainContent = document.querySelector('.booking-main');
    var summaryContent = document.querySelector('.booking-summary');

    if (mainContent) {
        mainContent.innerHTML =
            '<div class="login-required-box">' +
                '<div class="login-required-icon" style="background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);">' +
                    '<i class="bi bi-building-exclamation" style="color: #d97706;"></i></div>' +
                '<h3>기업회원은 이용할 수 없습니다</h3>' +
                '<p>항공권 결제 서비스는 일반회원 전용입니다.<br>기업회원은 상품 등록 및 관리 기능을 이용해주세요.</p>' +
                '<div class="login-required-buttons">' +
                    '<a href="${pageContext.request.contextPath}/mypage/business/dashboard" class="btn btn-primary btn-lg">' +
                        '<i class="bi bi-speedometer2 me-2"></i>기업 대시보드</a>' +
                    '<a href="${pageContext.request.contextPath}/product/manage" class="btn btn-outline btn-lg">' +
                        '<i class="bi bi-box-seam me-2"></i>상품 관리</a>' +
                '</div>' +
                '<a href="${pageContext.request.contextPath}/product/flight" class="back-link">' +
                    '<i class="bi bi-arrow-left me-1"></i>항공권 검색으로 돌아가기</a>' +
            '</div>';
    }

    if (summaryContent) {
        summaryContent.style.display = 'none';
    }
}

// 탑승객 정보 초기화
function initPassengers() {
    var container = document.getElementById('passengersContainer');
    container.innerHTML = '';

    // 성인 탑승객
    for (var i = 1; i <= passengerCount.adult; i++) {
        addPassengerCard(container, 'adult', i);
    }

    // 소아 탑승객
    for (var j = 1; j <= passengerCount.child; j++) {
        addPassengerCard(container, 'child', j);
    }

    // 유아 탑승객
    for (var k = 1; k <= passengerCount.infant; k++) {
        addPassengerCard(container, 'infant', k);
    }
}

// 탑승객 카드 추가
function addPassengerCard(container, type, num) {
    var typeLabels = { adult: '성인', child: '소아', infant: '유아' };
    var typeLabel = typeLabels[type];

    var div = document.createElement('div');
    div.className = 'passenger-card';
    div.innerHTML =
        '<div class="passenger-card-header">' +
            '<h6><i class="bi bi-person-fill me-2"></i>탑승객 ' + num + ' <span class="passenger-type-badge">' + typeLabel + '</span></h6>' +
        '</div>' +
        '<div class="row">' +
            '<div class="col-md-4">' +
                '<div class="form-group">' +
                    '<label class="form-label">성 <span class="text-danger">*</span></label>' +
                    '<input type="text" class="form-control" name="lastName' + type + num + '" placeholder="홍" required>' +
                '</div>' +
            '</div>' +
            '<div class="col-md-4">' +
                '<div class="form-group">' +
                    '<label class="form-label">이름 <span class="text-danger">*</span></label>' +
                    '<input type="text" class="form-control" name="firstName' + type + num + '" placeholder="길동" required>' +
                '</div>' +
            '</div>' +
            '<div class="col-md-4">' +
                '<div class="form-group">' +
                    '<label class="form-label">성별 <span class="text-danger">*</span></label>' +
                    '<select class="form-control form-select" name="gender' + type + num + '" required>' +
                        '<option value="">선택</option>' +
                        '<option value="M">남성</option>' +
                        '<option value="F">여성</option>' +
                    '</select>' +
                '</div>' +
            '</div>' +
            '<div class="col-md-4">' +
                '<div class="form-group mb-0">' +
                    '<label class="form-label">생년월일 <span class="text-danger">*</span></label>' +
                    '<input type="date" class="form-control" name="birth' + type + num + '" required>' +
                '</div>' +
            '</div>' +
        '</div>';

    container.appendChild(div);
}

// 탑승인원 변경
function changePassengerCount(type, delta) {
    var newCount = passengerCount[type] + delta;
    var totalPassengers = passengerCount.adult + passengerCount.child + passengerCount.infant;

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
        if (newCount < passengerCount.infant) {
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
        if (newCount > passengerCount.adult) {
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
    passengerCount[type] = newCount;

    // UI 업데이트
    document.getElementById(type + 'Count').textContent = newCount;
    updateCountButtons();

    // 탑승객 카드 재생성
    initPassengers();

    // 좌석 선택 초기화 (인원 변경 시)
    if (selectedSeats.length > 0) {
        selectedSeats = [];
        seatExtraFee = 0;
        document.getElementById('summarySeatsRow').style.display = 'none';
        document.getElementById('summarySeatFeeRow').style.display = 'none';
        document.querySelector('.seat-selection-info').innerHTML =
            '<p>좌석 선택은 선택사항입니다. 미선택 시 자동 배정됩니다.</p>' +
            '<button type="button" class="btn btn-outline" onclick="openSeatSelection()">' +
                '<i class="bi bi-grid-3x3 me-1"></i>좌석 선택하기' +
            '</button>';
        initSeatMap();
    }

    // 총 금액 재계산
    calculateTotal();
}

// 버튼 상태 업데이트
function updateCountButtons() {
    // 성인 마이너스 버튼
    var adultMinus = document.querySelector('.passenger-count-row:nth-child(1) .count-btn.minus');
    adultMinus.disabled = passengerCount.adult <= 1;

    // 소아 마이너스 버튼
    var childMinus = document.querySelector('.passenger-count-row:nth-child(2) .count-btn.minus');
    childMinus.disabled = passengerCount.child <= 0;

    // 유아 마이너스 버튼
    var infantMinus = document.querySelector('.passenger-count-row:nth-child(3) .count-btn.minus');
    infantMinus.disabled = passengerCount.infant <= 0;

    // 총 인원 9명 제한
    var totalPassengers = passengerCount.adult + passengerCount.child + passengerCount.infant;
    var plusButtons = document.querySelectorAll('.count-btn.plus');
    plusButtons.forEach(function(btn) {
        btn.disabled = totalPassengers >= 9;
    });

    // 유아 플러스 버튼 (성인 수 제한)
    var infantPlus = document.querySelector('.passenger-count-row:nth-child(3) .count-btn.plus');
    if (passengerCount.infant >= passengerCount.adult) {
        infantPlus.disabled = true;
    }
}

// 총 금액 계산
function calculateTotal() {
    var totalPassengers = passengerCount.adult + passengerCount.child;
    var segmentCount = bookingData ? bookingData.flights.length : 1;

    // 항공 운임은 이미 모든 구간 합계 (basePrice = totalFlightPrice)
    // 유류할증료/세금은 구간 수 x 인원 수
    var additionalFees = (fuelSurcharge + taxAndFees) * segmentCount;
    var total = (basePrice + additionalFees) * totalPassengers + seatExtraFee;

    // 요금 표시 업데이트
    document.getElementById('summaryFare').textContent = basePrice.toLocaleString() + '원 x ' + totalPassengers + '명';
    document.getElementById('summaryFuel').textContent = (fuelSurcharge * segmentCount).toLocaleString() + '원 x ' + totalPassengers + '명';
    document.getElementById('summaryTax').textContent = (taxAndFees * segmentCount).toLocaleString() + '원 x ' + totalPassengers + '명';
    document.getElementById('totalAmount').textContent = total.toLocaleString() + '원';
    document.getElementById('payBtnText').textContent = total.toLocaleString() + '원 결제하기';

    // 탑승객 정보 업데이트
    var passengerText = [];
    if (passengerCount.adult > 0) passengerText.push('성인 ' + passengerCount.adult + '명');
    if (passengerCount.child > 0) passengerText.push('소아 ' + passengerCount.child + '명');
    if (passengerCount.infant > 0) passengerText.push('유아 ' + passengerCount.infant + '명');
    document.getElementById('summaryPassengers').textContent = passengerText.join(', ');
}

// 좌석 선택 모달 열기
function openSeatSelection() {
    seatSelectionModal.show();
}

// 좌석 배치 초기화
function initSeatMap() {
    var seatMap = document.getElementById('seatMap');
    var columns = ['A', 'B', 'C', '', 'D', 'E', 'F'];
    var rows = 20;
    var html = '';

    // 열 헤더
    html += '<div class="seat-row">';
    html += '<div class="seat-row-number"></div>';
    columns.forEach(function(col) {
        if (col === '') {
            html += '<div class="seat-aisle"></div>';
        } else {
            html += '<div class="seat" style="background: none; cursor: default; color: var(--gray-medium);">' + col + '</div>';
        }
    });
    html += '</div>';

    // 좌석 행
    for (var i = 1; i <= rows; i++) {
        html += '<div class="seat-row">';
        html += '<div class="seat-row-number">' + i + '</div>';

        columns.forEach(function(col) {
            if (col === '') {
                html += '<div class="seat-aisle"></div>';
            } else {
                var seatId = i + col;
                var occupied = Math.random() < 0.3;
                var extra = i <= 3;
                var seatClass = occupied ? 'occupied' : (extra ? 'extra available' : 'available');

                html += '<button type="button" class="seat ' + seatClass + '" data-seat="' + seatId + '" ' +
                        (occupied ? 'disabled' : 'onclick="toggleSeat(this)"') + '>' +
                        (occupied ? '' : seatId) + '</button>';
            }
        });

        html += '</div>';
    }

    seatMap.innerHTML = html;
}

// 좌석 토글
function toggleSeat(btn) {
    var seatId = btn.dataset.seat;
    var isExtra = btn.classList.contains('extra');

    if (btn.classList.contains('selected')) {
        btn.classList.remove('selected');
        btn.classList.add('available');
        selectedSeats = selectedSeats.filter(function(s) { return s !== seatId; });
    } else {
        if (selectedSeats.length >= (passengerCount.adult + passengerCount.child)) {
            showToast('탑승객 수만큼만 좌석을 선택할 수 있습니다.', 'warning');
            return;
        }
        btn.classList.remove('available');
        btn.classList.add('selected');
        selectedSeats.push(seatId);

        // 추가요금 좌석 선택 시 안내
        if (isExtra) {
            showToast('추가요금 좌석이 선택되었습니다. (+10,000원)', 'info');
        }
    }
}

// 좌석 선택 확인
function confirmSeatSelection() {
    // 결제 요약에 좌석 정보 반영
    var seatsRow = document.getElementById('summarySeatsRow');
    var seatFeeRow = document.getElementById('summarySeatFeeRow');
    var summarySeats = document.getElementById('summarySeats');
    var summarySeatFee = document.getElementById('summarySeatFee');
    var seatSelectionInfo = document.querySelector('.seat-selection-info');

    if (selectedSeats.length === 0) {
        seatsRow.style.display = 'none';
        seatFeeRow.style.display = 'none';
        seatExtraFee = 0;
        seatSelectionInfo.innerHTML =
            '<p>좌석 선택은 선택사항입니다. 미선택 시 자동 배정됩니다.</p>' +
            '<button type="button" class="btn btn-outline" onclick="openSeatSelection()">' +
                '<i class="bi bi-grid-3x3 me-1"></i>좌석 선택하기' +
            '</button>';
    } else {
        // 추가요금 좌석 개수 계산 (1~3열)
        var extraSeatCount = 0;
        selectedSeats.forEach(function(seat) {
            var rowNum = parseInt(seat);
            if (rowNum <= 3) extraSeatCount++;
        });
        seatExtraFee = extraSeatCount * 10000;

        // 좌석 정보 표시
        seatsRow.style.display = 'flex';
        summarySeats.textContent = selectedSeats.join(', ');

        // 추가요금 표시
        if (seatExtraFee > 0) {
            seatFeeRow.style.display = 'flex';
            summarySeatFee.textContent = '+' + seatExtraFee.toLocaleString() + '원';
        } else {
            seatFeeRow.style.display = 'none';
        }

        // 좌석 선택 영역 업데이트
        seatSelectionInfo.innerHTML =
            '<div class="selected-seats-display">' +
                '<div class="selected-seats-info">' +
                    '<i class="bi bi-check-circle-fill text-success me-2"></i>' +
                    '<span>선택된 좌석: <strong>' + selectedSeats.join(', ') + '</strong></span>' +
                    (seatExtraFee > 0 ? '<span class="seat-extra-fee">(+' + seatExtraFee.toLocaleString() + '원)</span>' : '') +
                '</div>' +
                '<button type="button" class="btn btn-outline btn-sm" onclick="openSeatSelection()">' +
                    '<i class="bi bi-pencil me-1"></i>변경' +
                '</button>' +
            '</div>';

        showToast('좌석 ' + selectedSeats.join(', ') + '이(가) 선택되었습니다.', 'success');
    }

    // 총 금액 재계산
    calculateTotal();
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

// 개별 약관 체크 시 전체 동의 업데이트
document.querySelectorAll('.agree-item').forEach(function(item) {
    item.addEventListener('change', function() {
        var requiredCount = document.querySelectorAll('.agree-item').length;
        var checkedCount = document.querySelectorAll('.agree-item:checked').length;
        var marketingChecked = document.getElementById('agreeMarketing').checked;
        document.getElementById('agreeAll').checked = (checkedCount === requiredCount && marketingChecked);
    });
});

// 폼 제출
document.getElementById('flightBookingForm').addEventListener('submit', function(e) {
    e.preventDefault();

    // 필수 입력값 검증
    var bookerName = document.getElementById('bookerName').value;
    var bookerPhone = document.getElementById('bookerPhone').value;
    var bookerEmail = document.getElementById('bookerEmail').value;

    if (!bookerName || !bookerPhone || !bookerEmail) {
        showToast('결제자 정보를 모두 입력해주세요.', 'error');
        return;
    }

    // 필수 약관 체크 확인
    var allAgreed = true;
    document.querySelectorAll('.agree-item').forEach(function(agree) {
        if (!agree.checked) allAgreed = false;
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
        document.querySelectorAll('.booking-step')[1].classList.remove('active');
        document.querySelectorAll('.booking-step')[1].classList.add('completed');
        document.querySelectorAll('.booking-step')[2].classList.add('active');

        showToast('항공권 결제가 완료되었습니다!', 'success');

        setTimeout(function() {
            window.location.href = '${pageContext.request.contextPath}/product/complete?type=flight';
        }, 500);
    }, 1500);
});
</script>

<c:set var="pageJs" value="product" />
<%@ include file="../common/footer.jsp" %>
