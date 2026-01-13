<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="아이디/비밀번호 찾기" />
<c:set var="pageCss" value="member" />

<%@ include file="../common/header.jsp" %>

<div class="auth-page">
    <div class="auth-container">
        <div class="auth-card">
            <!-- 헤더 -->
            <div class="auth-header">
                <a href="${pageContext.request.contextPath}/" class="auth-logo">
                    <img src="${pageContext.request.contextPath}/resources/images/moheng_CI.png" alt="모행" class="auth-logo-img">
                </a>
                <h1 class="auth-title">아이디/비밀번호 찾기</h1>
                <p class="auth-subtitle">가입 시 등록한 정보로 찾을 수 있습니다</p>
            </div>

            <!-- 탭 -->
            <div class="find-tabs">
                <button type="button" class="find-tab active" data-tab="findId" onclick="switchFindTab('findId')">
                    아이디 찾기
                </button>
                <button type="button" class="find-tab" data-tab="findPw" onclick="switchFindTab('findPw')">
                    비밀번호 찾기
                </button>
            </div>

            <!-- 아이디 찾기 -->
            <div class="find-content active" id="findIdContent">
                <form class="auth-form" id="findIdForm" onsubmit="return findId(event)">
                    <div class="form-group">
                        <label class="form-label">이름</label>
                        <input type="text" class="form-control" name="userName" id="findIdName"
                               placeholder="이름을 입력하세요" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">이메일</label>
                        <input type="email" class="form-control" name="email" id="findIdEmail"
                               placeholder="가입 시 등록한 이메일을 입력하세요" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-submit">
                        아이디 찾기
                    </button>
                </form>
            </div>

            <!-- 비밀번호 찾기 -->
            <div class="find-content" id="findPwContent">
                <form class="auth-form" id="findPwForm" onsubmit="return findPassword(event)">
                    <div class="form-group">
                        <label class="form-label">아이디</label>
                        <input type="text" class="form-control" name="userId" id="findPwId"
                               placeholder="아이디를 입력하세요" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">이름</label>
                        <input type="text" class="form-control" name="userName" id="findPwName"
                               placeholder="이름을 입력하세요" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">이메일</label>
                        <input type="email" class="form-control" name="email" id="findPwEmail"
                               placeholder="가입 시 등록한 이메일을 입력하세요" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-submit">
                        비밀번호 찾기
                    </button>
                </form>
            </div>

            <!-- 로그인 링크 -->
            <div class="auth-footer">
                <a href="${pageContext.request.contextPath}/member/login">로그인으로 돌아가기</a>
            </div>
        </div>
    </div>
</div>

<!-- 아이디 찾기 결과 모달 -->
<div class="modal fade" id="findIdModal" tabindex="-1" aria-labelledby="findIdModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header border-0">
                <h5 class="modal-title" id="findIdModalLabel">아이디 찾기 결과</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center py-4">
                <div class="find-result-icon mx-auto mb-3">
                    <i class="bi bi-check-lg"></i>
                </div>
                <p class="find-result-text mb-2">회원님의 아이디는</p>
                <p class="find-result-id" id="foundUserId"></p>
                <p class="find-result-text">입니다.</p>
            </div>
            <div class="modal-footer border-0 justify-content-center">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">닫기</button>
                <a href="${pageContext.request.contextPath}/member/login" class="btn btn-primary">로그인하기</a>
            </div>
        </div>
    </div>
</div>

<!-- 비밀번호 찾기 결과 모달 -->
<div class="modal fade" id="findPwModal" tabindex="-1" aria-labelledby="findPwModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header border-0">
                <h5 class="modal-title" id="findPwModalLabel">비밀번호 찾기 결과</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center py-4">
                <div class="find-result-icon mx-auto mb-3" style="background: var(--success-color);">
                    <i class="bi bi-envelope-check"></i>
                </div>
                <p class="find-result-text" style="font-size: 17px; font-weight: 500;">
                    등록된 이메일로 임시 비밀번호가<br>전송되었습니다.
                </p>
                <p class="text-muted mt-3" style="font-size: 13px;">
                    이메일이 도착하지 않았다면 스팸함을 확인해주세요.
                </p>
            </div>
            <div class="modal-footer border-0 justify-content-center">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">닫기</button>
                <a href="${pageContext.request.contextPath}/member/login" class="btn btn-primary">로그인하기</a>
            </div>
        </div>
    </div>
</div>

<style>
/* 모달 내 결과 아이콘 */
#findIdModal .find-result-icon,
#findPwModal .find-result-icon {
    width: 64px;
    height: 64px;
    background: var(--primary-color);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 28px;
    color: white;
}

#findIdModal .find-result-id,
#findPwModal .find-result-id {
    font-size: 22px;
    font-weight: 700;
    color: var(--primary-color);
    margin: 12px 0;
}

#findIdModal .modal-content,
#findPwModal .modal-content {
    border-radius: var(--radius-lg);
    border: none;
}

#findIdModal .modal-footer .btn,
#findPwModal .modal-footer .btn {
    min-width: 100px;
}
</style>

<script>
// 탭 전환
function switchFindTab(tabId) {
    // 탭 버튼 활성화
    var tabs = document.querySelectorAll('.find-tab');
    for (var i = 0; i < tabs.length; i++) {
        tabs[i].classList.remove('active');
    }
    var selectedTab = document.querySelector('.find-tab[data-tab="' + tabId + '"]');
    if (selectedTab) {
        selectedTab.classList.add('active');
    }

    // 콘텐츠 활성화
    var contents = document.querySelectorAll('.find-content');
    for (var j = 0; j < contents.length; j++) {
        contents[j].classList.remove('active');
    }
    var selectedContent = document.getElementById(tabId + 'Content');
    if (selectedContent) {
        selectedContent.classList.add('active');
    }
}

// 아이디 찾기
function findId(e) {
    e.preventDefault();

    var name = document.getElementById('findIdName').value.trim();
    var email = document.getElementById('findIdEmail').value.trim();

    if (!name || !email) {
        if (typeof showToast === 'function') {
            showToast('모든 항목을 입력해주세요.', 'error');
        } else {
            alert('모든 항목을 입력해주세요.');
        }
        return false;
    }

    // API 호출 (실제 구현 시)
    // 데모용 결과 표시
    var maskedId = maskUserId('user123');
    document.getElementById('foundUserId').textContent = maskedId;

    // 모달 표시
    var findIdModal = new bootstrap.Modal(document.getElementById('findIdModal'));
    findIdModal.show();

    return false;
}

// 비밀번호 찾기
function findPassword(e) {
    e.preventDefault();

    var userId = document.getElementById('findPwId').value.trim();
    var name = document.getElementById('findPwName').value.trim();
    var email = document.getElementById('findPwEmail').value.trim();

    if (!userId || !name || !email) {
        if (typeof showToast === 'function') {
            showToast('모든 항목을 입력해주세요.', 'error');
        } else {
            alert('모든 항목을 입력해주세요.');
        }
        return false;
    }

    // API 호출 (실제 구현 시)
    // 데모용 결과 표시 - 모달로 임시 비밀번호 전송 메시지 표시
    var findPwModal = new bootstrap.Modal(document.getElementById('findPwModal'));
    findPwModal.show();

    return false;
}

// 아이디 마스킹
function maskUserId(userId) {
    if (userId.length <= 3) {
        return userId;
    }
    var visible = userId.substring(0, 3);
    var masked = '';
    for (var i = 0; i < userId.length - 3; i++) {
        masked += '*';
    }
    return visible + masked;
}
</script>

<c:set var="pageJs" value="member" />
<%@ include file="../common/footer.jsp" %>
