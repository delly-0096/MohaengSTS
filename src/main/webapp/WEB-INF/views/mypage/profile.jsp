<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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

                <form class="profile-edit-form" id="profileForm" action="${pageContext.request.contextPath}/mypage/profile/update" method="POST" enctype="multipart/form-data">
                	<input type="hidden" name="profileImageDeleted" id="profileImageDeleted" value="false">
                    <!-- 프로필 이미지 섹션 -->
                    <div class="content-section">
                        <h5 class="form-section-title"><i class="bi bi-image me-2"></i>프로필 이미지</h5>
                        	<div class="profile-image-upload">
                        		<div id="profileContainer" class="profile-image-preview-container">
		                            <!-- 기본 아이콘 -->
								    <i class="bi bi-person profile-default-icon"
								       style="${not empty profileImgUrl ? 'display:none;' : ''}">
								    </i>

	                          		<!-- 프로필 이미지 -->
								    <img
								        id="profilePreview"
								        class="profile-image-preview"
								        src="${not empty profileImgUrl 
								              ? pageContext.request.contextPath.concat(profileImgUrl) 
								              : ''}"
								        style="${not empty profileImgUrl ? '' : 'display:none;'}"
								        alt="프로필 이미지"
								    >
								</div>
                            <div class="profile-image-actions">
                                <input type="file" name="profileImage" id="profileImage" accept="image/*" hidden>
                                <button type="button" class="btn btn-outline btn-sm" onclick="document.getElementById('profileImage').click()">
                                    <i class="bi bi-camera me-2"></i>이미지 변경
                                </button>
                                <button type="button" class="btn btn-outline btn-sm" onclick="resetProfileImage()">
                                    <i class="bi bi-trash me-2"></i>삭제
                                </button>
                                <p class="form-hint mt-2 mb-0">JPG, PNG 파일 (최대 5MB)</p>
                            </div>
                        </div>
                    </div>

                    <!-- 기본 정보 섹션 -->
                    <div class="content-section">
                        <h5 class="form-section-title"><i class="bi bi-person me-2"></i>기본 정보</h5>

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
                                           value="${member.memName}" placeholder="이름을 입력하세요" readonly disabled>
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
                        <h5 class="form-section-title"><i class="bi bi-geo-alt me-2"></i>주소 정보</h5>

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
                        <h5 class="form-section-title"><i class="bi bi-lock me-2"></i>비밀번호 확인</h5>
                        <p class="text-muted mb-4">회원정보 수정을 위해 현재 비밀번호를 입력해주세요. 비밀번호 변경을 원하시면 새 비밀번호도 입력하세요.</p>

                        <div class="row">
                            <!-- 현재 비밀번호 -->
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label class="form-label">현재 비밀번호 <span class="text-danger">*</span></label>
                                    <div class="password-toggle">
                                        <input type="password" class="form-control" name="currentPassword" id="currentPassword"
                                               placeholder="현재 비밀번호를 입력하세요" required>
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
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">새 비밀번호 <span class="text-muted">(선택)</span></label>
                                    <div class="password-toggle">
                                        <input type="password" class="form-control" name="newPassword" id="newPassword"
                                               placeholder="변경 시에만 입력하세요" onkeyup="checkPasswordStrength()">
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
                                    <div class="form-error">
                                        <i class="bi bi-exclamation-circle"></i>
                                        <span>비밀번호는 8자 이상이어야 합니다.</span>
                                    </div>
                                </div>
                            </div>

                            <!-- 새 비밀번호 확인 -->
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">새 비밀번호 확인</label>
                                    <div class="password-toggle">
                                        <input type="password" class="form-control" name="confirmPassword" id="confirmPassword"
                                               placeholder="새 비밀번호를 다시 입력하세요" onkeyup="checkPasswordMatch()">
                                        <span class="toggle-btn" onclick="togglePassword('confirmPassword')">
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
                            </div>
                        </div>
                    </div>

                    <!-- 알림 설정 섹션 -->
                    <div class="content-section">
                        <h5 class="form-section-title"><i class="bi bi-bell me-2"></i>알림 설정</h5>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="notifyReservation" id="notifyReservation" checked>
                            <label class="form-check-label" for="notifyReservation">
                                예약 확정/취소 알림 (이메일)
                            </label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="notifySchedule" id="notifySchedule" checked>
                            <label class="form-check-label" for="notifySchedule">
                                여행 일정 리마인드 알림 (이메일)
                            </label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="notifyCommunity" id="notifyCommunity" checked>
                            <label class="form-check-label" for="notifyCommunity">
                                커뮤니티 댓글/답글 알림 (이메일)
                            </label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" name="notifyPoint" id="notifyPoint">
                            <label class="form-check-label" for="notifyPoint">
                                포인트 적립/사용 알림 (이메일)
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="notifyInquiry" id="notifyInquiry" checked>
                            <label class="form-check-label" for="notifyInquiry">
                                문의 답변 알림 (이메일)
                            </label>
                        </div>
                    </div>

                    <!-- 마케팅 수신 동의 섹션 -->
                    <div class="content-section">
                        <h5 class="form-section-title"><i class="bi bi-megaphone me-2"></i>마케팅 수신 동의</h5>
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
                        <button type="button" class="btn btn-outline btn-lg" onclick="location.href='${pageContext.request.contextPath}/mypage'">
                            취소
                        </button>
                    </div>
                </form>

                <!-- 계정 탈퇴 섹션 -->
                <div class="content-section danger-section">
                    <h5 class="form-section-title text-danger"><i class="bi bi-exclamation-triangle me-2"></i>계정 탈퇴</h5>
                    <p class="text-muted mb-3">
                        계정을 탈퇴하면 모든 데이터가 삭제되며 복구할 수 없습니다.<br>
                        작성한 게시글, 예약 내역, 포인트 등 모든 정보가 영구적으로 삭제됩니다.
                    </p>
                    <button type="button" class="btn btn-outline-danger" onclick="openWithdrawModal()">
                        <i class="bi bi-person-x me-2"></i>회원 탈퇴
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 회원 탈퇴 모달 -->
<div class="modal fade" id="withdrawModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-danger">
                    <i class="bi bi-exclamation-triangle me-2"></i>회원 탈퇴
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-danger">
                    <strong>주의!</strong> 탈퇴 시 다음 정보가 모두 삭제됩니다.
                </div>
                <ul class="withdraw-info-list">
                    <li><i class="bi bi-calendar-x"></i> 저장된 여행 일정</li>
                    <li><i class="bi bi-bookmark-x"></i> 북마크한 장소 및 상품</li>
                    <li><i class="bi bi-coin"></i> 보유 포인트</li>
                </ul>
                <div class="alert alert-warning mt-3">
                    <i class="bi bi-info-circle me-2"></i>
                    <strong>결제 및 예약 내역</strong>은 관련 법령에 따라 탈퇴 후 <strong>5년간 보관</strong> 후 자동 삭제됩니다.
                </div>

                <!-- 탈퇴 사유 입력 -->
                <div class="form-group mt-4">
                    <label class="form-label">탈퇴 사유 <span class="text-danger">*</span></label>
                    <textarea class="form-control" id="withdrawReason" rows="3"
                              placeholder="탈퇴 사유를 입력해주세요." required></textarea>
                    <div class="form-hint mt-1">서비스 개선을 위해 탈퇴 사유를 남겨주시면 감사하겠습니다.</div>
                </div>

                <hr class="my-4">

                <div class="form-group">
                    <label class="form-label">본인 확인을 위해 비밀번호를 입력하세요 <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="withdrawPassword"
                           placeholder="비밀번호 입력">
                </div>
                <div class="form-check mt-3">
                    <input class="form-check-input" type="checkbox" id="withdrawAgree">
                    <label class="form-check-label text-danger" for="withdrawAgree">
                        위 내용을 확인했으며, 탈퇴에 동의합니다.
                    </label>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-danger" onclick="confirmWithdraw()">탈퇴하기</button>
            </div>
        </div>
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

window.addEventListener('DOMContentLoaded', () => {
    const img = document.getElementById('profilePreview');

    // base64 미리보기 상태면 건드리지 않음
    if (img && img.src.startsWith('data:image')) {
        return;
    }

    // 서버 이미지 정상 유지
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
    const password = document.getElementById('newPassword').value;
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

    checkPasswordMatch();
}

// 비밀번호 일치 확인
function checkPasswordMatch() {
    const password = document.getElementById('newPassword').value;
    const passwordConfirm = document.getElementById('confirmPassword');
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

    // 비밀번호 검사
    const currentPassword = document.getElementById('currentPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    // 현재 비밀번호는 필수
    if (!currentPassword) {
        document.getElementById('currentPassword').classList.add('is-invalid');
        isValid = false;
    }

    // 새 비밀번호 입력 시 검사
    if (newPassword || confirmPassword) {
        if (newPassword.length < 8 && newPassword.length > 0) {
            document.getElementById('newPassword').classList.add('is-invalid');
            isValid = false;
        }

        if (newPassword !== confirmPassword) {
            document.getElementById('confirmPassword').classList.add('is-invalid');
            isValid = false;
        }
    }

    if (!isValid) {
        showToast('입력 정보를 확인해주세요.', 'error');
        const firstInvalid = document.querySelector('.is-invalid');
        if (firstInvalid) {
            firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        return;
    }

    // 성공 시
    showToast('회원 정보가 수정되었습니다.', 'success');

    // 실제 구현 시 아래 주석 해제
   	this.submit();
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

    // 탈퇴 처리
    showToast('회원 탈퇴가 완료되었습니다. 그동안 이용해 주셔서 감사합니다.', 'info');

    setTimeout(() => {
        window.location.href = '${pageContext.request.contextPath}/';
    }, 2000);
}
</script>

<c:set var="pageJs" value="mypage" />
<%@ include file="../common/footer.jsp" %>
