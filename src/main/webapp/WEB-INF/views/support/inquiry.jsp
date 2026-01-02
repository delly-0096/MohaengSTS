<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="pageTitle" value="1:1 문의" />
<c:set var="pageCss" value="support" />
<c:set var="newLine" value="
" />

<%@ include file="../common/header.jsp" %>

<div class="support-page">
    <div class="container">
        <!-- 헤더 -->
        <div class="support-header">
            <h1><i class="bi bi-chat-dots me-3"></i>1:1 문의</h1>
            <p>궁금한 점이 있으시면 문의해주세요</p>
        </div>

        <!-- 고객지원 네비게이션 -->
        <div class="support-nav">
            <a href="${pageContext.request.contextPath}/support/faq" class="support-nav-item">
                <i class="bi bi-question-circle me-2"></i>FAQ
            </a>
            <a href="${pageContext.request.contextPath}/support/notice" class="support-nav-item">
                <i class="bi bi-megaphone me-2"></i>공지사항
            </a>
            <a href="${pageContext.request.contextPath}/support/inquiry" class="support-nav-item active">
                <i class="bi bi-chat-dots me-2"></i>1:1 문의
            </a>
        </div>

        <div class="inquiry-container">
            <!-- 탭 -->
            <div class="inquiry-tabs">
                <button class="inquiry-tab ${currentTab == 'history' ? 'active' : ''}" data-tab="history">문의 내역</button>
                <button class="inquiry-tab ${currentTab == 'write' ? 'active' : ''}" data-tab="write">문의 작성</button>
            </div>

            <!-- 문의 작성 폼 -->
            <div class="inquiry-content-area" id="writeTab" style="display: ${currentTab == 'write' ? 'block' : 'none'};">
                <div class="inquiry-form">
                    <h3><i class="bi bi-pencil me-2"></i>문의하기</h3>

                    <form id="inquiryForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">문의 유형 <span class="text-danger">*</span></label>
                                    <select class="form-control form-select" id="inqryCtgryCd" required>
                                        <option value="">선택해주세요</option>
                                        <c:forEach var="category" items="${categoryList}">
                                            <option value="${category.cd}">${category.cdName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">관련 예약번호 (선택)</label>
                                    <input type="text" class="form-control" id="inquiryTargetNo" placeholder="예약번호가 있다면 입력해주세요">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">제목 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="inqryTitle" placeholder="문의 제목을 입력해주세요" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">문의 내용 <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="inqryCn" rows="8" placeholder="문의하실 내용을 상세히 작성해주세요" required></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label">첨부파일 (선택)</label>
                            <input type="file" class="form-control" id="attachFile" multiple accept="image/*,.pdf,.doc,.docx">
                            <small class="text-muted">최대 5개, 각 10MB 이하 (이미지, PDF, DOC 파일)</small>
                        </div>

                        <div class="form-group">
                            <label class="form-label">답변 받을 이메일 <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="inqryEmail" value="${loginEmail}" placeholder="이메일을 입력해주세요" required>
                            <small class="text-muted">답변 알림이 발송됩니다.</small>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="agreePrivacy" required>
                            <label class="form-check-label" for="agreePrivacy">
                                개인정보 수집 및 이용에 동의합니다. <a href="#" class="text-primary">내용 보기</a>
                            </label>
                        </div>

                        <button type="submit" class="btn btn-primary btn-lg w-100">
                            <i class="bi bi-send me-2"></i>문의 등록
                        </button>
                    </form>

                    <div class="alert alert-info mt-4">
                        <i class="bi bi-info-circle me-2"></i>
                        <strong>안내사항</strong>
                        <ul class="mb-0 mt-2 ps-3">
                            <li>문의 답변은 평일 09:00~18:00에 순차적으로 처리됩니다.</li>
                            <li>주말 및 공휴일에 접수된 문의는 다음 영업일에 답변됩니다.</li>
                            <li>긴급 문의는 AI 챗봇을 이용해주세요.</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- 문의 내역 -->
            <div class="inquiry-content-area" id="historyTab" style="display: ${currentTab == 'history' ? 'block' : 'none'};">
                <c:choose>
                    <c:when test="${not empty sessionScope.loginMember}">
                        <!-- 카테고리 필터 -->
                        <div class="faq-categories mb-4">
                            <button class="faq-category ${empty currentCategory || currentCategory == 'all' ? 'active' : ''}"
                                    onclick="changeCategory('all')">전체</button>
                            <c:forEach var="category" items="${categoryList}">
                                <button class="faq-category ${currentCategory == category.cd ? 'active' : ''}"
                                        onclick="changeCategory('${category.cd}')">${category.cdName}</button>
                            </c:forEach>
                        </div>

                        <div class="inquiry-list">
                            <c:choose>
                                <c:when test="${empty inquiryList}">
                                    <div class="text-center py-5" style="color: #999;">
                                        <i class="bi bi-inbox" style="font-size: 48px;"></i>
                                        <p class="mt-3">문의 내역이 없습니다.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="inquiry" items="${inquiryList}">
                                        <!-- 문의 아이템 -->
                                        <div class="inquiry-item">
                                            <div class="inquiry-item-header">
                                                <div class="inquiry-item-info">
                                                    <h4 class="inquiry-item-title">${inquiry.inqryTitle}</h4>
                                                    <div class="inquiry-item-meta">
                                                        <span class="badge bg-secondary me-2">${inquiry.categoryName}</span>
                                                        ${inquiry.regDtStr}
                                                    </div>
                                                </div>
                                                <c:choose>
                                                    <c:when test="${inquiry.inqryStatus == 'answered'}">
                                                        <span class="inquiry-status answered">답변완료</span>
                                                    </c:when>
                                                    <c:when test="${inquiry.inqryStatus == 'waiting'}">
                                                        <span class="inquiry-status waiting">답변대기</span>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                            <div class="inquiry-item-body">
                                                <div class="inquiry-content">
                                                    <div class="inquiry-content-label">문의 내용</div>
                                                    <p>${fn:replace(inquiry.inqryCn, newLine, '<br>')}</p>
                                                </div>
                                                <c:if test="${inquiry.inqryStatus == 'answered' && not empty inquiry.replyCn}">
                                                    <div class="inquiry-answer">
                                                        <div class="inquiry-content-label">답변 (${inquiry.replyDtStr})</div>
                                                        <p>${fn:replace(inquiry.replyCn, newLine, '<br>')}</p>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
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
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="bi bi-lock" style="font-size: 64px; color: var(--gray-light);"></i>
                            <h4 class="mt-3">로그인이 필요합니다</h4>
                            <p class="text-muted mb-4">문의 내역을 확인하려면 로그인해주세요.</p>
                            <a href="${pageContext.request.contextPath}/member/login" class="btn btn-primary">
                                <i class="bi bi-box-arrow-in-right me-2"></i>로그인
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
// 탭 전환 함수
function switchTab(tabName) {
    const url = '${pageContext.request.contextPath}/support/inquiry';
    const params = new URLSearchParams();
    params.append('tab', tabName);

    // 현재 카테고리 유지
    if (tabName === 'history') {
        params.append('category', '${currentCategory}');
        params.append('page', '${currentPage}');
    }

    window.location.href = url + '?' + params.toString();
}

// 페이지 로드 시 URL 해시 확인
document.addEventListener('DOMContentLoaded', function() {
    if (window.location.hash === '#write') {
        switchTab('write');
    }
});

// 탭 클릭 이벤트
document.querySelectorAll('.inquiry-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        const tabName = this.dataset.tab;
        switchTab(tabName);
    });
});

// 문의 아코디언
document.querySelectorAll('.inquiry-item-header').forEach(header => {
    header.addEventListener('click', function() {
        const item = this.closest('.inquiry-item');
        item.classList.toggle('active');
    });
});

// 카테고리 변경
function changeCategory(category) {
    const url = '${pageContext.request.contextPath}/support/inquiry';
    const params = new URLSearchParams();
    params.append('tab', 'history');
    params.append('category', category);
    params.append('page', '1');
    window.location.href = url + '?' + params.toString();
}

// 페이지 이동
function goToPage(page) {
    if (page < 1 || page > ${totalPages}) return;

    const url = '${pageContext.request.contextPath}/support/inquiry';
    const params = new URLSearchParams();
    params.append('tab', 'history');
    params.append('category', '${currentCategory}');
    params.append('page', page);
    window.location.href = url + '?' + params.toString();
}

// 문의 등록 폼
document.getElementById('inquiryForm').addEventListener('submit', function(e) {
    e.preventDefault();

    // 로그인 체크
    const isLoggedIn = ${not empty sessionScope.loginMember};
    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    // 폼 데이터 수집
    const formData = {
        inqryCtgryCd: document.getElementById('inqryCtgryCd').value,
        inqryTitle: document.getElementById('inqryTitle').value,
        inqryCn: document.getElementById('inqryCn').value,
        inquiryTargetNo: document.getElementById('inquiryTargetNo').value || null,
        inqryEmail: document.getElementById('inqryEmail').value
    };

    // AJAX 요청
    fetch('${pageContext.request.contextPath}/support/inquiry', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(formData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert(data.message);
            // 문의 내역 탭으로 이동
            window.location.href = '${pageContext.request.contextPath}/support/inquiry?tab=history';
        } else {
            alert(data.message);
            if (data.redirect) {
                window.location.href = data.redirect;
            }
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('문의 등록 중 오류가 발생했습니다.');
    });
});
</script>

<c:set var="pageJs" value="support" />
<%@ include file="../common/footer.jsp" %>