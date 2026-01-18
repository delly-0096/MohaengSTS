<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="pageTitle" value="숙박 검색" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>

<div class="product-page">
    <!-- 헤더 -->
    <div class="product-header">
        <div class="container">
            <h1><i class="bi bi-building me-3"></i>숙박 검색</h1>
            <p>호텔, 리조트, 펜션 등 다양한 숙소를 비교해보세요</p>
        </div>
    </div>

    <div class="container">
        <!-- 검색 박스 -->
        <div class="search-box">
            <form id="accommodationSearchForm" action="${pageContext.request.contextPath}/product/accommodation" method="get">
                <div class="search-form-row">
                    <div class="form-group">
                        <label class="form-label">목적지</label>
                        <div class="search-input-group">
                            <span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>
                            <input type="text" class="form-control location-autocomplete" id="destination" placeholder="도시, 지역 또는 숙소명" autocomplete="off">
                            <div class="autocomplete-dropdown" id="destinationDropdown"></div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">체크인</label>
                        <input type="text" class="form-control date-picker" id="checkIn" placeholder="날짜 선택">
                    </div>
                    <div class="form-group">
                        <label class="form-label">체크아웃</label>
                        <input type="text" class="form-control date-picker" id="checkOut" placeholder="날짜 선택">
                    </div>
                    <div class="form-group">
					    <label class="form-label">인원</label>
					    <div class="guest-counter-wrapper">
					        <div class="counter-item">
					            <div class="counter-controls">
					            <small>성인 기준</small>
					                <button type="button" class="btn-count minus" onclick="updateCount('adult', -1)">-</button>
					                <input type="number" id="adultCount" name="adultCount" value="2" readonly>인
					                <button type="button" class="btn-count plus" onclick="updateCount('adult', 1)">+</button>
					            </div>
					        </div>
					        </div>
					</div>
                    <button type="submit" class="btn btn-primary btn-search">
                        <i class="bi bi-search me-2"></i>검색
                    </button>
                </div>
            </form>
        </div>

        <!-- 필터 -->
        <div class="tour-filters mt-4">
            <div class="filter-row">
                <div class="filter-group">
                    <label>숙소 유형</label>
                    <select class="form-select">
                        <option value="">전체</option>
                        <option value="hotel">호텔</option>
                        <option value="resort">리조트</option>
                        <option value="pension">펜션</option>
                        <option value="guesthouse">게스트하우스</option>
                        <option value="airbnb">에어비앤비</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>가격대</label>
                    <select class="form-select">
                        <option value="">전체</option>
                        <option value="0-50000">5만원 이하</option>
                        <option value="50000-100000">5~10만원</option>
                        <option value="100000-200000">10~20만원</option>
                        <option value="200000-">20만원 이상</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>등급</label>
                    <select class="form-select">
                        <option value="">전체</option>
                        <option value="5">5성급</option>
                        <option value="4">4성급</option>
                        <option value="3">3성급</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>정렬</label>
                    <select class="form-select" id="sortBy">
                        <option value="recommend">추천순</option>
                        <option value="price_low">가격 낮은순</option>
                        <option value="price_high">가격 높은순</option>
                        <option value="rating">평점 높은순</option>
                        <option value="review">리뷰 많은순</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- 검색 결과 -->
        <div class="flight-results">
            <div class="results-header">
                <p class="results-count">
                <!-- 이건 준혁님이 고치면 거기에 얹어가면 됨  -->
                    <strong>제주도</strong> 숙소 <strong>128</strong>개
                </p>
            </div>

            <div class="accommodation-grid">
                <!-- 숙소 카드 -->
                <c:forEach items="${accList }" var="acc">
                <div class="accommodation-card" data-accommodation-id="${acc.accNo}">
                    <a href="${pageContext.request.contextPath}/product/accommodation/${acc.accNo }" class="accommodation-image">
                        <img src="${acc.accFilePath}" alt="${acc.accName}">
                        <span class="accommodation-badge">인기</span>
                    </a>
                    <button class="accommodation-bookmark" onclick="toggleAccommodationBookmark(event, this)">
                        <i class="bi bi-bookmark"></i>
                    </button>
                    <div class="accommodation-body">
                        <div class="accommodation-rating">
                            <i class="bi bi-star-fill"></i>
                            <span>4.8</span>
                            <span class="review-count">(1,234)</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/product/accommodation/${acc.accNo }" class="accommodation-name-link">
                            <h3 class="accommodation-name">${acc.accName}</h3>
                        </a>

                        <p class="accommodation-location">
                            <i class="bi bi-geo-alt"></i> ${acc.addr1}
                        </p>
                        <div class="accommodation-amenities" style="display: flex; flex-wrap: wrap; gap: 8px;">
                            <c:if test="${acc.wifiYn eq 'Y'}"><span class="amenity"><i class="bi bi-wifi"></i> WiFi</span></c:if>
						    <c:if test="${acc.parkingYn eq 'Y'}"><span class="amenity"><i class="bi bi-p-circle"></i> 주차</span></c:if>
						    <c:if test="${acc.breakfastYn eq 'Y'}"><span class="amenity"><i class="bi bi-cup-hot"></i> 조식</span></c:if>
						    <c:if test="${acc.poolYn eq 'Y'}"><span class="amenity"><i class="bi bi-water"></i> 수영장</span></c:if>
						    <c:if test="${acc.gymYn eq 'Y'}"><span class="amenity"><i class="bi bi-heart-pulse"></i> 피트니스</span></c:if>
						    <c:if test="${acc.spaYn eq 'Y'}"><span class="amenity"><i class="bi bi-magic"></i> 스파</span></c:if>
						    <c:if test="${acc.restaurantYn eq 'Y'}"><span class="amenity"><i class="bi bi-egg-fried"></i> 식당</span></c:if>
						    <c:if test="${acc.barYn eq 'Y'}"><span class="amenity"><i class="bi bi-glass-cocktail"></i> 바</span></c:if>
						    <c:if test="${acc.roomServiceYn eq 'Y'}"><span class="amenity"><i class="bi bi-bell"></i> 룸서비스</span></c:if>
						    <c:if test="${acc.laundryYn eq 'Y'}"><span class="amenity"><i class="bi bi-wind"></i> 세탁</span></c:if>
						    <c:if test="${acc.smokingAreaYn eq 'Y'}"><span class="amenity"><i class="bi bi-cursor"></i> 흡연구역</span></c:if>
						    <c:if test="${acc.petFriendlyYn eq 'Y'}"><span class="amenity"><i class="bi bi-dog"></i> 반려동물</span></c:if>
						</div>
               			<div class="discount-row">
               				<p class="discount-badge" style="font-size: 0.5em;">${acc.maxDiscount }% OFF</p>
               			</div>
                        <div class="accommodation-price-row">
                            <div class="accommodation-price">
                            	<c:choose>
                            		<c:when test="${acc.maxDiscount > 0 }">
                            			<div class="price-main-row">
                            			<span class="original-price" style="text-decoration: line-through; color: #999; font-size: 0.9em;">
                            				<fmt:formatNumber value="${acc.minPrice}" pattern="#,###"/>원
                            			</span>
                            			<span class="price" style="color: #e74c3c; font-weight: bold;">
                            				<fmt:formatNumber value="${acc.finalPrice}" pattern="#,###"/>원
                            			</span>
                            			</div>
                            		</c:when>
                            	<c:otherwise>
                            		<span class="price">
                            			<fmt:formatNumber value="${acc.minPrice}" pattern="#,###"/>원
                            		</span>
                            	</c:otherwise>
                            	</c:choose>
                                <span class="per-night">/ 1박</span>
                            </div>
                           
                            <button class="btn btn-primary btn-sm accommodation-select-btn" onclick="toggleAccommodationDropdown(event, ${acc.accNo})">
                                결제 <i class="bi bi-chevron-down"></i>
                            </button>
                        </div>
                    </div>
                    <!-- 결제 드롭다운 -->
                    <div class="accommodation-booking-dropdown" id="accommodationDropdown${acc.accNo}">
                        <div class="booking-dropdown-content">
                            <div class="room-options">
                            <c:set var="lastRoomName" value="" />
                            <c:forEach items="${acc.roomList }" var="room">
                            	<c:if test="${room.roomName ne lastRoomName}">
                                <div class="room-option">
                                    <div class="room-option-info">
                                        <h6>${room.roomName}</h6>
                                        <c:set var="lastRoomName" value="${room.roomName}" />
                                        <p><i class="bi bi-people"></i> ${room.baseGuestCount } / <i class="bi bi-arrows-angle-expand"></i> ${room.roomSize }㎡</p>
                                        <span class="room-stock available"><i class="bi bi-check-circle"></i> 잔여 ${room.totalRoomCount }실</span>
                                    </div>
                                    <div class="room-option-price">
                                        <span class="price"><fmt:formatNumber value="${room.price * (100 - room.discount) / 100}" pattern="#,###"/>원</span>
                                        <span class="per-night">/ 1박</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/product/accommodation/${acc.accNo}/booking?roomNo=${room.roomTypeNo}" class="btn btn-primary btn-sm">결제</a>
                                </div>
                                </c:if>
                            </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
              </c:forEach>

             <!-- 로딩 인디케이터 -->
            <div class="infinite-scroll-loader" id="accomScrollLoader">
                <div class="loader-spinner">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>

            <!-- 더 이상 데이터 없음 -->
            <div class="infinite-scroll-end" id="accomScrollEnd" style="display: none;">
                <p>모든 숙소를 불러왔습니다</p>
            </div> 
            </div>
        </div>
    </div>
</div>

<style>
/* 금액 영역 전체 컨테이너 */
.accommodation-price-row {
    display: flex;
    justify-content: space-between; /* 가격과 결제버튼 양끝 정렬 */
    align-items: flex-end; /* 바닥 기준 정렬 */
/*     margin-top: 2px; */
}

.accommodation-price {
    display: flex;
    align-items: baseline; /* 텍스트 베이스라인에 맞춤 */
    flex-wrap: nowrap; /* 절대 줄바꿈 금지 */
    gap: 6px; /* 요소 사이 간격 */
}

/* 10% OFF 뱃지 */
.discount-badge {
	display: inline-block;  
    width: auto;            
    background-color: #ffeded;
    color: #e74c3c;
    padding: 2px 8px;       
    border-radius: 4px;
    margin-bottom: 1px;
}

/* 원래 가격 (취소선) */
.original-price {
    color: #999;
    text-decoration: line-through;
    font-size: 14px;
    white-space: nowrap;
}

/* 실제 결제 가격 (빨간색) */
.price {
    color: #e74c3c;
    font-size: 20px; /* 크기 살짝 조정 */
    font-weight: 800;
    line-height: 1;
    white-space: nowrap;
}

/* / 1박 텍스트 */
.per-night {
    font-size: 13px;
    color: #666;
    margin-left: 2px;
}

/* 숙소 카드 드롭다운 스타일 */
.accommodation-price .price-label {
    display: block;
    font-size: 11px;
    color: var(--gray-medium);
    margin-bottom: 2px;
}

.accommodation-select-btn {
    white-space: nowrap;
}

.accommodation-select-btn i {
    margin-left: 4px;
    transition: transform 0.3s ease;
}

.accommodation-card.active .accommodation-select-btn i {
    transform: rotate(180deg);
}

/* 결제 드롭다운 */
.accommodation-booking-dropdown {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: white;
    border-radius: 0 0 12px 12px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    z-index: 100;
}

.accommodation-card.active .accommodation-booking-dropdown {
    display: block;
}

.booking-dropdown-content {
    padding: 16px;
}

.room-options {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.room-option {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16px;
    background: #f8fafc;
    border-radius: 10px;
    border: 1px solid #e2e8f0;
    transition: all 0.2s ease;
}

.room-option:hover {
    border-color: var(--primary-color);
    background: #f0f7ff;
}

.room-option-info h6 {
    font-size: 15px;
    font-weight: 600;
    margin: 0 0 6px 0;
    color: #333;
}

.room-option-info p {
    font-size: 13px;
    color: #666;
    margin: 0;
    display: flex;
    align-items: center;
    gap: 8px;
}

.room-option-info p i {
    color: var(--primary-color);
}

/* 잔여 객실 수 스타일 */
.room-stock {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    font-size: 12px;
    font-weight: 500;
    padding: 3px 8px;
    border-radius: 4px;
    margin-top: 6px;
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

.room-option-price {
    text-align: right;
    margin-right: 16px;
}

.room-option-price .price {
    font-size: 18px;
    font-weight: 700;
    color: var(--primary-color);
}

.room-option-price .per-night {
    font-size: 12px;
    color: #666;
}

/* 숙소 이미지/이름 링크 스타일 */
a.accommodation-image {
    display: block;
    position: relative;
    aspect-ratio: 4/3;
    overflow: hidden;
}

a.accommodation-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s ease;
}

a.accommodation-image:hover img {
    transform: scale(1.05);
}

.accommodation-name-link {
    text-decoration: none;
    color: inherit;
}

.accommodation-name-link:hover .accommodation-name {
    color: var(--primary-color);
}

/* 인원 선택 스타일 */
.guest-counter-wrapper {
    display: flex;
    align-items: center;
    background: var(--white-color);
    border: 2px solid var(--gray-light);
    border-radius: var(--radius-md);
    padding: 12px 16px;
    font-size: 15px;
}
.counter-controls {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-left: auto;
}
.btn-count {
    width: 20px;
    height: 20px;
    border-radius: 50%;
    border: 1px solid var(--primary-color);
    background: #fff;
    color: var(--primary-color);
    font-weight: bold;
    cursor: pointer;
}
.btn-count:hover {
    background: var(--primary-color);
    color: #fff;
}
#adultCount {
    width: 30px;
    border: none;
    text-align: center;
    font-weight: bold;
}
}
</style>
<script src="${pageContext.request.contextPath}/resources/js/accommodation.js"></script>
<script>
const isLoggedIn = <sec:authorize access="isAuthenticated()">true</sec:authorize><sec:authorize access="isAnonymous()">false</sec:authorize>;

window.addEventListener('load', function() {
    if (typeof initSearch === 'function') {
        initSearch({
            initialListSize: ${empty accList ? 0 : accList.size()},
            totalCount: ${empty totalCount ? 0 : totalCount},
            areaCode: '${param.areaCode}',
            keyword: '${param.keyword}'
        });
    }
});
</script>

<%@ include file="../common/footer.jsp" %>
