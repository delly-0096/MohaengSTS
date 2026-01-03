<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="기업 대시보드" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../../common/header.jsp" %>

<div class="mypage business-mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>대시보드</h1>
                    <p>비즈니스 현황을 한눈에 확인하세요</p>
                </div>

                <!-- 통계 카드 -->
                <div class="stats-grid">
                    <div class="stat-card primary">
                        <div class="stat-icon"><i class="bi bi-currency-won"></i></div>
                        <div class="stat-value">3,250,000</div>
                        <div class="stat-label">이번 달 매출</div>
                    </div>
                    <div class="stat-card secondary">
                        <div class="stat-icon"><i class="bi bi-cart-check"></i></div>
                        <div class="stat-value">47</div>
                        <div class="stat-label">이번 달 예약</div>
                    </div>
                    <div class="stat-card accent">
                        <div class="stat-icon"><i class="bi bi-box-seam"></i></div>
                        <div class="stat-value">8</div>
                        <div class="stat-label">등록 상품</div>
                    </div>
                    <div class="stat-card warning">
                        <div class="stat-icon"><i class="bi bi-star-fill"></i></div>
                        <div class="stat-value">4.8</div>
                        <div class="stat-label">평균 평점</div>
                    </div>
                </div>

                <div class="row">
                    <!-- 최근 예약 -->
                    <div class="col-lg-8">
                        <div class="content-section">
                            <div class="section-header">
                                <h3><i class="bi bi-receipt"></i> 최근 예약</h3>
                                <a href="${pageContext.request.contextPath}/mypage/business/sales" class="view-all">
                                    전체보기 <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>

                            <div class="table-responsive">
                                <table class="sales-table">
                                    <thead>
                                        <tr>
                                            <th>예약번호</th>
                                            <th>상품명</th>
                                            <th>예약자</th>
                                            <th>금액</th>
                                            <th>상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>MH2403001</td>
                                            <td>제주 스쿠버다이빙 체험</td>
                                            <td>김OO</td>
                                            <td class="text-primary fw-bold">136,000원</td>
                                            <td><span class="payment-status completed">확정</span></td>
                                        </tr>
                                        <tr>
                                            <td>MH2403002</td>
                                            <td>한라산 트레킹 투어</td>
                                            <td>이OO</td>
                                            <td class="text-primary fw-bold">85,000원</td>
                                            <td><span class="payment-status completed">확정</span></td>
                                        </tr>
                                        <tr>
                                            <td>MH2403003</td>
                                            <td>제주 서핑 레슨</td>
                                            <td>박OO</td>
                                            <td class="text-primary fw-bold">65,000원</td>
                                            <td><span class="payment-status completed">확정</span></td>
                                        </tr>
                                        <tr>
                                            <td>MH2403004</td>
                                            <td>제주 스쿠버다이빙 체험</td>
                                            <td>최OO</td>
                                            <td class="text-primary fw-bold">204,000원</td>
                                            <td><span class="payment-status completed">확정</span></td>
                                        </tr>
                                        <tr>
                                            <td>MH2403005</td>
                                            <td>우도 자전거 투어</td>
                                            <td>정OO</td>
                                            <td class="text-primary fw-bold">45,000원</td>
                                            <td><span class="payment-status cancelled">취소</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- 알림 -->
                    <div class="col-lg-4">
                        <div class="content-section">
                            <div class="section-header">
                                <h3><i class="bi bi-bell"></i> 알림</h3>
                                <a href="${pageContext.request.contextPath}/mypage/business/notifications" class="view-all">
                                    전체보기 <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>

                            <div class="notification-list">
                                <div class="notification-item unread">
                                    <div class="notification-icon order">
                                        <i class="bi bi-cart-check"></i>
                                    </div>
                                    <div class="notification-content">
                                        <h4>새 예약이 들어왔습니다</h4>
                                        <p>제주 스쿠버다이빙 체험</p>
                                    </div>
                                    <span class="notification-time">10분 전</span>
                                </div>
                                <div class="notification-item unread">
                                    <div class="notification-icon review">
                                        <i class="bi bi-star"></i>
                                    </div>
                                    <div class="notification-content">
                                        <h4>새 후기가 등록되었습니다</h4>
                                        <p>한라산 트레킹 투어</p>
                                    </div>
                                    <span class="notification-time">1시간 전</span>
                                </div>
                                <div class="notification-item">
                                    <div class="notification-icon inquiry">
                                        <i class="bi bi-chat-dots"></i>
                                    </div>
                                    <div class="notification-content">
                                        <h4>문의가 접수되었습니다</h4>
                                        <p>제주 서핑 레슨 관련</p>
                                    </div>
                                    <span class="notification-time">3시간 전</span>
                                </div>
                                <div class="notification-item">
                                    <div class="notification-icon system">
                                        <i class="bi bi-gear"></i>
                                    </div>
                                    <div class="notification-content">
                                        <h4>정산 완료</h4>
                                        <p>2월 정산금 입금 완료</p>
                                    </div>
                                    <span class="notification-time">어제</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 상품 현황 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-box-seam"></i> 상품 현황</h3>
                        <a href="${pageContext.request.contextPath}/mypage/business/products" class="view-all">
                            전체보기 <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>

                    <div class="product-manage-list">
                        <div class="product-manage-item">
                            <div class="product-manage-info">
                                <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=80&h=80&fit=crop&q=80" alt="상품">
                                <div class="product-manage-details">
                                    <h4>제주 스쿠버다이빙 체험</h4>
                                    <span class="category">투어/체험</span>
                                    <div class="price">68,000원</div>
                                </div>
                            </div>
                            <div class="product-stats">
                                <div class="product-stat">
                                    <div class="value">156</div>
                                    <div class="label">조회</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">32</div>
                                    <div class="label">예약</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">4.9</div>
                                    <div class="label">평점</div>
                                </div>
                            </div>
                            <span class="product-status active">판매중</span>
                        </div>

                        <div class="product-manage-item">
                            <div class="product-manage-info">
                                <img src="https://images.unsplash.com/photo-1551632811-561732d1e306?w=80&h=80&fit=crop&q=80" alt="상품">
                                <div class="product-manage-details">
                                    <h4>한라산 트레킹 투어</h4>
                                    <span class="category">투어/체험</span>
                                    <div class="price">85,000원</div>
                                </div>
                            </div>
                            <div class="product-stats">
                                <div class="product-stat">
                                    <div class="value">89</div>
                                    <div class="label">조회</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">15</div>
                                    <div class="label">예약</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">4.7</div>
                                    <div class="label">평점</div>
                                </div>
                            </div>
                            <span class="product-status active">판매중</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<c:set var="pageJs" value="mypage" />
<%@ include file="../../common/footer.jsp" %>
