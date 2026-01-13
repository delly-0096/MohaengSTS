<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="pageTitle" value="운영자 문의" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../common/header.jsp" %>

<div class="mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>운영자 문의</h1>
                    <p>1:1 문의 내역을 확인하세요</p>
                </div>

                <!-- 통계 카드 -->
                <div class="stats-grid">
                    <div class="stat-card primary">
                        <div class="stat-icon"><i class="bi bi-chat-dots"></i></div>
                        <div class="stat-value">${status.total}</div>
                        <div class="stat-label">전체 문의</div>
                    </div>
                    <div class="stat-card secondary">
                        <div class="stat-icon"><i class="bi bi-check-circle"></i></div>
                        <div class="stat-value">${status.answered}</div>
                        <div class="stat-label">답변 완료</div>
                    </div>
                    <div class="stat-card accent">
                        <div class="stat-icon"><i class="bi bi-hourglass-split"></i></div>
                        <div class="stat-value">${status.waiting}</div>
                        <div class="stat-label">답변 대기</div>
                    </div>
                </div>

                <!-- 탭 -->
                <div class="mypage-tabs">
                    <button class="mypage-tab ${currentFilter == 'all' ? 'active' : ''}"
                            onclick="changeFilter('all')">전체</button>
                    <button class="mypage-tab ${currentFilter == 'answered' ? 'active' : ''}"
                            onclick="changeFilter('answered')">답변 완료</button>
                    <button class="mypage-tab ${currentFilter == 'waiting' ? 'active' : ''}"
                            onclick="changeFilter('waiting')">답변 대기</button>
                    <a href="${pageContext.request.contextPath}/support/inquiry#write" class="btn btn-primary btn-sm ms-auto">
                        <i class="bi bi-pencil me-1"></i>문의 작성
                    </a>
                </div>

                <!-- 문의 내역 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-list-ul"></i> 문의 내역</h3>
                        <div class="d-flex gap-2">
                            <select class="form-select form-select-sm" style="width: 120px;"
                                    onchange="changeMonths(this.value)">
                                <option value="3" ${currentMonths == 3 ? 'selected' : ''}>최근 3개월</option>
                                <option value="6" ${currentMonths == 6 ? 'selected' : ''}>최근 6개월</option>
                                <option value="12" ${currentMonths == 12 ? 'selected' : ''}>최근 1년</option>
                                <option value="0" ${currentMonths == 0 ? 'selected' : ''}>전체</option>
                            </select>
                        </div>
                    </div>

                    <div class="inquiry-list-mypage">
                        <c:choose>
                            <c:when test="${empty inquiryList}">
                                <div class="empty-state" style="text-align: center; padding: 60px 20px; color: #999;">
                                    <i class="bi bi-inbox" style="font-size: 48px; margin-bottom: 16px;"></i>
                                    <p style="font-size: 16px; margin: 0;">문의 내역이 없습니다.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="inquiry" items="${inquiryList}">
                                    <!-- 문의 아이템 -->
                                    <div class="inquiry-item-mypage" data-status="${inquiry.inqryStatus}">
                                        <div class="inquiry-item-header-mypage" onclick="toggleInquiry(this)">
                                            <div class="inquiry-info">
                                                <span class="inquiry-category">${inquiry.categoryName}</span>
                                                <h4 class="inquiry-title">${inquiry.inqryTitle}</h4>
                                                <div class="inquiry-meta">
                                                    <span>${inquiry.regDtStr}</span>
                                                </div>
                                            </div>
                                            <div class="inquiry-status-wrap">
                                                <c:choose>
                                                    <c:when test="${inquiry.inqryStatus == 'answered'}">
                                                        <span class="inquiry-status answered">답변완료</span>
                                                    </c:when>
                                                    <c:when test="${inquiry.inqryStatus == 'waiting'}">
                                                        <span class="inquiry-status waiting">답변대기</span>
                                                    </c:when>
                                                </c:choose>
                                                <i class="bi bi-chevron-down"></i>
                                            </div>
                                        </div>
                                        <div class="inquiry-body-mypage">
                                            <div class="inquiry-question">
                                                <div class="inquiry-label">문의 내용</div>
                                                <p>${fn:replace(inquiry.inqryCn, newLineChar, '<br>')}</p>
                                            </div>
                                            <c:if test="${inquiry.inqryStatus == 'answered' && not empty inquiry.replyCn}">
                                                <div class="inquiry-answer-box">
                                                    <div class="inquiry-label">답변
                                                        <span class="answer-date">${inquiry.replyDtStr}</span>
                                                    </div>
                                                    <p>${fn:replace(inquiry.replyCn, newLineChar, '<br>')}</p>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 페이지네이션 -->
                <c:if test="${totalPages > 0}">
                    <div class="pagination-container">
                        <nav>
                            <ul class="pagination">
                                <!-- 이전 페이지 -->
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="javascript:goToPage(${currentPage - 1})">
                                        <i class="bi bi-chevron-left"></i>
                                    </a>
                                </li>

                                <!-- 페이지 번호 -->
                                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                    <li class="page-item ${currentPage == pageNum ? 'active' : ''}">
                                        <a class="page-link" href="javascript:goToPage(${pageNum})">${pageNum}</a>
                                    </li>
                                </c:forEach>

                                <!-- 다음 페이지 -->
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="javascript:goToPage(${currentPage + 1})">
                                        <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
// 문의 아코디언
function toggleInquiry(header) {
    const item = header.closest('.inquiry-item-mypage');
    item.classList.toggle('active');
}

// 필터 변경
function changeFilter(filter) {
    const url = '${pageContext.request.contextPath}/mypage/inquiries';
    const params = new URLSearchParams();
    params.append('filter', filter);
    params.append('months', '${currentMonths}');
    params.append('page', '1');
    window.location.href = url + '?' + params.toString();
}

// 조회 기간 변경
function changeMonths(months) {
    const url = '${pageContext.request.contextPath}/mypage/inquiries';
    const params = new URLSearchParams();
    params.append('filter', '${currentFilter}');
    params.append('months', months);
    params.append('page', '1');
    window.location.href = url + '?' + params.toString();
}

// 페이지 이동
function goToPage(page) {
    if (page < 1 || page > ${totalPages}) return;

    const url = '${pageContext.request.contextPath}/mypage/inquiries';
    const params = new URLSearchParams();
    params.append('filter', '${currentFilter}');
    params.append('months', '${currentMonths}');
    params.append('page', page);
    window.location.href = url + '?' + params.toString();
}
</script>

<c:set var="pageJs" value="mypage" />
<%@ include file="../common/footer.jsp" %>