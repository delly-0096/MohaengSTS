<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="그랜드 하얏트 제주" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>

<div class="accommodation-detail-page">
    <div class="container">
        <!-- 브레드크럼 -->
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/">홈</a>
            <span class="mx-2">/</span>
            <a href="${pageContext.request.contextPath}/product/accommodation">숙박</a>
            <span class="mx-2">/</span>
            <span>그랜드 하얏트 제주</span>
        </nav>

        <!-- 갤러리 -->
        <div class="accommodation-gallery">
            <div class="gallery-main">
                <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&h=500&fit=crop&q=80"
                     alt="호텔 외관" id="mainImage">
                <span class="gallery-badge"><i class="bi bi-images me-1"></i>1/12</span>
            </div>
            <div class="gallery-grid">
                <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=300&h=200&fit=crop&q=80"
                     alt="객실" onclick="changeMainImage(this, 2)">
                <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?w=300&h=200&fit=crop&q=80"
                     alt="욕실" onclick="changeMainImage(this, 3)">
                <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=300&h=200&fit=crop&q=80"
                     alt="수영장" onclick="changeMainImage(this, 4)">
                <div class="gallery-more" onclick="openGalleryModal()">
                    <img src="https://images.unsplash.com/photo-1540541338287-41700207dee6?w=300&h=200&fit=crop&q=80"
                         alt="레스토랑">
                    <div class="gallery-more-overlay">
                        <span>+8</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="accommodation-detail-content">
            <!-- 숙소 정보 -->
            <div class="accommodation-info">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <div class="accommodation-badges">
                        <span class="badge-type">호텔</span>
                        <span class="badge-star"><i class="bi bi-star-fill"></i> 5성급</span>
                    </div>
                    <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.userType ne 'BUSINESS'}">
                    <button class="report-btn" onclick="openReportModal('accommodation', '1', '그랜드 하얏트 제주')">
                        <i class="bi bi-flag"></i> 신고
                    </button>
                    </c:if>
                </div>
                <h1>그랜드 하얏트 제주</h1>

                <div class="accommodation-meta">
                    <span><i class="bi bi-geo-alt"></i> 제주 서귀포시 중문관광로</span>
                    <span><i class="bi bi-star-fill text-warning"></i> 4.8 (512 리뷰)</span>
                </div>

                <!-- 체크인/아웃 정보 -->
                <div class="checkin-info">
                    <div class="checkin-item">
                        <i class="bi bi-box-arrow-in-right"></i>
                        <div>
                            <span class="label">체크인</span>
                            <span class="time">15:00</span>
                        </div>
                    </div>
                    <div class="checkin-divider"></div>
                    <div class="checkin-item">
                        <i class="bi bi-box-arrow-right"></i>
                        <div>
                            <span class="label">체크아웃</span>
                            <span class="time">11:00</span>
                        </div>
                    </div>
                </div>

                <!-- 숙소 소개 -->
                <div class="accommodation-section">
                    <h3>숙소 소개</h3>
                    <p>
                        제주도의 아름다운 중문 관광단지에 위치한 그랜드 하얏트 제주는
                        최고급 시설과 서비스를 제공하는 5성급 럭셔리 호텔입니다.
                    </p>
                    <p>
                        탁 트인 오션뷰와 함께 인피니티 풀, 스파, 피트니스 센터 등
                        다양한 부대시설을 갖추고 있어 완벽한 휴식을 경험하실 수 있습니다.
                    </p>
                </div>

                <!-- 편의시설 -->
                <div class="accommodation-section">
                    <h3>편의시설</h3>
                    <div class="amenities-list">
                        <div class="amenity-item">
                            <i class="bi bi-wifi"></i>
                            <span>무료 WiFi</span>
                        </div>
                        <div class="amenity-item">
                            <i class="bi bi-p-circle"></i>
                            <span>무료 주차</span>
                        </div>
                        <div class="amenity-item">
                            <i class="bi bi-water"></i>
                            <span>수영장</span>
                        </div>
                        <div class="amenity-item">
                            <i class="bi bi-heart-pulse"></i>
                            <span>피트니스</span>
                        </div>
                        <div class="amenity-item">
                            <i class="bi bi-droplet"></i>
                            <span>스파/사우나</span>
                        </div>
                        <div class="amenity-item">
                            <i class="bi bi-cup-hot"></i>
                            <span>조식 제공</span>
                        </div>
                        <div class="amenity-item">
                            <i class="bi bi-shop"></i>
                            <span>레스토랑</span>
                        </div>
                        <div class="amenity-item">
                            <i class="bi bi-cup-straw"></i>
                            <span>바/라운지</span>
                        </div>
                        <div class="amenity-item">
                            <i class="bi bi-bell"></i>
                            <span>룸서비스</span>
                        </div>
                        <div class="amenity-item">
                            <i class="bi bi-basket"></i>
                            <span>세탁 서비스</span>
                        </div>
                    </div>
                </div>

                <!-- 객실 선택 -->
                <div class="accommodation-section">
                    <h3>객실 선택</h3>
                    <div class="room-list">
                        <!-- 객실 1 -->
                        <div class="room-card" data-room-id="1">
                            <div class="room-image">
                                <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=300&h=200&fit=crop&q=80" alt="디럭스 더블">
                                <button class="room-image-btn" onclick="openRoomGallery(1)">
                                    <i class="bi bi-images"></i>
                                </button>
                            </div>
                            <div class="room-info">
                                <h4>디럭스 더블</h4>
                                <div class="room-details">
                                    <span><i class="bi bi-people"></i> 기준 2인 / 최대 3인</span>
                                    <span><i class="bi bi-arrows-fullscreen"></i> 35㎡</span>
                                    <span><i class="bi bi-moon"></i> 더블 베드 1개</span>
                                </div>
                                <div class="room-features">
                                    <span class="feature"><i class="bi bi-cup-hot"></i> 조식 포함</span>
                                    <span class="feature"><i class="bi bi-check"></i> 무료 취소</span>
                                </div>
                                <div class="room-stock available">
                                    <i class="bi bi-check-circle"></i> 잔여 5실
                                </div>
                            </div>
                            <div class="room-price">
                                <div class="price-info">
                                    <span class="original-price">280,000원</span>
                                    <span class="sale-price">220,000원</span>
                                    <span class="per-night">/ 1박</span>
                                </div>
                                <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                                <button class="btn btn-primary btn-sm" onclick="selectRoom(1, '디럭스 더블', 220000)">
                                    객실 선택
                                </button>
                                </c:if>
                            </div>
                        </div>

                        <!-- 객실 2 -->
                        <div class="room-card" data-room-id="2">
                            <div class="room-image">
                                <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?w=300&h=200&fit=crop&q=80" alt="프리미엄 트윈">
                                <button class="room-image-btn" onclick="openRoomGallery(2)">
                                    <i class="bi bi-images"></i>
                                </button>
                            </div>
                            <div class="room-info">
                                <h4>프리미엄 트윈</h4>
                                <div class="room-details">
                                    <span><i class="bi bi-people"></i> 기준 2인 / 최대 4인</span>
                                    <span><i class="bi bi-arrows-fullscreen"></i> 42㎡</span>
                                    <span><i class="bi bi-moon"></i> 싱글 베드 2개</span>
                                </div>
                                <div class="room-features">
                                    <span class="feature"><i class="bi bi-cup-hot"></i> 조식 포함</span>
                                    <span class="feature"><i class="bi bi-eye"></i> 오션뷰</span>
                                </div>
                                <div class="room-stock low">
                                    <i class="bi bi-exclamation-circle"></i> 잔여 2실
                                </div>
                            </div>
                            <div class="room-price">
                                <div class="price-info">
                                    <span class="original-price">350,000원</span>
                                    <span class="sale-price">290,000원</span>
                                    <span class="per-night">/ 1박</span>
                                </div>
                                <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                                <button class="btn btn-primary btn-sm" onclick="selectRoom(2, '프리미엄 트윈', 290000)">
                                    객실 선택
                                </button>
                                </c:if>
                            </div>
                        </div>

                        <!-- 객실 3 -->
                        <div class="room-card" data-room-id="3">
                            <div class="room-image">
                                <img src="https://images.unsplash.com/photo-1591088398332-8a7791972843?w=300&h=200&fit=crop&q=80" alt="스위트">
                                <button class="room-image-btn" onclick="openRoomGallery(3)">
                                    <i class="bi bi-images"></i>
                                </button>
                            </div>
                            <div class="room-info">
                                <h4>오션뷰 스위트</h4>
                                <div class="room-details">
                                    <span><i class="bi bi-people"></i> 기준 2인 / 최대 4인</span>
                                    <span><i class="bi bi-arrows-fullscreen"></i> 65㎡</span>
                                    <span><i class="bi bi-moon"></i> 킹 베드 1개</span>
                                </div>
                                <div class="room-features">
                                    <span class="feature"><i class="bi bi-cup-hot"></i> 조식 포함</span>
                                    <span class="feature"><i class="bi bi-eye"></i> 오션뷰</span>
                                    <span class="feature"><i class="bi bi-door-open"></i> 거실 포함</span>
                                </div>
                                <div class="room-stock soldout">
                                    <i class="bi bi-x-circle"></i> 매진
                                </div>
                            </div>
                            <div class="room-price">
                                <div class="price-info">
                                    <span class="sale-price">450,000원</span>
                                    <span class="per-night">/ 1박</span>
                                </div>
                                <button class="btn btn-outline btn-sm" disabled>
                                    예약 마감
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 위치 -->
                <div class="accommodation-section" style="border-bottom: none;">
                    <h3>위치</h3>
                    <p><i class="bi bi-geo-alt me-2"></i>제주특별자치도 서귀포시 중문관광로 72번길 75</p>
                    <div class="bg-light rounded-3 p-4 text-center" style="height: 200px;">
                        <i class="bi bi-map" style="font-size: 48px; color: var(--gray-medium);"></i>
                        <p class="mt-2 text-muted">지도가 표시됩니다</p>
                    </div>
                </div>
            </div>

            <!-- 예약 사이드바 -->
            <aside class="booking-sidebar">
                <div class="booking-card">
                    <div class="booking-price">
                        <span class="price-label">객실 최저가</span>
                        <div>
                            <span class="price">220,000</span>
                            <span class="per-person">원~ / 1박</span>
                        </div>
                    </div>

                    <form class="booking-form" id="bookingForm">
                        <div class="form-group">
                            <label class="form-label">체크인</label>
                            <input type="text" class="form-control date-picker" id="checkInDate"
                                   placeholder="체크인 날짜" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">체크아웃</label>
                            <input type="text" class="form-control date-picker" id="checkOutDate"
                                   placeholder="체크아웃 날짜" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">인원</label>
                            <div class="guest-selector">
                                <div class="guest-row">
                                    <span>성인</span>
                                    <div class="guest-counter">
                                        <button type="button" onclick="updateGuest('adult', -1)">-</button>
                                        <span id="adultCount">2</span>
                                        <button type="button" onclick="updateGuest('adult', 1)">+</button>
                                    </div>
                                </div>
                                <div class="guest-row">
                                    <span>아동</span>
                                    <div class="guest-counter">
                                        <button type="button" onclick="updateGuest('child', -1)">-</button>
                                        <span id="childCount">0</span>
                                        <button type="button" onclick="updateGuest('child', 1)">+</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="selected-room-info" id="selectedRoomInfo" style="display: none;">
                            <div class="selected-room-header">
                                <span>선택한 객실</span>
                                <button type="button" class="btn-remove-room" onclick="clearSelectedRoom()">
                                    <i class="bi bi-x"></i>
                                </button>
                            </div>
                            <div class="selected-room-name" id="selectedRoomName"></div>
                            <div class="selected-room-price" id="selectedRoomPrice"></div>
                        </div>

                        <div class="booking-total">
                            <span class="booking-total-label">총 금액</span>
                            <span class="booking-total-price" id="totalPrice">-</span>
                        </div>

                        <div class="booking-actions">
                            <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                            <button type="button" class="btn btn-outline w-100" onclick="addToBookmark()">
                                <i class="bi bi-bookmark me-2"></i>북마크
                            </button>
                            <button type="submit" class="btn btn-primary w-100" id="bookingBtn" disabled>
                                <i class="bi bi-credit-card me-2"></i>결제하기
                            </button>
                            </c:if>
                            <c:if test="${sessionScope.loginUser.userType eq 'BUSINESS'}">
                            <div class="business-notice mt-2">
                                <small class="text-muted"><i class="bi bi-info-circle me-1"></i>기업회원은 예약이 불가합니다.</small>
                            </div>
                            </c:if>
                        </div>
                    </form>
                </div>
            </aside>
        </div>

        <!-- 리뷰 섹션 -->
        <div class="review-section mt-5">
            <div class="review-header">
                <h3><i class="bi bi-star me-2"></i>리뷰 (512)</h3>
                <div class="review-summary">
                    <div class="review-score">
                        <span class="score">4.8</span>
                        <div class="stars">
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-half"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="review-list">
                <!-- 리뷰 1 -->
                <div class="review-item">
                    <div class="review-item-header">
                        <div class="reviewer-info">
                            <div class="reviewer-avatar">
                                <i class="bi bi-person"></i>
                            </div>
                            <div>
                                <span class="reviewer-name">travel_lover</span>
                                <span class="review-date">2024.03.15</span>
                            </div>
                        </div>
                        <div class="review-rating">
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                        </div>
                    </div>
                    <div class="review-room">
                        <i class="bi bi-door-closed me-1"></i>디럭스 더블 | 2024.03.10 - 2024.03.12 (2박)
                    </div>
                    <div class="review-content">
                        <p>
                            위치도 좋고 시설도 깨끗해서 정말 만족스러웠습니다.
                            특히 오션뷰가 정말 멋졌고, 조식 뷔페도 다양하고 맛있었어요.
                            직원분들도 친절하셔서 다음에 제주 올 때도 여기 묵을 것 같아요!
                        </p>
                    </div>
                    <div class="review-images">
                        <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=100&h=100&fit=crop&q=80" alt="리뷰 이미지">
                        <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=100&h=100&fit=crop&q=80" alt="리뷰 이미지">
                    </div>
                </div>

                <!-- 리뷰 2 -->
                <div class="review-item">
                    <div class="review-item-header">
                        <div class="reviewer-info">
                            <div class="reviewer-avatar">
                                <i class="bi bi-person"></i>
                            </div>
                            <div>
                                <span class="reviewer-name">jeju_trip</span>
                                <span class="review-date">2024.03.08</span>
                            </div>
                        </div>
                        <div class="review-rating">
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star"></i>
                        </div>
                    </div>
                    <div class="review-room">
                        <i class="bi bi-door-closed me-1"></i>프리미엄 트윈 | 2024.03.05 - 2024.03.07 (2박)
                    </div>
                    <div class="review-content">
                        <p>
                            전반적으로 좋았는데 체크인할 때 대기 시간이 좀 길었어요.
                            그래도 객실은 깔끔하고 넓어서 편하게 쉴 수 있었습니다.
                            수영장도 넓고 좋았어요.
                        </p>
                    </div>
                </div>

                <!-- 리뷰 3 -->
                <div class="review-item">
                    <div class="review-item-header">
                        <div class="reviewer-info">
                            <div class="reviewer-avatar">
                                <i class="bi bi-person"></i>
                            </div>
                            <div>
                                <span class="reviewer-name">happy_family</span>
                                <span class="review-date">2024.03.01</span>
                            </div>
                        </div>
                        <div class="review-rating">
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                        </div>
                    </div>
                    <div class="review-room">
                        <i class="bi bi-door-closed me-1"></i>오션뷰 스위트 | 2024.02.25 - 2024.02.28 (3박)
                    </div>
                    <div class="review-content">
                        <p>
                            가족여행으로 왔는데 아이들도 정말 좋아했어요!
                            키즈 프로그램도 있고 수영장에서 아이들이 신나게 놀았습니다.
                            스위트룸 거실에서 보는 바다 풍경이 정말 예뻤어요.
                        </p>
                    </div>
                    <div class="review-images">
                        <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=100&h=100&fit=crop&q=80" alt="리뷰 이미지">
                    </div>
                </div>
            </div>

            <div class="review-more">
                <button class="btn btn-outline" onclick="loadMoreReviews()">
                    더 많은 리뷰 보기 <i class="bi bi-chevron-down ms-1"></i>
                </button>
            </div>
        </div>

        <!-- 문의 섹션 -->
        <div class="inquiry-section mt-5">
            <div class="inquiry-header">
                <h3><i class="bi bi-chat-dots me-2"></i>숙소 문의</h3>
                <p class="text-muted">숙소에 대해 궁금한 점이 있으신가요? 숙소에 직접 문의해보세요.</p>
            </div>

            <!-- 숙소 정보 -->
            <div class="seller-info-card">
                <div class="seller-profile">
                    <div class="seller-logo">
                        <i class="bi bi-building"></i>
                    </div>
                    <div class="seller-details">
                        <h4>그랜드 하얏트 제주</h4>
                        <div class="seller-meta">
                            <span><i class="bi bi-patch-check-fill text-primary"></i> 공식 숙소</span>
                            <span><i class="bi bi-star-fill text-warning"></i> 4.8</span>
                            <span><i class="bi bi-chat-dots"></i> 응답률 99%</span>
                        </div>
                        <p class="seller-desc">제주 중문 관광단지에 위치한 5성급 럭셔리 리조트입니다.</p>
                    </div>
                </div>
                <div class="seller-contact">
                    <span><i class="bi bi-clock"></i> 평균 응답시간: 30분 이내</span>
                </div>
            </div>

            <!-- 문의 작성 -->
            <div class="inquiry-form-card">
                <h4><i class="bi bi-pencil-square me-2"></i>문의하기</h4>
                <form id="inquiryForm">
                    <div class="form-group">
                        <label class="form-label">문의 유형</label>
                        <select class="form-control form-select" id="inquiryType" required>
                            <option value="">문의 유형을 선택하세요</option>
                            <option value="room">객실 문의</option>
                            <option value="facility">시설/서비스 문의</option>
                            <option value="booking">예약 문의</option>
                            <option value="cancel">취소/환불 문의</option>
                            <option value="other">기타 문의</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">문의 내용</label>
                        <textarea class="form-control" id="inquiryContent" rows="4"
                                  placeholder="문의하실 내용을 작성해주세요." required></textarea>
                        <small class="text-muted">개인정보(연락처, 주소 등)는 입력하지 마세요.</small>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" class="form-check-input" id="inquirySecret">
                        <label class="form-check-label" for="inquirySecret">비밀글로 문의하기</label>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-send me-2"></i>문의 등록
                    </button>
                </form>
            </div>

            <!-- 문의 목록 -->
            <div class="inquiry-list-card">
                <div class="inquiry-list-header">
                    <h4><i class="bi bi-list-ul me-2"></i>문의 내역 <span class="inquiry-count">(24)</span></h4>
                </div>
                <div class="inquiry-list">
                    <!-- 문의 아이템 1 -->
                    <div class="inquiry-item">
                        <div class="inquiry-item-header">
                            <div class="inquiry-item-info">
                                <span class="inquiry-type-badge room">객실 문의</span>
                                <span class="inquiry-author">ocean_v**</span>
                                <span class="inquiry-date">2024.03.18</span>
                            </div>
                            <span class="inquiry-status answered">답변완료</span>
                        </div>
                        <div class="inquiry-item-question">
                            <p><strong>Q.</strong> 오션뷰 스위트룸에서 일출을 볼 수 있나요?</p>
                        </div>
                        <div class="inquiry-item-answer">
                            <div class="answer-header">
                                <span class="answer-badge"><i class="bi bi-building"></i> 숙소 답변</span>
                                <span class="answer-date">2024.03.18</span>
                            </div>
                            <p><strong>A.</strong> 안녕하세요, 그랜드 하얏트 제주입니다. 오션뷰 스위트룸은 동쪽을 향하고 있어
                            아름다운 일출을 감상하실 수 있습니다. 특히 맑은 날에는 성산일출봉까지 보이는 멋진 전망을 즐기실 수 있습니다.</p>
                        </div>
                    </div>

                    <!-- 문의 아이템 2 -->
                    <div class="inquiry-item">
                        <div class="inquiry-item-header">
                            <div class="inquiry-item-info">
                                <span class="inquiry-type-badge facility">시설/서비스</span>
                                <span class="inquiry-author">family_t**</span>
                                <span class="inquiry-date">2024.03.15</span>
                            </div>
                            <span class="inquiry-status answered">답변완료</span>
                        </div>
                        <div class="inquiry-item-question">
                            <p><strong>Q.</strong> 아이들을 위한 키즈 프로그램이 있나요? 7살, 5살 아이와 함께 갑니다.</p>
                        </div>
                        <div class="inquiry-item-answer">
                            <div class="answer-header">
                                <span class="answer-badge"><i class="bi bi-building"></i> 숙소 답변</span>
                                <span class="answer-date">2024.03.15</span>
                            </div>
                            <p><strong>A.</strong> 네, 저희 호텔에서는 키즈 클럽을 운영하고 있습니다.
                            만 4세~12세 아동을 위한 다양한 프로그램이 준비되어 있으며, 전문 스태프가 안전하게 돌봐드립니다.
                            이용 시간은 09:00~18:00이며, 투숙객은 무료로 이용 가능합니다.</p>
                        </div>
                    </div>

                    <!-- 문의 아이템 3 (답변대기) -->
                    <div class="inquiry-item" data-inquiry-id="3">
                        <div class="inquiry-item-header">
                            <div class="inquiry-item-info">
                                <span class="inquiry-type-badge booking">예약 문의</span>
                                <span class="inquiry-author">travel_**</span>
                                <span class="inquiry-date">2024.03.20</span>
                            </div>
                            <span class="inquiry-status waiting">답변대기</span>
                        </div>
                        <div class="inquiry-item-question">
                            <p><strong>Q.</strong> 얼리 체크인(13시)이 가능한가요? 비행기가 아침에 도착해서요.</p>
                        </div>
                        <!-- 기업회원 답변 영역 -->
                        <c:if test="${sessionScope.loginUser.userType eq 'BUSINESS'}">
                        <div class="business-reply-section">
                            <button class="btn btn-sm btn-primary" onclick="toggleReplyForm(3)">
                                <i class="bi bi-reply me-1"></i>답변하기
                            </button>
                            <div class="reply-form" id="replyForm_3" style="display: none;">
                                <textarea class="form-control" id="replyContent_3" rows="3"
                                          placeholder="답변 내용을 입력하세요..."></textarea>
                                <div class="reply-form-actions">
                                    <button class="btn btn-sm btn-outline" onclick="toggleReplyForm(3)">취소</button>
                                    <button class="btn btn-sm btn-primary" onclick="submitReply(3)">답변 등록</button>
                                </div>
                            </div>
                        </div>
                        </c:if>
                    </div>
                </div>

                <!-- 더보기 버튼 -->
                <div class="inquiry-more">
                    <button class="btn btn-outline" onclick="loadMoreInquiries()">
                        더 많은 문의 보기 <i class="bi bi-chevron-down ms-1"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
/* 숙박 상세 페이지 스타일 */
.accommodation-detail-page {
    padding: 20px 0 60px;
    background: #f8fafc;
}

/* 갤러리 */
.accommodation-gallery {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 12px;
    margin-bottom: 32px;
    border-radius: 16px;
    overflow: hidden;
}

.gallery-main {
    position: relative;
    height: 400px;
}

.gallery-main img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.gallery-badge {
    position: absolute;
    bottom: 16px;
    left: 16px;
    background: rgba(0,0,0,0.6);
    color: white;
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 13px;
}

.gallery-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
}

.gallery-grid img {
    width: 100%;
    height: calc(200px - 6px);
    object-fit: cover;
    cursor: pointer;
    transition: opacity 0.2s;
}

.gallery-grid img:hover {
    opacity: 0.8;
}

.gallery-more {
    position: relative;
    cursor: pointer;
}

.gallery-more img {
    height: calc(200px - 6px);
}

.gallery-more-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0,0,0,0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 24px;
    font-weight: 700;
}

/* 상세 콘텐츠 레이아웃 */
.accommodation-detail-content {
    display: grid;
    grid-template-columns: 1fr 380px;
    gap: 32px;
    align-items: start;
}

.accommodation-info {
    background: white;
    border-radius: 16px;
    padding: 32px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

/* 배지 */
.accommodation-badges {
    display: flex;
    gap: 8px;
}

.badge-type {
    background: var(--primary-color);
    color: white;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 500;
}

.badge-star {
    background: #fef3c7;
    color: #b45309;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 500;
}

.accommodation-info h1 {
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 12px;
}

.accommodation-meta {
    display: flex;
    gap: 20px;
    color: #666;
    font-size: 14px;
    margin-bottom: 24px;
}

.accommodation-meta span {
    display: flex;
    align-items: center;
    gap: 6px;
}

/* 체크인/아웃 정보 */
.checkin-info {
    display: flex;
    align-items: center;
    gap: 24px;
    padding: 20px;
    background: #f0f9ff;
    border-radius: 12px;
    margin-bottom: 32px;
}

.checkin-item {
    display: flex;
    align-items: center;
    gap: 12px;
}

.checkin-item i {
    font-size: 24px;
    color: var(--primary-color);
}

.checkin-item .label {
    display: block;
    font-size: 12px;
    color: #666;
}

.checkin-item .time {
    display: block;
    font-size: 18px;
    font-weight: 700;
    color: #333;
}

.checkin-divider {
    width: 1px;
    height: 40px;
    background: #ddd;
}

/* 섹션 */
.accommodation-section {
    padding-bottom: 24px;
    margin-bottom: 24px;
    border-bottom: 1px solid #eee;
}

.accommodation-section h3 {
    font-size: 18px;
    font-weight: 700;
    margin-bottom: 16px;
    display: flex;
    align-items: center;
}

/* 편의시설 */
.amenities-list {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 16px;
}

.amenity-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    padding: 16px;
    background: #f8fafc;
    border-radius: 12px;
    font-size: 13px;
    color: #666;
    text-align: center;
}

.amenity-item i {
    font-size: 24px;
    color: var(--primary-color);
}

/* 객실 카드 */
.room-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.room-card {
    display: grid;
    grid-template-columns: 180px 1fr 160px;
    gap: 20px;
    padding: 20px;
    background: #f8fafc;
    border-radius: 12px;
    border: 1px solid #e2e8f0;
    transition: all 0.2s;
}

.room-card:hover {
    border-color: var(--primary-color);
    box-shadow: 0 4px 12px rgba(74, 144, 217, 0.15);
}

.room-image {
    position: relative;
    height: 120px;
    border-radius: 8px;
    overflow: hidden;
}

.room-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.room-image-btn {
    position: absolute;
    bottom: 8px;
    right: 8px;
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: rgba(0,0,0,0.6);
    color: white;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
}

.room-info h4 {
    font-size: 16px;
    font-weight: 700;
    margin-bottom: 8px;
}

.room-details {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    font-size: 13px;
    color: #666;
    margin-bottom: 8px;
}

.room-details span {
    display: flex;
    align-items: center;
    gap: 4px;
}

.room-features {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-bottom: 8px;
}

.room-features .feature {
    font-size: 12px;
    color: #10b981;
    background: #ecfdf5;
    padding: 2px 8px;
    border-radius: 4px;
}

.room-stock {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    font-size: 12px;
    font-weight: 500;
    padding: 4px 10px;
    border-radius: 4px;
}

.room-stock.available {
    color: #10b981;
    background: #ecfdf5;
}

.room-stock.low {
    color: #f59e0b;
    background: #fffbeb;
}

.room-stock.soldout {
    color: #ef4444;
    background: #fef2f2;
}

.room-price {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-end;
    gap: 12px;
}

.room-price .price-info {
    text-align: right;
}

.room-price .original-price {
    display: block;
    font-size: 13px;
    color: #999;
    text-decoration: line-through;
}

.room-price .sale-price {
    font-size: 20px;
    font-weight: 700;
    color: #333;
}

.room-price .per-night {
    font-size: 13px;
    color: #666;
}

/* 예약 사이드바 */
.booking-sidebar {
    position: sticky;
    top: 100px;
}

.booking-card {
    background: white;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
}

.booking-price {
    margin-bottom: 24px;
}

.booking-price .price-label {
    display: block;
    font-size: 13px;
    color: #666;
    margin-bottom: 4px;
}

.booking-price .price {
    font-size: 28px;
    font-weight: 700;
    color: var(--primary-color);
}

.booking-price .per-person {
    font-size: 14px;
    color: #666;
}

.booking-form .form-group {
    margin-bottom: 16px;
}

.booking-form .form-label {
    font-weight: 600;
    margin-bottom: 8px;
}

/* 인원 선택 */
.guest-selector {
    background: #f8fafc;
    border-radius: 8px;
    padding: 12px;
}

.guest-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 0;
}

.guest-row:not(:last-child) {
    border-bottom: 1px solid #e2e8f0;
}

.guest-counter {
    display: flex;
    align-items: center;
    gap: 12px;
}

.guest-counter button {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: 1px solid #ddd;
    background: white;
    cursor: pointer;
    font-size: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.guest-counter button:hover {
    border-color: var(--primary-color);
    color: var(--primary-color);
}

.guest-counter span {
    font-weight: 600;
    min-width: 24px;
    text-align: center;
}

/* 선택한 객실 정보 */
.selected-room-info {
    background: #f0f9ff;
    border-radius: 8px;
    padding: 12px;
    margin-bottom: 16px;
}

.selected-room-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
    font-size: 12px;
    color: #666;
}

.btn-remove-room {
    width: 24px;
    height: 24px;
    border-radius: 50%;
    border: none;
    background: #fee2e2;
    color: #ef4444;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
}

.selected-room-name {
    font-weight: 600;
    margin-bottom: 4px;
}

.selected-room-price {
    font-size: 18px;
    font-weight: 700;
    color: var(--primary-color);
}

.booking-total {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 0;
    border-top: 1px solid #eee;
    margin-bottom: 16px;
}

.booking-total-label {
    font-weight: 600;
}

.booking-total-price {
    font-size: 24px;
    font-weight: 700;
    color: var(--primary-color);
}

.booking-actions {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

/* 리뷰 섹션 */
.review-section {
    background: white;
    border-radius: 16px;
    padding: 32px;
    margin-bottom: 32px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

.review-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    padding-bottom: 16px;
    border-bottom: 1px solid #eee;
}

.review-header h3 {
    font-size: 20px;
    font-weight: 700;
    margin: 0;
}

.review-score {
    display: flex;
    align-items: center;
    gap: 12px;
}

.review-score .score {
    font-size: 32px;
    font-weight: 700;
    color: #333;
}

.review-score .stars {
    color: #fbbf24;
}

.review-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.review-item {
    padding: 20px;
    background: #f8fafc;
    border-radius: 12px;
}

.review-item-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 12px;
}

.reviewer-info {
    display: flex;
    align-items: center;
    gap: 12px;
}

.reviewer-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: #e2e8f0;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #666;
}

.reviewer-name {
    font-weight: 600;
    display: block;
}

.review-date {
    font-size: 12px;
    color: #999;
}

.review-rating {
    color: #fbbf24;
}

.review-room {
    font-size: 12px;
    color: #666;
    margin-bottom: 12px;
    padding: 6px 12px;
    background: white;
    border-radius: 6px;
    display: inline-block;
}

.review-content p {
    margin: 0;
    line-height: 1.6;
    color: #333;
}

.review-images {
    display: flex;
    gap: 8px;
    margin-top: 12px;
}

.review-images img {
    width: 80px;
    height: 80px;
    object-fit: cover;
    border-radius: 8px;
    cursor: pointer;
}

.review-more {
    text-align: center;
    margin-top: 24px;
}

/* ==================== 문의 섹션 ==================== */
.inquiry-section {
    margin-bottom: 60px;
}

.inquiry-header {
    margin-bottom: 24px;
}

.inquiry-header h3 {
    font-size: 22px;
    font-weight: 700;
    margin-bottom: 8px;
    display: flex;
    align-items: center;
}

.inquiry-header h3 i {
    color: var(--primary-color);
}

/* 판매자 정보 카드 */
.seller-info-card {
    background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
    border-radius: 16px;
    padding: 24px;
    margin-bottom: 24px;
    border: 1px solid #e2e8f0;
}

.seller-profile {
    display: flex;
    gap: 20px;
    align-items: flex-start;
}

.seller-logo {
    width: 64px;
    height: 64px;
    background: white;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 28px;
    color: var(--primary-color);
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    flex-shrink: 0;
}

.seller-details h4 {
    font-size: 18px;
    font-weight: 700;
    margin-bottom: 8px;
}

.seller-meta {
    display: flex;
    flex-wrap: wrap;
    gap: 16px;
    margin-bottom: 8px;
    font-size: 13px;
    color: #666;
}

.seller-meta span {
    display: flex;
    align-items: center;
    gap: 4px;
}

.seller-desc {
    font-size: 14px;
    color: #666;
    margin: 0;
}

.seller-contact {
    margin-top: 16px;
    padding-top: 16px;
    border-top: 1px solid #ddd;
    font-size: 13px;
    color: #666;
}

.seller-contact i {
    margin-right: 4px;
}

/* 문의 작성 카드 */
.inquiry-form-card {
    background: white;
    border-radius: 16px;
    padding: 24px;
    margin-bottom: 24px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    border: 1px solid #eee;
}

.inquiry-form-card h4 {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
}

.inquiry-form-card h4 i {
    color: var(--primary-color);
}

.inquiry-form-card .form-group {
    margin-bottom: 16px;
}

.inquiry-form-card .form-label {
    font-weight: 500;
    margin-bottom: 8px;
}

.inquiry-form-card .btn-primary {
    padding: 12px 24px;
}

/* 문의 목록 카드 */
.inquiry-list-card {
    background: white;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    border: 1px solid #eee;
}

.inquiry-list-header {
    margin-bottom: 20px;
    padding-bottom: 16px;
    border-bottom: 1px solid #eee;
}

.inquiry-list-header h4 {
    font-size: 18px;
    font-weight: 600;
    margin: 0;
    display: flex;
    align-items: center;
}

.inquiry-list-header h4 i {
    color: var(--primary-color);
}

.inquiry-count {
    color: #666;
    font-weight: 400;
}

/* 문의 아이템 */
.inquiry-item {
    padding: 20px;
    background: #f8fafc;
    border-radius: 12px;
    margin-bottom: 16px;
}

.inquiry-item:last-child {
    margin-bottom: 0;
}

.inquiry-item-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
    flex-wrap: wrap;
    gap: 8px;
}

.inquiry-item-info {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
}

.inquiry-type-badge {
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
}

.inquiry-type-badge.room {
    background: #dbeafe;
    color: #1d4ed8;
}

.inquiry-type-badge.facility {
    background: #dcfce7;
    color: #15803d;
}

.inquiry-type-badge.booking {
    background: #fef3c7;
    color: #b45309;
}

.inquiry-type-badge.cancel {
    background: #fee2e2;
    color: #dc2626;
}

.inquiry-type-badge.other {
    background: #e5e7eb;
    color: #4b5563;
}

.inquiry-author {
    font-size: 13px;
    color: #666;
}

.inquiry-date {
    font-size: 12px;
    color: #999;
}

.secret-badge {
    font-size: 12px;
    color: #666;
    display: flex;
    align-items: center;
    gap: 4px;
}

.inquiry-status {
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
}

.inquiry-status.answered {
    background: #dcfce7;
    color: #15803d;
}

.inquiry-status.waiting {
    background: #fef3c7;
    color: #b45309;
}

.inquiry-item-question p {
    margin: 0;
    font-size: 14px;
    line-height: 1.6;
    color: #333;
}

.inquiry-item-question strong {
    color: var(--primary-color);
}

.secret-content {
    color: #999 !important;
    font-style: italic;
}

/* 답변 스타일 */
.inquiry-item-answer {
    margin-top: 16px;
    padding: 16px;
    background: white;
    border-radius: 10px;
    border-left: 3px solid var(--primary-color);
}

.answer-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}

.answer-badge {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    font-weight: 600;
    color: var(--primary-color);
}

.answer-date {
    font-size: 12px;
    color: #999;
}

.inquiry-item-answer p {
    margin: 0;
    font-size: 14px;
    line-height: 1.6;
    color: #333;
}

.inquiry-item-answer strong {
    color: #10b981;
}

/* 더보기 버튼 */
.inquiry-more {
    text-align: center;
    margin-top: 20px;
}

.inquiry-more .btn-outline {
    padding: 10px 24px;
}

/* 기업회원 답변 영역 */
.business-reply-section {
    margin-top: 16px;
    padding-top: 16px;
    border-top: 1px dashed #ddd;
}

.reply-form {
    margin-top: 12px;
    animation: slideIn 0.2s ease-out;
}

.reply-form textarea {
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 12px;
    font-size: 14px;
    resize: none;
}

.reply-form textarea:focus {
    border-color: var(--primary-color);
    outline: none;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
}

.reply-form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    margin-top: 10px;
}

.reply-form-actions .btn-sm {
    padding: 6px 16px;
    font-size: 13px;
}

/* 문의 애니메이션 */
@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.new-inquiry {
    border: 2px solid var(--primary-color);
    background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
}

/* 문의 섹션 반응형 */
@media (max-width: 768px) {
    .seller-profile {
        flex-direction: column;
        align-items: center;
        text-align: center;
    }

    .seller-meta {
        justify-content: center;
    }

    .inquiry-item-header {
        flex-direction: column;
        align-items: flex-start;
    }

    .inquiry-item-info {
        margin-bottom: 8px;
    }
}

/* 반응형 */
@media (max-width: 1200px) {
    .accommodation-detail-content {
        grid-template-columns: 1fr;
    }

    .booking-sidebar {
        position: static;
    }
}

@media (max-width: 768px) {
    .accommodation-gallery {
        grid-template-columns: 1fr;
    }

    .gallery-main {
        height: 250px;
    }

    .gallery-grid {
        display: none;
    }

    .room-card {
        grid-template-columns: 1fr;
    }

    .room-image {
        height: 180px;
    }

    .room-price {
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
    }

    .amenities-list {
        grid-template-columns: repeat(3, 1fr);
    }

    .checkin-info {
        flex-wrap: wrap;
        justify-content: center;
    }
}
</style>

<script>
// 현재 숙소 정보
var currentAccommodation = {
    id: '1',
    name: '그랜드 하얏트 제주',
    minPrice: 220000
};

// 선택한 객실 정보
var selectedRoom = null;
var guests = {
    adult: 2,
    child: 0
};
var nights = 0;

// 이미지 변경
function changeMainImage(thumb, index) {
    document.getElementById('mainImage').src = thumb.src.replace('w=300&h=200', 'w=800&h=500');
    document.querySelector('.gallery-badge').textContent = index + '/12';
}

// 갤러리 모달 열기
function openGalleryModal() {
    // TODO: 갤러리 모달 구현
    showToast('갤러리를 불러오는 중...', 'info');
}

// 객실 갤러리 열기
function openRoomGallery(roomId) {
    // TODO: 객실 갤러리 모달 구현
    showToast('객실 사진을 불러오는 중...', 'info');
}

// 인원 업데이트
function updateGuest(type, delta) {
    if (type === 'adult') {
        guests.adult = Math.max(1, Math.min(10, guests.adult + delta));
        document.getElementById('adultCount').textContent = guests.adult;
    } else {
        guests.child = Math.max(0, Math.min(5, guests.child + delta));
        document.getElementById('childCount').textContent = guests.child;
    }
    updateTotalPrice();
}

// 객실 선택
function selectRoom(roomId, roomName, price) {
    selectedRoom = {
        id: roomId,
        name: roomName,
        price: price
    };

    // 모든 객실 카드에서 선택 표시 제거
    document.querySelectorAll('.room-card').forEach(function(card) {
        card.classList.remove('selected');
    });

    // 선택한 객실 카드에 표시
    document.querySelector('.room-card[data-room-id="' + roomId + '"]').classList.add('selected');

    // 선택 정보 표시
    document.getElementById('selectedRoomInfo').style.display = 'block';
    document.getElementById('selectedRoomName').textContent = roomName;
    document.getElementById('selectedRoomPrice').textContent = price.toLocaleString() + '원 / 1박';

    // 예약 버튼 활성화
    document.getElementById('bookingBtn').disabled = false;

    updateTotalPrice();
    showToast(roomName + ' 객실이 선택되었습니다.', 'success');
}

// 선택 객실 취소
function clearSelectedRoom() {
    selectedRoom = null;

    document.querySelectorAll('.room-card').forEach(function(card) {
        card.classList.remove('selected');
    });

    document.getElementById('selectedRoomInfo').style.display = 'none';
    document.getElementById('bookingBtn').disabled = true;
    document.getElementById('totalPrice').textContent = '-';
}

// 총 금액 업데이트
function updateTotalPrice() {
    if (!selectedRoom || nights <= 0) {
        document.getElementById('totalPrice').textContent = '-';
        return;
    }

    var total = selectedRoom.price * nights;
    document.getElementById('totalPrice').textContent = total.toLocaleString() + '원';
}

// 날짜 선택기 초기화
document.addEventListener('DOMContentLoaded', function() {
    if (typeof flatpickr !== 'undefined') {
        var checkInPicker = flatpickr('#checkInDate', {
            locale: 'ko',
            dateFormat: 'Y-m-d',
            minDate: 'today',
            disableMobile: true,
            onChange: function(selectedDates) {
                if (selectedDates.length > 0) {
                    checkOutPicker.set('minDate', new Date(selectedDates[0].getTime() + 86400000));
                    calculateNights();
                }
            }
        });

        var checkOutPicker = flatpickr('#checkOutDate', {
            locale: 'ko',
            dateFormat: 'Y-m-d',
            minDate: new Date(new Date().getTime() + 86400000),
            disableMobile: true,
            onChange: function() {
                calculateNights();
            }
        });
    }
});

// 숙박일 계산
function calculateNights() {
    var checkIn = document.getElementById('checkInDate').value;
    var checkOut = document.getElementById('checkOutDate').value;

    if (checkIn && checkOut) {
        var date1 = new Date(checkIn);
        var date2 = new Date(checkOut);
        nights = Math.ceil((date2 - date1) / (1000 * 60 * 60 * 24));

        if (nights > 0) {
            updateTotalPrice();
        }
    }
}

// 북마크 추가
function addToBookmark() {
    var isLoggedIn = ${not empty sessionScope.loginUser};

    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    showToast('북마크에 추가되었습니다.', 'success');
}

// 예약 폼 제출
document.getElementById('bookingForm').addEventListener('submit', function(e) {
    e.preventDefault();

    var isLoggedIn = ${not empty sessionScope.loginUser};

    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    var checkIn = document.getElementById('checkInDate').value;
    var checkOut = document.getElementById('checkOutDate').value;

    if (!checkIn || !checkOut) {
        showToast('체크인/체크아웃 날짜를 선택해주세요.', 'warning');
        return;
    }

    if (!selectedRoom) {
        showToast('객실을 선택해주세요.', 'warning');
        return;
    }

    // 예약 페이지로 이동
    window.location.href = '${pageContext.request.contextPath}/product/accommodation/1/booking' +
        '?checkIn=' + checkIn +
        '&checkOut=' + checkOut +
        '&roomId=' + selectedRoom.id +
        '&adults=' + guests.adult +
        '&children=' + guests.child;
});

// 더 많은 리뷰 불러오기
function loadMoreReviews() {
    showToast('리뷰를 불러오는 중...', 'info');
    // TODO: API 호출
}

// ==================== 문의 기능 ====================

// 문의 폼 제출
document.getElementById('inquiryForm').addEventListener('submit', function(e) {
    e.preventDefault();

    var isLoggedIn = ${not empty sessionScope.loginUser};
    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    var inquiryType = document.getElementById('inquiryType').value;
    var inquiryContent = document.getElementById('inquiryContent').value;

    if (!inquiryType) {
        showToast('문의 유형을 선택해주세요.', 'warning');
        return;
    }

    if (inquiryContent.trim().length < 10) {
        showToast('문의 내용을 10자 이상 입력해주세요.', 'warning');
        return;
    }

    // TODO: API 호출
    showToast('문의가 등록되었습니다.', 'success');
    document.getElementById('inquiryForm').reset();
});

// 더 많은 문의 불러오기
function loadMoreInquiries() {
    showToast('문의를 불러오는 중...', 'info');
    // TODO: API 호출
}

// 답변 폼 토글
function toggleReplyForm(inquiryId) {
    var form = document.getElementById('replyForm_' + inquiryId);
    var btn = form.previousElementSibling;

    if (form.style.display === 'none') {
        form.style.display = 'block';
        btn.style.display = 'none';
    } else {
        form.style.display = 'none';
        btn.style.display = 'inline-flex';
    }
}

// 답변 등록
function submitReply(inquiryId) {
    var content = document.getElementById('replyContent_' + inquiryId).value.trim();

    if (content.length < 10) {
        showToast('답변은 10자 이상 입력해주세요.', 'warning');
        return;
    }

    // TODO: API 호출
    showToast('답변이 등록되었습니다.', 'success');
}
</script>

<%@ include file="../common/footer.jsp" %>
