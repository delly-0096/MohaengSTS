<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="결제 내역" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../common/header.jsp" %>

<div class="mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>결제 내역</h1>
                    <p>예약 및 결제 내역을 확인하세요</p>
                </div>

                <!-- 통계 카드 -->
                <div class="stats-grid">
                    <div class="stat-card primary">
                        <div class="stat-icon"><i class="bi bi-credit-card"></i></div>
                        <div class="stat-value">5</div>
                        <div class="stat-label">전체 결제</div>
                    </div>
                    <div class="stat-card secondary">
                        <div class="stat-icon"><i class="bi bi-check-circle"></i></div>
                        <div class="stat-value">3</div>
                        <div class="stat-label">이용 완료</div>
                    </div>
                    <div class="stat-card accent">
                        <div class="stat-icon"><i class="bi bi-hourglass-split"></i></div>
                        <div class="stat-value">2</div>
                        <div class="stat-label">예정된 이용</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-currency-dollar"></i></div>
                        <div class="stat-value">524,000</div>
                        <div class="stat-label">총 결제금액</div>
                    </div>
                </div>

                <!-- 탭 -->
                <div class="mypage-tabs">
                    <button class="mypage-tab active" data-filter="all">전체</button>
                    <button class="mypage-tab" data-filter="completed">이용 완료</button>
                    <button class="mypage-tab" data-filter="pending">이용 예정</button>
                    <button class="mypage-tab" data-filter="cancelled">취소/환불</button>
                </div>

                <!-- 결제 내역 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-list-ul"></i> 결제 내역</h3>
                        <div class="d-flex gap-2">
                            <select class="form-select form-select-sm" style="width: 120px;">
                                <option>최근 3개월</option>
                                <option>최근 6개월</option>
                                <option>최근 1년</option>
                                <option>전체</option>
                            </select>
                        </div>
                    </div>

                    <div class="payment-list">
                        <!-- 결제 1 - 예정 -->
                        <div class="payment-item" data-status="pending" data-payment-id="1">
                            <div class="payment-product">
                                <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=120&h=120&fit=crop&q=80" alt="상품">
                                <div class="payment-product-info">
                                    <h4>제주 스쿠버다이빙 체험</h4>
                                    <p>2024.04.20 (토) 14:00 | 2명</p>
                                    <span class="payment-status pending">이용 예정</span>
                                </div>
                            </div>
                            <div class="payment-amount">
                                <div class="amount">136,000원</div>
                                <div class="date">결제일: 2024.03.15</div>
                            </div>
                            <div class="payment-actions">
                                <button class="btn btn-outline btn-sm" onclick="showReceipt(1)">
                                    <i class="bi bi-receipt"></i> 영수증
                                </button>
                                <button class="btn btn-outline-danger btn-sm" onclick="showCancelConfirm(1)">
                                    <i class="bi bi-x-circle"></i> 결제 취소
                                </button>
                            </div>
                        </div>

                        <!-- 결제 2 - 예정 -->
                        <div class="payment-item" data-status="pending" data-payment-id="2">
                            <div class="payment-product">
                                <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=120&h=120&fit=crop&q=80" alt="상품">
                                <div class="payment-product-info">
                                    <h4>제주 신라 호텔</h4>
                                    <p>2024.04.20 - 2024.04.22 (2박) | 디럭스룸</p>
                                    <span class="payment-status pending">이용 예정</span>
                                </div>
                            </div>
                            <div class="payment-amount">
                                <div class="amount">320,000원</div>
                                <div class="date">결제일: 2024.03.14</div>
                            </div>
                            <div class="payment-actions">
                                <button class="btn btn-outline btn-sm" onclick="showReceipt(2)">
                                    <i class="bi bi-receipt"></i> 영수증
                                </button>
                                <button class="btn btn-outline-danger btn-sm" onclick="showCancelConfirm(2)">
                                    <i class="bi bi-x-circle"></i> 결제 취소
                                </button>
                            </div>
                        </div>

                        <!-- 결제 3 - 완료 -->
                        <div class="payment-item" data-status="completed" data-payment-id="3">
                            <div class="payment-product">
                                <img src="https://images.unsplash.com/photo-1472745942893-4b9f730c7668?w=120&h=120&fit=crop&q=80" alt="상품">
                                <div class="payment-product-info">
                                    <h4>부산 해운대 카약 체험</h4>
                                    <p>2024.02.21 (수) 10:00 | 3명</p>
                                    <span class="payment-status completed">이용 완료</span>
                                </div>
                            </div>
                            <div class="payment-amount">
                                <div class="amount">45,000원</div>
                                <div class="date">결제일: 2024.02.15</div>
                            </div>
                            <div class="payment-actions">
                                <button class="btn btn-outline btn-sm" onclick="showReceipt(3)">
                                    <i class="bi bi-receipt"></i> 영수증
                                </button>
                                <button class="btn btn-primary btn-sm" onclick="openReviewModal(3)">
                                    <i class="bi bi-star"></i> 후기 작성
                                </button>
                            </div>
                        </div>

                        <!-- 결제 4 - 완료 (후기 작성 완료) -->
                        <div class="payment-item" data-status="completed" data-payment-id="4">
                            <div class="payment-product">
                                <img src="https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=120&h=120&fit=crop&q=80" alt="상품">
                                <div class="payment-product-info">
                                    <h4>경주 전통 한과 만들기 체험</h4>
                                    <p>2024.01.28 (일) 13:00 | 2명</p>
                                    <span class="payment-status completed">이용 완료</span>
                                </div>
                            </div>
                            <div class="payment-amount">
                                <div class="amount">48,000원</div>
                                <div class="date">결제일: 2024.01.20</div>
                            </div>
                            <div class="payment-actions">
                                <button class="btn btn-outline btn-sm" onclick="showReceipt(4)">
                                    <i class="bi bi-receipt"></i> 영수증
                                </button>
                                <span class="text-success"><i class="bi bi-check-circle-fill"></i> 후기 작성 완료</span>
                            </div>
                        </div>

                        <!-- 결제 5 - 취소 -->
                        <div class="payment-item" data-status="cancelled" data-payment-id="5">
                            <div class="payment-product">
                                <img src="https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=120&h=120&fit=crop&q=80" alt="상품">
                                <div class="payment-product-info">
                                    <h4>설악산 짚라인 체험</h4>
                                    <p>2024.01.15 (월) 11:00 | 1명</p>
                                    <span class="payment-status cancelled">취소 완료</span>
                                </div>
                            </div>
                            <div class="payment-amount">
                                <div class="amount"><del>35,000원</del></div>
                                <div class="date">환불일: 2024.01.10</div>
                            </div>
                            <div class="payment-actions">
                                <button class="btn btn-outline btn-sm" onclick="showRefundDetail(5)">
                                    환불 상세
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 페이지네이션 -->
                <div class="pagination-container">
                    <nav>
                        <ul class="pagination">
                            <li class="page-item">
                                <a class="page-link" href="#"><i class="bi bi-chevron-left"></i></a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 영수증 모달 -->
<div class="modal fade" id="receiptModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-receipt me-2"></i>영수증
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="receipt-content">
                    <!-- 결제 상태 뱃지 -->
                    <div class="receipt-status-badge" id="receiptStatusBadge">
                        <span class="payment-status pending">이용 예정</span>
                    </div>

                    <!-- 상품 정보 -->
                    <div class="receipt-product">
                        <img src="" alt="상품" id="receiptProductImage">
                        <div class="receipt-product-info">
                            <h4 id="receiptProductName">제주 스쿠버다이빙 체험</h4>
                            <p id="receiptProductDate">2024.04.20 (토) 14:00</p>
                            <p id="receiptProductOption">2명</p>
                        </div>
                    </div>

                    <!-- 결제 정보 -->
                    <div class="receipt-section">
                        <h5>결제 정보</h5>
                        <div class="receipt-row">
                            <span>결제번호</span>
                            <span id="receiptOrderNo">ORD-20240315-001234</span>
                        </div>
                        <div class="receipt-row">
                            <span>결제일시</span>
                            <span id="receiptPayDate">2024.03.15 14:32:15</span>
                        </div>
                        <div class="receipt-row">
                            <span>결제수단</span>
                            <span id="receiptPayMethod">신용카드</span>
                        </div>
                    </div>

                    <!-- 금액 정보 -->
                    <div class="receipt-section">
                        <h5>결제 금액</h5>
                        <div class="receipt-row">
                            <span>상품 금액</span>
                            <span id="receiptOriginalPrice">150,000원</span>
                        </div>
                        <div class="receipt-row discount">
                            <span>할인</span>
                            <span id="receiptDiscount">-10,000원</span>
                        </div>
                        <div class="receipt-row discount">
                            <span>포인트 사용</span>
                            <span id="receiptPointUsed">-4,000원</span>
                        </div>
                        <div class="receipt-row total">
                            <span>총 결제금액</span>
                            <span id="receiptTotalPrice">136,000원</span>
                        </div>
                    </div>

                    <!-- 적립 정보 -->
                    <div class="receipt-section">
                        <h5>적립 정보</h5>
                        <div class="receipt-row">
                            <span>적립 포인트</span>
                            <span id="receiptEarnedPoints" class="text-primary">+1,360P</span>
                        </div>
                    </div>

                    <!-- 결제자 정보 -->
                    <div class="receipt-section">
                        <h5>결제자 정보</h5>
                        <div class="receipt-row">
                            <span>결제자명</span>
                            <span id="receiptCustomerName">${sessionScope.loginUser.userName}</span>
                        </div>
                        <div class="receipt-row">
                            <span>연락처</span>
                            <span id="receiptCustomerPhone">010-1234-5678</span>
                        </div>
                        <div class="receipt-row">
                            <span>이메일</span>
                            <span id="receiptCustomerEmail">${sessionScope.loginUser.email}</span>
                        </div>
                    </div>

                    <!-- 판매자 정보 -->
                    <div class="receipt-section">
                        <h5>판매자 정보</h5>
                        <div class="receipt-row">
                            <span>상호명</span>
                            <span id="receiptSellerName">제주다이빙센터</span>
                        </div>
                        <div class="receipt-row">
                            <span>사업자번호</span>
                            <span id="receiptSellerBizNo">123-45-67890</span>
                        </div>
                        <div class="receipt-row">
                            <span>연락처</span>
                            <span id="receiptSellerPhone">064-123-4567</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" onclick="printReceipt()">
                    <i class="bi bi-printer me-1"></i>인쇄
                </button>
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">확인</button>
            </div>
        </div>
    </div>
</div>

<!-- 환불 상세 모달 -->
<div class="modal fade" id="refundModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-arrow-counterclockwise me-2"></i>환불 상세
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="refund-content">
                    <!-- 환불 상태 -->
                    <div class="refund-status-box">
                        <i class="bi bi-check-circle-fill"></i>
                        <div>
                            <h4>환불 완료</h4>
                            <p>환불이 정상적으로 처리되었습니다.</p>
                        </div>
                    </div>

                    <!-- 상품 정보 -->
                    <div class="refund-product">
                        <img src="" alt="상품" id="refundProductImage">
                        <div class="refund-product-info">
                            <h4 id="refundProductName">설악산 짚라인 체험</h4>
                            <p id="refundProductDate">2024.01.15 (월) 11:00</p>
                            <p id="refundProductOption">1명</p>
                        </div>
                    </div>

                    <!-- 환불 정보 -->
                    <div class="refund-section">
                        <h5>환불 정보</h5>
                        <div class="refund-row">
                            <span>결제번호</span>
                            <span id="refundOrderNo">ORD-20240108-005678</span>
                        </div>
                        <div class="refund-row">
                            <span>취소 요청일</span>
                            <span id="refundRequestDate">2024.01.09 10:15:00</span>
                        </div>
                        <div class="refund-row">
                            <span>환불 완료일</span>
                            <span id="refundCompleteDate">2024.01.10 14:30:00</span>
                        </div>
                        <div class="refund-row">
                            <span>취소 사유</span>
                            <span id="refundReason">일정 변경</span>
                        </div>
                    </div>

                    <!-- 환불 금액 -->
                    <div class="refund-section">
                        <h5>환불 금액</h5>
                        <div class="refund-row">
                            <span>결제 금액</span>
                            <span id="refundOriginalPrice">35,000원</span>
                        </div>
                        <div class="refund-row warning">
                            <span>취소 수수료 (10%)</span>
                            <span id="refundFee">-3,500원</span>
                        </div>
                        <div class="refund-row total">
                            <span>환불 금액</span>
                            <span id="refundTotalAmount">31,500원</span>
                        </div>
                    </div>

                    <!-- 환불 수단 -->
                    <div class="refund-section">
                        <h5>환불 수단</h5>
                        <div class="refund-row">
                            <span>환불 방법</span>
                            <span id="refundMethod">신용카드 취소</span>
                        </div>
                        <div class="refund-row">
                            <span>포인트 환급</span>
                            <span id="refundPointReturn" class="text-primary">+350P</span>
                        </div>
                    </div>

                    <!-- 안내 -->
                    <div class="refund-notice">
                        <i class="bi bi-info-circle me-2"></i>
                        <span>카드 환불은 카드사 정책에 따라 3~5영업일 소요될 수 있습니다.</span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">확인</button>
            </div>
        </div>
    </div>
</div>

<!-- 후기 작성 모달 -->
<div class="modal fade" id="reviewModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-star me-2"></i>후기 작성
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="reviewForm">
                    <!-- 상품 정보 -->
                    <div class="review-product-info">
                        <img src="" alt="상품" id="reviewProductImage">
                        <div>
                            <h4 id="reviewProductName">부산 해운대 카약 체험</h4>
                            <p id="reviewProductDate">2024.02.21 (수) 10:00 | 3명</p>
                        </div>
                    </div>

                    <!-- 별점 -->
                    <div class="review-section">
                        <label class="review-label">별점 <span class="text-danger">*</span></label>
                        <div class="star-rating" id="starRating">
                            <i class="bi bi-star" data-rating="1"></i>
                            <i class="bi bi-star" data-rating="2"></i>
                            <i class="bi bi-star" data-rating="3"></i>
                            <i class="bi bi-star" data-rating="4"></i>
                            <i class="bi bi-star" data-rating="5"></i>
                        </div>
                        <span class="rating-text" id="ratingText">별점을 선택해주세요</span>
                        <input type="hidden" name="rating" id="reviewRating" value="0">
                    </div>

                    <!-- 후기 내용 -->
                    <div class="review-section">
                        <label class="review-label">후기 내용 <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="reviewContent" name="content" rows="5"
                                  placeholder="상품 이용 경험을 자세히 작성해주세요. (최소 20자 이상)"
                                  minlength="20" maxlength="1000" required></textarea>
                        <div class="char-counter">
                            <span id="reviewCharCount">0</span> / 1000자
                        </div>
                    </div>

                    <!-- 사진 첨부 -->
                    <div class="review-section">
                        <label class="review-label">사진 첨부 <span class="text-muted">(선택, 최대 5장)</span></label>
                        <div class="review-image-upload">
                            <input type="file" id="reviewImages" name="images" accept="image/*" multiple style="display: none;">
                            <div class="image-upload-area" onclick="document.getElementById('reviewImages').click()">
                                <i class="bi bi-camera"></i>
                                <span>사진 추가</span>
                            </div>
                            <div class="image-preview-list" id="imagePreviewList"></div>
                        </div>
                    </div>

                    <!-- 추천 여부 -->
                    <div class="review-section">
                        <label class="review-label">이 상품을 추천하시나요?</label>
                        <div class="recommend-options">
                            <label class="recommend-option">
                                <input type="radio" name="recommend" value="yes" checked>
                                <span class="recommend-btn yes">
                                    <i class="bi bi-hand-thumbs-up-fill"></i> 추천해요
                                </span>
                            </label>
                            <label class="recommend-option">
                                <input type="radio" name="recommend" value="no">
                                <span class="recommend-btn no">
                                    <i class="bi bi-hand-thumbs-down-fill"></i> 별로예요
                                </span>
                            </label>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="submitReview()">
                    <i class="bi bi-check-lg me-1"></i>후기 등록
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 취소 확인 모달 -->
<div class="modal fade" id="cancelConfirmModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-warning">
                    <i class="bi bi-exclamation-triangle me-2"></i>결제 취소
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="cancel-confirm-content">
                    <p class="cancel-warning">정말 결제를 취소하시겠습니까?</p>

                    <div class="cancel-product-info">
                        <h5 id="cancelProductName">제주 스쿠버다이빙 체험</h5>
                        <p id="cancelProductDate">2024.04.20 (토) 14:00 | 2명</p>
                    </div>

                    <div class="cancel-policy">
                        <h5><i class="bi bi-info-circle me-1"></i>취소 수수료 안내</h5>
                        <ul>
                            <li>이용일 7일 전: 무료 취소</li>
                            <li>이용일 3~6일 전: 30% 수수료</li>
                            <li>이용일 1~2일 전: 50% 수수료</li>
                            <li>이용일 당일: 환불 불가</li>
                        </ul>
                    </div>

                    <div class="cancel-fee-info">
                        <div class="fee-row">
                            <span>결제 금액</span>
                            <span id="cancelOriginalPrice">136,000원</span>
                        </div>
                        <div class="fee-row warning">
                            <span>예상 취소 수수료</span>
                            <span id="cancelFee">0원 (무료 취소)</span>
                        </div>
                        <div class="fee-row total">
                            <span>예상 환불 금액</span>
                            <span id="cancelRefundAmount">136,000원</span>
                        </div>
                    </div>

                    <div class="cancel-reason">
                        <label class="form-label">취소 사유 <span class="text-danger">*</span></label>
                        <select class="form-select" id="cancelReason" required>
                            <option value="">취소 사유를 선택해주세요</option>
                            <option value="schedule">일정 변경</option>
                            <option value="mistake">실수로 예약</option>
                            <option value="price">가격이 비싸서</option>
                            <option value="change">다른 상품으로 변경</option>
                            <option value="other">기타</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">돌아가기</button>
                <button type="button" class="btn btn-danger" onclick="confirmCancel()">
                    <i class="bi bi-x-circle me-1"></i>결제 취소하기
                </button>
            </div>
        </div>
    </div>
</div>

<style>
/* 영수증 모달 스타일 */
.receipt-content {
    padding: 0;
}

.receipt-status-badge {
    text-align: center;
    padding: 15px;
    background: #f8fafc;
    border-radius: 8px;
    margin-bottom: 20px;
}

.receipt-product {
    display: flex;
    gap: 15px;
    padding: 15px;
    background: #f8fafc;
    border-radius: 8px;
    margin-bottom: 20px;
}

.receipt-product img {
    width: 80px;
    height: 80px;
    border-radius: 8px;
    object-fit: cover;
}

.receipt-product-info h4 {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 5px;
}

.receipt-product-info p {
    font-size: 14px;
    color: #64748b;
    margin: 2px 0;
}

.receipt-section {
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 1px solid #e2e8f0;
}

.receipt-section:last-child {
    border-bottom: none;
    margin-bottom: 0;
}

.receipt-section h5 {
    font-size: 14px;
    font-weight: 600;
    color: #334155;
    margin-bottom: 12px;
}

.receipt-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 0;
    font-size: 14px;
}

.receipt-row span:first-child {
    color: #64748b;
}

.receipt-row span:last-child {
    font-weight: 500;
    color: #1e293b;
}

.receipt-row.discount span:last-child {
    color: #ef4444;
}

.receipt-row.total {
    border-top: 1px solid #e2e8f0;
    margin-top: 10px;
    padding-top: 15px;
    font-size: 16px;
}

.receipt-row.total span:last-child {
    font-weight: 700;
    color: var(--primary);
}

/* 환불 상세 모달 스타일 */
.refund-status-box {
    display: flex;
    align-items: center;
    gap: 15px;
    padding: 20px;
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    border-radius: 12px;
    color: white;
    margin-bottom: 20px;
}

.refund-status-box i {
    font-size: 40px;
}

.refund-status-box h4 {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 5px;
}

.refund-status-box p {
    font-size: 14px;
    opacity: 0.9;
    margin: 0;
}

.refund-product {
    display: flex;
    gap: 15px;
    padding: 15px;
    background: #f8fafc;
    border-radius: 8px;
    margin-bottom: 20px;
}

.refund-product img {
    width: 80px;
    height: 80px;
    border-radius: 8px;
    object-fit: cover;
}

.refund-product-info h4 {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 5px;
}

.refund-product-info p {
    font-size: 14px;
    color: #64748b;
    margin: 2px 0;
}

.refund-section {
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 1px solid #e2e8f0;
}

.refund-section h5 {
    font-size: 14px;
    font-weight: 600;
    color: #334155;
    margin-bottom: 12px;
}

.refund-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 0;
    font-size: 14px;
}

.refund-row span:first-child {
    color: #64748b;
}

.refund-row span:last-child {
    font-weight: 500;
    color: #1e293b;
}

.refund-row.warning span:last-child {
    color: #f59e0b;
}

.refund-row.total {
    border-top: 1px solid #e2e8f0;
    margin-top: 10px;
    padding-top: 15px;
    font-size: 16px;
}

.refund-row.total span:last-child {
    font-weight: 700;
    color: var(--primary);
}

.refund-notice {
    display: flex;
    align-items: flex-start;
    gap: 8px;
    padding: 12px;
    background: #fef3c7;
    border-radius: 8px;
    font-size: 13px;
    color: #92400e;
}

/* 후기 작성 모달 스타일 */
.review-product-info {
    display: flex;
    gap: 15px;
    padding: 15px;
    background: #f8fafc;
    border-radius: 8px;
    margin-bottom: 25px;
}

.review-product-info img {
    width: 80px;
    height: 80px;
    border-radius: 8px;
    object-fit: cover;
}

.review-product-info h4 {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 5px;
}

.review-product-info p {
    font-size: 14px;
    color: #64748b;
    margin: 0;
}

.review-section {
    margin-bottom: 25px;
}

.review-label {
    display: block;
    font-size: 14px;
    font-weight: 600;
    color: #334155;
    margin-bottom: 10px;
}

.star-rating {
    display: flex;
    gap: 8px;
    margin-bottom: 8px;
}

.star-rating i {
    font-size: 32px;
    color: #e2e8f0;
    cursor: pointer;
    transition: all 0.2s;
}

.star-rating i:hover,
.star-rating i.active {
    color: #fbbf24;
}

.star-rating i.bi-star-fill {
    color: #fbbf24;
}

.rating-text {
    font-size: 14px;
    color: #64748b;
}

.char-counter {
    text-align: right;
    font-size: 12px;
    color: #94a3b8;
    margin-top: 5px;
}

.review-image-upload {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.image-upload-area {
    width: 80px;
    height: 80px;
    border: 2px dashed #e2e8f0;
    border-radius: 8px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s;
}

.image-upload-area:hover {
    border-color: var(--primary);
    background: #f0f7ff;
}

.image-upload-area i {
    font-size: 24px;
    color: #94a3b8;
}

.image-upload-area span {
    font-size: 11px;
    color: #94a3b8;
    margin-top: 5px;
}

.image-preview-list {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.image-preview-item {
    position: relative;
    width: 80px;
    height: 80px;
}

.image-preview-item img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: 8px;
}

.image-preview-item .remove-btn {
    position: absolute;
    top: -8px;
    right: -8px;
    width: 22px;
    height: 22px;
    border-radius: 50%;
    background: #ef4444;
    color: white;
    border: none;
    font-size: 12px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
}

.recommend-options {
    display: flex;
    gap: 15px;
}

.recommend-option {
    cursor: pointer;
}

.recommend-option input {
    display: none;
}

.recommend-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 12px 24px;
    border: 2px solid #e2e8f0;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.2s;
}

.recommend-btn.yes {
    color: #64748b;
}

.recommend-btn.no {
    color: #64748b;
}

.recommend-option input:checked + .recommend-btn.yes {
    border-color: var(--primary);
    background: #f0f7ff;
    color: var(--primary);
}

.recommend-option input:checked + .recommend-btn.no {
    border-color: #ef4444;
    background: #fef2f2;
    color: #ef4444;
}

/* 취소 확인 모달 스타일 */
.cancel-confirm-content {
    text-align: center;
}

.cancel-warning {
    font-size: 18px;
    font-weight: 600;
    color: #1e293b;
    margin-bottom: 20px;
}

.cancel-product-info {
    padding: 15px;
    background: #f8fafc;
    border-radius: 8px;
    margin-bottom: 20px;
}

.cancel-product-info h5 {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 5px;
}

.cancel-product-info p {
    font-size: 14px;
    color: #64748b;
    margin: 0;
}

.cancel-policy {
    text-align: left;
    padding: 15px;
    background: #fef3c7;
    border-radius: 8px;
    margin-bottom: 20px;
}

.cancel-policy h5 {
    font-size: 14px;
    font-weight: 600;
    color: #92400e;
    margin-bottom: 10px;
}

.cancel-policy ul {
    margin: 0;
    padding-left: 20px;
    font-size: 13px;
    color: #92400e;
}

.cancel-policy li {
    margin-bottom: 5px;
}

.cancel-fee-info {
    text-align: left;
    padding: 15px;
    background: #f8fafc;
    border-radius: 8px;
    margin-bottom: 20px;
}

.fee-row {
    display: flex;
    justify-content: space-between;
    padding: 8px 0;
    font-size: 14px;
}

.fee-row span:first-child {
    color: #64748b;
}

.fee-row.warning span:last-child {
    color: #f59e0b;
    font-weight: 500;
}

.fee-row.total {
    border-top: 1px solid #e2e8f0;
    margin-top: 10px;
    padding-top: 12px;
    font-weight: 600;
}

.fee-row.total span:last-child {
    color: var(--primary);
}

.cancel-reason {
    text-align: left;
}

.cancel-reason .form-label {
    font-size: 14px;
    font-weight: 600;
    color: #334155;
}

/* 영수증 인쇄 스타일 */
@media print {
    /* 모든 요소 숨김 */
    body * {
        visibility: hidden;
    }

    /* 영수증 모달과 그 내용만 표시 */
    #receiptModal,
    #receiptModal * {
        visibility: visible;
    }

    /* 영수증 모달 위치 및 스타일 조정 */
    #receiptModal {
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
        height: auto;
        margin: 0;
        padding: 0;
        background: white !important;
    }

    #receiptModal .modal-dialog {
        max-width: 100%;
        margin: 0;
        padding: 20px;
    }

    #receiptModal .modal-content {
        border: none;
        box-shadow: none;
    }

    /* 모달 배경 숨김 */
    .modal-backdrop {
        display: none !important;
    }

    /* 버튼들 숨김 */
    #receiptModal .modal-header .btn-close,
    #receiptModal .modal-footer {
        display: none !important;
    }

    /* 영수증 제목 스타일 */
    #receiptModal .modal-header {
        border-bottom: 2px solid #333;
        padding-bottom: 15px;
    }

    #receiptModal .modal-title {
        font-size: 24px;
        font-weight: bold;
    }

    /* 영수증 내용 스타일 */
    #receiptModal .receipt-content {
        padding: 0;
    }

    #receiptModal .receipt-section {
        page-break-inside: avoid;
    }

    /* 색상 인쇄 보장 */
    #receiptModal .receipt-row.total span:last-child {
        color: #000 !important;
        -webkit-print-color-adjust: exact;
        print-color-adjust: exact;
    }
}
</style>

<script>
// 결제 데이터 (실제로는 서버에서 가져옴)
const paymentData = {
    1: {
        status: 'pending',
        productName: '제주 스쿠버다이빙 체험',
        productImage: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=120&h=120&fit=crop&q=80',
        useDate: '2024.04.20 (토) 14:00',
        option: '2명',
        orderNo: 'ORD-20240315-001234',
        payDate: '2024.03.15 14:32:15',
        payMethod: '신용카드',
        originalPrice: '150,000원',
        discount: '-10,000원',
        pointUsed: '-4,000원',
        totalPrice: '136,000원',
        earnedPoints: '+1,360P',
        sellerName: '제주다이빙센터',
        sellerBizNo: '123-45-67890',
        sellerPhone: '064-123-4567'
    },
    2: {
        status: 'pending',
        productName: '제주 신라 호텔',
        productImage: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=120&h=120&fit=crop&q=80',
        useDate: '2024.04.20 - 2024.04.22 (2박)',
        option: '디럭스룸',
        orderNo: 'ORD-20240314-001122',
        payDate: '2024.03.14 10:20:30',
        payMethod: '신용카드',
        originalPrice: '340,000원',
        discount: '-20,000원',
        pointUsed: '0원',
        totalPrice: '320,000원',
        earnedPoints: '+3,200P',
        sellerName: '제주 신라 호텔',
        sellerBizNo: '234-56-78901',
        sellerPhone: '064-234-5678'
    },
    3: {
        status: 'completed',
        productName: '부산 해운대 카약 체험',
        productImage: 'https://images.unsplash.com/photo-1472745942893-4b9f730c7668?w=120&h=120&fit=crop&q=80',
        useDate: '2024.02.21 (수) 10:00',
        option: '3명',
        orderNo: 'ORD-20240215-003344',
        payDate: '2024.02.15 16:45:00',
        payMethod: '카카오페이',
        originalPrice: '50,000원',
        discount: '-5,000원',
        pointUsed: '0원',
        totalPrice: '45,000원',
        earnedPoints: '+450P',
        sellerName: '해운대카약센터',
        sellerBizNo: '345-67-89012',
        sellerPhone: '051-345-6789'
    },
    4: {
        status: 'completed',
        productName: '경주 전통 한과 만들기 체험',
        productImage: 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=120&h=120&fit=crop&q=80',
        useDate: '2024.01.28 (일) 13:00',
        option: '2명',
        orderNo: 'ORD-20240120-005566',
        payDate: '2024.01.20 09:30:00',
        payMethod: '신용카드',
        originalPrice: '50,000원',
        discount: '0원',
        pointUsed: '-2,000원',
        totalPrice: '48,000원',
        earnedPoints: '+480P',
        sellerName: '경주한과체험관',
        sellerBizNo: '456-78-90123',
        sellerPhone: '054-456-7890'
    },
    5: {
        status: 'cancelled',
        productName: '설악산 짚라인 체험',
        productImage: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=120&h=120&fit=crop&q=80',
        useDate: '2024.01.15 (월) 11:00',
        option: '1명',
        orderNo: 'ORD-20240108-005678',
        payDate: '2024.01.08 11:20:00',
        payMethod: '신용카드',
        originalPrice: '35,000원',
        requestDate: '2024.01.09 10:15:00',
        completeDate: '2024.01.10 14:30:00',
        reason: '일정 변경',
        fee: '-3,500원',
        refundAmount: '31,500원',
        pointReturn: '+350P'
    }
};

let currentPaymentId = null;

// Bootstrap 모달 인스턴스
let receiptModal, refundModal, reviewModal, cancelConfirmModal;

document.addEventListener('DOMContentLoaded', function() {
    receiptModal = new bootstrap.Modal(document.getElementById('receiptModal'));
    refundModal = new bootstrap.Modal(document.getElementById('refundModal'));
    reviewModal = new bootstrap.Modal(document.getElementById('reviewModal'));
    cancelConfirmModal = new bootstrap.Modal(document.getElementById('cancelConfirmModal'));
});

// 탭 필터링
document.querySelectorAll('.mypage-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        document.querySelectorAll('.mypage-tab').forEach(t => t.classList.remove('active'));
        this.classList.add('active');

        const filter = this.dataset.filter;
        const payments = document.querySelectorAll('.payment-item');

        payments.forEach(payment => {
            if (filter === 'all') {
                payment.style.display = 'flex';
            } else {
                const status = payment.dataset.status;
                payment.style.display = status === filter ? 'flex' : 'none';
            }
        });
    });
});

// 영수증 모달 열기
function showReceipt(paymentId) {
    currentPaymentId = paymentId;
    const data = paymentData[paymentId];

    // 상태 뱃지
    const statusBadge = document.getElementById('receiptStatusBadge');
    if (data.status === 'pending') {
        statusBadge.innerHTML = '<span class="payment-status pending">이용 예정</span>';
    } else if (data.status === 'completed') {
        statusBadge.innerHTML = '<span class="payment-status completed">이용 완료</span>';
    }

    // 상품 정보
    document.getElementById('receiptProductImage').src = data.productImage;
    document.getElementById('receiptProductName').textContent = data.productName;
    document.getElementById('receiptProductDate').textContent = data.useDate;
    document.getElementById('receiptProductOption').textContent = data.option;

    // 결제 정보
    document.getElementById('receiptOrderNo').textContent = data.orderNo;
    document.getElementById('receiptPayDate').textContent = data.payDate;
    document.getElementById('receiptPayMethod').textContent = data.payMethod;

    // 금액 정보
    document.getElementById('receiptOriginalPrice').textContent = data.originalPrice;
    document.getElementById('receiptDiscount').textContent = data.discount;
    document.getElementById('receiptPointUsed').textContent = data.pointUsed;
    document.getElementById('receiptTotalPrice').textContent = data.totalPrice;
    document.getElementById('receiptEarnedPoints').textContent = data.earnedPoints;

    // 판매자 정보
    document.getElementById('receiptSellerName').textContent = data.sellerName;
    document.getElementById('receiptSellerBizNo').textContent = data.sellerBizNo;
    document.getElementById('receiptSellerPhone').textContent = data.sellerPhone;

    receiptModal.show();
}

function printReceipt() {
    window.print();
}

// 결제 취소 확인 모달 열기
function showCancelConfirm(paymentId) {
    currentPaymentId = paymentId;
    const data = paymentData[paymentId];

    document.getElementById('cancelProductName').textContent = data.productName;
    document.getElementById('cancelProductDate').textContent = data.useDate + ' | ' + data.option;
    document.getElementById('cancelOriginalPrice').textContent = data.totalPrice;

    // 취소 수수료 계산 (예시: 무료 취소 가능)
    document.getElementById('cancelFee').textContent = '0원 (무료 취소)';
    document.getElementById('cancelRefundAmount').textContent = data.totalPrice;

    cancelConfirmModal.show();
}

function confirmCancel() {
    const reason = document.getElementById('cancelReason').value;
    if (!reason) {
        showToast('취소 사유를 선택해주세요.', 'error');
        return;
    }

    // 실제로는 서버에 취소 요청
    cancelConfirmModal.hide();
    showToast('결제가 취소되었습니다. 환불은 3~5영업일 내 처리됩니다.', 'success');

    // 상태 변경 (실제로는 페이지 새로고침 또는 AJAX로 업데이트)
    setTimeout(() => {
        location.reload();
    }, 1500);
}

// 환불 상세 모달
function showRefundDetail(paymentId) {
    const data = paymentData[paymentId];

    document.getElementById('refundProductImage').src = data.productImage;
    document.getElementById('refundProductName').textContent = data.productName;
    document.getElementById('refundProductDate').textContent = data.useDate;
    document.getElementById('refundProductOption').textContent = data.option;

    document.getElementById('refundOrderNo').textContent = data.orderNo;
    document.getElementById('refundRequestDate').textContent = data.requestDate;
    document.getElementById('refundCompleteDate').textContent = data.completeDate;
    document.getElementById('refundReason').textContent = data.reason;

    document.getElementById('refundOriginalPrice').textContent = data.originalPrice;
    document.getElementById('refundFee').textContent = data.fee;
    document.getElementById('refundTotalAmount').textContent = data.refundAmount;

    document.getElementById('refundMethod').textContent = '신용카드 취소';
    document.getElementById('refundPointReturn').textContent = data.pointReturn;

    refundModal.show();
}

// 후기 작성 모달
let selectedRating = 0;
let uploadedImages = [];

function openReviewModal(paymentId) {
    currentPaymentId = paymentId;
    const data = paymentData[paymentId];

    document.getElementById('reviewProductImage').src = data.productImage;
    document.getElementById('reviewProductName').textContent = data.productName;
    document.getElementById('reviewProductDate').textContent = data.useDate + ' | ' + data.option;

    // 초기화
    selectedRating = 0;
    uploadedImages = [];
    document.getElementById('reviewRating').value = 0;
    document.getElementById('reviewContent').value = '';
    document.getElementById('reviewCharCount').textContent = '0';
    document.getElementById('imagePreviewList').innerHTML = '';
    updateStars(0);
    document.getElementById('ratingText').textContent = '별점을 선택해주세요';

    reviewModal.show();
}

// 별점 선택
document.getElementById('starRating').addEventListener('click', function(e) {
    if (e.target.tagName === 'I') {
        selectedRating = parseInt(e.target.dataset.rating);
        document.getElementById('reviewRating').value = selectedRating;
        updateStars(selectedRating);
        updateRatingText(selectedRating);
    }
});

document.getElementById('starRating').addEventListener('mouseover', function(e) {
    if (e.target.tagName === 'I') {
        const rating = parseInt(e.target.dataset.rating);
        updateStars(rating);
    }
});

document.getElementById('starRating').addEventListener('mouseout', function() {
    updateStars(selectedRating);
});

function updateStars(rating) {
    const stars = document.querySelectorAll('#starRating i');
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.remove('bi-star');
            star.classList.add('bi-star-fill');
        } else {
            star.classList.remove('bi-star-fill');
            star.classList.add('bi-star');
        }
    });
}

function updateRatingText(rating) {
    const texts = ['별점을 선택해주세요', '별로예요', '그저 그래요', '보통이에요', '좋아요', '최고예요!'];
    document.getElementById('ratingText').textContent = texts[rating];
}

// 글자수 카운터
document.getElementById('reviewContent').addEventListener('input', function() {
    document.getElementById('reviewCharCount').textContent = this.value.length;
});

// 이미지 업로드
document.getElementById('reviewImages').addEventListener('change', function(e) {
    const files = Array.from(e.target.files);

    if (uploadedImages.length + files.length > 5) {
        showToast('이미지는 최대 5장까지 첨부 가능합니다.', 'error');
        return;
    }

    files.forEach(file => {
        if (file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = function(e) {
                uploadedImages.push(e.target.result);
                renderImagePreviews();
            };
            reader.readAsDataURL(file);
        }
    });

    e.target.value = '';
});

function renderImagePreviews() {
    const container = document.getElementById('imagePreviewList');
    container.innerHTML = uploadedImages.map((src, index) => `
        <div class="image-preview-item">
            <img src="${src}" alt="이미지">
            <button class="remove-btn" onclick="removeImage(${index})">&times;</button>
        </div>
    `).join('');
}

function removeImage(index) {
    uploadedImages.splice(index, 1);
    renderImagePreviews();
}

// 후기 제출
function submitReview() {
    const rating = document.getElementById('reviewRating').value;
    const content = document.getElementById('reviewContent').value.trim();

    if (rating == 0) {
        showToast('별점을 선택해주세요.', 'error');
        return;
    }

    if (content.length < 20) {
        showToast('후기 내용을 20자 이상 입력해주세요.', 'error');
        document.getElementById('reviewContent').focus();
        return;
    }

    // 실제로는 서버에 후기 등록 요청
    reviewModal.hide();
    showToast('후기가 등록되었습니다. 감사합니다!', 'success');

    // 버튼 상태 변경 (실제로는 페이지 새로고침 또는 AJAX로 업데이트)
    setTimeout(() => {
        location.reload();
    }, 1500);
}
</script>

<c:set var="pageJs" value="mypage" />
<%@ include file="../common/footer.jsp" %>
