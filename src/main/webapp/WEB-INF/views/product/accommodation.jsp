<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="pageTitle" value="숙박 검색" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/accommodation.css">

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
                            <input type="text" class="form-control location-autocomplete" id="destination" 
                            		name="keyword" placeholder="도시, 지역 또는 숙소명" autocomplete="off">
                            <div class="auto-dropdown" id="destinationDropdown" style="display:none;"></div>
                            <input type="hidden" name="areaCode" id="areaCode"><input type="hidden" name="accNo" id="accNo">
                            </div>
                    </div>
						<div class="form-group">
						    <label class="form-label">체크인 - 체크아웃</label>
						    <div class="input-group">
						        <input type="text" class="form-control range-picker-target" id="dateRange" placeholder="날짜 범위를 선택하세요" readonly>
						        <span class="input-group-text" id="stayDuration">0박 0일</span>
						    </div>
						    <input type="hidden" id="checkIn" name="startDate">
						    <input type="hidden" id="checkOut" name="endDate">
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
                    <select class="form-select" name="accCatCd">
                        <option value="">전체</option>
                        <option value="B02010100">호텔</option>
                        <option value="B02010500">리조트</option>
                        <option value="B02010700">펜션</option>
                        <option value="B02011100">게스트하우스</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>가격대</label>
                    <select class="form-select" name="priceRange">
                        <option value="">전체</option>
                        <option value="0-50000">5만원 이하</option>
                        <option value="50000-100000">5~10만원</option>
                        <option value="100000-200000">10~20만원</option>
                        <option value="200000-">20만원 이상</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>등급</label>
                    <select class="form-select" name="starGrade">
                        <option value="">전체</option>
                        <option value="5">5성급</option>
                        <option value="4">4성급</option>
                        <option value="3">3성급</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>정렬</label>
                    <select class="form-select" id="sortBy" name="sortBy">
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
		        <p class="results-count"> <c:choose>
		                <c:when test="${not empty keyword}">
		                    <strong>${keyword}</strong>
		                </c:when>
		                <c:when test="${not empty searchParam.keyword}">
		                    <strong>${searchParam.keyword}</strong>
		                </c:when>
		                <c:otherwise>
		                    <strong>전체</strong>
		                </c:otherwise>
		            </c:choose>
		            숙소 <strong>${totalCount}</strong>개
		        </p>
		    </div>
		</div>
	        
            <!-- 숙소 카드 -->
            <div class="accommodation-grid">
                <c:forEach items="${accList }" var="acc">
                <div class="accommodation-card" data-accommodation-id="${acc.accNo}">
                    <a href="${pageContext.request.contextPath}/product/accommodation/${acc.tripProdNo}?startDate=${param.startDate}&endDate=${param.endDate}&adultCount=${param.adultCount}" class="accommodation-image">
                        <img src="${acc.accFilePath}" alt="${acc.accName}">
                        <%-- 배지 로직 시작 --%>
			            <c:choose>
			                <%-- 1. 평점이 5점인 진짜 '인기' 숙소! --%>
			                <c:when test="${acc.avgRating eq 5.0}">
			                    <span class="accommodation-badge" style="background: #ff4757;">인기</span>
			                </c:when>
			                
			                <%-- 2. 리뷰가 아예 없는 따끈따끈한 '신규' 숙소 --%>
			                <c:when test="${acc.reviewCount eq 0}">
			                    <span class="accommodation-badge" style="background: #1e90ff;">신규</span>
			                </c:when>
			                
			                <%-- 3. 그 외에는 배지 노출 안 함 (깔끔!) --%>
			            </c:choose>
                    </a>
                    <button class="accommodation-bookmark" onclick="toggleAccommodationBookmark(event, this)"
                    		data-trip-prod-no="${acc.tripProdNo}">
                        <i class="bi bi-bookmark"></i>
                    </button>
                    <div class="accommodation-body">
                        <div class="accommodation-rating">
                            <i class="bi bi-star-fill"></i>
                            <span>${acc.avgRating > 0 ? acc.avgRating : '-'}</span>
                            <span class="review-count">(${acc.reviewCount})</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/product/accommodation/${acc.tripProdNo }?startDate=${param.startDate}&endDate=${param.endDate}&adultCount=${param.adultCount}" class="accommodation-name-link">
                            <h3 class="accommodation-name">${acc.accName}</h3>
                        </a>

                        <p class="accommodation-location">
                            <i class="bi bi-geo-alt"></i> ${acc.addr1}
                        </p>
                        <div class="accommodation-amenities" style="display: flex; flex-wrap: wrap; gap: 8px;">
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
                                예약 <i class="bi bi-chevron-down"></i>
                            </button>
                        </div>
                    </div>
                    <!-- 결제 드롭다운 -->
                    <div class="accommodation-booking-dropdown" id="accommodationDropdown${acc.accNo}">
                        <div class="booking-dropdown-content">
                            <div class="room-options">
                            <c:set var="lastRoomName" value="" />
                            <c:forEach items="${acc.roomTypeList }" var="room">
                            	<c:if test="${room.roomName ne lastRoomName}"/>
                            	<div class="room-option" style="padding: 15px; border-bottom: 1px solid #f0f0f0; display: flex; align-items: center;">
								    <div class="room-option-info" style="flex: 1;">
								        <h6 style="margin: 0; font-weight: 600; color: #333;">${room.roomName}</h6>
								        <p style="font-size: 0.8rem; color: #888; margin: 4px 0;">
								            기준 ${room.baseGuestCount}인 · 잔여 ${room.totalRoomCount}실
								        </p>
								    </div>
								
								    <div class="room-option-price" style="text-align: right; margin-right: 15px;">
								        <c:choose>
								            <c:when test="${room.discount > 0}">
								                <div style="font-size: 0.75rem;">
								                    <span style="color: #ff5a5f; font-weight: bold;">${room.discount}%</span>
								                    <span style="text-decoration: line-through; color: #bbb; margin-left: 3px;">
								                        <fmt:formatNumber value="${room.price}" pattern="#,###"/>
								                    </span>
								                </div>
								                <div style="font-size: 1.05rem; font-weight: 700; color: #222;">
								                    <fmt:formatNumber value="${room.price * (100 - room.discount) / 100}" pattern="#,###"/>원
								                </div>
								            </c:when>
								            <c:otherwise>
								                <div style="font-size: 1.05rem; font-weight: 700; color: #222;">
								                    <fmt:formatNumber value="${room.price}" pattern="#,###"/>원
								                </div>
								            </c:otherwise>
								        </c:choose>
								    </div>
								
								    <button type="button" class="btn btn-primary btn-sm" style="border-radius: 6px; padding: 6px 15px;"
								            onclick="goBooking(${acc.accNo}, ${room.roomTypeNo}, ${acc.tripProdNo }, ${room.price * (100 - room.discount) / 100})">결제</button>
								</div>
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
            <c:if test="${not empty accList}">
			    <div class="infinite-scroll-end text-center py-4 w-100" id="accomScrollEnd" style="display: none; text-align: center; padding: 20px;">
			        <hr class="my-4" style="width: 50%; margin: 0 auto; border-top: 1px dashed #ccc;">
    				<p class="text-muted">✨ 모든 숙소를 불러왔습니다 ✨</p>
			    </div>
			</c:if>
            </div>
        </div>
		     <!-- 검색 결과 없음 -->
		     <c:if test="${empty accList}">
			    <div class="no-result-wrapper text-center">
			        <i class="bi bi-search" style="font-size: 4rem; color: #dee2e6;"></i>
			        <h3 class="mt-4 fw-bold">검색 결과가 없습니다</h3>
			        <p class="text-muted">다른 지역이나 키워드로 검색해보시겠어요?</p>
			        <a href="${contextPath}/product/accommodation" class="btn btn-primary btn-lg mt-3 shadow-sm">
			            <i class="bi bi-arrow-clockwise"></i> 검색 초기화
			        </a>
			    </div>
			</c:if>
    </div>


<script src="${pageContext.request.contextPath}/resources/js/accommodation.js"></script>
<script>
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
