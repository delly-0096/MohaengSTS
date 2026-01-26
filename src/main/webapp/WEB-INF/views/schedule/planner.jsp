<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="일정 계획하기" />
<c:set var="pageCss" value="schedule" />

<%@ include file="../common/header.jsp" %>

<div class="planner-page">
    <!-- 사이드바: 일정 리스트 -->
    <aside class="planner-sidebar">
        <div class="planner-sidebar-header">
            <h1 class="planner-trip-title" id="tripTitle" onclick="openEditSchdlNmModal()">
            	<span class="" id="schdlNm">제주도 여행</span>
            	<span class="budget-edit-icon"><i class="bi bi-pencil"></i></span>
            </h1>
            <p class="planner-trip-dates" id="tripDates">2024.03.15 - 2024.03.18 (3박 4일)</p>

            <!-- 예산 요약 -->
            <div class="budget-summary" onclick="openBudgetModal()">
                <div class="budget-summary-header">
                    <span class="budget-label"><i class="bi bi-wallet2 me-1"></i>여행 예산</span>
                    <span class="budget-edit-icon"><i class="bi bi-pencil"></i></span>
                </div>
                <div class="budget-summary-content">
                    <div class="budget-amount">
                        <span class="budget-spent" id="totalSpent">0</span>
                        <span class="budget-separator">/</span>
                        <span class="budget-total" id="totalBudget">0</span>
                        <span class="budget-unit">원</span>
                    </div>
                    <div class="budget-progress-bar">
                        <div class="budget-progress" id="budgetProgress" style="width: 0%;"></div>
                    </div>
                    <div class="budget-remaining">
                        <span id="budgetRemaining">예산을 설정해주세요</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 탭 -->
        <div class="planner-tabs">
            <button class="planner-tab active" data-tab="itinerary" onclick="switchPlannerTab('itinerary')">
                <i class="bi bi-calendar-check me-1"></i>일정
            </button>
            <button class="planner-tab" data-tab="search" onclick="switchPlannerTab('search')">
                <i class="bi bi-search me-1"></i>장소 검색
            </button>
        </div>

        <!-- 일정 탭 콘텐츠 -->
        <div class="planner-content" id="itineraryContent">
            

            
        </div>

        <!-- 검색 탭 콘텐츠 -->
        <div class="planner-content" id="searchContent" style="display: none;">
            <div class="search-panel">
                <div class="search-input-wrapper">
                    <i class="bi bi-search"></i>
                    <input type="text" id="searchInput" placeholder="장소, 맛집, 관광지 검색..."
                           onfocus="showPlaceAutocomplete()"
                           onkeyup="filterPlaceAutocomplete(this.value)"
                           autocomplete="off">
                    <!-- 자동완성 드롭다운 -->
                    <div class="place-autocomplete-dropdown" id="placeAutocomplete">
                        <div class="autocomplete-section" id="autocomplete-section">
                            <div class="autocomplete-section-title">추천 장소</div>
                            <div class="place-autocomplete-item" onclick="selectPlace(5, '한라산 국립공원', '관광지', 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=80&h=80&fit=crop&q=80')">
                                <div class="place-autocomplete-icon"><i class="bi bi-geo-alt"></i></div>
                                <div class="place-autocomplete-info">
                                    <span class="place-autocomplete-name">한라산 국립공원</span>
                                    <span class="place-autocomplete-category">관광지 · 자연</span>
                                </div>
                            </div>
                            <div class="place-autocomplete-item" onclick="selectPlace(6, '봄날카페', '카페', 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=80&h=80&fit=crop&q=80')">
                                <div class="place-autocomplete-icon cafe"><i class="bi bi-cup-hot"></i></div>
                                <div class="place-autocomplete-info">
                                    <span class="place-autocomplete-name">봄날카페</span>
                                    <span class="place-autocomplete-category">카페 · 오션뷰</span>
                                </div>
                            </div>
                            <div class="place-autocomplete-item" onclick="selectPlace(7, '제주갈치조림', '맛집', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=80&h=80&fit=crop&q=80')">
                                <div class="place-autocomplete-icon restaurant"><i class="bi bi-shop"></i></div>
                                <div class="place-autocomplete-info">
                                    <span class="place-autocomplete-name">제주갈치조림</span>
                                    <span class="place-autocomplete-category">맛집 · 해산물</span>
                                </div>
                            </div>
                            <div class="place-autocomplete-item" onclick="selectPlace(8, '금능해수욕장', '관광지', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=80&h=80&fit=crop&q=80')">
                                <div class="place-autocomplete-icon"><i class="bi bi-water"></i></div>
                                <div class="place-autocomplete-info">
                                    <span class="place-autocomplete-name">금능해수욕장</span>
                                    <span class="place-autocomplete-category">관광지 · 해변</span>
                                </div>
                            </div>
                            <div class="place-autocomplete-item" onclick="selectPlace(9, '성산일출봉', '관광지', 'https://images.unsplash.com/photo-1578469645742-46cae010e5d4?w=80&h=80&fit=crop&q=80')">
                                <div class="place-autocomplete-icon"><i class="bi bi-sunrise"></i></div>
                                <div class="place-autocomplete-info">
                                    <span class="place-autocomplete-name">성산일출봉</span>
                                    <span class="place-autocomplete-category">관광지 · 유네스코</span>
                                </div>
                            </div>
                            <div class="place-autocomplete-item" onclick="selectPlace(10, '협재해수욕장', '관광지', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=80&h=80&fit=crop&q=80')">
                                <div class="place-autocomplete-icon"><i class="bi bi-water"></i></div>
                                <div class="place-autocomplete-info">
                                    <span class="place-autocomplete-name">협재해수욕장</span>
                                    <span class="place-autocomplete-category">관광지 · 해변</span>
                                </div>
                            </div>
                            <div class="place-autocomplete-item" onclick="selectPlace(11, '우도', '관광지', 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=80&h=80&fit=crop&q=80')">
                                <div class="place-autocomplete-icon"><i class="bi bi-geo-alt"></i></div>
                                <div class="place-autocomplete-info">
                                    <span class="place-autocomplete-name">우도</span>
                                    <span class="place-autocomplete-category">관광지 · 섬</span>
                                </div>
                            </div>
                            <div class="place-autocomplete-item" onclick="selectPlace(12, '흑돼지거리', '맛집', 'https://images.unsplash.com/photo-1544025162-d76694265947?w=80&h=80&fit=crop&q=80')">
                                <div class="place-autocomplete-icon restaurant"><i class="bi bi-shop"></i></div>
                                <div class="place-autocomplete-info">
                                    <span class="place-autocomplete-name">흑돼지거리</span>
                                    <span class="place-autocomplete-category">맛집 · 흑돼지</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="search-bar-container">
                    
                    <div class="search-filters">
                        <button class="filter-chip active" data-filter="all" onclick="filterSearch('all')">전체</button>
                        <button class="filter-chip" data-filter="attraction" onclick="filterSearch('attraction')">관광지</button>
                        <button class="filter-chip" data-filter="restaurant" onclick="filterSearch('restaurant')">맛집</button>
                        <button class="filter-chip" data-filter="cafe" onclick="filterSearch('cafe')">카페</button>
                        <button class="filter-chip" data-filter="activity" onclick="filterSearch('activity')">액티비티</button>
                    </div>

                    <div class="search-actions">
                        <button class="filter-region active" onclick="setRegion()">지역관광</button>
                    </div>

                </div>
            </div>

            <div class="search-results" id="searchResults">
                <!-- 검색 결과 -->
                <div class="search-result-item">
                    <img src="https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=80&h=80&fit=crop&q=80"
                         alt="한라산" class="search-result-image">
                    <div class="search-result-content">
                        <h5 class="search-result-name">한라산 국립공원</h5>
                        <span class="search-result-category">관광지 · 자연</span>
                        <div class="search-result-rating">
                            <i class="bi bi-star-fill"></i>
                            <span>4.8</span>
                            <span class="text-muted">(1,234)</span>
                        </div>
                    </div>
                    <button class="search-result-add" onclick="addToItinerary(5, '한라산 국립공원', '관광지')">
                        <i class="bi bi-plus"></i>
                    </button>
                </div>
            </div>
        </div>
    </aside>

    <!-- 지도 영역 -->
    <div class="planner-map" id="map">
        <div class="map-placeholder">
            <i class="bi bi-map"></i>
            <p>지도가 표시됩니다</p>
            <p class="text-muted" style="font-size: 14px;">일정의 장소들이 지도에 표시됩니다</p>
        </div>
    </div>
</div>

<!-- 장소 상세보기 모달 -->
<div class="modal fade" id="placeDetailModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">장소 상세정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="placeDetailBody">
                <!-- 동적 콘텐츠 -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<!-- 일자/시간 선택 모달 -->
<div class="modal fade" id="selectDayModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">일정 추가</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p class="mb-3 text-muted" style="font-size: 14px;">방문 일자와 시간을 선택하세요</p>

                <!-- 일자 선택 -->
                <div class="mb-3">
                    <label class="form-label fw-bold"><i class="bi bi-calendar3 me-1"></i>일자</label>
                    <div class="d-flex gap-2 flex-wrap" id="daySelectButtons">
                        <button class="btn btn-outline time-select-btn active" data-day="1" onclick="selectDay(1)">1일차</button>
                        <button class="btn btn-outline time-select-btn" data-day="2" onclick="selectDay(2)">2일차</button>
                        <button class="btn btn-outline time-select-btn" data-day="3" onclick="selectDay(3)">3일차</button>
                        <button class="btn btn-outline time-select-btn" data-day="4" onclick="selectDay(4)">4일차</button>
                    </div>
                </div>

                <!-- 시간 선택 -->
                <div class="mb-3">
                    <label class="form-label fw-bold"><i class="bi bi-clock me-1"></i>시간</label>
                    <div class="d-flex align-items-center gap-2">
                        <input type="time" class="form-control time-input-modal" id="selectedStartTimeInput" value="09:00">
                        <span class="time-separator-modal">~</span>
                        <input type="time" class="form-control time-input-modal" id="selectedEndTimeInput" value="11:00">
                    </div>
                    <small class="text-muted mt-1 d-block">시작 시간 ~ 종료 시간</small>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="confirmAddPlace()">
                    <i class="bi bi-plus me-1"></i>추가
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 일정 저장 설정 모달 -->
<div class="modal fade" id="saveScheduleModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-bookmark-check me-2"></i>일정 저장</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p class="text-muted mb-4">일정을 저장하기 전에 공개 설정을 선택해주세요.</p>

                <!-- 공개 설정 선택 -->
                <div class="visibility-options">
                    <label class="visibility-option" onclick="selectVisibility('public')">
                        <input type="radio" name="scheduleVisibility" value="public" checked>
                        <div class="visibility-option-content">
                            <div class="visibility-option-icon">
                                <i class="bi bi-globe"></i>
                            </div>
                            <div class="visibility-option-info">
                                <span class="visibility-option-title">전체 공개</span>
                                <span class="visibility-option-desc">모든 사용자가 이 일정을 볼 수 있습니다</span>
                            </div>
                            <div class="visibility-option-check">
                                <i class="bi bi-check-circle-fill"></i>
                            </div>
                        </div>
                    </label>

                    <label class="visibility-option" onclick="selectVisibility('private')">
                        <input type="radio" name="scheduleVisibility" value="private">
                        <div class="visibility-option-content">
                            <div class="visibility-option-icon">
                                <i class="bi bi-lock"></i>
                            </div>
                            <div class="visibility-option-info">
                                <span class="visibility-option-`title`">비공개</span>
                                <span class="visibility-option-desc">나만 이 일정을 볼 수 있습니다</span>
                            </div>
                            <div class="visibility-option-check">
                                <i class="bi bi-check-circle-fill"></i>
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

<!-- 예산 설정 모달 -->
<div class="modal fade" id="budgetModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-wallet2 me-2"></i>예산 설정</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- 총 예산 입력 -->
                <div class="mb-4">
                    <label class="form-label fw-bold"><i class="bi bi-piggy-bank me-1"></i>총 여행 예산</label>
                    <div class="input-group">
                        <input type="text" class="form-control form-control-lg" id="budgetInput"
                               placeholder="예: 500,000" value="" onclick="this.select()">
                        <span class="input-group-text">원</span>
                    </div>
                    <small class="text-muted">숫자만 입력하세요 (예: 500000)</small>
                </div>

                <!-- 빠른 예산 선택 -->
                <div class="mb-4">
                    <label class="form-label fw-bold"><i class="bi bi-lightning me-1"></i>빠른 선택</label>
                    <div class="quick-budget-chips">
                        <button type="button" class="quick-budget-chip" onclick="setQuickBudget(300000)">30만원</button>
                        <button type="button" class="quick-budget-chip" onclick="setQuickBudget(500000)">50만원</button>
                        <button type="button" class="quick-budget-chip" onclick="setQuickBudget(700000)">70만원</button>
                        <button type="button" class="quick-budget-chip" onclick="setQuickBudget(1000000)">100만원</button>
                        <button type="button" class="quick-budget-chip" onclick="setQuickBudget(1500000)">150만원</button>
                        <button type="button" class="quick-budget-chip" onclick="setQuickBudget(2000000)">200만원</button>
                    </div>
                </div>

                <!-- 현재 비용 현황 -->
                <div class="budget-status-box">
                    <h6><i class="bi bi-bar-chart me-1"></i>현재 비용 현황</h6>
                    <div class="budget-status-grid" id="budgetList">
                        <div class="budget-status-item">
                            <span class="status-label">1일차</span>
                            <span class="status-value" id="day1Cost">0원</span>
                        </div>
                        <div class="budget-status-item">
                            <span class="status-label">2일차</span>
                            <span class="status-value" id="day2Cost">0원</span>
                        </div>
                        <div class="budget-status-item">
                            <span class="status-label">3일차</span>
                            <span class="status-value" id="day3Cost">0원</span>
                        </div>
                        <div class="budget-status-item">
                            <span class="status-label">4일차</span>
                            <span class="status-value" id="day4Cost">0원</span>
                        </div>
                    </div>
                    <div class="budget-status-total">
                        <span>총 지출</span>
                        <span id="modalTotalCost">0원</span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="confirmBudget()">
                    <i class="bi bi-check-lg me-1"></i>설정 완료
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 일차 수정 모달 -->
<div class="modal fade" id="editDayModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i><span id="editDayModalTitle">1일차 수정</span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="editingDay" value="">

                <!-- 테마/부제목 입력 -->
                <div class="mb-3">
                    <label class="form-label fw-bold"><i class="bi bi-tag me-1"></i>테마 (선택사항)</label>
                    <input type="text" class="form-control" id="editDayTheme" placeholder="예: 동부 해안 탐방, 맛집 투어, 휴식의 날">
                    <small class="text-muted">이 날의 여행 테마나 부제목을 입력하세요</small>
                </div>

                <!-- 빠른 테마 선택 -->
                <div class="mb-3">
                    <label class="form-label fw-bold"><i class="bi bi-lightning me-1"></i>빠른 테마 선택</label>
                    <div class="quick-theme-chips">
                        <button type="button" class="quick-theme-chip" onclick="setQuickTheme('동부 탐방')">동부 탐방</button>
                        <button type="button" class="quick-theme-chip" onclick="setQuickTheme('서부 드라이브')">서부 드라이브</button>
                        <button type="button" class="quick-theme-chip" onclick="setQuickTheme('맛집 투어')">맛집 투어</button>
                        <button type="button" class="quick-theme-chip" onclick="setQuickTheme('자연 힐링')">자연 힐링</button>
                        <button type="button" class="quick-theme-chip" onclick="setQuickTheme('액티비티')">액티비티</button>
                        <button type="button" class="quick-theme-chip" onclick="setQuickTheme('문화 체험')">문화 체험</button>
                        <button type="button" class="quick-theme-chip" onclick="setQuickTheme('휴식')">휴식</button>
                        <button type="button" class="quick-theme-chip" onclick="setQuickTheme('출발/도착')">출발/도착</button>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="confirmEditDay()">
                    <i class="bi bi-check-lg me-1"></i>적용
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 제목 수정 모달 -->
<div class="modal fade" id="editSchdlNmModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i><span id="editSchdlNmModalTitle">일정명 수정</span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
<!--                 <input type="hidden" id="editingSchdlNm" value=""> -->
                <div class="mb-3">
                    <label class="form-label fw-bold"><i class="bi bi-tag me-1"></i>여행일정 제목</label>
                    <input type="text" class="form-control" id="editingSchdlNm">
                    <small class="text-muted">여행일정의 제목을 입력 해 주세요</small>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="confirmEditSchdlNm()">
                    <i class="bi bi-check-lg me-1"></i>적용
                </button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9976009a2fb2e0385884b79eca12dd63&libraries=services,clusterer"></script>
<script src="${pageContext.request.contextPath}/resources/js/schedule.js"></script>

<script>
//map

let daySelectButtons = document.querySelector("#daySelectButtons")

let selectedItem = null;
let selectDayModal;
let saveScheduleModal;
let editSchdlNmModal
let editDayModal;
let budgetModal;
let selectedDay = 1;
let itemIdCounter = 100; // 새 아이템 ID 생성용
let selectedVisibility = 'public'; // 기본값: 전체 공개
let totalBudget = 0; // 총 예산

let travelDates = "";
let preferenceData = JSON.parse(sessionStorage.getItem('preferenceData') || '{}');

let myMap = "";

let startDt = "";
let endDt = "";
let diffDay = 0;
let duration = 0;
let schdlNm = "";

let searchPage = 1;

const weekdays = ['일', '월', '화', '수', '목', '금', '토'];

const tourContentList = {
    <c:forEach items="${ tourContentList }" var="content">
        ${ content.contentTypeId } : '${ content.contentTypeName }',
    </c:forEach>
};

// 일차 데이터 저장
let dayData = {
    1: { theme: '', date: '' },
    2: { theme: '', date: '' },
    3: { theme: '', date: '' },
    4: { theme: '', date: '' }
};

document.addEventListener('DOMContentLoaded', async function() {
    selectDayModal = new bootstrap.Modal(document.getElementById('selectDayModal'));
    saveScheduleModal = new bootstrap.Modal(document.getElementById('saveScheduleModal'));
    editDayModal = new bootstrap.Modal(document.getElementById('editDayModal'));
    editSchdlNmModal = new bootstrap.Modal(document.getElementById('editSchdlNmModal'));
    budgetModal = new bootstrap.Modal(document.getElementById('budgetModal'));
    
    calculateAllCosts(); // 초기 비용 계산
	
    // 선호도 데이터 로드
    preferenceData = JSON.parse(sessionStorage.getItem('preferenceData') || '{}');
    
    travelDates = preferenceData.travelDates;
    
    initTemplate();
    let destinationcode = preferenceData.destinationcode
    console.log(destinationcode)
    let destinationData = await initDestinationData(destinationcode)
    let tourPlace = initTourPlaceList(destinationcode)
    
    let latitude = destinationData.latitude;
    let longitude = destinationData.longitude;
    
	// 1. 맵 객체 생성 (div id가 'map'이라고 가정)
	myMap = new KakaoMapHelper('map');
	
	myMap.init(latitude, longitude);
	const tourPlaces = [
		{ title: preferenceData.destination, lat: latitude, lng: longitude, id: 1 },
// 	     { title: 'N서울타워', lat: 37.5511, lng: 126.9882, id: 2 },
// 	     { title: '북촌한옥마을', lat: 37.5826, lng: 126.9830, id: 3 }
	];
	tourPlaces.forEach(place => {
	    // 마커 추가 (위도, 경도, 제목, 커스텀데이터)
	    myMap.addMarker(place.lat, place.lng, place.title, { id: place.id });
	});
	
	// 4. 마커가 다 보이도록 지도 줌 레벨 자동 조정
	myMap.fitBounds();
	
	initReturn();
});

// 일자 선택
function selectDay(day) {
    selectedDay = day;
    var buttons = document.querySelectorAll('#daySelectButtons .time-select-btn');
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].classList.remove('active');
    }
    var selectedBtn = document.querySelector('#daySelectButtons .time-select-btn[data-day="' + day + '"]');
    if (selectedBtn) {
        selectedBtn.classList.add('active');
    }
}

// 장소 추가 모달 열기
function openAddPlaceModal(day) {
    selectedDay = day;

    // 일자 버튼 상태 업데이트
    var dayButtons = document.querySelectorAll('#daySelectButtons .time-select-btn');
    for (var i = 0; i < dayButtons.length; i++) {
        dayButtons[i].classList.remove('active');
    }
    var selectedDayBtn = document.querySelector('#daySelectButtons .time-select-btn[data-day="' + day + '"]');
    if (selectedDayBtn) {
        selectedDayBtn.classList.add('active');
    }

    // 기본 시간 설정 (현재 시간 기준 다음 정각)
    var now = new Date();
    var nextHour = now.getHours() + 1;
    if (nextHour > 23) nextHour = 9;
    var defaultStartTime = (nextHour < 10 ? '0' : '') + nextHour + ':00';
    var endHour = nextHour + 2;
    if (endHour > 23) endHour = 23;
    var defaultEndTime = (endHour < 10 ? '0' : '') + endHour + ':00';

    document.getElementById('selectedStartTimeInput').value = defaultStartTime;
    document.getElementById('selectedEndTimeInput').value = defaultEndTime;

    // 검색 탭으로 전환
    switchPlannerTab('search');
}

// 시간 변경 시 아이템 정렬
function updateItemTime(day, itemId, type, newTime) {
    var item = document.querySelector('#day' + day + 'Items [data-item-id="' + itemId + '"]');
    if (item) {
        if (type === 'start') {
            item.dataset.startTime = newTime;
        } else {
            item.dataset.endTime = newTime;
        }
        sortItemsByTime(day);
    }
}

// 시간순 정렬 (시작 시간 기준)
function sortItemsByTime(day) {
    var container = document.getElementById('day' + day + 'Items');
    var items = Array.from(container.querySelectorAll('.planner-item'));

    items.sort(function(a, b) {
        var timeA = a.dataset.startTime || '00:00';
        var timeB = b.dataset.startTime || '00:00';
        return timeA.localeCompare(timeB);
    });

    // 정렬된 순서로 다시 추가
    items.forEach(function(item) {
        container.appendChild(item);
    });
}

function switchPlannerTab(tab) {
    // 모든 탭에서 active 클래스 제거
    var tabs = document.querySelectorAll('.planner-tab');
    for (var i = 0; i < tabs.length; i++) {
        tabs[i].classList.remove('active');
    }

    // 선택한 탭에 active 클래스 추가
    var selectedTab = document.querySelector('.planner-tab[data-tab="' + tab + '"]');
    if (selectedTab) {
        selectedTab.classList.add('active');
    }

    // 콘텐츠 전환
    var itineraryContent = document.getElementById('itineraryContent');
    var searchContent = document.getElementById('searchContent');

    if (tab === 'itinerary') {
        itineraryContent.style.display = 'block';
        searchContent.style.display = 'none';
    } else if (tab === 'search') {
        itineraryContent.style.display = 'none';
        searchContent.style.display = 'block';
    }
}

function filterSearch(filter) {
    // 모든 필터 칩에서 active 클래스 제거
    var chips = document.querySelectorAll('.filter-chip');
    for (var i = 0; i < chips.length; i++) {
        chips[i].classList.remove('active');
    }

    // 선택한 필터에 active 클래스 추가
    var selectedChip = document.querySelector('.filter-chip[data-filter="' + filter + '"]');
    if (selectedChip) {
        selectedChip.classList.add('active');
    }

    // 실제 구현 시 필터링 로직
    if (typeof showToast === 'function') {
        showToast('"' + filter + '" 필터가 적용되었습니다.', 'info');
    }
}

function setRegion() {
    // 모든 필터 칩에서 active 클래스 제거
    var chips = document.querySelector('.filter-region');
    console.log(chips.classList)
    if(chips.classList.contains('active')) {
        chips.classList.remove('active');
        initTourPlaceList(0)
    } else {
        chips.classList.add('active');
        initTourPlaceList(destinationcode)
    }

    // 실제 구현 시 필터링 로직
    if (typeof showToast === 'function') {
        if(chips.classList.contains('active')) {
            showToast('지역관광 필터가 적용되었습니다.', 'info');
        } else {
            showToast('지역관광 필터가 해제되었습니다.', 'info');
        }
    }

    
}

function searchPlaces(keyword) {
    // 실제 구현 시 API 호출
    console.log('Searching for:', keyword);
}

// 장소 자동완성 드롭다운 표시
function showPlaceAutocomplete() {
    var dropdown = document.getElementById('placeAutocomplete');
    if (dropdown) {
        dropdown.classList.add('active');
    }
}

// 장소 자동완성 드롭다운 숨기기
function hidePlaceAutocomplete() {
    var dropdown = document.getElementById('placeAutocomplete');
    if (dropdown) {
        dropdown.classList.remove('active');
    }
}

// 장소 자동완성 필터링
function filterPlaceAutocomplete(keyword) {
    var items = document.querySelectorAll('.place-autocomplete-item');
    var lowerKeyword = keyword.toLowerCase();

    for (var i = 0; i < items.length; i++) {
        var name = items[i].querySelector('.place-autocomplete-name').textContent.toLowerCase();
        var category = items[i].querySelector('.place-autocomplete-category').textContent.toLowerCase();

        if (name.indexOf(lowerKeyword) !== -1 || category.indexOf(lowerKeyword) !== -1 || keyword === '') {
            items[i].style.display = 'flex';
        } else {
            items[i].style.display = 'none';
        }
    }

    // 드롭다운 표시
    showPlaceAutocomplete();
}

// 장소 선택
function selectPlace(id, name, category, latitude, longitude, contentid, contenttypeid) {
    // 입력란에 선택한 장소 이름 표시
    document.getElementById('searchInput').value = name;

    // 드롭다운 숨기기
    hidePlaceAutocomplete();

    // 일정에 추가할 항목 설정
    selectedItem = { id, name, category, latitude, longitude , contentid, contenttypeid};

    // 일자 선택 모달 표시
    selectDayModal.show();
}

// 드롭다운 외부 클릭 시 닫기
document.addEventListener('click', function(e) {
    var dropdown = document.getElementById('placeAutocomplete');
    var input = document.getElementById('searchInput');

    if (dropdown && input) {
        if (!dropdown.contains(e.target) && e.target !== input) {
            hidePlaceAutocomplete();
        }
    }
});

function addToItinerary(id, name, category, latitude, longitude, contentid, contenttypeid) {
    selectedItem = { id, name, category, latitude, longitude , contentid, contenttypeid};
    selectDayModal.show();
}

// 장소 추가 확인 (시간 입력 포함)
function confirmAddPlace() {
    if (!selectedItem) return;
    
    console.log(selectedItem);

    var startTime = document.getElementById('selectedStartTimeInput').value;
    var endTime = document.getElementById('selectedEndTimeInput').value;

    if (!startTime) startTime = '09:00';
    if (!endTime) endTime = '11:00';

    // 종료 시간이 시작 시간보다 이전인 경우 경고
    if (endTime < startTime) {
        showToast('종료 시간은 시작 시간 이후여야 합니다.', 'warning');
        return;
    }

    var itemsContainer = document.getElementById('day' + selectedDay + 'Items');
    if (!itemsContainer) {
        console.error('Container not found');
        return;
    }

    itemIdCounter++;
    var newItemId = itemIdCounter;

    var newItem = document.createElement('div');
    newItem.className = 'planner-item';
    newItem.draggable = true;
    newItem.dataset.itemId = newItemId;
    newItem.dataset.contentid = selectedItem.contentid;
    newItem.dataset.contenttypeid = selectedItem.contenttypeid;
    newItem.dataset.startTime = startTime;
    newItem.dataset.endTime = endTime;
    newItem.dataset.latitude = selectedItem.latitude;
    newItem.dataset.longitude = selectedItem.longitude;
    newItem.dataset.cost = 0;
    newItem.innerHTML =
        '<div class="planner-item-time">' +
            '<input type="time" class="time-input time-start" value="' + startTime + '" onchange="updateItemTime(' + selectedDay + ', ' + newItemId + ', \'start\', this.value)">' +
            '<span class="time-separator">~</span>' +
            '<input type="time" class="time-input time-end" value="' + endTime + '" onchange="updateItemTime(' + selectedDay + ', ' + newItemId + ', \'end\', this.value)">' +
        '</div>' +
        '<div class="planner-item-content">' +
            '<span class="planner-item-name">' + selectedItem.name + '</span>' +
            '<span class="planner-item-category"> ' + selectedItem.category + '</span>' +
        '</div>' +
        '<div class="planner-item-cost">' +
            '<input type="text" class="cost-input" value="0" placeholder="0" onclick="this.select()" onchange="updateItemCost(' + selectedDay + ', ' + newItemId + ', this.value)">' +
            '<span class="cost-unit">원</span>' +
        '</div>' +
        '<div class="planner-item-actions">' +
            '<button onclick="viewItemDetail(' + newItemId + ')"><i class="bi bi-info-circle"></i></button>' +
            '<button onclick="removeItem(' + selectedDay + ', ' + newItemId + ')"><i class="bi bi-trash"></i></button>' +
        '</div>';

    itemsContainer.appendChild(newItem);
    initDragAndDropForItem(newItem);

    // 시간순 정렬
    sortItemsByTime(selectedDay);

    selectDayModal.hide();

    showToast(selectedItem.name + '이(가) ' + selectedDay + '일차 ' + startTime + ' ~ ' + endTime + '에 추가되었습니다.', 'success');

    // 일정 탭으로 전환
    switchPlannerTab('itinerary');

    myMap.addMarker(selectedItem.latitude, selectedItem.longitude, selectedItem.name, { id: selectedItem.id });

	myMap.fitBounds();
	
    selectedItem = null;
}

async function viewItemDetail(itemId) {
	let itemContentId = "";
	let contenttypeId = "";
	
	let plannerItems = $(".planner-items").children();
	
	for(let i = 0; i < plannerItems.length && itemContentId == ""; i++) {
		let plannerItem = $(".planner-items").children().eq(i)
		if(itemId == plannerItem.attr("data-item-id")) {
			itemContentId = plannerItem.attr("data-contentid")
			contenttypeId = plannerItem.attr("data-contenttypeid")
		}
	}
	
    const modal = new bootstrap.Modal(document.getElementById('placeDetailModal'));
    
    document.getElementById('placeDetailBody').innerHTML = `
	    <div class="text-center">
			<div class="spinner-border text-primary" style="width: 10rem; height: 10rem;" role="status">
			  <span class="visually-hidden">Loading...</span>
			</div>
		</div>
	`
	
	modal.show();
	
    let placeItem = await searchPlaceDetail(itemContentId, contenttypeId);
	console.log(placeItem);

	let plcDesc = (placeItem.plcDesc+"").replaceAll(/\\n/g, '<br>');
	console.log("plcDesc:  " + plcDesc)
	let operationHours = (placeItem.operationHours+"").replaceAll(/\\n/g, '<br>');
	let plcPrice = (placeItem.plcPrice+"").replaceAll(/\\n/g, '<br>');
	
    document.getElementById('placeDetailBody').innerHTML =	`
        <div class="text-center">
            <img src="\${placeItem.defaultImg}"
                 alt="\${placeItem.plcNm}" class="w-100 rounded mb-3">

            <h5>\${placeItem.plcNm}</h5>
            <p class="text-muted mb-3">\${placeItem.plcAddr1}</p>
            <p style="white-space: pre-wrap; word-break: break-all;">\${plcDesc}</p>
            <hr>
            <div class="d-flex justify-content-around text-center">
                <div class="col">
                    <i class="bi bi-clock text-primary mb-1" style="font-size: 24px;"></i>
                    <p class="mb-0 small">\${operationHours}</p>
                </div>
                <div class="col">
                    <i class="bi bi-currency-dollar text-primary mb-1" style="font-size: 24px;"></i>
                    <p class="mb-0 small">\${ placeItem.plcPrice ? plcPrice : 'x' }</p>
                </div>
                <div class="col">
                    <i class="bi bi-star-fill text-warning mb-1" style="font-size: 24px;"></i>
                    <p class="mb-0 small">4.7점</p>
                </div>
            </div>
        </div>
    `;
}

function removeItem(day, itemId) {
    var item = document.querySelector('#day' + day + 'Items [data-item-id="' + itemId + '"]');
    if (item && confirm('이 장소를 삭제하시겠습니까?')) {
        item.remove();
        calculateAllCosts(); // 비용 재계산
        showToast('장소가 삭제되었습니다.', 'success');
    }
}

function initDragAndDrop() {
    var containers = document.querySelectorAll('.planner-items');

    for (var i = 0; i < containers.length; i++) {
        (function(container) {
            container.addEventListener('dragover', function(e) {
                e.preventDefault();
                var dragging = document.querySelector('.dragging');
                if (!dragging) return;

                var afterElement = getDragAfterElement(container, e.clientY);

                if (afterElement == null) {
                    container.appendChild(dragging);
                } else {
                    container.insertBefore(dragging, afterElement);
                }
            });
        })(containers[i]);
    }

    var items = document.querySelectorAll('.planner-item');
    for (var j = 0; j < items.length; j++) {
        initDragAndDropForItem(items[j]);
    }
}

function initDragAndDropForItem(item) {
    item.addEventListener('dragstart', function() {
        item.classList.add('dragging');
    });

    item.addEventListener('dragend', function() {
        item.classList.remove('dragging');
    });
}

function getDragAfterElement(container, y) {
    const draggableElements = [...container.querySelectorAll('.planner-item:not(.dragging)')];

    return draggableElements.reduce((closest, child) => {
        const box = child.getBoundingClientRect();
        const offset = y - box.top - box.height / 2;

        if (offset < 0 && offset > closest.offset) {
            return { offset: offset, element: child };
        } else {
            return closest;
        }
    }, { offset: Number.NEGATIVE_INFINITY }).element;
}

function saveSchedule() {
    const isLoggedIn = ${not empty sessionScope.loginMember};
	console.log("${sessionScope}")
	console.log("${sessionScope.loginMember}")
    if (!isLoggedIn) {
        sessionStorage.setItem('returnUrl', window.location.href);
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {

			let tempPlanDataList = new Array;
            let tempPlanData = new Array;

            let plannerDayList = document.querySelectorAll(".planner-day");
            
            let plannerItems = document.querySelectorAll(".planner-item");

            let tempSchdlTitles = [];

            plannerDayList.forEach(dayItem => {
                let day = dayItem.dataset.day;
                let dayTheme = dayItem.querySelector(".planner-day-theme").innerText;
                
                tempSchdlTitles.push({ day: day, title: dayData[day].theme });
            });

            sessionStorage.setItem('tempSchdlTitles', JSON.stringify(tempSchdlTitles));

            plannerItems.forEach(item => {
                let parentItem = item.closest(".planner-day");
                let day = parentItem.dataset.day;
                let itemId = item.dataset.itemId;
                let contentid = item.dataset.contentid;
                let contenttypeid = item.dataset.contenttypeid;
                let startTime = item.dataset.startTime;
                let endTime = item.dataset.endTime;
                let cost = item.dataset.cost;
                let latitude = item.dataset.latitude;
                let longitude = item.dataset.longitude;
                let itemName = item.querySelector(".planner-item-name").innerText;
                let itemCategory = item.querySelector(".planner-item-category").innerText;

                tempPlanData = {
                    day : day,
                    itemId : itemId,
                    contentid : contentid,
                    contenttypeid : contenttypeid,
                    startTime : startTime,
                    endTime : endTime,
                    cost : cost,
                    itemName : itemName,
                    itemCategory : itemCategory,
                    latitude : latitude,
                    longitude : longitude,
                }

                tempPlanDataList.push(tempPlanData);
            });

            console.log(tempPlanDataList);

        	sessionStorage.setItem('tempPlanDataList', JSON.stringify(tempPlanDataList));
        	sessionStorage.setItem('tempSchdlNm', schdlNm);

            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        // return;
    }

    // 공개 설정 모달 표시
    saveScheduleModal.show();
}

// 공개 설정 선택
function selectVisibility(visibility) {
    selectedVisibility = visibility;

    // 라디오 버튼 체크
    var radios = document.querySelectorAll('input[name="scheduleVisibility"]');
    radios.forEach(function(radio) {
        radio.checked = (radio.value === visibility);
    });

    // 선택된 옵션 스타일 업데이트
    var options = document.querySelectorAll('.visibility-option');
    options.forEach(function(option) {
        var radio = option.querySelector('input[type="radio"]');
        if (radio.value === visibility) {
            option.classList.add('selected');
        } else {
            option.classList.remove('selected');
        }
    });
}

// 일정 저장 확인
// function confirmSaveSchedule() {
//     var visibilityLabels = {
//         'public': '전체 공개',
//         'private': '비공개'
//     };

//     // 일정 저장 (실제 구현 시 AJAX)
//     console.log('저장 설정:', selectedVisibility);

//     saveScheduleModal.hide();
//     showToast('일정이 ' + visibilityLabels[selectedVisibility] + '로 저장되었습니다!', 'success');

//     setTimeout(function() {
//         window.location.href = '${pageContext.request.contextPath}/schedule/my';
//     }, 1500);
// }

function confirmSaveSchedule() {
    // 1. Master 데이터 추출 (TRIP_SCHEDULE 매핑)
    const masterData = {
    	schdlNm : schdlNm,
        schdlStartDt: startDt, // 시작일 (YYYY-MM-DD)
        schdlEndDt: endDt,     // 종료일
        totalBudget: totalBudget,
        publicYn: selectedVisibility === 'public' ? 'Y' : 'N',
        aiRecomYn : 'N',
        prefNo: preferenceData.prefNo || null, // 선호도 번호가 있다면
        startPlaceId : preferenceData.departurecode,
        targetPlaceId : preferenceData.destinationcode,
        travelerCount : preferenceData.travelerCount,
        details: [] // 상세 일차 데이터를 담을 배열
    };

    // 2. 일차별 데이터 및 장소 데이터 추출 (DETAILS & PLACE 매핑)
    for (let d = 1; d <= duration; d++) {
        const dayInfo = dayData[d] || {};
        
        const detailObj = {
            schdlDt: d,                         // 1일차, 2일차...
            schdlTitle: dayInfo.theme, // 일차별 테마
            places: []                          // 해당 일차의 장소들
        };

        // 해당 일차의 장소 아이템들 수집
        const items = document.querySelectorAll('#day' + d + 'Items .planner-item');
        items.forEach((item, index) => {
            detailObj.places.push({
                placeId: item.dataset.contentid,        // PLACE_ID
                placeType: item.dataset.contenttypeid,  // PLACE_TYPE
                placeStartTime: item.dataset.startTime, // 방문시간
                placeEndTime: item.dataset.endTime,     // 방문종료시간
                placeOrder: index + 1,                  // 순서 (순차적으로)
                // DB에는 없지만 필요시 전달할 추가 정보
                plcNm: item.querySelector('.planner-item-name').innerText,
                planCost: item.dataset.cost.replace(/[^0-9]/g, '')
            });
        });

        masterData.details.push(detailObj);
    }

    // 데이터 유효성 검사
    if (masterData.details.every(d => d.places.length === 0)) {
        showToast('최소 하나 이상의 장소를 추가해야 저장 가능합니다.', 'warning');
        return;
    }

    // 3. 서버 전송 (AJAX)
    fetch('${pageContext.request.contextPath}/schedule/insert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(masterData)
    })
    .then(response => response.json())
    .then(res => {
        if (res > 0 || res.status === 'success') {
            showToast('일정이 안전하게 저장되었습니다!', 'success');
            
            // 성공 시 세션 스토리지 정리 (앞서 질문하신 특정 아이템 삭제)
            sessionStorage.removeItem('tempPlanDataList');
            sessionStorage.removeItem('tempSchdlNm');
            setTimeout(() => {
                window.location.href = '${pageContext.request.contextPath}/schedule/my';
            }, 1000);
        } else {
            showToast('저장 중 오류가 발생했습니다.', 'danger');
        }
    })
    .catch(err => {
        console.error('Save Error:', err);
        showToast('서버 통신 실패', 'danger');
    });
}

// 여행일정명 수정 모달 열기
function openEditSchdlNmModal() {
console.log(schdlNm);
    document.getElementById('editingSchdlNm').value = schdlNm;
    document.getElementById('editSchdlNmModalTitle').textContent = '여행일정 제목 수정';

    // 현재 테마 불러오기
//     var currentTheme = dayData[day].theme || '';
//     document.getElementById('editSchdlNm').value = currentTheme;

    editSchdlNmModal.show();
}

// 일차 수정 모달 열기
function openEditDayModal(day) {
    document.getElementById('editingDay').value = day;
    document.getElementById('editDayModalTitle').textContent = day + '일차 수정';

    // 현재 테마 불러오기
    var currentTheme = dayData[day].theme || '';
    document.getElementById('editDayTheme').value = currentTheme;

    editDayModal.show();
}

// 빠른 테마 선택
function setQuickTheme(theme) {
    document.getElementById('editDayTheme').value = theme;

    // 선택된 칩 강조
    var chips = document.querySelectorAll('.quick-theme-chip');
    for (var i = 0; i < chips.length; i++) {
        chips[i].classList.remove('active');
        if (chips[i].textContent === theme) {
            chips[i].classList.add('active');
        }
    }
}

//여행일정 제목 수정 확인
function confirmEditSchdlNm() {
    var day = parseInt(document.getElementById('editingDay').value);
    var theme = document.getElementById('editDayTheme').value.trim();

    // 데이터 저장
    schdlNm = document.getElementById('editingSchdlNm').value;

    // 표시 업데이트
    document.getElementById('schdlNm').innerText = schdlNm;
    
    editSchdlNmModal.hide();
    showToast('여행일정 제목이 수정되었습니다.', 'success');
}

// 일차 수정 확인
function confirmEditDay() {
    var day = parseInt(document.getElementById('editingDay').value);
    var theme = document.getElementById('editDayTheme').value.trim();

    // 데이터 저장
    dayData[day].theme = theme;

    // 테마 표시 업데이트
    var themeElement = document.getElementById('dayTheme' + day);
    if (themeElement) {
        if (theme) {
            themeElement.textContent = '- ' + theme;
            themeElement.style.display = 'inline';
        } else {
            themeElement.textContent = '';
            themeElement.style.display = 'none';
        }
    }

    editDayModal.hide();
    showToast(day + '일차 정보가 수정되었습니다.', 'success');
}

// ===== 예산 관련 함수 =====

// 예산 모달 열기
function openBudgetModal() {
    document.getElementById('budgetInput').value = totalBudget > 0 ? totalBudget.toLocaleString() : '';
    updateModalCostDisplay();
    budgetModal.show();
}

// 빠른 예산 선택
function setQuickBudget(amount) {
    document.getElementById('budgetInput').value = amount.toLocaleString();

    // 선택된 칩 강조
    var chips = document.querySelectorAll('.quick-budget-chip');
    chips.forEach(function(chip) {
        chip.classList.remove('active');
        if (parseInt(chip.textContent.replace(/[^0-9]/g, '')) * 10000 === amount) {
            chip.classList.add('active');
        }
    });
}

// 예산 설정 확인
function confirmBudget() {
    var inputValue = document.getElementById('budgetInput').value;
    var numericValue = parseInt(inputValue.replace(/[^0-9]/g, '')) || 0;

    totalBudget = numericValue;
    updateBudgetDisplay();

    budgetModal.hide();
    showToast('예산이 ' + numericValue.toLocaleString() + '원으로 설정되었습니다.', 'success');
}

// 예산 표시 업데이트
function updateBudgetDisplay() {
    var totalSpent = calculateTotalSpent();
    var remaining = totalBudget - totalSpent;
    var percentage = totalBudget > 0 ? (totalSpent / totalBudget * 100) : 0;

    document.getElementById('totalSpent').textContent = totalSpent.toLocaleString();
    document.getElementById('totalBudget').textContent = totalBudget.toLocaleString();

    var progressBar = document.getElementById('budgetProgress');
    progressBar.style.width = Math.min(percentage, 100) + '%';

    // 예산 초과 시 빨간색
    if (percentage > 100) {
        progressBar.style.background = 'linear-gradient(90deg, #ef4444, #dc2626)';
    } else if (percentage > 80) {
        progressBar.style.background = 'linear-gradient(90deg, #f59e0b, #d97706)';
    } else {
        progressBar.style.background = 'linear-gradient(90deg, var(--primary-color), var(--secondary-color))';
    }

    var remainingElement = document.getElementById('budgetRemaining');
    if (totalBudget === 0) {
        remainingElement.textContent = '예산을 설정해주세요';
        remainingElement.className = '';
    } else if (remaining >= 0) {
        remainingElement.textContent = '남은 예산: ' + remaining.toLocaleString() + '원';
        remainingElement.className = 'text-success';
    } else {
        remainingElement.textContent = '예산 초과: ' + Math.abs(remaining).toLocaleString() + '원';
        remainingElement.className = 'text-danger';
    }
}

// 모달 내 비용 현황 표시
function updateModalCostDisplay() {
    for (var day = 1; day <= duration; day++) {

        var dayCost = calculateDayCost(day);
        document.getElementById('day' + day + 'Cost').textContent = dayCost.toLocaleString() + '원';
    }
    document.getElementById('modalTotalCost').textContent = calculateTotalSpent().toLocaleString() + '원';
}

// 총 지출 계산
function calculateTotalSpent() {
    var total = 0;
    for (var day = 1; day <= duration; day++) {
        total += calculateDayCost(day);
    }
    return total;
}

// 일차별 비용 계산
function calculateDayCost(day) {
    var items = document.querySelectorAll('#day' + day + 'Items .planner-item');
    var total = 0;

    items.forEach(function(item) {
        var cost = parseInt(item.dataset.cost) || 0;
        total += cost;
    });

    return total;
}

// 모든 비용 계산 및 표시 업데이트
function calculateAllCosts() {
    updateBudgetDisplay();
}

// 아이템 비용 업데이트
function updateItemCost(day, itemId, value) {
    var numericValue = parseInt(value.replace(/[^0-9]/g, '')) || 0;
    var item = document.querySelector('#day' + day + 'Items [data-item-id="' + itemId + '"]');

    if (item) {
        item.dataset.cost = numericValue;

        // 입력 필드 값 포맷팅
        var input = item.querySelector('.cost-input');
        if (input) {
            input.value = numericValue.toLocaleString();
        }
    }

    calculateAllCosts();
}

async function initDestinationData(destinationcode) {
	const response = await fetch("/schedule/common/searchRegion?rgnNo="+destinationcode)
	
	const dataList = await response.json();
	
	return dataList;
}

async function initTourPlaceList(areaCode) {
	const response = await fetch("/schedule/common/initTourPlaceList",{
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            areaCode : areaCode,
            page : 1
        })
    })
	
	const dataList = await response.json();
	
	let items = dataList.response.body.items.item;
	
	let placeData = "";

	let outputCnt = 0;
	
	for(let i = 0; i < items.length && outputCnt < 15; i++) {
		let tourPlace = items[i];
		
		if(tourPlace.firstimage) {
			placeData += `
		        <div class="search-result-item" data-contentid="\${tourPlace.contentid}">
		        <img src="\${ tourPlace.firstimage }"
		             alt="\${ tourPlace.title }" class="search-result-image">
		        <div class="search-result-content">
		            <h5 class="search-result-name">\${ tourPlace.title }</h5>
		            <span class="search-result-category">\${getContentTypeName(tourPlace.contenttypeid)} · 자연</span>
		            <div class="search-result-rating">
		                <i class="bi bi-star-fill"></i>
		                <span>4.8</span>
		                <span class="text-muted">(1,234)</span>
		            </div>
		        </div>
		        <button class="search-result-add" onclick="addToItinerary(\${tourPlace.contentid}, '\${ tourPlace.title }', '\${getContentTypeName(tourPlace.contenttypeid)}', '\${ tourPlace.mapy }', '\${ tourPlace.mapx }', '\${ tourPlace.contentid }', '\${ tourPlace.contenttypeid }')">
		            <i class="bi bi-plus"></i>
		        </button>
		    </div>
			`;
			
			outputCnt++;
		}
	}
	
	$("#searchResults").html(placeData);
	searchPage = 1;
	return dataList;
}

async function searchPlaceDetail(contentId, contenttypeId) {
	const response = await fetch("/schedule/common/searchPlaceDetail?contentId="+contentId+"&contenttypeId="+contenttypeId);
	
	const dataList = await response.json();
	console.log(dataList)
	
	return dataList;
}

// 비용 입력 포맷팅 (숫자만, 쉼표 추가)
document.addEventListener('input', function(e) {
    if (e.target.classList.contains('cost-input') || e.target.id === 'budgetInput') {
        var value = e.target.value.replace(/[^0-9]/g, '');
        if (value) {
            e.target.value = parseInt(value).toLocaleString();
        }
    }
});

function initTemplate() {
	//당일치기인지 체크
    if(travelDates.length > 10) {
        travelDates = travelDates.replaceAll("~", "");
        travelDates = travelDates.replaceAll("  ", " ");
        
        startDt = travelDates.split(" ")[0];
        endDt = travelDates.split(" ")[1];
    } else {
        startDt = travelDates;
        endDt = travelDates;
    }
    
    diffDay = getDaysDiff(startDt, endDt);
    duration = diffDay + 1;
    
    let plannerDay = "";
    let selectBtnList = "";
    let budgetListData = "";
    
    for(let i = 0; i < duration; i++) {
		let dDay = i + 1;
        dayData[dDay] = {
            theme: '',
            date: ''
        }; // 일차별 데이터 초기화
    	let durDate = new Date(startDt);
    	durDate.setDate(durDate.getDate() + i);
    	let shortWeekday = new Intl.DateTimeFormat('ko-KR', { weekday: 'short' }).format(durDate);
    	let dDateMonth = durDate.getMonth() + 1;
    	let dDateDay = durDate.getDate();
    	
    	plannerDay += `
    		<div class="planner-day" data-day="\${dDay}">
            <div class="planner-day-header" onclick="openEditDayModal(\${dDay})">
                <div class="planner-day-header-content">
                    <span class="planner-day-title" id="dayTitle\${dDay}">\${dDay}일차</span>
                    <span class="planner-day-theme" id="dayTheme\${dDay}"></span>
                </div>
                <span class="planner-day-date" id="dayDate\${dDay}">\${dDateMonth}월 \${dDateDay}일 (\${shortWeekday})</span>
                <i class="bi bi-pencil planner-day-edit-icon"></i>
            </div>
            <div class="planner-items" id="day\${dDay}Items">
				
            </div>
            <button class="add-place-btn" onclick="openAddPlaceModal(\${dDay})" style="margin-top: 8px; padding: 10px;">
                <i class="bi bi-plus"></i> 장소 추가
            </button>
        </div>
        `
    	selectBtnList += `
    		<button class="btn btn-outline time-select-btn \${ dDay == 1 ? 'active' : '' }" data-day="\${dDay}" onclick="selectDay(\${dDay})">\${dDay}일차</button>
    	`
    	
   	    budgetListData += `
            <div class="budget-status-item">
            <span class="status-label">\${dDay}일차</span>
            <span class="status-value" id="day\${dDay}Cost">0원</span>
        </div>
   	    `
    }
    
    plannerDay += `
        <div class="mt-4">
            <button class="btn btn-primary w-100" onclick="saveSchedule()">
                <i class="bi bi-bookmark me-2"></i>일정 담기
            </button>
        </div>
    `
     
    $("#budgetList").html(budgetListData);
    $("#itineraryContent").html(plannerDay);
    daySelectButtons.innerHTML = selectBtnList;
    
    initDragAndDrop();
    
    //제목 작성
    if (preferenceData.destination) {
        document.getElementById('schdlNm').textContent = preferenceData.destination + ' 여행';
        schdlNm = preferenceData.destination + ' 여행';
    }
    //여행기간 작성
    if (preferenceData.travelDates) {
        document.getElementById('tripDates').textContent = preferenceData.travelDates;
    }
    
}

function initReturn() {
	let tempPlanDataList = sessionStorage.getItem("tempPlanDataList");
	let tempSchdlNm = sessionStorage.getItem("tempSchdlNm");
    let tempSchdlTitles = sessionStorage.getItem("tempSchdlTitles");
	
	let planDataList = JSON.parse(tempPlanDataList);
	let tempSchdlTitleList = JSON.parse(tempSchdlTitles);

    console.log(tempSchdlTitleList);

    for(let i = 0; i <= tempSchdlTitleList.length-1; i++) {
        let day = tempSchdlTitleList[i].day;
        let theme = tempSchdlTitleList[i].title;
        console.log(theme);
        
        if(theme != '') {
            $("#dayTheme"+day).text("- " + theme);
        }
    }

	if(planDataList && planDataList.length > 0) {
		document.querySelector("#schdlNm").innerText = tempSchdlNm;
		
		schdlNm = tempSchdlNm;
		planDataList.forEach(item => {
            console.log(item)
			itemIdCounter++;
		    var newItemId = itemIdCounter;
		    var newItem = document.createElement('div');
		    
		    newItem.className = 'planner-item';
		    newItem.draggable = true;
		    newItem.dataset.itemId = item.itemId;
		    newItem.dataset.contentid = item.contentid;
		    newItem.dataset.contenttypeid = item.contenttypeid;
		    newItem.dataset.startTime = item.startTime;
		    newItem.dataset.endTime = item.endTime;
		    newItem.dataset.latitude = item.latitude;
		    newItem.dataset.longitude = item.longitude;
		    newItem.dataset.cost = item.cost;
		    
		    newItem.innerHTML =
		        '<div class="planner-item-time">' +
		            '<input type="time" class="time-input time-start" value="' + item.startTime + '" onchange="updateItemTime(' + item.day + ', ' + item.itemId + ', \'start\', this.value)">' +
		            '<span class="time-separator">~</span>' +
		            '<input type="time" class="time-input time-end" value="' + item.endTime + '" onchange="updateItemTime(' + item.day + ', ' + item.itemId + ', \'end\', this.value)">' +
		        '</div>' +
		        '<div class="planner-item-content">' +
		            '<span class="planner-item-name">' + item.itemName + '</span>' +
		            '<span class="planner-item-category">' + item.itemCategory + '</span>' +
		        '</div>' +
		        '<div class="planner-item-cost">' +
		            '<input type="text" class="cost-input" value="0" placeholder="0" onclick="this.select()" onchange="updateItemCost(' + item.day + ', ' + item.itemId + ', this.value)">' +
		            '<span class="cost-unit">원</span>' +
		        '</div>' +
		        '<div class="planner-item-actions">' +
		            '<button onclick="viewItemDetail(' + item.itemId + ')"><i class="bi bi-info-circle"></i></button>' +
		            '<button onclick="removeItem(' + item.day + ', ' + item.itemId + ')"><i class="bi bi-trash"></i></button>' +
		        '</div>';
		        
	        let itemsContainer = document.getElementById('day' + item.day + 'Items');
	        if (!itemsContainer) {
	            console.error('Container not found');
	            return;
	        }
	        
    		itemsContainer.appendChild(newItem);
		    initDragAndDropForItem(newItem);

			console.log(item.day);
		    
			myMap.addMarker(item.latitude, item.longitude, item.itemName, item.day, { id: item.itemId });
			
			myMap.fitBounds();
        });
	}

}

function getContentTypeName(contentTypeId) {
    return tourContentList[contentTypeId] || '기타';
}

$("#searchInput").on("keydown",  function() {
    if (event.key === "Enter") {
        event.preventDefault(); // 폼 제출 방지

        let keyword = $("#searchInput").val().trim();
        searchPage = 1;
        areaCode = "";

        let isRegionActive = document.querySelector(".filter-region").classList.contains("active");

        if(isRegionActive) {
            areaCode = preferenceData.destinationcode;
        }
        
        searchTourPlaceList(keyword, areaCode, searchPage);
    }
});

function searchTourPlaceList(keyword, areaCode, page) {
    fetch("/schedule/common/searchTourPlaceList",{
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            keyword : keyword,
            areaCode : areaCode,
            page : page
        })
    })
    .then(response => response.json())
    .then(dataList => {
        let items = dataList.response.body.items.item;
        let popularList = [];

        for(let i = 0; i < dataList.popularPlaceList.length; i++) {
        	popularList[i] = dataList.popularPlaceList[i].plcNo + "";
        }

        let placeData = "";
        let popPlaceData = "";

        let outputCnt = 0;
        
        for(let i = 0; i < items.length && outputCnt < 15; i++) {
            let tourPlace = items[i];
            console.log(tourPlace);
            let isPopular = popularList.includes(tourPlace.contentid);
            
            if(tourPlace.firstimage) {
                placeData += `
                    <div class="search-result-item" data-contentid="\${tourPlace.contentid}">
                    <img src="\${ tourPlace.firstimage }"
                        alt="\${ tourPlace.title }" class="search-result-image">
                    <div class="search-result-content">
                        <h5 class="search-result-name">\${ tourPlace.title }</h5>
                        <span class="search-result-category">\${getContentTypeName(tourPlace.contenttypeid)} · 자연</span>
                        <div class="search-result-rating">
                            <i class="bi bi-star-fill"></i>
                            <span>4.8</span>
                            <span class="text-muted">(1,234)</span>
                        </div>
                    </div>
                    <button class="search-result-add" onclick="addToItinerary(\${tourPlace.contentid}, '\${ tourPlace.title }', '\${getContentTypeName(tourPlace.contenttypeid)}', '\${ tourPlace.mapy }', '\${ tourPlace.mapx }', '\${ tourPlace.contentid }', '\${ tourPlace.contenttypeid }')">
                        <i class="bi bi-plus"></i>
                    </button>
                </div>
                `;
                
                outputCnt++;
		    }

            if(isPopular) {
                popPlaceData += `
                    <div class="place-autocomplete-item" onclick="selectPlace(\${tourPlace.contentid}, '\${ tourPlace.title }', '\${getContentTypeName(tourPlace.contenttypeid)}', '\${ tourPlace.mapy }', '\${ tourPlace.mapx }', '\${ tourPlace.contentid }', '\${ tourPlace.contenttypeid }')" style="display: flex;">
                        <div class="place-autocomplete-icon">
                            <img class="place-img" src="\${ tourPlace.firstimage }" alt="\${ tourPlace.title }" class="place-autocomplete-image">
                        </div>
                        <div class="place-autocomplete-info">
                            <span class="place-autocomplete-name">\${ tourPlace.title }</span>
                            <span class="place-autocomplete-category">\${getContentTypeName(tourPlace.contenttypeid)} · 자연</span>
                        </div>
                    </div>
                `
                $("#placeAutocomplete").children("#autocomplete-section").append(popPlaceData);
            }
	    }
	    $("#searchResults").html(placeData);
    });
	searchPage++;
}

</script>

<%@ include file="../common/footer.jsp" %>
