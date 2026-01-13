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

                <div class="content-section">
                    <form class="profile-form" id="businessProfileForm" style="max-width: 100%;">
                        <!-- 기업 로고 -->
                        <div class="profile-image-upload">
                            <img src="https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200&h=200&fit=crop&q=80"
                                 alt="기업 로고" class="profile-image-preview" id="logoPreview">
                            <div class="profile-image-actions">
                                <input type="file" id="logoInput" accept="image/*" style="display: none;" onchange="previewLogo(this)">
                                <button type="button" class="btn btn-outline btn-sm" onclick="document.getElementById('logoInput').click()">
                                    <i class="bi bi-camera me-1"></i>로고 변경
                                </button>
                                <button type="button" class="btn btn-outline-danger btn-sm" onclick="deleteLogo()">
                                    <i class="bi bi-trash me-1"></i>삭제
                                </button>
                            </div>
                            <small class="text-muted d-block mt-2">권장 크기: 200x200px (최대 2MB)</small>
                        </div>

                        <div class="row">
                            <!-- 기업 기본 정보 (읽기전용) -->
                            <div class="col-lg-6">
                                <h5 class="form-section-title"><i class="bi bi-building me-2"></i>기업 기본 정보</h5>
                                <div class="form-group">
                                    <label class="form-label">기업명</label>
                                    <input type="text" class="form-control" value="모행 투어" readonly disabled>
                                    <small class="text-muted">기업 정보 변경은 고객센터로 문의해주세요.</small>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">사업자등록번호</label>
                                    <input type="text" class="form-control" value="123-45-67890" readonly disabled>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">업종</label>
                                    <input type="text" class="form-control" value="관광/레저" readonly disabled>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">사업장 주소</label>
                                    <input type="text" class="form-control mb-2" value="63535" readonly disabled>
                                    <input type="text" class="form-control mb-2" value="제주특별자치도 서귀포시 중문관광로 72" readonly disabled>
                                    <input type="text" class="form-control" value="3층 301호" readonly disabled>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">회사 홈페이지</label>
                                    <input type="url" class="form-control" name="companyWebsite" id="companyWebsite"
                                           value="https://www.mohaengtour.com" placeholder="예: https://www.example.com">
                                    <small class="text-muted">https://를 포함하여 입력해주세요.</small>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">기업 소개</label>
                                    <textarea class="form-control" name="companyDescription" id="companyDescription"
                                              rows="4" maxlength="1000"
                                              placeholder="기업에 대한 간단한 소개를 입력해주세요. (최대 1000자)">제주도 전문 여행사 모행투어입니다. 현지 전문가와 함께하는 프리미엄 투어 서비스를 제공합니다. 소규모 그룹 투어부터 맞춤 프라이빗 투어까지 다양한 여행 상품을 만나보세요.</textarea>
                                    <small class="text-muted">고객에게 보여질 기업 소개입니다. 제공하는 서비스, 특장점 등을 작성해주세요.</small>
                                </div>
                            </div>

                            <!-- 담당자 정보 (수정가능) -->
                            <div class="col-lg-6">
                                <h5 class="form-section-title"><i class="bi bi-person me-2"></i>담당자 정보</h5>
                                <div class="form-group">
                                    <label class="form-label">담당자명 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="managerName" id="managerName" value="홍길동" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">담당자 이메일 <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" name="managerEmail" id="managerEmail" value="mohaeng.tour@example.com" required>
                                    <small class="text-muted">알림 수신 및 비밀번호 찾기에 사용됩니다.</small>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">담당자 연락처 <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" name="managerPhone" id="managerPhone" value="01012345678" placeholder="'-' 없이 입력" maxlength="11" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">대표 전화번호</label>
                                    <input type="tel" class="form-control" value="064-123-4567" readonly disabled>
                                    <small class="text-muted">대표 전화번호 변경은 고객센터로 문의해주세요.</small>
                                </div>
                            </div>
                        </div>

                        <!-- 정산 정보 (읽기전용) -->
                        <h5 class="form-section-title"><i class="bi bi-bank me-2"></i>정산 정보</h5>
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">은행</label>
                                    <input type="text" class="form-control" value="신한은행" readonly disabled>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">계좌번호</label>
                                    <input type="text" class="form-control" value="110-***-***890" readonly disabled>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">예금주</label>
                                    <input type="text" class="form-control" value="(주)모행투어" readonly disabled>
                                </div>
                            </div>
                            <div class="col-12">
                                <small class="text-muted"><i class="bi bi-info-circle me-1"></i>정산 정보 변경은 고객센터로 문의해주세요.</small>
                            </div>
                        </div>

                        <!-- 비밀번호 확인 -->
                        <h5 class="form-section-title"><i class="bi bi-lock me-2"></i>비밀번호 확인</h5>
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

                        <!-- 알림 설정 -->
                        <h5 class="form-section-title"><i class="bi bi-bell me-2"></i>알림 설정</h5>
                        <div class="row mb-4">
                            <div class="col-12">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" id="notifyOrder" checked>
                                    <label class="form-check-label" for="notifyOrder">
                                        새 예약 알림 (이메일)
                                    </label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" id="notifyReview" checked>
                                    <label class="form-check-label" for="notifyReview">
                                        새 후기 알림 (이메일)
                                    </label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" id="notifyInquiry" checked>
                                    <label class="form-check-label" for="notifyInquiry">
                                        문의 알림 (이메일)
                                    </label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" id="notifySettlement" checked>
                                    <label class="form-check-label" for="notifySettlement">
                                        정산 완료 알림 (이메일)
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="notifyMarketing">
                                    <label class="form-check-label" for="notifyMarketing">
                                        마케팅 정보 수신 (이메일)
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex gap-3">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="bi bi-check-lg me-2"></i>저장하기
                            </button>
                            <button type="button" class="btn btn-outline btn-lg" onclick="history.back()">
                                취소
                            </button>
                        </div>
                    </form>
                </div>

                <!-- 안내 메시지 -->
                <div class="content-section">
                    <div class="alert alert-info mb-0">
                        <i class="bi bi-info-circle me-2"></i>
                        <strong>기업 정보 변경 안내</strong><br>
                        기업명, 사업자등록번호, 사업장 주소, 정산 정보 등 주요 정보의 변경이 필요한 경우<br>
                        고객센터(1588-0000)로 문의하시거나 1:1 문의를 이용해주세요.
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

// 폼 제출
document.getElementById('businessProfileForm').addEventListener('submit', function(e) {
    e.preventDefault();

    // 현재 비밀번호 필수 체크
    const currentPassword = document.getElementById('currentPassword').value;
    if (!currentPassword) {
        showToast('현재 비밀번호를 입력해주세요.', 'error');
        document.getElementById('currentPassword').focus();
        return;
    }

    // 담당자명 체크
    const managerName = document.getElementById('managerName').value.trim();
    if (!managerName) {
        showToast('담당자명을 입력해주세요.', 'error');
        document.getElementById('managerName').focus();
        return;
    }

    // 담당자 이메일 체크
    const managerEmail = document.getElementById('managerEmail').value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!managerEmail || !emailRegex.test(managerEmail)) {
        showToast('올바른 이메일 주소를 입력해주세요.', 'error');
        document.getElementById('managerEmail').focus();
        return;
    }

    // 담당자 연락처 체크
    const managerPhone = document.getElementById('managerPhone').value.trim();
    const phoneRegex = /^01[0-9]{8,9}$/;
    if (!managerPhone || !phoneRegex.test(managerPhone)) {
        showToast('올바른 연락처를 입력해주세요.', 'error');
        document.getElementById('managerPhone').focus();
        return;
    }

    // 회사 홈페이지 URL 체크 (선택 항목이지만 입력 시 형식 검증)
    const companyWebsite = document.getElementById('companyWebsite').value.trim();
    if (companyWebsite) {
        const urlRegex = /^https?:\/\/.+/;
        if (!urlRegex.test(companyWebsite)) {
            showToast('올바른 홈페이지 URL을 입력해주세요. (https://로 시작)', 'error');
            document.getElementById('companyWebsite').focus();
            return;
        }
    }

    // 새 비밀번호 체크
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    if (newPassword || confirmPassword) {
        if (newPassword.length < 8) {
            showToast('새 비밀번호는 8자 이상이어야 합니다.', 'error');
            document.getElementById('newPassword').focus();
            return;
        }

        if (newPassword !== confirmPassword) {
            showToast('새 비밀번호가 일치하지 않습니다.', 'error');
            document.getElementById('confirmPassword').focus();
            return;
        }
    }

    // 성공
    showToast('회원 정보가 수정되었습니다.', 'success');
});

// 로고 미리보기
function previewLogo(input) {
    if (input.files && input.files[0]) {
        var file = input.files[0];

        // 파일 크기 체크 (2MB)
        if (file.size > 2 * 1024 * 1024) {
            showToast('파일 크기는 2MB 이하여야 합니다.', 'error');
            input.value = '';
            return;
        }

        // 이미지 파일 체크
        if (!file.type.startsWith('image/')) {
            showToast('이미지 파일만 업로드 가능합니다.', 'error');
            input.value = '';
            return;
        }

        var reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('logoPreview').src = e.target.result;
            showToast('로고가 변경되었습니다. 저장 버튼을 눌러 적용하세요.', 'success');
        };
        reader.readAsDataURL(file);
    }
}

// 로고 삭제
function deleteLogo() {
    if (confirm('로고를 삭제하시겠습니까?')) {
        document.getElementById('logoPreview').src = 'https://via.placeholder.com/200x200?text=LOGO';
        document.getElementById('logoInput').value = '';
        showToast('로고가 삭제되었습니다. 저장 버튼을 눌러 적용하세요.', 'info');
    }
}
</script>

<c:set var="pageJs" value="mypage" />
<%@ include file="../../common/footer.jsp" %>
