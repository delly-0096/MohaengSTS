<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="${acc.accName}" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/accommodation-detail.css">
<sec:authorize access="isAuthenticated()"><sec:authentication property="principal" var="user" /></sec:authorize>

<div class="accommodation-detail-page">
    <div class="container">
        <!-- 브레드크럼 -->
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/">홈</a>
            <span class="mx-2">/</span>
            <a href="${pageContext.request.contextPath}/product/accommodation">숙박</a>
            <span class="mx-2">/</span>
            <span>${acc.accName}</span>
        </nav>

        <!-- 갤러리 -->
        <div class="accommodation-gallery">
            <div class="gallery-main">
                <img src="${acc.accFilePath}"
                     alt="${acc.accName}" id="mainImage">
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
                        <span class="badge-type">
                        ${acc.accCatCd eq 'B02010700' ? '호텔' : '숙박'}
                        </span>
                        <c:if test="${not empty acc.starGrade}">
					        <span class="badge-star">
					            <i class="bi bi-star-fill"></i> 
					            ${acc.starGrade}성급
					        </span>
					    </c:if>
                    </div>
                    <sec:authorize access="hasRole('MEMBER')" var="isUser">
                    <button class="report-btn" onclick="reportAccommodation()">
					    <i class="bi bi-flag"></i> 신고
					</button>
                    </sec:authorize>
                </div>
                <h1>${acc.accName}</h1>

                <div class="acc-meta">
                    <span><i class="bi bi-geo-alt"></i> ${acc.addr1}${not empty acc.addr2 ? ' ' : ''}${acc.addr2}</span>
                    <span><i class="bi bi-star-fill text-warning"></i> ${reviewStat.avgRating > 0 ? reviewStat.avgRating : '-'} (${reviewStat.reviewCount} 리뷰)</span>
                </div>

                <!-- 체크인/아웃 정보 -->
                <div class="checkin-info">
                    <div class="checkin-item">
                        <i class="bi bi-box-arrow-in-right"></i>
                        <div>
                            <span class="label">체크인</span>
                            <span class="time">${acc.checkInTime }</span>
                        </div>
                    </div>
                    <div class="checkin-divider"></div>
                    <div class="checkin-item">
                        <i class="bi bi-box-arrow-right"></i>
                        <div>
                            <span class="label">체크아웃</span>
                            <span class="time">${acc.checkOutTime }</span>
                        </div>
                    </div>
                </div>

                <!-- 숙소 소개 -->
                <div class="accommodation-section">
                    <h3>숙소 소개</h3>
                    <p style="white-space: pre-wrap; line-height: 1.8;">${acc.overview}</p>
                </div>

                <!-- 편의시설 -->
                <div class="acc-section">
                    <h3>편의시설</h3>
                    <div class="amenities-list">
                    <c:if test="${facility.wifiYn eq 'Y'}">
                        <div class="amenity-item">
                            <i class="bi bi-wifi"></i>
                            <span>무료 WiFi</span>
                        </div>
                    </c:if>
                    <c:if test="${facility.parkingYn eq 'Y'}">
                        <div class="amenity-item">
                            <i class="bi bi-p-circle"></i>
                            <span>무료 주차</span>
                        </div>
                    </c:if>
                    <c:if test="${facility.poolYn eq 'Y'}">
                        <div class="amenity-item">
                            <i class="bi bi-water"></i>
                            <span>수영장</span>
                        </div>
                    </c:if>
                    <c:if test="${facility.gymYn eq 'Y'}">
                        <div class="amenity-item">
                            <i class="bi bi-heart-pulse"></i>
                            <span>피트니스</span>
                        </div>
                    </c:if>
                    <c:if test="${facility.spaYn eq 'Y'}">
                        <div class="amenity-item">
                            <i class="bi bi-droplet"></i>
                            <span>스파/사우나</span>
                        </div>
                    </c:if>
                    <c:if test="${facility.breakfastYn eq 'Y'}">
                        <div class="amenity-item">
                            <i class="bi bi-cup-hot"></i>
                            <span>조식 제공</span>
                        </div>
                    </c:if>
                    <c:if test="${facility.restaurantYn eq 'Y'}">
                        <div class="amenity-item">
                            <i class="bi bi-shop"></i>
                            <span>레스토랑</span>
                        </div>
                    </c:if>
                    <c:if test="${facility.barYn eq 'Y'}">
                        <div class="amenity-item">
                            <i class="bi bi-cup-straw"></i>
                            <span>바/라운지</span>
                        </div>
                    </c:if>
                    <c:if test="${facility.roomServiceYn eq 'Y'}">
                        <div class="amenity-item">
                            <i class="bi bi-bell"></i>
                            <span>룸서비스</span>
                        </div>
                    </c:if>
                    <c:if test="${facility.laundryYn eq 'Y'}">
                        <div class="amenity-item">
                            <i class="bi bi-basket"></i>
                            <span>세탁 서비스</span>
                        </div>
					</c:if>
                    <c:if test="${facility.smokingAreaYn eq 'Y'}">
                        <div class="amenity-item">
                            <i class="bi bi-basket"></i>
                            <span>지정 흡연구역</span>
                        </div>
					</c:if>
                    <c:if test="${facility.petFriendlyYn eq 'Y'}">
                        <div class="amenity-item">
                            <i class="bi bi-basket"></i>
                            <span>반려동물 입실 가능</span>
                        </div>
					</c:if>
                    </div>
                </div>

                <!-- 객실 선택 -->
                <div class="acc-section">
                    <h3>객실 선택</h3>
                    <div class="room-list">
                     <c:forEach var="room" items="${roomList}">
                        <div class="room-card" data-room-id="${room.roomTypeNo}">
                            <div class="room-image">
                                <c:choose>
							        <c:when test="${fn:contains(room.roomName, '스위트')}">
							            <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?w=500" alt="스위트룸">
							        </c:when>
							        <c:when test="${fn:contains(room.roomName, '디럭스')}">
							            <img src="https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=500" alt="디럭스룸">
							        </c:when>
							        <c:otherwise>
							            <img src="${acc.accFilePath}" alt="일반객실">
							        </c:otherwise>
							    </c:choose>
                            </div>
                            <div class="room-info">
                                <h4>${room.roomName}</h4>
                                <div class="room-details">
                                    <span><i class="bi bi-people"></i> 기준 ${room.baseGuestCount}인 / 최대 ${room.maxGuestCount}인</span>
                                    <span><i class="bi bi-arrows-fullscreen"></i> ${room.roomSize}㎡</span>
                                    <span><i class="bi bi-moon"></i> 더블 베드 ${room.bedCount}개</span>
                                </div>
                                <div class="room-features">
								    <%-- 1. 전망 시리즈 --%>
								    <c:if test="${room.feature.oceanViewYn eq 'Y'}">
								        <span class="feature"><i class="bi bi-water"></i> 오션뷰</span>
								    </c:if>
								    <c:if test="${room.feature.mountainViewYn eq 'Y'}">
								        <span class="feature"><i class="bi bi-mountain"></i> 마운틴뷰</span>
								    </c:if>
								    <c:if test="${room.feature.cityViewYn eq 'Y'}">
								        <span class="feature"><i class="bi bi-building"></i> 시티뷰</span>
								    </c:if>
								
								    <%-- 2. 객실 구성 시리즈 --%>
								    <c:if test="${room.feature.livingRoomYn eq 'Y'}">
								        <span class="feature"><i class="bi bi-door-open"></i> 거실 포함</span>
								    </c:if>
								    <c:if test="${room.feature.terraceYn eq 'Y'}">
								        <span class="feature"><i class="bi bi-house-door"></i> 테라스</span>
								    </c:if>
								
								    <%-- 3. 서비스/정책 시리즈 --%>
								    <c:if test="${room.feature.kitchenYn eq 'Y'}">
								        <span class="feature"><i class="bi bi-egg-fried"></i> 취사 가능</span>
								    </c:if>
								    <c:if test="${room.feature.nonSmokingYn eq 'Y'}">
								        <span class="feature"><i class="bi bi-no-circle"></i> 금연 객실</span>
								    </c:if>
								    <c:if test="${room.feature.freeCancelYn eq 'Y'}">
								        <span class="feature text-primary" style="background: #e0f2fe;">
								            <i class="bi bi-check-circle"></i> 무료 취소
								        </span>
								    </c:if>
								</div>
                                <div class="room-stock available">
                                    <i class="bi bi-check-circle"></i> 잔여 5실
                                </div>
                            </div>
                            <div class="room-price">
							    <div class="price-info">
							        <c:set var="calculatedFinalPrice" value="${room.price * (100 - room.discount) / 100}" />
							        <c:choose>
							            <%-- 2. 할인이 있을 때 (discount > 0) --%>
							            <c:when test="${room.discount > 0}">
							                <span class="original-price" style="text-decoration: line-through; color: #999; font-size: 0.9em;">
							                    <fmt:formatNumber value="${room.price}" type="number"/>원
							                </span>
							                <span class="sale-price" style="color: #ff5a5f; font-weight: bold; font-size: 1.2em;">
							                    <fmt:formatNumber value="${calculatedFinalPrice}" type="number"/>원
							                </span>
							            </c:when>
							
							            <%-- 3. 할인이 없을 때 (0원이거나 null일 때) --%>
							            <c:otherwise>
							                <span class="sale-price" style="color: #333; font-weight: bold; font-size: 1.2em;">
							                    <fmt:formatNumber value="${room.price}" type="number"/>원
							                </span>
							            </c:otherwise>
							        </c:choose>
							
							        <span class="per-night">/ 1박</span>
							    </div>
							
							    <sec:authorize access="hasRole('MEMBER')" var="isUser">
							        <button class="btn btn-primary btn-sm" 
							                onclick="selectRoom('${room.roomTypeNo}', '${room.roomName}', ${calculatedFinalPrice}, ${room.baseGuestCount}, ${room.extraGuestFee})">
							            객실 선택
							        </button>
							    </sec:authorize>
							</div>
                        </div>
                        </c:forEach>
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
			                <span class="price" id="minPriceDisplay">
			                    <span class="price" id="minPriceDisplay">
								    <c:choose>
								        <c:when test="${not empty acc.minPrice and acc.minPrice > 0}">
								            <fmt:formatNumber value="${acc.finalPrice}" type="number"/>
								        </c:when>
								        <c:otherwise>
								            판매중지
								        </c:otherwise>
								    </c:choose>
								</span>
			                </span>
			                <span class="per-person">원~ / 1박</span>
			            </div>
			        </div>
			
			        <form class="booking-form" id="bookingForm" onsubmit="handleBookingSubmit(event)">
			            <div class="form-group">
			                <label class="form-label">체크인</label>
			                <input type="text" class="form-control date-picker" id="checkInDate"
			                       placeholder="체크인 날짜" onchange="calculateNights()" required>
			            </div>
			
			            <div class="form-group">
			                <label class="form-label">체크아웃</label>
			                <input type="text" class="form-control date-picker" id="checkOutDate"
			                       placeholder="체크아웃 날짜" onchange="calculateNights()" required>
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
			
			            <div class="selected-room-info" id="selectedRoomInfo" style="display: none; border: 2px solid var(--primary-color); padding: 10px; border-radius: 8px;">
			                <div class="selected-room-header" style="margin-bottom: 10px; border-bottom: 1px solid #eee; padding-bottom: 5px;">
			                    <strong>선택한 객실</strong>
			                </div>
			                <div id="selectedRoomList"></div>
			                <div id="nightStayCount" class="text-muted small mt-2" style="text-align: right;"></div>
			            </div>
			
			            <div class="booking-total">
			                <span class="booking-total-label">총 결제 금액</span>
			                <span class="booking-total-price" id="totalPrice">-</span>
			            </div>
			
			            <div class="booking-actions">
			                <sec:authorize access="hasRole('MEMBER')" var="isUser">
			                    <button type="button" class="btn btn-outline w-100 mb-2" onclick="addToBookmark()">
			                        <i class="bi bi-bookmark me-2"></i>북마크
			                    </button>
			                    <button type="submit" class="btn btn-primary w-100" id="bookingBtn" disabled>
			                        <i class="bi bi-credit-card me-2"></i>결제하기
			                    </button>
			                </sec:authorize>
			                <sec:authorize access="hasRole('BUSINESS')" var="isBusiness">
			                    <div class="business-notice mt-2 text-center">
			                        <small class="text-muted"><i class="bi bi-info-circle me-1"></i>기업회원은 예약이 불가합니다.</small>
			                    </div>
			                </sec:authorize>
			            </div>
			        </form>
			    </div>
			</aside>
        </div>

        <!-- 리뷰 섹션 -->
        <div class="review-section mt-5">
            <div class="review-header">
                <h3><i class="bi bi-star me-2"></i>리뷰 (${reviewStat.reviewCount})</h3>
                <div class="review-summary">
                    <div class="review-score">
                        <span class="score">${reviewStat.avgRating > 0 ? reviewStat.avgRating : '-'}</span>
                        <div class="stars">
		                    <c:set var="rating" value="${reviewStat.avgRating != null ? reviewStat.avgRating : 0}" />
		                    <fmt:parseNumber var="fullStars" value="${rating}" integerOnly="true" />
		                    <c:set var="decimal" value="${rating - fullStars}" />
		                    
		                    <c:forEach begin="1" end="5" var="i">
		                        <c:choose>
		                            <c:when test="${i <= fullStars}">
		                                <i class="bi bi-star-fill"></i>
		                            </c:when>
		                            <c:when test="${i == fullStars + 1 && decimal >= 0.5}">
		                                <i class="bi bi-star-half"></i>
		                            </c:when>
		                            <c:otherwise>
		                                <i class="bi bi-star"></i>
		                            </c:otherwise>
		                        </c:choose>
		                    </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <div class="review-list" id="reviewList">
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
                        <h4>${acc.accName }</h4>
                        <div class="seller-meta">
                            <span><i class="bi bi-star-fill text-warning"></i> ${seller.avgRating > 0 ? seller.avgRating : '-'}</span>
			                <span><i class="bi bi-chat-dots"></i> 응답률 <fmt:formatNumber value="${seller.responseRate}" maxFractionDigits="0"/>%</span>
                        </div>
			            <c:choose>
			                <c:when test="${not empty seller.compIntro}">
			                    <p class="seller-desc">${seller.compIntro}</p>
			                </c:when>
			                <c:otherwise>
			                    <p class="seller-desc text-muted">업체 소개가 등록되지 않았습니다.</p>
			                </c:otherwise>
			            </c:choose>
                    </div>
                </div>
                <div class="seller-contact">
                     <span><i class="bi bi-clock"></i> 평균 응답시간: 
			            <c:choose>
			                <c:when test="${seller.answeredCount == 0 || seller.totalInquiryCount == 0}">정보 없음</c:when>
			                <c:when test="${seller.avgResponseTime < 1}">1시간 이내</c:when>
			                <c:when test="${seller.avgResponseTime < 24}"><fmt:formatNumber value="${seller.avgResponseTime}" maxFractionDigits="0"/>시간 이내</c:when>
			                <c:otherwise><fmt:formatNumber value="${seller.avgResponseTime / 24}" maxFractionDigits="0"/>일 이내</c:otherwise>
			            </c:choose>
			        </span>
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
			        <h4><i class="bi bi-list-ul me-2"></i>문의 내역 <span class="inquiry-count">(${inquiryCount})</span></h4>
			    </div>
			    <div class="inquiry-list" id="inquiryList">
			        <c:choose>
			            <c:when test="${empty inquiry}">
			                <div class="no-inquiry" style="text-align: center; padding: 40px; color: #999;">
			                    <i class="bi bi-chat-square-text" style="font-size: 48px; opacity: 0.5;"></i>
			                    <p style="margin-top: 16px;">아직 문의가 없습니다.</p>
			                </div>
			            </c:when>
			            <c:otherwise>
			                <c:forEach items="${inquiry}" var="inq" varStatus="status">
			                    <div class="inquiry-item" data-inquiry-id="${inq.prodInqryNo}">
			                        <div class="inquiry-item-header">
			                            <div class="inquiry-item-info">
			                                <!-- 문의 유형 뱃지 -->
			                                <c:choose>
			                                    <c:when test="${inq.inquiryCtgry eq 'product'}">
			                                        <span class="inquiry-type-badge product">상품 문의</span>
			                                    </c:when>
			                                    <c:when test="${inq.inquiryCtgry eq 'booking'}">
			                                        <span class="inquiry-type-badge booking">예약/일정</span>
			                                    </c:when>
			                                    <c:when test="${inq.inquiryCtgry eq 'price'}">
			                                        <span class="inquiry-type-badge price">가격/결제</span>
			                                    </c:when>
			                                    <c:when test="${inq.inquiryCtgry eq 'cancel'}">
			                                        <span class="inquiry-type-badge cancel">취소/환불</span>
			                                    </c:when>
			                                    <c:otherwise>
			                                        <span class="inquiry-type-badge other">기타</span>
			                                    </c:otherwise>
			                                </c:choose>
			                                
			                                <!-- 작성자 닉네임 마스킹 -->
			                                <span class="inquiry-author">${inq.inquiryNickname}</span>
			                                <span class="inquiry-date">
			                                    <fmt:formatDate value="${inq.regDt}" pattern="yyyy.MM.dd"/>
			                                </span>
			                                
			                                <!-- 비밀글 표시 -->
			                                <c:if test="${inq.secretYn eq 'Y'}">
			                                    <span class="secret-badge"><i class="bi bi-lock"></i> 비밀글</span>
			                                </c:if>
			                            </div>
			                            
			                            <!-- 답변 상태 -->
			                            <div class="d-flex align-items-center gap-2">
										    <!-- 답변 상태 -->
										    <c:choose>
										        <c:when test="${inq.inqryStatus eq 'DONE'}">
										            <span class="inquiry-status answered">답변완료</span>
										        </c:when>
										        <c:otherwise>
										            <span class="inquiry-status waiting">답변대기</span>
										        </c:otherwise>
										    </c:choose>
										    
										    <c:if test="${loginMemNo == inq.inquiryMemNo && inq.inqryStatus ne 'DONE'}">
										        <div class="dropdown">
										            <button class="btn-more" type="button" data-bs-toggle="dropdown">
										                <i class="bi bi-three-dots-vertical"></i>
										            </button>
										            <ul class="dropdown-menu dropdown-menu-end">
										                <li><a class="dropdown-item" href="javascript:void(0)" onclick="openEditInquiryModal(${inq.prodInqryNo}, '${inq.inquiryCtgry}', '${fn:escapeXml(inq.prodInqryCn)}', '${inq.secretYn}')">
										                    <i class="bi bi-pencil me-2"></i>수정</a></li>
										                <li><a class="dropdown-item text-danger" href="javascript:void(0)" onclick="deleteInquiry(${inq.prodInqryNo})">
										                    <i class="bi bi-trash me-2"></i>삭제</a></li>
										            </ul>
										        </div>
										    </c:if>
										</div>
			                        </div>
			                        
			                        <!-- 문의 내용 -->
			                        <div class="inquiry-item-question">
			                            <c:choose>
			                                <c:when test="${inq.secretYn eq 'Y' && loginMemNo != inq.memNo && !isBusiness}">
			                                    <p class="secret-content"><i class="bi bi-lock me-1"></i>비밀글로 작성된 문의입니다.</p>
			                                </c:when>
			                                <c:otherwise>
			                                    <p><strong>Q.</strong> ${inq.prodInqryCn}</p>
			                                </c:otherwise>
			                            </c:choose>
			                        </div>
			                        
			                        <!-- 답변 내용 (답변완료 시) -->
									<c:if test="${inq.inqryStatus eq 'DONE' && not empty inq.replyCn}">
									    <!-- 비밀글이 아니거나 본인인 경우만 답변 표시 -->
									    <c:if test="${inq.secretYn ne 'Y' || loginMemNo == inq.memNo || isBusiness}">
									    <div class="inquiry-item-answer" id="answer_${inq.prodInqryNo}">
									        <div class="answer-header">
									            <span class="answer-badge"><i class="bi bi-building"></i> 판매자 답변</span>
									            <div class="d-flex align-items-center gap-2">
									                <span class="answer-date">
									                    <fmt:formatDate value="${inq.replyDt}" pattern="yyyy.MM.dd"/>
									                </span>
									                <c:if test="${isBusiness && loginMemNo == inq.replyMemNo}">
									                    <div class="dropdown">
									                        <button class="btn-more btn-more-sm" type="button" data-bs-toggle="dropdown">
									                            <i class="bi bi-three-dots-vertical"></i>
									                        </button>
									                        <ul class="dropdown-menu dropdown-menu-end">
									                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="openEditReplyModal(${inq.prodInqryNo}, '${fn:escapeXml(inq.replyCn)}')">
									                                <i class="bi bi-pencil me-2"></i>수정</a></li>
									                            <li><a class="dropdown-item text-danger" href="javascript:void(0)" onclick="deleteReply(${inq.prodInqryNo})">
									                                <i class="bi bi-trash me-2"></i>삭제</a></li>
									                        </ul>
									                    </div>
									                </c:if>
									            </div>
									        </div>
									        <p class="answer-content"><strong>A.</strong> ${inq.replyCn}</p>
									    </div>
									    </c:if>
									</c:if>
			                        
			                        <!-- 기업회원 답변 영역 (답변대기 상태일 때만) -->
			                       <c:if test="${isBusiness && inq.inqryStatus eq 'WAIT' && loginMemNo == acc.memNo}">
			                        <div class="business-reply-section">
			                            <button class="btn btn-sm btn-primary" onclick="toggleReplyForm(${inq.prodInqryNo})">
			                                <i class="bi bi-reply me-1"></i>답변하기
			                            </button>
			                            <div class="reply-form" id="replyForm_${inq.prodInqryNo}" style="display: none;">
			                                <textarea class="form-control" id="replyContent_${inq.prodInqryNo}" rows="3"
			                                          placeholder="답변 내용을 입력하세요..."></textarea>
			                                <div class="reply-form-actions">
			                                    <button class="btn btn-sm btn-outline" onclick="toggleReplyForm(${inq.prodInqryNo})">취소</button>
			                                    <button class="btn btn-sm btn-primary" onclick="submitReply(${inq.prodInqryNo})">답변 등록</button>
			                                </div>
			                            </div>
			                        </div>
			                        </c:if>
			                    </div>
			                </c:forEach>
			            </c:otherwise>
			        </c:choose>
			    </div>
			
			    <!-- 더보기 버튼: 6개 이상일 때만 표시 -->
			    <c:if test="${inquiryCount > 5}">
			        <div class="inquiry-more" id="inquiryMoreBtn">
			            <button class="btn btn-outline" onclick="loadMoreInquiries()">
			                더 많은 문의 보기 <i class="bi bi-chevron-down ms-1"></i>
			            </button>
			        </div>
			    </c:if>
			</div>
        </div>
    </div>
</div>

<!-- 리뷰 수정 모달 -->
<div class="modal fade" id="editReviewModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-star me-2"></i>리뷰 수정
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="editReviewForm">
                    <input type="hidden" id="editReviewId">
                    
                    <!-- 별점 -->
                    <div class="review-section">
                        <label class="review-label">별점 <span class="text-danger">*</span></label>
                        <div class="star-rating" id="editStarRating">
                            <i class="bi bi-star" data-rating="1"></i>
                            <i class="bi bi-star" data-rating="2"></i>
                            <i class="bi bi-star" data-rating="3"></i>
                            <i class="bi bi-star" data-rating="4"></i>
                            <i class="bi bi-star" data-rating="5"></i>
                        </div>
                        <span class="rating-text" id="editRatingText">별점을 선택해주세요</span>
                        <input type="hidden" id="editReviewRating" value="0">
                    </div>

                    <!-- 후기 내용 -->
                    <div class="review-section">
                        <label class="review-label">후기 내용 <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="editReviewContent" rows="5"
                                  placeholder="상품 이용 경험을 자세히 작성해주세요. (최소 20자 이상)"
                                  minlength="20" maxlength="1000"></textarea>
                        <div class="char-counter">
                            <span id="editReviewCharCount">0</span> / 1000자
                        </div>
                    </div>
                    
                    <!-- 사진 첨부 -->
					<div class="review-section">
					    <label class="review-label">사진 첨부 <span class="text-muted">(선택, 최대 5장)</span></label>
					    <div class="review-image-upload">
					        <input type="file" id="editReviewImages" accept="image/*" multiple style="display: none;">
					        <div class="image-upload-area" onclick="document.getElementById('editReviewImages').click()">
					            <i class="bi bi-camera"></i>
					            <span>사진 추가</span>
					        </div>
					        <div class="image-preview-list" id="editImagePreviewList"></div>
					    </div>
					</div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="updateReview()">
                    <i class="bi bi-check-lg me-1"></i>수정 완료
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 문의 수정 모달 -->
<div class="modal fade" id="editInquiryModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-pencil-square me-2"></i>문의 수정
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="editInquiryForm">
                    <input type="hidden" id="editInquiryId">
                    
                    <div class="form-group mb-3">
                        <label class="form-label">문의 유형</label>
                        <select class="form-control form-select" id="editInquiryType">
                            <option value="product">상품 문의</option>
                            <option value="booking">예약/일정 문의</option>
                            <option value="price">가격/결제 문의</option>
                            <option value="cancel">취소/환불 문의</option>
                            <option value="other">기타 문의</option>
                        </select>
                    </div>
                    <div class="form-group mb-3">
                        <label class="form-label">문의 내용</label>
                        <textarea class="form-control" id="editInquiryContent" rows="4"
                                  placeholder="문의 내용을 입력해주세요."></textarea>
                    </div>
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="editInquirySecret">
                        <label class="form-check-label" for="editInquirySecret">비밀글로 문의하기</label>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="updateInquiry()">
                    <i class="bi bi-check-lg me-1"></i>수정 완료
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 답변 수정 모달 -->
<div class="modal fade" id="editReplyModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-reply me-2"></i>답변 수정
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="editReplyInquiryId">
                <div class="form-group">
                    <label class="form-label">답변 내용</label>
                    <textarea class="form-control" id="editReplyContent" rows="4"
                              placeholder="답변 내용을 입력해주세요."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="updateReply()">
                    <i class="bi bi-check-lg me-1"></i>수정 완료
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 상품 이미지 수정 모달 (기업회원 전용) -->
<sec:authorize access="hasRole('BUSINESS')" var="isBusiness">
<c:if test="${loginMemNo == acc.memNo}">
<div class="modal fade" id="imageUploadModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-images me-2"></i>상품 이미지 관리
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- 현재 이미지 목록 -->
                <div class="current-images-section mb-4">
                    <h6 class="mb-3">현재 등록된 이미지</h6>
                    <div class="current-images-grid" id="currentImagesGrid">
                        <!-- JS로 동적 로드 -->
                        <div class="loading-placeholder">
                            <div class="spinner-border spinner-border-sm" role="status"></div>
                            <span>이미지 로딩 중...</span>
                        </div>
                    </div>
                </div>
                
                <!-- 새 이미지 업로드 -->
                <div class="new-images-section">
                    <h6 class="mb-3">새 이미지 추가 <span class="text-muted">(최대 10장)</span></h6>
                    <input type="file" id="productImageInput" accept="image/*" multiple style="display: none;">
                    <div class="image-drop-zone" id="imageDropZone" onclick="document.getElementById('productImageInput').click()">
                        <i class="bi bi-cloud-arrow-up"></i>
                        <p>클릭하여 이미지 선택 또는 드래그 앤 드롭</p>
                        <small class="text-muted">JPG, PNG, GIF (최대 5MB)</small>
                    </div>
                    <div class="new-images-preview" id="newImagesPreview"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="uploadProductImages()">
                    <i class="bi bi-check-lg me-1"></i>저장
                </button>
            </div>
        </div>
    </div>
</div>
</c:if>
</sec:authorize>

<script src="${pageContext.request.contextPath}/resources/js/accommodation-detail.js"></script>
<script>
    const cp = document.querySelector('meta[name="context-path"]')?.content || '${pageContext.request.contextPath}';

    initDetail({
        contextPath: cp,
        accNo: '${acc.accNo}',
        accName: '${acc.accName}',
        isLoggedIn: ${not empty loginMember ? 'true' : 'false'}, 
        isBusiness: ${not empty loginMember and loginMember.memType eq 'BUSINESS' ? 'true' : 'false'}
    });

    function openEditInquiryModal(id, ctgry, content, secret) {
        document.getElementById('editInquiryId').value = id;
        document.getElementById('editInquiryType').value = ctgry;
        document.getElementById('editInquiryContent').value = content;
        document.getElementById('editInquirySecret').checked = (secret === 'Y');
        
        const modal = new bootstrap.Modal(document.getElementById('editInquiryModal'));
        modal.show();
    }

</script>


<%@ include file="../common/footer.jsp" %>
