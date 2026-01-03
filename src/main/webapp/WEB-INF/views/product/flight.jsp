<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="항공권 검색" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>

<div class="product-page">
    <!-- 헤더 -->
    <div class="product-header">
        <div class="container">
            <h1><i class="bi bi-airplane me-3"></i>항공권 검색</h1>
            <p>국내 항공권을 한 번에 비교하고 최저가를 찾아보세요</p>
        </div>
    </div>

    <div class="container">
        <!-- 검색 박스 -->
        <div class="search-box">
            <div class="search-tabs">
                <button class="search-tab active" data-type="round">왕복</button>
                <button class="search-tab" data-type="oneway">편도</button>
                <button class="search-tab" data-type="multi">다구간</button>
            </div>

            <form id="flightSearchForm">
                <!-- 왕복/편도 검색 폼 -->
                <div id="normalSearchForm">
                    <div class="search-form-row">
                        <div class="form-group">
                            <label class="form-label">출발지</label>
                            <div class="search-input-group">
                                <span class="input-icon"><i class="bi bi-geo-alt"></i></span>
                                <input type="text" class="form-control location-autocomplete" id="departure" placeholder="도시 또는 공항" autocomplete="off">
                                <div class="autocomplete-dropdown" id="departureDropdown"></div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">도착지</label>
                            <div class="search-input-group">
                                <span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>
                                <input type="text" class="form-control location-autocomplete" id="destination" placeholder="도시 또는 공항" autocomplete="off">
                                <div class="autocomplete-dropdown" id="destinationDropdown"></div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">출발일</label>
                            <input type="text" class="form-control date-picker" id="departDate" placeholder="날짜 선택">
                        </div>
                        <div class="form-group" id="returnDateGroup">
                            <label class="form-label">귀국일</label>
                            <input type="text" class="form-control date-picker" id="returnDate" placeholder="날짜 선택">
                        </div>
                        <button type="submit" class="btn btn-primary btn-search">
                            <i class="bi bi-search me-2"></i>검색
                        </button>
                    </div>
                </div>

                <!-- 다구간 검색 폼 -->
                <div id="multiCitySearchForm" style="display: none;">
                    <div class="multi-city-segments" id="multiCitySegments">
                        <!-- 구간 1 -->
                        <div class="multi-city-segment" data-segment="1">
                            <div class="segment-header">
                                <span class="segment-number">구간 1</span>
                            </div>
                            <div class="segment-fields">
                                <div class="form-group">
                                    <label class="form-label">출발지</label>
                                    <div class="search-input-group">
                                        <span class="input-icon"><i class="bi bi-geo-alt"></i></span>
                                        <input type="text" class="form-control location-autocomplete" name="multiDeparture[]" placeholder="도시 또는 공항" autocomplete="off">
                                        <div class="autocomplete-dropdown"></div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">도착지</label>
                                    <div class="search-input-group">
                                        <span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>
                                        <input type="text" class="form-control location-autocomplete" name="multiDestination[]" placeholder="도시 또는 공항" autocomplete="off">
                                        <div class="autocomplete-dropdown"></div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">출발일</label>
                                    <input type="text" class="form-control date-picker-multi" name="multiDate[]" placeholder="날짜 선택">
                                </div>
                                <div class="segment-action">
                                    <!-- 첫 번째 구간은 삭제 불가 -->
                                </div>
                            </div>
                        </div>

                        <!-- 구간 2 -->
                        <div class="multi-city-segment" data-segment="2">
                            <div class="segment-header">
                                <span class="segment-number">구간 2</span>
                            </div>
                            <div class="segment-fields">
                                <div class="form-group">
                                    <label class="form-label">출발지</label>
                                    <div class="search-input-group">
                                        <span class="input-icon"><i class="bi bi-geo-alt"></i></span>
                                        <input type="text" class="form-control location-autocomplete" name="multiDeparture[]" placeholder="도시 또는 공항" autocomplete="off">
                                        <div class="autocomplete-dropdown"></div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">도착지</label>
                                    <div class="search-input-group">
                                        <span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>
                                        <input type="text" class="form-control location-autocomplete" name="multiDestination[]" placeholder="도시 또는 공항" autocomplete="off">
                                        <div class="autocomplete-dropdown"></div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">출발일</label>
                                    <input type="text" class="form-control date-picker-multi" name="multiDate[]" placeholder="날짜 선택">
                                </div>
                                <div class="segment-action">
                                    <button type="button" class="btn-remove-segment" onclick="removeSegment(2)" title="구간 삭제">
                                        <i class="bi bi-x-lg"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 구간 추가 버튼 -->
                    <div class="add-segment-wrapper">
                        <button type="button" class="btn btn-outline btn-add-segment" id="addSegmentBtn" onclick="addSegment()">
                            <i class="bi bi-plus-lg me-2"></i>구간 추가 <span class="segment-limit">(최대 6구간)</span>
                        </button>
                    </div>

                    <!-- 승객 및 좌석 옵션 -->
                    <div class="multi-city-options">
                        <div class="options-row">
                            <div class="form-group passenger-dropdown">
                                <label class="form-label">승객</label>
                                <input type="text" class="form-control passenger-input" id="multiPassengerInput"
                                       value="성인 1명" readonly onclick="toggleMultiPassengerPanel()">
                                <div class="passenger-panel" id="multiPassengerPanel">
                                    <div class="passenger-row">
                                        <div class="passenger-label">
                                            성인
                                            <span>만 12세 이상</span>
                                        </div>
                                        <div class="passenger-counter">
                                            <button type="button" class="counter-btn" onclick="updateMultiPassenger('adult', -1)">-</button>
                                            <span class="counter-value" id="multiAdultCount">1</span>
                                            <button type="button" class="counter-btn" onclick="updateMultiPassenger('adult', 1)">+</button>
                                        </div>
                                    </div>
                                    <div class="passenger-row">
                                        <div class="passenger-label">
                                            소아
                                            <span>만 2~11세</span>
                                        </div>
                                        <div class="passenger-counter">
                                            <button type="button" class="counter-btn" onclick="updateMultiPassenger('child', -1)">-</button>
                                            <span class="counter-value" id="multiChildCount">0</span>
                                            <button type="button" class="counter-btn" onclick="updateMultiPassenger('child', 1)">+</button>
                                        </div>
                                    </div>
                                    <div class="passenger-row">
                                        <div class="passenger-label">
                                            유아
                                            <span>만 2세 미만</span>
                                        </div>
                                        <div class="passenger-counter">
                                            <button type="button" class="counter-btn" onclick="updateMultiPassenger('infant', -1)">-</button>
                                            <span class="counter-value" id="multiInfantCount">0</span>
                                            <button type="button" class="counter-btn" onclick="updateMultiPassenger('infant', 1)">+</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">좌석 등급</label>
                                <select class="form-control form-select" id="multiCabinClass">
                                    <option value="economy">일반석</option>
                                    <option value="premium">프리미엄 일반석</option>
                                    <option value="business">비즈니스석</option>
                                    <option value="first">일등석</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">직항만</label>
                                <div class="form-check mt-2">
                                    <input class="form-check-input" type="checkbox" id="multiDirectOnly">
                                    <label class="form-check-label" for="multiDirectOnly">직항 항공편만 보기</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 검색 버튼 -->
                    <div class="multi-city-search-btn">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="bi bi-search me-2"></i>다구간 항공권 검색
                        </button>
                    </div>
                </div>

                <div class="search-form-row mt-3">
                    <div class="form-group passenger-dropdown">
                        <label class="form-label">승객</label>
                        <input type="text" class="form-control passenger-input" id="passengerInput"
                               value="성인 1명" readonly onclick="togglePassengerPanel()">
                        <div class="passenger-panel" id="passengerPanel">
                            <div class="passenger-row">
                                <div class="passenger-label">
                                    성인
                                    <span>만 12세 이상</span>
                                </div>
                                <div class="passenger-counter">
                                    <button type="button" class="counter-btn" onclick="updatePassenger('adult', -1)">-</button>
                                    <span class="counter-value" id="adultCount">1</span>
                                    <button type="button" class="counter-btn" onclick="updatePassenger('adult', 1)">+</button>
                                </div>
                            </div>
                            <div class="passenger-row">
                                <div class="passenger-label">
                                    소아
                                    <span>만 2~11세</span>
                                </div>
                                <div class="passenger-counter">
                                    <button type="button" class="counter-btn" onclick="updatePassenger('child', -1)">-</button>
                                    <span class="counter-value" id="childCount">0</span>
                                    <button type="button" class="counter-btn" onclick="updatePassenger('child', 1)">+</button>
                                </div>
                            </div>
                            <div class="passenger-row">
                                <div class="passenger-label">
                                    유아
                                    <span>만 2세 미만</span>
                                </div>
                                <div class="passenger-counter">
                                    <button type="button" class="counter-btn" onclick="updatePassenger('infant', -1)">-</button>
                                    <span class="counter-value" id="infantCount">0</span>
                                    <button type="button" class="counter-btn" onclick="updatePassenger('infant', 1)">+</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">좌석 등급</label>
                        <select class="form-control form-select" id="cabinClass">
                            <option value="economy">일반석</option>
                            <option value="premium">프리미엄 일반석</option>
                            <option value="business">비즈니스석</option>
                            <option value="first">일등석</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">직항만</label>
                        <div class="form-check mt-2">
                            <input class="form-check-input" type="checkbox" id="directOnly">
                            <label class="form-check-label" for="directOnly">직항 항공편만 보기</label>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- 선택한 항공편 표시 영역 -->
        <div class="selected-flights-container" id="selectedFlightsContainer" style="display: none;">
            <div class="selected-flights-header">
                <h5><i class="bi bi-check-circle-fill me-2"></i>선택한 항공편</h5>
                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="resetFlightSelection()">
                    <i class="bi bi-arrow-counterclockwise me-1"></i>다시 선택
                </button>
            </div>
            <div class="selected-flights-list" id="selectedFlightsList"></div>
        </div>

        <!-- 현재 선택 단계 표시 -->
        <div class="selection-step-indicator" id="selectionStepIndicator" style="display: none;">
            <div class="step-badge">
                <span id="currentStepText">가는편 선택</span>
            </div>
        </div>

        <!-- 검색 결과 -->
        <div class="flight-results" id="flightResults">
            <div class="results-header">
                <p class="results-count">
                    <strong>김포(GMP)</strong> → <strong>제주(CJU)</strong> 검색 결과 <strong>24</strong>개
                </p>
                <div class="sort-options">
                    <button class="sort-btn active" data-sort="price">최저가순</button>
                    <button class="sort-btn" data-sort="duration">최단시간순</button>
                    <button class="sort-btn" data-sort="departure">출발시간순</button>
                </div>
            </div>

            <!-- 항공편 카드들 -->
            <div class="flight-card" data-flight-id="1">
                <div class="flight-card-content">
                    <div class="flight-info">
                        <div class="flight-time">
                            <div class="time">07:00</div>
                            <div class="airport">GMP 김포</div>
                        </div>
                    </div>
                    <div class="flight-duration">
                        <div class="duration-line">
                            <i class="bi bi-airplane"></i>
                        </div>
                        <div class="duration-text">1시간 05분</div>
                        <div class="flight-airline">대한항공 KE1201</div>
                        <div class="stops direct">직항</div>
                    </div>
                    <div class="flight-info">
                        <div class="flight-time">
                            <div class="time">08:05</div>
                            <div class="airport">CJU 제주</div>
                        </div>
                    </div>
                    <div class="flight-baggage">
                        <i class="bi bi-luggage-fill"></i>
                        <span>15kg</span>
                    </div>
                    <div class="flight-price">
                        <div class="price">52,000<span class="price-unit">원</span></div>
                        <button type="button" class="btn btn-primary btn-sm flight-action-btn"
                                onclick="selectFlight(1, '대한항공 KE1201', '07:00', '08:05', 'GMP', 'CJU', 52000, '15kg')">
                            결제하기
                        </button>
                    </div>
                </div>
            </div>

            <div class="flight-card" data-flight-id="2">
                <div class="flight-card-content">
                    <div class="flight-info">
                        <div class="flight-time">
                            <div class="time">08:30</div>
                            <div class="airport">GMP 김포</div>
                        </div>
                    </div>
                    <div class="flight-duration">
                        <div class="duration-line">
                            <i class="bi bi-airplane"></i>
                        </div>
                        <div class="duration-text">1시간 10분</div>
                        <div class="flight-airline">아시아나 OZ8901</div>
                        <div class="stops direct">직항</div>
                    </div>
                    <div class="flight-info">
                        <div class="flight-time">
                            <div class="time">09:40</div>
                            <div class="airport">CJU 제주</div>
                        </div>
                    </div>
                    <div class="flight-baggage">
                        <i class="bi bi-luggage-fill"></i>
                        <span>15kg</span>
                    </div>
                    <div class="flight-price">
                        <div class="price">58,000<span class="price-unit">원</span></div>
                        <button type="button" class="btn btn-primary btn-sm flight-action-btn"
                                onclick="selectFlight(2, '아시아나 OZ8901', '08:30', '09:40', 'GMP', 'CJU', 58000, '15kg')">
                            결제하기
                        </button>
                    </div>
                </div>
            </div>

            <div class="flight-card" data-flight-id="3">
                <div class="flight-card-content">
                    <div class="flight-info">
                        <div class="flight-time">
                            <div class="time">09:15</div>
                            <div class="airport">GMP 김포</div>
                        </div>
                    </div>
                    <div class="flight-duration">
                        <div class="duration-line">
                            <i class="bi bi-airplane"></i>
                        </div>
                        <div class="duration-text">1시간 05분</div>
                        <div class="flight-airline">제주항공 7C101</div>
                        <div class="stops direct">직항</div>
                    </div>
                    <div class="flight-info">
                        <div class="flight-time">
                            <div class="time">10:20</div>
                            <div class="airport">CJU 제주</div>
                        </div>
                    </div>
                    <div class="flight-baggage">
                        <i class="bi bi-luggage-fill"></i>
                        <span>15kg</span>
                    </div>
                    <div class="flight-price">
                        <div class="price">39,000<span class="price-unit">원</span></div>
                        <button type="button" class="btn btn-primary btn-sm flight-action-btn"
                                onclick="selectFlight(3, '제주항공 7C101', '09:15', '10:20', 'GMP', 'CJU', 39000, '15kg')">
                            결제하기
                        </button>
                    </div>
                </div>
            </div>

            <div class="flight-card" data-flight-id="4">
                <div class="flight-card-content">
                    <div class="flight-info">
                        <div class="flight-time">
                            <div class="time">10:30</div>
                            <div class="airport">GMP 김포</div>
                        </div>
                    </div>
                    <div class="flight-duration">
                        <div class="duration-line">
                            <i class="bi bi-airplane"></i>
                        </div>
                        <div class="duration-text">1시간 10분</div>
                        <div class="flight-airline">진에어 LJ301</div>
                        <div class="stops direct">직항</div>
                    </div>
                    <div class="flight-info">
                        <div class="flight-time">
                            <div class="time">11:40</div>
                            <div class="airport">CJU 제주</div>
                        </div>
                    </div>
                    <div class="flight-baggage">
                        <i class="bi bi-luggage-fill"></i>
                        <span>15kg</span>
                    </div>
                    <div class="flight-price">
                        <div class="price">35,000<span class="price-unit">원</span></div>
                        <button type="button" class="btn btn-primary btn-sm flight-action-btn"
                                onclick="selectFlight(4, '진에어 LJ301', '10:30', '11:40', 'GMP', 'CJU', 35000, '15kg')">
                            결제하기
                        </button>
                    </div>
                </div>
            </div>

            <!-- 로딩 인디케이터 -->
            <div class="infinite-scroll-loader" id="flightScrollLoader">
                <div class="loader-spinner">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>

            <!-- 더 이상 데이터 없음 -->
            <div class="infinite-scroll-end" id="flightScrollEnd" style="display: none;">
                <p>모든 항공편을 불러왔습니다</p>
            </div>
        </div>
    </div>
</div>

<style>
/* 다구간 검색 폼 스타일 */
.multi-city-segments {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.multi-city-segment {
    background: var(--light-color);
    border-radius: var(--radius-md);
    padding: 20px;
    border: 1px solid var(--gray-lighter);
    transition: all var(--transition-fast);
}

.multi-city-segment:hover {
    border-color: var(--primary-color);
}

.segment-header {
    margin-bottom: 16px;
}

.segment-number {
    font-weight: 600;
    font-size: 14px;
    color: var(--primary-color);
    background: rgba(74, 144, 217, 0.1);
    padding: 4px 12px;
    border-radius: 20px;
}

.segment-fields {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr auto;
    gap: 16px;
    align-items: end;
}

.segment-fields .form-group {
    margin: 0;
}

.segment-action {
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 44px;
    padding-bottom: 4px;
}

.btn-remove-segment {
    width: 40px;
    height: 40px;
    border: none;
    background: white;
    border-radius: 50%;
    color: var(--gray-dark);
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all var(--transition-fast);
    box-shadow: var(--shadow-sm);
}

.btn-remove-segment:hover {
    background: #fee2e2;
    color: #ef4444;
}

.add-segment-wrapper {
    margin-top: 16px;
    text-align: center;
}

.btn-add-segment {
    border-style: dashed;
    padding: 12px 24px;
}

.btn-add-segment:hover {
    border-style: solid;
}

.segment-limit {
    font-size: 12px;
    color: var(--gray-medium);
    font-weight: normal;
}

.multi-city-search-btn {
    margin-top: 24px;
    text-align: center;
}

.multi-city-search-btn .btn {
    min-width: 250px;
}

/* 다구간 폼 반응형 */
@media (max-width: 992px) {
    .segment-fields {
        grid-template-columns: 1fr 1fr;
    }

    .segment-action {
        grid-column: span 2;
        justify-content: flex-end;
        padding-top: 8px;
    }
}

@media (max-width: 576px) {
    .segment-fields {
        grid-template-columns: 1fr;
    }

    .segment-action {
        grid-column: span 1;
        justify-content: center;
    }

    .multi-city-search-btn .btn {
        width: 100%;
        min-width: auto;
    }
}

/* 다구간 옵션 영역 스타일 */
.multi-city-options {
    margin-top: 24px;
    padding-top: 24px;
    border-top: 1px solid var(--gray-lighter);
}

.multi-city-options .options-row {
    display: flex;
    gap: 20px;
    flex-wrap: wrap;
    align-items: flex-start;
}

.multi-city-options .form-group {
    flex: 1;
    min-width: 180px;
}

.multi-city-options .passenger-dropdown {
    position: relative;
}

.multi-city-options .passenger-panel {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: white;
    border-radius: var(--radius-md);
    box-shadow: var(--shadow-lg);
    padding: 16px;
    z-index: 100;
    display: none;
    min-width: 280px;
}

.multi-city-options .passenger-panel.active {
    display: block;
}

.multi-city-options .form-check {
    padding-top: 10px;
}

@media (max-width: 768px) {
    .multi-city-options .options-row {
        flex-direction: column;
    }

    .multi-city-options .form-group {
        width: 100%;
    }
}

/* 항공편 카드 스타일 */
.flight-card {
    position: relative;
}

.flight-card-content {
    transition: background var(--transition-fast);
}

.flight-card-content:hover {
    background: var(--light-color);
}

.flight-airline {
    font-size: 13px;
    color: var(--gray-dark);
    font-weight: 500;
    margin-top: 4px;
}

/* 선택한 항공편 표시 영역 */
.selected-flights-container {
    background: linear-gradient(135deg, #e8f4fd 0%, #f0f7ff 100%);
    border: 2px solid var(--primary-color);
    border-radius: var(--radius-lg);
    padding: 20px;
    margin-bottom: 20px;
}

.selected-flights-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
}

.selected-flights-header h5 {
    margin: 0;
    color: var(--primary-color);
    font-weight: 600;
}

.selected-flights-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.selected-flight-item {
    background: white;
    border-radius: var(--radius-md);
    padding: 16px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: var(--shadow-sm);
}

.selected-flight-info {
    display: flex;
    align-items: center;
    gap: 20px;
}

.selected-flight-label {
    background: var(--primary-color);
    color: white;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    min-width: 60px;
    text-align: center;
}

.selected-flight-detail {
    display: flex;
    align-items: center;
    gap: 12px;
}

.selected-flight-time {
    font-weight: 600;
    font-size: 16px;
}

.selected-flight-route {
    color: var(--gray-medium);
    font-size: 14px;
}

.selected-flight-airline {
    color: var(--gray-dark);
    font-size: 13px;
}

.selected-flight-price {
    font-weight: 700;
    font-size: 18px;
    color: var(--primary-color);
}

/* 선택 단계 표시 */
.selection-step-indicator {
    margin-bottom: 16px;
}

.step-badge {
    display: inline-flex;
    align-items: center;
    background: var(--primary-color);
    color: white;
    padding: 8px 20px;
    border-radius: 25px;
    font-weight: 600;
    font-size: 14px;
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.8; }
}

/* 총 금액 및 결제 버튼 */
.selected-flights-total {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 16px;
    padding-top: 16px;
    border-top: 2px dashed var(--gray-lighter);
}

.total-price-label {
    font-size: 14px;
    color: var(--gray-dark);
}

.total-price-value {
    font-size: 24px;
    font-weight: 700;
    color: var(--primary-color);
}

/* 반응형 */
@media (max-width: 768px) {
    .selected-flight-item {
        flex-direction: column;
        gap: 12px;
        align-items: flex-start;
    }

    .selected-flight-info {
        flex-wrap: wrap;
    }

    .selected-flights-total {
        flex-direction: column;
        gap: 12px;
        text-align: center;
    }
}
</style>

<script>
// 승객 정보
let passengers = { adult: 1, child: 0, infant: 0 };
let multiPassengers = { adult: 1, child: 0, infant: 0 }; // 다구간용 승객 정보
let segmentCount = 2; // 초기 구간 수
const MAX_SEGMENTS = 6;

// ==================== 항공편 선택 상태 관리 ====================
let currentSearchType = 'round'; // round, oneway, multi
let currentSelectionStep = 0; // 현재 선택 단계 (0: 가는편, 1: 오는편, 다구간은 0~n)
let selectedFlights = []; // 선택된 항공편 목록
let totalSegments = 2; // 총 선택해야 할 구간 수 (왕복: 2, 편도: 1, 다구간: n)

// 검색 타입 탭 전환
document.querySelectorAll('.search-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        document.querySelectorAll('.search-tab').forEach(t => t.classList.remove('active'));
        this.classList.add('active');

        const type = this.dataset.type;
        currentSearchType = type;

        // 선택 상태 초기화
        resetFlightSelection();

        if (type === 'multi') {
            // 다구간 선택
            document.getElementById('normalSearchForm').style.display = 'none';
            document.getElementById('multiCitySearchForm').style.display = 'block';
            document.querySelector('.search-form-row.mt-3').style.display = 'none';
            totalSegments = document.querySelectorAll('.multi-city-segment').length;
        } else {
            // 왕복/편도 선택
            document.getElementById('normalSearchForm').style.display = 'block';
            document.getElementById('multiCitySearchForm').style.display = 'none';
            document.querySelector('.search-form-row.mt-3').style.display = 'flex';

            if (type === 'oneway') {
                document.getElementById('returnDateGroup').style.display = 'none';
                totalSegments = 1;
            } else {
                document.getElementById('returnDateGroup').style.display = 'block';
                totalSegments = 2;
            }
        }

        // 버튼 텍스트 업데이트
        updateFlightButtons();
        // 선택 단계 표시 업데이트
        updateSelectionStepIndicator();
    });
});

// 버튼 텍스트 업데이트
function updateFlightButtons() {
    const buttons = document.querySelectorAll('.flight-action-btn');
    const isLastStep = (currentSelectionStep >= totalSegments - 1);

    buttons.forEach(btn => {
        if (currentSearchType === 'oneway') {
            btn.textContent = '결제하기';
        } else {
            btn.textContent = isLastStep ? '결제하기' : '선택';
        }
    });
}

// 선택 단계 표시 업데이트
function updateSelectionStepIndicator() {
    const indicator = document.getElementById('selectionStepIndicator');
    const stepText = document.getElementById('currentStepText');

    if (currentSearchType === 'oneway') {
        indicator.style.display = 'none';
        return;
    }

    indicator.style.display = 'block';

    if (currentSearchType === 'round') {
        stepText.textContent = currentSelectionStep === 0 ? '가는편 선택' : '오는편 선택';
    } else if (currentSearchType === 'multi') {
        stepText.textContent = '구간 ' + (currentSelectionStep + 1) + ' 선택';
    }
}

// 항공편 선택 처리
function selectFlight(id, airline, depTime, arrTime, depAirport, arrAirport, price, baggage) {
    const flightData = {
        id: id,
        airline: airline,
        departureTime: depTime,
        arrivalTime: arrTime,
        departureAirport: depAirport,
        arrivalAirport: arrAirport,
        price: price,
        baggage: baggage,
        step: currentSelectionStep
    };

    // 편도인 경우 바로 결제 페이지로 이동
    if (currentSearchType === 'oneway') {
        goToBooking([flightData]);
        return;
    }

    // 왕복/다구간인 경우
    selectedFlights.push(flightData);
    currentSelectionStep++;

    // 선택한 항공편 표시 업데이트
    updateSelectedFlightsDisplay();

    // 마지막 구간인 경우 결제 페이지로 이동
    if (currentSelectionStep >= totalSegments) {
        // 잠시 후 결제 페이지로 이동 (선택 결과 보여주기 위해)
        setTimeout(() => {
            goToBooking(selectedFlights);
        }, 500);
    } else {
        // 다음 구간 선택을 위해 버튼 및 표시 업데이트
        updateFlightButtons();
        updateSelectionStepIndicator();

        // 스크롤을 검색 결과 상단으로 이동
        document.getElementById('flightResults').scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
}

// 선택한 항공편 표시 업데이트
function updateSelectedFlightsDisplay() {
    const container = document.getElementById('selectedFlightsContainer');
    const list = document.getElementById('selectedFlightsList');

    if (selectedFlights.length === 0) {
        container.style.display = 'none';
        return;
    }

    container.style.display = 'block';

    let html = '';
    let totalPrice = 0;

    selectedFlights.forEach((flight, index) => {
        let label = '';
        if (currentSearchType === 'round') {
            label = index === 0 ? '가는편' : '오는편';
        } else {
            label = '구간 ' + (index + 1);
        }

        totalPrice += flight.price;

        html += '<div class="selected-flight-item">' +
            '<div class="selected-flight-info">' +
                '<span class="selected-flight-label">' + label + '</span>' +
                '<div class="selected-flight-detail">' +
                    '<span class="selected-flight-time">' + flight.departureTime + ' → ' + flight.arrivalTime + '</span>' +
                    '<span class="selected-flight-route">' + flight.departureAirport + ' → ' + flight.arrivalAirport + '</span>' +
                '</div>' +
                '<span class="selected-flight-airline">' + flight.airline + '</span>' +
            '</div>' +
            '<span class="selected-flight-price">' + flight.price.toLocaleString() + '원</span>' +
        '</div>';
    });

    // 모든 구간 선택 완료 시 총 금액 및 결제 버튼 표시
    if (currentSelectionStep >= totalSegments) {
        html += '<div class="selected-flights-total">' +
            '<div>' +
                '<span class="total-price-label">총 금액</span>' +
                '<span class="total-price-value ms-3">' + totalPrice.toLocaleString() + '원</span>' +
            '</div>' +
            '<a href="${pageContext.request.contextPath}/product/flight/booking" class="btn btn-primary btn-lg">' +
                '<i class="bi bi-credit-card me-2"></i>결제하기' +
            '</a>' +
        '</div>';
    }

    list.innerHTML = html;
}

// 선택 초기화
function resetFlightSelection() {
    selectedFlights = [];
    currentSelectionStep = 0;

    document.getElementById('selectedFlightsContainer').style.display = 'none';
    document.getElementById('selectedFlightsList').innerHTML = '';

    updateFlightButtons();
    updateSelectionStepIndicator();
}

// 결제 페이지로 이동
function goToBooking(flights) {
    // 항공편 데이터를 sessionStorage에 저장
    const bookingData = {
        tripType: currentSearchType,
        totalSegments: totalSegments,
        flights: flights.map((f, index) => ({
            ...f,
            segmentIndex: index,
            segmentLabel: getSegmentLabel(index)
        }))
    };
    sessionStorage.setItem('flightBookingData', JSON.stringify(bookingData));

    const flightIds = flights.map(f => f.id).join(',');
    window.location.href = '${pageContext.request.contextPath}/product/flight/booking?flightIds=' + flightIds + '&type=' + currentSearchType;
}

// 구간 라벨 생성
function getSegmentLabel(index) {
    if (currentSearchType === 'round') {
        return index === 0 ? '가는편' : '오는편';
    } else if (currentSearchType === 'multi') {
        return '구간 ' + (index + 1);
    } else {
        return '편도';
    }
}

// 구간 추가
function addSegment() {
    if (segmentCount >= MAX_SEGMENTS) {
        showToast('최대 ' + MAX_SEGMENTS + '개 구간까지 추가 가능합니다.', 'warning');
        return;
    }

    segmentCount++;

    var segmentHtml = '<div class="multi-city-segment" data-segment="' + segmentCount + '">' +
        '<div class="segment-header">' +
            '<span class="segment-number">구간 ' + segmentCount + '</span>' +
        '</div>' +
        '<div class="segment-fields">' +
            '<div class="form-group">' +
                '<label class="form-label">출발지</label>' +
                '<div class="search-input-group">' +
                    '<span class="input-icon"><i class="bi bi-geo-alt"></i></span>' +
                    '<input type="text" class="form-control location-autocomplete" name="multiDeparture[]" placeholder="도시 또는 공항" autocomplete="off">' +
                    '<div class="autocomplete-dropdown"></div>' +
                '</div>' +
            '</div>' +
            '<div class="form-group">' +
                '<label class="form-label">도착지</label>' +
                '<div class="search-input-group">' +
                    '<span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>' +
                    '<input type="text" class="form-control location-autocomplete" name="multiDestination[]" placeholder="도시 또는 공항" autocomplete="off">' +
                    '<div class="autocomplete-dropdown"></div>' +
                '</div>' +
            '</div>' +
            '<div class="form-group">' +
                '<label class="form-label">출발일</label>' +
                '<input type="text" class="form-control date-picker-multi" name="multiDate[]" placeholder="날짜 선택">' +
            '</div>' +
            '<div class="segment-action">' +
                '<button type="button" class="btn-remove-segment" onclick="removeSegment(' + segmentCount + ')" title="구간 삭제">' +
                    '<i class="bi bi-x-lg"></i>' +
                '</button>' +
            '</div>' +
        '</div>' +
    '</div>';

    document.getElementById('multiCitySegments').insertAdjacentHTML('beforeend', segmentHtml);

    // 새로 추가된 구간의 날짜 선택기 초기화
    var newSegment = document.querySelector('.multi-city-segment[data-segment="' + segmentCount + '"]');
    var newDateInput = newSegment.querySelector('.date-picker-multi');
    if (newDateInput && typeof flatpickr !== 'undefined') {
        flatpickr(newDateInput, {
            dateFormat: 'Y-m-d',
            minDate: 'today',
            locale: 'ko'
        });
    }

    // 새로 추가된 구간의 자동완성 초기화
    initSegmentAutocomplete(newSegment);

    // 최대 구간 도달 시 버튼 비활성화
    if (segmentCount >= MAX_SEGMENTS) {
        document.getElementById('addSegmentBtn').disabled = true;
        document.getElementById('addSegmentBtn').classList.add('disabled');
    }

    // 다구간 모드에서 totalSegments 업데이트
    if (currentSearchType === 'multi') {
        totalSegments = segmentCount;
        resetFlightSelection();
    }

    showToast('구간 ' + segmentCount + '이(가) 추가되었습니다.', 'success');
}

// 구간 삭제
function removeSegment(segmentNum) {
    var segments = document.querySelectorAll('.multi-city-segment');

    if (segments.length <= 2) {
        showToast('최소 2개 구간이 필요합니다.', 'warning');
        return;
    }

    var segmentToRemove = document.querySelector('.multi-city-segment[data-segment="' + segmentNum + '"]');
    if (segmentToRemove) {
        segmentToRemove.style.transition = 'all 0.3s ease';
        segmentToRemove.style.opacity = '0';
        segmentToRemove.style.transform = 'translateX(-20px)';

        setTimeout(function() {
            segmentToRemove.remove();
            updateSegmentNumbers();
            segmentCount = document.querySelectorAll('.multi-city-segment').length;

            // 구간 추가 버튼 다시 활성화
            if (segmentCount < MAX_SEGMENTS) {
                document.getElementById('addSegmentBtn').disabled = false;
                document.getElementById('addSegmentBtn').classList.remove('disabled');
            }

            // 다구간 모드에서 totalSegments 업데이트
            if (currentSearchType === 'multi') {
                totalSegments = segmentCount;
                resetFlightSelection();
            }
        }, 300);
    }
}

// 구간 번호 재정렬
function updateSegmentNumbers() {
    var segments = document.querySelectorAll('.multi-city-segment');
    segments.forEach(function(segment, index) {
        var num = index + 1;
        segment.setAttribute('data-segment', num);
        segment.querySelector('.segment-number').textContent = '구간 ' + num;

        // 삭제 버튼 업데이트 (첫 번째 구간 제외)
        var actionDiv = segment.querySelector('.segment-action');
        if (num === 1) {
            actionDiv.innerHTML = '<!-- 첫 번째 구간은 삭제 불가 -->';
        } else {
            actionDiv.innerHTML = '<button type="button" class="btn-remove-segment" onclick="removeSegment(' + num + ')" title="구간 삭제">' +
                '<i class="bi bi-x-lg"></i>' +
            '</button>';
        }
    });
}

// 승객 패널 토글
function togglePassengerPanel() {
    document.getElementById('passengerPanel').classList.toggle('active');
    // 다구간 패널 닫기
    document.getElementById('multiPassengerPanel').classList.remove('active');
}

// 다구간 승객 패널 토글
function toggleMultiPassengerPanel() {
    document.getElementById('multiPassengerPanel').classList.toggle('active');
    // 일반 패널 닫기
    document.getElementById('passengerPanel').classList.remove('active');
}

// 패널 외부 클릭 시 닫기
document.addEventListener('click', function(e) {
    // 일반 검색 승객 드롭다운
    const dropdown = document.querySelector('.search-form-row.mt-3 .passenger-dropdown');
    if (dropdown && !dropdown.contains(e.target)) {
        document.getElementById('passengerPanel').classList.remove('active');
    }

    // 다구간 검색 승객 드롭다운
    const multiDropdown = document.querySelector('.multi-city-options .passenger-dropdown');
    if (multiDropdown && !multiDropdown.contains(e.target)) {
        document.getElementById('multiPassengerPanel').classList.remove('active');
    }
});

// 승객 수 업데이트
function updatePassenger(type, delta) {
    const newValue = passengers[type] + delta;

    if (type === 'adult' && newValue < 1) return;
    if (newValue < 0) return;
    if (newValue > 9) return;

    passengers[type] = newValue;
    document.getElementById(type + 'Count').textContent = newValue;

    // 입력 필드 업데이트
    let text = [];
    if (passengers.adult > 0) text.push('성인 ' + passengers.adult + '명');
    if (passengers.child > 0) text.push('소아 ' + passengers.child + '명');
    if (passengers.infant > 0) text.push('유아 ' + passengers.infant + '명');
    document.getElementById('passengerInput').value = text.join(', ');
}

// 다구간 승객 수 업데이트
function updateMultiPassenger(type, delta) {
    const newValue = multiPassengers[type] + delta;

    if (type === 'adult' && newValue < 1) return;
    if (newValue < 0) return;
    if (newValue > 9) return;

    // 유아는 성인 수를 초과할 수 없음
    if (type === 'infant' && newValue > multiPassengers.adult) {
        showToast('유아는 성인 수를 초과할 수 없습니다.', 'warning');
        return;
    }

    multiPassengers[type] = newValue;
    document.getElementById('multi' + type.charAt(0).toUpperCase() + type.slice(1) + 'Count').textContent = newValue;

    // 입력 필드 업데이트
    let text = [];
    if (multiPassengers.adult > 0) text.push('성인 ' + multiPassengers.adult + '명');
    if (multiPassengers.child > 0) text.push('소아 ' + multiPassengers.child + '명');
    if (multiPassengers.infant > 0) text.push('유아 ' + multiPassengers.infant + '명');
    document.getElementById('multiPassengerInput').value = text.join(', ');
}

// 정렬 옵션
document.querySelectorAll('.sort-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        document.querySelectorAll('.sort-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        // 실제 구현 시 정렬 로직
    });
});

// ==================== 인피니티 스크롤 ====================
var flightCurrentPage = 1;
var flightIsLoading = false;
var flightHasMore = true;
var flightTotalPages = 4;

// 추가 항공편 데모 데이터
var additionalFlights = [
    {
        airline: '아시아나',
        flightNo: 'OZ8905',
        departureTime: '09:30',
        departureAirport: 'GMP 김포',
        arrivalTime: '10:40',
        arrivalAirport: 'CJU 제주',
        duration: '1시간 10분',
        type: '직항',
        price: 62000,
        fuel: 28000,
        tax: 24000,
        baggage: '15kg'
    },
    {
        airline: '티웨이항공',
        flightNo: 'TW701',
        departureTime: '11:15',
        departureAirport: 'GMP 김포',
        arrivalTime: '12:25',
        arrivalAirport: 'CJU 제주',
        duration: '1시간 10분',
        type: '직항',
        price: 48000,
        fuel: 25000,
        tax: 22000,
        baggage: '15kg'
    },
    {
        airline: '에어서울',
        flightNo: 'RS501',
        departureTime: '14:00',
        departureAirport: 'GMP 김포',
        arrivalTime: '15:10',
        arrivalAirport: 'CJU 제주',
        duration: '1시간 10분',
        type: '직항',
        price: 45000,
        fuel: 25000,
        tax: 20000,
        baggage: '15kg'
    },
    {
        airline: '진에어',
        flightNo: 'LJ301',
        departureTime: '16:30',
        departureAirport: 'GMP 김포',
        arrivalTime: '17:40',
        arrivalAirport: 'CJU 제주',
        duration: '1시간 10분',
        type: '직항',
        price: 52000,
        fuel: 26000,
        tax: 22000,
        baggage: '15kg'
    }
];

// 페이지 로드시 초기화
document.addEventListener('DOMContentLoaded', function() {
    initFlightInfiniteScroll();
    // 항공편 선택 버튼 및 표시 초기화
    updateFlightButtons();
    updateSelectionStepIndicator();
});

function initFlightInfiniteScroll() {
    var loader = document.getElementById('flightScrollLoader');
    if (!loader) return;

    var observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting && !flightIsLoading && flightHasMore) {
                loadMoreFlights();
            }
        });
    }, {
        root: null,
        rootMargin: '100px',
        threshold: 0
    });

    observer.observe(loader);
}

function loadMoreFlights() {
    if (flightIsLoading || !flightHasMore) return;

    flightIsLoading = true;
    document.getElementById('flightScrollLoader').style.display = 'flex';

    setTimeout(function() {
        flightCurrentPage++;

        if (flightCurrentPage > flightTotalPages) {
            flightHasMore = false;
            document.getElementById('flightScrollLoader').style.display = 'none';
            document.getElementById('flightScrollEnd').style.display = 'block';
            flightIsLoading = false;
            return;
        }

        var resultsList = document.getElementById('flightResults');
        var loader = document.getElementById('flightScrollLoader');
        var flightsToAdd = getFlightsForPage(flightCurrentPage);

        flightsToAdd.forEach(function(flight, index) {
            var flightHtml = createFlightCard(flight, flightCurrentPage * 10 + index);
            var tempDiv = document.createElement('div');
            tempDiv.innerHTML = flightHtml;
            var newCard = tempDiv.firstElementChild;

            newCard.style.opacity = '0';
            newCard.style.transform = 'translateY(20px)';
            resultsList.insertBefore(newCard, loader);

            setTimeout(function() {
                newCard.style.transition = 'all 0.4s ease';
                newCard.style.opacity = '1';
                newCard.style.transform = 'translateY(0)';
            }, index * 100);
        });

        flightIsLoading = false;
    }, 800);
}

function getFlightsForPage(page) {
    var flights = [];
    for (var i = 0; i < 3; i++) {
        var dataIndex = ((page - 2) * 3 + i) % additionalFlights.length;
        flights.push(Object.assign({}, additionalFlights[dataIndex]));
    }
    return flights;
}

function createFlightCard(data, id) {
    // 버튼 텍스트 결정
    var isLastStep = (currentSelectionStep >= totalSegments - 1);
    var buttonText = (currentSearchType === 'oneway' || isLastStep) ? '결제하기' : '선택';

    // 공항 코드 추출 (예: "GMP 김포" -> "GMP")
    var depCode = data.departureAirport.split(' ')[0];
    var arrCode = data.arrivalAirport.split(' ')[0];

    return '<div class="flight-card" data-flight-id="' + id + '">' +
        '<div class="flight-card-content">' +
            '<div class="flight-info">' +
                '<div class="flight-time">' +
                    '<div class="time">' + data.departureTime + '</div>' +
                    '<div class="airport">' + data.departureAirport + '</div>' +
                '</div>' +
            '</div>' +
            '<div class="flight-duration">' +
                '<div class="duration-line">' +
                    '<i class="bi bi-airplane"></i>' +
                '</div>' +
                '<div class="duration-text">' + data.duration + '</div>' +
                '<div class="flight-airline">' + data.airline + ' ' + data.flightNo + '</div>' +
                '<div class="stops direct">' + data.type + '</div>' +
            '</div>' +
            '<div class="flight-info">' +
                '<div class="flight-time">' +
                    '<div class="time">' + data.arrivalTime + '</div>' +
                    '<div class="airport">' + data.arrivalAirport + '</div>' +
                '</div>' +
            '</div>' +
            '<div class="flight-baggage">' +
                '<i class="bi bi-luggage-fill"></i>' +
                '<span>' + data.baggage + '</span>' +
            '</div>' +
            '<div class="flight-price">' +
                '<div class="price">' + data.price.toLocaleString() + '<span class="price-unit">원</span></div>' +
                '<button type="button" class="btn btn-primary btn-sm flight-action-btn" ' +
                    'onclick="selectFlight(' + id + ', \'' + data.airline + ' ' + data.flightNo + '\', \'' +
                    data.departureTime + '\', \'' + data.arrivalTime + '\', \'' + depCode + '\', \'' + arrCode + '\', ' +
                    data.price + ', \'' + data.baggage + '\')">' +
                    buttonText +
                '</button>' +
            '</div>' +
        '</div>' +
    '</div>';
}

// 검색 폼 제출
document.getElementById('flightSearchForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const activeTab = document.querySelector('.search-tab.active');
    const searchType = activeTab ? activeTab.dataset.type : 'round';

    if (searchType === 'multi') {
        // 다구간 검색 유효성 검사
        const segments = document.querySelectorAll('.multi-city-segment');
        let isValid = true;
        let errorMessage = '';

        segments.forEach(function(segment, index) {
            const departure = segment.querySelector('input[name="multiDeparture[]"]').value;
            const destination = segment.querySelector('input[name="multiDestination[]"]').value;
            const date = segment.querySelector('input[name="multiDate[]"]').value;

            if (!departure || !destination || !date) {
                isValid = false;
                errorMessage = '구간 ' + (index + 1) + '의 모든 정보를 입력해주세요.';
            }
        });

        if (!isValid) {
            showToast(errorMessage, 'error');
            return;
        }

        // 다구간 검색 데이터 수집
        const multiCityData = {
            segments: [],
            passengers: {
                adult: multiPassengers.adult,
                child: multiPassengers.child,
                infant: multiPassengers.infant
            },
            cabinClass: document.getElementById('multiCabinClass').value,
            directOnly: document.getElementById('multiDirectOnly').checked
        };

        segments.forEach(function(segment) {
            multiCityData.segments.push({
                departure: segment.querySelector('input[name="multiDeparture[]"]').value,
                destination: segment.querySelector('input[name="multiDestination[]"]').value,
                date: segment.querySelector('input[name="multiDate[]"]').value
            });
        });

        console.log('다구간 검색 데이터:', multiCityData);
        showToast(multiCityData.segments.length + '개 구간의 항공편을 검색하고 있습니다...', 'info');

        // 실제 구현 시 API 호출 또는 검색 결과 페이지로 이동
        // window.location.href = '/product/flight/search?type=multi&data=' + encodeURIComponent(JSON.stringify(multiCityData));

    } else {
        // 왕복/편도 검색
        const departure = document.getElementById('departure').value;
        const destination = document.getElementById('destination').value;

        if (!departure || !destination) {
            showToast('출발지와 도착지를 입력해주세요.', 'error');
            return;
        }

        showToast('항공편을 검색하고 있습니다...', 'info');
    }
});

// 페이지 로드 시 날짜 선택기 초기화
document.addEventListener('DOMContentLoaded', function() {
    // 일반 검색 날짜 선택기
    if (typeof flatpickr !== 'undefined') {
        flatpickr('.date-picker', {
            dateFormat: 'Y-m-d',
            minDate: 'today',
            locale: 'ko'
        });

        // 다구간 검색 날짜 선택기 초기화
        initMultiCityDatePickers();
    }
});

// 다구간 날짜 선택기 초기화
function initMultiCityDatePickers() {
    if (typeof flatpickr !== 'undefined') {
        flatpickr('.date-picker-multi', {
            dateFormat: 'Y-m-d',
            minDate: 'today',
            locale: 'ko'
        });
    }
}

// 새 구간의 자동완성 초기화
function initSegmentAutocomplete(segment) {
    const inputs = segment.querySelectorAll('.location-autocomplete');

    inputs.forEach(function(input) {
        const dropdown = input.nextElementSibling;
        if (!dropdown || !dropdown.classList.contains('autocomplete-dropdown')) return;

        let selectedIndex = -1;

        // 입력 이벤트
        input.addEventListener('input', function() {
            const query = this.value.trim();
            showSegmentAutocomplete(dropdown, query);
            selectedIndex = -1;
        });

        // 포커스 이벤트
        input.addEventListener('focus', function() {
            const query = this.value.trim();
            showSegmentAutocomplete(dropdown, query);
        });

        // 키보드 네비게이션
        input.addEventListener('keydown', function(e) {
            const items = dropdown.querySelectorAll('.autocomplete-item');

            if (e.key === 'ArrowDown') {
                e.preventDefault();
                selectedIndex = Math.min(selectedIndex + 1, items.length - 1);
                updateAutocompleteSelection(items, selectedIndex);
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                selectedIndex = Math.max(selectedIndex - 1, 0);
                updateAutocompleteSelection(items, selectedIndex);
            } else if (e.key === 'Enter' && selectedIndex >= 0) {
                e.preventDefault();
                items[selectedIndex]?.click();
            } else if (e.key === 'Escape') {
                dropdown.classList.remove('active');
            }
        });

        // 외부 클릭 시 닫기
        document.addEventListener('click', function(e) {
            if (!input.contains(e.target) && !dropdown.contains(e.target)) {
                dropdown.classList.remove('active');
            }
        });
    });
}

// 자동완성 드롭다운 표시
function showSegmentAutocomplete(dropdown, query) {
    // common.js의 locationData 사용
    if (typeof locationData === 'undefined') return;

    let results = [];
    const domesticResults = filterSegmentLocations(locationData.domestic, query, false);
    const overseasResults = filterSegmentLocations(locationData.overseas, query, true);

    let html = '';

    if (domesticResults.length > 0) {
        html += '<div class="autocomplete-section"><div class="autocomplete-section-title">국내</div>';
        html += domesticResults.map(function(loc) {
            return createAutocompleteItemHtml(loc, query);
        }).join('');
        html += '</div>';
    }

    if (overseasResults.length > 0) {
        html += '<div class="autocomplete-section"><div class="autocomplete-section-title">해외</div>';
        html += overseasResults.map(function(loc) {
            return createAutocompleteItemHtml(loc, query);
        }).join('');
        html += '</div>';
    }

    if (domesticResults.length === 0 && overseasResults.length === 0 && query) {
        html = '<div class="autocomplete-empty"><i class="bi bi-search"></i>"' + query + '"에 대한 검색 결과가 없습니다.</div>';
    }

    dropdown.innerHTML = html;
    dropdown.classList.add('active');

    // 클릭 이벤트 바인딩
    dropdown.querySelectorAll('.autocomplete-item').forEach(function(item) {
        item.addEventListener('click', function() {
            const input = dropdown.previousElementSibling;
            input.value = this.dataset.name;
            dropdown.classList.remove('active');
        });
    });
}

// 지역 필터링
function filterSegmentLocations(locations, query, isOverseas) {
    if (!query) {
        return locations.slice(0, 8).map(function(loc) {
            return Object.assign({}, loc, { isOverseas: isOverseas });
        });
    }

    const lowerQuery = query.toLowerCase();
    return locations
        .filter(function(loc) {
            return loc.name.toLowerCase().includes(lowerQuery) ||
                   loc.sub.toLowerCase().includes(lowerQuery);
        })
        .slice(0, 10)
        .map(function(loc) {
            return Object.assign({}, loc, { isOverseas: isOverseas });
        });
}

// 자동완성 아이템 HTML 생성
function createAutocompleteItemHtml(location, query) {
    const highlightedName = query ? location.name.replace(new RegExp('(' + query + ')', 'gi'), '<mark>$1</mark>') : location.name;
    const iconClass = location.isOverseas ? 'overseas' : '';
    const icon = location.isOverseas ? 'bi-airplane' : 'bi-geo-alt';

    return '<div class="autocomplete-item" data-name="' + location.name + '" data-code="' + location.code + '">' +
           '<div class="autocomplete-item-icon ' + iconClass + '"><i class="bi ' + icon + '"></i></div>' +
           '<div class="autocomplete-item-info"><div class="autocomplete-item-name">' + highlightedName + '</div>' +
           '<div class="autocomplete-item-sub">' + location.sub + '</div></div></div>';
}

// 자동완성 선택 상태 업데이트
function updateAutocompleteSelection(items, index) {
    items.forEach(function(item, i) {
        if (i === index) {
            item.classList.add('selected');
        } else {
            item.classList.remove('selected');
        }
    });

    if (items[index]) {
        items[index].scrollIntoView({ block: 'nearest' });
    }
}

// 다구간 폼 초기화 (페이지 로드 시 기존 구간들의 자동완성 초기화)
function initMultiCityAutocomplete() {
    const segments = document.querySelectorAll('.multi-city-segment');
    segments.forEach(function(segment) {
        initSegmentAutocomplete(segment);
    });
}

// 페이지 로드 완료 시 다구간 자동완성 초기화
document.addEventListener('DOMContentLoaded', function() {
    initMultiCityAutocomplete();
});
</script>

<c:set var="pageJs" value="product" />
<%@ include file="../common/footer.jsp" %>
