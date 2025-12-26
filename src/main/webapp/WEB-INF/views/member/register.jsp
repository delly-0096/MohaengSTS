<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="회원가입" />
<c:set var="pageCss" value="member" />

<%@ include file="../common/header.jsp" %>

<div class="auth-page">
    <div class="auth-container register-container">
        <div class="auth-card">
            <!-- 헤더 -->
            <div class="auth-header">
                <a href="${pageContext.request.contextPath}/" class="auth-logo">
                    <img src="${pageContext.request.contextPath}/resources/images/moheng_CI.png" alt="모행" class="auth-logo-img">
                </a>
                <h1 class="auth-title">회원가입</h1>
                <p class="auth-subtitle">모행과 함께 특별한 여행을 시작하세요</p>
            </div>

            <!-- 회원 유형 선택 -->
            <div class="member-type-selector">
                <div class="member-type-option">
                    <input type="radio" name="memberType" id="typeGeneral" value="GENERAL" checked>
                    <label for="typeGeneral" class="member-type-label">
                        <div class="member-type-icon">
                            <i class="bi bi-person"></i>
                        </div>
                        <span class="member-type-name">일반 회원</span>
                        <span class="member-type-desc">여행 계획 및 예약</span>
                    </label>
                </div>
                <div class="member-type-option">
                    <input type="radio" name="memberType" id="typeBusiness" value="BUSINESS">
                    <label for="typeBusiness" class="member-type-label">
                        <div class="member-type-icon">
                            <i class="bi bi-building"></i>
                        </div>
                        <span class="member-type-name">기업 회원</span>
                        <span class="member-type-desc">상품 등록 및 판매</span>
                    </label>
                </div>
            </div>

            <!-- 회원가입 폼 -->
            <form class="auth-form" id="registerForm" action="${pageContext.request.contextPath}/member/register" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="userType" id="userType" value="GENERAL">

                <!-- 아이디 -->
                <div class="form-group">
                    <label class="form-label">아이디 <span class="text-danger">*</span></label>
                    <div class="input-with-btn">
                        <input type="text" class="form-control" name="userId" id="userId"
                               placeholder="영문, 숫자 조합 4~20자" required>
                        <button type="button" class="btn btn-outline" onclick="checkDuplicateId()">
                            중복확인
                        </button>
                    </div>
                    <div class="form-hint" id="userIdHint">영문, 숫자 조합 4~20자로 입력해주세요.</div>
                    <div class="form-error">
                        <i class="bi bi-exclamation-circle"></i>
                        <span id="userIdError">아이디를 입력해주세요.</span>
                    </div>
                    <div class="form-success" id="userIdSuccess" style="display: none;">
                        <i class="bi bi-check-circle"></i>
                        <span>사용 가능한 아이디입니다.</span>
                    </div>
                </div>

                <!-- 비밀번호 -->
                <div class="form-group">
                    <label class="form-label">비밀번호 <span class="text-danger">*</span></label>
                    <div class="password-toggle">
                        <input type="password" class="form-control" name="password" id="password"
                               placeholder="비밀번호를 입력하세요" required onkeyup="checkPasswordStrength()">
                        <span class="toggle-btn" onclick="togglePassword('password')">
                            <i class="bi bi-eye"></i>
                        </span>
                    </div>
                    <div class="password-strength">
                        <div class="strength-bar">
                            <div class="strength-bar-fill" id="strengthBar"></div>
                        </div>
                        <span class="strength-text" id="strengthText">영문, 숫자, 특수문자 포함 8자 이상</span>
                    </div>
                    <div class="form-error">
                        <i class="bi bi-exclamation-circle"></i>
                        <span>비밀번호는 8자 이상이어야 합니다.</span>
                    </div>
                </div>

                <!-- 비밀번호 확인 -->
                <div class="form-group">
                    <label class="form-label">비밀번호 확인 <span class="text-danger">*</span></label>
                    <div class="password-toggle">
                        <input type="password" class="form-control" name="passwordConfirm" id="passwordConfirm"
                               placeholder="비밀번호를 다시 입력하세요" required onkeyup="checkPasswordMatch()">
                        <span class="toggle-btn" onclick="togglePassword('passwordConfirm')">
                            <i class="bi bi-eye"></i>
                        </span>
                    </div>
                    <div class="form-error">
                        <i class="bi bi-exclamation-circle"></i>
                        <span>비밀번호가 일치하지 않습니다.</span>
                    </div>
                    <div class="form-success" id="passwordMatchSuccess" style="display: none;">
                        <i class="bi bi-check-circle"></i>
                        <span>비밀번호가 일치합니다.</span>
                    </div>
                </div>

                <!-- 개인회원 전용 필드 -->
                <div id="personalFields">
                    <!-- 이름 -->
                    <div class="form-group">
                        <label class="form-label">이름 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="userName" id="userName"
                               placeholder="이름을 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>이름을 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 닉네임 -->
                    <div class="form-group">
                        <label class="form-label">닉네임 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="nickname" id="nickname"
                               placeholder="닉네임을 입력하세요">
                        <div class="form-hint">2~10자 이내로 입력해주세요.</div>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>닉네임을 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 주소 -->
                    <div class="form-group">
                        <label class="form-label">주소 <span class="text-danger">*</span></label>
                        <div class="input-with-btn">
                            <input type="text" class="form-control" name="postcode" id="postcode"
                                   placeholder="우편번호" readonly>
                            <button type="button" class="btn btn-outline" onclick="searchAddress()">
                                <i class="bi bi-search me-1"></i>주소검색
                            </button>
                        </div>
                        <input type="text" class="form-control mt-2" name="address" id="address"
                               placeholder="기본주소" readonly>
                        <input type="text" class="form-control mt-2" name="addressDetail" id="addressDetail"
                               placeholder="상세주소를 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>주소를 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 전화번호 -->
                    <div class="form-group">
                        <label class="form-label">전화번호 <span class="text-danger">*</span></label>
                        <input type="tel" class="form-control" name="phone" id="phone"
                               placeholder="'-' 없이 숫자만 입력하세요" maxlength="11">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>올바른 전화번호 형식이 아닙니다.</span>
                        </div>
                    </div>

                    <!-- 이메일 -->
                    <div class="form-group">
                        <label class="form-label">이메일 <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" name="email" id="email"
                               placeholder="이메일 주소를 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>올바른 이메일 형식이 아닙니다.</span>
                        </div>
                    </div>

                    <!-- 생년월일 -->
                    <div class="form-group">
                        <label class="form-label">생년월일 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control date-picker-birth" name="birthDate" id="birthDate"
                               placeholder="생년월일을 선택하세요" readonly>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>생년월일을 선택해주세요.</span>
                        </div>
                    </div>

                    <!-- 성별 (선택) -->
                    <div class="form-group">
                        <label class="form-label">성별 <span class="text-muted">(선택)</span></label>
                        <div class="gender-selector">
                            <label class="gender-option">
                                <input type="radio" name="gender" value="M">
                                <span class="gender-label">
                                    <i class="bi bi-gender-male"></i>
                                    남성
                                </span>
                            </label>
                            <label class="gender-option">
                                <input type="radio" name="gender" value="F">
                                <span class="gender-label">
                                    <i class="bi bi-gender-female"></i>
                                    여성
                                </span>
                            </label>
                            <label class="gender-option">
                                <input type="radio" name="gender" value="">
                                <span class="gender-label">
                                    <i class="bi bi-dash"></i>
                                    기타
                                </span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- 기업회원 전용 필드 -->
                <div id="businessFields" style="display: none;">
                    <hr class="my-4">
                    <h5 class="mb-3"><i class="bi bi-building me-2"></i>기업 정보</h5>

                    <!-- 회사명 -->
                    <div class="form-group">
                        <label class="form-label">회사명 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="companyName" id="companyName"
                               placeholder="회사명을 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>회사명을 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 사업자등록번호 -->
                    <div class="form-group">
                        <label class="form-label">사업자등록번호 <span class="text-danger">*</span></label>
                        <div class="input-with-btn">
                            <input type="text" class="form-control" name="businessNo" id="businessNo"
                                   placeholder="'-' 없이 숫자만 입력하세요" maxlength="10">
                            <button type="button" class="btn btn-outline" onclick="verifyBusinessNo()">
                                확인
                            </button>
                        </div>
                        <div class="form-hint">예: 1234567890 (10자리)</div>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>사업자등록번호를 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 사업자등록증 파일 업로드 -->
                    <div class="form-group">
                        <label class="form-label">사업자등록증 <span class="text-danger">*</span></label>
                        <div class="file-upload-wrapper">
                            <input type="file" class="form-control" name="businessLicense" id="businessLicense"
                                   accept=".pdf,.jpg,.jpeg,.png">
                            <div class="form-hint">PDF, JPG, PNG 파일만 업로드 가능합니다. (최대 10MB)</div>
                        </div>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>사업자등록증을 업로드해주세요.</span>
                        </div>
                    </div>

                    <!-- 사업주명 -->
                    <div class="form-group">
                        <label class="form-label">사업주명 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="ceoName" id="ceoName"
                               placeholder="대표자명을 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>사업주명을 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 통신판매업 신고번호 -->
                    <div class="form-group">
                        <label class="form-label">통신판매업 신고번호 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="ecommerceNo" id="ecommerceNo"
                               placeholder="예: 제2024-서울강남-00000호">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>통신판매업 신고번호를 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 회사 홈페이지 -->
                    <div class="form-group">
                        <label class="form-label">회사 홈페이지 <span class="text-muted">(선택)</span></label>
                        <input type="url" class="form-control" name="companyWebsite" id="companyWebsite"
                               placeholder="예: https://www.example.com">
                        <div class="form-hint">https://를 포함하여 입력해주세요.</div>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>올바른 URL 형식이 아닙니다.</span>
                        </div>
                    </div>

                    <!-- 기업 소개 -->
                    <div class="form-group">
                        <label class="form-label">기업 소개 <span class="text-muted">(선택)</span></label>
                        <textarea class="form-control" name="companyDescription" id="companyDescription"
                                  rows="4" maxlength="1000"
                                  placeholder="기업에 대한 간단한 소개를 입력해주세요. (최대 1000자)"></textarea>
                        <div class="form-hint">고객에게 보여질 기업 소개입니다. 제공하는 서비스, 특장점 등을 작성해주세요.</div>
                    </div>

                    <!-- 회사주소 -->
                    <div class="form-group">
                        <label class="form-label">회사주소 <span class="text-danger">*</span></label>
                        <div class="input-with-btn">
                            <input type="text" class="form-control" name="companyPostcode" id="companyPostcode"
                                   placeholder="우편번호" readonly>
                            <button type="button" class="btn btn-outline" onclick="searchCompanyAddress()">
                                <i class="bi bi-search me-1"></i>주소검색
                            </button>
                        </div>
                        <input type="text" class="form-control mt-2" name="companyAddress" id="companyAddress"
                               placeholder="기본주소" readonly>
                        <input type="text" class="form-control mt-2" name="companyAddressDetail" id="companyAddressDetail"
                               placeholder="상세주소를 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>회사주소를 입력해주세요.</span>
                        </div>
                    </div>

                    <hr class="my-4">
                    <h5 class="mb-3"><i class="bi bi-person-badge me-2"></i>담당자 정보</h5>

                    <!-- 담당자명 -->
                    <div class="form-group">
                        <label class="form-label">담당자명 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="managerName" id="managerName"
                               placeholder="담당자 이름을 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>담당자명을 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 담당자 연락처 -->
                    <div class="form-group">
                        <label class="form-label">담당자 연락처 <span class="text-danger">*</span></label>
                        <input type="tel" class="form-control" name="managerPhone" id="managerPhone"
                               placeholder="'-' 없이 숫자만 입력하세요" maxlength="11">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>올바른 연락처 형식이 아닙니다.</span>
                        </div>
                    </div>

                    <!-- 담당자 이메일 -->
                    <div class="form-group">
                        <label class="form-label">담당자 이메일 <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" name="managerEmail" id="managerEmail"
                               placeholder="이메일 주소를 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>올바른 이메일 형식이 아닙니다.</span>
                        </div>
                    </div>

                    <hr class="my-4">
                    <h5 class="mb-3"><i class="bi bi-bank me-2"></i>정산 계좌 정보</h5>

                    <!-- 은행명 -->
                    <div class="form-group">
                        <label class="form-label">은행명 <span class="text-danger">*</span></label>
                        <select class="form-control" name="bankName" id="bankName">
                            <option value="">은행을 선택하세요</option>
                            <option value="KB국민은행">KB국민은행</option>
                            <option value="신한은행">신한은행</option>
                            <option value="우리은행">우리은행</option>
                            <option value="하나은행">하나은행</option>
                            <option value="SC제일은행">SC제일은행</option>
                            <option value="한국씨티은행">한국씨티은행</option>
                            <option value="케이뱅크">케이뱅크</option>
                            <option value="카카오뱅크">카카오뱅크</option>
                            <option value="토스뱅크">토스뱅크</option>
                            <option value="NH농협은행">NH농협은행</option>
                            <option value="IBK기업은행">IBK기업은행</option>
                            <option value="KDB산업은행">KDB산업은행</option>
                            <option value="수협은행">수협은행</option>
                            <option value="대구은행">대구은행</option>
                            <option value="부산은행">부산은행</option>
                            <option value="경남은행">경남은행</option>
                            <option value="광주은행">광주은행</option>
                            <option value="전북은행">전북은행</option>
                            <option value="제주은행">제주은행</option>
                            <option value="새마을금고">새마을금고</option>
                            <option value="신협">신협</option>
                            <option value="우체국">우체국</option>
                        </select>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>은행을 선택해주세요.</span>
                        </div>
                    </div>

                    <!-- 계좌번호 -->
                    <div class="form-group">
                        <label class="form-label">계좌번호 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="accountNumber" id="accountNumber"
                               placeholder="'-' 없이 숫자만 입력하세요" maxlength="20">
                        <div class="form-hint">정산금 입금에 사용됩니다.</div>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>계좌번호를 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 예금주 -->
                    <div class="form-group">
                        <label class="form-label">예금주 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="accountHolder" id="accountHolder"
                               placeholder="예금주명을 입력하세요">
                        <div class="form-hint">사업자등록증의 대표자명과 동일해야 합니다.</div>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>예금주를 입력해주세요.</span>
                        </div>
                    </div>
                </div>

                <!-- 약관 동의 -->
                <div class="terms-agreement">
                    <div class="terms-all">
                        <label class="terms-check">
                            <input type="checkbox" id="agreeAll" onchange="toggleAllTerms()">
                            <span><strong>전체 약관에 동의합니다</strong></span>
                        </label>
                    </div>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" name="agreeTerms" class="term-checkbox" required>
                            <span>이용약관 동의 <span class="required">(필수)</span></span>
                        </label>
                        <a href="${pageContext.request.contextPath}/terms" target="_blank" class="terms-link">보기</a>
                    </div>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" name="agreePrivacy" class="term-checkbox" required>
                            <span>개인정보처리방침 동의 <span class="required">(필수)</span></span>
                        </label>
                        <a href="${pageContext.request.contextPath}/privacy" target="_blank" class="terms-link">보기</a>
                    </div>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" name="agreeLocation" class="term-checkbox">
                            <span>위치기반서비스 이용약관 동의 (선택)</span>
                        </label>
                        <a href="${pageContext.request.contextPath}/location" target="_blank" class="terms-link">보기</a>
                    </div>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" name="agreeMarketing" class="term-checkbox">
                            <span>마케팅 정보 수신 동의 (선택)</span>
                        </label>
                    </div>
                </div>

                <!-- 가입 버튼 -->
                <button type="submit" class="btn btn-primary btn-submit">
                    회원가입
                </button>
            </form>

            <!-- 로그인 링크 -->
            <div class="auth-footer">
                이미 계정이 있으신가요?
                <a href="${pageContext.request.contextPath}/member/login">로그인</a>
            </div>
        </div>
    </div>
</div>

<!-- 다음 주소 검색 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
// 아이디 중복확인 여부
let isIdChecked = false;

// 회원 유형 변경 시
document.querySelectorAll('input[name="memberType"]').forEach(radio => {
    radio.addEventListener('change', function() {
        const userType = this.value;
        document.getElementById('userType').value = userType;

        if (userType === 'BUSINESS') {
            // 기업회원: 개인 필드 숨기고 기업 필드 표시
            document.getElementById('personalFields').style.display = 'none';
            document.getElementById('businessFields').style.display = 'block';
        } else {
            // 개인회원: 개인 필드 표시하고 기업 필드 숨김
            document.getElementById('personalFields').style.display = 'block';
            document.getElementById('businessFields').style.display = 'none';
        }
    });
});

// 아이디 중복 확인
function checkDuplicateId() {
    const userId = document.getElementById('userId');
    const value = userId.value.trim();

    // 유효성 검사
    if (!value) {
        userId.classList.add('is-invalid');
        document.getElementById('userIdError').textContent = '아이디를 입력해주세요.';
        return;
    }

    // 형식 검사 (영문, 숫자 조합 4~20자)
    const idRegex = /^[a-zA-Z0-9]{4,20}$/;
    if (!idRegex.test(value)) {
        userId.classList.add('is-invalid');
        document.getElementById('userIdError').textContent = '영문, 숫자 조합 4~20자로 입력해주세요.';
        return;
    }

    // API 호출 (실제 구현 시)
    // fetch(`${contextPath}/api/member/check-id?userId=${value}`)
    //     .then(response => response.json())
    //     .then(data => { ... });

    // 임시: 성공 처리
    userId.classList.remove('is-invalid');
    document.getElementById('userIdHint').style.display = 'none';
    document.getElementById('userIdSuccess').style.display = 'flex';
    isIdChecked = true;
    showToast('사용 가능한 아이디입니다.', 'success');
}

// 아이디 입력 시 중복확인 초기화
document.getElementById('userId').addEventListener('input', function() {
    isIdChecked = false;
    document.getElementById('userIdSuccess').style.display = 'none';
    document.getElementById('userIdHint').style.display = 'block';
    this.classList.remove('is-invalid');
});

// 비밀번호 보기/숨기기
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

// 비밀번호 강도 체크
function checkPasswordStrength() {
    const password = document.getElementById('password').value;
    const strengthBar = document.getElementById('strengthBar');
    const strengthText = document.getElementById('strengthText');

    let strength = 0;
    if (password.length >= 8) strength++;
    if (password.match(/[a-z]/)) strength++;
    if (password.match(/[A-Z]/)) strength++;
    if (password.match(/[0-9]/)) strength++;
    if (password.match(/[^a-zA-Z0-9]/)) strength++;

    strengthBar.className = 'strength-bar-fill';

    if (password.length === 0) {
        strengthBar.style.width = '0';
        strengthText.textContent = '영문, 숫자, 특수문자 포함 8자 이상';
    } else if (strength <= 2) {
        strengthBar.classList.add('weak');
        strengthText.textContent = '약함';
    } else if (strength === 3) {
        strengthBar.classList.add('fair');
        strengthText.textContent = '보통';
    } else if (strength === 4) {
        strengthBar.classList.add('good');
        strengthText.textContent = '좋음';
    } else {
        strengthBar.classList.add('strong');
        strengthText.textContent = '매우 강함';
    }

    // 비밀번호 확인도 체크
    checkPasswordMatch();
}

// 비밀번호 일치 확인
function checkPasswordMatch() {
    const password = document.getElementById('password').value;
    const passwordConfirm = document.getElementById('passwordConfirm');
    const confirmValue = passwordConfirm.value;
    const successEl = document.getElementById('passwordMatchSuccess');

    if (confirmValue.length === 0) {
        passwordConfirm.classList.remove('is-invalid');
        successEl.style.display = 'none';
        return;
    }

    if (password === confirmValue) {
        passwordConfirm.classList.remove('is-invalid');
        successEl.style.display = 'flex';
    } else {
        passwordConfirm.classList.add('is-invalid');
        successEl.style.display = 'none';
    }
}

// 주소 검색 (다음 우편번호 API) - 개인회원용
function searchAddress() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 도로명 주소 사용
            let address = data.roadAddress || data.jibunAddress;

            document.getElementById('postcode').value = data.zonecode;
            document.getElementById('address').value = address;
            document.getElementById('addressDetail').focus();

            // 에러 상태 제거
            document.getElementById('postcode').classList.remove('is-invalid');
            document.getElementById('address').classList.remove('is-invalid');
        }
    }).open();
}

// 회사주소 검색 (다음 우편번호 API) - 기업회원용
function searchCompanyAddress() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 도로명 주소 사용
            let address = data.roadAddress || data.jibunAddress;

            document.getElementById('companyPostcode').value = data.zonecode;
            document.getElementById('companyAddress').value = address;
            document.getElementById('companyAddressDetail').focus();

            // 에러 상태 제거
            document.getElementById('companyPostcode').classList.remove('is-invalid');
            document.getElementById('companyAddress').classList.remove('is-invalid');
        }
    }).open();
}

// 전체 약관 동의
function toggleAllTerms() {
    const allCheckbox = document.getElementById('agreeAll');
    const checkboxes = document.querySelectorAll('.term-checkbox');

    checkboxes.forEach(checkbox => {
        checkbox.checked = allCheckbox.checked;
    });
}

// 개별 약관 체크 시 전체동의 상태 업데이트
document.querySelectorAll('.term-checkbox').forEach(checkbox => {
    checkbox.addEventListener('change', function() {
        const allChecked = document.querySelectorAll('.term-checkbox:checked').length ===
                          document.querySelectorAll('.term-checkbox').length;
        document.getElementById('agreeAll').checked = allChecked;
    });
});

// 사업자등록번호 확인
function verifyBusinessNo() {
    const businessNo = document.getElementById('businessNo').value;

    if (!businessNo || businessNo.length !== 10) {
        showToast('사업자등록번호 10자리를 입력해주세요.', 'error');
        return;
    }

    // API 호출 (실제 구현 시)
    showToast('유효한 사업자등록번호입니다.', 'success');
}

// 생년월일 날짜 선택기 초기화
document.addEventListener('DOMContentLoaded', function() {
    const birthInput = document.querySelector('.date-picker-birth');
    if (birthInput && typeof flatpickr !== 'undefined') {
        flatpickr(birthInput, {
            locale: 'ko',
            dateFormat: 'Y-m-d',
            maxDate: 'today',
            defaultDate: '1990-01-01',
            disableMobile: true
        });
    }
});

// 전화번호 자동 포맷 - 개인회원
const phoneInput = document.getElementById('phone');
if (phoneInput) {
    phoneInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });
}

// 전화번호 자동 포맷 - 담당자
const managerPhoneInput = document.getElementById('managerPhone');
if (managerPhoneInput) {
    managerPhoneInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });
}

// 사업자등록번호 자동 포맷
const businessNoInput = document.getElementById('businessNo');
if (businessNoInput) {
    businessNoInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });
}

// 계좌번호 자동 포맷 (숫자만)
const accountNumberInput = document.getElementById('accountNumber');
if (accountNumberInput) {
    accountNumberInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });
}

// 폼 제출 전 유효성 검사
document.getElementById('registerForm').addEventListener('submit', function(e) {
    let isValid = true;
    const userType = document.getElementById('userType').value;
    const userId = document.getElementById('userId');
    const password = document.getElementById('password');
    const passwordConfirm = document.getElementById('passwordConfirm');

    // 공통 검사: 아이디 중복확인
    if (!isIdChecked) {
        userId.classList.add('is-invalid');
        document.getElementById('userIdError').textContent = '아이디 중복확인을 해주세요.';
        isValid = false;
    }

    // 공통 검사: 비밀번호 길이
    if (password.value.length < 8) {
        password.classList.add('is-invalid');
        isValid = false;
    }

    // 공통 검사: 비밀번호 일치
    if (password.value !== passwordConfirm.value) {
        passwordConfirm.classList.add('is-invalid');
        isValid = false;
    }

    // 회원 유형별 검사
    if (userType === 'GENERAL') {
        // 개인회원 필수 필드 검사
        const userName = document.getElementById('userName');
        const nickname = document.getElementById('nickname');
        const postcode = document.getElementById('postcode');
        const phone = document.getElementById('phone');
        const email = document.getElementById('email');
        const birthDate = document.getElementById('birthDate');

        if (!userName.value.trim()) {
            userName.classList.add('is-invalid');
            isValid = false;
        }

        if (!nickname.value.trim() || nickname.value.length < 2 || nickname.value.length > 10) {
            nickname.classList.add('is-invalid');
            isValid = false;
        }

        if (!postcode.value) {
            postcode.classList.add('is-invalid');
            isValid = false;
        }

        const phoneRegex = /^01[0-9]{8,9}$/;
        if (!phoneRegex.test(phone.value)) {
            phone.classList.add('is-invalid');
            isValid = false;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email.value)) {
            email.classList.add('is-invalid');
            isValid = false;
        }

        if (!birthDate.value) {
            birthDate.classList.add('is-invalid');
            isValid = false;
        }
    } else {
        // 기업회원 필수 필드 검사
        const companyName = document.getElementById('companyName');
        const businessNo = document.getElementById('businessNo');
        const businessLicense = document.getElementById('businessLicense');
        const ceoName = document.getElementById('ceoName');
        const ecommerceNo = document.getElementById('ecommerceNo');
        const companyPostcode = document.getElementById('companyPostcode');
        const managerName = document.getElementById('managerName');
        const managerPhone = document.getElementById('managerPhone');
        const managerEmail = document.getElementById('managerEmail');
        const bankName = document.getElementById('bankName');
        const accountNumber = document.getElementById('accountNumber');
        const accountHolder = document.getElementById('accountHolder');

        // 회사명
        if (!companyName.value.trim()) {
            companyName.classList.add('is-invalid');
            isValid = false;
        }

        // 사업자등록번호
        if (!businessNo.value || businessNo.value.length !== 10) {
            businessNo.classList.add('is-invalid');
            isValid = false;
        }

        // 사업자등록증 파일
        if (!businessLicense.files || businessLicense.files.length === 0) {
            businessLicense.classList.add('is-invalid');
            isValid = false;
        }

        // 사업주명
        if (!ceoName.value.trim()) {
            ceoName.classList.add('is-invalid');
            isValid = false;
        }

        // 통신판매업 신고번호
        if (!ecommerceNo.value.trim()) {
            ecommerceNo.classList.add('is-invalid');
            isValid = false;
        }

        // 회사주소
        if (!companyPostcode.value) {
            companyPostcode.classList.add('is-invalid');
            isValid = false;
        }

        // 담당자명
        if (!managerName.value.trim()) {
            managerName.classList.add('is-invalid');
            isValid = false;
        }

        // 담당자 연락처
        const phoneRegex = /^01[0-9]{8,9}$/;
        if (!phoneRegex.test(managerPhone.value)) {
            managerPhone.classList.add('is-invalid');
            isValid = false;
        }

        // 담당자 이메일
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(managerEmail.value)) {
            managerEmail.classList.add('is-invalid');
            isValid = false;
        }

        // 은행명
        if (!bankName.value) {
            bankName.classList.add('is-invalid');
            isValid = false;
        }

        // 계좌번호
        if (!accountNumber.value.trim() || accountNumber.value.length < 10) {
            accountNumber.classList.add('is-invalid');
            isValid = false;
        }

        // 예금주
        if (!accountHolder.value.trim()) {
            accountHolder.classList.add('is-invalid');
            isValid = false;
        }
    }

    if (!isValid) {
        e.preventDefault();
        showToast('입력 정보를 확인해주세요.', 'error');

        // 첫 번째 에러 필드로 스크롤
        const firstInvalid = document.querySelector('.is-invalid');
        if (firstInvalid) {
            firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
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
