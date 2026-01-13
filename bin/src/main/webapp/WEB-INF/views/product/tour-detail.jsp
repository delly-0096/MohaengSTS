<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="제주 스쿠버다이빙 체험" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>

<div class="product-detail-page">
    <div class="container">
        <!-- 브레드크럼 -->
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/">홈</a>
            <span class="mx-2">/</span>
            <a href="${pageContext.request.contextPath}/product/tour">투어/체험/티켓</a>
            <span class="mx-2">/</span>
            <span>제주 스쿠버다이빙 체험</span>
        </nav>

        <!-- 갤러리 -->
        <div class="product-gallery">
            <div class="gallery-main">
                <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800&h=500&fit=crop&q=80"
                     alt="스쿠버다이빙" id="mainImage">
            </div>
            <div class="gallery-thumbs">
                <img src="https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=200&h=150&fit=crop&q=80"
                     alt="스쿠버다이빙" onclick="changeMainImage(this)">
                <img src="https://images.unsplash.com/photo-1682687220742-aba13b6e50ba?w=200&h=150&fit=crop&q=80"
                     alt="스쿠버다이빙" onclick="changeMainImage(this)">
            </div>
        </div>

        <div class="product-detail-content">
            <!-- 상품 정보 -->
            <div class="product-info">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="badge bg-primary">액티비티</span>
                    <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.userType ne 'BUSINESS'}">
                    <button class="report-btn" onclick="openReportModal('product', '1', '제주 스쿠버다이빙 체험 (초보자 가능)')">
                        <i class="bi bi-flag"></i> 신고
                    </button>
                    </c:if>
                </div>
                <h1>제주 스쿠버다이빙 체험 (초보자 가능)</h1>

                <div class="product-meta">
                    <span><i class="bi bi-geo-alt"></i> 제주 서귀포시 중문</span>
                    <span><i class="bi bi-clock"></i> 약 2시간</span>
                    <span><i class="bi bi-star-fill text-warning"></i> 4.9 (328 리뷰)</span>
                </div>

                <!-- 상품 설명 -->
                <div class="product-description">
                    <h3>상품 소개</h3>
                    <p>
                        제주도의 맑고 깨끗한 바다에서 스쿠버다이빙을 체험해보세요!
                        수영을 못하셔도, 스쿠버다이빙이 처음이셔도 괜찮습니다.
                        전문 강사가 1:1로 안전하게 안내해드립니다.
                    </p>
                    <p>
                        제주 바다 속 아름다운 산호초와 열대어들을 직접 눈으로 확인하실 수 있으며,
                        수중 사진 촬영 서비스도 함께 제공됩니다.
                    </p>
                </div>

                <!-- 포함/불포함 -->
                <div class="product-description">
                    <h3>포함 사항</h3>
                    <ul class="mb-4">
                        <li><i class="bi bi-check-circle text-success me-2"></i>전문 강사 1:1 지도</li>
                        <li><i class="bi bi-check-circle text-success me-2"></i>스쿠버다이빙 장비 대여</li>
                        <li><i class="bi bi-check-circle text-success me-2"></i>수중 사진 촬영</li>
                        <li><i class="bi bi-check-circle text-success me-2"></i>샤워 시설 이용</li>
                    </ul>

                    <h3>불포함 사항</h3>
                    <ul>
                        <li><i class="bi bi-x-circle text-danger me-2"></i>픽업/샌딩 서비스</li>
                        <li><i class="bi bi-x-circle text-danger me-2"></i>개인 물품 (수영복, 타월 등)</li>
                    </ul>
                </div>

                <!-- 이용 안내 -->
                <div class="product-description">
                    <h3>이용 안내</h3>
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>운영 시간</strong></p>
                            <p class="text-muted">매일 09:00 - 18:00 (1시간 단위 예약)</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>소요 시간</strong></p>
                            <p class="text-muted">약 2시간 (실제 다이빙 40분)</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>최소 인원</strong></p>
                            <p class="text-muted">1명</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>연령 제한</strong></p>
                            <p class="text-muted">만 10세 이상</p>
                        </div>
                    </div>
                </div>

                <!-- 위치 -->
                <div class="product-description" style="border-bottom: none;">
                    <h3>위치</h3>
                    <p><i class="bi bi-geo-alt me-2"></i>제주특별자치도 서귀포시 중문관광로 123</p>
                    <div class="bg-light rounded-3 p-4 text-center" style="height: 200px;">
                        <i class="bi bi-map" style="font-size: 48px; color: var(--gray-medium);"></i>
                        <p class="mt-2 text-muted">지도가 표시됩니다</p>
                    </div>
                </div>
            </div>

            <!-- 결제 사이드바 -->
            <aside class="booking-sidebar">
                <div class="booking-card">
                    <div class="booking-price">
                        <span class="original">85,000원</span>
                        <div>
                            <span class="price">68,000</span>
                            <span class="per-person">원 / 1인</span>
                        </div>
                    </div>

                    <form class="booking-form" id="bookingForm">
                        <div class="form-group">
                            <label class="form-label">날짜 선택</label>
                            <input type="text" class="form-control date-picker" id="bookingDate"
                                   placeholder="날짜를 선택하세요" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">시간 선택</label>
                            <select class="form-control form-select" id="bookingTime" required>
                                <option value="">시간을 선택하세요</option>
                                <option value="09:00">09:00</option>
                                <option value="10:00">10:00</option>
                                <option value="11:00">11:00</option>
                                <option value="14:00">14:00</option>
                                <option value="15:00">15:00</option>
                                <option value="16:00">16:00</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">인원 선택</label>
                            <select class="form-control form-select" id="bookingPeople" onchange="updateTotal()">
                                <option value="1">1명</option>
                                <option value="2" selected>2명</option>
                                <option value="3">3명</option>
                                <option value="4">4명</option>
                            </select>
                        </div>

                        <div class="booking-total">
                            <span class="booking-total-label">총 금액</span>
                            <span class="booking-total-price" id="totalPrice">136,000원</span>
                        </div>

                        <div class="booking-actions">
                            <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                            <button type="button" class="btn btn-outline w-100" onclick="addToBookmark()">
                                <i class="bi bi-bookmark me-2"></i>북마크
                            </button>
                            <button type="button" class="btn btn-outline-primary w-100" onclick="addToCartFromDetail()">
                                <i class="bi bi-cart-plus me-2"></i>장바구니
                            </button>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-credit-card me-2"></i>바로 결제
                            </button>
                            </c:if>
                            <c:if test="${sessionScope.loginUser.userType eq 'BUSINESS'}">
                            <div class="business-notice mt-2">
                                <small class="text-muted"><i class="bi bi-info-circle me-1"></i>기업회원은 구매가 불가합니다.</small>
                            </div>
                            </c:if>
                        </div>
                    </form>
                </div>
            </aside>
        </div>

        <!-- 리뷰 섹션 -->
        <div class="mt-5">
            <h3 class="mb-4">리뷰 (328)</h3>
            <div class="card mb-3">
                <div class="card-body">
                    <div class="d-flex gap-3">
                        <div class="user-avatar" style="width: 48px; height: 48px;">
                            <i class="bi bi-person"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <strong>travel_lover</strong>
                                    <div class="text-warning">
                                        <i class="bi bi-star-fill"></i>
                                        <i class="bi bi-star-fill"></i>
                                        <i class="bi bi-star-fill"></i>
                                        <i class="bi bi-star-fill"></i>
                                        <i class="bi bi-star-fill"></i>
                                    </div>
                                </div>
                                <small class="text-muted">2024.03.10</small>
                            </div>
                            <p class="mt-2 mb-0">
                                수영을 못해서 걱정했는데 강사님이 정말 친절하게 알려주셔서 안전하게 잘 체험했어요!
                                제주 바다가 이렇게 예쁜 줄 몰랐네요. 사진도 잘 찍어주셔서 추억 남기기 딱이에요!
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 판매자 문의 섹션 -->
        <div class="inquiry-section mt-5">
            <div class="inquiry-header">
                <h3><i class="bi bi-chat-dots me-2"></i>판매자 문의</h3>
                <p class="text-muted">상품에 대해 궁금한 점이 있으신가요? 판매자에게 직접 문의해보세요.</p>
            </div>

            <!-- 판매자 정보 -->
            <div class="seller-info-card">
                <div class="seller-profile">
                    <div class="seller-logo">
                        <i class="bi bi-building"></i>
                    </div>
                    <div class="seller-details">
                        <h4>제주다이브센터</h4>
                        <div class="seller-meta">
                            <span><i class="bi bi-patch-check-fill text-primary"></i> 인증업체</span>
                            <span><i class="bi bi-star-fill text-warning"></i> 4.9</span>
                            <span><i class="bi bi-chat-dots"></i> 응답률 98%</span>
                        </div>
                        <p class="seller-desc">제주도 스쿠버다이빙 전문 업체로 10년 이상의 경험을 보유하고 있습니다.</p>
                    </div>
                </div>
                <div class="seller-contact">
                    <span><i class="bi bi-clock"></i> 평균 응답시간: 1시간 이내</span>
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
                            <option value="product">상품 문의</option>
                            <option value="booking">예약/일정 문의</option>
                            <option value="price">가격/결제 문의</option>
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
                    <h4><i class="bi bi-list-ul me-2"></i>문의 내역 <span class="inquiry-count">(12)</span></h4>
                </div>
                <div class="inquiry-list">
                    <!-- 문의 아이템 1 -->
                    <div class="inquiry-item">
                        <div class="inquiry-item-header">
                            <div class="inquiry-item-info">
                                <span class="inquiry-type-badge product">상품 문의</span>
                                <span class="inquiry-author">jeju_trip**</span>
                                <span class="inquiry-date">2024.03.15</span>
                            </div>
                            <span class="inquiry-status answered">답변완료</span>
                        </div>
                        <div class="inquiry-item-question">
                            <p><strong>Q.</strong> 수영을 전혀 못해도 체험이 가능한가요? 물에 대한 공포가 조금 있어서요.</p>
                        </div>
                        <div class="inquiry-item-answer">
                            <div class="answer-header">
                                <span class="answer-badge"><i class="bi bi-building"></i> 판매자 답변</span>
                                <span class="answer-date">2024.03.15</span>
                            </div>
                            <p><strong>A.</strong> 안녕하세요, 제주다이브센터입니다. 수영을 못하셔도 전혀 문제없습니다!
                            전문 강사가 1:1로 안전하게 안내해드리며, 물에 대한 공포가 있으신 분들도 많이 체험하시고
                            즐거운 시간 보내셨습니다. 체험 전 충분한 교육과 적응 시간을 드리니 안심하고 오세요!</p>
                        </div>
                    </div>

                    <!-- 문의 아이템 2 -->
                    <div class="inquiry-item">
                        <div class="inquiry-item-header">
                            <div class="inquiry-item-info">
                                <span class="inquiry-type-badge booking">예약/일정</span>
                                <span class="inquiry-author">happy_d**</span>
                                <span class="inquiry-date">2024.03.12</span>
                            </div>
                            <span class="inquiry-status answered">답변완료</span>
                        </div>
                        <div class="inquiry-item-question">
                            <p><strong>Q.</strong> 당일 예약도 가능한가요? 제주도 여행 중인데 갑자기 하고 싶어져서요.</p>
                        </div>
                        <div class="inquiry-item-answer">
                            <div class="answer-header">
                                <span class="answer-badge"><i class="bi bi-building"></i> 판매자 답변</span>
                                <span class="answer-date">2024.03.12</span>
                            </div>
                            <p><strong>A.</strong> 네, 당일 예약도 가능합니다! 다만 예약 상황에 따라 원하시는 시간대가
                            마감될 수 있으니, 가능하면 하루 전 예약을 권장드립니다. 급하신 경우 064-XXX-XXXX로
                            전화주시면 빠르게 확인해드리겠습니다.</p>
                        </div>
                    </div>

                    <!-- 문의 아이템 3 (비밀글) -->
                    <div class="inquiry-item secret">
                        <div class="inquiry-item-header">
                            <div class="inquiry-item-info">
                                <span class="inquiry-type-badge cancel">취소/환불</span>
                                <span class="inquiry-author">user12**</span>
                                <span class="inquiry-date">2024.03.10</span>
                                <span class="secret-badge"><i class="bi bi-lock"></i> 비밀글</span>
                            </div>
                            <span class="inquiry-status answered">답변완료</span>
                        </div>
                        <div class="inquiry-item-question">
                            <p class="secret-content"><i class="bi bi-lock me-1"></i>비밀글로 작성된 문의입니다.</p>
                        </div>
                    </div>

                    <!-- 문의 아이템 4 (대기중) -->
                    <div class="inquiry-item" data-inquiry-id="4">
                        <div class="inquiry-item-header">
                            <div class="inquiry-item-info">
                                <span class="inquiry-type-badge price">가격/결제</span>
                                <span class="inquiry-author">travel_**</span>
                                <span class="inquiry-date">2024.03.18</span>
                            </div>
                            <span class="inquiry-status waiting">답변대기</span>
                        </div>
                        <div class="inquiry-item-question">
                            <p><strong>Q.</strong> 4명이 같이 가면 단체 할인이 있나요?</p>
                        </div>
                        <!-- 기업회원 답변 영역 -->
                        <c:if test="${sessionScope.loginUser.userType eq 'BUSINESS'}">
                        <div class="business-reply-section">
                            <button class="btn btn-sm btn-primary" onclick="toggleReplyForm(4)">
                                <i class="bi bi-reply me-1"></i>답변하기
                            </button>
                            <div class="reply-form" id="replyForm_4" style="display: none;">
                                <textarea class="form-control" id="replyContent_4" rows="3"
                                          placeholder="답변 내용을 입력하세요..."></textarea>
                                <div class="reply-form-actions">
                                    <button class="btn btn-sm btn-outline" onclick="toggleReplyForm(4)">취소</button>
                                    <button class="btn btn-sm btn-primary" onclick="submitReply(4)">답변 등록</button>
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

/* 버튼 스타일 추가 */
.btn-outline-primary {
    border: 2px solid var(--primary-color);
    color: var(--primary-color);
    background: transparent;
}

.btn-outline-primary:hover {
    background: var(--primary-color);
    color: white;
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

/* ==================== 판매자 문의 섹션 ==================== */
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

.inquiry-type-badge.product {
    background: #dbeafe;
    color: #1d4ed8;
}

.inquiry-type-badge.booking {
    background: #dcfce7;
    color: #15803d;
}

.inquiry-type-badge.price {
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

/* 문의 추가 애니메이션 */
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
</style>

<script>
const pricePerPerson = 68000;

// 현재 상품 정보
const currentProduct = {
    id: '1',
    name: '제주 스쿠버다이빙 체험 (초보자 가능)',
    price: 68000,
    image: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=300&fit=crop&q=80'
};

// 장바구니 데이터
var cart = [];

function changeMainImage(thumb) {
    document.getElementById('mainImage').src = thumb.src;
}

function updateTotal() {
    const people = parseInt(document.getElementById('bookingPeople').value);
    const total = pricePerPerson * people;
    document.getElementById('totalPrice').textContent = total.toLocaleString() + '원';
}

function addToBookmark() {
    const isLoggedIn = ${not empty sessionScope.loginUser};

    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    showToast('북마크에 추가되었습니다.', 'success');
}

document.getElementById('bookingForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const isLoggedIn = ${not empty sessionScope.loginUser};

    if (!isLoggedIn) {
        sessionStorage.setItem('returnUrl', window.location.href);
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    const date = document.getElementById('bookingDate').value;
    const time = document.getElementById('bookingTime').value;

    if (!date || !time) {
        showToast('날짜와 시간을 선택해주세요.', 'error');
        return;
    }

    // 결제 페이지로 이동
    window.location.href = '${pageContext.request.contextPath}/product/tour/1/booking?date=' + date + '&time=' + time +
                           '&people=' + document.getElementById('bookingPeople').value;
});

// ==================== 장바구니 기능 ====================

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

// 상세페이지에서 장바구니에 추가
function addToCartFromDetail() {
    var people = parseInt(document.getElementById('bookingPeople').value) || 1;

    // 이미 장바구니에 있는지 확인
    var existingItem = cart.find(function(item) {
        return item.id === currentProduct.id;
    });

    if (existingItem) {
        existingItem.quantity += people;
        showToast('장바구니에 ' + people + '개 추가되었습니다', 'success');
    } else {
        cart.push({
            id: currentProduct.id,
            name: currentProduct.name,
            price: currentProduct.price,
            image: currentProduct.image,
            quantity: people
        });
        showToast('장바구니에 담겼습니다 (' + people + '개)', 'success');
    }

    saveCart();
    updateCartUI();

    // 장바구니 사이드바 열기
    setTimeout(function() {
        openCart();
    }, 500);
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

// ==================== 판매자 문의 기능 ====================

// 문의 폼 제출
document.getElementById('inquiryForm').addEventListener('submit', function(e) {
    e.preventDefault();

    // 로그인 체크
    var isLoggedIn = ${not empty sessionScope.loginUser};
    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    // 폼 데이터 수집
    var inquiryType = document.getElementById('inquiryType').value;
    var inquiryContent = document.getElementById('inquiryContent').value;
    var isSecret = document.getElementById('inquirySecret').checked;

    // 유효성 검사
    if (!inquiryType) {
        showToast('문의 유형을 선택해주세요.', 'warning');
        document.getElementById('inquiryType').focus();
        return;
    }

    if (!inquiryContent.trim()) {
        showToast('문의 내용을 입력해주세요.', 'warning');
        document.getElementById('inquiryContent').focus();
        return;
    }

    if (inquiryContent.trim().length < 10) {
        showToast('문의 내용을 10자 이상 입력해주세요.', 'warning');
        document.getElementById('inquiryContent').focus();
        return;
    }

    // 문의 데이터 객체
    var inquiryData = {
        productId: currentProduct.id,
        type: inquiryType,
        content: inquiryContent.trim(),
        isSecret: isSecret
    };

    console.log('문의 등록 데이터:', inquiryData);

    // TODO: 실제 API 호출로 변경
    // 성공 시뮬레이션
    showToast('문의가 등록되었습니다. 판매자 답변을 기다려주세요.', 'success');

    // 폼 초기화
    document.getElementById('inquiryForm').reset();

    // 새 문의를 목록 맨 앞에 추가 (미리보기)
    addNewInquiryToList(inquiryData);
});

// 새 문의를 목록에 추가
function addNewInquiryToList(data) {
    var inquiryList = document.querySelector('.inquiry-list');
    if (!inquiryList) return;

    // 문의 유형 라벨
    var typeLabels = {
        'product': '상품 문의',
        'booking': '예약/일정',
        'price': '가격/결제',
        'cancel': '취소/환불',
        'other': '기타'
    };

    // 현재 날짜
    var today = new Date();
    var dateStr = today.getFullYear() + '.' +
                  String(today.getMonth() + 1).padStart(2, '0') + '.' +
                  String(today.getDate()).padStart(2, '0');

    // 사용자 이름 마스킹 (실제로는 서버에서 처리)
    var userName = '${sessionScope.loginUser.userName}' || '회원';
    var maskedName = userName.length > 2 ?
                     userName.substring(0, 2) + '**' :
                     userName + '**';

    // 새 문의 HTML 생성
    var newInquiryHtml =
        '<div class="inquiry-item new-inquiry" style="animation: slideIn 0.3s ease-out;">' +
            '<div class="inquiry-item-header">' +
                '<div class="inquiry-item-info">' +
                    '<span class="inquiry-type-badge ' + data.type + '">' + typeLabels[data.type] + '</span>' +
                    '<span class="inquiry-author">' + maskedName + '</span>' +
                    '<span class="inquiry-date">' + dateStr + '</span>' +
                    (data.isSecret ? '<span class="secret-badge"><i class="bi bi-lock"></i> 비밀글</span>' : '') +
                '</div>' +
                '<span class="inquiry-status waiting">답변대기</span>' +
            '</div>' +
            '<div class="inquiry-item-question">' +
                (data.isSecret ?
                    '<p class="secret-content"><i class="bi bi-lock me-1"></i>비밀글로 작성된 문의입니다.</p>' :
                    '<p><strong>Q.</strong> ' + escapeHtml(data.content) + '</p>') +
            '</div>' +
        '</div>';

    // 목록 맨 앞에 추가
    inquiryList.insertAdjacentHTML('afterbegin', newInquiryHtml);

    // 문의 개수 업데이트
    var countEl = document.querySelector('.inquiry-count');
    if (countEl) {
        var currentCount = parseInt(countEl.textContent.replace(/[()]/g, '')) || 0;
        countEl.textContent = '(' + (currentCount + 1) + ')';
    }
}

// HTML 이스케이프 함수
function escapeHtml(text) {
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// 더 많은 문의 불러오기
var inquiryPage = 1;
function loadMoreInquiries() {
    inquiryPage++;

    // TODO: 실제 API 호출로 변경
    // 예시 데이터 추가
    var moreInquiries = [
        {
            type: 'other',
            typeLabel: '기타',
            author: 'summer**',
            date: '2024.03.08',
            status: 'answered',
            question: '주차장이 있나요? 렌터카로 방문하려고 합니다.',
            answer: '네, 무료 주차장이 마련되어 있습니다. 약 20대 정도 주차 가능하며, 성수기에는 일찍 오시는 것을 권장드립니다.',
            answerDate: '2024.03.08'
        },
        {
            type: 'product',
            typeLabel: '상품 문의',
            author: 'ocean_l**',
            date: '2024.03.05',
            status: 'answered',
            question: '사진 촬영한 것은 어떻게 받을 수 있나요?',
            answer: '체험 종료 후 카카오톡으로 보내드립니다. 보통 당일 저녁까지 전송해드리며, 원본 파일로 제공됩니다.',
            answerDate: '2024.03.05'
        }
    ];

    var inquiryList = document.querySelector('.inquiry-list');

    moreInquiries.forEach(function(item) {
        var html =
            '<div class="inquiry-item" style="animation: slideIn 0.3s ease-out;">' +
                '<div class="inquiry-item-header">' +
                    '<div class="inquiry-item-info">' +
                        '<span class="inquiry-type-badge ' + item.type + '">' + item.typeLabel + '</span>' +
                        '<span class="inquiry-author">' + item.author + '</span>' +
                        '<span class="inquiry-date">' + item.date + '</span>' +
                    '</div>' +
                    '<span class="inquiry-status ' + item.status + '">' +
                        (item.status === 'answered' ? '답변완료' : '답변대기') + '</span>' +
                '</div>' +
                '<div class="inquiry-item-question">' +
                    '<p><strong>Q.</strong> ' + item.question + '</p>' +
                '</div>' +
                (item.answer ?
                    '<div class="inquiry-item-answer">' +
                        '<div class="answer-header">' +
                            '<span class="answer-badge"><i class="bi bi-building"></i> 판매자 답변</span>' +
                            '<span class="answer-date">' + item.answerDate + '</span>' +
                        '</div>' +
                        '<p><strong>A.</strong> ' + item.answer + '</p>' +
                    '</div>' : '') +
            '</div>';

        inquiryList.insertAdjacentHTML('beforeend', html);
    });

    // 3페이지 이상이면 더보기 버튼 숨기기 (예시)
    if (inquiryPage >= 3) {
        document.querySelector('.inquiry-more').style.display = 'none';
        showToast('모든 문의를 불러왔습니다.', 'info');
    }
}

// ==================== 기업회원 답변 기능 ====================

// 답변 폼 토글
function toggleReplyForm(inquiryId) {
    var form = document.getElementById('replyForm_' + inquiryId);
    var btn = form.previousElementSibling;

    if (form.style.display === 'none') {
        form.style.display = 'block';
        btn.style.display = 'none';
        document.getElementById('replyContent_' + inquiryId).focus();
    } else {
        form.style.display = 'none';
        btn.style.display = 'inline-flex';
    }
}

// 답변 등록
function submitReply(inquiryId) {
    var content = document.getElementById('replyContent_' + inquiryId).value.trim();

    if (!content) {
        showToast('답변 내용을 입력해주세요.', 'warning');
        return;
    }

    if (content.length < 10) {
        showToast('답변은 10자 이상 입력해주세요.', 'warning');
        return;
    }

    // TODO: 실제 API 호출로 변경
    console.log('답변 등록:', { inquiryId: inquiryId, content: content });

    // 성공 시 UI 업데이트
    var inquiryItem = document.querySelector('[data-inquiry-id="' + inquiryId + '"]');
    if (inquiryItem) {
        // 상태 변경
        var statusBadge = inquiryItem.querySelector('.inquiry-status');
        statusBadge.className = 'inquiry-status answered';
        statusBadge.textContent = '답변완료';

        // 답변 영역 추가
        var questionDiv = inquiryItem.querySelector('.inquiry-item-question');
        var today = new Date();
        var dateStr = today.getFullYear() + '.' +
                      String(today.getMonth() + 1).padStart(2, '0') + '.' +
                      String(today.getDate()).padStart(2, '0');

        var answerHtml =
            '<div class="inquiry-item-answer" style="animation: slideIn 0.3s ease-out;">' +
                '<div class="answer-header">' +
                    '<span class="answer-badge"><i class="bi bi-building"></i> 판매자 답변</span>' +
                    '<span class="answer-date">' + dateStr + '</span>' +
                '</div>' +
                '<p><strong>A.</strong> ' + escapeHtml(content) + '</p>' +
            '</div>';

        questionDiv.insertAdjacentHTML('afterend', answerHtml);

        // 답변 폼 영역 제거
        var replySection = inquiryItem.querySelector('.business-reply-section');
        if (replySection) {
            replySection.remove();
        }
    }

    showToast('답변이 등록되었습니다.', 'success');
}
</script>

<%@ include file="../common/footer.jsp" %>
