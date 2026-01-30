<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

<c:set var="pageTitle" value="결제 내역" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../common/header.jsp"%>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="todayStr" value="${now}" pattern="yyyy-MM-dd" />

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
						<div class="stat-icon">
							<i class="bi bi-credit-card"></i>
						</div>
						<div class="stat-value">${stats.TOTAL_COUNT}</div>
						<div class="stat-label">전체 결제</div>
					</div>
					<div class="stat-card secondary">
						<div class="stat-icon">
							<i class="bi bi-check-circle"></i>
						</div>
						<div class="stat-value">${stats.COMPLETED_COUNT}</div>
						<div class="stat-label">이용 완료</div>
					</div>
					<div class="stat-card accent">
						<div class="stat-icon">
							<i class="bi bi-hourglass-split"></i>
						</div>
						<div class="stat-value">${stats.PENDING_COUNT}</div>
						<div class="stat-label">예정된 이용</div>
					</div>
					<div class="stat-card">
						<div class="stat-icon">
							₩
						</div>
						<div class="stat-value">
							<fmt:formatNumber value="${stats.TOTAL_REVENUE}" pattern="#,###" />
							원
						</div>
						<div class="stat-label">총 결제금액</div>
					</div>
				</div>

				<div class="bookmark-search">
					<form class="bookmark-search-input" id="searchForm" method="get">
						<input type="hidden" name="page" id="page" /> <input
							type="hidden" name="contentType" value="${contentType}" />
					</form>
				</div>

				<!-- 탭 -->
				<div class="mypage-tabs">
					<button
						class="mypage-tab <c:if test="${not empty contentType and contentType eq 'all' }">active</c:if>"
						data-category="all">전체</button>
					<button
						class="mypage-tab <c:if test="${not empty contentType and contentType eq 'completed' }">active</c:if>"
						data-category="completed">이용 완료</button>
					<button
						class="mypage-tab <c:if test="${not empty contentType and contentType eq 'pending' }">active</c:if>"
						data-category="pending">이용 예정</button>
<!-- 					<button -->
<%-- 						class="mypage-tab <c:if test="${not empty contentType and contentType eq 'cancelled' }">active</c:if>" --%>
<!-- 						data-category="cancelled">취소 완료</button> -->
				</div>

				<!-- 결제 내역 -->
				<div class="content-section">
					<div class="section-header">
						<h3>
							<i class="bi bi-list-ul"></i> 결제 내역
						</h3>
						<!--                         <div class="d-flex gap-2">
                            <select class="form-select form-select-sm" style="width: 120px;">
                                <option>최근 3개월</option>
                                <option>최근 6개월</option>
                                <option>최근 1년</option>
                                <option>전체</option>
                            </select>
                        </div> -->
					</div>

					<div class="payment-list">
						<c:choose>
							<%-- 1. 데이터가 존재하는 경우 --%>
							<c:when test="${not empty pagingVO.dataList}">
								<c:forEach var="pay" items="${pagingVO.dataList}">
									<div class="payment-item" data-status="${pay.payStatus}"
										data-payment-id="${pay.payNo}">
										<div class="payment-product" style="display: flex; align-items: center; gap: 15px;">
										    <c:choose>
										        <%-- 1. 항공권일 때 --%>
										        <c:when test="${fn:contains(pay.prodName, '항공')}">
										            <c:set var="imgSrc" value="${pageContext.request.contextPath}/resources/images/default_flight.jpg" />
										        </c:when>
										        <%-- 2. 이미지가 있을 때 (여행기록 방식: /files + coverPath) --%>
										        <c:when test="${not empty pay.thumbImg and pay.thumbImg ne '/resources/images/default_flight.jpg'}">
										            <c:set var="imgSrc" value="${pageContext.request.contextPath}/files${pay.thumbImg}" />
										        </c:when>
										        <%-- 3. 그 외 기본 이미지 --%>
										        <c:otherwise>
										            <c:set var="imgSrc" value="${pageContext.request.contextPath}/resources/images/no_image.jpg" />
										        </c:otherwise>
										    </c:choose>
										
										    <img src="${imgSrc}" alt="상품 이미지" 
										         style="width: 80px; height: 80px; border-radius: 8px; object-fit: cover; flex-shrink: 0;"
										         onerror="this.src='${pageContext.request.contextPath}/resources/images/no_image.jpg'">
										    
										    <div class="payment-product-info">
										        <h4>${pay.prodName}</h4>
										        <p>${pay.useDate} | ${pay.optionInfo}</p>
										        <span class="payment-status ${pay.payStatus}">
										            <c:choose>
										                <c:when test="${pay.payStatus eq 'DONE'}">이용 완료</c:when>
										                <c:when test="${pay.payStatus eq 'WAIT'}">이용 예정</c:when>
										                <c:when test="${pay.payStatus eq 'CANCEL'}">취소 완료</c:when>
										            </c:choose>
										        </span>
										    </div>
										</div>

										<div class="payment-amount">
											<div class="amount">
												<fmt:formatNumber value="${pay.payTotalAmt}" pattern="#,###" />
												원
											</div>
											<div class="date">
												<%-- 날짜 포맷: 2026.1.24 10:56:09 형식 --%>
												결제일:
												<%-- 'T' 뒤의 시간을 포함하여 16자(yyyy-MM-ddTHH:mm)까지만 잘라서 파싱하면 초가 있든 없든 안전합니다 --%>
												<c:set var="payDtShort"
													value="${fn:substring(pay.payDt.toString(), 0, 16)}" />
												<fmt:parseDate value="${payDtShort}"
													pattern="yyyy-MM-dd'T'HH:mm" var="parsedPayDt" type="both" />
												<fmt:formatDate value="${parsedPayDt}"
													pattern="yyyy.M.d HH:mm:ss" />
											</div>
										</div>

										<div class="payment-actions">
											<button class="btn btn-outline btn-sm"
												onclick="showReceipt(${pay.payNo})">
												<i class="bi bi-receipt"></i> 영수증
											</button>
										</div>
									</div>
								</c:forEach>
							</c:when>

							<%-- 2. 데이터가 존재하지 않는 경우 --%>
							<c:otherwise>
								<div class="no-data-message"
									style="text-align: center; padding: 50px 0; color: #64748b; width: 100%;">
									<i class="bi bi-exclamation-circle"
										style="font-size: 2rem; display: block; margin-bottom: 10px;"></i>
									<p>결제 내역이 존재하지 않습니다.</p>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<!-- 페이지네이션 -->
				<div class="pagination-container" id="pagingArea">
					<nav>${pagingVO.pagingHTML }</nav>
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
					<div class="receipt-product-area"></div>

					<div class="receipt-section">
						<h5>결제 정보</h5>
						<div class="receipt-row">
							<span>결제번호</span><span id="receiptOrderNo"></span>
						</div>
						<div class="receipt-row">
							<span>결제일시</span><span id="receiptPayDate"></span>
						</div>
						<div class="receipt-row">
							<span>결제수단</span><span id="receiptPayMethod"></span>
						</div>
					</div>

					<div class="receipt-section">
						<h5>결제 금액</h5>
						<div class="receipt-row">
							<span>상품 금액</span><span id="receiptOriginalPrice">0원</span>
						</div>
						<div class="receipt-row discount">
							<span>할인</span><span id="receiptDiscount">-0원</span>
						</div>
						<div class="receipt-row discount">
							<span>포인트 사용</span><span id="receiptPointUsed">-0원</span>
						</div>
						<div class="receipt-row total">
							<span>총 결제금액</span><span id="receiptTotalPrice">0원</span>
						</div>
					</div>

					<div class="receipt-section">
						<h5>적립 정보</h5>
						<div class="receipt-row">
							<span>적립 포인트</span><span id="receiptEarnedPoints"
								class="text-primary">0P</span>
						</div>
					</div>

					<div class="receipt-section">
						<h5>결제자 정보</h5>
						<div class="receipt-row">
							<span>결제자명</span><span id="receiptMemName"></span>
						</div>
						<div class="receipt-row">
							<span>연락처</span><span id="receiptTel"></span>
						</div>
						<div class="receipt-row">
							<span>이메일</span><span id="receiptMemEmail"></span>
						</div>
					</div>

					<div class="receipt-section">
						<h5>판매자 정보</h5>
						<div class="receipt-row">
							<span>상호명</span><span id="receiptCompName"></span>
						</div>
						<div class="receipt-row">
							<span>사업자번호</span><span id="receiptBrno"></span>
						</div>
						<div class="receipt-row">
							<span>연락처</span><span id="receiptCompTel"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-outline-secondary"
					onclick="printReceipt()">
					<i class="bi bi-printer me-1"></i>인쇄
				</button>
				<button type="button" class="btn btn-primary"
					data-bs-dismiss="modal">확인</button>
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
							<span>결제번호</span> <span id="refundOrderNo">ORD-20240108-005678</span>
						</div>
						<div class="refund-row">
							<span>취소 요청일</span> <span id="refundRequestDate">2024.01.09
								10:15:00</span>
						</div>
						<div class="refund-row">
							<span>환불 완료일</span> <span id="refundCompleteDate">2024.01.10
								14:30:00</span>
						</div>
						<div class="refund-row">
							<span>취소 사유</span> <span id="refundReason">일정 변경</span>
						</div>
					</div>

					<!-- 환불 금액 -->
					<div class="refund-section">
						<h5>환불 금액</h5>
						<div class="refund-row">
							<span>결제 금액</span> <span id="refundOriginalPrice">35,000원</span>
						</div>
						<div class="refund-row warning">
							<span>취소 수수료 (10%)</span> <span id="refundFee">-3,500원</span>
						</div>
						<div class="refund-row total">
							<span>환불 금액</span> <span id="refundTotalAmount">31,500원</span>
						</div>
					</div>

					<!-- 환불 수단 -->
					<div class="refund-section">
						<h5>환불 수단</h5>
						<div class="refund-row">
							<span>환불 방법</span> <span id="refundMethod">신용카드 취소</span>
						</div>
						<div class="refund-row">
							<span>포인트 환급</span> <span id="refundPointReturn"
								class="text-primary">+350P</span>
						</div>
					</div>

					<!-- 안내 -->
					<div class="refund-notice">
						<i class="bi bi-info-circle me-2"></i> <span>카드 환불은 카드사 정책에
							따라 3~5영업일 소요될 수 있습니다.</span>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary"
					data-bs-dismiss="modal">확인</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="reviewModal" tabindex="-1">
	<div class="modal-dialog modal-dialog-centered modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="reviewModalLabel">
					<i class="bi bi-star me-2"></i>후기 작성
				</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>
			<div class="modal-body">
				<form id="reviewForm" enctype="multipart/form-data">
					<input type="hidden" id="reviewTripProdNo" name="tripProdNo">
					<input type="hidden" id="reviewProdRvNo" name="prodRvNo">

					<div class="review-product-info">
						<img src="" alt="상품" id="reviewProductImage">
						<div>
							<h4 id="reviewProductName"></h4>
							<p id="reviewProductDate"></p>
						</div>
					</div>

					<div class="review-section">
						<label class="review-label">별점 <span class="text-danger">*</span></label>
						<div class="star-rating" id="starRating">
							<i class="bi bi-star" data-rating="1"></i> <i class="bi bi-star"
								data-rating="2"></i> <i class="bi bi-star" data-rating="3"></i>
							<i class="bi bi-star" data-rating="4"></i> <i class="bi bi-star"
								data-rating="5"></i>
						</div>
						<span class="rating-text" id="ratingText">별점을 선택해주세요</span> <input
							type="hidden" name="rating" id="reviewRating" value="0">
					</div>

					<div class="review-section">
						<label class="review-label">후기 내용 <span
							class="text-danger">*</span></label>
						<textarea class="form-control" id="reviewContent"
							name="prodReview" rows="5"
							placeholder="상품 이용 경험을 자세히 작성해주세요. (최소 20자 이상)"></textarea>
						<div class="char-counter">
							<span id="reviewCharCount">0</span> / 1000자
						</div>
					</div>

					<div class="review-section">
						<label class="review-label">사진 첨부 <span class="text-muted">(최대
								5장)</span></label>
						<div class="review-image-upload">
							<input type="file" id="reviewImages" name="uploadFiles"
								accept="image/*" multiple style="display: none;">
							<div class="image-upload-area"
								onclick="document.getElementById('reviewImages').click()">
								<i class="bi bi-camera"></i> <span>사진 추가</span>
							</div>
							<div id="imagePreviewList" class="image-preview-list"></div>
						</div>
					</div>

					<div class="review-section">
						<label class="review-label">이 상품을 추천하시나요?</label>
						<div class="recommend-options">
							<label class="recommend-option"> <input type="radio"
								name="recommend" value="yes" checked> <span
								class="recommend-btn yes"><i
									class="bi bi-hand-thumbs-up-fill"></i> 추천해요</span>
							</label> <label class="recommend-option"> <input type="radio"
								name="recommend" value="no"> <span
								class="recommend-btn no"><i
									class="bi bi-hand-thumbs-down-fill"></i> 별로예요</span>
							</label>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-outline-secondary"
					data-bs-dismiss="modal">취소</button>
				<button type="button" class="btn btn-primary" id="btnSubmitReview"
					onclick="submitReview()">
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
						<h5>
							<i class="bi bi-info-circle me-1"></i>취소 수수료 안내
						</h5>
						<ul>
							<li>이용일 7일 전: 무료 취소</li>
							<li>이용일 3~6일 전: 30% 수수료</li>
							<li>이용일 1~2일 전: 50% 수수료</li>
							<li>이용일 당일: 환불 불가</li>
						</ul>
					</div>

					<div class="cancel-fee-info">
						<div class="fee-row">
							<span>결제 금액</span> <span id="cancelOriginalPrice">136,000원</span>
						</div>
						<div class="fee-row warning">
							<span>예상 취소 수수료</span> <span id="cancelFee">0원 (무료 취소)</span>
						</div>
						<div class="fee-row total">
							<span>예상 환불 금액</span> <span id="cancelRefundAmount">136,000원</span>
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
				<button type="button" class="btn btn-outline-secondary"
					data-bs-dismiss="modal">돌아가기</button>
				<button type="button" class="btn btn-danger"
					onclick="confirmCancel()">
					<i class="bi bi-x-circle me-1"></i>결제 취소하기
				</button>
			</div>
		</div>
	</div>
</div>


<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script type="text/javascript">
var cp = '${pageContext.request.contextPath}'; 
let receiptItems = []; 
let uploadedFiles = [];
let receiptModal, refundModal, reviewModal, cancelConfirmModal;
let deletedFiles = [];

//알림창 (Alert 대체)
const toast = (title, icon = 'success') => {
    Swal.fire({
        title: title,
        icon: icon,
        confirmButtonColor: '#3085d6',
        confirmButtonText: '확인'
    });
};

// 확인창 (Confirm 대체)
const confirmSwal = (title, text, icon = 'warning') => {
    return Swal.fire({
        title: title,
        text: text,
        icon: icon,
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: '확인',
        cancelButtonText: '취소'
    });
};

$(function(){
    // Bootstrap 모달 초기화
    receiptModal = new bootstrap.Modal(document.getElementById('receiptModal'));
    refundModal = new bootstrap.Modal(document.getElementById('refundModal'));
    reviewModal = new bootstrap.Modal(document.getElementById('reviewModal'));
    cancelConfirmModal = new bootstrap.Modal(document.getElementById('cancelConfirmModal'));

    // 페이징 및 탭 이벤트
    $("#pagingArea").on("click", "a", function(e){
        e.preventDefault();
        $("#page").val($(this).data("page"));
        $("#searchForm").submit();
    });
    
    $(".mypage-tab").on("click", function(){
        location.href = cp + "/mypage/payments/list?page=1&contentType=" + $(this).data("category");
    });

    // 별점 클릭 및 글자수 체크
    $(document).on("click", ".star-rating i", function() {
        const rating = $(this).data("rating");
        $("#reviewRating").val(rating);
        $(".star-rating i").removeClass("bi-star-fill active").addClass("bi-star");
        $(this).prevAll().addBack().removeClass("bi-star").addClass("bi-star-fill active");
        $("#ratingText").text(rating + "점 - " + getRatingText(rating));
    });

    $("#reviewContent").on("input", function() {
        $("#reviewCharCount").text($(this).val().length);
    });

    // 사진 선택 시 미리보기 및 누적 관리 
    $("#reviewImages").on("change", function(e) {
        const files = Array.from(e.target.files);
        const previewList = $("#imagePreviewList");

        if (uploadedFiles.length + files.length > 5) {
        	toast("사진은 최대 5장까지 첨부 가능합니다.", "error");
            $(this).val(""); 
            return;
        }

        files.forEach((file) => {
            uploadedFiles.push(file); 
            const reader = new FileReader();
            reader.onload = function(e) {
                const html = 
                    '<div class="image-preview-item new-file">' +
                    '<img src="' + e.target.result + '">' +
                    '<button type="button" class="remove-btn" onclick="removeFile(this, \'' + file.name + '\')">×</button>' +
                    '</div>';
                previewList.append(html);
            };
            reader.readAsDataURL(file);
        });
        $(this).val(""); 
    });
});

function printReceipt() {
    window.print();
}

/* --- 포맷팅 유틸리티 함수 추가 --- */
// 결제번호 생성 (날짜8자리 + payNo8자리)
function formatPayNo(dateStr, payNo) {
 if (!dateStr || !payNo) return "-";
 // dateStr: "2026.01.24 10:56:09" 형식을 가정
 const datePart = dateStr.split(' ')[0].replace(/\./g, '');
 const payNoPart = String(payNo).padStart(8, '0');
 return datePart + payNoPart;
}

// 사업자번호 포맷팅 (000-00-00000)
function formatBrno(num) {
 if (!num || num === "정보 없음") return num;
 const cleaned = String(num).replace(/\D/g, '');
 if (cleaned.length !== 10) return num;
 return cleaned.replace(/(\d{3})(\d{2})(\d{5})/, '$1-$2-$3');
}

// 전화번호 포맷팅 (지역번호 및 휴대폰 대응)
function formatTel(num) {
 if (!num || num === "정보 없음") return num;
 const cleaned = String(num).replace(/\D/g, '');
 if (cleaned.startsWith('02')) {
     return cleaned.replace(/(\d{2})(\d{3,4})(\d{4})/, '$1-$2-$3');
 }
 return cleaned.replace(/(\d{3})(\d{3,4})(\d{4})/, '$1-$2-$3');
}

/* --- showReceipt 함수 수정 --- */
/* 영수증 상세 조회 함수 수정 */
function showReceipt(payNo) {
    $.ajax({
        url: cp + "/mypage/payments/receiptDetail",
        type: "get",
        data: { payNo: payNo },
        success: function(res) {
            const master = res.master; 
            receiptItems = res.details; 

            if (!res || !res.master) {
                alert("결제 정보를 찾을 수 없습니다.");
                console.error("데이터 응답 오류:", res);
                return;
            }
            
            // ... 결제 및 판매자 정보 매핑 로직 (기존 유지) ...
            const displayPayNo = formatPayNo(master.PAY_DT, master.PAY_NO);
            $("#receiptOrderNo").text(displayPayNo); 
            $("#receiptPayMethod").text(master.PAY_METHOD_CD); 
            $("#receiptOriginalPrice").text(Number(master.PROD_TOTAL_PRICE || 0).toLocaleString() + "원");
            $("#receiptDiscount").text("-" + Number(master.TOTAL_DISCOUNT || 0).toLocaleString() + "원");
            $("#receiptPointUsed").text("-" + Number(master.USE_POINT || 0).toLocaleString() + "원");
            $("#receiptTotalPrice").text(Number(master.PAY_TOTAL_AMT || 0).toLocaleString() + "원");
            const earnedPoints = Math.floor(Number(master.PAY_TOTAL_AMT || 0) * 0.03);
            $("#receiptEarnedPoints").text("+" + earnedPoints.toLocaleString() + "P");
            $("#receiptMemName").text(master.MEM_NAME);   
            $("#receiptTel").text(formatTel(master.MEM_TEL)); 
            $("#receiptMemEmail").text(master.MEM_EMAIL); 
            $("#receiptCompName").text(master.BZMN_NM || "정보 없음"); 
            $("#receiptBrno").text(formatBrno(master.BRNO || "정보 없음"));
            $("#receiptCompTel").text(formatTel(master.COMP_TEL || "정보 없음")); 
            if(master.PAY_DT) $("#receiptPayDate").text(master.PAY_DT.replace('T', ' '));

            /* 상품 리스트 생성 로직 - 이미지 경로 수정 */
            let detailHtml = "";
            receiptItems.forEach(function(item, index) {
                // 이미지 경로 결정
                let thumbImg = "";
                
             	// 이미 경로에 'resources'가 포함되어 있는 경우 (이미 프로젝트 내 경로임)
                if (item.THUMB_IMG && item.THUMB_IMG.indexOf('resources') > -1) {
                    // 앞에 /files를 붙이지 않고 컨텍스트 패스(cp)만 붙임
                    let cleanPath = item.THUMB_IMG.startsWith('/') ? item.THUMB_IMG : '/' + item.THUMB_IMG;
                    thumbImg = cp + cleanPath;
                }
                // 항공권일 때
                else if (item.PROD_NAME.indexOf('항공') > -1) {
                    thumbImg = cp + '/resources/images/default_flight.jpg';
                } 
                // 순수 파일 경로만 있는 경우 (투어 등 업로드 파일)
                else if (item.THUMB_IMG && item.THUMB_IMG !== '/resources/images/no_image.jpg') {
                    let cleanPath = item.THUMB_IMG.startsWith('/') ? item.THUMB_IMG : '/' + item.THUMB_IMG;
                    thumbImg = cp + '/files' + cleanPath;
                } 
                // 그 외 기본 이미지
                else {
                    thumbImg = cp + '/resources/images/no_image.jpg';
                }


                item.processedImg = thumbImg;
                
                /* showReceipt 함수 내 버튼 생성 로직 수정 */
                let actionBtn = "";

                // 항공권이 아닐 것
                if(item.PROD_NAME.indexOf('항공') === -1) {
                    
                    // 이용 완료(DONE) 상태일 때만 버튼 노출
                    if(item.PAY_STATUS === 'DONE') {
                        if(item.PROD_RV_NO) {
                            // 이미 작성한 후기가 있는 경우: 수정/삭제
                            actionBtn = '<div class="d-flex gap-2 mt-2">' +
                                '<button class="btn btn-sm btn-outline-secondary" onclick="prepareReviewModal(\'EDIT\',' + index + ')">수정</button>' +
                                '<button class="btn btn-sm btn-outline-danger" onclick="deleteReview(' + item.PROD_RV_NO + ')">삭제</button>' +
                                '</div>';
                        } else {
                            // 아직 후기가 없는 경우: 후기 작성
                            actionBtn = '<button class="btn btn-sm btn-primary mt-2" onclick="prepareReviewModal(\'INSERT\',' + index + ')">후기 작성</button>';
                        }
                    } else if(item.PAY_STATUS === 'WAIT') {
                        // 이용 예정(WAIT) 상태일 때는 안내 문구 또는 버튼 숨김
                        actionBtn = '<p class="text-muted mt-2" style="font-size: 12px;"><i class="bi bi-info-circle"></i> 이용 완료 후 후기 작성이 가능합니다.</p>';
                    }
                }

                
                
                // 가로 배치를 위한 flex 구조 적용
                detailHtml += '<div class="receipt-product" style="display: flex; gap: 15px; align-items: center; margin-bottom: 15px; padding: 10px; background: #f8fafc; border-radius: 8px;">' +
                    '<img src="' + thumbImg + '" style="width:70px; height:70px; border-radius:8px; object-fit:cover; flex-shrink: 0;" ' +
                    'onerror="this.src=\'' + cp + '/resources/images/no_image.jpg\'">' +
                    '<div class="receipt-product-info" style="flex: 1;">' +
                    '<h4 style="margin: 0 0 5px 0; font-size: 16px; font-weight: 600;">' + item.PROD_NAME + '</h4>' +
                    '<p style="margin: 0; color: #64748b; font-size: 14px;">' + item.USE_INFO + '</p>' +
                    '<p style="margin: 0; color: #64748b; font-size: 14px;">' + item.QUANTITY + '개 | ' + Number(item.ITEM_TOTAL_PRICE).toLocaleString() + '원</p>' +
                    actionBtn + 
                    '</div></div>';
            });
            
            $(".receipt-product-area").html(detailHtml);
            receiptModal.show();
        },
        error: function(xhr, status, error) { 
            console.error("Detail Error:", error);
            alert("정보를 불러오는데 실패했습니다."); 
        }
    });
}

/* 후기 모달 데이터 세팅 */
function prepareReviewModal(mode, idx) {
    const item = receiptItems[idx];
    deletedFiles = [];  // 삭제 리스트 초기화
    uploadedFiles = []; // 신규 업로드 리스트 초기화
    $("#imagePreviewList").empty(); 
    $("#reviewImages").val(""); // input file 초기화
    
    $("#reviewTripProdNo").val(item.TRIP_PROD_NO);
    $("#reviewProductName").text(item.PROD_NAME);
    
    // 모달 상단 상품 이미지 설정
    let displayImg = item.processedImg || (cp + '/resources/images/no_image.jpg');
    
    // 엑박 방지를 위한 추가 체크 (문자열에 undefined가 포함된 경우 등)
    if (displayImg.includes('undefined')) {
        displayImg = cp + '/resources/images/no_image.jpg';
    }

    $("#reviewProductImage").attr("src", displayImg);
    $("#reviewProductDate").text(item.USE_INFO);

    if (mode === 'EDIT') {
        $("#reviewModalLabel").html('<i class="bi bi-pencil-square"></i> 후기 수정');
        $("#btnSubmitReview").text('후기 수정');
        $("#reviewProdRvNo").val(item.PROD_RV_NO);
        $("#reviewContent").val(item.PROD_REVIEW);
        
        // 별점 세팅
        const rating = parseInt(item.RATING || 5);
        $("#reviewRating").val(rating);
        $(".star-rating i").removeClass("bi-star-fill active").addClass("bi-star");
        $(".star-rating i").each(function() {
            if ($(this).data("rating") <= rating) $(this).removeClass("bi-star").addClass("bi-star-fill active");
        });

        // 추천 여부
        const rcmdVal = item.RCMDTN_YN === 'N' ? 'no' : 'yes';
        $("input[name='recommend'][value='" + rcmdVal + "']").prop("checked", true);

        // 기존 이미지 불러오기 및 삭제 이벤트 바인딩
       if (item.EXISTING_IMAGES) {
	    const imgPaths = item.EXISTING_IMAGES.split(',');
	    imgPaths.forEach(path => {
	        // 공백 제거 (매우 중요: 콤마 뒤에 공백이 있으면 경로가 깨짐)
	        let cleanPath = path.trim();
	        if(!cleanPath) return; 
	
	        // 슬래시 중복 방지 로직
	        // cleanPath가 /로 시작하면 그냥 붙이고, 아니면 /를 넣어서 붙임
	        let finalPath = cleanPath.startsWith('/') ? cleanPath : '/' + cleanPath;
	        let webPath = cp + "/files" + finalPath; 
	        
	        // HTML 생성 (변수명 대문자 item.ATTACH_NO 확인 필수)
	        const html = '<div class="image-preview-item existing-file">' +
	                     '<img src="' + webPath + '">' +
	                     '<button type="button" class="remove-btn" ' +
	                     'onclick="removeExistingFile(this, \'' + cleanPath + '\')">×</button>' +
	                     '</div>';
	        $("#imagePreviewList").append(html);
	    });
	}
    } else {
        // 등록 모드 초기화
        $("#reviewModalLabel").html('<i class="bi bi-star"></i> 후기 작성');
        $("#btnSubmitReview").text('후기 등록');
        $("#reviewProdRvNo").val("");
        $("#reviewContent").val("");
        $("#reviewRating").val(5);
        $(".star-rating i").addClass("bi-star-fill active");
        $("input[name='recommend'][value='yes']").prop("checked", true);
    }
    reviewModal.show();
}

/* 기존 이미지 삭제 버튼 클릭 시 SweetAlert2 적용 */
function removeExistingFile(btn, filePath) {
    confirmSwal("사진 삭제", "이 사진을 삭제하시겠습니까?", "question")
    .then((result) => {
        if (result.isConfirmed) {
            // 서버로 보낼 삭제 목록에 추가
            deletedFiles.push(filePath); 
            // UI에서 제거
            $(btn).closest('.image-preview-item').remove();
            
            // 삭제되었다는 간단한 알림 (선택 사항)
            Swal.fire({
                title: '삭제되었습니다.',
                text: ' ',
                icon: 'success',
                timer: 1500,
                showConfirmButton: false
            });
        }
    });
}

/* 신규 추가한 파일 삭제 (SweetAlert 없이 즉시 삭제 권장 혹은 적용 선택) */
function removeFile(btn, fileName) {
    $(btn).closest('.image-preview-item').remove();
    uploadedFiles = uploadedFiles.filter(f => f.name !== fileName);
}

/* 후기 제출 */
function submitReview() {
    const rvNo = $("#reviewProdRvNo").val(); // 수정일 때만 값이 있음
    const isUpdate = !!rvNo;
    const url = isUpdate ? cp + "/mypage/payments/review/update" : cp + "/mypage/payments/review/insert";
    
    let formData = new FormData();
    
    // 공통 필드 (등록/수정 공통)
    formData.append("tripProdNo", $("#reviewTripProdNo").val());
    formData.append("prodReview", $("#reviewContent").val());
    formData.append("rating", $("#reviewRating").val());
    formData.append("rcmdtnYn", $("input[name='recommend']:checked").val() === 'yes' ? 'Y' : 'N');
    
    if (isUpdate) {
        // 수정 모드 전용
        formData.append("prodRvNo", rvNo);
        deletedFiles.forEach(path => formData.append("deletedFiles", path));
    }
    
    // 중요: 신규 업로드 파일 전송 (등록/수정 공통)
    if (uploadedFiles.length > 0) {
        uploadedFiles.forEach(file => {
            formData.append("uploadFiles", file);
        });
    }

    // 유효성 검사
    if (!$("#reviewContent").val().trim()) { 
    	toast("내용을 입력해주세요.", "error"); 
        return; 
    }

    $.ajax({
        url: url,
        type: "POST",
        data: formData,
        processData: false,
        contentType: false, // 브라우저가 알아서 boundary를 설정하게 함
        success: function(res) {
            if(res.success || res.message) {
                // alert 대신 Swal.fire 또는 toast 사용
                Swal.fire({
                    title: res.message,
                    text: ' ',
                    icon: 'success',
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: '확인'
                }).then((result) => {
                    if (result.isConfirmed) {
                        location.reload();
                    }
                });
            } else {
                toast("처리에 실패했습니다.", "error");
            }
        },
        error: function(xhr) {
            console.error("Error Details:", xhr.responseText);
            alert("서버 오류가 발생했습니다. (상태코드: " + xhr.status + ")");
        }
    });
}

function removeFile(btn, fileName) {
    $(btn).closest('.image-preview-item').remove();
    uploadedFiles = uploadedFiles.filter(f => f.name !== fileName);
}

/* 후기 삭제 기능 통합 */
function deleteReview(prodRvNo) {
    confirmSwal("후기 삭제", "정말 이 후기를 삭제하시겠습니까?", "warning")
    .then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: cp + "/mypage/payments/review/delete", 
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify({ prodRvNo: prodRvNo }),
                success: function(res) {
                    if(res.success) {
                        Swal.fire('삭제 완료', res.message, 'success')
                        .then(() => location.reload());
                    } else {
                        toast(res.message, "error");
                    }
                },
                error: function() {
                    toast("삭제 처리 중 에러가 발생했습니다.", "error");
                }
            });
        }
    });
}

function getRatingText(rating) {
    const texts = {1:"나빠요", 2:"별로예요", 3:"보통이에요", 4:"좋아요", 5:"최고예요!"};
    return texts[rating] || "";
}
</script>

<style>
/* 이용 완료 아이콘 스타일 */
.payment-status.DONE {
	background-color: #08a94e;
	color: white;
	padding: 5px 15px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 600;
	display: inline-block;
}

/* 이용 예정 아이콘 스타일 */
.payment-status.WAIT {
	background-color: #ff9f1c;
	color: white;
	padding: 5px 15px;
	border-radius: 20px;
	font-size: 12px;
}

/* 취소 완료 아이콘 스타일 */
.payment-status.CANCEL {
	background-color: #cccccc;
	color: white;
	padding: 5px 15px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 600;
	display: inline-block;
}

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

.star-rating i:hover, .star-rating i.active {
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

.recommend-option input:checked+.recommend-btn.yes {
	border-color: var(--primary);
	background: #f0f7ff;
	color: var(--primary);
}

.recommend-option input:checked+.recommend-btn.no {
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

.image-preview-list {
	display: flex;
	gap: 10px;
	flex-wrap: wrap;
	margin-top: 10px;
}

.image-preview-item {
	position: relative;
	width: 80px;
	height: 80px;
	border-radius: 8px;
	overflow: hidden;
	border: 1px solid #ddd;
}

.image-preview-item img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.image-preview-item .remove-btn {
	position: absolute;
	top: 2px;
	right: 2px;
	width: 20px;
	height: 20px;
	background: rgba(0, 0, 0, 0.6);
	color: white;
	border: none;
	border-radius: 50%;
	font-size: 12px;
	cursor: pointer;
}

/* 영수증 인쇄 스타일 */
@media print {
	/* 모든 요소 숨김 */
	body * {
		visibility: hidden;
	}

	/* 영수증 모달과 그 내용만 표시 */
	#receiptModal, #receiptModal * {
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
	#receiptModal .modal-header .btn-close, #receiptModal .modal-footer {
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

.stat-icon {
  font-size: 1.6rem;
  font-weight: 700;
}
</style>

<c:set var="pageJs" value="mypage" />
<%@ include file="../common/footer.jsp"%>
