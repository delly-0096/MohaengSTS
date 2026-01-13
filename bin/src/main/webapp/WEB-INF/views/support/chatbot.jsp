<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="AI 챗봇" />
<c:set var="pageCss" value="support" />

<%@ include file="../common/header.jsp" %>

<div class="chatbot-page">
    <div class="container">
        <div class="chatbot-page-container">
            <!-- 헤더 -->
            <div class="chatbot-page-header">
                <h1><i class="bi bi-robot me-3"></i>AI 여행 도우미</h1>
                <p>원하시는 항목을 선택해주세요. 24시간 여행 상담이 가능합니다.</p>
            </div>

            <!-- 챗봇 창 -->
            <div class="chatbot-page-window">
                <!-- 메시지 영역 -->
                <div class="chatbot-page-messages" id="chatMessages">
                    <!-- 초기 메시지는 JavaScript로 생성 -->
                </div>
            </div>

            <!-- 기능 안내 -->
            <div class="chatbot-features">
                <div class="chatbot-feature">
                    <i class="bi bi-map"></i>
                    <h4>여행지 추천</h4>
                    <p>취향에 맞는 여행지를 추천받으세요</p>
                </div>
                <div class="chatbot-feature">
                    <i class="bi bi-calendar-check"></i>
                    <h4>일정 계획</h4>
                    <p>AI가 맞춤 일정을 만들어드려요</p>
                </div>
                <div class="chatbot-feature">
                    <i class="bi bi-question-circle"></i>
                    <h4>서비스 안내</h4>
                    <p>예약, 결제, 환불 등 궁금한 점을 해결하세요</p>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
/* 챗봇 전용 페이지에서는 플로팅 챗봇 숨김 */
.chatbot-float {
    display: none !important;
}

/* 선택지 버튼 스타일 */
.chat-options {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-top: 15px;
    padding-left: 52px;
}

.chat-option-btn {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 14px 20px;
    background: white;
    border: 2px solid #e2e8f0;
    border-radius: 12px;
    font-size: 15px;
    font-weight: 500;
    color: #334155;
    cursor: pointer;
    transition: all 0.2s ease;
    text-align: left;
}

.chat-option-btn:hover {
    border-color: var(--primary-color);
    background: rgba(74, 144, 217, 0.05);
    transform: translateX(5px);
}

.chat-option-btn i {
    font-size: 20px;
    color: var(--primary-color);
    width: 24px;
    text-align: center;
}

.chat-option-btn.back-btn {
    background: #f8fafc;
    border-color: #cbd5e1;
    color: #64748b;
    margin-top: 10px;
}

.chat-option-btn.back-btn:hover {
    background: #f1f5f9;
    border-color: #94a3b8;
}

.chat-option-btn.back-btn i {
    color: #64748b;
}

/* 선택된 옵션 스타일 (사용자 메시지) */
.chatbot-message.user .chatbot-bubble {
    background: var(--primary-color);
    color: white;
}

/* 챗봇 응답 내 링크 스타일 */
.chatbot-bubble a {
    color: var(--secondary-color);
    text-decoration: underline;
}

.chatbot-message.user .chatbot-bubble a {
    color: #e0f2fe;
}

/* 답변 내 정보 박스 */
.chat-info-box {
    background: #f0f9ff;
    border-left: 4px solid var(--primary-color);
    padding: 15px;
    border-radius: 0 8px 8px 0;
    margin: 10px 0;
}

.chat-info-box h5 {
    font-size: 14px;
    font-weight: 600;
    color: var(--primary-color);
    margin-bottom: 8px;
}

.chat-info-box ul {
    margin: 0;
    padding-left: 18px;
}

.chat-info-box li {
    margin-bottom: 5px;
    font-size: 14px;
}

/* 일정 카드 스타일 */
.chat-schedule-card {
    background: #f8fafc;
    border-radius: 12px;
    padding: 15px;
    margin: 10px 0;
}

.chat-schedule-day {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 10px 0;
    border-bottom: 1px dashed #e2e8f0;
}

.chat-schedule-day:last-child {
    border-bottom: none;
}

.chat-day-num {
    background: var(--primary-color);
    color: white;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    white-space: nowrap;
}

.chat-day-content {
    font-size: 14px;
    color: #475569;
    line-height: 1.5;
}
</style>

<script>
const chatMessages = document.getElementById('chatMessages');

// 챗봇 대화 데이터 구조
const chatData = {
    // 시작 화면
    start: {
        message: '안녕하세요! 모행 AI 여행 도우미입니다.<br>무엇을 도와드릴까요?',
        options: [
            { id: 'destination', icon: 'bi-geo-alt', text: '여행지 추천받기' },
            { id: 'schedule', icon: 'bi-calendar-check', text: '여행 일정 안내' },
            { id: 'booking', icon: 'bi-credit-card', text: '예약/결제 안내' },
            { id: 'service', icon: 'bi-headset', text: '서비스 이용 안내' }
        ]
    },

    // 여행지 추천
    destination: {
        message: '어떤 여행지를 찾고 계신가요?',
        options: [
            { id: 'dest_domestic', icon: 'bi-flag', text: '국내 여행지 추천' },
            { id: 'dest_season', icon: 'bi-sun', text: '계절별 추천 여행지' },
            { id: 'dest_theme', icon: 'bi-heart', text: '테마별 추천 여행지' },
            { id: 'start', icon: 'bi-arrow-left', text: '처음으로', isBack: true }
        ]
    },

    dest_domestic: {
        message: '어느 지역이 궁금하신가요?',
        options: [
            { id: 'dest_jeju', icon: 'bi-water', text: '제주도' },
            { id: 'dest_busan', icon: 'bi-building', text: '부산' },
            { id: 'dest_gangwon', icon: 'bi-snow', text: '강원도' },
            { id: 'dest_gyeongju', icon: 'bi-bank', text: '경주' },
            { id: 'destination', icon: 'bi-arrow-left', text: '이전으로', isBack: true }
        ]
    },

    dest_jeju: {
        message: `<strong>제주도 추천 여행 정보</strong>
            <div class="chat-info-box">
                <h5>인기 관광지</h5>
                <ul>
                    <li>성산일출봉 - 유네스코 세계자연유산</li>
                    <li>우도 - 에메랄드빛 바다와 땅콩 아이스크림</li>
                    <li>한라산 - 등반 및 둘레길 트레킹</li>
                    <li>협재해수욕장 - 투명한 바다와 하얀 모래</li>
                </ul>
            </div>
            <div class="chat-info-box">
                <h5>추천 맛집</h5>
                <ul>
                    <li>흑돼지 구이 - 제주 대표 먹거리</li>
                    <li>해물뚝배기 - 신선한 해산물</li>
                    <li>고기국수 - 제주식 국수</li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/product/tour?region=jeju">제주도 상품 보러가기 →</a>`,
        options: [
            { id: 'schedule_jeju', icon: 'bi-calendar-check', text: '제주도 추천 일정 보기' },
            { id: 'dest_domestic', icon: 'bi-arrow-left', text: '다른 지역 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    dest_busan: {
        message: `<strong>부산 추천 여행 정보</strong>
            <div class="chat-info-box">
                <h5>인기 관광지</h5>
                <ul>
                    <li>해운대해수욕장 - 대한민국 대표 해변</li>
                    <li>광안리 - 광안대교 야경</li>
                    <li>감천문화마을 - 알록달록 계단 마을</li>
                    <li>자갈치시장 - 싱싱한 해산물</li>
                </ul>
            </div>
            <div class="chat-info-box">
                <h5>추천 맛집</h5>
                <ul>
                    <li>돼지국밥 - 부산의 소울푸드</li>
                    <li>밀면 - 시원한 부산식 냉면</li>
                    <li>씨앗호떡 - 해운대 명물</li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/product/tour?region=busan">부산 상품 보러가기 →</a>`,
        options: [
            { id: 'schedule_busan', icon: 'bi-calendar-check', text: '부산 추천 일정 보기' },
            { id: 'dest_domestic', icon: 'bi-arrow-left', text: '다른 지역 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    dest_gangwon: {
        message: `<strong>강원도 추천 여행 정보</strong>
            <div class="chat-info-box">
                <h5>인기 관광지</h5>
                <ul>
                    <li>강릉 경포대 - 해돋이 명소</li>
                    <li>속초 설악산 - 단풍 및 등산</li>
                    <li>양양 서피비치 - 서핑 성지</li>
                    <li>평창 대관령 - 양떼목장, 스키장</li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/product/tour?region=gangwon">강원도 상품 보러가기 →</a>`,
        options: [
            { id: 'dest_domestic', icon: 'bi-arrow-left', text: '다른 지역 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    dest_gyeongju: {
        message: `<strong>경주 추천 여행 정보</strong>
            <div class="chat-info-box">
                <h5>인기 관광지</h5>
                <ul>
                    <li>불국사 & 석굴암 - 유네스코 세계문화유산</li>
                    <li>첨성대 - 신라 시대 천문대</li>
                    <li>동궁과 월지 - 야경 명소</li>
                    <li>대릉원 - 신라 왕릉 산책</li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/product/tour?region=gyeongju">경주 상품 보러가기 →</a>`,
        options: [
            { id: 'dest_domestic', icon: 'bi-arrow-left', text: '다른 지역 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    dest_season: {
        message: '어느 계절 여행을 계획하고 계신가요?',
        options: [
            { id: 'season_spring', icon: 'bi-flower1', text: '봄 (3~5월)' },
            { id: 'season_summer', icon: 'bi-sun', text: '여름 (6~8월)' },
            { id: 'season_fall', icon: 'bi-tree', text: '가을 (9~11월)' },
            { id: 'season_winter', icon: 'bi-snow', text: '겨울 (12~2월)' },
            { id: 'destination', icon: 'bi-arrow-left', text: '이전으로', isBack: true }
        ]
    },

    season_spring: {
        message: `<strong>봄 추천 여행지</strong>
            <div class="chat-info-box">
                <h5>벚꽃 명소</h5>
                <ul>
                    <li>진해 - 군항제, 여좌천 벚꽃</li>
                    <li>경주 - 보문단지 벚꽃길</li>
                    <li>서울 여의도 - 윤중로 벚꽃축제</li>
                </ul>
            </div>
            <div class="chat-info-box">
                <h5>꽃 축제</h5>
                <ul>
                    <li>태안 - 튤립 축제</li>
                    <li>고창 - 청보리밭 축제</li>
                    <li>제주 - 유채꽃 축제</li>
                </ul>
            </div>`,
        options: [
            { id: 'dest_season', icon: 'bi-arrow-left', text: '다른 계절 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    season_summer: {
        message: `<strong>여름 추천 여행지</strong>
            <div class="chat-info-box">
                <h5>해변 여행</h5>
                <ul>
                    <li>부산 해운대 - 대한민국 대표 해변</li>
                    <li>강릉 경포대 - 동해안 청정 해변</li>
                    <li>제주 협재 - 에메랄드빛 바다</li>
                </ul>
            </div>
            <div class="chat-info-box">
                <h5>물놀이/액티비티</h5>
                <ul>
                    <li>양양 - 서핑</li>
                    <li>단양 - 래프팅</li>
                    <li>제주 - 스쿠버다이빙</li>
                </ul>
            </div>`,
        options: [
            { id: 'dest_season', icon: 'bi-arrow-left', text: '다른 계절 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    season_fall: {
        message: `<strong>가을 추천 여행지</strong>
            <div class="chat-info-box">
                <h5>단풍 명소</h5>
                <ul>
                    <li>설악산 - 대한민국 대표 단풍</li>
                    <li>내장산 - 단풍 터널</li>
                    <li>지리산 - 피아골 단풍</li>
                </ul>
            </div>
            <div class="chat-info-box">
                <h5>가을 축제</h5>
                <ul>
                    <li>안동 - 탈춤 페스티벌</li>
                    <li>이천 - 도자기 축제</li>
                    <li>부산 - 불꽃축제</li>
                </ul>
            </div>`,
        options: [
            { id: 'dest_season', icon: 'bi-arrow-left', text: '다른 계절 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    season_winter: {
        message: `<strong>겨울 추천 여행지</strong>
            <div class="chat-info-box">
                <h5>스키/보드</h5>
                <ul>
                    <li>평창 - 알펜시아, 휘닉스파크</li>
                    <li>강원도 - 하이원, 용평</li>
                </ul>
            </div>
            <div class="chat-info-box">
                <h5>눈꽃 여행</h5>
                <ul>
                    <li>태백산 - 눈꽃축제</li>
                    <li>제주 한라산 - 설경</li>
                    <li>대관령 - 양떼목장 겨울</li>
                </ul>
            </div>`,
        options: [
            { id: 'dest_season', icon: 'bi-arrow-left', text: '다른 계절 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    dest_theme: {
        message: '어떤 테마의 여행을 원하시나요?',
        options: [
            { id: 'theme_healing', icon: 'bi-heart', text: '힐링/휴식' },
            { id: 'theme_activity', icon: 'bi-bicycle', text: '액티비티/체험' },
            { id: 'theme_food', icon: 'bi-egg-fried', text: '맛집 탐방' },
            { id: 'theme_culture', icon: 'bi-bank', text: '문화/역사' },
            { id: 'destination', icon: 'bi-arrow-left', text: '이전으로', isBack: true }
        ]
    },

    theme_healing: {
        message: `<strong>힐링/휴식 추천</strong>
            <div class="chat-info-box">
                <h5>온천/스파</h5>
                <ul>
                    <li>아산 - 온양온천</li>
                    <li>부산 - 해운대 스파</li>
                    <li>제주 - 중문 리조트</li>
                </ul>
            </div>
            <div class="chat-info-box">
                <h5>자연 힐링</h5>
                <ul>
                    <li>담양 - 죽녹원, 메타세쿼이아길</li>
                    <li>순천 - 순천만 습지</li>
                    <li>울릉도 - 청정 자연</li>
                </ul>
            </div>`,
        options: [
            { id: 'dest_theme', icon: 'bi-arrow-left', text: '다른 테마 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    theme_activity: {
        message: `<strong>액티비티/체험 추천</strong>
            <div class="chat-info-box">
                <h5>수상 액티비티</h5>
                <ul>
                    <li>양양 서핑</li>
                    <li>제주 스쿠버다이빙</li>
                    <li>단양 래프팅</li>
                    <li>부산 요트 투어</li>
                </ul>
            </div>
            <div class="chat-info-box">
                <h5>이색 체험</h5>
                <ul>
                    <li>보성 녹차밭 체험</li>
                    <li>전주 한복 체험</li>
                    <li>경주 도자기 만들기</li>
                </ul>
            </div>`,
        options: [
            { id: 'dest_theme', icon: 'bi-arrow-left', text: '다른 테마 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    theme_food: {
        message: `<strong>맛집 탐방 추천</strong>
            <div class="chat-info-box">
                <h5>지역별 대표 맛집</h5>
                <ul>
                    <li>전주 - 한정식, 비빔밥</li>
                    <li>부산 - 돼지국밥, 밀면</li>
                    <li>제주 - 흑돼지, 해산물</li>
                    <li>춘천 - 닭갈비, 막국수</li>
                </ul>
            </div>`,
        options: [
            { id: 'dest_busan', icon: 'bi-building', text: '부산 맛집 상세보기' },
            { id: 'dest_jeju', icon: 'bi-water', text: '제주 맛집 상세보기' },
            { id: 'dest_theme', icon: 'bi-arrow-left', text: '다른 테마 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    theme_culture: {
        message: `<strong>문화/역사 추천</strong>
            <div class="chat-info-box">
                <h5>역사 탐방</h5>
                <ul>
                    <li>경주 - 신라 천년 고도</li>
                    <li>공주/부여 - 백제 유적</li>
                    <li>서울 - 5대 궁궐 투어</li>
                    <li>안동 - 하회마을</li>
                </ul>
            </div>`,
        options: [
            { id: 'dest_gyeongju', icon: 'bi-bank', text: '경주 상세보기' },
            { id: 'dest_theme', icon: 'bi-arrow-left', text: '다른 테마 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    // 여행 일정
    schedule: {
        message: '어떤 일정 정보가 필요하신가요?',
        options: [
            { id: 'schedule_jeju', icon: 'bi-water', text: '제주도 추천 일정' },
            { id: 'schedule_busan', icon: 'bi-building', text: '부산 추천 일정' },
            { id: 'schedule_ai', icon: 'bi-robot', text: 'AI 맞춤 일정 만들기' },
            { id: 'start', icon: 'bi-arrow-left', text: '처음으로', isBack: true }
        ]
    },

    schedule_jeju: {
        message: `<strong>제주도 3박 4일 추천 일정</strong>
            <div class="chat-schedule-card">
                <div class="chat-schedule-day">
                    <span class="chat-day-num">Day 1</span>
                    <span class="chat-day-content">제주공항 → 용두암 → 제주시 동문시장 → 숙소</span>
                </div>
                <div class="chat-schedule-day">
                    <span class="chat-day-num">Day 2</span>
                    <span class="chat-day-content">성산일출봉 → 섭지코지 → 우도 → 월정리해변</span>
                </div>
                <div class="chat-schedule-day">
                    <span class="chat-day-num">Day 3</span>
                    <span class="chat-day-content">한라산 둘레길 → 중문관광단지 → 천지연폭포</span>
                </div>
                <div class="chat-schedule-day">
                    <span class="chat-day-num">Day 4</span>
                    <span class="chat-day-content">협재해수욕장 → 오설록 티뮤지엄 → 제주공항</span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/schedule/search">AI 맞춤 일정 만들기 →</a>`,
        options: [
            { id: 'dest_jeju', icon: 'bi-geo-alt', text: '제주도 여행 정보 보기' },
            { id: 'schedule', icon: 'bi-arrow-left', text: '다른 일정 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    schedule_busan: {
        message: `<strong>부산 2박 3일 추천 일정</strong>
            <div class="chat-schedule-card">
                <div class="chat-schedule-day">
                    <span class="chat-day-num">Day 1</span>
                    <span class="chat-day-content">부산역 → 자갈치시장 → 남포동 BIFF거리 → 광안리 야경</span>
                </div>
                <div class="chat-schedule-day">
                    <span class="chat-day-num">Day 2</span>
                    <span class="chat-day-content">해운대 → 동백섬 → 해동용궁사 → 기장 카페거리</span>
                </div>
                <div class="chat-schedule-day">
                    <span class="chat-day-num">Day 3</span>
                    <span class="chat-day-content">감천문화마을 → 송도 스카이워크 → 부산역</span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/schedule/search">AI 맞춤 일정 만들기 →</a>`,
        options: [
            { id: 'dest_busan', icon: 'bi-geo-alt', text: '부산 여행 정보 보기' },
            { id: 'schedule', icon: 'bi-arrow-left', text: '다른 일정 보기', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    schedule_ai: {
        message: `<strong>AI 맞춤 일정 서비스</strong><br><br>
            모행의 AI가 당신만을 위한 맞춤 여행 일정을 만들어드립니다!<br><br>
            <div class="chat-info-box">
                <h5>이용 방법</h5>
                <ul>
                    <li>여행지, 기간, 인원 선택</li>
                    <li>여행 스타일 선택 (힐링/액티비티/맛집 등)</li>
                    <li>AI가 맞춤 일정 자동 생성</li>
                    <li>일정 수정 및 저장 가능</li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/schedule/search" class="btn btn-primary btn-sm" style="color: white; text-decoration: none;">AI 일정 만들러 가기 →</a>`,
        options: [
            { id: 'schedule', icon: 'bi-arrow-left', text: '이전으로', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    // 예약/결제 안내
    booking: {
        message: '예약/결제 관련하여 무엇이 궁금하신가요?',
        options: [
            { id: 'booking_how', icon: 'bi-cart-check', text: '예약 방법 안내' },
            { id: 'booking_cancel', icon: 'bi-x-circle', text: '취소/환불 안내' },
            { id: 'booking_payment', icon: 'bi-credit-card', text: '결제 수단 안내' },
            { id: 'booking_point', icon: 'bi-coin', text: '포인트 사용 안내' },
            { id: 'start', icon: 'bi-arrow-left', text: '처음으로', isBack: true }
        ]
    },

    booking_how: {
        message: `<strong>예약 방법 안내</strong>
            <div class="chat-info-box">
                <h5>예약 절차</h5>
                <ul>
                    <li><strong>1단계:</strong> 원하는 상품 선택</li>
                    <li><strong>2단계:</strong> 날짜/인원/옵션 선택</li>
                    <li><strong>3단계:</strong> 결제자 정보 입력</li>
                    <li><strong>4단계:</strong> 결제 수단 선택 및 결제</li>
                    <li><strong>5단계:</strong> 결제 완료!</li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/product/tour">상품 보러가기 →</a>`,
        options: [
            { id: 'booking', icon: 'bi-arrow-left', text: '이전으로', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    booking_cancel: {
        message: `<strong>취소/환불 안내</strong>
            <div class="chat-info-box">
                <h5>취소 방법</h5>
                <ul>
                    <li>마이페이지 → 결제 내역 → 결제 취소</li>
                </ul>
            </div>
            <div class="chat-info-box">
                <h5>환불 정책</h5>
                <ul>
                    <li>이용일 7일 전: <strong>100% 환불</strong></li>
                    <li>이용일 3~6일 전: <strong>70% 환불</strong></li>
                    <li>이용일 1~2일 전: <strong>50% 환불</strong></li>
                    <li>이용일 당일: <strong>환불 불가</strong></li>
                </ul>
            </div>
            <p style="color: #ef4444; font-size: 14px;">* 상품에 따라 환불 정책이 다를 수 있습니다.</p>`,
        options: [
            { id: 'booking', icon: 'bi-arrow-left', text: '이전으로', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    booking_payment: {
        message: `<strong>결제 수단 안내</strong>
            <div class="chat-info-box">
                <h5>이용 가능한 결제 수단</h5>
                <ul>
                    <li><strong>신용/체크카드</strong> - 모든 카드 이용 가능</li>
                    <li><strong>카카오페이</strong> - 간편 결제</li>
                    <li><strong>네이버페이</strong> - 간편 결제</li>
                    <li><strong>계좌이체</strong> - 실시간 계좌이체</li>
                </ul>
            </div>`,
        options: [
            { id: 'booking', icon: 'bi-arrow-left', text: '이전으로', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    booking_point: {
        message: `<strong>포인트 사용 안내</strong>
            <div class="chat-info-box">
                <h5>포인트 적립</h5>
                <ul>
                    <li>결제 금액의 1% 자동 적립</li>
                    <li>후기 작성 시 추가 적립</li>
                    <li>이벤트 참여 시 보너스 적립</li>
                </ul>
            </div>
            <div class="chat-info-box">
                <h5>포인트 사용</h5>
                <ul>
                    <li>최소 1,000P 이상 사용 가능</li>
                    <li>결제 시 포인트 차감 적용</li>
                    <li>포인트 유효기간: 적립일로부터 1년</li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/mypage/points">내 포인트 확인하기 →</a>`,
        options: [
            { id: 'booking', icon: 'bi-arrow-left', text: '이전으로', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    // 서비스 이용 안내
    service: {
        message: '서비스 이용에 관해 무엇이 궁금하신가요?',
        options: [
            { id: 'service_member', icon: 'bi-person-plus', text: '회원가입/로그인' },
            { id: 'service_mypage', icon: 'bi-person-circle', text: '마이페이지 이용' },
            { id: 'service_inquiry', icon: 'bi-envelope', text: '1:1 문의하기' },
            { id: 'service_faq', icon: 'bi-question-circle', text: '자주 묻는 질문' },
            { id: 'start', icon: 'bi-arrow-left', text: '처음으로', isBack: true }
        ]
    },

    service_member: {
        message: `<strong>회원가입/로그인 안내</strong>
            <div class="chat-info-box">
                <h5>회원 유형</h5>
                <ul>
                    <li><strong>일반회원:</strong> 여행 상품 구매, 포인트 적립</li>
                    <li><strong>기업회원:</strong> 여행 상품 등록 및 판매</li>
                </ul>
            </div>
            <div class="chat-info-box">
                <h5>간편 로그인</h5>
                <ul>
                    <li>카카오 로그인</li>
                    <li>네이버 로그인</li>
                    <li>구글 로그인</li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/member/join">회원가입 하러가기 →</a>`,
        options: [
            { id: 'service', icon: 'bi-arrow-left', text: '이전으로', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    service_mypage: {
        message: `<strong>마이페이지 이용 안내</strong>
            <div class="chat-info-box">
                <h5>마이페이지 메뉴</h5>
                <ul>
                    <li><strong>내 일정:</strong> 저장한 여행 일정 관리</li>
                    <li><strong>결제 내역:</strong> 결제/환불 내역 확인</li>
                    <li><strong>포인트:</strong> 포인트 적립/사용 내역</li>
                    <li><strong>찜 목록:</strong> 찜한 상품 목록</li>
                    <li><strong>1:1 문의:</strong> 문의 내역 확인</li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/mypage">마이페이지 가기 →</a>`,
        options: [
            { id: 'service', icon: 'bi-arrow-left', text: '이전으로', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    service_inquiry: {
        message: `<strong>1:1 문의 안내</strong><br><br>
            챗봇으로 해결되지 않는 문의사항은<br>
            1:1 문의를 통해 상담받으실 수 있습니다.<br><br>
            <div class="chat-info-box">
                <h5>문의 유형</h5>
                <ul>
                    <li>예약/결제 문의</li>
                    <li>취소/환불 문의</li>
                    <li>상품 관련 문의</li>
                    <li>기타 문의</li>
                </ul>
            </div>
            <p><strong>평균 답변 시간:</strong> 24시간 이내</p>
            <a href="${pageContext.request.contextPath}/support/inquiry" class="btn btn-primary btn-sm" style="color: white; text-decoration: none;">1:1 문의하기 →</a>`,
        options: [
            { id: 'service', icon: 'bi-arrow-left', text: '이전으로', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    },

    service_faq: {
        message: `<strong>자주 묻는 질문</strong><br><br>
            FAQ 페이지에서 자주 묻는 질문과 답변을 확인하세요!<br><br>
            <div class="chat-info-box">
                <h5>인기 FAQ</h5>
                <ul>
                    <li>예약 확인은 어디서 하나요?</li>
                    <li>결제 후 일정 변경이 가능한가요?</li>
                    <li>포인트는 언제 적립되나요?</li>
                    <li>환불은 얼마나 걸리나요?</li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/support/faq" class="btn btn-outline btn-sm">FAQ 전체보기 →</a>`,
        options: [
            { id: 'service', icon: 'bi-arrow-left', text: '이전으로', isBack: true },
            { id: 'start', icon: 'bi-house', text: '처음으로', isBack: true }
        ]
    }
};

// 현재 시간 포맷
function getCurrentTime() {
    const now = new Date();
    return now.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
}

// 봇 메시지 추가
function addBotMessage(message) {
    const messageDiv = document.createElement('div');
    messageDiv.className = 'chatbot-message bot';
    messageDiv.innerHTML = `
        <div class="chatbot-avatar">
            <i class="bi bi-robot"></i>
        </div>
        <div class="chatbot-bubble">
            ${message}
            <span class="time">${getCurrentTime()}</span>
        </div>
    `;
    chatMessages.appendChild(messageDiv);
}

// 사용자 선택 메시지 추가
function addUserMessage(message) {
    const messageDiv = document.createElement('div');
    messageDiv.className = 'chatbot-message user';
    messageDiv.innerHTML = `
        <div class="chatbot-avatar">
            <i class="bi bi-person"></i>
        </div>
        <div class="chatbot-bubble">
            ${message}
            <span class="time">${getCurrentTime()}</span>
        </div>
    `;
    chatMessages.appendChild(messageDiv);
}

// 선택지 버튼 추가
function addOptions(options) {
    const optionsDiv = document.createElement('div');
    optionsDiv.className = 'chat-options';

    options.forEach(option => {
        const btn = document.createElement('button');
        btn.className = 'chat-option-btn' + (option.isBack ? ' back-btn' : '');
        btn.innerHTML = `<i class="bi ${option.icon}"></i> ${option.text}`;
        btn.onclick = () => handleOptionClick(option);
        optionsDiv.appendChild(btn);
    });

    chatMessages.appendChild(optionsDiv);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

// 선택지 클릭 처리
function handleOptionClick(option) {
    // 이전 선택지 버튼들 비활성화
    document.querySelectorAll('.chat-options').forEach(optDiv => {
        optDiv.querySelectorAll('.chat-option-btn').forEach(btn => {
            btn.disabled = true;
            btn.style.opacity = '0.5';
            btn.style.cursor = 'default';
        });
    });

    // 사용자 선택 표시
    addUserMessage(option.text);

    // 잠시 후 봇 응답
    setTimeout(() => {
        const data = chatData[option.id];
        if (data) {
            addBotMessage(data.message);
            if (data.options) {
                addOptions(data.options);
            }
        }
    }, 500);
}

// 초기화
function initChat() {
    chatMessages.innerHTML = '';
    const startData = chatData.start;
    addBotMessage(startData.message);
    addOptions(startData.options);
}

// 페이지 로드 시 초기화
window.onload = initChat;
</script>

<c:set var="pageJs" value="support" />
<%@ include file="../common/footer.jsp" %>
