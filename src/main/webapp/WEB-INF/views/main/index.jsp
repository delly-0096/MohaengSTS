<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="나만의 여행을 계획하세요" />
<c:set var="pageCss" value="main" />

<%@ include file="../common/header.jsp" %>

<!-- 히어로 섹션 -->
<section class="hero-section">
     <video class="hero-video" autoplay muted loop playsinline>
        <source src="${pageContext.request.contextPath}/resources/videos/hero0126.mp4" type="video/mp4">
    </video>
    
    <div class="hero-overlay"></div>

    <div class="hero-content">
<%--         <div class="hero-logo-img">
            <img src="${pageContext.request.contextPath}/resources/images/moheng_CI_con.png" alt="모행" class="hero-brand-img">
        </div> --%>
        
<%--         <div class="hero-text-wrapper">
	        <div class="hero-logo motion-logo">
	            <img src="${pageContext.request.contextPath}/resources/images/moheng_CI.png" alt="모행" class="hero-brand-img">
	        </div>
        </div> --%>
        
		<div class="hero-text">
		  <img class="hero-logo-img" src="${pageContext.request.contextPath}/resources/images/moheng_CI_con.png" alt="모행" class="hero-brand-img">
		  <p class="hero-tagline">AI가 추천하는 나만의 맞춤 여행, 지금 시작하세요</p>
		</div>
		
        <!-- 여행 검색 폼 -->
        <div class="search-form-container">

            <form class="search-form" action="${pageContext.request.contextPath}/schedule/search" method="GET">
                <div class="search-input-group">
                    <label>출발지</label>
                    <span class="input-icon"><i class="bi bi-geo-alt"></i></span>
                    <input type="text" class="form-control location-autocomplete" name="departure" id="departureInput" placeholder="어디서 출발하시나요?" autocomplete="off">
                    <div class="autocomplete-dropdown" id="departureDropdown"></div>
                </div>

                <div class="search-input-group">
                    <label>도착지</label>
                    <span class="input-icon"><i class="bi bi-geo-alt-fill"></i></span>
                    <input type="text" class="form-control location-autocomplete" name="destination" id="destinationInput" placeholder="어디로 가시나요?" autocomplete="off">
                    <div class="autocomplete-dropdown" id="destinationDropdown"></div>
                </div>

                <div class="search-input-group">
                    <label>여행 날짜</label>
                    <span class="input-icon"><i class="bi bi-calendar3"></i></span>
                    <input type="text" class="form-control date-range-picker" name="travelDate" placeholder="날짜를 선택하세요">
                </div>

                <button type="submit" class="btn btn-primary search-btn">
                    <i class="bi bi-search me-2"></i>검색
                </button>
            </form>
        </div>
    </div>

    <!-- 스크롤 다운 인디케이터 -->
    <div class="scroll-indicator" onclick="document.getElementById('features').scrollIntoView({behavior: 'smooth'})">
        <span>스크롤하여 더 알아보기</span>
        <i class="bi bi-chevron-down"></i>
    </div>
</section>

<!-- 기능 소개 섹션 -->
<section class="features-section" id="features">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">모행이 특별한 이유</h2>
            <p class="section-subtitle">AI 기반 맞춤 추천부터 간편한 예약까지, 여행의 모든 것을 한 곳에서</p>
        </div>

        <div class="features-grid">
            <div class="feature-card animate-on-scroll">
                <div class="feature-icon">
                    <i class="bi bi-robot"></i>
                </div>
                <h3 class="feature-title">AI 맞춤 일정 추천</h3>
                <p class="feature-desc">
                    여행 스타일과 선호도를 분석하여 나만을 위한 최적의 여행 일정을 AI가 자동으로 추천해드립니다.
                </p>
            </div>

            <div class="feature-card animate-on-scroll">
                <div class="feature-icon">
                    <i class="bi bi-calendar-check"></i>
                </div>
                <h3 class="feature-title">스마트 일정 관리</h3>
                <p class="feature-desc">
                    직관적인 플래너로 여행지, 숙소, 맛집을 쉽게 추가하고 일정을 관리하세요.
                </p>
            </div>

            <div class="feature-card animate-on-scroll">
                <div class="feature-icon">
                    <i class="bi bi-airplane"></i>
                </div>
                <h3 class="feature-title">원스톱 예약</h3>
                <p class="feature-desc">
                    항공권, 숙박, 투어/체험까지 여행에 필요한 모든 것을 한 번에 검색하고 예약할 수 있습니다.
                </p>
            </div>

            <div class="feature-card animate-on-scroll">
                <div class="feature-icon">
                    <i class="bi bi-journal-richtext"></i>
                </div>
                <h3 class="feature-title">여행 기록 공유</h3>
                <p class="feature-desc">
                    인스타그램처럼 나만의 여행 기록을 남기고, 다른 여행자들의 생생한 후기를 확인하세요.
                </p>
            </div>

            <div class="feature-card animate-on-scroll">
                <div class="feature-icon">
                    <i class="bi bi-people"></i>
                </div>
                <h3 class="feature-title">여행 커뮤니티</h3>
                <p class="feature-desc">
                    동행을 구하거나 여행 정보를 공유하며 다른 여행자들과 소통하고 교류하세요.
                </p>
            </div>

            <div class="feature-card animate-on-scroll">
                <div class="feature-icon">
                    <i class="bi bi-chat-dots"></i>
                </div>
                <h3 class="feature-title">24시간 AI 챗봇</h3>
                <p class="feature-desc">
                    궁금한 점이 있으시면 언제든지 AI 챗봇에게 물어보세요. 여행 계획의 든든한 파트너가 되어드립니다.
                </p>
            </div>
        </div>
    </div>
</section>

<!-- AI 일정 추천 섹션 -->
<section class="ai-section">
    <div class="container">
        <div class="ai-content">
            <div class="ai-text">
                <h2>어떤 취향이든,<br>AI가 맞춰드려요</h2>
                <p>
                    힐링 여행? 액티비티 여행? 맛집 탐방?<br>
                    당신의 여행 스타일에 맞는 완벽한 일정을<br>
                    AI가 자동으로 추천해드립니다.
                </p>

                <div class="ai-features">
                    <div class="ai-feature-item">
                        <i class="bi bi-check"></i>
                        <span>여행 선호도 분석 기반 맞춤 추천</span>
                    </div>
                    <div class="ai-feature-item">
                        <i class="bi bi-check"></i>
                        <span>실시간 날씨, 혼잡도 반영</span>
                    </div>
                    <div class="ai-feature-item">
                        <i class="bi bi-check"></i>
                        <span>최적의 이동 경로 자동 설정</span>
                    </div>
                    <div class="ai-feature-item">
                        <i class="bi bi-check"></i>
                        <span>추천 일정 자유롭게 수정 가능</span>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/schedule/search" class="btn btn-white btn-lg">
                    <i class="bi bi-magic me-2"></i>AI 일정 추천 받기
                </a>
            </div>

            <div class="ai-image">
                <img src="resources/images/mohaeng_main_photo.png" alt="AI 일정 추천" style="border-radius: 20px;">
<!--                 <div class="ai-badge">
                    <i class="bi bi-stars me-1"></i> NEW
                </div> -->
            </div>
        </div>
    </div>
</section>

<!-- 인기 여행지 섹션 -->
<section class="destinations-section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">지금 인기 있는 여행지</h2>
            <p class="section-subtitle">모행 사용자들이 가장 많이 찾는 여행지를 만나보세요</p>
        </div>

        <div class="destinations-grid">
            <div class="destination-card animate-on-scroll">
                <img src="resources/images/jejuisland2.jpg" alt="제주도">
                <div class="destination-overlay">
                    <h3 class="destination-name">제주도</h3>
                    <p class="destination-country">대한민국</p>
                </div>
                <span class="destination-badge">인기</span>
            </div>

            <div class="destination-card animate-on-scroll">
                <img src="resources/images/busan2.jpg" alt="부산">
                <div class="destination-overlay">
                    <h3 class="destination-name">부산</h3>
                    <p class="destination-country">대한민국</p>
                </div>
            </div>

            <div class="destination-card animate-on-scroll">
                <img src="resources/images/gangneung.jpg" alt="강릉">
                <div class="destination-overlay">
                    <h3 class="destination-name">강릉</h3>
                    <p class="destination-country">대한민국</p>
                </div>
            </div>

            <div class="destination-card animate-on-scroll">
                <img src="resources/images/gyeongju3.jpg" alt="경주">
                <div class="destination-overlay">
                    <h3 class="destination-name">경주</h3>
                    <p class="destination-country">대한민국</p>
                </div>
                <span class="destination-badge">추천</span>
            </div>
        </div>
    </div>
</section>

<!-- 여행 기록 섹션 -->
<section class="travellog-section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">생생한 여행 기록</h2>
            <p class="section-subtitle">다른 여행자들의 특별한 순간을 확인해보세요</p>
        </div>

        <div class="travellog-grid">
            <div class="travellog-card animate-on-scroll">
                <div class="travellog-image">
                    <img src="resources/images/daejeon_trip.jpg" alt="여행기록">
                </div>
                <div class="travellog-content">
                    <h4 class="travellog-title">대전 여행 여행기</h4>
                    <div class="travellog-meta">
                        <span><i class="bi bi-heart-fill text-danger"></i> 10</span>
                        <span><i class="bi bi-chat"></i> 8</span>
                        <span><i class="bi bi-eye"></i> 57</span>
                    </div>
                </div>
            </div>

            <div class="travellog-card animate-on-scroll">
                <div class="travellog-image">
                    <img src="resources/images/seoul_trip.jpg" alt="여행기록">
                </div>
                <div class="travellog-content">
                    <h4 class="travellog-title">서울 한복판에서 찾은 짧은 쉼표</h4>
                    <div class="travellog-meta">
                        <span><i class="bi bi-heart-fill text-danger"></i> 5</span>
                        <span><i class="bi bi-chat"></i> 4</span>
                        <span><i class="bi bi-eye"></i> 37</span>
                    </div>
                </div>
            </div>

            <div class="travellog-card animate-on-scroll">
                <div class="travellog-image">
                    <img src="resources/images/jeju_trip.png" alt="여행기록">
                </div>
                <div class="travellog-content">
                    <h4 class="travellog-title">바람 따라 걷는 제주, 느리게 채운 3박 4일</h4>
                    <div class="travellog-meta">
                        <span><i class="bi bi-heart-fill text-danger"></i> 4</span>
                        <span><i class="bi bi-chat"></i> 2</span>
                        <span><i class="bi bi-eye"></i> 23</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center mt-5">
            <a href="${pageContext.request.contextPath}/community/travel-log" class="btn btn-outline btn-lg">
                더 많은 여행기록 보기 <i class="bi bi-arrow-right ms-2"></i>
            </a>
        </div>
    </div>
</section>

<!-- 통계 섹션 -->
<section class="stats-section">
    <div class="container">
        <div class="stats-grid">
            <div class="stat-item">
                <div class="stat-number" data-count="50000">50,000+</div>
                <div class="stat-label">누적 회원 수</div>
            </div>
            <div class="stat-item">
                <div class="stat-number" data-count="120000">120,000+</div>
                <div class="stat-label">생성된 여행 일정</div>
            </div>
            <div class="stat-item">
                <div class="stat-number" data-count="30000">30,000+</div>
                <div class="stat-label">여행 기록</div>
            </div>
            <div class="stat-item">
                <div class="stat-number" data-count="98">98%</div>
                <div class="stat-label">고객 만족도</div>
            </div>
        </div>
    </div>
</section>

<!-- CTA 섹션 -->
<section class="cta-section">
    <div class="container">
        <div class="cta-content">
            <h2 class="cta-title">지금 바로 시작하세요!</h2>
            <p class="cta-desc">
                무료 회원가입으로 AI 맞춤 일정 추천부터<br>
                다양한 혜택까지 모두 누려보세요.
            </p>
            <div class="cta-buttons">
                <a href="${pageContext.request.contextPath}/member/register" class="btn btn-white btn-lg">
                    무료 회원가입
                </a>
                <a href="${pageContext.request.contextPath}/schedule/search" class="btn btn-outline btn-lg" style="border-color: white; color: white;">
                    둘러보기
                </a>
            </div>
        </div>
    </div>
</section>

<c:set var="pageJs" value="main" />
<%@ include file="../common/footer.jsp" %>
