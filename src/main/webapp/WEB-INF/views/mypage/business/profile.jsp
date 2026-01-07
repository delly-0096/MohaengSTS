<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="회원 정보 수정" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../../common/header.jsp" %>

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
							                <div class="notification-item" id="notifyOrder">
							                    <label for="notifyReservation" for="notifyOrder">새 예약 알림</label>
							                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifyReservation" id="notifyReservation" checked></div>
							                </div>
							                <div class="notification-item" id="notifyReview">
							                    <label for="notifySchedule" for="notifyReview">새 후기 알림</label>
							                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifySchedule" id="notifySchedule" checked></div>
							                </div>
							                <div class="notification-item" id="notifyInquiry">
							                    <label for="notifyCommunity" for="notifyInquiry">문의 알림</label>
							                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifyCommunity" id="notifyCommunity" checked></div>
							                </div>
							                <div class="notification-item" id="notifySettlement">
							                    <label for="notifyPoint" for="notifySettlement">정산 완료 알림</label>
							                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifyPoint" id="notifyPoint"></div>
							                </div>
							                <div class="notification-item" id="notifyMarketing">
							                    <label for="notifyInquiry" for="notifyMarketing">마케팅 정보 수신</label>
							                    <div class="form-check form-switch"><input class="form-check-input" type="checkbox" name="notifyInquiry" id="notifyInquiry" checked></div>
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
							                <label class="form-label">기업 소개</label>
							                <div class="editable-input-container rounded-3">
							                    <textarea class="form-control" id="companyIntro" name="compIntro" rows="5" maxlength="1000" placeholder="기업을 소개해주세요.">${member.company.compIntro}</textarea>
							                </div>
							                <div class="text-end mt-1">
							                    <small class="text-muted"><span id="charCount">0</span> / 1000자</small>
							                </div>
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
							                    <input type="text" class="form-control" name="memName" value="${member.memName}" required>
							                </div>
							            </div>
							
							            <div class="form-group">
							                <label class="form-label">비즈니스 이메일 <span class="text-danger ms-1">*</span></label>
							                <div class="field-base editable-input-container d-flex">
							                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
							                    <input type="email" class="form-control border-0" name="memEmail" value="${member.memEmail}" required>
							                </div>
							            </div>
							
							            <div class="form-group">
							                <label class="form-label">담당자 연락처 <span class="text-danger ms-1">*</span></label>
							                <div class="field-base editable-input-container d-flex">
							                    <span class="input-group-text"><i class="bi bi-phone"></i></span>
							                    <input type="tel" class="form-control border-0" name="memCompTel" value="${member.memComp.memCompTel}" required>
							                </div>
							            </div>
							
							            <div class="form-group">
							                <label class="form-label">기업 대표 전화</label>
							                <div class="field-base readonly-field">
							                    <i class="bi bi-telephone me-2 small"></i> ${member.company.compTel}
							                </div>
							                <small class="text-muted mt-2 d-block">대표 번호 변경은 관리자 승인이 필요합니다.</small>
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
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">현재 비밀번호 <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" name="currentPassword" id="currentPassword" placeholder="현재 비밀번호" required>
                                    <small class="text-muted">본인 확인을 위해 필수 입력</small>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">새 비밀번호 <span class="text-muted">(선택)</span></label>
                                    <input type="password" class="form-control" id="newPassword" placeholder="변경 시에만 입력">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group mb-0">
                                    <label class="form-label">새 비밀번호 확인</label>
                                    <input type="password" class="form-control" id="confirmPassword" placeholder="새 비밀번호 확인">
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
// 전화번호 숫자만 입력
document.getElementById('managerPhone').addEventListener('input', function() {
    this.value = this.value.replace(/[^0-9]/g, '');
});

//폼 제출
document.getElementById('businessProfileForm').addEventListener('submit', function(e) {
    e.preventDefault(); // 일단 폼 전송을 완전히 막습니다.

    const form = this;
    const currentPasswordInput = document.getElementById('currentPassword');
    const currentPassword = currentPasswordInput.value;

    // --- 1. 기본 유효성 검사 (서버 통신 전 실행) ---

    // 현재 비밀번호 입력 확인
    if (!currentPassword) {
        showToast('현재 비밀번호를 입력해주세요.', 'error');
        currentPasswordInput.classList.add('is-invalid');
        currentPasswordInput.focus();
        return;
    }

    // 담당자명 체크
    const managerName = document.getElementById('managerName');
    if (!managerName.value.trim()) {
        showToast('담당자명을 입력해주세요.', 'error');
        managerName.classList.add('is-invalid');
        managerName.focus();
        return;
    }

    // 담당자 이메일 체크
    const managerEmail = document.getElementById('managerEmail');
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!managerEmail.value.trim() || !emailRegex.test(managerEmail.value)) {
        showToast('올바른 이메일 주소를 입력해주세요.', 'error');
        managerEmail.classList.add('is-invalid');
        managerEmail.focus();
        return;
    }

    // 담당자 연락처 체크
    const managerPhone = document.getElementById('managerPhone');
    const phoneRegex = /^01[0-9]{8,9}$/;
    if (!managerPhone.value.trim() || !phoneRegex.test(managerPhone.value)) {
        showToast('올바른 연락처를 입력해주세요.', 'error');
        managerPhone.classList.add('is-invalid');
        managerPhone.focus();
        return;
    }

    // 회사 홈페이지 URL 체크
    const companyWebsite = document.getElementById('companyWebsite');
    if (companyWebsite.value.trim()) {
        const urlRegex = /^https?:\/\/.+/;
        if (!urlRegex.test(companyWebsite.value)) {
            showToast('올바른 홈페이지 URL을 입력해주세요. (https://...)', 'error');
            companyWebsite.classList.add('is-invalid');
            companyWebsite.focus();
            return;
        }
    }

    // 새 비밀번호 체크
    const newPw = document.getElementById('newPassword');
    const confirmPw = document.getElementById('confirmPassword');
    if (newPw.value || confirmPw.value) {
        if (newPw.value.length < 8) {
            showToast('새 비밀번호는 8자 이상이어야 합니다.', 'error');
            newPw.classList.add('is-invalid');
            newPw.focus();
            return;
        }
        if (newPw.value !== confirmPw.value) {
            showToast('새 비밀번호가 일치하지 않습니다.', 'error');
            confirmPw.classList.add('is-invalid');
            confirmPw.focus();
            return;
        }
    }

    // --- 2. 서버 통신 (비밀번호 최종 확인) ---
    // 여기까지 도달했다면 모든 입력 형식은 올바른 상태입니다.
    fetch('${pageContext.request.contextPath}/mypage/profile/checkPassword', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            // 만약 403 에러가 발생한다면 CSRF 토큰을 여기에 추가해야 합니다.
        },
        body: 'currentPassword=' + encodeURIComponent(currentPassword)
    })
    .then(response => {
        if (!response.ok) throw new Error('서버 응답 오류');
        return response.json();
    })
    .then(isMatched => {
        if (isMatched === true) {
            // 비밀번호 일치 시 최종 제출
            // showToast('정보가 수정되었습니다.', 'success'); // 컨트롤러에서 rttr로 띄우므로 여기선 생략 가능
            form.submit();
        } else {
            // 비밀번호 불일치 시 (새로고침 안 됨)
            showToast('현재 비밀번호가 일치하지 않습니다.', 'error');
            currentPasswordInput.classList.add('is-invalid');
            currentPasswordInput.focus();
        }
    })
    .catch(error => {
        console.error('CheckPassword Error:', error);
        showToast('비밀번호 확인 중 오류가 발생했습니다.', 'error');
    });
});

//프로필 이미지 미리보기
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

//사업자 등록번호 하이픈 자동 추가 예시 (123-12-31232)
function formatBusinessNumber(value) {
    if (!value) return value;
    value = value.replace(/[^0-9]/g, ''); // 숫자만 남기기
    if (value.length <= 3) return value;
    if (value.length <= 5) return `${value.slice(0, 3)}-${value.slice(3)}`;
    return `${value.slice(0, 3)}-${value.slice(3, 5)}-${value.slice(5, 10)}`;
}

// 적용할 인풋 아이디에 연결
const bizInput = document.getElementById('brno');
if(bizInput) {
    bizInput.addEventListener('input', (e) => {
        e.target.value = formatBusinessNumber(e.target.value);
    });
}

// 기업 소개
document.addEventListener('DOMContentLoaded', function() {
    const textarea = document.getElementById('companyIntro'); // HTML의 id와 일치해야 함
    const charCount = document.getElementById('charCount');

    // 글자 수 업데이트 함수
    function updateCharCount() {
        const length = textarea.value.length;
        charCount.innerText = length;

        // 디자인 디테일: 900자가 넘어가면 빨간색으로 강조해서 경고 주기
        if (length >= 900) {
            charCount.style.color = '#dc3545';
            charCount.style.fontWeight = 'bold';
        } else {
            charCount.style.color = '#888';
            charCount.style.fontWeight = 'normal';
        }
    }

    // 1. 초기 로딩 시 실행 (기존 데이터가 있을 수 있으므로)
    if (textarea && charCount) {
        updateCharCount();

        // 2. 입력할 때마다 실시간 실행
        textarea.addEventListener('input', updateCharCount);
    }
});

</script>

<c:set var="pageJs" value="mypage" />
<%@ include file="../../common/footer.jsp" %>
