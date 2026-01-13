<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="추천 일정" />
<c:set var="pageCss" value="schedule" />

<%@ include file="../common/header.jsp" %>

<div class="ai-result-page">
    <!-- 헤더 (추천 유형에 따라 동적 변경) -->
    <div class="ai-result-header" id="resultHeader">
        <h1 id="resultTitle"><i class="bi bi-stars text-warning me-2"></i>AI 추천 일정</h1>
        <p id="resultSubtitle">선호도를 기반으로 만들어진 맞춤 여행 일정입니다</p>
    </div>

    <div class="schedule-container">
        <!-- 사이드바 -->
        <aside class="schedule-sidebar">
            <div class="trip-info">
                <h2 class="trip-destination" id="tripDestination">제주도</h2>
                <div class="trip-dates">
                    <i class="bi bi-calendar3"></i>
                    <span id="tripDates">2024.03.15 - 2024.03.18</span>
                    <span class="text-muted">(3박 4일)</span>
                </div>
            </div>

            <div class="day-tabs" id="dayTabs">
                <div class="day-tab active" data-day="1" onclick="selectDay(1)">
                    <div class="day-number">1</div>
                    <div class="day-info">
                        <span class="day-label">1일차</span>
                        <span class="day-date">3월 15일 (금)</span>
                    </div>
                </div>
                <div class="day-tab" data-day="2" onclick="selectDay(2)">
                    <div class="day-number">2</div>
                    <div class="day-info">
                        <span class="day-label">2일차</span>
                        <span class="day-date">3월 16일 (토)</span>
                    </div>
                </div>
                <div class="day-tab" data-day="3" onclick="selectDay(3)">
                    <div class="day-number">3</div>
                    <div class="day-info">
                        <span class="day-label">3일차</span>
                        <span class="day-date">3월 17일 (일)</span>
                    </div>
                </div>
                <div class="day-tab" data-day="4" onclick="selectDay(4)">
                    <div class="day-number">4</div>
                    <div class="day-info">
                        <span class="day-label">4일차</span>
                        <span class="day-date">3월 18일 (월)</span>
                    </div>
                </div>
            </div>
        </aside>

        <!-- 메인 콘텐츠 -->
        <main class="schedule-main">
            <!-- Day 1 -->
            <div class="schedule-day" id="day1" data-day="1">
                <div class="schedule-day-header">
                    <h2 class="schedule-day-title">1일차 - 도착 & 동부 탐방</h2>
                    <div class="schedule-day-actions">
                        <button class="btn btn-outline btn-sm" onclick="regenerateDay(1)">
                            <i class="bi bi-arrow-clockwise me-1"></i>다시 추천
                        </button>
                    </div>
                </div>

                <div class="timeline">
                    <div class="timeline-item transport">
                        <div class="timeline-dot"><i class="bi bi-airplane"></i></div>
                        <div class="timeline-time">09:00 - 10:10</div>
                        <div class="timeline-card">
                            <div class="timeline-card-header">
                                <div class="timeline-card-content">
                                    <span class="timeline-card-category">이동</span>
                                    <h4 class="timeline-card-title">김포 → 제주 (항공편)</h4>
                                    <p class="timeline-card-address">
                                        <i class="bi bi-clock"></i> 비행시간 약 1시간 10분
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="timeline-item">
                        <div class="timeline-dot">1</div>
                        <div class="timeline-time">11:00 - 12:30</div>
                        <div class="timeline-card">
                            <div class="timeline-card-header">
                                <img src="https://images.unsplash.com/photo-1578469645742-46cae010e5d4?w=200&h=150&fit=crop&q=80"
                                     alt="성산일출봉" class="timeline-card-image">
                                <div class="timeline-card-content">
                                    <span class="timeline-card-category">관광지</span>
                                    <h4 class="timeline-card-title">성산일출봉</h4>
                                    <p class="timeline-card-address">
                                        <i class="bi bi-geo-alt"></i> 제주 서귀포시 성산읍 성산리
                                    </p>
                                    <div class="timeline-card-actions">
                                        <button class="btn btn-outline btn-sm" onclick="viewDetail('place', 1)">
                                            상세보기
                                        </button>
                                        <button class="btn btn-text btn-sm" onclick="removeItem(1, 1)">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="timeline-item">
                        <div class="timeline-dot">2</div>
                        <div class="timeline-time">12:30 - 14:00</div>
                        <div class="timeline-card">
                            <div class="timeline-card-header">
                                <img src="https://images.unsplash.com/photo-1553621042-f6e147245754?w=200&h=150&fit=crop&q=80"
                                     alt="해녀의집" class="timeline-card-image">
                                <div class="timeline-card-content">
                                    <span class="timeline-card-category" style="background: var(--accent-color);">맛집</span>
                                    <h4 class="timeline-card-title">해녀의집</h4>
                                    <p class="timeline-card-address">
                                        <i class="bi bi-geo-alt"></i> 제주 서귀포시 성산읍
                                    </p>
                                    <div class="timeline-card-actions">
                                        <button class="btn btn-outline btn-sm" onclick="viewDetail('restaurant', 1)">
                                            상세보기
                                        </button>
                                        <button class="btn btn-text btn-sm" onclick="removeItem(1, 2)">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="timeline-item">
                        <div class="timeline-dot">3</div>
                        <div class="timeline-time">14:30 - 16:30</div>
                        <div class="timeline-card">
                            <div class="timeline-card-header">
                                <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=200&h=150&fit=crop&q=80"
                                     alt="우도" class="timeline-card-image">
                                <div class="timeline-card-content">
                                    <span class="timeline-card-category">관광지</span>
                                    <h4 class="timeline-card-title">우도</h4>
                                    <p class="timeline-card-address">
                                        <i class="bi bi-geo-alt"></i> 제주 제주시 우도면
                                    </p>
                                    <div class="timeline-card-actions">
                                        <button class="btn btn-outline btn-sm" onclick="viewDetail('place', 2)">
                                            상세보기
                                        </button>
                                        <button class="btn btn-text btn-sm" onclick="removeItem(1, 3)">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="timeline-item">
                        <div class="timeline-dot">4</div>
                        <div class="timeline-time">18:00 - 19:30</div>
                        <div class="timeline-card">
                            <div class="timeline-card-header">
                                <img src="https://images.unsplash.com/photo-1544025162-d76694265947?w=200&h=150&fit=crop&q=80"
                                     alt="흑돼지거리" class="timeline-card-image">
                                <div class="timeline-card-content">
                                    <span class="timeline-card-category" style="background: var(--accent-color);">맛집</span>
                                    <h4 class="timeline-card-title">제주 흑돼지거리</h4>
                                    <p class="timeline-card-address">
                                        <i class="bi bi-geo-alt"></i> 제주 제주시 연동
                                    </p>
                                    <div class="timeline-card-actions">
                                        <button class="btn btn-outline btn-sm" onclick="viewDetail('restaurant', 2)">
                                            상세보기
                                        </button>
                                        <button class="btn btn-text btn-sm" onclick="removeItem(1, 4)">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <button class="add-place-btn" onclick="addPlace(1)">
                    <i class="bi bi-plus-circle"></i> 장소 추가하기
                </button>
            </div>

            <!-- Day 2, 3, 4 (숨김) -->
            <div class="schedule-day" id="day2" data-day="2" style="display: none;">
                <div class="schedule-day-header">
                    <h2 class="schedule-day-title">2일차 - 서부 해안 드라이브</h2>
                    <div class="schedule-day-actions">
                        <button class="btn btn-outline btn-sm" onclick="regenerateDay(2)">
                            <i class="bi bi-arrow-clockwise me-1"></i>다시 추천
                        </button>
                    </div>
                </div>
                <div class="timeline">
                    <!-- 2일차 일정 내용 -->
                    <div class="timeline-item">
                        <div class="timeline-dot">1</div>
                        <div class="timeline-time">09:00 - 11:00</div>
                        <div class="timeline-card">
                            <div class="timeline-card-header">
                                <div class="timeline-card-content">
                                    <span class="timeline-card-category">관광지</span>
                                    <h4 class="timeline-card-title">협재해수욕장</h4>
                                    <p class="timeline-card-address">
                                        <i class="bi bi-geo-alt"></i> 제주 제주시 한림읍
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <button class="add-place-btn" onclick="addPlace(2)">
                    <i class="bi bi-plus-circle"></i> 장소 추가하기
                </button>
            </div>

            <div class="schedule-day" id="day3" data-day="3" style="display: none;">
                <div class="schedule-day-header">
                    <h2 class="schedule-day-title">3일차 - 중문관광단지</h2>
                </div>
                <div class="timeline">
                    <div class="timeline-item">
                        <div class="timeline-dot">1</div>
                        <div class="timeline-time">10:00 - 12:00</div>
                        <div class="timeline-card">
                            <div class="timeline-card-header">
                                <div class="timeline-card-content">
                                    <span class="timeline-card-category">관광지</span>
                                    <h4 class="timeline-card-title">중문대포해안 주상절리대</h4>
                                    <p class="timeline-card-address">
                                        <i class="bi bi-geo-alt"></i> 제주 서귀포시 중문동
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <button class="add-place-btn" onclick="addPlace(3)">
                    <i class="bi bi-plus-circle"></i> 장소 추가하기
                </button>
            </div>

            <div class="schedule-day" id="day4" data-day="4" style="display: none;">
                <div class="schedule-day-header">
                    <h2 class="schedule-day-title">4일차 - 마지막 날</h2>
                </div>
                <div class="timeline">
                    <div class="timeline-item">
                        <div class="timeline-dot">1</div>
                        <div class="timeline-time">09:00 - 10:30</div>
                        <div class="timeline-card">
                            <div class="timeline-card-header">
                                <div class="timeline-card-content">
                                    <span class="timeline-card-category">관광지</span>
                                    <h4 class="timeline-card-title">동문시장</h4>
                                    <p class="timeline-card-address">
                                        <i class="bi bi-geo-alt"></i> 제주 제주시 이도1동
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="timeline-item transport">
                        <div class="timeline-dot"><i class="bi bi-airplane"></i></div>
                        <div class="timeline-time">14:00 - 15:10</div>
                        <div class="timeline-card">
                            <div class="timeline-card-header">
                                <div class="timeline-card-content">
                                    <span class="timeline-card-category">이동</span>
                                    <h4 class="timeline-card-title">제주 → 김포 (항공편)</h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 액션 버튼 -->
            <div class="schedule-actions">
                <a href="${pageContext.request.contextPath}/schedule/planner" class="btn btn-outline btn-lg">
                    <i class="bi bi-pencil me-2"></i>일정 수정하기
                </a>
                <button class="btn btn-primary btn-lg" onclick="saveSchedule()">
                    <i class="bi bi-bookmark me-2"></i>일정 담기
                </button>
            </div>
        </main>
    </div>
</div>

<!-- 상세보기 모달 -->
<div class="modal fade" id="detailModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detailModalTitle">장소 상세정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="detailModalBody">
                <!-- 동적 콘텐츠 -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary">
                    <i class="bi bi-bookmark me-1"></i>북마크
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 일정 저장 모달 -->
<div class="modal fade" id="saveScheduleModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-bookmark-check me-2"></i>일정 저장</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p class="text-muted mb-3">저장할 일정의 공개 범위를 선택해주세요.</p>
                <div class="visibility-options">
                    <label class="visibility-option selected" onclick="selectVisibility('public')">
                        <input type="radio" name="visibility" value="public" checked>
                        <div class="visibility-option-content">
                            <div class="visibility-icon">
                                <i class="bi bi-globe"></i>
                            </div>
                            <div class="visibility-info">
                                <div class="visibility-title">전체 공개</div>
                                <div class="visibility-desc">모든 사용자가 볼 수 있습니다</div>
                            </div>
                        </div>
                    </label>
                    <label class="visibility-option" onclick="selectVisibility('private')">
                        <input type="radio" name="visibility" value="private">
                        <div class="visibility-option-content">
                            <div class="visibility-icon">
                                <i class="bi bi-lock"></i>
                            </div>
                            <div class="visibility-info">
                                <div class="visibility-title">비공개</div>
                                <div class="visibility-desc">나만 볼 수 있습니다</div>
                            </div>
                        </div>
                    </label>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="confirmSaveSchedule()">
                    <i class="bi bi-check-lg me-1"></i>저장하기
                </button>
            </div>
        </div>
    </div>
</div>

<script>
let currentDay = 1;
let selectedVisibility = 'public';
let saveScheduleModal;

// 선호도 데이터 로드
document.addEventListener('DOMContentLoaded', function() {
    // 저장 모달 초기화
    saveScheduleModal = new bootstrap.Modal(document.getElementById('saveScheduleModal'));
    const preferenceData = JSON.parse(sessionStorage.getItem('preferenceData') || '{}');

    if (preferenceData.destination) {
        document.getElementById('tripDestination').textContent = preferenceData.destination;
    }
    if (preferenceData.travelDates) {
        document.getElementById('tripDates').textContent = preferenceData.travelDates;
    }

    // 추천 유형에 따라 헤더 변경
    if (preferenceData.recommendType === 'user_plans') {
        document.getElementById('resultTitle').innerHTML = '<i class="bi bi-people-fill text-primary me-2"></i>사용자 추천 일정';
        document.getElementById('resultSubtitle').textContent = '다른 여행자들이 만든 인기 일정입니다';
        document.title = '사용자 추천 일정 - 모행';
    }
});

function selectDay(day) {
    // 탭 활성화 - 모든 탭에서 active 제거
    var tabs = document.querySelectorAll('.day-tab');
    for (var i = 0; i < tabs.length; i++) {
        tabs[i].classList.remove('active');
    }

    // 선택한 탭에 active 추가
    var selectedTab = document.querySelector('.day-tab[data-day="' + day + '"]');
    if (selectedTab) {
        selectedTab.classList.add('active');
    }

    // 콘텐츠 표시 - 모든 일정 숨기기
    var contents = document.querySelectorAll('.schedule-day');
    for (var j = 0; j < contents.length; j++) {
        contents[j].style.display = 'none';
    }

    // 선택한 일정 표시
    var selectedDay = document.getElementById('day' + day);
    if (selectedDay) {
        selectedDay.style.display = 'block';
    }

    currentDay = day;
}

function viewDetail(type, id) {
    // 모달 표시
    const modal = new bootstrap.Modal(document.getElementById('detailModal'));

    // 상세 정보 로드 (실제 구현 시 AJAX)
    document.getElementById('detailModalTitle').textContent = type === 'place' ? '관광지 상세정보' : '맛집 상세정보';
    document.getElementById('detailModalBody').innerHTML = `
        <div class="text-center py-4">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2">정보를 불러오는 중...</p>
        </div>
    `;

    modal.show();

    // 데모용 콘텐츠
    setTimeout(function() {
        document.getElementById('detailModalBody').innerHTML =
            '<div class="row">' +
                '<div class="col-md-6">' +
                    '<img src="https://images.unsplash.com/photo-1578469645742-46cae010e5d4?w=400&h=300&fit=crop&q=80" ' +
                         'alt="성산일출봉" class="w-100 rounded-3 mb-3">' +
                '</div>' +
                '<div class="col-md-6">' +
                    '<h4>성산일출봉</h4>' +
                    '<p class="text-muted mb-3">' +
                        '<i class="bi bi-geo-alt me-1"></i>제주 서귀포시 성산읍 성산리 114' +
                    '</p>' +
                    '<div class="mb-3">' +
                        '<span class="badge bg-primary me-1">관광명소</span>' +
                        '<span class="badge bg-secondary">유네스코 세계자연유산</span>' +
                    '</div>' +
                    '<p>해발 182m의 수성화산체로, 제주도 동쪽 해안에 위치한 우리나라 최대의 화산 분화구입니다.</p>' +
                    '<hr>' +
                    '<p class="mb-1"><strong>운영시간:</strong> 일출 1시간 전 ~ 20:00</p>' +
                    '<p class="mb-1"><strong>입장료:</strong> 성인 5,000원</p>' +
                    '<p class="mb-1"><strong>주차:</strong> 가능 (유료)</p>' +
                    '<div class="d-flex gap-2 mt-3">' +
                        '<span class="text-warning"><i class="bi bi-star-fill"></i></span>' +
                        '<span class="fw-bold">4.7</span>' +
                        '<span class="text-muted">(리뷰 2,847개)</span>' +
                    '</div>' +
                '</div>' +
            '</div>';
    }, 500);
}

function removeItem(day, itemIndex) {
    if (confirm('이 장소를 일정에서 제거하시겠습니까?')) {
        showToast('장소가 제거되었습니다.', 'success');
    }
}

function addPlace(day) {
    window.location.href = '${pageContext.request.contextPath}/schedule/planner?day=' + day;
}

function regenerateDay(day) {
    if (confirm('이 날의 일정을 다시 추천받으시겠습니까?')) {
        showToast('일정을 다시 생성하고 있습니다...', 'info');
    }
}

function saveSchedule() {
    // 로그인 체크
    const isLoggedIn = ${not empty sessionScope.loginUser};

    if (!isLoggedIn) {
        sessionStorage.setItem('returnUrl', window.location.href);
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    // 공개여부 선택 모달 표시
    saveScheduleModal.show();
}

function selectVisibility(visibility) {
    selectedVisibility = visibility;

    // 라디오 버튼 업데이트
    var radios = document.querySelectorAll('input[name="visibility"]');
    for (var i = 0; i < radios.length; i++) {
        radios[i].checked = (radios[i].value === visibility);
    }

    // 선택 스타일 업데이트
    var options = document.querySelectorAll('.visibility-option');
    for (var j = 0; j < options.length; j++) {
        options[j].classList.remove('selected');
    }

    var selectedOption = document.querySelector('.visibility-option input[value="' + visibility + '"]');
    if (selectedOption) {
        selectedOption.closest('.visibility-option').classList.add('selected');
    }
}

function confirmSaveSchedule() {
    var visibilityLabels = {
        'public': '전체 공개',
        'private': '비공개'
    };

    // 모달 닫기
    saveScheduleModal.hide();

    // 일정 저장 (실제 구현 시 AJAX)
    showToast('일정이 ' + visibilityLabels[selectedVisibility] + '로 저장되었습니다!', 'success');
    setTimeout(function() {
        window.location.href = '${pageContext.request.contextPath}/schedule/my';
    }, 1500);
}
</script>

<c:set var="pageJs" value="schedule" />
<%@ include file="../common/footer.jsp" %>
