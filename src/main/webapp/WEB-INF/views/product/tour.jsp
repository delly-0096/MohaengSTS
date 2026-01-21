<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="투어/체험/티켓" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/tour.css">

<div class="product-page">
    <!-- 헤더 -->
    <div class="product-header">
        <div class="container">
            <h1><i class="bi bi-ticket-perforated me-3"></i>투어/체험/티켓</h1>
            <p>특별한 경험과 다양한 액티비티를 찾아보세요</p>
        </div>
    </div>

    <div class="container">
        <!-- 검색 박스 -->
        <div class="search-box">
            <form id="tourSearchForm">
                <!-- 검색어 입력 영역 -->
                <div class="keyword-search-row">
                    <div class="keyword-input-wrapper">
                        <i class="bi bi-search"></i>
                        <input type="text" class="form-control" id="keyword"
                               placeholder="투어, 체험, 티켓 검색"
                               autocomplete="off">
                    </div>
                    <div class="popular-keyword-area" onmouseenter="showMoreKeywords()" onmouseleave="hideMoreKeywords()">
					    <span class="popular-label"><i class="bi bi-fire"></i> 인기</span>
					    <span class="popular-keyword" id="rotatingKeyword" onclick="selectKeywordByText(this.textContent.trim())">
					        <c:choose>
					            <c:when test="${not empty keywords}">${keywords[0].keyword}</c:when>
					            <c:otherwise>스쿠버다이빙</c:otherwise>
					        </c:choose>
					    </span>
					    <div class="more-keywords" id="moreKeywords"></div>
					</div>
                </div>

                <div class="search-form-row">
                    <div class="form-group">
                        <label class="form-label">여행지</label>
                        <div class="search-input-group">
                            <span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>
                            <input type="text" class="form-control location-autocomplete" id="destination" placeholder="도시 또는 지역" autocomplete="off">
                            <div class="autocomplete-dropdown" id="destinationDropdown"></div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">카테고리</label>
                        <select class="form-control form-select" id="category">
                            <option value="">전체</option>
                            <option value="tour">투어</option>
                            <option value="activity">액티비티</option>
                            <option value="ticket">입장권/티켓</option>
                            <option value="class">클래스/체험</option>
                            <option value="transfer">교통/이동</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">날짜</label>
                        <input type="text" class="form-control date-picker" id="tourDate" placeholder="날짜 선택">
                    </div>
                    <div class="form-group">
                        <label class="form-label">인원</label>
                        <select class="form-control form-select" id="people">
                            <option value="1">1명</option>
                            <option value="2" selected>2명</option>
                            <option value="3">3명</option>
                            <option value="4">4명</option>
                            <option value="5">5명 이상</option>
                        </select>
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
				    <label>가격대</label>
				    <select class="form-select" id="priceFilter">
				        <option value="">전체</option>
				        <option value="0">3만원 이하</option>
				        <option value="3">3~5만원</option>
				        <option value="5">5~10만원</option>
				        <option value="10">10만원 이상</option>
				    </select>
				</div>
                <div class="filter-group">
                    <label>소요시간</label>
                    <select class="form-select" id="leadTimeFilter">
                        <option value="">전체</option>
                        <option value="1">1시간 이내</option>
                        <option value="3">1~3시간</option>
                        <option value="6">3~6시간</option>
                        <option value="24">하루 이상</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>정렬</label>
                    <select class="form-select" id="sortBy">
                        <option value="recommend">추천순</option>
                        <option value="popular">인기순</option>
                        <option value="price_low">가격 낮은순</option>
                        <option value="price_high">가격 높은순</option>
                        <option value="rating">평점 높은순</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- 검색 결과 -->
        <div class="flight-results">
            <div class="results-header">
                <p class="results-count" id="resultsCount">
				    <strong>전체</strong> 투어/체험/티켓 <strong id="totalCountDisplay">${totalCount}</strong>개
				</p>
            </div>

            <div class="tour-grid">
			    <c:choose>
			        <c:when test="${empty tpList}">
			            <div class="no-results">
			                <i class="bi bi-search"></i>
			                <p>등록된 상품이 없습니다.</p>
			            </div>
			        </c:when>
			        <c:otherwise>
		            	<c:forEach items="${tpList}" var="tp">
			                <!-- 투어 카드 1 -->
			                <div class="tour-card" data-id="${tp.tripProdNo}" data-name="${tp.tripProdTitle}" data-price="${tp.price}" 
     							data-min-people="${tp.prodMinPeople != null ? tp.prodMinPeople : 1}"
							    data-stock="${tp.curStock}"
							    data-location="${tp.ctyNm}"
     							data-image="${not empty tp.thumbImage ? pageContext.request.contextPath.concat('/upload/product/').concat(tp.thumbImage) : 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=300&fit=crop&q=80'}">
			                    <a href="${pageContext.request.contextPath}/tour/${tp.tripProdNo}" class="tour-link">
			                        <div class="tour-image">
			                            <c:choose>
									        <c:when test="${not empty tp.thumbImage}">
									            <img src="${pageContext.request.contextPath}/upload/product/${tp.thumbImage}" 
									                 alt="${tp.tripProdTitle}">
									        </c:when>
									        <c:otherwise>
									            <img src="https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=300&fit=crop&q=80" 
									                 alt="${tp.tripProdTitle}">
									        </c:otherwise>
									    </c:choose>
			                            <span class="tour-category">
										    <c:choose>
										        <c:when test="${tp.prodCtgryType eq 'tour'}">투어</c:when>
										        <c:when test="${tp.prodCtgryType eq 'activity'}">액티비티</c:when>
										        <c:when test="${tp.prodCtgryType eq 'ticket'}">입장권/티켓</c:when>
										        <c:when test="${tp.prodCtgryType eq 'class'}">클래스/체험</c:when>
										        <c:when test="${tp.prodCtgryType eq 'transfer'}">교통/이동</c:when>
										        <c:otherwise>${tp.prodCtgryType}</c:otherwise>
										    </c:choose>
										</span>
			                        </div>
			                        <div class="tour-body">
			                            <p class="tour-location"><i class="bi bi-geo-alt"></i> ${tp.ctyNm}</p>
			                            <h4 class="tour-name">${tp.tripProdTitle}</h4>
			                            <div class="tour-rating">
			                                <i class="bi bi-star-fill"></i>
			                                <span>${tp.avgRating > 0 ? tp.avgRating : '-'}</span>
			                                <span class="text-muted">(${tp.reviewCount})</span>
			                            </div>
			                         	<!-- 정가가 없거나 할인이 없으면 정가 표시 안 함 -->
										<div class="tour-price">
										    <c:if test="${tp.netprc != null && tp.netprc > tp.price}">
										        <span class="original"><fmt:formatNumber value="${tp.netprc}" pattern="#,###"/>원</span>
										    </c:if>
										    <span class="price"><fmt:formatNumber value="${tp.price}" pattern="#,###"/>원</span>
										</div>
			                            <!-- 개선: 재고 10개 이하일 때 경고 스타일 -->
										<div class="tour-stock ${tp.curStock <= 10 ? 'stock-warning' : ''}">
										    <i class="bi ${tp.curStock <= 10 ? 'bi-exclamation-triangle' : 'bi-box-seam'}"></i> 
										    ${tp.curStock <= 10 ? '품절 임박:' : '남은 수량:'} 
										    <span class="stock-count">${tp.curStock}개</span>
										</div>
			                        </div>
			                    </a>
			                    <c:if test="${sessionScope.loginMember.memType ne 'BUSINESS'}">
			                    <button class="tour-cart-btn" onclick="addToCart(this)" title="장바구니 담기">
			                        <i class="bi bi-cart-plus"></i>
			                    </button>
			                    </c:if>
			                </div>
		                </c:forEach>
			        </c:otherwise>
			    </c:choose>

	            <!-- 로딩 인디케이터 -->
	            <div class="infinite-scroll-loader" id="tourScrollLoader">
	                <div class="loader-spinner">
	                    <div class="spinner-border text-primary" role="status">
	                        <span class="visually-hidden">Loading...</span>
	                    </div>
	                </div>
	            </div>

	            <!-- 더 이상 데이터 없음 -->
	            <div class="infinite-scroll-end" id="tourScrollEnd" style="display: none;">
	                <p>모든 상품을 불러왔습니다</p>
	            </div>
        </div>
    </div>
</div>

<c:if test="${sessionScope.loginMember.memType ne 'BUSINESS'}">
<!-- 플로팅 장바구니 버튼 -->
<button class="floating-cart-btn" onclick="openCart()" id="floatingCartBtn">
    <i class="bi bi-cart3"></i>
    <span class="cart-badge" id="cartBadge">0</span>
</button>

<!-- 장바구니 사이드바 -->
<div class="cart-overlay" id="cartOverlay" onclick="closeCart()"></div>
<div class="cart-sidebar" id="cartSidebar">
	<div class="cart-header">
	    <h3><i class="bi bi-cart3"></i> 장바구니</h3>
	    <button class="cart-close-btn" onclick="closeCart()">
	        <i class="bi bi-x-lg"></i>
	    </button>
	</div>
	<div class="cart-body" id="cartBody">
	    <div class="cart-empty" id="cartEmpty">
	        <i class="bi bi-cart-x"></i>
	        <p>장바구니가 비어있습니다</p>
	        <span>마음에 드는 상품을 담아보세요</span>
	    </div>
	    <div class="cart-items" id="cartItems">
	        <!-- 장바구니 아이템들이 여기에 추가됨 -->
	    </div>
	</div>
	<div class="cart-footer" id="cartFooter">
	    <div class="cart-summary">
	        <div class="summary-row">
	            <span>상품 수</span>
	            <span id="cartItemCount">0개</span>
	        </div>
	        <div class="summary-row total">
	            <span>총 금액</span>
	            <span id="cartTotalPrice">0원</span>
	        </div>
	    </div>
	    <button class="btn btn-primary btn-lg cart-checkout-btn" onclick="checkout()">
	        <i class="bi bi-credit-card me-2"></i>결제하기
	    </button>
	</div>
</div>
</c:if>

<script>
const CONTEXT_PATH = '${pageContext.request.contextPath}';
var totalCount = ${totalCount};
var initialListSize = ${fn:length(tpList)};
var isBusiness = ${not empty sessionScope.loginMember && sessionScope.loginMember.memType eq 'BUSINESS'};
var isLoggedIn = ${not empty sessionScope.loginMember};

// 인기 검색어 목록
var popularKeywords = [
    <c:choose>
        <c:when test="${not empty keywords}">
            <c:forEach items="${keywords}" var="kw" varStatus="status">
                '${kw.keyword}'<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        </c:when>
        <c:otherwise>
            '스쿠버다이빙', '카약', '승마', 'ATV', '스노클링', '한복', '야경', '에버랜드'
        </c:otherwise>
    </c:choose>
];
</script>
<script src="${pageContext.request.contextPath}/resources/js/tour.js"></script>

<c:set var="pageJs" value="product" />
<%@ include file="../common/footer.jsp" %>
