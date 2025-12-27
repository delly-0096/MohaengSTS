<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="로그인" />
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
                <h1 class="auth-title">로그인</h1>
                <p class="auth-subtitle">모행에 오신 것을 환영합니다!</p>
            </div>

            <!-- 회원 유형 선택 탭 -->
            <div class="login-type-tabs">
                <button type="button" class="login-type-tab active" data-type="PERSONAL">
                    <i class="bi bi-person"></i>
                    <span>개인회원</span>
                </button>
                <button type="button" class="login-type-tab" data-type="BUSINESS">
                    <i class="bi bi-building"></i>
                    <span>기업회원</span>
                </button>
            </div>

            <!-- 로그인 폼 -->
            <form class="auth-form" id="loginForm" action="${pageContext.request.contextPath}/member/login" method="POST">
                <input type="hidden" name="returnUrl" value="${param.returnUrl}">
                <input type="hidden" name="memberType" id="memberType" value="PERSONAL">

                <!-- 아이디 -->
                <div class="form-group">
                    <label class="form-label">아이디</label>
                    <input type="text" class="form-control" name="memId" id="memId"
                           placeholder="아이디를 입력하세요" required>
                    <div class="form-error">
                        <i class="bi bi-exclamation-circle"></i>
                        <span>아이디를 입력해주세요.</span>
                    </div>
                </div>

                <!-- 비밀번호 -->
                <div class="form-group">
                    <label class="form-label">비밀번호</label>
                    <div class="password-toggle">
                        <input type="password" class="form-control" name="memPassword" id="memPassword"
                               placeholder="비밀번호를 입력하세요" required>
                        <span class="toggle-btn" onclick="togglePassword('memPassword')">
                            <i class="bi bi-eye"></i>
                        </span>
                    </div>
                    <div class="form-error">
                        <i class="bi bi-exclamation-circle"></i>
                        <span>비밀번호를 입력해주세요.</span>
                    </div>
                </div>

                <!-- 로그인 옵션 -->
                <div class="login-options">
                    <label class="remember-me">
                        <input type="checkbox" name="rememberMe" id="rememberMe">
                        <span>로그인 상태 유지</span>
                    </label>
                    <a href="${pageContext.request.contextPath}/member/find" class="forgot-password">
                        아이디/비밀번호 찾기
                    </a>
                </div>

                <!-- 에러 메시지 -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger mb-3" role="alert">
                        <i class="bi bi-exclamation-triangle me-2"></i>${errorMessage}
                    </div>
                </c:if>

                <!-- 로그인 버튼 -->
                <button type="submit" class="btn btn-primary btn-submit">
                    로그인
                </button>
            </form>

            <!-- 구분선 (개인회원만) -->
            <div class="auth-divider" id="authDivider">또는</div>

            <!-- 소셜 로그인 (개인회원만) -->
            <div class="social-login" id="socialLoginSection">
                <button type="button" class="social-btn google" onclick="socialLogin('google')">
                    <i class="bi bi-google"></i>
                    Google 계정으로 로그인
                </button>
                <button type="button" class="social-btn naver" onclick="socialLogin('naver')">
                    <span class="naver-icon">N</span>
                    네이버 계정으로 로그인
                </button>
            </div>

            <!-- 회원가입 링크 -->
            <div class="auth-footer">
                아직 회원이 아니신가요?
                <a href="${pageContext.request.contextPath}/member/register">회원가입</a>
            </div>
        </div>
    </div>
</div>

<script>
// 회원 유형 탭 전환
document.querySelectorAll('.login-type-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        // 모든 탭에서 active 제거
        document.querySelectorAll('.login-type-tab').forEach(t => t.classList.remove('active'));
        // 클릭한 탭에 active 추가
        this.classList.add('active');
        // hidden input 값 변경
        document.getElementById('memberType').value = this.dataset.type;

        // 기업회원 선택 시 소셜 로그인 숨기기
        const socialLoginSection = document.getElementById('socialLoginSection');
        const authDivider = document.getElementById('authDivider');

        if (this.dataset.type === 'BUSINESS') {
            socialLoginSection.classList.add('d-none');
            authDivider.classList.add('d-none');
        } else {
            socialLoginSection.classList.remove('d-none');
            authDivider.classList.remove('d-none');
        }
    });
});

// 비밀번호 보기/숨기기 토글
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    const icon = input.nextElementSibling.querySelector('i');

    if (input.type === 'password') {
        input.type = 'text';
        icon.className = 'bi bi-eye-slash';
    } else {
        input.type = 'password';
        icon.className = 'bi bi-eye';
    }
}

// 소셜 로그인
function socialLogin(provider) {
    window.location.href = '${pageContext.request.contextPath}/oauth2/authorization/' + provider;
}

// 폼 유효성 검사
document.getElementById('loginForm').addEventListener('submit', function(e) {
    const memId = document.getElementById('memId');
    const memPassword = document.getElementById('memPassword');
    let isValid = true;

    // 아이디 검사
    if (!memId.value.trim()) {
    	memId.classList.add('is-invalid');
        isValid = false;
    } else {
    	memId.classList.remove('is-invalid');
    }

    // 비밀번호 검사
    if (!memPassword.value) {
    	memPassword.classList.add('is-invalid');
        isValid = false;
    } else {
    	memPassword.classList.remove('is-invalid');
    }

    if (!isValid) {
        e.preventDefault();
    }
});

// 입력 시 에러 상태 제거
document.querySelectorAll('.form-control').forEach(input => {
    input.addEventListener('input', function() {
        this.classList.remove('is-invalid');
    });
});
</script>

<c:set var="pageJs" value="member" />
<%@ include file="../common/footer.jsp" %>
