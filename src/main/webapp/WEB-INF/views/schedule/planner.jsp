<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="일정 계획하기" />
<c:set var="pageCss" value="schedule" />

<%@ include file="../common/header.jsp" %>

<div class="planner-page">
    <!-- 사이드바: 일정 리스트 -->
    <aside class="planner-sidebar">
        <div class="planner-sidebar-header">
            <h1 class="planner-trip-title" id="tripTitle">제주도 여행</h1>
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
            <!-- Day 1 -->
            <div class="planner-day" data-day="1">
                <div class="planner-day-header" onclick="openEditDayModal(1)">
                    <div class="planner-day-header-content">
                        <span class="planner-day-title" id="dayTitle1">1일차</span>
                        <span class="planner-day-theme" id="dayTheme1"></span>
                    </div>
                    <span class="planner-day-date" id="dayDate1">3월 15일 (금)</span>
                    <i class="bi bi-pencil planner-day-edit-icon"></i>
                </div>
                <div class="planner-items" id="day1Items">
                    <div class="planner-item" draggable="true" data-item-id="1" data-start-time="06:00" data-end-time="08:00" data-cost="5000">
                        <div class="planner-item-time">
                            <input type="time" class="time-input time-start" value="06:00" onchange="updateItemTime(1, 1, 'start', this.value)">
                            <span class="time-separator">~</span>
                            <input type="time" class="time-input time-end" value="08:00" onchange="updateItemTime(1, 1, 'end', this.value)">
                        </div>
                        <div class="planner-item-content">
                            <span class="planner-item-name">성산일출봉</span>
                            <span class="planner-item-category">관광지</span>
                        </div>
                        <div class="planner-item-cost">
                            <input type="text" class="cost-input" value="5,000" placeholder="0" onclick="this.select()" onchange="updateItemCost(1, 1, this.value)">
                            <span class="cost-unit">원</span>
                        </div>
                        <div class="planner-item-actions">
                            <button onclick="viewItemDetail(1)"><i class="bi bi-info-circle"></i></button>
                            <button onclick="removeItem(1, 1)"><i class="bi bi-trash"></i></button>
                        </div>
                    </div>
                    <div class="planner-item" draggable="true" data-item-id="2" data-start-time="12:00" data-end-time="13:00" data-cost="25000">
                        <div class="planner-item-time">
                            <input type="time" class="time-input time-start" value="12:00" onchange="updateItemTime(1, 2, 'start', this.value)">
                            <span class="time-separator">~</span>
                            <input type="time" class="time-input time-end" value="13:00" onchange="updateItemTime(1, 2, 'end', this.value)">
                        </div>
                        <div class="planner-item-content">
                            <span class="planner-item-name">해녀의집</span>
                            <span class="planner-item-category">맛집</span>
                        </div>
                        <div class="planner-item-cost">
                            <input type="text" class="cost-input" value="25,000" placeholder="0" onclick="this.select()" onchange="updateItemCost(1, 2, this.value)">
                            <span class="cost-unit">원</span>
                        </div>
                        <div class="planner-item-actions">
                            <button onclick="viewItemDetail(2)"><i class="bi bi-info-circle"></i></button>
                            <button onclick="removeItem(1, 2)"><i class="bi bi-trash"></i></button>
                        </div>
                    </div>
                    <div class="planner-item" draggable="true" data-item-id="3" data-start-time="14:30" data-end-time="17:00" data-cost="15000">
                        <div class="planner-item-time">
                            <input type="time" class="time-input time-start" value="14:30" onchange="updateItemTime(1, 3, 'start', this.value)">
                            <span class="time-separator">~</span>
                            <input type="time" class="time-input time-end" value="17:00" onchange="updateItemTime(1, 3, 'end', this.value)">
                        </div>
                        <div class="planner-item-content">
                            <span class="planner-item-name">우도</span>
                            <span class="planner-item-category">관광지</span>
                        </div>
                        <div class="planner-item-cost">
                            <input type="text" class="cost-input" value="15,000" placeholder="0" onclick="this.select()" onchange="updateItemCost(1, 3, this.value)">
                            <span class="cost-unit">원</span>
                        </div>
                        <div class="planner-item-actions">
                            <button onclick="viewItemDetail(3)"><i class="bi bi-info-circle"></i></button>
                            <button onclick="removeItem(1, 3)"><i class="bi bi-trash"></i></button>
                        </div>
                    </div>
                </div>
                <button class="add-place-btn" onclick="openAddPlaceModal(1)" style="margin-top: 8px; padding: 10px;">
                    <i class="bi bi-plus"></i> 장소 추가
                </button>
            </div>

            <!-- Day 2 -->
            <div class="planner-day" data-day="2">
                <div class="planner-day-header" onclick="openEditDayModal(2)">
                    <div class="planner-day-header-content">
                        <span class="planner-day-title" id="dayTitle2">2일차</span>
                        <span class="planner-day-theme" id="dayTheme2"></span>
                    </div>
                    <span class="planner-day-date" id="dayDate2">3월 16일 (토)</span>
                    <i class="bi bi-pencil planner-day-edit-icon"></i>
                </div>
                <div class="planner-items" id="day2Items">
                    <div class="planner-item" draggable="true" data-item-id="4" data-start-time="09:00" data-end-time="12:00" data-cost="0">
                        <div class="planner-item-time">
                            <input type="time" class="time-input time-start" value="09:00" onchange="updateItemTime(2, 4, 'start', this.value)">
                            <span class="time-separator">~</span>
                            <input type="time" class="time-input time-end" value="12:00" onchange="updateItemTime(2, 4, 'end', this.value)">
                        </div>
                        <div class="planner-item-content">
                            <span class="planner-item-name">협재해수욕장</span>
                            <span class="planner-item-category">관광지</span>
                        </div>
                        <div class="planner-item-cost">
                            <input type="text" class="cost-input" value="0" placeholder="0" onclick="this.select()" onchange="updateItemCost(2, 4, this.value)">
                            <span class="cost-unit">원</span>
                        </div>
                        <div class="planner-item-actions">
                            <button onclick="viewItemDetail(4)"><i class="bi bi-info-circle"></i></button>
                            <button onclick="removeItem(2, 4)"><i class="bi bi-trash"></i></button>
                        </div>
                    </div>
                </div>
                <button class="add-place-btn" onclick="openAddPlaceModal(2)" style="margin-top: 8px; padding: 10px;">
                    <i class="bi bi-plus"></i> 장소 추가
                </button>
            </div>

            <!-- Day 3 -->
            <div class="planner-day" data-day="3">
                <div class="planner-day-header" onclick="openEditDayModal(3)">
                    <div class="planner-day-header-content">
                        <span class="planner-day-title" id="dayTitle3">3일차</span>
                        <span class="planner-day-theme" id="dayTheme3"></span>
                    </div>
                    <span class="planner-day-date" id="dayDate3">3월 17일 (일)</span>
                    <i class="bi bi-pencil planner-day-edit-icon"></i>
                </div>
                <div class="planner-items" id="day3Items">
                    <!-- 비어있음 -->
                </div>
                <button class="add-place-btn" onclick="openAddPlaceModal(3)" style="margin-top: 8px; padding: 10px;">
                    <i class="bi bi-plus"></i> 장소 추가
                </button>
            </div>

            <!-- Day 4 -->
            <div class="planner-day" data-day="4">
                <div class="planner-day-header" onclick="openEditDayModal(4)">
                    <div class="planner-day-header-content">
                        <span class="planner-day-title" id="dayTitle4">4일차</span>
                        <span class="planner-day-theme" id="dayTheme4"></span>
                    </div>
                    <span class="planner-day-date" id="dayDate4">3월 18일 (월)</span>
                    <i class="bi bi-pencil planner-day-edit-icon"></i>
                </div>
                <div class="planner-items" id="day4Items">
                    <!-- 비어있음 -->
                </div>
                <button class="add-place-btn" onclick="openAddPlaceModal(4)" style="margin-top: 8px; padding: 10px;">
                    <i class="bi bi-plus"></i> 장소 추가
                </button>
            </div>

            <!-- 저장 버튼 -->
            <div class="mt-4">
                <button class="btn btn-primary w-100" onclick="saveSchedule()">
                    <i class="bi bi-bookmark me-2"></i>일정 담기
                </button>
            </div>
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
                        <div class="autocomplete-section">
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
                <div class="search-filters">
                    <button class="filter-chip active" data-filter="all" onclick="filterSearch('all')">전체</button>
                    <button class="filter-chip" data-filter="attraction" onclick="filterSearch('attraction')">관광지</button>
                    <button class="filter-chip" data-filter="restaurant" onclick="filterSearch('restaurant')">맛집</button>
                    <button class="filter-chip" data-filter="cafe" onclick="filterSearch('cafe')">카페</button>
                    <button class="filter-chip" data-filter="activity" onclick="filterSearch('activity')">액티비티</button>
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

                <div class="search-result-item">
                    <img src="https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=80&h=80&fit=crop&q=80"
                         alt="카페" class="search-result-image">
                    <div class="search-result-content">
                        <h5 class="search-result-name">봄날카페</h5>
                        <span class="search-result-category">카페 · 오션뷰</span>
                        <div class="search-result-rating">
                            <i class="bi bi-star-fill"></i>
                            <span>4.6</span>
                            <span class="text-muted">(892)</span>
                        </div>
                    </div>
                    <button class="search-result-add" onclick="addToItinerary(6, '봄날카페', '카페')">
                        <i class="bi bi-plus"></i>
                    </button>
                </div>

                <div class="search-result-item">
                    <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=80&h=80&fit=crop&q=80"
                         alt="맛집" class="search-result-image">
                    <div class="search-result-content">
                        <h5 class="search-result-name">제주갈치조림</h5>
                        <span class="search-result-category">맛집 · 해산물</span>
                        <div class="search-result-rating">
                            <i class="bi bi-star-fill"></i>
                            <span>4.5</span>
                            <span class="text-muted">(567)</span>
                        </div>
                    </div>
                    <button class="search-result-add" onclick="addToItinerary(7, '제주갈치조림', '맛집')">
                        <i class="bi bi-plus"></i>
                    </button>
                </div>

                <div class="search-result-item">
                    <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=80&h=80&fit=crop&q=80"
                         alt="해변" class="search-result-image">
                    <div class="search-result-content">
                        <h5 class="search-result-name">금능해수욕장</h5>
                        <span class="search-result-category">관광지 · 해변</span>
                        <div class="search-result-rating">
                            <i class="bi bi-star-fill"></i>
                            <span>4.7</span>
                            <span class="text-muted">(445)</span>
                        </div>
                    </div>
                    <button class="search-result-add" onclick="addToItinerary(8, '금능해수욕장', '관광지')">
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
                                <span class="visibility-option-title">비공개</span>
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
                    <div class="budget-status-grid">
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

<script>
//map

let selectedItem = null;
let selectDayModal;
let saveScheduleModal;
let editDayModal;
let budgetModal;
let selectedDay = 1;
let itemIdCounter = 100; // 새 아이템 ID 생성용
let selectedVisibility = 'public'; // 기본값: 전체 공개
let totalBudget = 0; // 총 예산

// 일차 데이터 저장
let dayData = {
    1: { theme: '', date: '' },
    2: { theme: '', date: '' },
    3: { theme: '', date: '' },
    4: { theme: '', date: '' }
};

document.addEventListener('DOMContentLoaded', function() {
    selectDayModal = new bootstrap.Modal(document.getElementById('selectDayModal'));
    saveScheduleModal = new bootstrap.Modal(document.getElementById('saveScheduleModal'));
    editDayModal = new bootstrap.Modal(document.getElementById('editDayModal'));
    budgetModal = new bootstrap.Modal(document.getElementById('budgetModal'));
    initDragAndDrop();
    calculateAllCosts(); // 초기 비용 계산

    // 선호도 데이터 로드
    const preferenceData = JSON.parse(sessionStorage.getItem('preferenceData') || '{}');
    if (preferenceData.destination) {
        document.getElementById('tripTitle').textContent = preferenceData.destination + ' 여행';
    }
    if (preferenceData.travelDates) {
        document.getElementById('tripDates').textContent = preferenceData.travelDates;
    }
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
function selectPlace(id, name, category, imageUrl) {
    // 입력란에 선택한 장소 이름 표시
    document.getElementById('searchInput').value = name;

    // 드롭다운 숨기기
    hidePlaceAutocomplete();

    // 일정에 추가할 항목 설정
    selectedItem = { id: id, name: name, category: category, imageUrl: imageUrl };

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

function addToItinerary(id, name, category) {
    selectedItem = { id, name, category };
    selectDayModal.show();
}

// 장소 추가 확인 (시간 입력 포함)
function confirmAddPlace() {
    if (!selectedItem) return;

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
    newItem.dataset.startTime = startTime;
    newItem.dataset.endTime = endTime;
    newItem.dataset.cost = 0;
    newItem.innerHTML =
        '<div class="planner-item-time">' +
            '<input type="time" class="time-input time-start" value="' + startTime + '" onchange="updateItemTime(' + selectedDay + ', ' + newItemId + ', \'start\', this.value)">' +
            '<span class="time-separator">~</span>' +
            '<input type="time" class="time-input time-end" value="' + endTime + '" onchange="updateItemTime(' + selectedDay + ', ' + newItemId + ', \'end\', this.value)">' +
        '</div>' +
        '<div class="planner-item-content">' +
            '<span class="planner-item-name">' + selectedItem.name + '</span>' +
            '<span class="planner-item-category">' + selectedItem.category + '</span>' +
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

    selectedItem = null;
}

function viewItemDetail(itemId) {
    const modal = new bootstrap.Modal(document.getElementById('placeDetailModal'));
    document.getElementById('placeDetailBody').innerHTML = `
        <div class="text-center">
            <img src="https://images.unsplash.com/photo-1578469645742-46cae010e5d4?w=400&h=300&fit=crop&q=80"
                 alt="성산일출봉" class="w-100 rounded mb-3"
                 onerror="this.src='https://via.placeholder.com/400x300?text=성산일출봉'">
            <h5>성산일출봉</h5>
            <p class="text-muted mb-3">제주 서귀포시 성산읍</p>
            <p>유네스코 세계자연유산으로 지정된 제주도의 대표 관광지입니다.</p>
            <hr>
            <div class="d-flex justify-content-around text-center">
                <div>
                    <i class="bi bi-clock text-primary mb-1" style="font-size: 24px;"></i>
                    <p class="mb-0 small">일출 1시간 전~20:00</p>
                </div>
                <div>
                    <i class="bi bi-currency-dollar text-primary mb-1" style="font-size: 24px;"></i>
                    <p class="mb-0 small">성인 5,000원</p>
                </div>
                <div>
                    <i class="bi bi-star-fill text-warning mb-1" style="font-size: 24px;"></i>
                    <p class="mb-0 small">4.7점</p>
                </div>
            </div>
        </div>
    `;
    modal.show();
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
    const isLoggedIn = ${not empty sessionScope.loginUser};

    if (!isLoggedIn) {
        sessionStorage.setItem('returnUrl', window.location.href);
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
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
function confirmSaveSchedule() {
    var visibilityLabels = {
        'public': '전체 공개',
        'private': '비공개'
    };

    // 일정 저장 (실제 구현 시 AJAX)
    console.log('저장 설정:', selectedVisibility);

    saveScheduleModal.hide();
    showToast('일정이 ' + visibilityLabels[selectedVisibility] + '로 저장되었습니다!', 'success');

    setTimeout(function() {
        window.location.href = '${pageContext.request.contextPath}/schedule/my';
    }, 1500);
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
    for (var day = 1; day <= 4; day++) {
        var dayCost = calculateDayCost(day);
        document.getElementById('day' + day + 'Cost').textContent = dayCost.toLocaleString() + '원';
    }
    document.getElementById('modalTotalCost').textContent = calculateTotalSpent().toLocaleString() + '원';
}

// 총 지출 계산
function calculateTotalSpent() {
    var total = 0;
    for (var day = 1; day <= 4; day++) {
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

// 비용 입력 포맷팅 (숫자만, 쉼표 추가)
document.addEventListener('input', function(e) {
    if (e.target.classList.contains('cost-input') || e.target.id === 'budgetInput') {
        var value = e.target.value.replace(/[^0-9]/g, '');
        if (value) {
            e.target.value = parseInt(value).toLocaleString();
        }
    }
});
</script>

<c:set var="pageJs" value="schedule" />
<%@ include file="../common/footer.jsp" %>
