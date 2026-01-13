<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="투어/체험/티켓" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>

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
                        <span class="popular-keyword" id="rotatingKeyword" onclick="selectKeywordByText(this.textContent)">스쿠버다이빙</span>
                        <div class="more-keywords" id="moreKeywords">
                            <!-- 동적으로 추가됨 -->
                        </div>
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
                    <select class="form-select">
                        <option value="">전체</option>
                        <option value="0-30000">3만원 이하</option>
                        <option value="30000-50000">3~5만원</option>
                        <option value="50000-100000">5~10만원</option>
                        <option value="100000-">10만원 이상</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>소요시간</label>
                    <select class="form-select">
                        <option value="">전체</option>
                        <option value="1">1시간 이내</option>
                        <option value="3">1~3시간</option>
                        <option value="6">3~6시간</option>
                        <option value="day">하루 이상</option>
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
                <p class="results-count">
                    <strong>제주도</strong> 투어/체험 <strong>86</strong>개
                </p>
            </div>

            <div class="tour-grid">
                <!-- 투어 카드 1 -->
                <div class="tour-card" data-id="1" data-name="제주 스쿠버다이빙 체험 (초보자 가능)" data-price="68000" data-image="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=300&fit=crop&q=80">
                    <a href="${pageContext.request.contextPath}/product/tour/1" class="tour-link">
                        <div class="tour-image">
                            <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=300&fit=crop&q=80" alt="스쿠버다이빙">
                            <span class="tour-category">액티비티</span>
                        </div>
                        <div class="tour-body">
                            <p class="tour-location"><i class="bi bi-geo-alt"></i> 제주 서귀포시</p>
                            <h4 class="tour-name">제주 스쿠버다이빙 체험 (초보자 가능)</h4>
                            <div class="tour-rating">
                                <i class="bi bi-star-fill"></i>
                                <span>4.9</span>
                                <span class="text-muted">(328)</span>
                            </div>
                            <div class="tour-price">
                                <span class="original">85,000원</span>
                                <span class="price">68,000원</span>
                            </div>
                            <div class="tour-stock">
                                <i class="bi bi-box-seam"></i> 남은 수량: <span class="stock-count">45개</span>
                            </div>
                        </div>
                    </a>
                    <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                    <button class="tour-cart-btn" onclick="addToCart(this)" title="장바구니 담기">
                        <i class="bi bi-cart-plus"></i>
                    </button>
                    </c:if>
                </div>

                <!-- 투어 카드 2 -->
                <div class="tour-card" data-id="2" data-name="제주 투명카약 체험 (협재해변)" data-price="35000" data-image="https://images.unsplash.com/photo-1472745942893-4b9f730c7668?w=400&h=300&fit=crop&q=80">
                    <a href="${pageContext.request.contextPath}/product/tour/2" class="tour-link">
                        <div class="tour-image">
                            <img src="https://images.unsplash.com/photo-1472745942893-4b9f730c7668?w=400&h=300&fit=crop&q=80" alt="카약">
                            <span class="tour-category">액티비티</span>
                        </div>
                        <div class="tour-body">
                            <p class="tour-location"><i class="bi bi-geo-alt"></i> 제주 제주시</p>
                            <h4 class="tour-name">제주 투명카약 체험 (협재해변)</h4>
                            <div class="tour-rating">
                                <i class="bi bi-star-fill"></i>
                                <span>4.8</span>
                                <span class="text-muted">(215)</span>
                            </div>
                            <div class="tour-price">
                                <span class="price">35,000원</span>
                            </div>
                            <div class="tour-stock">
                                <i class="bi bi-box-seam"></i> 남은 수량: <span class="stock-count">32개</span>
                            </div>
                        </div>
                    </a>
                    <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                    <button class="tour-cart-btn" onclick="addToCart(this)" title="장바구니 담기">
                        <i class="bi bi-cart-plus"></i>
                    </button>
                    </c:if>
                </div>

                <!-- 투어 카드 3 -->
                <div class="tour-card" data-id="3" data-name="아쿠아플라넷 제주 입장권" data-price="37000" data-image="https://images.unsplash.com/photo-1559825481-12a05cc00344?w=400&h=300&fit=crop&q=80">
                    <a href="${pageContext.request.contextPath}/product/tour/3" class="tour-link">
                        <div class="tour-image">
                            <img src="https://images.unsplash.com/photo-1559825481-12a05cc00344?w=400&h=300&fit=crop&q=80" alt="아쿠아리움">
                            <span class="tour-category">입장권</span>
                        </div>
                        <div class="tour-body">
                            <p class="tour-location"><i class="bi bi-geo-alt"></i> 제주 서귀포시</p>
                            <h4 class="tour-name">아쿠아플라넷 제주 입장권</h4>
                            <div class="tour-rating">
                                <i class="bi bi-star-fill"></i>
                                <span>4.6</span>
                                <span class="text-muted">(1,234)</span>
                            </div>
                            <div class="tour-price">
                                <span class="original">41,900원</span>
                                <span class="price">37,000원</span>
                            </div>
                            <div class="tour-stock stock-warning">
                                <i class="bi bi-exclamation-triangle"></i> 품절 임박: <span class="stock-count">5개</span>
                            </div>
                        </div>
                    </a>
                    <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                    <button class="tour-cart-btn" onclick="addToCart(this)" title="장바구니 담기">
                        <i class="bi bi-cart-plus"></i>
                    </button>
                    </c:if>
                </div>

                <!-- 투어 카드 4 -->
                <div class="tour-card" data-id="4" data-name="제주 흑돼지 요리 클래스" data-price="55000" data-image="https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=400&h=300&fit=crop&q=80">
                    <a href="${pageContext.request.contextPath}/product/tour/4" class="tour-link">
                        <div class="tour-image">
                            <img src="https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=400&h=300&fit=crop&q=80" alt="요리클래스">
                            <span class="tour-category">클래스</span>
                        </div>
                        <div class="tour-body">
                            <p class="tour-location"><i class="bi bi-geo-alt"></i> 제주 제주시</p>
                            <h4 class="tour-name">제주 흑돼지 요리 클래스</h4>
                            <div class="tour-rating">
                                <i class="bi bi-star-fill"></i>
                                <span>4.9</span>
                                <span class="text-muted">(89)</span>
                            </div>
                            <div class="tour-price">
                                <span class="price">55,000원</span>
                            </div>
                            <div class="tour-stock">
                                <i class="bi bi-box-seam"></i> 남은 수량: <span class="stock-count">18개</span>
                            </div>
                        </div>
                    </a>
                    <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                    <button class="tour-cart-btn" onclick="addToCart(this)" title="장바구니 담기">
                        <i class="bi bi-cart-plus"></i>
                    </button>
                    </c:if>
                </div>

                <!-- 투어 카드 5 -->
                <div class="tour-card" data-id="5" data-name="제주 승마 체험 (초원 코스)" data-price="42000" data-image="https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?w=400&h=300&fit=crop&q=80">
                    <a href="${pageContext.request.contextPath}/product/tour/5" class="tour-link">
                        <div class="tour-image">
                            <img src="https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?w=400&h=300&fit=crop&q=80" alt="승마">
                            <span class="tour-category">체험</span>
                        </div>
                        <div class="tour-body">
                            <p class="tour-location"><i class="bi bi-geo-alt"></i> 제주 제주시</p>
                            <h4 class="tour-name">제주 승마 체험 (초원 코스)</h4>
                            <div class="tour-rating">
                                <i class="bi bi-star-fill"></i>
                                <span>4.7</span>
                                <span class="text-muted">(456)</span>
                            </div>
                            <div class="tour-price">
                                <span class="original">50,000원</span>
                                <span class="price">42,000원</span>
                            </div>
                            <div class="tour-stock">
                                <i class="bi bi-box-seam"></i> 남은 수량: <span class="stock-count">60개</span>
                            </div>
                        </div>
                    </a>
                    <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                    <button class="tour-cart-btn" onclick="addToCart(this)" title="장바구니 담기">
                        <i class="bi bi-cart-plus"></i>
                    </button>
                    </c:if>
                </div>

                <!-- 투어 카드 6 -->
                <div class="tour-card" data-id="6" data-name="제주 동부 일주 버스투어" data-price="49000" data-image="https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=400&h=300&fit=crop&q=80">
                    <a href="${pageContext.request.contextPath}/product/tour/6" class="tour-link">
                        <div class="tour-image">
                            <img src="https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=400&h=300&fit=crop&q=80" alt="버스투어">
                            <span class="tour-category">투어</span>
                        </div>
                        <div class="tour-body">
                            <p class="tour-location"><i class="bi bi-geo-alt"></i> 제주 전역</p>
                            <h4 class="tour-name">제주 동부 일주 버스투어</h4>
                            <div class="tour-rating">
                                <i class="bi bi-star-fill"></i>
                                <span>4.5</span>
                                <span class="text-muted">(678)</span>
                            </div>
                            <div class="tour-price">
                                <span class="price">49,000원</span>
                            </div>
                            <div class="tour-stock">
                                <i class="bi bi-box-seam"></i> 남은 수량: <span class="stock-count">25개</span>
                            </div>
                        </div>
                    </a>
                    <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                    <button class="tour-cart-btn" onclick="addToCart(this)" title="장바구니 담기">
                        <i class="bi bi-cart-plus"></i>
                    </button>
                    </c:if>
                </div>

                <!-- 투어 카드 7 -->
                <div class="tour-card" data-id="7" data-name="제주 ATV 오프로드 체험" data-price="45000" data-image="https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop&q=80">
                    <a href="${pageContext.request.contextPath}/product/tour/7" class="tour-link">
                        <div class="tour-image">
                            <img src="https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop&q=80" alt="ATV">
                            <span class="tour-category">액티비티</span>
                        </div>
                        <div class="tour-body">
                            <p class="tour-location"><i class="bi bi-geo-alt"></i> 제주 서귀포시</p>
                            <h4 class="tour-name">제주 ATV 오프로드 체험</h4>
                            <div class="tour-rating">
                                <i class="bi bi-star-fill"></i>
                                <span>4.8</span>
                                <span class="text-muted">(234)</span>
                            </div>
                            <div class="tour-price">
                                <span class="price">45,000원</span>
                            </div>
                            <div class="tour-stock stock-warning">
                                <i class="bi bi-exclamation-triangle"></i> 품절 임박: <span class="stock-count">3개</span>
                            </div>
                        </div>
                    </a>
                    <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                    <button class="tour-cart-btn" onclick="addToCart(this)" title="장바구니 담기">
                        <i class="bi bi-cart-plus"></i>
                    </button>
                    </c:if>
                </div>

                <!-- 투어 카드 8 -->
                <div class="tour-card" data-id="8" data-name="테디베어 뮤지엄 입장권" data-price="12000" data-image="https://images.unsplash.com/photo-1554907984-15263bfd63bd?w=400&h=300&fit=crop&q=80">
                    <a href="${pageContext.request.contextPath}/product/tour/8" class="tour-link">
                        <div class="tour-image">
                            <img src="https://images.unsplash.com/photo-1554907984-15263bfd63bd?w=400&h=300&fit=crop&q=80" alt="박물관">
                            <span class="tour-category">입장권</span>
                        </div>
                        <div class="tour-body">
                            <p class="tour-location"><i class="bi bi-geo-alt"></i> 제주 서귀포시</p>
                            <h4 class="tour-name">테디베어 뮤지엄 입장권</h4>
                            <div class="tour-rating">
                                <i class="bi bi-star-fill"></i>
                                <span>4.4</span>
                                <span class="text-muted">(567)</span>
                            </div>
                            <div class="tour-price">
                                <span class="original">15,000원</span>
                                <span class="price">12,000원</span>
                            </div>
                            <div class="tour-stock">
                                <i class="bi bi-box-seam"></i> 남은 수량: <span class="stock-count">100개</span>
                            </div>
                        </div>
                    </a>
                    <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                    <button class="tour-cart-btn" onclick="addToCart(this)" title="장바구니 담기">
                        <i class="bi bi-cart-plus"></i>
                    </button>
                    </c:if>
                </div>
            </div>

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

<c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
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

<style>
/* 재고 표시 스타일 */
.tour-stock {
    display: flex;
    align-items: center;
    gap: 4px;
    font-size: 12px;
    color: #666;
    margin-top: 6px;
    padding: 4px 8px;
    background: #f1f5f9;
    border-radius: 4px;
    width: fit-content;
}

.tour-stock i {
    font-size: 11px;
}

.tour-stock .stock-count {
    font-weight: 600;
    color: var(--primary-color);
}

.tour-stock.stock-warning {
    background: #fef2f2;
    color: #dc2626;
}

.tour-stock.stock-warning i {
    color: #dc2626;
}

.tour-stock.stock-warning .stock-count {
    color: #dc2626;
}

/* 투어 카드 수정 */
.tour-card {
    position: relative;
}

.tour-link {
    display: block;
    text-decoration: none;
    color: inherit;
}

.tour-cart-btn {
    position: absolute;
    bottom: 16px;
    right: 16px;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: var(--primary-color);
    color: white;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    box-shadow: 0 4px 12px rgba(74, 144, 217, 0.4);
    transition: all 0.3s ease;
    z-index: 5;
}

.tour-cart-btn:hover {
    background: #3a7bc8;
    transform: scale(1.1);
}

.tour-cart-btn.added {
    background: #10b981;
}

.tour-cart-btn.added i {
    animation: cartBounce 0.5s ease;
}

@keyframes cartBounce {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.3); }
}

/* 플로팅 장바구니 버튼 */
.floating-cart-btn {
    position: fixed;
    bottom: 100px;
    right: 24px;
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background: linear-gradient(135deg, #4A90D9 0%, #357ABD 100%);
    color: white;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    box-shadow: 0 6px 20px rgba(74, 144, 217, 0.4);
    transition: all 0.3s ease;
    z-index: 998;
}

.floating-cart-btn:hover {
    transform: scale(1.1);
    box-shadow: 0 8px 25px rgba(74, 144, 217, 0.5);
}

.cart-badge {
    position: absolute;
    top: -5px;
    right: -5px;
    min-width: 24px;
    height: 24px;
    background: #ef4444;
    color: white;
    border-radius: 12px;
    font-size: 12px;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 6px;
}

.cart-badge:empty,
.cart-badge[data-count="0"] {
    display: none;
}

/* 장바구니 오버레이 */
.cart-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1100;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
}

.cart-overlay.active {
    opacity: 1;
    visibility: visible;
}

/* 장바구니 사이드바 */
.cart-sidebar {
    position: fixed;
    top: 0;
    right: -420px;
    width: 400px;
    max-width: 100%;
    height: 100%;
    background: white;
    z-index: 1200;
    display: flex;
    flex-direction: column;
    box-shadow: -5px 0 30px rgba(0, 0, 0, 0.15);
    transition: right 0.3s ease;
}

.cart-sidebar.active {
    right: 0;
}

.cart-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px;
    border-bottom: 1px solid #eee;
    background: #f8fafc;
}

.cart-header h3 {
    margin: 0;
    font-size: 18px;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 10px;
}

.cart-close-btn {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    border: none;
    background: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    color: #666;
    transition: all 0.2s ease;
}

.cart-close-btn:hover {
    background: #fee2e2;
    color: #ef4444;
}

.cart-body {
    flex: 1;
    overflow-y: auto;
    padding: 20px;
}

.cart-empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    color: #999;
    text-align: center;
}

.cart-empty i {
    font-size: 64px;
    margin-bottom: 16px;
    opacity: 0.5;
}

.cart-empty p {
    font-size: 16px;
    font-weight: 500;
    margin-bottom: 8px;
    color: #666;
}

.cart-empty span {
    font-size: 14px;
}

.cart-items {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

/* 장바구니 아이템 */
.cart-item {
    display: flex;
    gap: 12px;
    padding: 12px;
    background: #f8fafc;
    border-radius: 12px;
    position: relative;
}

.cart-item-image {
    width: 80px;
    height: 60px;
    border-radius: 8px;
    overflow: hidden;
    flex-shrink: 0;
}

.cart-item-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.cart-item-info {
    flex: 1;
    min-width: 0;
}

.cart-item-name {
    font-size: 14px;
    font-weight: 600;
    color: #333;
    margin-bottom: 4px;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.cart-item-price {
    font-size: 15px;
    font-weight: 700;
    color: var(--primary-color);
}

.cart-item-quantity {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-top: 8px;
}

.quantity-btn {
    width: 28px;
    height: 28px;
    border-radius: 6px;
    border: 1px solid #ddd;
    background: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    transition: all 0.2s ease;
}

.quantity-btn:hover {
    border-color: var(--primary-color);
    color: var(--primary-color);
}

.quantity-value {
    font-size: 14px;
    font-weight: 600;
    min-width: 24px;
    text-align: center;
}

.cart-item-remove {
    position: absolute;
    top: 8px;
    right: 8px;
    width: 24px;
    height: 24px;
    border-radius: 50%;
    border: none;
    background: transparent;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #999;
    font-size: 14px;
    transition: all 0.2s ease;
}

.cart-item-remove:hover {
    background: #fee2e2;
    color: #ef4444;
}

/* 장바구니 푸터 */
.cart-footer {
    padding: 20px;
    border-top: 1px solid #eee;
    background: #f8fafc;
}

.cart-summary {
    margin-bottom: 16px;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 0;
    font-size: 14px;
    color: #666;
}

.summary-row.total {
    font-size: 18px;
    font-weight: 700;
    color: #333;
    border-top: 1px solid #ddd;
    padding-top: 12px;
    margin-top: 8px;
}

.summary-row.total span:last-child {
    color: var(--primary-color);
}

.cart-checkout-btn {
    width: 100%;
    padding: 14px;
    font-size: 16px;
    font-weight: 600;
}

/* 반응형 */
@media (max-width: 480px) {
    .cart-sidebar {
        width: 100%;
        right: -100%;
    }

    .floating-cart-btn {
        right: 24px;
        bottom: 90px;
        width: 56px;
        height: 56px;
    }
}
</style>

<script>
// 인기 검색어 목록
var popularKeywords = ['스쿠버다이빙', '카약', '승마', '아쿠아리움', '요리 클래스', 'ATV', '버스투어', '스노클링'];
var currentKeywordIndex = 0;
var rotateInterval;
var isHovering = false;

// 인기 검색어 순환
function rotateKeyword() {
    if (isHovering) return; // 호버 중에는 회전 안함

    currentKeywordIndex = (currentKeywordIndex + 1) % popularKeywords.length;
    var keywordEl = document.getElementById('rotatingKeyword');
    if (keywordEl) {
        // 페이드 아웃
        keywordEl.style.opacity = '0';
        keywordEl.style.transform = 'translateY(-10px)';

        setTimeout(function() {
            keywordEl.textContent = popularKeywords[currentKeywordIndex];
            // 페이드 인
            keywordEl.style.opacity = '1';
            keywordEl.style.transform = 'translateY(0)';
        }, 300);
    }
}

// 3초마다 검색어 변경
rotateInterval = setInterval(rotateKeyword, 3000);

// 더 많은 키워드 표시
function showMoreKeywords() {
    isHovering = true;
    var moreKeywordsEl = document.getElementById('moreKeywords');
    if (!moreKeywordsEl) return;

    // 현재 인덱스 다음부터 4개 표시
    var html = '';
    for (var i = 1; i <= 4; i++) {
        var idx = (currentKeywordIndex + i) % popularKeywords.length;
        html += '<span class="more-keyword-item" onclick="selectKeywordByText(\'' + popularKeywords[idx] + '\')">' + popularKeywords[idx] + '</span>';
    }
    moreKeywordsEl.innerHTML = html;
    moreKeywordsEl.classList.add('active');
}

// 더 많은 키워드 숨기기
function hideMoreKeywords() {
    isHovering = false;
    var moreKeywordsEl = document.getElementById('moreKeywords');
    if (moreKeywordsEl) {
        moreKeywordsEl.classList.remove('active');
    }
}

// 키워드 선택
function selectKeywordByText(keyword) {
    document.getElementById('keyword').value = keyword;
    hideMoreKeywords();
    showToast('"' + keyword + '" 검색 결과를 불러오는 중...', 'info');
}

// ==================== 인피니티 스크롤 ====================
var tourCurrentPage = 1;
var tourIsLoading = false;
var tourHasMore = true;
var tourTotalPages = 4;
var isBusiness = ${sessionScope.loginUser.userType eq 'BUSINESS'};

// 추가 투어 데모 데이터
var additionalTours = [
    {
        id: 9,
        name: '제주 패러글라이딩 체험',
        category: '액티비티',
        location: '제주 서귀포시',
        image: 'https://images.unsplash.com/photo-1503220317375-aaad61436b1b?w=400&h=300&fit=crop&q=80',
        rating: 4.8,
        reviews: 189,
        price: 95000,
        originalPrice: 120000,
        stock: 28
    },
    {
        id: 10,
        name: '제주 올레길 트레킹 가이드 투어',
        category: '투어',
        location: '제주 전역',
        image: 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=400&h=300&fit=crop&q=80',
        rating: 4.7,
        reviews: 234,
        price: 55000,
        originalPrice: null,
        stock: 4
    },
    {
        id: 11,
        name: '제주 감귤 농장 체험',
        category: '체험',
        location: '제주 서귀포시',
        image: 'https://images.unsplash.com/photo-1557800636-894a64c1696f?w=400&h=300&fit=crop&q=80',
        rating: 4.6,
        reviews: 156,
        price: 25000,
        originalPrice: 30000,
        stock: 55
    }
];

// 페이지 로드시 인피니티 스크롤 초기화
document.addEventListener('DOMContentLoaded', function() {
    initTourInfiniteScroll();
});

function initTourInfiniteScroll() {
    var loader = document.getElementById('tourScrollLoader');
    if (!loader) return;

    var observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting && !tourIsLoading && tourHasMore) {
                loadMore();
            }
        });
    }, {
        root: null,
        rootMargin: '100px',
        threshold: 0
    });

    observer.observe(loader);
}

function loadMore() {
    if (tourIsLoading || !tourHasMore) return;

    tourIsLoading = true;
    document.getElementById('tourScrollLoader').style.display = 'flex';

    setTimeout(function() {
        tourCurrentPage++;

        if (tourCurrentPage > tourTotalPages) {
            tourHasMore = false;
            document.getElementById('tourScrollLoader').style.display = 'none';
            document.getElementById('tourScrollEnd').style.display = 'block';
            tourIsLoading = false;
            return;
        }

        var grid = document.querySelector('.tour-grid');
        var toursToAdd = getToursForPage(tourCurrentPage);

        toursToAdd.forEach(function(tour, index) {
            var tourHtml = createTourCard(tour);
            var tempDiv = document.createElement('div');
            tempDiv.innerHTML = tourHtml;
            var newCard = tempDiv.firstElementChild;

            newCard.style.opacity = '0';
            newCard.style.transform = 'translateY(20px)';
            grid.appendChild(newCard);

            setTimeout(function() {
                newCard.style.transition = 'all 0.4s ease';
                newCard.style.opacity = '1';
                newCard.style.transform = 'translateY(0)';
            }, index * 100);
        });

        tourIsLoading = false;
    }, 800);
}

function getToursForPage(page) {
    var tours = [];
    for (var i = 0; i < 3; i++) {
        var dataIndex = ((page - 2) * 3 + i) % additionalTours.length;
        var tour = Object.assign({}, additionalTours[dataIndex]);
        tour.id = 8 + (page - 2) * 3 + i + 1;
        tours.push(tour);
    }
    return tours;
}

function createTourCard(data) {
    var originalPriceHtml = data.originalPrice ?
        '<span class="original">' + data.originalPrice.toLocaleString() + '원</span>' : '';

    var cartBtnHtml = !isBusiness ?
        '<button class="tour-cart-btn" onclick="addToCart(this)" title="장바구니 담기">' +
            '<i class="bi bi-cart-plus"></i>' +
        '</button>' : '';

    // 재고 표시 HTML 생성
    var stockClass = data.stock <= 10 ? 'tour-stock stock-warning' : 'tour-stock';
    var stockIcon = data.stock <= 10 ? 'bi-exclamation-triangle' : 'bi-box-seam';
    var stockLabel = data.stock <= 10 ? '품절 임박:' : '남은 수량:';
    var stockHtml = '<div class="' + stockClass + '">' +
        '<i class="bi ' + stockIcon + '"></i> ' + stockLabel + ' <span class="stock-count">' + data.stock + '개</span>' +
    '</div>';

    return '<div class="tour-card" data-id="' + data.id + '" data-name="' + data.name + '" data-price="' + data.price + '" data-image="' + data.image + '">' +
        '<a href="${pageContext.request.contextPath}/product/tour/' + data.id + '" class="tour-link">' +
            '<div class="tour-image">' +
                '<img src="' + data.image + '" alt="' + data.name + '">' +
                '<span class="tour-category">' + data.category + '</span>' +
            '</div>' +
            '<div class="tour-body">' +
                '<p class="tour-location"><i class="bi bi-geo-alt"></i> ' + data.location + '</p>' +
                '<h4 class="tour-name">' + data.name + '</h4>' +
                '<div class="tour-rating">' +
                    '<i class="bi bi-star-fill"></i>' +
                    '<span>' + data.rating + '</span>' +
                    '<span class="text-muted">(' + data.reviews + ')</span>' +
                '</div>' +
                '<div class="tour-price">' +
                    originalPriceHtml +
                    '<span class="price">' + data.price.toLocaleString() + '원</span>' +
                '</div>' +
                stockHtml +
            '</div>' +
        '</a>' +
        cartBtnHtml +
    '</div>';
}

// 검색 폼 제출
document.getElementById('tourSearchForm').addEventListener('submit', function(e) {
    e.preventDefault();
    var keyword = document.getElementById('keyword').value;
    if (keyword) {
        showToast('"' + keyword + '" 검색 결과를 불러오는 중...', 'info');
    } else {
        showToast('상품을 검색하고 있습니다...', 'info');
    }
});

// ==================== 장바구니 기능 ====================
var cart = [];

// 페이지 로드시 장바구니 불러오기
document.addEventListener('DOMContentLoaded', function() {
    loadCart();
    updateCartUI();
});

// 로컬스토리지에서 장바구니 불러오기
function loadCart() {
    var savedCart = localStorage.getItem('tourCart');
    if (savedCart) {
        try {
            cart = JSON.parse(savedCart);
        } catch (e) {
            cart = [];
        }
    }
}

// 로컬스토리지에 장바구니 저장
function saveCart() {
    localStorage.setItem('tourCart', JSON.stringify(cart));
}

// 장바구니에 상품 추가
function addToCart(btn) {
    event.stopPropagation();
    event.preventDefault();

    var card = btn.closest('.tour-card');
    var id = card.dataset.id;
    var name = card.dataset.name;
    var price = parseInt(card.dataset.price);
    var image = card.dataset.image;

    // 이미 장바구니에 있는지 확인
    var existingItem = cart.find(function(item) {
        return item.id === id;
    });

    if (existingItem) {
        existingItem.quantity++;
        showToast('수량이 추가되었습니다', 'success');
    } else {
        cart.push({
            id: id,
            name: name,
            price: price,
            image: image,
            quantity: 1
        });
        showToast('장바구니에 담겼습니다', 'success');
    }

    // 버튼 애니메이션
    btn.classList.add('added');
    btn.innerHTML = '<i class="bi bi-cart-check"></i>';

    setTimeout(function() {
        btn.classList.remove('added');
        btn.innerHTML = '<i class="bi bi-cart-plus"></i>';
    }, 1500);

    saveCart();
    updateCartUI();
}

// 장바구니에서 상품 제거
function removeFromCart(id) {
    cart = cart.filter(function(item) {
        return item.id !== id;
    });

    saveCart();
    updateCartUI();
    renderCart();
    showToast('상품이 제거되었습니다', 'info');
}

// 수량 변경
function updateQuantity(id, delta) {
    var item = cart.find(function(item) {
        return item.id === id;
    });

    if (item) {
        item.quantity += delta;

        if (item.quantity <= 0) {
            removeFromCart(id);
            return;
        }

        saveCart();
        updateCartUI();
        renderCart();
    }
}

// 장바구니 UI 업데이트 (뱃지, 총액)
function updateCartUI() {
    var totalItems = cart.reduce(function(sum, item) {
        return sum + item.quantity;
    }, 0);

    var totalPrice = cart.reduce(function(sum, item) {
        return sum + (item.price * item.quantity);
    }, 0);

    // 뱃지 업데이트
    var badge = document.getElementById('cartBadge');
    if (badge) {
        badge.textContent = totalItems;
        badge.setAttribute('data-count', totalItems);
        badge.style.display = totalItems > 0 ? 'flex' : 'none';
    }

    // 상품 수 업데이트
    var itemCount = document.getElementById('cartItemCount');
    if (itemCount) {
        itemCount.textContent = totalItems + '개';
    }

    // 총 금액 업데이트
    var totalPriceEl = document.getElementById('cartTotalPrice');
    if (totalPriceEl) {
        totalPriceEl.textContent = totalPrice.toLocaleString() + '원';
    }

    // 빈 장바구니 표시 처리
    var cartEmpty = document.getElementById('cartEmpty');
    var cartItems = document.getElementById('cartItems');
    var cartFooter = document.getElementById('cartFooter');

    if (cart.length === 0) {
        if (cartEmpty) cartEmpty.style.display = 'flex';
        if (cartItems) cartItems.style.display = 'none';
        if (cartFooter) cartFooter.style.display = 'none';
    } else {
        if (cartEmpty) cartEmpty.style.display = 'none';
        if (cartItems) cartItems.style.display = 'flex';
        if (cartFooter) cartFooter.style.display = 'block';
    }
}

// 장바구니 렌더링
function renderCart() {
    var cartItemsEl = document.getElementById('cartItems');
    if (!cartItemsEl) return;

    if (cart.length === 0) {
        cartItemsEl.innerHTML = '';
        updateCartUI();
        return;
    }

    var html = '';
    cart.forEach(function(item) {
        var itemTotal = item.price * item.quantity;
        html += '<div class="cart-item" data-id="' + item.id + '">' +
            '<div class="cart-item-image">' +
                '<img src="' + item.image + '" alt="' + item.name + '">' +
            '</div>' +
            '<div class="cart-item-info">' +
                '<div class="cart-item-name">' + item.name + '</div>' +
                '<div class="cart-item-price">' + itemTotal.toLocaleString() + '원</div>' +
                '<div class="cart-item-quantity">' +
                    '<button class="quantity-btn" onclick="updateQuantity(\'' + item.id + '\', -1)">' +
                        '<i class="bi bi-dash"></i>' +
                    '</button>' +
                    '<span class="quantity-value">' + item.quantity + '</span>' +
                    '<button class="quantity-btn" onclick="updateQuantity(\'' + item.id + '\', 1)">' +
                        '<i class="bi bi-plus"></i>' +
                    '</button>' +
                '</div>' +
            '</div>' +
            '<button class="cart-item-remove" onclick="removeFromCart(\'' + item.id + '\')" title="삭제">' +
                '<i class="bi bi-x"></i>' +
            '</button>' +
        '</div>';
    });

    cartItemsEl.innerHTML = html;
    updateCartUI();
}

// 장바구니 열기
function openCart() {
    renderCart();
    document.getElementById('cartOverlay').classList.add('active');
    document.getElementById('cartSidebar').classList.add('active');
    document.body.style.overflow = 'hidden';
}

// 장바구니 닫기
function closeCart() {
    document.getElementById('cartOverlay').classList.remove('active');
    document.getElementById('cartSidebar').classList.remove('active');
    document.body.style.overflow = '';
}

// 결제하기 (체크아웃)
function checkout() {
    if (cart.length === 0) {
        showToast('장바구니가 비어있습니다', 'warning');
        return;
    }

    // 로그인 체크
    var isLoggedIn = ${not empty sessionScope.loginUser};
    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    // 장바구니 데이터를 sessionStorage에 저장 (결제 페이지에서 사용)
    sessionStorage.setItem('tourCartCheckout', JSON.stringify(cart));

    // 결제 페이지로 이동
    window.location.href = '${pageContext.request.contextPath}/booking/tour/checkout';
}

// ESC 키로 장바구니 닫기
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeCart();
    }
});
</script>

<c:set var="pageJs" value="product" />
<%@ include file="../common/footer.jsp" %>
