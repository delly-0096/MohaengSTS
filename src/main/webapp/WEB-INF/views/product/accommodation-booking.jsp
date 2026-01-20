<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="숙박 결제" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/accommodation-booking.css">
<sec:authorize access="isAuthenticated()"><sec:authentication property="principal" var="user" /></sec:authorize>

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
                                <img src="${acc.accFilePath}" alt="${acc.accName}" id="accommodationImage">
                            </div>
                            <div class="accommodation-summary-info">
                                <div class="accommodation-summary-rating">
                                    <i class="bi bi-star-fill"></i>
                                    <span id="accommodationRating">4.8</span>
                                    <span class="review-count" id="accommodationReviews">(1,234개 리뷰)</span>
                                </div>
                                <h4 id="accommodationName">${acc.accName}</h4>
                                <p class="accommodation-summary-address">
                                    <i class="bi bi-geo-alt"></i>
                                    <span id="accommodationAddress">${acc.addr1} ${acc.addr2}</span>
                                </p>
                                <div class="accommodation-summary-amenities" style="display: flex; flex-wrap: wrap; gap: 8px;">
                                    <c:if test="${acc.accFacility.wifiYn eq 'Y'}"><span class="amenity"><i class="bi bi-wifi"></i> WiFi</span></c:if>
								    <c:if test="${acc.accFacility.parkingYn eq 'Y'}"><span class="amenity"><i class="bi bi-p-circle"></i> 주차</span></c:if>
								    <c:if test="${acc.accFacility.breakfastYn eq 'Y'}"><span class="amenity"><i class="bi bi-cup-hot"></i> 조식</span></c:if>
								    <c:if test="${acc.accFacility.poolYn eq 'Y'}"><span class="amenity"><i class="bi bi-water"></i> 수영장</span></c:if>
								    <c:if test="${acc.accFacility.gymYn eq 'Y'}"><span class="amenity"><i class="bi bi-heart-pulse"></i> 피트니스</span></c:if>
								    <c:if test="${acc.accFacility.spaYn eq 'Y'}"><span class="amenity"><i class="bi bi-magic"></i> 스파</span></c:if>
								    <c:if test="${acc.accFacility.restaurantYn eq 'Y'}"><span class="amenity"><i class="bi bi-egg-fried"></i> 식당</span></c:if>
								    <c:if test="${acc.accFacility.barYn eq 'Y'}"><span class="amenity"><i class="bi bi-glass-cocktail"></i> 바</span></c:if>
								    <c:if test="${acc.accFacility.roomServiceYn eq 'Y'}"><span class="amenity"><i class="bi bi-bell"></i> 룸서비스</span></c:if>
								    <c:if test="${acc.accFacility.laundryYn eq 'Y'}"><span class="amenity"><i class="bi bi-wind"></i> 세탁</span></c:if>
								    <c:if test="${acc.accFacility.smokingAreaYn eq 'Y'}"><span class="amenity"><i class="bi bi-cursor"></i> 흡연구역</span></c:if>
								    <c:if test="${acc.accFacility.petFriendlyYn eq 'Y'}"><span class="amenity"><i class="bi bi-dog"></i> 반려동물</span></c:if>
                                </div>
                            </div>
                        </div>

                        <!-- 객실 정보 -->
                        <div class="room-info-card">
                            <div class="room-info-header">
                                <h5 id="roomName">${room.roomName}</h5>
                                <c:if test="${room.breakfastYn eq 'Y'}"><span class="room-type-badge"><i class="bi bi-cup-hot"></i> 조식</span></c:if>
                            </div>

                            <!-- 객실 사진 갤러리 -->
                            <div class="room-gallery">
                                <div class="room-gallery-main">
                                    <img src="${acc.accFilePath }"
                                         alt="${acc.accName}" id="roomMainImage" onclick="openRoomImageModal(0)">
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
                                    <span>기준 ${room.baseGuestCount}인 / 최대 ${room.maxGuestCount}인</span>
                                </div>
                                <div class="room-detail">
                                    <i class="bi bi-arrows-angle-expand"></i>
                                    <span>${room.roomSize}㎡</span>
                                </div>
                                <div class="room-detail">
                                    <i class="bi bi-door-open"></i>
                                    <span>${room.bedTypeCd} ${room.bedCount}개</span>
                                </div>
                            </div>
                            <div class="room-stock-info">
                                <i class="bi bi-check-circle-fill"></i>
                                <span>잔여 객실 <strong>${room.totalRoomCount}</strong>실</span>
                            </div>
                        </div>
                    </div>

                    <!-- 체크인/체크아웃 정보 -->
                    <div class="booking-section">
                        <h3><i class="bi bi-calendar-event me-2"></i>숙박 일정</h3>
                        <div class="stay-info-cards">
                            <div class="stay-info-card">
                                <div class="stay-info-label">체크인</div>
                                <div class="stay-info-date" id="checkInDate">${bookingData.startDate}</div>
                                <div class="stay-info-time">${acc.checkInTime} 이후</div>
                            </div>
                            <div class="stay-info-arrow">
                                <i class="bi bi-arrow-right"></i>
                                <span class="nights-badge" id="nightsCount">${nights}박</span>
                            </div>
                            <div class="stay-info-card">
                                <div class="stay-info-label">체크아웃</div>
                                <div class="stay-info-date" id="checkOutDate">${bookingData.endDate}</div>
                                <div class="stay-info-time">${acc.checkOutTime} 이전</div>
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
                                           value="${user.member.memName}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">연락처 <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" id="bookerPhone"
                                           value="${user.member.memUser.tel}" placeholder="010-0000-0000" maxlength="11" required>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-group mb-0">
                                    <label class="form-label">이메일 <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="bookerEmail"
                                           value="${user.member.memEmail}" required>
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
								    <label class="form-label">투숙객 선택 <span class="text-danger">*</span></label>
								        <div class="guest-selector-container p-3 border rounded bg-light">
								            <div class="d-flex justify-content-between align-items-center mb-3">
								                <div>
								                    <span class="fw-bold">성인</span>
								                    <small class="text-muted d-block">중학생 이상</small>
								                </div>
								                <div class="input-group" style="width: 120px;">
								                    <button class="btn btn-outline-secondary" type="button" onclick="changeGuestCount('adult', -1)">-</button>
								                    <input type="text" class="form-control text-center" id="adultCount" value="2" readonly>
								                    <button class="btn btn-outline-secondary" type="button" onclick="changeGuestCount('adult', 1)">+</button>
								                </div>
								            </div>
								            <div class="d-flex justify-content-between align-items-center mb-3">
								                <div>
								                    <span class="fw-bold">아동</span>
								                    <small class="text-muted d-block">초등학생 이하</small>
								                </div>
								                <div class="input-group" style="width: 120px;">
								                    <button class="btn btn-outline-secondary" type="button" onclick="changeGuestCount('child', -1)">-</button>
								                    <input type="text" class="form-control text-center" id="childCount" value="0" readonly>
								                    <button class="btn btn-outline-secondary" type="button" onclick="changeGuestCount('child', 1)">+</button>
								                </div>
								            </div>
								            <div class="d-flex justify-content-between align-items-center">
								                <div>
								                    <span class="fw-bold">유아</span>
								                    <small class="text-muted d-block">36개월 미만 (무료)</small>
								                </div>
								                <div class="input-group" style="width: 120px;">
								                    <button class="btn btn-outline-secondary" type="button" onclick="changeGuestCount('infant', -1)">-</button>
								                    <input type="text" class="form-control text-center" id="infantCount" value="0" readonly>
								                    <button class="btn btn-outline-secondary" type="button" onclick="changeGuestCount('infant', 1)">+</button>
								                </div>
								        </div>
								        <small class="text-danger mt-2 d-block" id="guestLimitNotice"></small>
								    </div>
								</div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">예상 도착 시간</label>
                                    <select class="form-control form-select" id="arrivalTime">
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

<script src="${pageContext.request.contextPath}/resources/js/accommodation-booking.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 1. 로그인 여부 체크
    const isLoggedIn = <sec:authorize access="isAuthenticated()">true</sec:authorize>
                       <sec:authorize access="isAnonymous()">false</sec:authorize>;
    
    // 2. 권한 체크 (기업회원 여부 확인)
    // 리더의 권한 이름이 'ROLE_BUSINESS'라면 아래처럼 체크!
    let isBusiness = false;
    <c:forEach items="${user.authorities}" var="auth">
        if("${auth.authority}" === 'ROLE_BUSINESS') isBusiness = true;
    </c:forEach>

    initBooking({
        roomPricePerNight: ${room.finalPrice},
        nights: ${nights},
        extraGuestPrice: ${room.extraGuestFee},
        baseGuestCount: ${room.baseGuestCount},
        maxGuestCount: ${room.maxGuestCount},  
        currentAdultCount: '${bookingData.adultCount}', 
        checkInTime: '${acc.checkInTime}',
        contextPath: '${pageContext.request.contextPath}',
        isLoggedIn: isLoggedIn,
        
        // 날짜 & 이미지 데이터 주입
        startDate: '${bookingData.startDate}',
        endDate: '${bookingData.endDate}',
        roomImages: ['${acc.accFilePath}', '${room.accFileNo}']
    });

    // 🚦 권한별 통제 로직
    if (!isLoggedIn) {
        showLoginRequired();
    } else if (isBusiness) {
        // "결제는 일반회원만 가능합니다" 로직 적용!
        showBusinessRestricted(); 
    } else {
        initAgreementEvents();
        initBookingForm();
    }
});
</script>
<%@ include file="../common/footer.jsp" %>
