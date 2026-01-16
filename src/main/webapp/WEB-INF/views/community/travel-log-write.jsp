<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="여행기록 작성" />
<c:set var="pageCss" value="community" />
<sec:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_BUSINESS')">
    <script>
        alert('일반회원만 여행기록을 작성할 수 있습니다.');
        location.href = '${pageContext.request.contextPath}/member/login';
    </script>
</sec:authorize>


<%@ include file="../common/header.jsp" %>

<style>
#locationSuggestions .location-item{
  height: 56px;
  box-sizing: border-box;
}
#locationSuggestions{
  max-height: calc(56px * 3);
  overflow-y: auto;
}

#locationSuggestions .location-item i { color: #1abc9c; }
#locationSuggestions .location-item small { color: #6b7280; }
#locationSuggestions .location-item:hover { background: #e8fbf6; }

/* 안내/빈결과 메시지도 동일 톤 */
#locationSuggestions .location-empty {
  padding: 12px;
  color: #6b7280;
}

</style>

<div class="travellog-write-page">
    <div class="travellog-write-container">
            <!-- 헤더 -->
            <div class="travellog-write-header">
                <button type="button" class="btn-back" onclick="goBack()">
                    <i class="bi bi-arrow-left"></i>
                </button>
                <h2>새 여행기록</h2>
                <button type="button" class="btn-submit" id="submitBtn" onclick="submitTravellog()">등록</button>
            </div>

            <div class="travellog-write-body-new">
                <!-- 왼쪽: 블로그 에디터 -->
                <div class="blog-editor-section">
                    <!-- 커버 이미지 -->
                    <div class="cover-image-wrapper" id="coverImageWrapper">
                        <div class="cover-image-placeholder" id="coverPlaceholder" onclick="document.getElementById('coverImageInput').click()">
                            <i class="bi bi-image"></i>
                            <span>커버 이미지 추가</span>
                            <p>여행의 대표 사진을 선택하세요</p>
                        </div>
                        <div class="cover-image-preview" id="coverPreview" style="display: none;">
                            <img src="" alt="커버 이미지" id="coverImg">
                            <div class="cover-image-overlay">
                                <button type="button" class="btn-cover-change" onclick="document.getElementById('coverImageInput').click()">
                                    <i class="bi bi-camera"></i> 변경
                                </button>
                                <button type="button" class="btn-cover-remove" onclick="removeCoverImage()">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>
                        <input type="file" id="coverImageInput" accept="image/*" style="display: none;" onchange="handleCoverImage(event)">
                    </div>

                    <!-- 제목 입력 -->
                    <div class="blog-title-input">
                        <input type="text" id="blogTitle" placeholder="여행 제목을 입력하세요" maxlength="100">
                    </div>

                    <!-- 일정 연결 배너 -->
                    <div class="schedule-link-banner" id="scheduleLinkBanner" onclick="openScheduleModal()">
                        <div class="schedule-link-icon">
                            <i class="bi bi-calendar-check"></i>
                        </div>
                        <div class="schedule-link-content">
                            <span class="schedule-link-title">내 일정 불러오기</span>
                            <span class="schedule-link-desc">저장된 여행 일정을 연결하면 장소 정보가 자동으로 추가됩니다</span>
                        </div>
                        <i class="bi bi-chevron-right"></i>
                    </div>

                    <!-- 연결된 일정 표시 (선택 후) -->
                    <div class="linked-schedule-card" id="linkedScheduleCard" style="display: none;">
                        <div class="linked-schedule-header">
                            <i class="bi bi-calendar-check-fill"></i>
                            <span>연결된 일정</span>
                            <button type="button" class="btn-unlink" onclick="unlinkSchedule()">
                                <i class="bi bi-x-lg"></i>
                            </button>
                        </div>
                        <div class="linked-schedule-body">
                            <h4 id="linkedScheduleTitle">제주도 힐링 여행</h4>
                            <div class="linked-schedule-meta">
                                <span><i class="bi bi-calendar3"></i> <span id="linkedScheduleDates">2024.03.15 - 2024.03.18</span></span>
                                <span><i class="bi bi-geo-alt"></i> <span id="linkedScheduleLocation">제주도</span></span>
                            </div>
                            <div class="linked-schedule-places" id="linkedSchedulePlaces">
                                <!-- 장소 태그들이 여기에 표시됩니다 -->
                            </div>
                        </div>
                    </div>

                    <!-- 블로그 에디터 (블록 기반) -->
                    <div class="blog-editor" id="blogEditor">
                        <!-- 블록들이 여기에 추가됩니다 -->
                        <div class="editor-block text-block" data-block-id="1">
                            <textarea class="block-textarea" placeholder="여행 이야기를 작성하세요..." oninput="autoResize(this)"></textarea>
                        </div>
                    </div>

                    <!-- 블록 추가 버튼 -->
                    <div class="add-block-toolbar">
                        <button type="button" class="add-block-btn" onclick="addTextBlock()">
                            <i class="bi bi-text-paragraph"></i>
                            <span>텍스트</span>
                        </button>
                        <button type="button" class="add-block-btn" onclick="document.getElementById('blockImageInput').click()">
                            <i class="bi bi-image"></i>
                            <span>이미지</span>
                        </button>
                        <button type="button" class="add-block-btn" onclick="addDividerBlock()">
                            <i class="bi bi-hr"></i>
                            <span>구분선</span>
                        </button>
                        <button type="button" class="add-block-btn" onclick="addPlaceBlock()">
                            <i class="bi bi-geo-alt"></i>
                            <span>장소</span>
                        </button>
                        <input type="file" id="blockImageInput" accept="image/*" multiple style="display: none;" onchange="addImageBlocks(event)">
                    </div>
                </div>

                <!-- 오른쪽: 설정 패널 -->
                <div class="settings-panel">
                    <!-- 작성자 정보 -->
                    <%-- <div class="writer-info-card">
                        <div class="writer-avatar">
                            <i class="bi bi-person-fill"></i>
                        </div>
                        <div class="writer-details">
                            <span class="writer-name">${sessionScope.loginUser.userName}</span>
                            <span class="writer-status">여행기록 작성 중</span>
                        </div>
                    </div> --%>

                    <!-- 여행 정보 설정 -->
                    <div class="settings-section">
                        <h3 class="settings-title"><i class="bi bi-info-circle"></i> 여행 정보</h3>

                        <!-- 위치 정보 -->
                        <div class="setting-item" id="locationSettingItem">
                            <div class="setting-icon"><i class="bi bi-geo-alt"></i></div>
                            <div class="setting-content">
                                <span class="setting-label">위치</span>
                                <span class="setting-value" id="locationValue">위치를 추가하세요</span>
                            </div>
                            <i class="bi bi-chevron-right setting-arrow"></i>
                        </div>
                        <div class="setting-input-area" id="locationInputArea">
                            <div class="search-input-wrapper">
                                <i class="bi bi-search"></i>
                                <input type="text" id="locationInput" placeholder="지역 검색" autocomplete="off"
       oninput="onLocationInput(event)"
       oncompositionend="onLocationInput(event)"
       onkeyup="onLocationInput(event)">
                            </div>
                            <div class="location-suggestions" id="locationSuggestions"></div>
                        </div>

                        <!-- 여행 기간 -->
                        <div class="setting-item" onclick="toggleSettingInput('date')">
                            <div class="setting-icon"><i class="bi bi-calendar-event"></i></div>
                            <div class="setting-content">
                                <span class="setting-label">여행 기간</span>
                                <span class="setting-value" id="dateValue">날짜를 선택하세요</span>
                            </div>
                            <i class="bi bi-chevron-right setting-arrow"></i>
                        </div>
                        <div class="setting-input-area" id="dateInputArea">
                            <input type="text" class="form-control date-range-picker" id="travelDateRange" placeholder="여행 기간 선택">
                        </div>

                        <!-- 태그 -->
                        <div class="setting-item" onclick="toggleSettingInput('tag')">
                            <div class="setting-icon"><i class="bi bi-hash"></i></div>
                            <div class="setting-content">
                                <span class="setting-label">태그</span>
                                <span class="setting-value" id="tagValue">태그를 추가하세요</span>
                            </div>
                            <i class="bi bi-chevron-right setting-arrow"></i>
                        </div>
                        <div class="setting-input-area" id="tagInputArea">
                            <input type="text" class="form-control" id="tagInput" placeholder="태그 입력 후 Enter" onkeypress="addTag(event)">
                            <div class="tag-list" id="tagList"></div>
                            <div class="popular-tags">
                                <span class="popular-tag-label">인기 태그</span>
                                <div class="popular-tag-list">
                                    <span class="popular-tag" onclick="addPopularTag('여행스타그램')">#여행스타그램</span>
                                    <span class="popular-tag" onclick="addPopularTag('여행에미치다')">#여행에미치다</span>
                                    <span class="popular-tag" onclick="addPopularTag('국내여행')">#국내여행</span>
                                    <span class="popular-tag" onclick="addPopularTag('제주도')">#제주도</span>
                                    <span class="popular-tag" onclick="addPopularTag('여행사진')">#여행사진</span>
                                    <span class="popular-tag" onclick="addPopularTag('힐링여행')">#힐링여행</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 공개 설정 -->
                    <div class="settings-section">
                        <h3 class="settings-title"><i class="bi bi-shield-check"></i> 공개 설정</h3>

                        <div class="setting-item no-arrow">
                            <div class="setting-icon"><i class="bi bi-globe"></i></div>
                            <div class="setting-content">
                                <span class="setting-label">공개 범위</span>
                            </div>
                            <select class="visibility-select" id="visibility">
                                <option value="public">전체 공개</option>
                                <option value="private">나만 보기</option>
                            </select>
                        </div>

                        <div class="setting-item no-arrow">
                            <div class="setting-icon"><i class="bi bi-map"></i></div>
                            <div class="setting-content">
                                <span class="setting-label">지도에 표시</span>
                                <span class="setting-desc">내 여행 지도에 이 기록을 표시합니다</span>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="showOnMap" checked>
                            </div>
                        </div>

                        <div class="setting-item no-arrow">
                            <div class="setting-icon"><i class="bi bi-chat-dots"></i></div>
                            <div class="setting-content">
                                <span class="setting-label">댓글 허용</span>
                                <span class="setting-desc">다른 사용자가 댓글을 작성할 수 있습니다</span>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="allowComments" checked>
                            </div>
                        </div>
                    </div>

                    <!-- 미리보기 및 저장 -->
                    <div class="settings-actions">
                        <button type="button" class="btn btn-outline w-100 mb-2" onclick="previewTravellog()">
                            <i class="bi bi-eye me-2"></i>미리보기
                        </button>
                       <!--  <button type="button" class="btn btn-secondary w-100 mb-2" onclick="saveDraft()">
                            <i class="bi bi-file-earmark me-2"></i>임시저장
                        </button> -->
                    </div>
                </div>
            </div>
        </div>
</div>

<!-- 일정 선택 모달 -->
<div class="modal fade" id="scheduleModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-calendar-check me-2"></i>내 일정 불러오기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- 필터 탭 -->
                <div class="schedule-modal-tabs">
                    <button class="schedule-modal-tab active" data-filter="all" onclick="filterScheduleModal('all')">전체</button>
                    <button class="schedule-modal-tab" data-filter="completed" onclick="filterScheduleModal('completed')">완료된 여행</button>
                    <button class="schedule-modal-tab" data-filter="upcoming" onclick="filterScheduleModal('upcoming')">예정된 여행</button>
                </div>

                <!-- 일정 목록 -->
                <div class="schedule-modal-list" id="scheduleModalList">
                    <!-- 완료된 여행 - 제주도 (상세 일정 포함) -->
                    <div class="schedule-modal-item" data-status="completed" data-schedule-id="1">
                        <div class="schedule-modal-image">
                            <img src="https://images.unsplash.com/photo-1590650046871-92c887180603?w=120&h=90&fit=crop&q=80" alt="제주도">
                            <span class="schedule-modal-badge completed">완료</span>
                        </div>
                        <div class="schedule-modal-info">
                            <h4>제주도 힐링 여행</h4>
                            <div class="schedule-modal-meta">
                                <span><i class="bi bi-calendar3"></i> 2024.03.15 - 2024.03.18</span>
                                <span><i class="bi bi-geo-alt"></i> 제주도</span>
                            </div>
                            <div class="schedule-modal-places">
                                <span class="place-chip">성산일출봉</span>
                                <span class="place-chip">우도</span>
                                <span class="place-chip">협재해수욕장</span>
                                <span class="place-chip more">+2</span>
                            </div>
                        </div>
                        <div class="schedule-modal-select">
                            <i class="bi bi-check-circle"></i>
                        </div>
                    </div>

                    <!-- 완료된 여행 - 부산 -->
                    <div class="schedule-modal-item" data-status="completed" data-schedule-id="2">
                        <div class="schedule-modal-image">
                            <img src="https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=120&h=90&fit=crop&q=80" alt="부산">
                            <span class="schedule-modal-badge completed">완료</span>
                        </div>
                        <div class="schedule-modal-info">
                            <h4>부산 휴양 여행</h4>
                            <div class="schedule-modal-meta">
                                <span><i class="bi bi-calendar3"></i> 2024.01.10 - 2024.01.14</span>
                                <span><i class="bi bi-geo-alt"></i> 부산</span>
                            </div>
                            <div class="schedule-modal-places">
                                <span class="place-chip">해운대</span>
                                <span class="place-chip">광안리</span>
                                <span class="place-chip">감천문화마을</span>
                            </div>
                        </div>
                        <div class="schedule-modal-select">
                            <i class="bi bi-check-circle"></i>
                        </div>
                    </div>

                    <!-- 예정된 여행 - 강릉 -->
                    <div class="schedule-modal-item" data-status="upcoming" data-schedule-id="3">
                        <div class="schedule-modal-image">
                            <img src="https://images.unsplash.com/photo-1548115184-bc6544d06a58?w=120&h=90&fit=crop&q=80" alt="강릉">
                            <span class="schedule-modal-badge upcoming">D-21</span>
                        </div>
                        <div class="schedule-modal-info">
                            <h4>강릉 맛집 투어</h4>
                            <div class="schedule-modal-meta">
                                <span><i class="bi bi-calendar3"></i> 2024.04.05 - 2024.04.08</span>
                                <span><i class="bi bi-geo-alt"></i> 강릉</span>
                            </div>
                            <div class="schedule-modal-places">
                                <span class="place-chip">정동진</span>
                                <span class="place-chip">경포대</span>
                                <span class="place-chip">주문진</span>
                            </div>
                        </div>
                        <div class="schedule-modal-select">
                            <i class="bi bi-check-circle"></i>
                        </div>
                    </div>

                    <!-- 빈 상태 -->
                    <div class="schedule-modal-empty" id="scheduleModalEmpty" style="display: none;">
                        <i class="bi bi-calendar-x"></i>
                        <p>해당하는 일정이 없습니다</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <a href="${pageContext.request.contextPath}/schedule/search" class="btn btn-secondary">
                    <i class="bi bi-plus-lg me-1"></i>새 일정 만들기
                </a>
            </div>
        </div>
    </div>
</div>

<!-- 장소 추가 모달 -->
<div class="modal fade" id="placeBlockModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-geo-alt me-2"></i>장소 추가</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="search-input-wrapper mb-3">
                    <i class="bi bi-search"></i>
                    <input type="text" id="placeSearchInput" placeholder="장소 이름 검색" onkeyup="searchPlaceForBlock(event)">
                </div>
                <div class="place-search-results" id="placeSearchResults">
                    <div class="place-search-item" onclick="addPlaceToEditor('성산일출봉', '제주 서귀포시 성산읍', 'https://images.unsplash.com/photo-1578469645742-46cae010e5d4?w=300&h=200&fit=crop&q=80')">
                        <img src="https://images.unsplash.com/photo-1578469645742-46cae010e5d4?w=80&h=60&fit=crop&q=80" alt="성산일출봉">
                        <div class="place-search-info">
                            <span class="place-name">성산일출봉</span>
                            <span class="place-address">제주 서귀포시 성산읍</span>
                        </div>
                    </div>
                    <div class="place-search-item" onclick="addPlaceToEditor('협재해수욕장', '제주 제주시 한림읍', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=300&h=200&fit=crop&q=80')">
                        <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=80&h=60&fit=crop&q=80" alt="협재해수욕장">
                        <div class="place-search-info">
                            <span class="place-name">협재해수욕장</span>
                            <span class="place-address">제주 제주시 한림읍</span>
                        </div>
                    </div>
                    <div class="place-search-item" onclick="addPlaceToEditor('우도', '제주 제주시 우도면', 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=300&h=200&fit=crop&q=80')">
                        <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=80&h=60&fit=crop&q=80" alt="우도">
                        <div class="place-search-info">
                            <span class="place-name">우도</span>
                            <span class="place-address">제주 제주시 우도면</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 미리보기 모달 -->
<div class="modal fade" id="previewModal" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-eye me-2"></i>미리보기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-0">
                <div class="preview-container" id="previewContainer">
                    <!-- 미리보기 내용이 여기에 렌더링됩니다 -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">닫기</button>
               <!--  <button type="button" class="btn btn-primary" onclick="submitTravellog()">
                    <i class="bi bi-send me-1"></i>공유하기
                </button> -->
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
let travelStartDate = null; // Date 객체
let travelEndDate = null;   // Date 객체


window.__CTX__ = '${pageContext.request.contextPath}';
window.showToast = window.showToast || function (msg, type) { alert(msg); };
// 블록 ID 카운터
let blockIdCounter = 1;

// 데이터 저장용 변수
let coverImageData = null;
let linkedSchedule = null;
let tags = [];
let selectedLocationName = ''; // 화면 표시용 (RGN_NM)
let selectedLocationCode = ''; // 저장용 (RGN_NO 문자열)
let bodyImageFiles = [];
let __locJustOpened = false;

// 모달 인스턴스
let scheduleModal, placeBlockModal, previewModal;

// 컨텍스트 경로
// const contextPath = '${pageContext.request.contextPath}';

document.addEventListener('DOMContentLoaded', function() {
    // 모달 초기화
    scheduleModal = new bootstrap.Modal(document.getElementById('scheduleModal'));
    placeBlockModal = new bootstrap.Modal(document.getElementById('placeBlockModal'));
    previewModal = new bootstrap.Modal(document.getElementById('previewModal'));

    // Flatpickr 초기화   
    const dateInput = document.getElementById('travelDateRange');
if (dateInput && typeof flatpickr !== 'undefined') {

  // ✅ 이미 다른 곳에서 flatpickr가 붙어있다면 제거
  if (dateInput._flatpickr) {
    dateInput._flatpickr.destroy();
  }

  flatpickr(dateInput, {
    locale: 'ko',
    dateFormat: 'Y-m-d',
    mode: 'range',
    allowInput: true,

    // ✅ 혹시 다른 곳에서 min/max 걸려도 여기서 "해제" 강제
    minDate: null,
    maxDate: null,

    onChange: function(selectedDates, dateStr) {
      if (selectedDates.length === 2) {
        travelStartDate = selectedDates[0];
        travelEndDate = selectedDates[1];
        document.getElementById('dateValue').textContent = dateStr;
      }
    }
  });
}


    // URL 파라미터 체크 (일정에서 넘어온 경우)
    const urlParams = new URLSearchParams(window.location.search);
    const scheduleId = urlParams.get('schedule');
    if (scheduleId) {
        // TODO: 서버에서 일정 정보를 가져와서 자동 연결
        console.log('Schedule ID from URL:', scheduleId);
    }
    
    // ⭐ 여기로 위치 자동완성 init을 넣기
    initLocationAutocomplete();

    // 별점 hover init도 여기로
    initStarRatingHover();

    // datepicker force도 여기로
    initTravelDatePickerForce();
    setTimeout(initTravelDatePickerForce, 0);
    setTimeout(initTravelDatePickerForce, 300);
    
    document.getElementById('locationSettingItem')?.addEventListener('click', function(e){
    	  e.stopPropagation();
    	  toggleSettingInput('location');
    	});

    
});

		function initLocationAutocomplete() {
			  console.log('[loc] init');

			  const input = document.getElementById('locationInput');
			  const box = document.getElementById('locationSuggestions');
			  if (!input || !box) {
			    console.log('[loc] init failed: input/box not found');
			    return;
			  }

			  // ✅ input 기준으로 중복 바인딩 방지
			  if (input.dataset.locBound === '1') {
			    console.log('[loc] already bound (input)');
			    return;
			  }
			  input.dataset.locBound = '1';

			  function handleQuery() {
			    const q = (input.value || '').trim();
			    console.log('[loc] input=', q);
			    debounceFetchRegions(q);
			  }

			  // ✅ focus: 열기
			  input.addEventListener('focus', function () {
			    openLocationSuggestions();
			  }, true);

			  // ✅ 실제 타이핑: input에 직접 바인딩(가장 확실)
			  input.addEventListener('input', function () {
			    handleQuery();
			  }, true);

			  // ✅ 한글 IME 조합 끝
			  input.addEventListener('compositionend', function () {
			    handleQuery();
			  }, true);

			  // ✅ 혹시 input 이벤트가 이상하면 keyup로 보강
			  input.addEventListener('keyup', function (e) {
			    const k = e.key;
			    if (k === 'ArrowUp' || k === 'ArrowDown' || k === 'ArrowLeft' || k === 'ArrowRight' || k === 'Escape' || k === 'Enter') return;
			    handleQuery();
			  }, true);

			  // ESC 닫기
			  input.addEventListener('keydown', function (e) {
			    if (e.key === 'Escape') {
			      closeLocationSuggestions();
			      input.blur();
			    }
			  }, true);

			  // 바깥 클릭 닫기(이건 document가 편함)
			  document.addEventListener('click', function (e) {
			    const inputArea = document.getElementById('locationInputArea');
			    if (!inputArea) return;
			    if (inputArea.style.display !== 'block') return;
			    if (!inputArea.contains(e.target)) {
			      closeLocationSuggestions();
			      inputArea.style.display = 'none';
			    }
			  }, true);

			  console.log('[loc] bound OK (direct input listeners)');
			}



	
	
// 플러스
function collectBlocksForSave() {
  const result = [];
  const blocks = document.querySelectorAll('#blogEditor .editor-block');

  blocks.forEach((block, idx) => {
    const order = idx + 1;

    // TEXT
    if (block.classList.contains('text-block')) {
      result.push({
        type: 'TEXT',
        order,
        text: block.querySelector('textarea')?.value || ''
      });
      return;
    }

    // IMAGE
    if (block.classList.contains('image-block')) {
      result.push({
        type: 'IMAGE',
        order,
        fileIndex: Number(block.dataset.fileIdx), // 여기서 매칭
        desc: block.querySelector('.image-caption')?.value || ''
      });
      return;
    }

    // DIVIDER
    if (block.classList.contains('divider-block')) {
      result.push({ type: 'DIVIDER', order });
      return;
    }

    // DAY_HEADER -> TEXT로 저장(빠른 방식)
    if (block.classList.contains('day-header-block')) {
      const day = block.querySelector('.day-badge')?.textContent?.trim() || '';
      const date = block.querySelector('.day-date')?.textContent?.trim() || '';
      result.push({
        type: 'TEXT',
        order,
        text: (day + ' ' + date).trim()
      });
      return;
    }

    // PLACE  (중요: plcNo가 있어야 DB 저장 가능)
    if (block.classList.contains('place-block')) {
      const rating = block.querySelector('.place-rating')?.dataset?.rating || '0';
      result.push({
        type: 'PLACE',
        order,
        plcNo: block.dataset.plcNo || null,          // ⚠️ 지금 너 코드는 plcNo가 없음
        rating: Number(rating),
        review: block.querySelector('textarea')?.value || ''
      });
      return;
    }
  });

  return result;
}

		

// 커버 이미지 처리
function handleCoverImage(event) {
    const file = event.target.files[0];
    if (!file) return;

    if (file.size > 10 * 1024 * 1024) {
        showToast('이미지 크기는 10MB 이하여야 합니다.', 'error');
        return;
    }

    const reader = new FileReader();
    reader.onload = function(e) {
        coverImageData = {
            file: file,
            dataUrl: e.target.result
        };
        document.getElementById('coverImg').src = e.target.result;
        document.getElementById('coverPlaceholder').style.display = 'none';
        document.getElementById('coverPreview').style.display = 'block';
    };
    reader.readAsDataURL(file);
}

function removeCoverImage() {
    coverImageData = null;
    document.getElementById('coverImg').src = '';
    document.getElementById('coverPlaceholder').style.display = 'flex';
    document.getElementById('coverPreview').style.display = 'none';
    document.getElementById('coverImageInput').value = '';
}

// 텍스트 블록 추가
function addTextBlock() {
    blockIdCounter++;
    const editor = document.getElementById('blogEditor');
    const block = document.createElement('div');
    block.className = 'editor-block text-block';
    block.dataset.blockId = blockIdCounter;
    block.innerHTML =
        '<div class="block-actions">' +
            '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + blockIdCounter + ')"><i class="bi bi-chevron-up"></i></button>' +
            '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + blockIdCounter + ')"><i class="bi bi-chevron-down"></i></button>' +
            '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + blockIdCounter + ')"><i class="bi bi-trash"></i></button>' +
        '</div>' +
        '<textarea class="block-textarea" placeholder="내용을 입력하세요..." oninput="autoResize(this)"></textarea>';
    editor.appendChild(block);
    block.querySelector('textarea').focus();
}

// 이미지 블록 추가
function addImageBlocks(event) {
    const files = Array.from(event.target.files);

    files.forEach(file => {
        if (file.size > 10 * 1024 * 1024) {
            showToast(file.name + ' 파일이 너무 큽니다. (최대 10MB)', 'error');
            return;
        }

        // ✅ 여기 추가 (파일을 전역 배열에 보관)
        bodyImageFiles.push(file);
        
        const fileIdx = bodyImageFiles.length - 1; // 플러스
        

        const reader = new FileReader();
        reader.onload = function(e) {
            blockIdCounter++;
            const currentId = blockIdCounter;
            const editor = document.getElementById('blogEditor');
            const block = document.createElement('div');
            block.className = 'editor-block image-block';
            block.dataset.blockId = currentId;
            
            block.dataset.fileIdx = fileIdx;	// 플러스
            
            block.innerHTML =
                '<div class="block-actions">' +
                    '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + currentId + ')"><i class="bi bi-chevron-up"></i></button>' +
                    '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + currentId + ')"><i class="bi bi-chevron-down"></i></button>' +
                    '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + currentId + ')"><i class="bi bi-trash"></i></button>' +
                '</div>' +
                '<div class="image-block-content">' +
                    '<img src="' + e.target.result + '" alt="업로드 이미지">' +
                '</div>' +
                '<input type="text" class="image-caption" placeholder="사진에 대한 설명을 추가하세요 (선택사항)">';
            editor.appendChild(block);
        };
        reader.readAsDataURL(file);
    });

    // ❗ 이건 유지해도 됨 (input 초기화)
    event.target.value = '';
}


// 구분선 블록 추가
function addDividerBlock() {
    blockIdCounter++;
    const editor = document.getElementById('blogEditor');
    const block = document.createElement('div');
    block.className = 'editor-block divider-block';
    block.dataset.blockId = blockIdCounter;
    block.innerHTML =
        '<div class="block-actions">' +
            '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + blockIdCounter + ')"><i class="bi bi-chevron-up"></i></button>' +
            '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + blockIdCounter + ')"><i class="bi bi-chevron-down"></i></button>' +
            '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + blockIdCounter + ')"><i class="bi bi-trash"></i></button>' +
        '</div>' +
        '<hr class="block-divider">';
    editor.appendChild(block);
}

// 장소 블록 모달 열기
function addPlaceBlock() {
    placeBlockModal.show();
}

// 장소 블록을 에디터에 추가
function addPlaceToEditor(name, address, imageUrl) {
    blockIdCounter++;
    const currentId = blockIdCounter;
    const editor = document.getElementById('blogEditor');
    const block = document.createElement('div');
    block.className = 'editor-block place-block';
    block.dataset.blockId = currentId;
    block.innerHTML =
        '<div class="block-actions">' +
            '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + currentId + ')"><i class="bi bi-chevron-up"></i></button>' +
            '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + currentId + ')"><i class="bi bi-chevron-down"></i></button>' +
            '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + currentId + ')"><i class="bi bi-trash"></i></button>' +
        '</div>' +
        '<div class="place-block-content">' +
            '<img src="' + imageUrl + '" alt="' + name + '">' +
            '<div class="place-block-info">' +
                '<h4><i class="bi bi-geo-alt-fill"></i> ' + name + '</h4>' +
                '<p>' + address + '</p>' +
                '<div class="place-rating" data-block-id="' + currentId + '">' +
                    '<span class="rating-label">별점</span>' +
                    '<div class="star-rating">' +
                        '<i class="bi bi-star" data-rating="1" onclick="setPlaceRating(' + currentId + ', 1)"></i>' +
                        '<i class="bi bi-star" data-rating="2" onclick="setPlaceRating(' + currentId + ', 2)"></i>' +
                        '<i class="bi bi-star" data-rating="3" onclick="setPlaceRating(' + currentId + ', 3)"></i>' +
                        '<i class="bi bi-star" data-rating="4" onclick="setPlaceRating(' + currentId + ', 4)"></i>' +
                        '<i class="bi bi-star" data-rating="5" onclick="setPlaceRating(' + currentId + ', 5)"></i>' +
                    '</div>' +
                    '<span class="rating-value">0.0</span>' +
                '</div>' +
            '</div>' +
        '</div>' +
        '<textarea class="block-textarea" placeholder="이 장소에 대한 이야기를 작성하세요..." oninput="autoResize(this)"></textarea>';
    editor.appendChild(block);
    placeBlockModal.hide();

    block.querySelector('textarea').focus();
}

// 장소 별점 설정
function setPlaceRating(blockId, rating) {
    const ratingContainer = document.querySelector('.place-rating[data-block-id="' + blockId + '"]');
    if (!ratingContainer) return;

    const stars = ratingContainer.querySelectorAll('.star-rating i');
    const ratingValue = ratingContainer.querySelector('.rating-value');

    // 모든 별 초기화
    stars.forEach(function(star, index) {
        if (index < rating) {
            star.classList.remove('bi-star');
            star.classList.add('bi-star-fill');
        } else {
            star.classList.remove('bi-star-fill');
            star.classList.add('bi-star');
        }
    });

    // 별점 값 표시
    ratingValue.textContent = rating + '.0';
    ratingContainer.dataset.rating = rating;
}

// 별점 호버 효과
function initStarRatingHover() {
    document.addEventListener('mouseover', function(e) {
        if (e.target.matches('.star-rating i')) {
            const starRating = e.target.closest('.star-rating');
            const stars = starRating.querySelectorAll('i');
            const hoverRating = parseInt(e.target.dataset.rating);

            stars.forEach(function(star, index) {
                if (index < hoverRating) {
                    star.classList.add('hovered');
                } else {
                    star.classList.remove('hovered');
                }
            });
        }
    });

    document.addEventListener('mouseout', function(e) {
        if (e.target.matches('.star-rating i')) {
            const starRating = e.target.closest('.star-rating');
            const stars = starRating.querySelectorAll('i');
            stars.forEach(function(star) {
                star.classList.remove('hovered');
            });
        }
    });
}

// 초기화 시 호버 효과 등록


// 블록 위로 이동
function moveBlockUp(blockId) {
    const block = document.querySelector('[data-block-id="' + blockId + '"]');
    const prev = block.previousElementSibling;
    if (prev && prev.classList.contains('editor-block')) {
        block.parentNode.insertBefore(block, prev);
    }
}

// 블록 아래로 이동
function moveBlockDown(blockId) {
    const block = document.querySelector('[data-block-id="' + blockId + '"]');
    const next = block.nextElementSibling;
    if (next && next.classList.contains('editor-block')) {
        block.parentNode.insertBefore(next, block);
    }
}

// 블록 삭제
function deleteBlock(blockId) {
    const block = document.querySelector('[data-block-id="' + blockId + '"]');
    if (document.querySelectorAll('.editor-block').length > 1) {
        block.remove();
    } else {
        showToast('최소 하나의 블록이 필요합니다.', 'warning');
    }
}

// 텍스트 영역 자동 크기 조절
function autoResize(textarea) {
    textarea.style.height = 'auto';
    textarea.style.height = textarea.scrollHeight + 'px';
}

// 일정 모달 열기
function openScheduleModal() {
    scheduleModal.show();

    // 일정 아이템 클릭 이벤트 등록
    document.querySelectorAll('.schedule-modal-item').forEach(function(item) {
        item.onclick = function() {
            const scheduleId = item.dataset.scheduleId;
            loadScheduleDetail(scheduleId);
        };
    });
}

// 일정 필터링
function filterScheduleModal(filter) {
    // 탭 활성화
    document.querySelectorAll('.schedule-modal-tab').forEach(function(tab) { tab.classList.remove('active'); });
    document.querySelector('.schedule-modal-tab[data-filter="' + filter + '"]').classList.add('active');

    // 아이템 필터링
    const items = document.querySelectorAll('.schedule-modal-item');
    let visibleCount = 0;

    items.forEach(function(item) {
        if (filter === 'all' || item.dataset.status === filter) {
            item.style.display = 'flex';
            visibleCount++;
        } else {
            item.style.display = 'none';
        }
    });

    // 빈 상태 표시
    document.getElementById('scheduleModalEmpty').style.display = visibleCount === 0 ? 'block' : 'none';
}

// 데모 일정 상세 데이터 (실제로는 서버에서 가져옴)
const scheduleDetailData = {
    1: {
        id: 1,
        title: '제주도 힐링 여행',
        dates: '2024.03.15 - 2024.03.18',
        location: '제주도',
        coverImage: 'https://images.unsplash.com/photo-1590650046871-92c887180603?w=800&h=400&fit=crop&q=80',
        days: [
            {
                day: 1,
                date: '3월 15일 (금)',
                places: [
                    { name: '성산일출봉', address: '제주 서귀포시 성산읍', category: '관광지', image: 'https://images.unsplash.com/photo-1578469645742-46cae010e5d4?w=300&h=200&fit=crop&q=80', startTime: '06:00', endTime: '08:00' },
                    { name: '해녀의집', address: '제주 서귀포시 성산읍', category: '맛집', image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=300&h=200&fit=crop&q=80', startTime: '12:00', endTime: '13:30' },
                    { name: '우도', address: '제주 제주시 우도면', category: '관광지', image: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=300&h=200&fit=crop&q=80', startTime: '14:30', endTime: '18:00' }
                ]
            },
            {
                day: 2,
                date: '3월 16일 (토)',
                places: [
                    { name: '협재해수욕장', address: '제주 제주시 한림읍', category: '관광지', image: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=300&h=200&fit=crop&q=80', startTime: '09:00', endTime: '12:00' },
                    { name: '한림공원', address: '제주 제주시 한림읍', category: '관광지', image: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=300&h=200&fit=crop&q=80', startTime: '14:00', endTime: '17:00' }
                ]
            },
            {
                day: 3,
                date: '3월 17일 (일)',
                places: [
                    { name: '흑돼지거리', address: '제주 제주시 연동', category: '맛집', image: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=300&h=200&fit=crop&q=80', startTime: '12:00', endTime: '14:00' },
                    { name: '동문시장', address: '제주 제주시 동문로', category: '쇼핑', image: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=300&h=200&fit=crop&q=80', startTime: '15:00', endTime: '18:00' }
                ]
            },
            {
                day: 4,
                date: '3월 18일 (월)',
                places: [
                    { name: '제주공항', address: '제주 제주시 공항로', category: '교통', image: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=300&h=200&fit=crop&q=80', startTime: '10:00', endTime: '12:00' }
                ]
            }
        ]
    },
    2: {
        id: 2,
        title: '부산 휴양 여행',
        dates: '2024.01.10 - 2024.01.14',
        location: '부산',
        coverImage: 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=800&h=400&fit=crop&q=80',
        days: [
            {
                day: 1,
                date: '1월 10일 (수)',
                places: [
                    { name: '해운대해수욕장', address: '부산 해운대구', category: '관광지', image: 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=300&h=200&fit=crop&q=80', startTime: '10:00', endTime: '13:00' },
                    { name: '광안리해수욕장', address: '부산 수영구', category: '관광지', image: 'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?w=300&h=200&fit=crop&q=80', startTime: '15:00', endTime: '18:00' }
                ]
            },
            {
                day: 2,
                date: '1월 11일 (목)',
                places: [
                    { name: '감천문화마을', address: '부산 사하구', category: '관광지', image: 'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?w=300&h=200&fit=crop&q=80', startTime: '09:00', endTime: '12:00' },
                    { name: '자갈치시장', address: '부산 중구', category: '시장', image: 'https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a?w=300&h=200&fit=crop&q=80', startTime: '13:00', endTime: '15:00' }
                ]
            },
            {
                day: 3,
                date: '1월 12일 (금)',
                places: [
                    { name: '태종대', address: '부산 영도구', category: '관광지', image: 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=300&h=200&fit=crop&q=80', startTime: '10:00', endTime: '14:00' }
                ]
            }
        ]
    },
    3: {
        id: 3,
        title: '강릉 맛집 투어',
        dates: '2024.04.05 - 2024.04.08',
        location: '강릉',
        coverImage: 'https://images.unsplash.com/photo-1548115184-bc6544d06a58?w=800&h=400&fit=crop&q=80',
        days: [
            {
                day: 1,
                date: '4월 5일 (금)',
                places: [
                    { name: '정동진', address: '강원도 강릉시', category: '관광지', image: 'https://images.unsplash.com/photo-1548115184-bc6544d06a58?w=300&h=200&fit=crop&q=80', startTime: '05:30', endTime: '08:00' },
                    { name: '정동진해변', address: '강원도 강릉시', category: '해변', image: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=300&h=200&fit=crop&q=80', startTime: '09:00', endTime: '11:00' }
                ]
            },
            {
                day: 2,
                date: '4월 6일 (토)',
                places: [
                    { name: '경포대', address: '강원도 강릉시', category: '관광지', image: 'https://images.unsplash.com/photo-1548115184-bc6544d06a58?w=300&h=200&fit=crop&q=80', startTime: '10:00', endTime: '12:30' },
                    { name: '주문진수산시장', address: '강원도 강릉시', category: '시장', image: 'https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a?w=300&h=200&fit=crop&q=80', startTime: '13:00', endTime: '15:00' }
                ]
            },
            {
                day: 3,
                date: '4월 7일 (일)',
                places: [
                    { name: '안목해변커피거리', address: '강원도 강릉시', category: '카페거리', image: 'https://images.unsplash.com/photo-1559496417-e7f25cb247f3?w=300&h=200&fit=crop&q=80', startTime: '14:00', endTime: '17:00' }
                ]
            }
        ]
    }
};

// 일정 상세 로드
function loadScheduleDetail(scheduleId) {
    // 실제로는 AJAX로 서버에서 가져옴
    const schedule = scheduleDetailData[scheduleId];
    if (!schedule) {
        showToast('일정을 불러올 수 없습니다.', 'error');
        return;
    }

    selectSchedule(schedule);
}

// 일정 선택 및 에디터에 내용 추가
function selectSchedule(schedule) {
    linkedSchedule = schedule;

    // 연결된 일정 표시
    document.getElementById('scheduleLinkBanner').style.display = 'none';
    document.getElementById('linkedScheduleCard').style.display = 'block';
    document.getElementById('linkedScheduleTitle').textContent = schedule.title;
    document.getElementById('linkedScheduleDates').textContent = schedule.dates;
    document.getElementById('linkedScheduleLocation').textContent = schedule.location;

    // 장소 표시 (모든 일차의 장소들)
    const allPlaces = [];
    schedule.days.forEach(function(day) {
        day.places.forEach(function(place) {
            if (allPlaces.indexOf(place.name) === -1) {
                allPlaces.push(place.name);
            }
        });
    });
    const placesContainer = document.getElementById('linkedSchedulePlaces');
    const displayPlaces = allPlaces.slice(0, 4);
    let placesHtml = displayPlaces.map(function(place) { return '<span class="place-chip">' + place + '</span>'; }).join('');
    if (allPlaces.length > 4) {
        placesHtml += '<span class="place-chip more">+' + (allPlaces.length - 4) + '</span>';
    }
    placesContainer.innerHTML = placesHtml;

// 위치
document.getElementById('locationValue').textContent = schedule.location;
// selectedLocation = schedule.location;
selectedLocationName = schedule.location;
selectedLocationCode = '';

// 날짜 (schedule.dates: "2024.03.15 - 2024.03.18")
if (schedule.dates && schedule.dates.includes(' - ')) {

  const parts = schedule.dates.split(' - ');
  const startStr = parts[0].trim().replace(/\./g, '-'); // 2024-03-15
  const endStr   = parts[1].trim().replace(/\./g, '-'); // 2024-03-18

  travelStartDate = new Date(startStr);
  travelEndDate   = new Date(endStr);

  console.log('schedule parsed dates =>', travelStartDate, travelEndDate);

  document.getElementById('dateValue').textContent = startStr + ' ~ ' + endStr;

  // flatpickr 동기화
  const fp = document.getElementById('travelDateRange')?._flatpickr;
  if (fp) {
    fp.setDate([travelStartDate, travelEndDate], true);
  }
}

// =================================================


    
//     document.getElementById('dateValue').textContent = schedule.dates;

    // 제목 자동 설정 (비어있는 경우)
    const titleInput = document.getElementById('blogTitle');
    if (!titleInput.value.trim()) {
        titleInput.value = schedule.title + ' 여행기';
    }

    // 커버 이미지 자동 설정 (비어있는 경우)
    if (!coverImageData && schedule.coverImage) {
        document.getElementById('coverImg').src = schedule.coverImage;
        document.getElementById('coverPlaceholder').style.display = 'none';
        document.getElementById('coverPreview').style.display = 'block';
        coverImageData = { dataUrl: schedule.coverImage, fromSchedule: true };
    }

    // 에디터에 일차별 블록 추가
    addScheduleBlocksToEditor(schedule);

    scheduleModal.hide();
    showToast('일정이 연결되었습니다. 각 장소에 여행 이야기를 작성해주세요!', 'success');
}

// 일정 블록들을 에디터에 추가
function addScheduleBlocksToEditor(schedule) {
    const editor = document.getElementById('blogEditor');

    // 기존 첫번째 텍스트 블록이 비어있으면 삭제
    const firstBlock = editor.querySelector('.editor-block');
    if (firstBlock && firstBlock.classList.contains('text-block')) {
        const textarea = firstBlock.querySelector('textarea');
        if (!textarea.value.trim()) {
            firstBlock.remove();
        }
    }

    // 인트로 텍스트 블록 추가
    blockIdCounter++;
    const introBlock = document.createElement('div');
    introBlock.className = 'editor-block text-block';
    introBlock.dataset.blockId = blockIdCounter;
    introBlock.innerHTML =
        '<div class="block-actions">' +
            '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + blockIdCounter + ')"><i class="bi bi-chevron-up"></i></button>' +
            '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + blockIdCounter + ')"><i class="bi bi-chevron-down"></i></button>' +
            '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + blockIdCounter + ')"><i class="bi bi-trash"></i></button>' +
        '</div>' +
        '<textarea class="block-textarea" placeholder="여행을 시작하며... 이번 여행의 계기나 기대했던 점을 적어보세요." oninput="autoResize(this)"></textarea>';
    editor.appendChild(introBlock);

    // 각 일차별로 블록 추가
    schedule.days.forEach(function(day) {
        // 일차 헤더 (구분선 + 제목)
        blockIdCounter++;
        const dayHeaderBlock = document.createElement('div');
        dayHeaderBlock.className = 'editor-block day-header-block';
        dayHeaderBlock.dataset.blockId = blockIdCounter;
        dayHeaderBlock.innerHTML =
            '<div class="block-actions">' +
                '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + blockIdCounter + ')"><i class="bi bi-chevron-up"></i></button>' +
                '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + blockIdCounter + ')"><i class="bi bi-chevron-down"></i></button>' +
                '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + blockIdCounter + ')"><i class="bi bi-trash"></i></button>' +
            '</div>' +
            '<div class="day-header-content">' +
                '<span class="day-badge">DAY ' + day.day + '</span>' +
                '<span class="day-date">' + day.date + '</span>' +
            '</div>';
        editor.appendChild(dayHeaderBlock);

        // 해당 일차의 장소들
        day.places.forEach(function(place) {
            blockIdCounter++;
            const currentId = blockIdCounter;
            const placeBlock = document.createElement('div');
            placeBlock.className = 'editor-block place-block';
            placeBlock.dataset.blockId = currentId;

            // 시간 정보 표시
            var timeInfo = '';
            if (place.startTime && place.endTime) {
                timeInfo = '<div class="place-time-info"><i class="bi bi-clock"></i> ' + place.startTime + ' ~ ' + place.endTime + '</div>';
            }

            placeBlock.innerHTML =
                '<div class="block-actions">' +
                    '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + currentId + ')"><i class="bi bi-chevron-up"></i></button>' +
                    '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + currentId + ')"><i class="bi bi-chevron-down"></i></button>' +
                    '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + currentId + ')"><i class="bi bi-trash"></i></button>' +
                '</div>' +
                '<div class="place-block-content">' +
                    '<img src="' + place.image + '" alt="' + place.name + '">' +
                    '<div class="place-block-info">' +
                        '<h4><i class="bi bi-geo-alt-fill"></i> ' + place.name + '</h4>' +
                        '<p>' + place.address + ' · ' + place.category + '</p>' +
                        timeInfo +
                        '<div class="place-rating" data-block-id="' + currentId + '">' +
                            '<span class="rating-label">별점</span>' +
                            '<div class="star-rating">' +
                                '<i class="bi bi-star" data-rating="1" onclick="setPlaceRating(' + currentId + ', 1)"></i>' +
                                '<i class="bi bi-star" data-rating="2" onclick="setPlaceRating(' + currentId + ', 2)"></i>' +
                                '<i class="bi bi-star" data-rating="3" onclick="setPlaceRating(' + currentId + ', 3)"></i>' +
                                '<i class="bi bi-star" data-rating="4" onclick="setPlaceRating(' + currentId + ', 4)"></i>' +
                                '<i class="bi bi-star" data-rating="5" onclick="setPlaceRating(' + currentId + ', 5)"></i>' +
                            '</div>' +
                            '<span class="rating-value">0.0</span>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
                '<textarea class="block-textarea" placeholder="' + place.name + '에서의 경험을 작성해주세요... 어떤 점이 좋았나요?" oninput="autoResize(this)"></textarea>';
            editor.appendChild(placeBlock);
        });
    });

    // 마무리 텍스트 블록 추가
    blockIdCounter++;
    const outroBlock = document.createElement('div');
    outroBlock.className = 'editor-block text-block';
    outroBlock.dataset.blockId = blockIdCounter;
    outroBlock.innerHTML =
        '<div class="block-actions">' +
            '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + blockIdCounter + ')"><i class="bi bi-chevron-up"></i></button>' +
            '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + blockIdCounter + ')"><i class="bi bi-chevron-down"></i></button>' +
            '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + blockIdCounter + ')"><i class="bi bi-trash"></i></button>' +
        '</div>' +
        '<textarea class="block-textarea" placeholder="여행을 마치며... 이번 여행에서 가장 기억에 남는 순간이나 느낀 점을 적어보세요." oninput="autoResize(this)"></textarea>';
    editor.appendChild(outroBlock);
}

// 일정 연결 해제
function unlinkSchedule() {
    linkedSchedule = null;
    document.getElementById('scheduleLinkBanner').style.display = 'flex';
    document.getElementById('linkedScheduleCard').style.display = 'none';
    showToast('일정 연결이 해제되었습니다.', 'info');
}

// 설정 입력 영역 토글
function toggleSettingInput(type) {
	
    const area = document.getElementById(type + 'InputArea');
    const isVisible = area.style.display === 'block';

    // 모든 입력 영역 닫기
    document.querySelectorAll('.setting-input-area').forEach(function(el) { el.style.display = 'none'; });

    // 클릭한 영역 토글
    if (!isVisible) {
        area.style.display = 'block';
        const input = area.querySelector('input');
        if (input) input.focus();
        
        if (type === 'location') {
        	  initLocationAutocomplete();
        	  __locJustOpened = true;
        	  openLocationSuggestions();
        }
    }
}

// 위치 검색




//====== 위치 자동완성(지역) ======
let regionAbortController = null;
let regionDebounceTimer = null;

// DOMContentLoaded에서 이벤트를 "JS로" 묶어주면 JSP onfocus/oninput 없어도 됨.
// 너는 이미 onfocus/oninput을 걸어놨으니, 아래 init만 추가해도 OK.
async function openLocationSuggestions() {
	  console.log('[loc] open');

	  const input = document.getElementById('locationInput');
	  if (!input) return;

	  const v = (input.value || '').trim();
	  const q = (v && v !== (selectedLocationName || '')) ? v : '';

	  // ✅ 열릴 때(패널 열기 직후)만 한번 select
	  if (__locJustOpened) {
	    __locJustOpened = false;
	    input.select();
	  }

	  await fetchAndRenderRegions(q);
	}

function debounceFetchRegions(query) {
	  if (regionDebounceTimer) clearTimeout(regionDebounceTimer);
	  regionDebounceTimer = setTimeout(function () {
	    fetchAndRenderRegions(query);
	  }, 400);
}

function onLocationInput(e) {
	  const el = e && e.target ? e.target : document.getElementById('locationInput');
	  if (!el) return;

	  const q = (el.value || '').trim();
	  console.log('[loc] input=', q);

	  // 방향키/ESC/ENTER는 keyup에서 걸러주기(옵션)
	  if (e && e.type === 'keyup') {
	    const k = e.key;
	    if (k === 'ArrowUp' || k === 'ArrowDown' || k === 'ArrowLeft' || k === 'ArrowRight' || k === 'Escape' || k === 'Enter') return;
	  }

	  debounceFetchRegions(q);
	}


// 실제 호출 + 렌더
async function fetchAndRenderRegions(query) {
	
	console.log('[loc] base=', window.__CTX__);
	const url = window.__CTX__ + '/api/regions?keyword=' + encodeURIComponent(query || '') + '&size=10';
	console.log('[loc] url=', url);
	
	console.log('[loc] fetch query=', query);
  const suggestions = document.getElementById('locationSuggestions');
  if (!suggestions) return;
//base는 ''(루트)일 수도 있으니 체크하지 않는다
const base = (window.__CTX__ ?? '');

if (!suggestions) return;  

  suggestions.style.display = 'block';

  // 이전 요청 취소
  if (regionAbortController) regionAbortController.abort();
  regionAbortController = new AbortController();

  try {
    const url = base + '/api/regions?keyword=' + encodeURIComponent(query || '') + '&size=10';

    const res = await fetch(url, {
      method: 'GET',
      credentials: 'include',
      signal: regionAbortController.signal
    });
    
    console.log('[loc] res status=', res.status);

    if (!res.ok) throw new Error('지역 검색 실패');

    const list = await res.json();

    console.log('[loc] list len=', Array.isArray(list)? list.length : 'not array', list);
    
    // 목록 비우고 시작
    suggestions.innerHTML = '';

    // 결과 없을 때
    if (!Array.isArray(list) || list.length === 0) {
      const msg = document.createElement('div');
      msg.className = 'location-empty';

      if (!query || query.length === 0) {
        // 포커스 시 기본목록이 비는 경우: "없음" 대신 안내문만
        msg.textContent = '지역을 입력하면 목록이 표시됩니다';
      } else {
        msg.textContent = '검색 결과가 없습니다';
      }

      suggestions.appendChild(msg);
      suggestions.style.display = 'block';
      return;
    }

    // 결과 렌더: innerHTML 문자열로 만들지 말고 DOM으로 만들기(안전/EL 충돌 없음)
    for (let i = 0; i < list.length; i++) {
      const r = list[i] || {};
      const nm = (r.rgnNm || '').toString();
      const sub = (r.rgnDetail || '').toString();
      const no = (r.rgnNo == null ? '' : String(r.rgnNo));

      const item = document.createElement('div');
      item.className = 'location-item';
      item.setAttribute('data-no', no);

      const icon = document.createElement('i');
      icon.className = 'bi bi-geo-alt';

      const span = document.createElement('span');
      span.textContent = nm;

      if (sub && sub.length > 0) {
        const small = document.createElement('small');
        small.style.opacity = '0.7';
        small.textContent = ' (' + sub + ')';
        span.appendChild(small);
      }

      item.appendChild(icon);
      item.appendChild(span);

      item.addEventListener('click', function () {
        selectRegionItem(no, nm);
      });

      suggestions.appendChild(item);
    }

    suggestions.style.display = 'block';

  } catch (e) {
    // abort는 정상 흐름
    if (e && e.name === 'AbortError') return;

    console.error(e);
    suggestions.innerHTML = '';
    suggestions.style.display = 'none';
  }
}

function closeLocationSuggestions() {
  const suggestions = document.getElementById('locationSuggestions');
  if (!suggestions) return;
  suggestions.innerHTML = '';
  suggestions.style.display = 'none';
}

// 선택 시 처리(너가 이미 쓰던 변수/표시 유지)
function selectRegionItem(rgnNo, rgnNm) {
  selectedLocationCode = String(rgnNo || '');
  selectedLocationName = String(rgnNm || '');

  document.getElementById('locationValue').textContent = selectedLocationName;
  document.getElementById('locationInput').value = selectedLocationName;

  closeLocationSuggestions();
  document.getElementById('locationInputArea').style.display = 'none';
}

// 태그 관리
function addTag(event) {
    if (event.key !== 'Enter') return;
    event.preventDefault();

    const input = document.getElementById('tagInput');
    let tag = input.value.trim().replace('#', '');

    if (!tag) return;

    if (tags.length >= 10) {
        showToast('태그는 최대 10개까지 추가 가능합니다.', 'warning');
        return;
    }

    if (tags.includes(tag)) {
        showToast('이미 추가된 태그입니다.', 'warning');
        return;
    }

    tags.push(tag);
    input.value = '';
    renderTags();
}

function addPopularTag(tag) {
    tag = tag.replace('#', '');

    if (tags.length >= 10) {
        showToast('태그는 최대 10개까지 추가 가능합니다.', 'warning');
        return;
    }

    if (tags.includes(tag)) {
        showToast('이미 추가된 태그입니다.', 'warning');
        return;
    }

    tags.push(tag);
    renderTags();
}

function renderTags() {
    const container = document.getElementById('tagList');
    container.innerHTML = tags.map(function(tag, index) {
        return '<span class="tag-item">#' + tag + '<button type="button" onclick="removeTag(' + index + ')"><i class="bi bi-x"></i></button></span>';
    }).join('');

    if (tags.length > 0) {
        document.getElementById('tagValue').textContent = tags.map(function(t) { return '#' + t; }).join(' ');
    } else {
        document.getElementById('tagValue').textContent = '태그를 추가하세요';
    }
}

function removeTag(index) {
    tags.splice(index, 1);
    renderTags();
}

// 장소 검색 (블록용)
function searchPlaceForBlock(event) {
    const query = event.target.value.trim().toLowerCase();
    const items = document.querySelectorAll('.place-search-item');

    items.forEach(function(item) {
        const name = item.querySelector('.place-name').textContent.toLowerCase();
        item.style.display = name.includes(query) || query === '' ? 'flex' : 'none';
    });
}

// 미리보기
function previewTravellog() {
    const title = document.getElementById('blogTitle').value || '제목 없음';
    const blocks = document.querySelectorAll('.editor-block');

    let contentHtml = '';

    // 커버 이미지
    if (coverImageData) {
        contentHtml += '<div class="preview-cover"><img src="' + coverImageData.dataUrl + '" alt="커버"></div>';
    }

    // 제목
    contentHtml += '<h1 class="preview-title">' + title + '</h1>';

    // 메타 정보
    contentHtml += '<div class="preview-meta">' +
        '<span><i class="bi bi-geo-alt"></i> ' + (selectedLocationName || '위치 미지정') + '</span>' +
        '<span><i class="bi bi-calendar3"></i> ' + document.getElementById('dateValue').textContent + '</span>' +
    '</div>';

    // 연결된 일정
    if (linkedSchedule) {
        contentHtml += '<div class="preview-schedule">' +
            '<i class="bi bi-calendar-check"></i> ' + linkedSchedule.title +
        '</div>';
    }

    // 블록 내용
    blocks.forEach(function(block) {
        if (block.classList.contains('text-block')) {
            const text = block.querySelector('textarea').value;
            if (text) {
                contentHtml += '<p class="preview-text">' + text.replace(/\n/g, '<br>') + '</p>';
            }
        } else if (block.classList.contains('image-block')) {
            const img = block.querySelector('img').src;
            const captionEl = block.querySelector('.image-caption');
            const caption = captionEl ? captionEl.value : '';
            contentHtml += '<figure class="preview-figure">' +
                '<img src="' + img + '" alt="">' +
                (caption ? '<figcaption>' + caption + '</figcaption>' : '') +
            '</figure>';
        } else if (block.classList.contains('divider-block')) {
            contentHtml += '<hr class="preview-divider">';
        } else if (block.classList.contains('day-header-block')) {
            const dayBadge = block.querySelector('.day-badge').textContent;
            const dayDate = block.querySelector('.day-date').textContent;
            contentHtml += '<div class="preview-day-header">' +
                '<span class="preview-day-badge">' + dayBadge + '</span>' +
                '<span class="preview-day-date">' + dayDate + '</span>' +
            '</div>';
        } else if (block.classList.contains('place-block')) {
            const placeImg = block.querySelector('.place-block-content img').src;
            const placeName = block.querySelector('.place-block-info h4').textContent;
            const placeAddress = block.querySelector('.place-block-info p').textContent;
            const placeTextEl = block.querySelector('.block-textarea');
            const placeText = placeTextEl ? placeTextEl.value : '';
            contentHtml += '<div class="preview-place">' +
                '<img src="' + placeImg + '" alt="' + placeName + '">' +
                '<div class="preview-place-info">' +
                    '<h4>' + placeName + '</h4>' +
                    '<p>' + placeAddress + '</p>' +
                '</div>' +
            '</div>';
            if (placeText) {
                contentHtml += '<p class="preview-text">' + placeText.replace(/\n/g, '<br>') + '</p>';
            }
        }
    });

    // 태그
    if (tags.length > 0) {
        contentHtml += '<div class="preview-tags">' + tags.map(function(t) { return '<span>#' + t + '</span>'; }).join(' ') + '</div>';
    }

    document.getElementById('previewContainer').innerHTML = contentHtml;
    previewModal.show();
}

// 폼 데이터 수집
function collectFormData() {
    const blocks = [];
    document.querySelectorAll('.editor-block').forEach(function(block) {
        const blockData = { id: block.dataset.blockId };

        if (block.classList.contains('text-block')) {
            blockData.type = 'text';
            blockData.content = block.querySelector('textarea').value;
        } else if (block.classList.contains('image-block')) {
            blockData.type = 'image';
            blockData.src = block.querySelector('img').src;
            const captionEl = block.querySelector('.image-caption');
            blockData.caption = captionEl ? captionEl.value : '';
        } else if (block.classList.contains('divider-block')) {
            blockData.type = 'divider';
        } else if (block.classList.contains('day-header-block')) {
            blockData.type = 'day-header';
            blockData.day = block.querySelector('.day-badge').textContent;
            blockData.date = block.querySelector('.day-date').textContent;
        } else if (block.classList.contains('place-block')) {
            blockData.type = 'place';
            blockData.name = block.querySelector('.place-block-info h4').textContent;
            blockData.address = block.querySelector('.place-block-info p').textContent;
            blockData.image = block.querySelector('.place-block-content img').src;
            const textareaEl = block.querySelector('.block-textarea');
            blockData.content = textareaEl ? textareaEl.value : '';
        }

        blocks.push(blockData);
    });

    return {
        title: document.getElementById('blogTitle').value,
        coverImage: coverImageData ? coverImageData.dataUrl : null,
        linkedSchedule: linkedSchedule,
        blocks: blocks,
        locationName: selectedLocationName,
        locationCode: selectedLocationCode,
        dateRange: document.getElementById('dateValue').textContent,
        tags: tags,
        visibility: document.getElementById('visibility').value,
        showOnMap: document.getElementById('showOnMap').checked,
        allowComments: document.getElementById('allowComments').checked
    };
}

// 플러스



// 뒤로가기
function goBack() {
	  const blogTitleEl = document.getElementById('blogTitle');
	  const textareaEl = document.querySelector('.editor-block textarea');

	  const hasContent =
	    (blogTitleEl && blogTitleEl.value.trim()) ||
	    coverImageData ||
	    document.querySelectorAll('.editor-block').length > 1 ||
	    (textareaEl && textareaEl.value.trim());

	  if (!hasContent) {
	    window.history.back();
	    return;
	  }

	  Swal.fire({
	    title: '페이지를 나가시겠어요?',
	    text: '작성 중인 내용은 저장되지 않습니다.',
	    icon: 'warning',
	    showCancelButton: true,
	    confirmButtonText: '나가기',
	    cancelButtonText: '취소',
	    reverseButtons: true,
	    confirmButtonColor: '#ef4444',   // 빨간색
	    cancelButtonColor: '#6b7280'
	  }).then((result) => {
	    if (result.isConfirmed) {
	      window.history.back();
	    }
	  });
	}



function getMainStoryText() {
	  // ✅ "여행 이야기를 작성하세요..."가 들어있는 첫 text-block textarea만 사용
	  const firstTextArea = document.querySelector('#blogEditor .text-block textarea');
	  return firstTextArea ? firstTextArea.value.trim() : '';
	}

	function formatDateToYMD(dateObj) {
	  if (!dateObj) return null;
	  const y = dateObj.getFullYear();
	  const m = String(dateObj.getMonth() + 1).padStart(2, '0');
	  const d = String(dateObj.getDate()).padStart(2, '0');
	  return y + '-' + m + '-' + d;
	}

	function isValidDate(d) {
		  return d instanceof Date && !isNaN(d.getTime());
		}

// 제출
function submitTravellog() {

	// fp에서 최신값 다시 동기화
  const fp = document.getElementById('travelDateRange')?._flatpickr;
  if (fp?.selectedDates?.length === 2) {
    travelStartDate = fp.selectedDates[0];
    travelEndDate = fp.selectedDates[1];
  }

  // ✅ Date 객체만 허용
  if (!isValidDate(travelStartDate) || !isValidDate(travelEndDate)) {
    showToast('여행 기간을 선택해주세요.', 'error');
    return;
  }

  // ✅ 제목(이미 있던 필수)
  const titleEl = document.getElementById('blogTitle');
  const title = titleEl.value.trim();
  if (!title) {
    showToast('여행 제목을 입력해주세요.', 'error');
    titleEl.focus();
    return;
  }

  // ✅ 커버 이미지 필수
  // 1) 직접 업로드한 파일이 있는지
  const coverInput = document.getElementById('coverImageInput');
  const hasCoverFile = coverInput?.files?.length > 0;

  // 2) 일정에서 자동 세팅된 coverImageData(이미지 URL)도 인정할지 여부
  //    -> "진짜 업로드만 허용"이면 hasCoverFile만 체크하면 됨
  const hasCoverData = !!(coverImageData && coverImageData.dataUrl);

  if (!hasCoverFile && !hasCoverData) {
    showToast('커버 이미지를 추가해주세요.', 'error');
    // 커버 선택창 열어주기(UX)
    document.getElementById('coverPlaceholder')?.click();
    return;
  }

  if (!selectedLocationCode) {
	  showToast('위치를 선택해주세요.', 'error');
	  toggleSettingInput('location');
	  document.getElementById('locationInput')?.focus();
	  return;
	}

  // ✅ 본문(원하면 유지)
  const mainContent = getMainStoryText();
  if (!mainContent) {
    showToast('여행 이야기를 입력해주세요.', 'error');
    const firstTextArea = document.querySelector('#blogEditor .text-block textarea');
    if (firstTextArea) firstTextArea.focus();
    return;
  }

	  const submitBtn = document.getElementById('submitBtn');
	  submitBtn.disabled = true;
	  submitBtn.textContent = '등록 중...';

	  const base = window.__CTX__;
	  
	  const req = {
	    schdlNo: null,                 // ✅ 일정 연결 지금 안함
	    rcdTitle: title,               // ✅ RCD_TITLE
	    rcdContent: mainContent,       // ✅ RCD_CONTENT (첫 텍스트만)
	    tripDaysCd: null,
	    locCd: selectedLocationCode, // ✅ REGION.RGN_NO를 문자열로 저장
	    
	    // ✅ 날짜는 YYYY-MM-DD 문자열로 보내기 (서버에서 DATE로 변환/매핑)
	    startDt: formatDateToYMD(travelStartDate),
	    endDt: formatDateToYMD(travelEndDate),

	    openScopeCd: document.getElementById('visibility').value === 'public' ? 'PUBLIC' : 'PRIVATE', // ✅ OPEN_SCOPE_CD
	    mapDispYn: document.getElementById('showOnMap').checked ? 'Y' : 'N',      // ✅ MAP_DISP_YN
	    replyEnblYn: document.getElementById('allowComments').checked ? 'Y' : 'N', // ✅ REPLY_ENBL_YN
	    // attachNo는 ✅ 서버가 coverFile 저장 후 생성해서 TRIP_RECORD.ATTACH_NO에 넣는 구조 권장
	    
	    tags: tags
	  };

	  console.log('REQ JSON =>', req);
	  
	  const formData = new FormData();
	  
	  // 플러스
	  // blocks JSON 추가
	  const blocks = collectBlocksForSave();
	  formData.append("blocks", new Blob([JSON.stringify(blocks)], { type:"application/json" }));

	  // 본문 이미지 파일들 추가
	  bodyImageFiles.forEach(f => formData.append("bodyFiles", f));
	  //
	  
	  
	  // 1) JSON req
	  formData.append(
	    "req",
	    new Blob([JSON.stringify(req)], { type: "application/json" })
	  );

	  // 2) 커버 파일 1개
	  const coverFileInput = document.getElementById("coverImageInput");
	  if (coverFileInput && coverFileInput.files && coverFileInput.files.length > 0) {
	    formData.append("coverFile", coverFileInput.files[0]);
	  }

	  fetch(base + '/api/travel-log/records', {
	    method: 'POST',
	    body: formData,
	    credentials: 'include'
	  })
	    .then(res => {
	      if (!res.ok) return res.text().then(t => { throw new Error(t || '등록 실패'); });
	      return res.json(); // rcdNo 받는다고 가정
	    })
	    .then(rcdNo => {
	      showToast('여행기록이 등록되었습니다!', 'success');
	      window.location.href = base + '/community/travel-log/detail?rcdNo=' + rcdNo;
	    })
	    .catch(err => {
	      console.error(err);
	      showToast('여행기록 등록 중 오류가 발생했습니다.', 'error');
	    })
	    .finally(() => {
	      submitBtn.disabled = false;
	      submitBtn.textContent = '등록';
	    });
}

function initTravelDatePickerForce() {
	  const dateInput = document.getElementById('travelDateRange');
	  if (!dateInput || typeof flatpickr === 'undefined') return;

	  // 이미 걸려있는 flatpickr(공통 포함) 제거
	  if (dateInput._flatpickr) {
	    dateInput._flatpickr.destroy();
	  }

	  flatpickr(dateInput, {
	    locale: 'ko',
	    dateFormat: 'Y-m-d',
	    mode: 'range',
	    allowInput: true,

	    // ✅ 과거/미래 모두 허용
	    minDate: null,
	    maxDate: null,
	    disable: [],

	    onChange: function(selectedDates, dateStr) {
	      if (selectedDates.length === 2) {
	        travelStartDate = selectedDates[0];
	        travelEndDate = selectedDates[1];
	        document.getElementById('dateValue').textContent = dateStr;
	      } else {
	        travelStartDate = null;
	        travelEndDate = null;
	        document.getElementById('dateValue').textContent = '날짜를 선택하세요';
	      }
	    }
	  });
	}




</script>

<%@ include file="../common/footer.jsp" %>
