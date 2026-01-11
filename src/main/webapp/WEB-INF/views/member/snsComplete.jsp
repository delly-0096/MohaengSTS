<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<c:set var="pageTitle" value="회원 정보 수정" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../common/header.jsp" %>

<div class="mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>회원 정보 수정</h1>
                    <p>개인정보를 안전하게 관리하세요</p>
                </div>

                <form class="profile-edit-form" id="profileForm" action="${pageContext.request.contextPath}/member/sns/complete" method="POST" enctype="multipart/form-data">
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
					                         style="${not empty profileImgUrl ? '' : 'display:none;'}" alt="프로필 이미지">
					                </div>
					                <div class="profile-image-actions">
					                    <input type="file" name="profileImage" id="profileImage" accept="image/*" hidden>
					                    <button type="button" class="btn btn-outline btn-sm" onclick="document.getElementById('profileImage').click()">
					                        <i class="bi bi-camera me-2"></i>프로필 변경
					                    </button>
					                    <button type="button" class="btn btn-outline btn-sm" onclick="resetProfileImage()">
					                        <i class="bi bi-trash me-2"></i>프로필 삭제
					                    </button>
					                    <p class="form-hint mt-2 mb-0">JPG, PNG 파일 (최대 5MB)</p>
					                </div>
					            </div>
					        </div>
					        
					<!-- 알림 설정 섹션 -->
					        <div class="profile-right-part">
					            <h5 class="form-section-title"><i class="bi bi-bell me-2 text-brand"></i>알림 설정</h5>
					            <div class="notification-list compact-grid">
					                <div class="notification-item">
					                    <label for="notifyReservation">예약 확정/취소</label>
					                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifyReservation" id="notifyReservation" checked></div>
					                </div>
					                <div class="notification-item">
					                    <label for="notifySchedule">여행 일정 리마인드</label>
					                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifySchedule" id="notifySchedule" checked></div>
					                </div>
					                <div class="notification-item">
					                    <label for="notifyCommunity">커뮤니티 댓글/답글</label>
					                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifyCommunity" id="notifyCommunity" checked></div>
					                </div>
					                <div class="notification-item">
					                    <label for="notifyPoint">포인트 적립/사용</label>
					                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifyPoint" id="notifyPoint"></div>
					                </div>
					                <div class="notification-item">
					                    <label for="notifyInquiry">1:1 문의 답변</label>
					                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifyInquiry" id="notifyInquiry" checked></div>
					                </div>
					            </div>
					        </div>
					    </div>
					</div>
	                    
                    <!-- 기본 정보 섹션 -->
                    <div class="content-section">
                        <h5 class="form-section-title"><i class="bi bi-person me-2 text-brand"></i>기본 정보</h5>

                        <div class="row">
                            <!-- 아이디 (읽기전용) -->
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">아이디</label>
                                    <input type="text" class="form-control" value="${member.memId}" readonly disabled>
                                    <div class="form-hint">아이디는 변경할 수 없습니다.</div>
                                </div>
                            </div>

                            <!-- 이메일 -->
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">이메일 <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" name="memEmail" id="email"
                                           value="${member.memEmail}" placeholder="이메일을 입력하세요" required>
                                    <div class="form-hint">알림 및 비밀번호 찾기에 사용됩니다.</div>
                                    <div class="form-error">
                                        <i class="bi bi-exclamation-circle"></i>
                                        <span>올바른 이메일 형식이 아닙니다.</span>
                                    </div>
                                </div>
                            </div>

                            <!-- 이름 -->
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">이름 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="memName" id="userName"
                                           value="${member.memName}" placeholder="이름을 입력하세요">
                                    <div class="form-error">
                                        <i class="bi bi-exclamation-circle"></i>
                                        <span>이름을 입력해주세요.</span>
                                    </div>
                                </div>
                            </div>

                            <!-- 닉네임 -->
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">닉네임 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="nickname" id="nickname"
                                           value="${member.memUser.nickname}" placeholder="닉네임을 입력하세요" required>
                                    <div class="form-hint">2~10자 이내로 입력해주세요.</div>
                                    <div class="form-error">
                                        <i class="bi bi-exclamation-circle"></i>
                                        <span>닉네임을 입력해주세요.</span>
                                    </div>
                                </div>
                            </div>

                            <!-- 전화번호 -->
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">전화번호 <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" name="tel" id="phone"
                                           value="${member.memUser.tel}" placeholder="'-' 없이 숫자만 입력하세요" maxlength="11" required>
                                    <div class="form-error">
                                        <i class="bi bi-exclamation-circle"></i>
                                        <span>올바른 전화번호 형식이 아닙니다.</span>
                                    </div>
                                </div>
                            </div>

                            <!-- 생년월일 -->
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">생년월일 <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control birthdate-picker" name="birthDate" id="birthDate"
                                           value="${member.memUser.birthDate}" placeholder="생년월일을 선택하세요" required>
                                    <div class="form-error">
                                        <i class="bi bi-exclamation-circle"></i>
                                        <span>생년월일을 선택해주세요. </span>
                                    </div>
                                </div>
                            </div>

                            <!-- 성별 -->
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">성별 <span class="text-muted">(선택)</span></label>
                                    <div class="gender-selector">
                                        <label class="gender-option">
                                            <input type="radio" name="gender" value="M" ${member.memUser.gender == 'M' ? 'checked' : ''}>
                                            <span class="gender-label">
                                                <i class="bi bi-gender-male"></i>
                                                남성
                                            </span>
                                        </label>
                                        <label class="gender-option">
                                            <input type="radio" name="gender" value="F" ${member.memUser.gender == 'F' ? 'checked' : ''}>
                                            <span class="gender-label">
                                                <i class="bi bi-gender-female"></i>
                                                여성
                                            </span>
                                        </label>
                                        <label class="gender-option">
                                            <input type="radio" name="gender" value="" ${empty member.memUser.gender ? 'checked' : ''}>
                                            <span class="gender-label">
                                                <i class="bi bi-dash"></i>
                                                기타
                                            </span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 주소 정보 섹션 -->
                    <div class="content-section">
                        <h5 class="form-section-title"><i class="bi bi-geo-alt me-2 text-brand"></i>주소 정보</h5>

                        <div class="form-group">
                            <label class="form-label">주소 <span class="text-danger">*</span></label>
                            <div class="input-with-btn">
                                <input type="text" class="form-control" name="zip" id="postcode"
                                       value="${member.memUser.zip}" placeholder="우편번호" readonly>
                                <button type="button" class="btn btn-outline" onclick="searchAddress()">
                                    <i class="bi bi-search me-1"></i>주소검색
                                </button>
                            </div>
                            <input type="text" class="form-control mt-2" name="addr1" id="address"
                                   value="${member.memUser.addr1}" placeholder="기본주소" readonly>
                            <input type="text" class="form-control mt-2" name="addr2" id="addressDetail"
                                   value="${member.memUser.addr2}" placeholder="상세주소를 입력하세요">
                            <div class="form-error">
                                <i class="bi bi-exclamation-circle"></i>
                                <span>주소를 입력해주세요.</span>
                            </div>
                        </div>
                    </div>
                    
                     <!-- 비밀번호 확인 섹션 -->
                    <div class="content-section">
                        <h5 class="form-section-title"><i class="bi bi-lock me-2 text-brand"></i>비밀번호 확인</h5>
                        <p class="text-muted mb-3">비밀번호를 설정하면 일반 로그인도 사용할 수 있습니다.</p>

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
                    </div>

                    <!-- 마케팅 수신 동의 섹션 -->
                    <div class="content-section">
                        <h5 class="form-section-title"><i class="bi bi-megaphone me-2 text-brand"></i>마케팅 수신 동의</h5>
                        <p class="text-muted mb-3">여행 정보, 할인 혜택 등 유용한 소식을 받아보세요.</p>

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
			</div>
		</div>
<!-- 다음 주소 검색 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
// 프로필 이미지 미리보기
document.getElementById('profileImage').addEventListener('change', function(e) {
    const file = e.target.files[0];
    if (!file) return;
    
    document.getElementById('profileImageDeleted').value = 'false';

    if (file) {
        // 파일 크기 체크 (5MB)
        if (file.size > 5 * 1024 * 1024) {
            showToast('이미지 크기는 5MB 이하만 가능합니다.', 'error');
            this.value = '';
            return;
        }

        // 파일 형식 체크
        if (!file.type.startsWith('image/')) {
            showToast('이미지 파일만 업로드 가능합니다.', 'error');
            this.value = '';
            return;
        }

        const reader = new FileReader();
        reader.onload = function(evt) {
        	const img = document.getElementById('profilePreview');
            const icon = document.querySelector('.profile-default-icon');
            img.src = evt.target.result;
            img.style.display = 'block';
            icon.style.display = 'none';
        };
        reader.readAsDataURL(file);

        showToast('이미지가 선택되었습니다.', 'success');
    }
});

function resetProfileImage() {
    const img = document.getElementById('profilePreview');
    const icon = document.querySelector('.profile-default-icon');
    const fileInput = document.getElementById('profileImage');
    const deletedFlag = document.getElementById('profileImageDeleted');

    img.src = '';
    img.style.display = 'none';

    icon.style.display = 'block';

    if (fileInput) fileInput.value = '';
    if (deletedFlag) deletedFlag.value = 'true';

    showToast('기본 아이콘으로 변경되었습니다.', 'info');
}

// 비밀번호 로직 선언
const newPw = document.getElementById('newPassword');
const confirmPw = document.getElementById('confirmPassword');

newPw.addEventListener('input', checkPasswordStrength);
confirmPw.addEventListener('input', () => checkPasswordMatch(false));
confirmPw.addEventListener('blur', () => checkPasswordMatch(true));

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
    const password = newPw.value;
    const strengthBar = document.getElementById('strengthBar');
    const strengthText = document.getElementById('strengthText');
    
    document.getElementById('passwordError').style.display = 'none';
    document.getElementById('newPassword').classList.remove('is-invalid');

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

// 주소 검색 (다음 우편번호 API)
function searchAddress() {
    new daum.Postcode({
        oncomplete: function(data) {
            let address = data.roadAddress || data.jibunAddress;

            document.getElementById('postcode').value = data.zonecode;
            document.getElementById('address').value = address;
            document.getElementById('addressDetail').focus();

            document.getElementById('postcode').classList.remove('is-invalid');
            document.getElementById('address').classList.remove('is-invalid');
        }
    }).open();
}

// 전화번호 숫자만 입력
document.getElementById('phone').addEventListener('input', function() {
    this.value = this.value.replace(/[^0-9]/g, '');
});

// 폼 제출 전 유효성 검사
document.getElementById('profileForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const form = this;
    let isValid = true;
    
    // 필수 필드 검사
    const userName = document.getElementById('userName');
    const nickname = document.getElementById('nickname');
    const phone = document.getElementById('phone');
    const postcode = document.getElementById('postcode');
    const birthDate = document.getElementById('birthDate');
    const email = document.getElementById('email');

    // 이메일 검사
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!email.value.trim() || !emailRegex.test(email.value)) {
        email.classList.add('is-invalid');
        isValid = false;
    }

    // 이름 검사
    if (!userName.value.trim()) {
        userName.classList.add('is-invalid');
        isValid = false;
    }

    // 닉네임 검사
    if (!nickname.value.trim() || nickname.value.length < 2 || nickname.value.length > 10) {
        nickname.classList.add('is-invalid');
        isValid = false;
    }

    // 전화번호 검사
    const phoneRegex = /^01[0-9]{8,9}$/;
    if (!phoneRegex.test(phone.value)) {
        phone.classList.add('is-invalid');
        isValid = false;
    }

    // 주소 검사
    if (!postcode.value) {
        postcode.classList.add('is-invalid');
        isValid = false;
    }

    // 생년월일 검사
    if (!birthDate.value) {
        birthDate.classList.add('is-invalid');
        isValid = false;
    }

 	// 새 비밀번호 입력 시 검사
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    if (newPassword || confirmPassword) {
        if (newPassword.length < 8) {
            document.getElementById('newPassword').classList.add('is-invalid');
            isValid = false;
        }
        if (newPassword !== confirmPassword) {
            document.getElementById('confirmPassword').classList.add('is-invalid');
            isValid = false;
        }
    }
    
	 // 기본 유효성 검사 실패 시 종료
    if (!isValid) {
        showToast('입력 정보를 확인해주세요.', 'error');
        const firstInvalid = document.querySelector('.is-invalid');
        if (firstInvalid) {
            firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        return;
    }
	 
	 form.submit();
 
});

// 입력 시 에러 상태 제거
document.querySelectorAll('.form-control').forEach(input => {
    input.addEventListener('input', function() {
        this.classList.remove('is-invalid');
    });
});
// 회원 탈퇴 모달 열기
function openWithdrawModal() {
    // 모달 초기화
    document.getElementById('withdrawReason').value = '';
    document.getElementById('withdrawPassword').value = '';
    document.getElementById('withdrawAgree').checked = false;

    const modal = new bootstrap.Modal(document.getElementById('withdrawModal'));
    modal.show();
}

// 회원 탈퇴 확인
function confirmWithdraw() {
    const reason = document.getElementById('withdrawReason').value.trim();
    const password = document.getElementById('withdrawPassword').value;
    const agree = document.getElementById('withdrawAgree').checked;

    if (!reason) {
        showToast('탈퇴 사유를 입력해주세요.', 'error');
        document.getElementById('withdrawReason').focus();
        return;
    }

    if (!password) {
        showToast('비밀번호를 입력해주세요.', 'error');
        document.getElementById('withdrawPassword').focus();
        return;
    }

    if (!agree) {
        showToast('탈퇴 동의에 체크해주세요.', 'error');
        return;
    }

    // 탈퇴 데이터 수집
    const withdrawData = {
        reason: reason,
        password: password
    };

    console.log('탈퇴 데이터:', withdrawData);

	// 실제 서버 전송 로직
    if (confirm('정말로 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
        
        const formData = new URLSearchParams();
        formData.append('currentPassword', password); // 서버 파라미터명과 일치시켜야 함
        formData.append('withdrawReason', reason);   // 사유를 기록한다면 추가

        fetch('${pageContext.request.contextPath}/mypage/profile/withdraw', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                // Spring Security 사용 시 CSRF 토큰은 필수입니다!
                'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content 
            },
            body: formData
        })
        .then(response => {
            if (response.redirected) {
                // 성공 시 서버에서 보낸 리다이렉트 경로(메인 등)로 이동
                showToast('회원 탈퇴가 완료되었습니다.', 'success');
                setTimeout(() => {
                    window.location.href = response.url;
                }, 1500);
            } else {
                return response.text().then(text => { throw new Error(text) });
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('비밀번호가 틀렸거나 탈퇴 처리 중 오류가 발생했습니다.', 'error');
        });
    }
        
    setTimeout(() => {
        window.location.href = '${pageContext.request.contextPath}/';
    }, 2000);
    
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
<%@ include file="../common/footer.jsp" %>
