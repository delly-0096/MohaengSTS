<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="1:1 문의" />
<c:set var="pageCss" value="support" />

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
                <button class="inquiry-tab active" data-tab="history">운영자 문의</button>
                <button class="inquiry-tab" data-tab="write">문의 작성</button>
            </div>

            <!-- 문의 작성 폼 -->
            <div class="inquiry-content-area" id="writeTab" style="display: none;">
                <div class="inquiry-form">
                    <h3><i class="bi bi-pencil me-2"></i>문의하기</h3>

                    <form id="inquiryForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">문의 유형 <span class="text-danger">*</span></label>
                                    <select class="form-control form-select" required>
                                        <option value="">선택해주세요</option>
                                        <option>회원/계정</option>
                                        <option>일정/예약</option>
                                        <option>결제/환불</option>
                                        <option>포인트</option>
                                        <option>서비스 이용</option>
                                        <option>기타</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">관련 예약번호 (선택)</label>
                                    <input type="text" class="form-control" placeholder="예약번호가 있다면 입력해주세요">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">제목 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="문의 제목을 입력해주세요" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">문의 내용 <span class="text-danger">*</span></label>
                            <textarea class="form-control" rows="8" placeholder="문의하실 내용을 상세히 작성해주세요" required></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label">첨부파일 (선택)</label>
                            <input type="file" class="form-control" multiple accept="image/*,.pdf,.doc,.docx">
                            <small class="text-muted">최대 5개, 각 10MB 이하 (이미지, PDF, DOC 파일)</small>
                        </div>

                        <div class="form-group">
                            <label class="form-label">답변 받을 이메일 <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" value="${sessionScope.loginUser.email}" required>
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
            <div class="inquiry-content-area" id="historyTab">
                <c:choose>
                    <c:when test="${not empty sessionScope.loginUser}">
                        <!-- 카테고리 필터 -->
                        <div class="faq-categories mb-4">
                            <button class="faq-category active" data-category="all">전체</button>
                            <button class="faq-category" data-category="account">회원/계정</button>
                            <button class="faq-category" data-category="schedule">일정/예약</button>
                            <button class="faq-category" data-category="payment">결제/환불</button>
                            <button class="faq-category" data-category="point">포인트</button>
                            <button class="faq-category" data-category="service">서비스 이용</button>
                            <button class="faq-category" data-category="etc">기타</button>
                        </div>

                        <div class="inquiry-list">
                            <!-- 문의 1 - 답변 완료 -->
                            <div class="inquiry-item" data-category="payment">
                                <div class="inquiry-item-header">
                                    <div class="inquiry-item-info">
                                        <h4 class="inquiry-item-title">환불 요청 관련 문의드립니다.</h4>
                                        <div class="inquiry-item-meta">
                                            <span class="badge bg-secondary me-2">결제/환불</span>
                                            2024.03.10 14:32
                                        </div>
                                    </div>
                                    <span class="inquiry-status answered">답변완료</span>
                                </div>
                                <div class="inquiry-item-body">
                                    <div class="inquiry-content">
                                        <div class="inquiry-content-label">문의 내용</div>
                                        <p>지난 주 예약한 제주 스쿠버다이빙 체험을 취소하고 싶습니다. 환불 가능한지 확인 부탁드립니다.</p>
                                    </div>
                                    <div class="inquiry-answer">
                                        <div class="inquiry-content-label">답변 (2024.03.11 10:15)</div>
                                        <p>
                                            안녕하세요, 모행입니다.<br><br>
                                            문의주신 예약건 확인했습니다. 이용일 기준 7일 이상 남아있어 전액 환불 가능합니다.<br>
                                            마이페이지 > 결제 내역에서 직접 취소하시거나, 자동 취소 처리해드릴까요?<br><br>
                                            추가 문의사항이 있으시면 말씀해주세요.<br>
                                            감사합니다.
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <!-- 문의 2 - 답변 대기 -->
                            <div class="inquiry-item" data-category="point">
                                <div class="inquiry-item-header">
                                    <div class="inquiry-item-info">
                                        <h4 class="inquiry-item-title">포인트 적립이 안됐어요</h4>
                                        <div class="inquiry-item-meta">
                                            <span class="badge bg-secondary me-2">포인트</span>
                                            2024.03.14 16:45
                                        </div>
                                    </div>
                                    <span class="inquiry-status waiting">답변대기</span>
                                </div>
                                <div class="inquiry-item-body">
                                    <div class="inquiry-content">
                                        <div class="inquiry-content-label">문의 내용</div>
                                        <p>어제 이용 완료한 한라산 트레킹 투어 포인트가 아직 적립되지 않았습니다. 확인 부탁드립니다.</p>
                                    </div>
                                </div>
                            </div>

                            <!-- 문의 3 - 답변 완료 -->
                            <div class="inquiry-item" data-category="schedule">
                                <div class="inquiry-item-header">
                                    <div class="inquiry-item-info">
                                        <h4 class="inquiry-item-title">예약 일정 변경 가능한가요?</h4>
                                        <div class="inquiry-item-meta">
                                            <span class="badge bg-secondary me-2">일정/예약</span>
                                            2024.02.28 09:20
                                        </div>
                                    </div>
                                    <span class="inquiry-status answered">답변완료</span>
                                </div>
                                <div class="inquiry-item-body">
                                    <div class="inquiry-content">
                                        <div class="inquiry-content-label">문의 내용</div>
                                        <p>3월 5일로 예약한 서핑 레슨을 3월 12일로 변경하고 싶습니다. 가능할까요?</p>
                                    </div>
                                    <div class="inquiry-answer">
                                        <div class="inquiry-content-label">답변 (2024.02.28 14:30)</div>
                                        <p>
                                            안녕하세요, 모행입니다.<br><br>
                                            예약 일정 변경 확인했습니다. 3월 12일 동일 시간대로 변경 처리 완료되었습니다.<br>
                                            변경된 예약 내역은 마이페이지 > 결제 내역에서 확인하실 수 있습니다.<br><br>
                                            즐거운 여행 되세요!
                                        </p>
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
                                    <li class="page-item">
                                        <a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
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
    document.querySelectorAll('.inquiry-tab').forEach(t => t.classList.remove('active'));
    document.querySelector('.inquiry-tab[data-tab="' + tabName + '"]').classList.add('active');

    document.getElementById('writeTab').style.display = tabName === 'write' ? 'block' : 'none';
    document.getElementById('historyTab').style.display = tabName === 'history' ? 'block' : 'none';
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
        // URL 해시 업데이트
        history.replaceState(null, null, '#' + tabName);
    });
});

// 문의 아코디언
document.querySelectorAll('.inquiry-item-header').forEach(header => {
    header.addEventListener('click', function() {
        const item = this.closest('.inquiry-item');
        item.classList.toggle('active');
    });
});

// 문의 내역 카테고리 필터링
document.querySelectorAll('#historyTab .faq-category').forEach(category => {
    category.addEventListener('click', function() {
        document.querySelectorAll('#historyTab .faq-category').forEach(c => c.classList.remove('active'));
        this.classList.add('active');

        const cat = this.dataset.category;
        const items = document.querySelectorAll('.inquiry-item');

        items.forEach(item => {
            if (cat === 'all') {
                item.style.display = 'block';
            } else {
                item.style.display = item.dataset.category === cat ? 'block' : 'none';
            }
        });
    });
});

// 문의 등록
document.getElementById('inquiryForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const isLoggedIn = ${not empty sessionScope.loginUser};

    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    showToast('문의가 등록되었습니다. 빠른 시일 내에 답변드리겠습니다.', 'success');

    // 폼 초기화
    this.reset();
});
</script>

<c:set var="pageJs" value="support" />
<%@ include file="../common/footer.jsp" %>
