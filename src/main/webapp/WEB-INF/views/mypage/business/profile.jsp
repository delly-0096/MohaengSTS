<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="회원 정보 수정" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../../common/header.jsp" %>

<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<div class="mypage business-mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>회원 정보 수정</h1>
                    <p>담당자 정보 및 비밀번호를 수정할 수 있습니다</p>
                </div>
				
                    <form class="profile-form" id="businessProfileForm" style="max-width: 100%;" action="${pageContext.request.contextPath}/mypage/profile/update" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="profileImageDeleted" id="profileImageDeleted" value="false">
		                    <!-- 프로필 이미지 섹션 -->
		                    <div class="content-section">
							    <div class="profile-top-layout">
							        <div class="profile-left-part">
							            <h5 class="form-section-title"><i class="bi bi-image me-2 text-brand"></i>프로필 이미지</h5>
							            <div class="profile-image-upload">
							                <div id="profileContainer" class="profile-image-preview-container">
							                    <i class="bi bi-person profile-default-icon" style="${not empty profileImgUrl ? 'display:none;' : ''}"></i>
							                    <img id="profilePreview" class="profile-image-preview" src="<c:url value='/upload${profileImgUrl}' />" 
							                         style="${not empty profileImgUrl ? '' : 'display:none;'}" alt="로고 프로필 이미지">
							                </div>
							                <div class="profile-image-actions">
							                    <input type="file" name="profileImage" id="profileImage" accept="image/*" hidden>
							                    <button type="button" class="btn btn-outline btn-sm" onclick="document.getElementById('profileImage').click()">
							                        <i class="bi bi-camera me-2"></i>로고 이미지 변경
							                    </button>
							                    <button type="button" class="btn btn-outline btn-sm" onclick="resetProfileImage()">
							                        <i class="bi bi-trash me-2"></i>로고 이미지 삭제
							                    </button>
							                    <p class="form-hint mt-2 mb-0">권장 크기: 200x200px (최대 2MB)</p>
							                </div>
							            </div>
							        </div>
							        
							<!-- 알림 설정 섹션 -->
							        <div class="profile-right-part">
							            <h5 class="form-section-title"><i class="bi bi-bell me-2 text-brand"></i>알림 설정</h5>
							            <div class="notification-list compact-grid">
							                <div class="notification-item">
							                    <label for="notifyReservation" for="notifyOrder">새 예약 알림</label>
							                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifyOrder" id="notifyOrder" checked></div>
							                </div>
							                <div class="notification-item">
							                    <label for="notifySchedule" for="notifyReview">새 후기 알림</label>
							                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifyReview" id="notifyReview" checked></div>
							                </div>
							                <div class="notification-item">
							                    <label for="notifyCommunity" for="notifyInquiry">문의 알림</label>
							                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifyInquiry" id="notifyCommunnotifyInquiryity" checked></div>
							                </div>
							                <div class="notification-item">
							                    <label for="notifyPoint" for="notifySettlement">정산 완료 알림</label>
							                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifySettlement" id="notifySettlement"></div>
							                </div>
							                <div class="notification-item">
							                    <label for="notifyInquiry" for="notifyMarketing">마케팅 정보 수신</label>
							                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifyMarketing" id="notifyMarketing" checked></div>
							                </div>
							            </div>
							        </div>
							    </div>
							</div>
							
							<!-- 기업 정보 -->
							<div class="content-section company-info-card">
							    <div class="row g-5">
							        <div class="col-lg-6 pe-lg-5 border-end">
										<h5 class="form-section-title mb-4">
										        <i class="bi bi-building-check text-brand"></i> 기업 기본 정보
							            </h5>
							            
							            <div class="form-group">
							                <label class="form-label">기업명</label>
							                <div class="field-base readonly-field">
							                    <i class="bi bi-lock-fill me-2 small"></i> ${member.company.bzmnNm}
							                </div>
							            </div>
							
							            <div class="row">
							                <div class="col-6">
							                    <div class="form-group">
							                        <label class="form-label">사업자번호</label>
							                        <div class="field-base readonly-field">${member.company.brno}</div>
							                    </div>
							                </div>
							                <div class="col-6">
							                    <div class="form-group">
							                        <label class="form-label">업종</label>
							                        <div class="field-base readonly-field">${member.company.industryCd}</div>
							                    </div>
							                </div>
							            </div>
							
							            <div class="form-group">
							                <label class="form-label">사업장 주소</label>
							                <div class="field-base readonly-field address-display">
							                    <div class="fw-bold text-dark">${member.company.compAddr1}</div>
							                    <div class="small">${member.company.compAddr2} (${member.company.compZip})</div>
							                </div>
							                <small class="text-muted mt-2 d-block"><i class="bi bi-info-circle me-1"></i> 주소 변경은 고객센터로 문의하세요.</small>
							            </div>
							            
							            <div class="form-group">
							                <label class="form-label">기업 대표 전화</label>
							                <div class="field-base readonly-field">
							                    <i class="bi bi-telephone me-2 small"></i> ${member.company.compTel}
							                </div>
							                <small class="text-muted mt-2 d-block">대표 번호 변경은 관리자 승인이 필요합니다.</small>
							            </div>

							
							        </div>
							
									<!-- 기업 담당자 정보  -->
							        <div class="col-lg-6 ps-lg-5">
										<h5 class="form-section-title mb-4">
										        <i class="bi bi-person-gear text-brand"></i>담당자 설정
										</h5>
							
							            <div class="form-group">
							                <label class="form-label">담당자 이름 <span class="text-danger ms-1">*</span></label>
							                <div class="field-base editable-input-container">
							                    <input type="text" class="form-control" name="memName" id="managerName" value="${member.memName}" required>
							                </div>
							            </div>
							
							            <div class="form-group">
							                <label class="form-label">비즈니스 이메일 <span class="text-danger ms-1">*</span></label>
							                <div class="field-base editable-input-container d-flex">
							                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
							                    <input type="email" class="form-control border-0" name="memEmail" id="managerEmail" value="${member.memEmail}" required>
							                </div>
							            </div>
							
							            <div class="form-group">
							                <label class="form-label">담당자 연락처 <span class="text-danger ms-1">*</span></label>
							                <div class="field-base editable-input-container d-flex">
							                    <span class="input-group-text"><i class="bi bi-phone"></i></span>
							                    <input type="tel" class="form-control border-0" name="memCompTel" id="managerPhone" value="${member.memComp.memCompTel}" required>
							                </div>
							            </div>
							            
							            <div class="form-group">
							                <label class="form-label">기업 홈페이지 주소 (선택)</label>
							                <div class="field-base editable-input-container d-flex">
							                    <span class="input-group-text"><i class="bi bi-link-45deg"></i></span>
							                    <input type="text" class="form-control border-0" name="compUrl" id="companyWebsite" value="${member.company.compUrl}" placeholder="예) http://www.mohaeng.com">
							                </div>
							            </div>
							            
							            <div class="form-group">
							                <label class="form-label">기업 소개 (선택)</label>
							                <div class="editable-input-container rounded-3">
							                    <textarea class="form-control" id="companyIntro" name="compIntro" rows="5" maxlength="1000" placeholder="기업을 소개해주세요.">${member.company.compIntro}</textarea>
							                </div>
							                <div class="text-end mt-1">
							                    <small class="text-muted"><span id="charCount">0</span> / 1000자</small>
							                </div>
							            </div>
							        </div>
							    </div>
							</div>
                    
                    <!-- 정산 정보 (읽기전용) -->
                    <div class="content-section">
                        <h5 class="form-section-title"><i class="bi bi-bank me-2 text-brand"></i>정산 정보</h5>
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">은행</label>
                                    <input type="text" class="form-control" name="bankCd" id="bankCd" value="${member.company.bankCd}" readonly disabled>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">계좌번호</label>
                                    <input type="text" class="form-control" name="accountNo" id="accountNo" value="${member.company.accountNo}" readonly disabled>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">예금주</label>
                                    <input type="text" class="form-control" name="depositor" id="depositor" value="${member.company.depositor}" readonly disabled>
                                </div>
                            </div>
                            <div class="col-12">
                                <small class="text-muted"><i class="bi bi-info-circle me-1"></i>정산 정보 변경은 고객센터로 문의해주세요.</small>
                            </div>
                        </div>
					</div>
					
                     <!-- 비밀번호 확인 섹션 -->
                    <div class="content-section">
                        <h5 class="form-section-title"><i class="bi bi-lock me-2 text-brand"></i>비밀번호 확인</h5>
                        <p class="text-muted mb-3">회원정보 수정을 위해 현재 비밀번호를 입력해주세요. 비밀번호 변경을 원하시면 새 비밀번호도 입력하세요.</p>

                        <div class="row">
                            <!-- 현재 비밀번호 -->
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">현재 비밀번호 <span class="text-danger">*</span></label>
                                    <div class="password-toggle">
                                        <input type="password" class="form-control" name="currentPassword" id="currentPassword"
                                               placeholder="현재 비밀번호를 입력하세요">
                                        <span class="toggle-btn" onclick="togglePassword('currentPassword')">
                                            <i class="bi bi-eye"></i>
                                        </span>
                                    </div>
                                    <div class="form-hint">본인 확인을 위해 필수 입력 항목입니다.</div>
                                    <div class="form-error">
                                        <i class="bi bi-exclamation-circle"></i>
                                        <span>현재 비밀번호를 입력해주세요.</span>
                                    </div>
                                </div>
                            </div>

                            <!-- 새 비밀번호 -->
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">새 비밀번호 <span class="text-muted">(선택)</span></label>
                                    <div class="password-toggle">
                                        <input type="password" class="form-control" name="newPassword" id="newPassword"
                                               placeholder="변경 시에만 입력하세요">
                                        <span class="toggle-btn" onclick="togglePassword('newPassword')">
                                            <i class="bi bi-eye"></i>
                                        </span>
                                    </div>
                                    <div class="password-strength">
                                        <div class="strength-bar">
                                            <div class="strength-bar-fill" id="strengthBar"></div>
                                        </div>
                                        <span class="strength-text" id="strengthText">영문, 숫자, 특수문자 포함 8자 이상</span>
                                    </div>
                                    <div class="form-error" id="passwordError" style="display:none;">
                                        <i class="bi bi-exclamation-circle"></i>
                                        <span>비밀번호는 영문, 숫자, 특수문자를 포함해 8자 이상이어야 합니다.</span>
                                    </div>
                                </div>
                            </div>

                            <!-- 새 비밀번호 확인 -->
                            <div class="col-md-4">
                                <div class="form-group mb-0">
                                    <label class="form-label">새 비밀번호 확인</label>
                                    <div class="password-toggle">
                                        <input type="password" class="form-control" name="confirmPassword" id="confirmPassword"
                                               placeholder="새 비밀번호를 다시 입력하세요">
                                        <span class="toggle-btn" onclick="togglePassword('confirmPassword')">
                                            <i class="bi bi-eye"></i>
                                        </span>
                                    </div>
                                    <div class="form-error" id="passwordMatchError" style="display:none;">
                                        <i class="bi bi-exclamation-circle"></i>
                                        <span>비밀번호가 일치하지 않습니다.</span>
                                    </div>
                                    <div class="form-success" id="passwordMatchSuccess" style="display: none;">
                                        <i class="bi bi-check-circle"></i>
                                        <span>비밀번호가 일치합니다.</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
					
					<!-- 마케팅 수신 동의 섹션 -->
                    <div class="content-section">
                        <h5 class="form-section-title"><i class="bi bi-megaphone me-2 text-brand"></i>마케팅 수신 동의</h5>
                        <p class="text-muted mb-3"> 기업 회원만의 유용한 소식을 받아보세요.</p>

                        <div class="marketing-options">
                            <div class="marketing-option">
                                <label class="marketing-check">
                                    <input type="checkbox" name="agreeEmailMarketing" id="agreeEmailMarketing">
                                    <span class="marketing-label">
                                        <i class="bi bi-envelope me-2"></i>
                                        이메일 수신 동의
                                    </span>
                                </label>
                            </div>
                            <div class="marketing-option">
                                <label class="marketing-check">
                                    <input type="checkbox" name="agreeSmsMarketing" id="agreeSmsMarketing">
                                    <span class="marketing-label">
                                        <i class="bi bi-chat-dots me-2"></i>
                                        SMS 수신 동의
                                    </span>
                                </label>
                            </div>
                            <div class="marketing-option">
                                <label class="marketing-check">
                                    <input type="checkbox" name="agreePushMarketing" id="agreePushMarketing">
                                    <span class="marketing-label">
                                        <i class="bi bi-bell me-2"></i>
                                        푸시 알림 수신 동의
                                    </span>
                                </label>
                            </div>
                        </div>
                    </div>
					
						<!-- 버튼 영역 -->
                    <div class="form-actions">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="bi bi-check-lg me-2"></i>저장하기
                            </button>
                            <button type="button" class="btn btn-outline btn-lg" onclick="history.back()">
                                취소
                            </button>
                        </div>
                    </form>

                <!-- 안내 메시지 -->
                <div class="content-section info-section">
				    <div class="info-flex-container">
				        <div class="info-text">
				            <h5 class="form-section-title text-info">
				                <i class="bi bi-info-circle me-2"></i>기업 정보 변경 안내
				            </h5>
				            <p class="text-muted mb-0">
				                기업명, 사업자등록번호, 주소, 정산 정보 등 주요 정보 변경은<br>
				                고객센터(1588-0000) 또는 1:1 문의를 이용해주세요.
				            </p>
				        </div>
				        <div class="info-action">
				            <button type="button" class="btn btn-outline-info btn-sm" onclick="location.href='${pageContext.request.contextPath}/support/inquiry'">
				                <i class="bi bi-headset me-2"></i>1:1 문의하기
				            </button>
				        </div>
				    </div>
				</div>
            </div>
        </div>
    </div>
</div>

<style>
/* 읽기전용 섹션 스타일 */
.readonly-section {
    opacity: 0.8;
}

input[readonly], input[disabled] {
    background-color: #f8fafc !important;
    cursor: not-allowed;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log("Member Update Script Initialized");
    
 // 비밀번호 로직 선언
    const newPw = document.getElementById('newPassword');
    const confirmPw = document.getElementById('confirmPassword');

    newPw.addEventListener('input', checkPasswordStrength);
    confirmPw.addEventListener('input', () => checkPasswordMatch(false));
    confirmPw.addEventListener('blur', () => checkPasswordMatch(true));

    // 비밀번호 보기/숨기기
    function togglePassword(inputId) {
    	const input = document.getElementById(inputId);
        if (!input) return;

        const wrapper = input.closest('.password-toggle');
        const icon = wrapper?.querySelector('.toggle-btn i');
        if (!icon) return;

        if (input.type === 'password') {
            input.type = 'text';
            icon.className = 'bi bi-eye-slash';
        } else {
            input.type = 'password';
            icon.className = 'bi bi-eye';
        }
    }
    
    window.togglePassword = togglePassword;

    // 비밀번호 강도 체크
    function checkPasswordStrength() {
        const password = newPw.value;
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');
        
        document.getElementById('passwordError').style.display = 'none';
        newPw.classList.remove('is-invalid');

        let strength = 0;
        if (password.length >= 8) strength++;
        if (password.match(/[a-z]/)) strength++;
        if (password.match(/[A-Z]/)) strength++;
        if (password.match(/[0-9]/)) strength++;
        if (password.match(/[^a-zA-Z0-9]/)) strength++;

        strengthBar.className = 'strength-bar-fill';
        
        if (!password) {
            strengthBar.style.width = '0%';
            strengthText.textContent = '대소문자 영문, 숫자, 특수문자 포함 8자 이상';
            confirmPw.value = '';
            return;
        }

        if (password.length === 0) {
            strengthBar.style.width = '0%';
            strengthText.textContent = '대소문자 영문, 숫자, 특수문자 포함 8자 이상';
        } else if (strength <= 2) {
            strengthBar.classList.add('weak');
        	strengthBar.style.width = '25%';
            strengthText.textContent = '약함';
        } else if (strength === 3) {
            strengthBar.classList.add('fair');
            strengthBar.style.width = '50%';
            strengthText.textContent = '보통';
        } else if (strength === 4) {
            strengthBar.classList.add('good');
            strengthBar.style.width = '75%';
            strengthText.textContent = '좋음';
        } else {
            strengthBar.classList.add('strong');
            strengthBar.style.width = '100%';
            strengthText.textContent = '매우 강함';
        }

        // 비밀번호 확인도 체크
        checkPasswordMatch();
    }

    //비밀번호 길이 체크
    function isValidPassword(password) {
        return (
            password.length >= 8 &&
            /[a-zA-Z]/.test(password) &&
            /[0-9]/.test(password) &&
            /[^a-zA-Z0-9]/.test(password)
        );
    }

    // 비밀번호 일치 확인
    function checkPasswordMatch(force = false) {
        const password = document.getElementById('newPassword').value;
        const passwordConfirm = document.getElementById('confirmPassword');
        const confirmValue = passwordConfirm.value;
        
        const successEl = document.getElementById('passwordMatchSuccess');
        const errorEl = document.getElementById('passwordMatchError');

        // 아무것도 안 쳤으면 전부 숨김
        if (confirmValue.length === 0) {
            passwordConfirm.classList.remove('is-invalid');
            successEl.style.display = 'none';
            errorEl.style.display = 'none';
            return;
        }

     	// 타이핑 중 (keyup)
     	if (!force) {
    	    if (password === confirmValue) {
                successEl.style.display = 'flex';
                errorEl.style.display = 'none';
                passwordConfirm.classList.remove('is-invalid');
    	    } else {
                // 타이핑 중엔 실패 문구 안 띄움
                successEl.style.display = 'none';
                errorEl.style.display = 'none';
                passwordConfirm.classList.remove('is-invalid');
    	    }
    	    return;
     	}
     	
     	// blur 시점
        if (password === confirmValue) {
            successEl.style.display = 'flex';
            errorEl.style.display = 'none';
            passwordConfirm.classList.remove('is-invalid');
        } else {
            successEl.style.display = 'none';
            errorEl.style.display = 'flex';
            passwordConfirm.classList.add('is-invalid');
        }
    }

    document.getElementById('newPassword').addEventListener('blur', () => {

        const pwInput = document.getElementById('newPassword');
        if (!pwInput) return;

        const password = pwInput.value || '';
        const errorEl = document.getElementById('passwordError');

        if (!pwInput.value) return;

        if (!isValidPassword(pwInput.value)) {
            pwInput.classList.add('is-invalid');
            errorEl.style.display = 'flex';
        } else {
            pwInput.classList.remove('is-invalid');
            errorEl.style.display = 'none';
        }
    });

    // 전화번호 숫자만 입력 (HTML의 id가 managerPhone인지 memCompTel인지 확인 후 둘 다 대응)
    const phoneInput = document.getElementById('managerPhone') || document.getElementById('memCompTel');
    if (phoneInput) {
        phoneInput.addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    }

    // 폼 제출 핸들러
    const profileForm = document.getElementById('businessProfileForm');
    if (profileForm) {
        profileForm.addEventListener('submit', function(e) {
            e.preventDefault(); // 기본 제출 방지

            const form = this;
            const currentPasswordInput = document.getElementById('currentPassword');
            const currentPassword = currentPasswordInput ? currentPasswordInput.value : '';

            // --- [유효성 검사 시작] ---

            // 현재 비밀번호 체크
            if (!currentPassword) {
                showToast('현재 비밀번호를 입력해주세요.', 'error');
                if(currentPasswordInput) {
                    currentPasswordInput.classList.add('is-invalid');
                    currentPasswordInput.focus();
                }
                return;
            }

            // 담당자명 체크 (id="managerName")
            const managerName = document.getElementById('managerName');
            if (managerName && !managerName.value.trim()) {
                showToast('담당자명을 입력해주세요.', 'error');
                managerName.focus();
                return;
            }

            // 담당자 이메일 체크 (id="managerEmail")
            const managerEmail = document.getElementById('managerEmail');
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (managerEmail && (!managerEmail.value.trim() || !emailRegex.test(managerEmail.value))) {
                showToast('올바른 이메일 주소를 입력해주세요.', 'error');
                managerEmail.focus();
                return;
            }

            // 회사 홈페이지 URL 체크 (선택 사항으로 변경)
            const companyWebsite = document.getElementById('companyWebsite');
            if (companyWebsite && companyWebsite.value.trim()) {
                // 값이 있을 때만 정규식 체크 실행
                const urlRegex = /^https?:\/\/.+/;
                if (!urlRegex.test(companyWebsite.value.trim())) {
                    showToast('올바른 홈페이지 URL을 입력해주세요. (https://...)', 'error');
                    companyWebsite.focus();
                    return;
                }
            }

            // 새 비밀번호 체크
            const newPw = document.getElementById('newPassword');
            const confirmPw = document.getElementById('confirmPassword');
            if (newPw && confirmPw && (newPw.value || confirmPw.value)) {
                if (newPw.value.length < 8) {
                    showToast('새 비밀번호는 8자 이상이어야 합니다.', 'error');
                    newPw.focus();
                    return;
                }
                if (newPw.value !== confirmPw.value) {
                    showToast('새 비밀번호가 일치하지 않습니다.', 'error');
                    confirmPw.focus();
                    return;
                }
            }

            // --- [서버 통신: 비밀번호 확인] ---
            const csrfToken = "${_csrf.token}";
            const csrfHeader = "${_csrf.headerName}" || "X-CSRF-TOKEN";

			console.log("CSRF Header:", csrfHeader);
			console.log("CSRF Token:", csrfToken);

			if (!csrfHeader || csrfHeader === "") {
			    console.error("CSRF 헤더 이름이 비어있습니다. Spring Security 설정을 확인하세요.");
			}

            fetch('${pageContext.request.contextPath}/mypage/profile/checkPassword', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    // 변수명 주위에 대괄호 [ ] 가 있어야 동적으로 헤더 이름이 할당됩니다.
                    [csrfHeader]: csrfToken
                },
                body: 'currentPassword=' + encodeURIComponent(currentPassword)
            })
            .then(response => {
                if (!response.ok) throw new Error('서버 응답 오류');
                return response.json();
            })
            .then(isMatched => {
                if (isMatched === true) {
                    // 모든 검증 통과 시 실제 제출
                    console.log("비밀번호 일치 - 폼 제출 실행");
                    form.submit();
                } else {
                	showToast('현재 비밀번호가 일치하지 않습니다.', 'error');
                    if(currentPasswordInput) currentPasswordInput.focus();
                }
            })
            .catch(error => {
                console.error('CheckPassword Error:', error);
                showToast('비밀번호 확인 중 오류가 발생했습니다.', 'error');
            });
        });
    }

    // 3. 프로필 이미지 미리보기
    const profileImageInput = document.getElementById('profileImage');
    if (profileImageInput) {
        profileImageInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (!file) return;
            
            const deletedFlag = document.getElementById('profileImageDeleted');
            if(deletedFlag) deletedFlag.value = 'false';

            if (file.size > 5 * 1024 * 1024) {
                showToast('이미지 크기는 5MB 이하만 가능합니다.', 'error');
                this.value = '';
                return;
            }

            if (!file.type.startsWith('image/')) {
                showToast('이미지 파일만 업로드 가능합니다.', 'error');
                this.value = '';
                return;
            }

            const reader = new FileReader();
            reader.onload = function(evt) {
                const img = document.getElementById('profilePreview');
                const icon = document.querySelector('.profile-default-icon');
                if(img) {
                    img.src = evt.target.result;
                    img.style.display = 'block';
                }
                if(icon) icon.style.display = 'none';
            };
            reader.readAsDataURL(file);
        });
    }

    // 사업자 번호 자동 하이픈
    const bizInput = document.getElementById('brno');
    if(bizInput) {
        bizInput.addEventListener('input', (e) => {
            let val = e.target.value.replace(/[^0-9]/g, '');
            if (val.length <= 3) e.target.value = val;
            else if (val.length <= 5) e.target.value = val.slice(0, 3) + '-' + val.slice(3);
            else e.target.value = val.slice(0, 3) + '-' + val.slice(3, 5) + '-' + val.slice(5, 10);
        });
    }
    
    // 기업 소개 글자수 
    const textarea = document.getElementById('companyIntro');
    const counter = document.getElementById('charCount');
    const maxLength = textarea.getAttribute('maxlength');

    // 초기 값 반영 (기존 데이터 있을 때)
    counter.textContent = textarea.value.length;

    textarea.addEventListener('input', () => {
        const length = textarea.value.length;
        counter.textContent = length;

        // 선택: 글자 수 임계치 UX
        if (length >= maxLength * 0.9) {
            counter.style.color = '#dc3545'; // 빨강 (거의 찼을 때)
        } else if (length >= maxLength * 0.7) {
            counter.style.color = '#f59e0b'; // 주황 (경고)
        } else {
            counter.style.color = ''; // 기본
        }
    });
});

// 이미지 리셋 (전역 함수 - HTML onclick 대응)
function resetProfileImage() {
    const img = document.getElementById('profilePreview');
    const icon = document.querySelector('.profile-default-icon');
    const fileInput = document.getElementById('profileImage');
    const deletedFlag = document.getElementById('profileImageDeleted');

    if(img) { img.src = ''; img.style.display = 'none'; }
    if(icon) icon.style.display = 'block';
    if(fileInput) fileInput.value = '';
    if(deletedFlag) deletedFlag.value = 'true';

    showToast('기본 아이콘으로 변경되었습니다.', 'info');
}
</script>

<c:if test="${not empty successMessage}">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            showToast("${successMessage}", "success");
        });
    </script>
</c:if>
<c:set var="pageJs" value="mypage" />
<%@ include file="../../common/footer.jsp" %>
