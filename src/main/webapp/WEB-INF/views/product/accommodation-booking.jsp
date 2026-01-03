<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="숙박 결제" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>

<!-- 객실 이미지 모달 -->
<div class="modal fade" id="roomImageModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">객실 사진</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-0">
                <div class="room-image-viewer">
                    <button class="room-image-nav prev" onclick="prevRoomImage()">
                        <i class="bi bi-chevron-left"></i>
                    </button>
                    <img src="" alt="객실 사진" id="roomModalImage">
                    <button class="room-image-nav next" onclick="nextRoomImage()">
                        <i class="bi bi-chevron-right"></i>
                    </button>
                </div>
                <div class="room-image-counter">
                    <span id="currentImageIndex">1</span> / <span id="totalImageCount">4</span>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="booking-page accommodation-booking-page">
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
                <span>결제 완료</span>
            </div>
        </div>

        <div class="booking-container">
            <!-- 결제 정보 입력 -->
            <div class="booking-main">
                <form id="accommodationBookingForm">
                    <!-- 숙소 정보 요약 -->
                    <div class="booking-section accommodation-info-section">
                        <h3><i class="bi bi-building me-2"></i>선택한 숙소</h3>

                        <div class="accommodation-summary-card">
                            <div class="accommodation-summary-image">
                                <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop&q=80" alt="숙소 이미지" id="accommodationImage">
                            </div>
                            <div class="accommodation-summary-info">
                                <div class="accommodation-summary-rating">
                                    <i class="bi bi-star-fill"></i>
                                    <span id="accommodationRating">4.8</span>
                                    <span class="review-count" id="accommodationReviews">(1,234개 리뷰)</span>
                                </div>
                                <h4 id="accommodationName">제주 신라호텔</h4>
                                <p class="accommodation-summary-address">
                                    <i class="bi bi-geo-alt"></i>
                                    <span id="accommodationAddress">제주 서귀포시 중문관광로 72번길 75</span>
                                </p>
                                <div class="accommodation-summary-amenities">
                                    <span class="amenity"><i class="bi bi-wifi"></i> 무료 와이파이</span>
                                    <span class="amenity"><i class="bi bi-water"></i> 수영장</span>
                                    <span class="amenity"><i class="bi bi-p-circle"></i> 주차</span>
                                </div>
                            </div>
                        </div>

                        <!-- 객실 정보 -->
                        <div class="room-info-card">
                            <div class="room-info-header">
                                <h5 id="roomName">디럭스 더블룸 (오션뷰)</h5>
                                <span class="room-type-badge">조식 포함</span>
                            </div>

                            <!-- 객실 사진 갤러리 -->
                            <div class="room-gallery">
                                <div class="room-gallery-main">
                                    <img src="https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=600&h=400&fit=crop&q=80"
                                         alt="객실 메인 사진" id="roomMainImage" onclick="openRoomImageModal(0)">
                                    <button class="room-gallery-expand" onclick="openRoomImageModal(0)">
                                        <i class="bi bi-arrows-fullscreen"></i>
                                    </button>
                                </div>
                                <div class="room-gallery-thumbs">
                                    <div class="room-thumb active" onclick="changeRoomImage(0)">
                                        <img src="https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=150&h=100&fit=crop&q=80" alt="객실 사진 1">
                                    </div>
                                    <div class="room-thumb" onclick="changeRoomImage(1)">
                                        <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?w=150&h=100&fit=crop&q=80" alt="객실 사진 2">
                                    </div>
                                    <div class="room-thumb" onclick="changeRoomImage(2)">
                                        <img src="https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=150&h=100&fit=crop&q=80" alt="객실 사진 3">
                                    </div>
                                    <div class="room-thumb" onclick="changeRoomImage(3)">
                                        <img src="https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=150&h=100&fit=crop&q=80" alt="객실 사진 4">
                                    </div>
                                </div>
                            </div>

                            <div class="room-info-details">
                                <div class="room-detail">
                                    <i class="bi bi-people"></i>
                                    <span>기준 2인 / 최대 3인</span>
                                </div>
                                <div class="room-detail">
                                    <i class="bi bi-arrows-angle-expand"></i>
                                    <span>42㎡</span>
                                </div>
                                <div class="room-detail">
                                    <i class="bi bi-door-open"></i>
                                    <span>더블베드 1개</span>
                                </div>
                            </div>
                            <div class="room-stock-info">
                                <i class="bi bi-check-circle-fill"></i>
                                <span>잔여 객실 <strong>5</strong>실</span>
                            </div>
                        </div>
                    </div>

                    <!-- 체크인/체크아웃 정보 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-calendar-event me-2"></i>숙박 일정</h3>
                        <div class="stay-info-cards">
                            <div class="stay-info-card">
                                <div class="stay-info-label">체크인</div>
                                <div class="stay-info-date" id="checkInDate">2024년 3월 15일 (금)</div>
                                <div class="stay-info-time">15:00 이후</div>
                            </div>
                            <div class="stay-info-arrow">
                                <i class="bi bi-arrow-right"></i>
                                <span class="nights-badge" id="nightsCount">2박</span>
                            </div>
                            <div class="stay-info-card">
                                <div class="stay-info-label">체크아웃</div>
                                <div class="stay-info-date" id="checkOutDate">2024년 3월 17일 (일)</div>
                                <div class="stay-info-time">11:00 이전</div>
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

                    <!-- 투숙객 정보 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-people me-2"></i>투숙객 정보</h3>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">투숙객 수 <span class="text-danger">*</span></label>
                                    <select class="form-control form-select" id="guestCount" onchange="updateGuestPrice()">
                                        <option value="1">성인 1명</option>
                                        <option value="2" selected>성인 2명</option>
                                        <option value="3">성인 3명 (+30,000원)</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">예상 도착 시간</label>
                                    <select class="form-control form-select" id="arrivalTime">
                                        <option value="">선택 안함</option>
                                        <option value="15:00">15:00 - 16:00</option>
                                        <option value="16:00">16:00 - 17:00</option>
                                        <option value="17:00">17:00 - 18:00</option>
                                        <option value="18:00">18:00 - 19:00</option>
                                        <option value="19:00">19:00 - 20:00</option>
                                        <option value="20:00">20:00 - 21:00</option>
                                        <option value="21:00">21:00 이후</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 추가 옵션 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-plus-circle me-2"></i>추가 옵션 <span class="optional-badge">선택사항</span></h3>
                        <div class="additional-services">
                            <label class="service-option">
                                <input type="checkbox" name="breakfast" value="breakfast" data-price="25000">
                                <div class="service-option-content">
                                    <div class="service-info">
                                        <div>
                                            <span class="service-name">조식 뷔페 (1인)</span>
                                            <span class="service-desc">매일 07:00 - 10:00</span>
                                        </div>
                                    </div>
                                    <span class="service-price">+25,000원</span>
                                </div>
                            </label>
                            <label class="service-option">
                                <input type="checkbox" name="latecheckout" value="latecheckout" data-price="50000">
                                <div class="service-option-content">
                                    <div class="service-info">
                                        <div>
                                            <span class="service-name">레이트 체크아웃</span>
                                            <span class="service-desc">14:00까지 객실 이용 가능</span>
                                        </div>
                                    </div>
                                    <span class="service-price">+50,000원</span>
                                </div>
                            </label>
                            <label class="service-option">
                                <input type="checkbox" name="spa" value="spa" data-price="80000">
                                <div class="service-option-content">
                                    <div class="service-info">
                                        <div>
                                            <span class="service-name">스파 패키지 (2인)</span>
                                            <span class="service-desc">아로마 마사지 60분</span>
                                        </div>
                                    </div>
                                    <span class="service-price">+80,000원</span>
                                </div>
                            </label>
                            <label class="service-option">
                                <input type="checkbox" name="parking" value="parking" data-price="15000">
                                <div class="service-option-content">
                                    <div class="service-info">
                                        <div>
                                            <span class="service-name">발렛파킹</span>
                                            <span class="service-desc">1박 기준</span>
                                        </div>
                                    </div>
                                    <span class="service-price">+15,000원</span>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- 요청사항 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-chat-text me-2"></i>요청사항</h3>
                        <div class="form-group mb-3">
                            <textarea class="form-control" id="requests" rows="3"
                                      placeholder="숙소에 전달할 요청사항을 입력해주세요. (선택)"></textarea>
                        </div>
                        <div class="quick-requests">
                            <span class="quick-request-label">빠른 선택:</span>
                            <button type="button" class="quick-request-btn" onclick="addQuickRequest('높은 층 객실 희망')">높은 층</button>
                            <button type="button" class="quick-request-btn" onclick="addQuickRequest('금연 객실 희망')">금연 객실</button>
                            <button type="button" class="quick-request-btn" onclick="addQuickRequest('트윈베드로 변경 희망')">트윈베드</button>
                            <button type="button" class="quick-request-btn" onclick="addQuickRequest('조용한 객실 희망')">조용한 객실</button>
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
                                <span>[필수] 숙박 이용약관 동의</span>
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
                        <i class="bi bi-lock me-2"></i><span id="payBtnText">530,000원 결제하기</span>
                    </button>
                </form>
            </div>

            <!-- 결제 요약 사이드바 -->
            <aside class="booking-summary">
                <div class="summary-card">
                    <h4>결제 정보</h4>

                    <div class="summary-accommodation-image">
                        <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=200&fit=crop&q=80" alt="숙소">
                    </div>

                    <div class="summary-details">
                        <div class="summary-row">
                            <span class="summary-label">숙소</span>
                            <span class="summary-value" id="summaryAccommodation">제주 신라호텔</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">객실</span>
                            <span class="summary-value" id="summaryRoom">디럭스 더블룸</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">숙박 기간</span>
                            <span class="summary-value" id="summaryPeriod">3/15 - 3/17 (2박)</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">투숙객</span>
                            <span class="summary-value" id="summaryGuests">성인 2명</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">객실 요금</span>
                            <span class="summary-value" id="summaryRoomPrice">265,000원 x 2박</span>
                        </div>
                        <div class="summary-row" id="summaryExtraGuestRow" style="display: none;">
                            <span class="summary-label">추가 인원</span>
                            <span class="summary-value" id="summaryExtraGuest">0원</span>
                        </div>
                        <div class="summary-row" id="summaryAddonsRow" style="display: none;">
                            <span class="summary-label">추가 옵션</span>
                            <span class="summary-value" id="summaryAddons">0원</span>
                        </div>
                        <div class="summary-row total">
                            <span class="summary-label">총 결제금액</span>
                            <span class="summary-value" id="totalAmount">530,000원</span>
                        </div>
                    </div>

                    <div class="summary-notice">
                        <i class="bi bi-info-circle me-2"></i>
                        <small>체크인 7일 전까지 무료 취소 가능합니다.</small>
                    </div>

                    <div class="cancellation-policy">
                        <h6>취소 규정</h6>
                        <ul>
                            <li>7일 전: 전액 환불</li>
                            <li>3~6일 전: 50% 환불</li>
                            <li>1~2일 전: 30% 환불</li>
                            <li>당일/노쇼: 환불 불가</li>
                        </ul>
                    </div>
                </div>
            </aside>
        </div>
    </div>
</div>

<style>
/* 숙소 요약 카드 */
.accommodation-info-section {
    background: linear-gradient(135deg, #f0f7ff 0%, #e8f4fd 100%);
}

.accommodation-summary-card {
    display: flex;
    gap: 20px;
    background: white;
    border-radius: 12px;
    padding: 20px;
    margin-bottom: 16px;
    border: 1px solid #e2e8f0;
}

.accommodation-summary-image {
    flex-shrink: 0;
}

.accommodation-summary-image img {
    width: 180px;
    height: 140px;
    object-fit: cover;
    border-radius: 10px;
}

.accommodation-summary-info {
    flex: 1;
}

.accommodation-summary-rating {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-bottom: 8px;
}

.accommodation-summary-rating i {
    color: #fbbf24;
}

.accommodation-summary-rating span {
    font-weight: 600;
    color: #333;
}

.accommodation-summary-rating .review-count {
    color: var(--gray-medium);
    font-weight: 400;
}

.accommodation-summary-info h4 {
    font-size: 20px;
    font-weight: 700;
    margin: 0 0 8px 0;
}

.accommodation-summary-address {
    font-size: 14px;
    color: var(--gray-dark);
    margin: 0 0 12px 0;
    display: flex;
    align-items: center;
    gap: 6px;
}

.accommodation-summary-address i {
    color: var(--primary-color);
}

.accommodation-summary-amenities {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
}

.accommodation-summary-amenities .amenity {
    font-size: 13px;
    color: var(--gray-dark);
    display: flex;
    align-items: center;
    gap: 4px;
}

.accommodation-summary-amenities .amenity i {
    color: var(--primary-color);
}

/* 객실 정보 카드 */
.room-info-card {
    background: white;
    border-radius: 12px;
    padding: 20px;
    border: 1px solid #e2e8f0;
}

.room-info-header {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 16px;
}

/* 객실 사진 갤러리 */
.room-gallery {
    margin-bottom: 16px;
}

.room-gallery-main {
    position: relative;
    border-radius: 10px;
    overflow: hidden;
    margin-bottom: 10px;
}

.room-gallery-main img {
    width: 100%;
    height: 250px;
    object-fit: cover;
    cursor: pointer;
    transition: transform 0.3s ease;
}

.room-gallery-main img:hover {
    transform: scale(1.02);
}

.room-gallery-expand {
    position: absolute;
    bottom: 12px;
    right: 12px;
    width: 36px;
    height: 36px;
    background: rgba(0, 0, 0, 0.6);
    border: none;
    border-radius: 8px;
    color: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background 0.2s;
}

.room-gallery-expand:hover {
    background: rgba(0, 0, 0, 0.8);
}

.room-gallery-thumbs {
    display: flex;
    gap: 8px;
}

.room-thumb {
    flex: 1;
    border-radius: 8px;
    overflow: hidden;
    cursor: pointer;
    border: 2px solid transparent;
    transition: all 0.2s;
}

.room-thumb.active {
    border-color: var(--primary-color);
}

.room-thumb:hover {
    opacity: 0.8;
}

.room-thumb img {
    width: 100%;
    height: 60px;
    object-fit: cover;
}

/* 객실 이미지 모달 */
.room-image-viewer {
    position: relative;
    background: #000;
}

.room-image-viewer img {
    width: 100%;
    height: auto;
    max-height: 70vh;
    object-fit: contain;
}

.room-image-nav {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    width: 44px;
    height: 44px;
    background: rgba(255, 255, 255, 0.9);
    border: none;
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    color: #333;
    transition: all 0.2s;
    z-index: 10;
}

.room-image-nav:hover {
    background: white;
    transform: translateY(-50%) scale(1.1);
}

.room-image-nav.prev {
    left: 16px;
}

.room-image-nav.next {
    right: 16px;
}

.room-image-counter {
    text-align: center;
    padding: 12px;
    background: #f8fafc;
    font-size: 14px;
    color: #666;
}

/* 잔여 객실 수 정보 */
.room-stock-info {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-top: 16px;
    padding: 12px 16px;
    background: #ecfdf5;
    border-radius: 8px;
    color: #10b981;
    font-size: 14px;
}

.room-stock-info i {
    font-size: 18px;
}

.room-stock-info strong {
    font-size: 18px;
    color: #059669;
}

.room-info-header h5 {
    font-size: 16px;
    font-weight: 600;
    margin: 0;
}

.room-type-badge {
    font-size: 11px;
    padding: 4px 10px;
    background: #dcfce7;
    color: #166534;
    border-radius: 20px;
    font-weight: 500;
}

.room-info-details {
    display: flex;
    gap: 24px;
    flex-wrap: wrap;
}

.room-detail {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
    color: var(--gray-dark);
}

.room-detail i {
    color: var(--primary-color);
    font-size: 16px;
}

/* 숙박 일정 카드 */
.stay-info-cards {
    display: flex;
    align-items: center;
    gap: 20px;
}

.stay-info-card {
    flex: 1;
    background: #f8fafc;
    border-radius: 12px;
    padding: 20px;
    text-align: center;
    border: 1px solid #e2e8f0;
}

.stay-info-label {
    font-size: 13px;
    color: var(--gray-medium);
    margin-bottom: 8px;
}

.stay-info-date {
    font-size: 18px;
    font-weight: 700;
    color: var(--text-color);
    margin-bottom: 4px;
}

.stay-info-time {
    font-size: 14px;
    color: var(--primary-color);
}

.stay-info-arrow {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
}

.stay-info-arrow i {
    font-size: 24px;
    color: var(--gray-medium);
}

.nights-badge {
    background: var(--primary-color);
    color: white;
    font-size: 13px;
    font-weight: 600;
    padding: 4px 12px;
    border-radius: 20px;
}

/* 빠른 요청사항 */
.quick-requests {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
}

.quick-request-label {
    font-size: 13px;
    color: var(--gray-medium);
}

.quick-request-btn {
    padding: 6px 14px;
    border: 1px solid var(--gray-light);
    border-radius: 20px;
    background: white;
    font-size: 13px;
    color: var(--gray-dark);
    cursor: pointer;
    transition: all 0.2s ease;
}

.quick-request-btn:hover {
    border-color: var(--primary-color);
    color: var(--primary-color);
    background: var(--primary-light);
}

/* 결제 요약 - 숙소 이미지 */
.summary-accommodation-image {
    margin-bottom: 20px;
}

.summary-accommodation-image img {
    width: 100%;
    height: 150px;
    object-fit: cover;
    border-radius: 12px;
}

/* 취소 규정 */
.cancellation-policy {
    margin-top: 16px;
    padding: 16px;
    background: #fef3c7;
    border-radius: 8px;
}

.cancellation-policy h6 {
    font-size: 14px;
    font-weight: 600;
    color: #92400e;
    margin: 0 0 12px 0;
}

.cancellation-policy ul {
    margin: 0;
    padding-left: 20px;
}

.cancellation-policy li {
    font-size: 12px;
    color: #92400e;
    margin-bottom: 4px;
}

.cancellation-policy li:last-child {
    margin-bottom: 0;
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

    .accommodation-summary-card {
        flex-direction: column;
    }

    .accommodation-summary-image img {
        width: 100%;
        height: 180px;
    }

    .stay-info-cards {
        flex-direction: column;
    }

    .stay-info-arrow {
        flex-direction: row;
    }

    .stay-info-arrow i {
        transform: rotate(90deg);
    }
}
</style>

<script>
var roomPricePerNight = 265000;
var nights = 2;
var extraGuestPrice = 30000;
var addonsTotal = 0;

// 객실 이미지 갤러리
var roomImages = [
    'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&h=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800&h=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=800&h=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=800&h=600&fit=crop&q=80'
];
var currentRoomImageIndex = 0;

// 객실 이미지 변경
function changeRoomImage(index) {
    currentRoomImageIndex = index;
    var mainImage = document.getElementById('roomMainImage');
    mainImage.src = roomImages[index].replace('w=800', 'w=600').replace('h=600', 'h=400');

    // 썸네일 활성화 상태 변경
    document.querySelectorAll('.room-thumb').forEach(function(thumb, i) {
        thumb.classList.toggle('active', i === index);
    });
}

// 객실 이미지 모달 열기
function openRoomImageModal(index) {
    currentRoomImageIndex = index;
    var modal = new bootstrap.Modal(document.getElementById('roomImageModal'));
    updateModalImage();
    modal.show();
}

// 모달 이미지 업데이트
function updateModalImage() {
    document.getElementById('roomModalImage').src = roomImages[currentRoomImageIndex];
    document.getElementById('currentImageIndex').textContent = currentRoomImageIndex + 1;
    document.getElementById('totalImageCount').textContent = roomImages.length;
}

// 이전 이미지
function prevRoomImage() {
    currentRoomImageIndex = (currentRoomImageIndex - 1 + roomImages.length) % roomImages.length;
    updateModalImage();
    changeRoomImage(currentRoomImageIndex);
}

// 다음 이미지
function nextRoomImage() {
    currentRoomImageIndex = (currentRoomImageIndex + 1) % roomImages.length;
    updateModalImage();
    changeRoomImage(currentRoomImageIndex);
}

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

    // 추가 옵션 체크박스 이벤트
    initAdditionalServices();

    // 총 금액 계산
    calculateTotal();
});

// 로그인 필요 안내
function showLoginRequired() {
    var mainContent = document.querySelector('.booking-main');
    var summaryContent = document.querySelector('.booking-summary');

    if (mainContent) {
        mainContent.innerHTML =
            '<div class="login-required-box">' +
                '<div class="login-required-icon"><i class="bi bi-person-lock"></i></div>' +
                '<h3>로그인이 필요합니다</h3>' +
                '<p>숙박 결제는 회원만 이용할 수 있습니다.<br>로그인 후 다시 시도해주세요.</p>' +
                '<div class="login-required-buttons">' +
                    '<a href="${pageContext.request.contextPath}/member/login" class="btn btn-primary btn-lg">' +
                        '<i class="bi bi-box-arrow-in-right me-2"></i>로그인</a>' +
                    '<a href="${pageContext.request.contextPath}/member/join" class="btn btn-outline btn-lg">' +
                        '<i class="bi bi-person-plus me-2"></i>회원가입</a>' +
                '</div>' +
                '<a href="${pageContext.request.contextPath}/product/accommodation" class="back-link">' +
                    '<i class="bi bi-arrow-left me-1"></i>숙소 검색으로 돌아가기</a>' +
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
                '<p>숙박 예약 서비스는 일반회원 전용입니다.<br>기업회원은 상품 등록 및 관리 기능을 이용해주세요.</p>' +
                '<div class="login-required-buttons">' +
                    '<a href="${pageContext.request.contextPath}/mypage/business/dashboard" class="btn btn-primary btn-lg">' +
                        '<i class="bi bi-speedometer2 me-2"></i>기업 대시보드</a>' +
                    '<a href="${pageContext.request.contextPath}/product/manage" class="btn btn-outline btn-lg">' +
                        '<i class="bi bi-box-seam me-2"></i>상품 관리</a>' +
                '</div>' +
                '<a href="${pageContext.request.contextPath}/product/accommodation" class="back-link">' +
                    '<i class="bi bi-arrow-left me-1"></i>숙소 검색으로 돌아가기</a>' +
            '</div>';
    }

    if (summaryContent) {
        summaryContent.style.display = 'none';
    }
}

// 추가 옵션 이벤트 초기화
function initAdditionalServices() {
    document.querySelectorAll('.service-option input').forEach(function(checkbox) {
        checkbox.addEventListener('change', function() {
            calculateAddons();
            calculateTotal();
        });
    });
}

// 추가 옵션 금액 계산
function calculateAddons() {
    addonsTotal = 0;
    document.querySelectorAll('.service-option input:checked').forEach(function(checkbox) {
        addonsTotal += parseInt(checkbox.dataset.price);
    });

    if (addonsTotal > 0) {
        document.getElementById('summaryAddonsRow').style.display = 'flex';
        document.getElementById('summaryAddons').textContent = addonsTotal.toLocaleString() + '원';
    } else {
        document.getElementById('summaryAddonsRow').style.display = 'none';
    }
}

// 투숙객 수 변경 시 가격 업데이트
function updateGuestPrice() {
    var guestCount = parseInt(document.getElementById('guestCount').value);
    var extraGuest = guestCount > 2 ? (guestCount - 2) * extraGuestPrice : 0;

    document.getElementById('summaryGuests').textContent = '성인 ' + guestCount + '명';

    if (extraGuest > 0) {
        document.getElementById('summaryExtraGuestRow').style.display = 'flex';
        document.getElementById('summaryExtraGuest').textContent = '+' + extraGuest.toLocaleString() + '원';
    } else {
        document.getElementById('summaryExtraGuestRow').style.display = 'none';
    }

    calculateTotal();
}

// 총 금액 계산
function calculateTotal() {
    var guestCount = parseInt(document.getElementById('guestCount').value);
    var extraGuest = guestCount > 2 ? (guestCount - 2) * extraGuestPrice : 0;

    var roomTotal = roomPricePerNight * nights;
    var total = roomTotal + extraGuest + addonsTotal;

    document.getElementById('summaryRoomPrice').textContent = roomPricePerNight.toLocaleString() + '원 x ' + nights + '박';
    document.getElementById('totalAmount').textContent = total.toLocaleString() + '원';
    document.getElementById('payBtnText').textContent = total.toLocaleString() + '원 결제하기';
}

// 빠른 요청사항 추가
function addQuickRequest(text) {
    var textarea = document.getElementById('requests');
    if (textarea.value) {
        textarea.value += '\n' + text;
    } else {
        textarea.value = text;
    }
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
document.getElementById('accommodationBookingForm').addEventListener('submit', function(e) {
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

        showToast('숙박 결제가 완료되었습니다!', 'success');

        setTimeout(function() {
            window.location.href = '${pageContext.request.contextPath}/product/complete?type=accommodation';
        }, 500);
    }, 1500);
});
</script>

<%@ include file="../common/footer.jsp" %>
