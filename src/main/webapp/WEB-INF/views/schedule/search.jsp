<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="일정 검색" />
<c:set var="pageCss" value="schedule" />

<%@ include file="../common/header.jsp" %>

<div class="schedule-search-page">
    <div id="loadingOverlay" class="d-none position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center" 
        style="background: rgba(0, 0, 0, 0.5); z-index: 9999;">
        <div class="text-center text-white">
            <div class="spinner-border" role="status" style="width: 3rem; height: 3rem;">
                <span class="visually-hidden">Loading...</span>
            </div>
            <div class="mt-2">데이터를 처리 중입니다...</div>
        </div>
    </div>

    <div class="container">
        <!-- 진행 단계 표시 -->
        <div class="preference-steps" id="stepIndicator">
            <div class="preference-step active" data-step="1">
                <div class="step-number">1</div>
                <span class="step-label">여행지 선택</span>
            </div>
            <div class="preference-step" data-step="2">
                <div class="step-number">2</div>
                <span class="step-label">계획 방식</span>
            </div>
            <div class="preference-step" data-step="3">
                <div class="step-number">3</div>
                <span class="step-label">추천 유형</span>
            </div>
            <div class="preference-step" data-step="4">
                <div class="step-number">4</div>
                <span class="step-label">여행 스타일</span>
            </div>
            <div class="preference-step" data-step="5">
                <div class="step-number">5</div>
                <span class="step-label">세부 선호도</span>
            </div>
        </div>

        <!-- Step 1: 여행지 선택 -->
        <div class="preference-card" id="step1" data-step="1">
            <h2 class="preference-title">어디로 여행을 떠나시나요?</h2>
            <p class="preference-subtitle">여행하고 싶은 지역을 선택해주세요</p>

            <!-- 메인 페이지 스타일 검색 폼 -->
            <div class="search-form-wrapper">
                <div class="search-form schedule-search-form">
                    <div class="search-input-group">
                        <label>출발지</label>
<!--                         <span class="input-icon"><i class="bi bi-geo-alt"></i></span> -->
                        <span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>
                        <input type="text" class="form-control location-autocomplete" id="departure" placeholder="어디서 출발하시나요?" value="서울" autocomplete="off">
                        <div class="autocomplete-dropdown" id="departureDropdown"></div>
                    </div>

                    <div class="search-input-group">
                        <label>도착지</label>
                        <span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>
                        <input type="text" class="form-control location-autocomplete" id="destination" placeholder="어디로 가시나요?" autocomplete="off">
                        <div class="autocomplete-dropdown" id="destinationDropdown"></div>
                    </div>

                    <div class="search-input-group travelers-group">
                        <label>여행 인원</label>
                        <span class="input-icon"><i class="bi bi-people"></i></span>
                        <div class="traveler-selector">
                            <button type="button" class="traveler-btn minus" onclick="changeTravelers(-1)">
                                <i class="bi bi-dash-lg"></i>
                            </button>
                            <span class="traveler-count" id="travelerCount">1</span>
                            <span class="traveler-unit">명</span>
                            <button type="button" class="traveler-btn plus" onclick="changeTravelers(1)">
                                <i class="bi bi-plus-lg"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 날짜 선택 (별도 줄) -->
                <div class="date-select-row">
                    <label>여행 날짜</label>
                    <div class="date-input-wrapper">
                        <div class="date-input-box">
                            <span class="date-input-label">시작일</span>
                            <span class="date-input-icon"><i class="bi bi-calendar3"></i></span>
                            <span class="date-input-value" id="startDateDisplay">날짜 선택</span>
                        </div>
                        <span class="date-separator"><i class="bi bi-arrow-right"></i></span>
                        <div class="date-input-box">
                            <span class="date-input-label">종료일</span>
                            <span class="date-input-icon"><i class="bi bi-calendar3"></i></span>
                            <span class="date-input-value" id="endDateDisplay">날짜 선택</span>
                        </div>
                        <div class="date-duration" id="dateDuration"></div>
                    </div>
                    <input type="hidden" id="travelDates">
                </div>
            </div>

            <!-- 인기 여행지 빠른 선택 -->
            <div class="popular-destinations">
                <label class="popular-label">인기 여행지</label>
                <div class="destination-chips">
                	<c:forEach items="${ popRegionList }" var="popregion">
                		<button type="button" class="destination-chip" onclick="selectDestination('${ popregion.rgnNm }')">
	                        <i class="bi bi-geo-alt"></i> ${ popregion.rgnNm }
	                    </button>
                	</c:forEach>
                    
<!--                     <button type="button" class="destination-chip" onclick="selectDestination('부산')"> -->
<!--                         <i class="bi bi-geo-alt"></i> 부산 -->
<!--                     </button> -->
<!--                     <button type="button" class="destination-chip" onclick="selectDestination('강릉')"> -->
<!--                         <i class="bi bi-geo-alt"></i> 강릉 -->
<!--                     </button> -->
<!--                     <button type="button" class="destination-chip" onclick="selectDestination('경주')"> -->
<!--                         <i class="bi bi-geo-alt"></i> 경주 -->
<!--                     </button> -->
<!--                     <button type="button" class="destination-chip" onclick="selectDestination('여수')"> -->
<!--                         <i class="bi bi-geo-alt"></i> 여수 -->
<!--                     </button> -->
<!--                     <button type="button" class="destination-chip" onclick="selectDestination('전주')"> -->
<!--                         <i class="bi bi-geo-alt"></i> 전주 -->
<!--                     </button> -->
                </div>
            </div>

            <div class="preference-buttons">
                <button type="button" class="btn btn-primary btn-lg" onclick="nextStep(2)">
                    다음 <i class="bi bi-arrow-right ms-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 2: 계획 방식 선택 -->
        <div class="preference-card" id="step2" data-step="2" style="display: none;">
            <h2 class="preference-title">어떻게 일정을 만들까요?</h2>
            <p class="preference-subtitle">원하는 계획 방식을 선택해주세요</p>

            <div class="plan-type-grid">
                <label class="plan-type-card">
                    <input type="radio" name="planMethod" value="recommend" checked>
                    <div class="plan-type-content">
                        <div class="plan-type-icon ai">
                            <i class="bi bi-stars"></i>
                        </div>
                        <div class="plan-type-badge">추천</div>
                        <h4 class="plan-type-title">일정 추천 받기</h4>
                        <p class="plan-type-desc">
                            선호도에 맞는 최적의 일정을<br>추천 받아보세요
                        </p>
                        <ul class="plan-type-features">
                            <li><i class="bi bi-check2"></i> AI 기반 맞춤 추천</li>
                            <li><i class="bi bi-check2"></i> 다른 이용자 일정 참고</li>
                            <li><i class="bi bi-check2"></i> 이동 경로 최적화</li>
                        </ul>
                    </div>
                </label>

                <label class="plan-type-card">
                    <input type="radio" name="planMethod" value="self">
                    <div class="plan-type-content">
                        <div class="plan-type-icon self">
                            <i class="bi bi-pencil-square"></i>
                        </div>
                        <h4 class="plan-type-title">직접 계획하기</h4>
                        <p class="plan-type-desc">
                            원하는 장소를 직접 검색하고<br>나만의 일정을 만들어보세요
                        </p>
                        <ul class="plan-type-features">
                            <li><i class="bi bi-check2"></i> 자유로운 장소 선택</li>
                            <li><i class="bi bi-check2"></i> 드래그 앤 드롭 편집</li>
                            <li><i class="bi bi-check2"></i> 세부 시간 조정 가능</li>
                        </ul>
                    </div>
                </label>
            </div>

            <div class="preference-buttons">
                <button type="button" class="btn btn-outline btn-lg" onclick="prevStep(1)">
                    <i class="bi bi-arrow-left me-2"></i> 이전
                </button>
                <button type="button" class="btn btn-primary btn-lg" onclick="handlePlanMethodNext()">
                    다음 <i class="bi bi-arrow-right ms-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 3: 추천 유형 선택 (추천 받기 선택 시에만 표시) -->
        <div class="preference-card" id="step3" data-step="3" style="display: none;">
            <h2 class="preference-title">어떤 추천을 받으시겠어요?</h2>
            <p class="preference-subtitle">원하는 추천 유형을 선택해주세요</p>

            <div class="recommend-type-grid">
                <label class="recommend-type-card">
                    <input type="radio" name="recommendType" value="ai_only" checked>
                    <div class="recommend-type-content">
                        <div class="recommend-type-icon">
                            <i class="bi bi-robot"></i>
                        </div>
                        <h4 class="recommend-type-title">AI 추천</h4>
                        <p class="recommend-type-desc">
                            AI가 선호도를 분석하여<br>최적의 일정을 추천해드립니다
                        </p>
                        <div class="recommend-type-features">
                            <span class="feature-tag"><i class="bi bi-cpu"></i> AI 분석</span>
                            <span class="feature-tag"><i class="bi bi-lightning-charge"></i> 맞춤 추천</span>
                            <span class="feature-tag"><i class="bi bi-sliders"></i> 선호도 반영</span>
                        </div>
                    </div>
                </label>

                <label class="recommend-type-card">
                    <input type="radio" name="recommendType" value="user_plans">
                    <div class="recommend-type-content">
                        <div class="recommend-type-icon">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <h4 class="recommend-type-title">다른 사용자 일정</h4>
                        <p class="recommend-type-desc">
                            다른 이용자들이 만든<br>인기 일정을 그대로 가져옵니다
                        </p>
                        <div class="recommend-type-features">
                            <span class="feature-tag"><i class="bi bi-heart"></i> 인기 일정</span>
                            <span class="feature-tag"><i class="bi bi-star"></i> 검증된 코스</span>
                            <span class="feature-tag"><i class="bi bi-copy"></i> 바로 복사</span>
                        </div>
                    </div>
                </label>
            </div>

            <div class="preference-buttons">
                <button type="button" class="btn btn-outline btn-lg" onclick="prevStep(2)">
                    <i class="bi bi-arrow-left me-2"></i> 이전
                </button>
                <button type="button" class="btn btn-primary btn-lg" onclick="handleRecommendTypeNext()">
                    다음 <i class="bi bi-arrow-right ms-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 4: 여행 스타일 선택 -->
        <div class="preference-card" id="step4" data-step="4" style="display: none;">
            <h2 class="preference-title">어떤 스타일의 여행을 원하시나요?</h2>
            <p class="preference-subtitle">나의 여행 스타일을 선택해주세요 (복수 선택 가능)</p>

            <div class="style-grid">
                <div class="style-card" onclick="toggleStyle(this, 'HEALING')">
                    <input type="checkbox" name="tripStyleCat" value="HEALING" hidden>
                    <div class="style-card-icon">
                        <i class="bi bi-tree"></i>
                    </div>
                    <h4 class="style-card-title">힐링 여행</h4>
                    <p class="style-card-desc">자연 속에서 여유롭게 쉬며 재충전하는 여행</p>
                    <div class="style-card-tags">
                        <span>온천</span>
                        <span>스파</span>
                        <span>휴양지</span>
                    </div>
                </div>

                <div class="style-card" onclick="toggleStyle(this, 'ACTIVITY')">
                    <input type="checkbox" name="tripStyleCat" value="ACTIVITY" hidden>
                    <div class="style-card-icon">
                        <i class="bi bi-bicycle"></i>
                    </div>
                    <h4 class="style-card-title">액티비티</h4>
                    <p class="style-card-desc">스릴 넘치는 활동으로 즐기는 여행</p>
                    <div class="style-card-tags">
                        <span>수상스포츠</span>
                        <span>등산</span>
                        <span>체험</span>
                    </div>
                </div>

                <div class="style-card" onclick="toggleStyle(this, 'FOODTOUR')">
                    <input type="checkbox" name="tripStyleCat" value="FOODTOUR" hidden>
                    <div class="style-card-icon">
                        <i class="bi bi-cup-hot"></i>
                    </div>
                    <h4 class="style-card-title">맛집 탐방</h4>
                    <p class="style-card-desc">지역 맛집과 카페를 찾아다니는 여행</p>
                    <div class="style-card-tags">
                        <span>로컬맛집</span>
                        <span>카페투어</span>
                        <span>시장</span>
                    </div>
                </div>

                <div class="style-card" onclick="toggleStyle(this, 'CULTURE')">
                    <input type="checkbox" name="tripStyleCat" value="CULTURE" hidden>
                    <div class="style-card-icon">
                        <i class="bi bi-bank"></i>
                    </div>
                    <h4 class="style-card-title">문화/역사</h4>
                    <p class="style-card-desc">역사적 명소와 문화를 체험하는 여행</p>
                    <div class="style-card-tags">
                        <span>박물관</span>
                        <span>유적지</span>
                        <span>전통체험</span>
                    </div>
                </div>

                <div class="style-card" onclick="toggleStyle(this, 'NATURE')">
                    <input type="checkbox" name="tripStyleCat" value="NATURE" hidden>
                    <div class="style-card-icon">
                        <i class="bi bi-sunrise"></i>
                    </div>
                    <h4 class="style-card-title">자연 감상</h4>
                    <p class="style-card-desc">아름다운 자연경관을 감상하는 여행</p>
                    <div class="style-card-tags">
                        <span>일출/일몰</span>
                        <span>해안도로</span>
                        <span>산/바다</span>
                    </div>
                </div>

                <div class="style-card" onclick="toggleStyle(this, 'PHOTO')">
                    <input type="checkbox" name="tripStyleCat" value="PHOTO" hidden>
                    <div class="style-card-icon">
                        <i class="bi bi-camera"></i>
                    </div>
                    <h4 class="style-card-title">사진 명소</h4>
                    <p class="style-card-desc">인생샷을 남길 수 있는 포토스팟 탐방</p>
                    <div class="style-card-tags">
                        <span>포토존</span>
                        <span>인스타</span>
                        <span>뷰맛집</span>
                    </div>
                </div>

                <div class="style-card" onclick="toggleStyle(this, 'SHOPPING')">
                    <input type="checkbox" name="tripStyleCat" value="SHOPPING" hidden>
                    <div class="style-card-icon">
                        <i class="bi bi-bag"></i>
                    </div>
                    <h4 class="style-card-title">쇼핑</h4>
                    <p class="style-card-desc">현지 특산품과 쇼핑을 즐기는 여행</p>
                    <div class="style-card-tags">
                        <span>특산품</span>
                        <span>기념품</span>
                        <span>아울렛</span>
                    </div>
                </div>

                <div class="style-card" onclick="toggleStyle(this, 'ROMANTIC')">
                    <input type="checkbox" name="tripStyleCat" value="ROMANTIC" hidden>
                    <div class="style-card-icon">
                        <i class="bi bi-heart"></i>
                    </div>
                    <h4 class="style-card-title">로맨틱</h4>
                    <p class="style-card-desc">연인과 함께하는 로맨틱한 여행</p>
                    <div class="style-card-tags">
                        <span>데이트</span>
                        <span>야경</span>
                        <span>분위기</span>
                    </div>
                </div>
            </div>

            <div class="preference-buttons">
                <button type="button" class="btn btn-outline btn-lg" onclick="prevStep(3)">
                    <i class="bi bi-arrow-left me-2"></i> 이전
                </button>
                <button type="button" class="btn btn-primary btn-lg" onclick="nextStep(5)">
                    다음 <i class="bi bi-arrow-right ms-2"></i>
                </button>
            </div>
        </div>

        <!-- Step 5: 세부 선호도 선택 -->
        <div class="preference-card" id="step5" data-step="5" style="display: none;">
            <h2 class="preference-title">세부 선호도를 알려주세요</h2>
            <p class="preference-subtitle">더 정확한 추천을 위해 선호도를 선택해주세요</p>

            <!-- 여행 페이스 -->
            <div class="preference-section">
                <h5 class="preference-section-title">
                    <i class="bi bi-speedometer2 me-2"></i>여행 페이스
                </h5>
                <p class="preference-section-desc">하루에 얼마나 많은 장소를 방문하고 싶으신가요?</p>
                <div class="pace-options">
                    <label class="pace-option">
                        <input type="radio" name="pace" value="relaxed">
                        <div class="pace-option-content">
                            <div class="pace-icon relaxed">
                                <i class="bi bi-emoji-smile"></i>
                            </div>
                            <span class="pace-name">여유롭게</span>
                            <span class="pace-desc">하루 2-3곳</span>
                        </div>
                    </label>
                    <label class="pace-option">
                        <input type="radio" name="pace" value="moderate" checked>
                        <div class="pace-option-content">
                            <div class="pace-icon moderate">
                                <i class="bi bi-emoji-neutral"></i>
                            </div>
                            <span class="pace-name">적당히</span>
                            <span class="pace-desc">하루 4-5곳</span>
                        </div>
                    </label>
                    <label class="pace-option">
                        <input type="radio" name="pace" value="busy">
                        <div class="pace-option-content">
                            <div class="pace-icon busy">
                                <i class="bi bi-lightning-charge"></i>
                            </div>
                            <span class="pace-name">알차게</span>
                            <span class="pace-desc">하루 6곳 이상</span>
                        </div>
                    </label>
                </div>
            </div>

            <!-- 예산 수준 -->
            <div class="preference-section">
                <h5 class="preference-section-title">
                    <i class="bi bi-wallet2 me-2"></i>예산 수준
                </h5>
                <p class="preference-section-desc">여행 예산은 어느 정도인가요?</p>
                <div class="budget-options">
                    <label class="budget-option">
                        <input type="radio" name="budget" value="low">
                        <div class="budget-option-content">
                            <div class="budget-icons">
                                <i class="bi bi-currency-dollar active"></i>
                                <i class="bi bi-currency-dollar"></i>
                                <i class="bi bi-currency-dollar"></i>
                            </div>
                            <span class="budget-name">가성비</span>
                            <span class="budget-range">~10만원/일</span>
                        </div>
                    </label>
                    <label class="budget-option">
                        <input type="radio" name="budget" value="medium" checked>
                        <div class="budget-option-content">
                            <div class="budget-icons">
                                <i class="bi bi-currency-dollar active"></i>
                                <i class="bi bi-currency-dollar active"></i>
                                <i class="bi bi-currency-dollar"></i>
                            </div>
                            <span class="budget-name">적당히</span>
                            <span class="budget-range">10~20만원/일</span>
                        </div>
                    </label>
                    <label class="budget-option">
                        <input type="radio" name="budget" value="high">
                        <div class="budget-option-content">
                            <div class="budget-icons">
                                <i class="bi bi-currency-dollar active"></i>
                                <i class="bi bi-currency-dollar active"></i>
                                <i class="bi bi-currency-dollar active"></i>
                            </div>
                            <span class="budget-name">럭셔리</span>
                            <span class="budget-range">20만원~/일</span>
                        </div>
                    </label>
                </div>
            </div>

            <!-- 숙소 유형 -->
            <div class="preference-section">
                <h5 class="preference-section-title">
                    <i class="bi bi-house-door me-2"></i>선호하는 숙소 유형
                </h5>
                <p class="preference-section-desc">어떤 숙소에서 머무르고 싶으신가요? (복수 선택 가능)</p>
                <div class="accommodation-options">
                    <label class="accommodation-option">
                        <input type="checkbox" name="accommodation" value="hotel">
                        <div class="accommodation-content">
                            <i class="bi bi-building"></i>
                            <span>호텔</span>
                        </div>
                    </label>
                    <label class="accommodation-option">
                        <input type="checkbox" name="accommodation" value="resort">
                        <div class="accommodation-content">
                            <i class="bi bi-water"></i>
                            <span>리조트</span>
                        </div>
                    </label>
                    <label class="accommodation-option">
                        <input type="checkbox" name="accommodation" value="pension">
                        <div class="accommodation-content">
                            <i class="bi bi-house"></i>
                            <span>펜션</span>
                        </div>
                    </label>
                    <label class="accommodation-option">
                        <input type="checkbox" name="accommodation" value="guesthouse">
                        <div class="accommodation-content">
                            <i class="bi bi-door-open"></i>
                            <span>게스트하우스</span>
                        </div>
                    </label>
                    <label class="accommodation-option">
                        <input type="checkbox" name="accommodation" value="airbnb">
                        <div class="accommodation-content">
                            <i class="bi bi-key"></i>
                            <span>에어비앤비</span>
                        </div>
                    </label>
                    <label class="accommodation-option">
                        <input type="checkbox" name="accommodation" value="camping">
                        <div class="accommodation-content">
                            <i class="bi bi-fire"></i>
                            <span>캠핑</span>
                        </div>
                    </label>
                </div>
            </div>

            <!-- 이동 수단 -->
            <div class="preference-section">
                <h5 class="preference-section-title">
                    <i class="bi bi-car-front me-2"></i>이동 수단
                </h5>
                <p class="preference-section-desc">주로 어떤 이동수단을 이용하실 예정인가요?</p>
                <div class="transport-options">
                    <label class="transport-option">
                        <input type="radio" name="transport" value="car" checked>
                        <div class="transport-content">
                            <i class="bi bi-car-front"></i>
                            <span>자가용/렌트카</span>
                        </div>
                    </label>
                    <label class="transport-option">
                        <input type="radio" name="transport" value="public">
                        <div class="transport-content">
                            <i class="bi bi-bus-front"></i>
                            <span>대중교통</span>
                        </div>
                    </label>
                    <label class="transport-option">
                        <input type="radio" name="transport" value="taxi">
                        <div class="transport-content">
                            <i class="bi bi-taxi-front"></i>
                            <span>택시/카풀</span>
                        </div>
                    </label>
                </div>
            </div>

            <!-- 선택 요약 -->
            <div class="selection-summary">
                <h5 class="summary-title"><i class="bi bi-clipboard-check me-2"></i>선택 내용 요약</h5>
                <div class="summary-content">
                    <div class="summary-item">
                        <span class="summary-label">여행지</span>
                        <span class="summary-value" id="summaryDestination">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">기간</span>
                        <span class="summary-value" id="summaryDates">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">인원</span>
                        <span class="summary-value" id="summaryTravelers">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">추천 유형</span>
                        <span class="summary-value" id="summaryRecommendType">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">스타일</span>
                        <span class="summary-value" id="summaryStyles">-</span>
                    </div>
                </div>
            </div>

            <div class="preference-buttons">
                <button type="button" class="btn btn-outline btn-lg" onclick="prevStep(4)">
                    <i class="bi bi-arrow-left me-2"></i> 이전
                </button>
                <button type="button" class="btn btn-primary btn-lg btn-gradient" onclick="submitPreference()">
                    <i class="bi bi-magic me-2"></i> 일정 추천 받기
                </button>
            </div>
        </div>
    </div>
</div>

<style>
/* 추천 유형 선택 스타일 */
.recommend-type-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 24px;
    max-width: 800px;
    margin: 0 auto 40px;
}

.recommend-type-card {
    cursor: pointer;
}

.recommend-type-card input[type="radio"] {
    display: none;
}

.recommend-type-content {
    background: white;
    border: 2px solid var(--gray-light);
    border-radius: var(--radius-xl);
    padding: 32px 24px;
    text-align: center;
    transition: all var(--transition-fast);
    height: 100%;
}

.recommend-type-card:hover .recommend-type-content {
    border-color: var(--primary-color);
    transform: translateY(-4px);
    box-shadow: var(--shadow-md);
}

.recommend-type-card input:checked + .recommend-type-content {
    border-color: var(--primary-color);
    background: linear-gradient(135deg, rgba(74, 144, 217, 0.05) 0%, rgba(46, 204, 113, 0.05) 100%);
    box-shadow: 0 8px 32px rgba(74, 144, 217, 0.2);
}

.recommend-type-icon {
    width: 80px;
    height: 80px;
    margin: 0 auto 20px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 36px;
    background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
    color: white;
}

.recommend-type-title {
    font-size: 20px;
    font-weight: 700;
    margin-bottom: 12px;
    color: var(--dark-color);
}

.recommend-type-desc {
    color: var(--gray-dark);
    font-size: 14px;
    line-height: 1.6;
    margin-bottom: 20px;
}

.recommend-type-features {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 8px;
}

.feature-tag {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    padding: 6px 12px;
    background: var(--gray-lighter);
    border-radius: 20px;
    font-size: 12px;
    color: var(--gray-dark);
}

.feature-tag i {
    font-size: 12px;
    color: var(--primary-color);
}

.recommend-type-card input:checked + .recommend-type-content .feature-tag {
    background: rgba(74, 144, 217, 0.1);
    color: var(--primary-color);
}

@media (max-width: 768px) {
    .recommend-type-grid {
        grid-template-columns: 1fr;
    }
}

/* 날짜 선택 스타일 */
.date-select-row {
    margin-top: 16px;
    padding: 20px;
    background: white;
    border-radius: var(--radius-lg);
    border: 1px solid var(--gray-light);
}

.date-select-row > label {
    display: block;
    font-size: 14px;
    font-weight: 600;
    color: var(--dark-color);
    margin-bottom: 12px;
}

.date-input-wrapper {
    display: flex;
    align-items: center;
    gap: 16px;
    flex-wrap: wrap;
}

.date-input-box {
    flex: 1;
    min-width: 180px;
    padding: 14px 16px;
    background: var(--light-color);
    border: 2px solid var(--gray-light);
    border-radius: var(--radius-md);
    cursor: pointer;
    transition: all var(--transition-fast);
    display: flex;
    align-items: center;
    gap: 12px;
}

.date-input-box:hover {
    border-color: var(--primary-color);
    background: white;
}

.date-input-box.active {
    border-color: var(--primary-color);
    background: white;
    box-shadow: 0 0 0 3px rgba(74, 144, 217, 0.1);
}

.date-input-label {
    font-size: 11px;
    color: var(--gray-medium);
    font-weight: 500;
    position: absolute;
    top: -8px;
    left: 12px;
    background: white;
    padding: 0 4px;
}

.date-input-box {
    position: relative;
}

.date-input-icon {
    color: var(--primary-color);
    font-size: 18px;
}

.date-input-value {
    font-size: 15px;
    font-weight: 500;
    color: var(--dark-color);
}

.date-input-value.placeholder {
    color: var(--gray-medium);
}

.date-separator {
    color: var(--gray-medium);
    font-size: 18px;
}

.date-duration {
    padding: 8px 16px;
    background: var(--primary-color);
    color: white;
    border-radius: 20px;
    font-size: 14px;
    font-weight: 600;
    white-space: nowrap;
}

.date-duration:empty {
    display: none;
}

@media (max-width: 576px) {
    .date-input-wrapper {
        flex-direction: column;
        align-items: stretch;
    }

    .date-separator {
        transform: rotate(90deg);
        align-self: center;
    }

    .date-input-box {
        min-width: 100%;
    }
}
</style>

<script>
let currentStep = 1;
let totalSteps = 5;
let travelerCount = 1;
let planMethod = 'recommend'; // 기본값: 추천 받기

// 여행지 빠른 선택
function selectDestination(destination) {
    document.getElementById('destination').value = destination;
    document.querySelectorAll('.destination-chip').forEach(chip => {
        chip.classList.remove('active');
        if (chip.textContent.includes(destination)) {
            chip.classList.add('active');
        }
    });
}

// 인원 변경
function changeTravelers(delta) {
    travelerCount = Math.max(1, Math.min(10, travelerCount + delta));
    document.getElementById('travelerCount').textContent = travelerCount;
}

// 여행 스타일 토글
function toggleStyle(card, value) {
    card.classList.toggle('selected');
    const checkbox = card.querySelector('input[type="checkbox"]');
    checkbox.checked = !checkbox.checked;
}

// 계획 방식에 따른 다음 단계 처리
function handlePlanMethodNext() {
    var selectedMethod = document.querySelector('input[name="planMethod"]:checked');
    if (!selectedMethod) {
        showMessage('계획 방식을 선택해주세요.');
        return;
    }

    planMethod = selectedMethod.value;

    if (planMethod === 'self') {
        // 직접 계획하기 선택 시 바로 planner 페이지로 이동
        goToPlanner();
    } else {
        // 추천 받기 선택 시 다음 단계(추천 유형 선택)로 이동
        nextStep(3);
    }
}

// 추천 유형에 따른 다음 단계 처리
function handleRecommendTypeNext() {
    var selectedType = document.querySelector('input[name="recommendType"]:checked');
    if (!selectedType) {
        showMessage('추천 유형을 선택해주세요.');
        return;
    }

    // 어떤 추천 유형이든 여행 스타일 선택 단계로 이동
    nextStep(4);
}

// planner 페이지로 이동
function goToPlanner() {
    // 기본 정보 저장
    var preferenceData = {
        departure: document.getElementById('departure').value,
        departurecode : document.getElementById('departure').dataset.code,
        destination: document.getElementById('destination').value,
        destinationcode : document.getElementById('destination').dataset.code,
        travelDates: document.getElementById('travelDates').value,
        travelerCount : travelerCount,
        travelers: travelerCount,
        planMethod: 'self'
    };

    sessionStorage.setItem('preferenceData', JSON.stringify(preferenceData));
    
    window.location.href = '${pageContext.request.contextPath}/schedule/planner';
}

// 다음 단계
function nextStep(step) {
    console.log('nextStep called, target step:', step, ', current step:', currentStep);

    try {
        if (!validateStep(currentStep)) {
            console.log('Validation failed for step:', currentStep);
            return;
        }
        console.log('Validation passed');

        // 현재 단계 완료 처리
        var currentStepEl = document.querySelector('.preference-step[data-step="' + currentStep + '"]');
        if (currentStepEl) {
            currentStepEl.classList.remove('active');
            currentStepEl.classList.add('completed');
        }

        // 다음 단계로 이동
        var currentPanel = document.getElementById('step' + currentStep);
        var nextPanel = document.getElementById('step' + step);

        if (currentPanel) currentPanel.style.display = 'none';
        if (nextPanel) nextPanel.style.display = 'block';

        // 진행 표시기 업데이트
        var nextStepEl = document.querySelector('.preference-step[data-step="' + step + '"]');
        if (nextStepEl) nextStepEl.classList.add('active');

        currentStep = step;

        // Step 5에서 요약 정보 업데이트
        if (step === 5) {
            updateSummary();
        }

        // 스크롤 상단으로
        window.scrollTo({ top: 0, behavior: 'smooth' });
        console.log('Successfully moved to step:', step);
    } catch (error) {
        console.error('Error in nextStep:', error);
        alert('오류가 발생했습니다: ' + error.message);
    }
}

// 이전 단계
function prevStep(step) {
    document.querySelector('.preference-step[data-step="' + currentStep + '"]').classList.remove('active');
    document.querySelector('.preference-step[data-step="' + step + '"]').classList.remove('completed');
    document.querySelector('.preference-step[data-step="' + step + '"]').classList.add('active');

    document.getElementById('step' + currentStep).style.display = 'none';
    document.getElementById('step' + step).style.display = 'block';

    currentStep = step;

    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// 메시지 표시
function showMessage(message) {
    console.log('Validation message:', message);
    if (typeof showToast === 'function') {
        showToast(message, 'error');
    } else {
        alert(message);
    }
}

// 유효성 검사
function validateStep(step) {
    console.log('validateStep called for step:', step);

    if (step === 1) {
        var departureEl = document.getElementById('departure');
        var destinationEl = document.getElementById('destination');
        var datesEl = document.getElementById('travelDates');

        console.log('Step 1 elements:', {
            departure: departureEl ? departureEl.value : 'NOT FOUND',
            destination: destinationEl ? destinationEl.value : 'NOT FOUND',
            dates: datesEl ? datesEl.value : 'NOT FOUND'
        });

        var departure = departureEl ? departureEl.value.trim() : '';
        var destination = destinationEl ? destinationEl.value.trim() : '';
        var dates = datesEl ? datesEl.value.trim() : '';

        if (!departure) {
            showMessage('출발지를 입력해주세요.');
            if (departureEl) departureEl.focus();
            return false;
        }
        if (!destination) {
            showMessage('도착지를 입력해주세요.');
            if (destinationEl) destinationEl.focus();
            return false;
        }
        if (!dates) {
            showMessage('여행 날짜를 선택해주세요.');
            if (datesEl) datesEl.focus();
            return false;
        }
        
        departureEl.removeAttribute("data-code");
        destinationEl.removeAttribute("data-code");
        
        domesticData = locationData.domestic;
        
    	for(const domestic of domesticData) {
    		let domesticVal = domestic.name;
    		if(domesticVal == departure) departureEl.dataset.code = domestic.code
    		if(domesticVal == destination) destinationEl.dataset.code = domestic.code
    	}
        
    	if(!departureEl.dataset.code) {
            showMessage('해당 출발지를 찾을 수 없습니다.');
            if (departureEl) datesEl.focus();
            return false;
    	}
    	
    	if(!destinationEl.dataset.code) {
    		showMessage('해당 도착지를 찾을 수 없습니다.');
            if (destinationEl) datesEl.focus();
            return false;
    	}
    	
//     	if (!dates) {
//             showMessage('여행 날짜를 선택해주세요.');
//             if (datesEl) datesEl.focus();
//             return false;
//         }
    	
    	
    }

    if (step === 4) {
        var styles = document.querySelectorAll('.style-card.selected');
        console.log('Step 4 selected styles count:', styles.length);
        if (styles.length === 0) {
            showMessage('여행 스타일을 최소 1개 선택해주세요.');
            return false;
        }
    }

    return true;
}

// 요약 정보 업데이트
function updateSummary() {
    var destination = document.getElementById('destination').value;
    var dates = document.getElementById('travelDates').value;

    document.getElementById('summaryDestination').textContent = destination || '-';
    document.getElementById('summaryDates').textContent = dates || '-';
    document.getElementById('summaryTravelers').textContent = travelerCount + '명';

    // 추천 유형
    var recommendTypeEl = document.querySelector('input[name="recommendType"]:checked');
    var recommendTypeText = recommendTypeEl && recommendTypeEl.value === 'user_plans' ? '다른 사용자 일정' : 'AI 추천';
    document.getElementById('summaryRecommendType').textContent = recommendTypeText;

    // 선택된 스타일
    var tripStyleCatList = [];
    var styleCards = document.querySelectorAll('.style-card.selected .style-card-title');
    for (var i = 0; i < styleCards.length; i++) {
        tripStyleCatList.push(styleCards[i].textContent);
    }
    document.getElementById('summaryStyles').textContent = tripStyleCatList.join(', ') || '-';
}

// 선호도 제출
function submitPreference() {
    // 선호도 데이터 수집
    var tripStyleCatList = [];
    var styleInputs = document.querySelectorAll('.style-card.selected input');
    for (var i = 0; i < styleInputs.length; i++) {
        tripStyleCatList.push(styleInputs[i].value);
    }

    var selectedAccommodations = [];
    var accommodationInputs = document.querySelectorAll('input[name="accommodation"]:checked');
    for (var j = 0; j < accommodationInputs.length; j++) {
        selectedAccommodations.push(accommodationInputs[j].value);
    }

    var paceEl = document.querySelector('input[name="pace"]:checked');
    var budgetEl = document.querySelector('input[name="budget"]:checked');
    var transportEl = document.querySelector('input[name="transport"]:checked');
    var recommendTypeEl = document.querySelector('input[name="recommendType"]:checked');
    var recommendType = recommendTypeEl ? recommendTypeEl.value : 'ai_only';

    var preferenceData = {
        departure: document.getElementById('departure').value,
        departurecode : document.getElementById('departure').dataset.code,
        destination: document.getElementById('destination').value,
        destinationcode : document.getElementById('destination').dataset.code,
        travelDates: document.getElementById('travelDates').value,
        travelers: travelerCount,
        planMethod: planMethod,
        recommendType: recommendType,
        tripStyleCatList: tripStyleCatList,
        pace: paceEl ? paceEl.value : 'moderate',
        budget: budgetEl ? budgetEl.value : 'medium',
        accommodation: selectedAccommodations,
        transport: transportEl ? transportEl.value : 'car'
    };

    // 세션 스토리지에 저장
    sessionStorage.setItem('preferenceData', JSON.stringify(preferenceData));
    
    // let rcmdForm = document.createElement("form");;
    // rcmdForm.setAttribute("method", "post");
    // rcmdForm.setAttribute("action", "${pageContext.request.contextPath}/schedule/rcmd-result");
    // document.body.appendChild(rcmdForm);
    // let input = document.createElement("input");
    // input.setAttribute("type", "hidden");
    // input.setAttribute("name", "preferenceData");
    // input.setAttribute("value", JSON.stringify(preferenceData));
    // rcmdForm.appendChild(input);
    // rcmdForm.submit();


    // 동일한 결과 페이지로 이동 (추천 유형에 따라 내용만 다르게 표시)
    // window.location.href = '${pageContext.request.contextPath}/schedule/rcmd-result';
    showLoadingLayout();
    aiResult(preferenceData);
}

// URL 파라미터 가져오기
function getUrlParameter(name) {
    var urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

// 날짜 선택기 초기화
document.addEventListener('DOMContentLoaded', function() {
    var dateInput = document.getElementById('travelDates');
    var startDateBox = document.querySelector('.date-input-box:first-child');
    var dateWrapper = document.querySelector('.date-input-wrapper');

    // URL 파라미터에서 값 가져오기
    var urlDeparture = getUrlParameter('departure');
    var urlDestination = getUrlParameter('destination');
    var urlTravelDate = getUrlParameter('travelDate');

    // 출발지 설정
    if (urlDeparture) {
        document.getElementById('departure').value = urlDeparture;
    }

    // 도착지 설정
    if (urlDestination) {
        document.getElementById('destination').value = urlDestination;
        // 인기 여행지 칩 활성화
        document.querySelectorAll('.destination-chip').forEach(function(chip) {
            if (chip.textContent.includes(urlDestination)) {
                chip.classList.add('active');
            }
        });
    }

    if (dateWrapper && typeof flatpickr !== 'undefined') {
        // 날짜 포맷팅 함수
        var formatDate = function(date) {
            var month = date.getMonth() + 1;
            var day = date.getDate();
            var weekdays = ['일', '월', '화', '수', '목', '금', '토'];
            var weekday = weekdays[date.getDay()];
            return month + '월 ' + day + '일 (' + weekday + ')';
        };

        // URL에서 받은 날짜 파싱
        var defaultDates = [];
        if (urlTravelDate) {
            // "2024-12-25 ~ 2024-12-28" 형식 파싱
            var dateParts = urlTravelDate.split(' ~ ');
            if (dateParts.length === 2) {
                defaultDates = [dateParts[0].trim(), dateParts[1].trim()];
            } else if (dateParts.length === 1) {
                // "2024-12-25 to 2024-12-28" 형식도 지원
                dateParts = urlTravelDate.split(' to ');
                if (dateParts.length === 2) {
                    defaultDates = [dateParts[0].trim(), dateParts[1].trim()];
                }
            }
        }

        var fp = flatpickr(dateWrapper, {
            mode: 'range',
            locale: 'ko',
            dateFormat: 'Y-m-d',
            minDate: 'today',
            disableMobile: true,
            inline: false,
            defaultDate: defaultDates.length === 2 ? defaultDates : null,
            onChange: function(selectedDates, dateStr) {
                var startDisplay = document.getElementById('startDateDisplay');
                var endDisplay = document.getElementById('endDateDisplay');
                var durationDisplay = document.getElementById('dateDuration');

                if (selectedDates.length >= 1) {
                    startDisplay.textContent = formatDate(selectedDates[0]);
                    startDisplay.classList.remove('placeholder');
                }

                if (selectedDates.length === 2) {
                    var days = Math.ceil((selectedDates[1] - selectedDates[0]) / (1000 * 60 * 60 * 24)) + 1;
                    var nights = days - 1;

                    endDisplay.textContent = formatDate(selectedDates[1]);
                    endDisplay.classList.remove('placeholder');
                    durationDisplay.textContent = nights + '박 ' + days + '일';

                    // hidden input에 값 저장
                    dateInput.value = dateStr;
                } else {
                    endDisplay.textContent = '날짜 선택';
                    endDisplay.classList.add('placeholder');
                    durationDisplay.textContent = '';
                }
            }
        });

        // URL에서 날짜가 있으면 초기 표시 업데이트
        if (defaultDates.length === 2) {
            var startDate = new Date(defaultDates[0]);
            var endDate = new Date(defaultDates[1]);

            var startDisplay = document.getElementById('startDateDisplay');
            var endDisplay = document.getElementById('endDateDisplay');
            var durationDisplay = document.getElementById('dateDuration');

            startDisplay.textContent = formatDate(startDate);
            startDisplay.classList.remove('placeholder');

            endDisplay.textContent = formatDate(endDate);
            endDisplay.classList.remove('placeholder');

            var days = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24)) + 1;
            var nights = days - 1;
            durationDisplay.textContent = nights + '박 ' + days + '일';

            // hidden input에 값 저장
            dateInput.value = urlTravelDate;
        }

        // 날짜 박스 클릭 시 캘린더 열기
        document.querySelectorAll('.date-input-box').forEach(function(box) {
            box.addEventListener('click', function() {
                fp.open();
            });
        });
    }
});

// 로딩 시작
function showLoadingLayout() {
    const loader = document.getElementById('loadingOverlay');
    loader.classList.remove('d-none');
}

// 로딩 종료
function hideLoadingLayout() {
    const loader = document.getElementById('loadingOverlay');
    loader.classList.add('d-none');
}

async function aiResult(preferenceData) {
    // AI 결과 처리 로직
    let response = await fetch('${pageContext.request.contextPath}/schedule/rcmd-result', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(preferenceData)
    });

    let responseData = await response.json();
    sessionStorage.setItem('aiRcmdData', JSON.stringify(responseData));
    hideLoadingLayout();
    location.href = '${pageContext.request.contextPath}/schedule/rcmd-result';
}
</script>

<c:set var="pageJs" value="schedule" />
<%@ include file="../common/footer.jsp" %>
