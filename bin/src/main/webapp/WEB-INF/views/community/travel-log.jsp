<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="여행기록" />
<c:set var="pageCss" value="community" />

<%@ include file="../common/header.jsp" %>

<div class="travellog-page">
    <div class="container">
        <!-- 헤더 -->
        <div class="travellog-header">
            <h1><i class="bi bi-journal-richtext me-3"></i>여행기록</h1>
            <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.userType ne 'BUSINESS'}">
                <a href="${pageContext.request.contextPath}/community/travel-log/write" class="btn btn-primary">
                    <i class="bi bi-plus-lg me-2"></i>기록 작성
                </a>
            </c:if>
            <c:if test="${sessionScope.loginUser.userType eq 'BUSINESS'}">
                <span class="business-notice">
                    <i class="bi bi-info-circle me-1"></i>기업회원은 기록 작성이 제한됩니다
                </span>
            </c:if>
        </div>

        <!-- 필터 -->
        <div class="travellog-filters">
            <span class="travellog-filter active" data-filter="all">전체</span>
            <span class="travellog-filter" data-filter="popular-bookmark">인기 북마크</span>
            <span class="travellog-filter" data-filter="popular-spot">인기 관광지</span>
        </div>

        <!-- 여행기록 그리드 -->
        <div class="travellog-grid" id="travellogGrid">
            <!-- 카드 1 -->
            <div class="travellog-card" data-id="1">
                <div class="travellog-card-header">
                    <img src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80"
                         alt="프로필" class="travellog-avatar">
                    <div class="travellog-user-info">
                        <span class="travellog-username">travel_lover</span>
                        <span class="travellog-location">제주도, 대한민국</span>
                    </div>
                    <div class="travellog-more-wrapper">
                        <button class="travellog-more-btn" onclick="toggleCardMenu(this)"><i class="bi bi-three-dots"></i></button>
                        <div class="travellog-card-menu">
                            <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.userType ne 'BUSINESS'}">
                            <button onclick="reportTravellog(1, '제주도 3박4일, 혼자여도 괜찮아...')"><i class="bi bi-flag"></i> 신고하기</button>
                            </c:if>
                        </div>
                    </div>
                </div>
                <div class="travellog-card-image" onclick="openTravellogModal(1)">
                    <img src="https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=600&h=600&fit=crop&q=80" alt="여행사진">
                    <span class="travellog-image-count"><i class="bi bi-images"></i> 5</span>
                </div>
                <div class="travellog-card-actions">
                    <button class="travellog-action-btn liked" onclick="toggleLike(this, 1)">
                        <i class="bi bi-heart-fill"></i>
                        <span>328</span>
                    </button>
                    <button class="travellog-action-btn" onclick="openTravellogModal(1)">
                        <i class="bi bi-chat"></i>
                        <span>24</span>
                    </button>
                    <button class="travellog-action-btn" onclick="shareTravellog(1)">
                        <i class="bi bi-send"></i>
                    </button>
                    <button class="travellog-action-btn bookmarked" onclick="toggleBookmark(this, 1)" style="margin-left: auto;">
                        <i class="bi bi-bookmark-fill"></i>
                    </button>
                </div>
                <div class="travellog-card-content">
                    <p class="travellog-likes">좋아요 328개</p>
                    <p class="travellog-text">
                        <span class="username">travel_lover</span>
                        제주도 3박4일, 혼자여도 괜찮아. 성산일출봉에서 맞이한 일출이 정말 장관이었어요. 혼자 여행하시는 분들께 강력 추천!
                    </p>
                    <p class="travellog-date">3일 전</p>
                </div>
            </div>

            <!-- 카드 2 -->
            <div class="travellog-card" data-id="2">
                <div class="travellog-card-header">
                    <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&q=80"
                         alt="프로필" class="travellog-avatar">
                    <div class="travellog-user-info">
                        <span class="travellog-username">foodie_kim</span>
                        <span class="travellog-location">부산, 대한민국</span>
                    </div>
                    <div class="travellog-more-wrapper">
                        <button class="travellog-more-btn" onclick="toggleCardMenu(this)"><i class="bi bi-three-dots"></i></button>
                        <div class="travellog-card-menu">
                            <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.userType ne 'BUSINESS'}">
                            <button onclick="reportTravellog(2, '부산 맛집 투어 완전 정복!...')"><i class="bi bi-flag"></i> 신고하기</button>
                            </c:if>
                        </div>
                    </div>
                </div>
                <div class="travellog-card-image" onclick="openTravellogModal(2)">
                    <img src="https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=600&h=600&fit=crop&q=80" alt="여행사진">
                    <span class="travellog-image-count"><i class="bi bi-images"></i> 8</span>
                </div>
                <div class="travellog-card-actions">
                    <button class="travellog-action-btn" onclick="toggleLike(this, 2)">
                        <i class="bi bi-heart"></i>
                        <span>512</span>
                    </button>
                    <button class="travellog-action-btn" onclick="openTravellogModal(2)">
                        <i class="bi bi-chat"></i>
                        <span>45</span>
                    </button>
                    <button class="travellog-action-btn" onclick="shareTravellog(2)">
                        <i class="bi bi-send"></i>
                    </button>
                    <button class="travellog-action-btn" onclick="toggleBookmark(this, 2)" style="margin-left: auto;">
                        <i class="bi bi-bookmark"></i>
                    </button>
                </div>
                <div class="travellog-card-content">
                    <p class="travellog-likes">좋아요 512개</p>
                    <p class="travellog-text">
                        <span class="username">foodie_kim</span>
                        부산 맛집 투어 완전 정복! 자갈치시장에서 먹은 회는 정말 인생 회였어요. 맛집 리스트 저장해두세요!
                    </p>
                    <p class="travellog-date">5일 전</p>
                </div>
            </div>

            <!-- 카드 3 -->
            <div class="travellog-card" data-id="3">
                <div class="travellog-card-header">
                    <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&q=80"
                         alt="프로필" class="travellog-avatar">
                    <div class="travellog-user-info">
                        <span class="travellog-username">adventure_park</span>
                        <span class="travellog-location">강릉, 대한민국</span>
                    </div>
                    <button class="travellog-more-btn"><i class="bi bi-three-dots"></i></button>
                </div>
                <div class="travellog-card-image" onclick="openTravellogModal(3)">
                    <img src="https://images.unsplash.com/photo-1548115184-bc6544d06a58?w=600&h=600&fit=crop&q=80" alt="여행사진">
                    <span class="travellog-image-count"><i class="bi bi-images"></i> 12</span>
                </div>
                <div class="travellog-card-actions">
                    <button class="travellog-action-btn" onclick="toggleLike(this, 3)">
                        <i class="bi bi-heart"></i>
                        <span>287</span>
                    </button>
                    <button class="travellog-action-btn" onclick="openTravellogModal(3)">
                        <i class="bi bi-chat"></i>
                        <span>31</span>
                    </button>
                    <button class="travellog-action-btn" onclick="shareTravellog(3)">
                        <i class="bi bi-send"></i>
                    </button>
                    <button class="travellog-action-btn" onclick="toggleBookmark(this, 3)" style="margin-left: auto;">
                        <i class="bi bi-bookmark"></i>
                    </button>
                </div>
                <div class="travellog-card-content">
                    <p class="travellog-likes">좋아요 287개</p>
                    <p class="travellog-text">
                        <span class="username">adventure_park</span>
                        강릉 & 속초 3일, 완벽 휴양 여행! 정동진의 일출은 정말 환상적이었어요.
                    </p>
                    <p class="travellog-date">1주 전</p>
                </div>
            </div>

            <!-- 카드 4 -->
            <div class="travellog-card" data-id="4">
                <div class="travellog-card-header">
                    <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&q=80"
                         alt="프로필" class="travellog-avatar">
                    <div class="travellog-user-info">
                        <span class="travellog-username">photo_jenny</span>
                        <span class="travellog-location">경주, 대한민국</span>
                    </div>
                    <button class="travellog-more-btn"><i class="bi bi-three-dots"></i></button>
                </div>
                <div class="travellog-card-image" onclick="openTravellogModal(4)">
                    <img src="https://images.unsplash.com/photo-1596422846543-75c6fc197f07?w=600&h=600&fit=crop&q=80" alt="여행사진">
                    <span class="travellog-image-count"><i class="bi bi-images"></i> 15</span>
                </div>
                <div class="travellog-card-actions">
                    <button class="travellog-action-btn" onclick="toggleLike(this, 4)">
                        <i class="bi bi-heart"></i>
                        <span>892</span>
                    </button>
                    <button class="travellog-action-btn" onclick="openTravellogModal(4)">
                        <i class="bi bi-chat"></i>
                        <span>67</span>
                    </button>
                    <button class="travellog-action-btn" onclick="shareTravellog(4)">
                        <i class="bi bi-send"></i>
                    </button>
                    <button class="travellog-action-btn" onclick="toggleBookmark(this, 4)" style="margin-left: auto;">
                        <i class="bi bi-bookmark"></i>
                    </button>
                </div>
                <div class="travellog-card-content">
                    <p class="travellog-likes">좋아요 892개</p>
                    <p class="travellog-text">
                        <span class="username">photo_jenny</span>
                        경주의 봄은 정말 아름다웠어요. 불국사 앞에서 찍은 사진들이 너무 마음에 들어요!
                    </p>
                    <p class="travellog-date">1주 전</p>
                </div>
            </div>

            <!-- 카드 5 -->
            <div class="travellog-card" data-id="5">
                <div class="travellog-card-header">
                    <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&q=80"
                         alt="프로필" class="travellog-avatar">
                    <div class="travellog-user-info">
                        <span class="travellog-username">hiking_master</span>
                        <span class="travellog-location">부산, 대한민국</span>
                    </div>
                    <button class="travellog-more-btn"><i class="bi bi-three-dots"></i></button>
                </div>
                <div class="travellog-card-image" onclick="openTravellogModal(5)">
                    <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&h=600&fit=crop&q=80" alt="여행사진">
                </div>
                <div class="travellog-card-actions">
                    <button class="travellog-action-btn" onclick="toggleLike(this, 5)">
                        <i class="bi bi-heart"></i>
                        <span>156</span>
                    </button>
                    <button class="travellog-action-btn" onclick="openTravellogModal(5)">
                        <i class="bi bi-chat"></i>
                        <span>12</span>
                    </button>
                    <button class="travellog-action-btn" onclick="shareTravellog(5)">
                        <i class="bi bi-send"></i>
                    </button>
                    <button class="travellog-action-btn" onclick="toggleBookmark(this, 5)" style="margin-left: auto;">
                        <i class="bi bi-bookmark"></i>
                    </button>
                </div>
                <div class="travellog-card-content">
                    <p class="travellog-likes">좋아요 156개</p>
                    <p class="travellog-text">
                        <span class="username">hiking_master</span>
                        해운대 일출, 오랜만에 부산 왔는데 역시 좋네요!
                    </p>
                    <p class="travellog-date">2주 전</p>
                </div>
            </div>

            <!-- 카드 6 -->
            <div class="travellog-card" data-id="6">
                <div class="travellog-card-header">
                    <img src="https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=100&h=100&fit=crop&q=80"
                         alt="프로필" class="travellog-avatar">
                    <div class="travellog-user-info">
                        <span class="travellog-username">couple_trip</span>
                        <span class="travellog-location">여수, 대한민국</span>
                    </div>
                    <button class="travellog-more-btn"><i class="bi bi-three-dots"></i></button>
                </div>
                <div class="travellog-card-image" onclick="openTravellogModal(6)">
                    <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&h=600&fit=crop&q=80" alt="여행사진">
                    <span class="travellog-image-count"><i class="bi bi-images"></i> 20</span>
                </div>
                <div class="travellog-card-actions">
                    <button class="travellog-action-btn" onclick="toggleLike(this, 6)">
                        <i class="bi bi-heart"></i>
                        <span>743</span>
                    </button>
                    <button class="travellog-action-btn" onclick="openTravellogModal(6)">
                        <i class="bi bi-chat"></i>
                        <span>54</span>
                    </button>
                    <button class="travellog-action-btn" onclick="shareTravellog(6)">
                        <i class="bi bi-send"></i>
                    </button>
                    <button class="travellog-action-btn" onclick="toggleBookmark(this, 6)" style="margin-left: auto;">
                        <i class="bi bi-bookmark"></i>
                    </button>
                </div>
                <div class="travellog-card-content">
                    <p class="travellog-likes">좋아요 743개</p>
                    <p class="travellog-text">
                        <span class="username">couple_trip</span>
                        여수 신혼여행 기록. 평생 잊지 못할 추억이 되었어요.
                    </p>
                    <p class="travellog-date">2주 전</p>
                </div>
            </div>
        </div>

        <!-- 로딩 인디케이터 -->
        <div class="infinite-scroll-loader" id="scrollLoader">
            <div class="loader-spinner">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        </div>

        <!-- 더 이상 데이터 없음 -->
        <div class="infinite-scroll-end" id="scrollEnd" style="display: none;">
            <p>모든 여행기록을 불러왔습니다</p>
        </div>
    </div>
</div>

<!-- 로그인 유도 오버레이 -->
<div class="login-overlay" id="loginOverlay">
    <div class="login-overlay-content">
        <i class="bi bi-journal-richtext" style="font-size: 64px; color: var(--primary-color); margin-bottom: 24px;"></i>
        <h3>더 많은 여행기록을 보려면<br>로그인해주세요</h3>
        <p>로그인하고 다른 여행자들의 특별한 순간을 만나보세요!</p>
        <div class="d-flex gap-2 justify-content-center">
            <a href="${pageContext.request.contextPath}/member/login" class="btn btn-primary">로그인</a>
            <a href="${pageContext.request.contextPath}/member/register" class="btn btn-outline">회원가입</a>
        </div>
    </div>
</div>

<!-- 상세 모달 -->
<div class="modal fade travellog-detail-modal" id="travellogModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-0" id="travellogModalBody">
                <!-- 동적 콘텐츠 -->
            </div>
        </div>
    </div>
</div>

<style>
/* 기업회원 안내 메시지 */
.business-notice {
    color: #666;
    font-size: 14px;
    padding: 10px 16px;
    background: #f8fafc;
    border-radius: 8px;
    border: 1px solid #e2e8f0;
}

.business-notice i {
    color: var(--primary-color);
}

/* 더보기 버튼 드롭다운 */
.travellog-more-wrapper {
    position: relative;
}

.travellog-card-menu {
    position: absolute;
    top: 100%;
    right: 0;
    background: white;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    min-width: 120px;
    z-index: 100;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: all 0.2s ease;
}

.travellog-card-menu.active {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.travellog-card-menu button {
    display: flex;
    align-items: center;
    gap: 8px;
    width: 100%;
    padding: 12px 16px;
    font-size: 14px;
    color: #ef4444;
    background: transparent;
    border: none;
    cursor: pointer;
    transition: background 0.2s ease;
}

.travellog-card-menu button:hover {
    background: #fef2f2;
}

/* 여행기록 상세 모달 */
.travellog-detail-modal .modal-content {
    border: none;
    border-radius: 16px;
    overflow: hidden;
}

.travellog-detail-modal .modal-header {
    position: absolute;
    top: 0;
    right: 0;
    z-index: 10;
    border: none;
    background: transparent;
}

.travellog-detail-modal .modal-header .btn-close {
    background-color: rgba(255, 255, 255, 0.9);
    border-radius: 50%;
    padding: 12px;
    opacity: 1;
}

.travellog-detail {
    max-height: 85vh;
    overflow-y: auto;
}

/* 커버 이미지 */
.detail-cover {
    position: relative;
    height: 300px;
    overflow: hidden;
}

.detail-cover img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.detail-cover-overlay {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 100px;
    background: linear-gradient(transparent, rgba(0, 0, 0, 0.3));
}

/* 본문 컨테이너 */
.detail-container {
    padding: 24px 32px 32px;
}

/* 작성자 카드 */
.detail-author-card {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
}

.detail-author-avatar {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    object-fit: cover;
}

.detail-author-info {
    flex: 1;
}

.detail-author-name {
    display: block;
    font-weight: 600;
    font-size: 15px;
    color: #1a1a2e;
}

.detail-author-meta {
    font-size: 13px;
    color: #64748b;
}

.detail-follow-btn {
    padding: 8px 16px;
    background: var(--primary-color);
    color: white;
    border: none;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
}

.detail-follow-btn:hover {
    background: #3a7bc8;
}

.detail-follow-btn:disabled {
    background: #cbd5e1;
    cursor: not-allowed;
}

/* 제목 */
.detail-title {
    font-size: 28px;
    font-weight: 700;
    color: #1a1a2e;
    margin-bottom: 12px;
    line-height: 1.3;
}

/* 여행 정보 */
.detail-trip-info {
    display: flex;
    gap: 20px;
    margin-bottom: 20px;
}

.detail-trip-info span {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 14px;
    color: #64748b;
}

.detail-trip-info i {
    color: var(--primary-color);
}

/* 인트로 */
.detail-intro {
    font-size: 16px;
    line-height: 1.7;
    color: #334155;
    margin-bottom: 24px;
}

/* 구분선 */
.detail-divider {
    border: none;
    height: 1px;
    background: #e2e8f0;
    margin: 24px 0;
}

/* 일차 섹션 */
.detail-day-section {
    margin-bottom: 32px;
}

.detail-day-header {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
}

.detail-day-badge {
    background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
    color: white;
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 700;
}

.detail-day-date {
    font-size: 15px;
    color: #64748b;
}

/* 장소 카드 */
.detail-place-card {
    background: #f8fafc;
    border-radius: 16px;
    overflow: hidden;
    margin-bottom: 20px;
}

.detail-place-image {
    height: 200px;
    overflow: hidden;
}

.detail-place-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s;
}

.detail-place-card:hover .detail-place-image img {
    transform: scale(1.05);
}

.detail-place-info {
    padding: 20px;
}

.detail-place-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
}

.detail-place-header h4 {
    font-size: 18px;
    font-weight: 600;
    color: #1a1a2e;
    margin: 0;
    display: flex;
    align-items: center;
    gap: 6px;
}

.detail-place-header h4 i {
    color: var(--primary-color);
}

.detail-place-rating {
    color: #fbbf24;
    font-size: 14px;
}

.detail-place-rating i {
    margin-left: 2px;
}

.detail-place-address {
    font-size: 13px;
    color: #64748b;
    margin-bottom: 4px;
}

.detail-place-time {
    font-size: 13px;
    color: #64748b;
    display: flex;
    align-items: center;
    gap: 4px;
    margin-bottom: 12px;
}

.detail-place-time i {
    color: var(--primary-color);
}

.detail-place-review {
    font-size: 15px;
    line-height: 1.7;
    color: #334155;
    margin: 0;
}

/* 아웃트로 */
.detail-outro {
    background: linear-gradient(135deg, rgba(74, 144, 217, 0.08), rgba(102, 126, 234, 0.08));
    border-radius: 12px;
    padding: 20px;
    margin: 24px 0;
}

.detail-outro p {
    font-size: 15px;
    line-height: 1.7;
    color: #334155;
    margin: 0;
    font-style: italic;
}

/* 태그 */
.detail-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-bottom: 24px;
}

.detail-tag {
    background: #e2e8f0;
    color: #475569;
    padding: 6px 12px;
    border-radius: 16px;
    font-size: 13px;
}

/* 액션 바 */
.detail-actions {
    display: flex;
    gap: 8px;
    padding: 16px 0;
    border-top: 1px solid #e2e8f0;
    border-bottom: 1px solid #e2e8f0;
    margin-bottom: 24px;
}

.detail-action-btn {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 10px 16px;
    background: #f1f5f9;
    border: none;
    border-radius: 20px;
    font-size: 14px;
    color: #475569;
    cursor: pointer;
    transition: all 0.2s;
}

.detail-action-btn:hover {
    background: #e2e8f0;
}

.detail-action-btn.active {
    background: var(--primary-color);
    color: white;
}

.detail-action-btn.active i {
    color: white;
}

.detail-action-btn.report {
    color: #ef4444;
}

.detail-action-btn.report:hover {
    background: #fef2f2;
    color: #dc2626;
}

/* 댓글 섹션 */
.detail-comments-section {
    margin-top: 24px;
}

.detail-comments-title {
    font-size: 18px;
    font-weight: 600;
    color: #1a1a2e;
    margin-bottom: 16px;
}

.detail-comment-input {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
}

.detail-comment-input input {
    flex: 1;
    padding: 12px 16px;
    border: 1px solid #e2e8f0;
    border-radius: 24px;
    font-size: 14px;
}

.detail-comment-input input:focus {
    outline: none;
    border-color: var(--primary-color);
}

.detail-comment-input button {
    padding: 12px 20px;
    background: var(--primary-color);
    color: white;
    border: none;
    border-radius: 24px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
}

.detail-comment-input button:disabled {
    background: #cbd5e1;
    cursor: not-allowed;
}

.detail-comments-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.detail-comment {
    display: flex;
    gap: 12px;
}

.detail-comment-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    flex-shrink: 0;
}

.detail-comment-content {
    flex: 1;
}

.detail-comment-header {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 4px;
}

.detail-comment-author {
    font-weight: 600;
    font-size: 14px;
    color: #1a1a2e;
}

.detail-comment-time {
    font-size: 12px;
    color: #94a3b8;
}

.detail-comment-text {
    font-size: 14px;
    color: #334155;
    margin: 0 0 8px;
    line-height: 1.5;
}

.detail-comment-actions {
    display: flex;
    gap: 12px;
}

.detail-comment-actions button {
    background: none;
    border: none;
    font-size: 12px;
    color: #64748b;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 4px;
}

.detail-comment-actions button:hover {
    color: var(--primary-color);
}

/* 반응형 */
@media (max-width: 768px) {
    .detail-container {
        padding: 20px 16px;
    }

    .detail-title {
        font-size: 22px;
    }

    .detail-cover {
        height: 200px;
    }

    .detail-trip-info {
        flex-direction: column;
        gap: 8px;
    }

    .detail-place-image {
        height: 160px;
    }

    .detail-actions {
        flex-wrap: wrap;
    }
}
</style>

<script>
var viewCount = 0;
var isLoggedIn = ${not empty sessionScope.loginUser};
var userType = '${sessionScope.loginUser.userType}';

// HTML 이스케이프 함수
function escapeHtml(text) {
    if (!text) return '';
    return text
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}
var travellogModal = null;

// 페이지 로드 시 모달 인스턴스 생성
document.addEventListener('DOMContentLoaded', function() {
    var modalElement = document.getElementById('travellogModal');
    if (modalElement) {
        travellogModal = new bootstrap.Modal(modalElement);
    }
});

// 필터 전환
document.querySelectorAll('.travellog-filter').forEach(filter => {
    filter.addEventListener('click', function() {
        document.querySelectorAll('.travellog-filter').forEach(f => f.classList.remove('active'));
        this.classList.add('active');
        // 실제 구현 시 필터링 로직
    });
});

// 좋아요 토글
function toggleLike(btn, id) {
    if (!isLoggedIn) {
        showLoginOverlay();
        return;
    }

    btn.classList.toggle('liked');
    const icon = btn.querySelector('i');
    const count = btn.querySelector('span');
    let num = parseInt(count.textContent);

    if (btn.classList.contains('liked')) {
        icon.className = 'bi bi-heart-fill';
        count.textContent = num + 1;
    } else {
        icon.className = 'bi bi-heart';
        count.textContent = num - 1;
    }
}

// 북마크 토글
function toggleBookmark(btn, id) {
    if (!isLoggedIn) {
        showLoginOverlay();
        return;
    }

    btn.classList.toggle('bookmarked');
    const icon = btn.querySelector('i');

    if (btn.classList.contains('bookmarked')) {
        icon.className = 'bi bi-bookmark-fill';
        showToast('북마크에 저장되었습니다.', 'success');
    } else {
        icon.className = 'bi bi-bookmark';
        showToast('북마크가 해제되었습니다.', 'info');
    }
}

// 공유
function shareTravellog(id) {
    // 실제 구현 시 공유 기능
    showToast('링크가 복사되었습니다.', 'success');
}

// 데모 여행기록 데이터
var travellogData = {
    1: {
        id: 1,
        title: '제주도 3박4일, 혼자여도 괜찮아',
        author: 'travel_lover',
        authorAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80',
        location: '제주도, 대한민국',
        dateRange: '2024.03.15 - 2024.03.18',
        coverImage: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&h=600&fit=crop&q=80',
        likes: 328,
        comments: 24,
        createdAt: '3일 전',
        tags: ['제주도', '혼자여행', '힐링', '일출'],
        intro: '처음으로 혼자 떠난 제주도 여행! 혼자여도 괜찮다, 오히려 좋다라는 걸 깨달았던 특별한 시간이었어요.',
        days: [
            {
                day: 1,
                date: '3월 15일 (금)',
                places: [
                    {
                        name: '성산일출봉',
                        address: '제주 서귀포시 성산읍',
                        image: 'https://images.unsplash.com/photo-1578469645742-46cae010e5d4?w=600&h=400&fit=crop&q=80',
                        rating: 5,
                        time: '06:00 ~ 08:00',
                        review: '새벽 5시에 일어나 일출을 보러 갔어요. 정상까지 올라가는 길이 조금 힘들었지만, 정상에서 바라본 일출은 정말 장관이었습니다. 혼자 온 것이 오히려 좋았어요. 나만의 시간을 가질 수 있었거든요.'
                    },
                    {
                        name: '해녀의집',
                        address: '제주 서귀포시 성산읍',
                        image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&h=400&fit=crop&q=80',
                        rating: 4,
                        time: '12:00 ~ 13:30',
                        review: '성산일출봉 근처에서 점심으로 해녀분들이 직접 잡아온 해산물을 맛봤어요. 전복죽과 물회가 정말 신선하고 맛있었습니다!'
                    }
                ]
            },
            {
                day: 2,
                date: '3월 16일 (토)',
                places: [
                    {
                        name: '협재해수욕장',
                        address: '제주 제주시 한림읍',
                        image: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&h=400&fit=crop&q=80',
                        rating: 5,
                        time: '09:00 ~ 12:00',
                        review: '에메랄드빛 바다가 정말 예뻤어요. 3월이라 물에 들어가진 않았지만, 백사장을 걸으며 힐링했습니다. 혼자 책도 읽고 커피도 마시며 여유로운 시간을 보냈어요.'
                    }
                ]
            }
        ],
        outro: '이번 제주도 여행은 혼자서도 충분히 행복할 수 있다는 걸 알게 해준 소중한 시간이었어요. 다음엔 더 긴 시간을 보내고 싶습니다.',
        commentsList: [
            { author: 'foodie_kim', avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&q=80', text: '와 너무 예뻐요! 저도 가고 싶어지네요', time: '3일 전', likes: 12 },
            { author: 'adventure_park', avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&q=80', text: '성산일출봉 일출 정말 최고죠!', time: '2일 전', likes: 8 },
            { author: 'photo_jenny', avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&q=80', text: '혼자여행 저도 도전해보고 싶어요! 용기가 생기네요 ㅎㅎ', time: '1일 전', likes: 5 }
        ]
    },
    2: {
        id: 2,
        title: '부산 맛집 투어 완전 정복!',
        author: 'foodie_kim',
        authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&q=80',
        location: '부산, 대한민국',
        dateRange: '2024.03.01 - 2024.03.03',
        coverImage: 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=1200&h=600&fit=crop&q=80',
        likes: 512,
        comments: 45,
        createdAt: '5일 전',
        tags: ['부산', '맛집투어', '해운대', '먹방'],
        intro: '부산 하면 역시 먹방이죠! 2박 3일 동안 부산의 유명 맛집들을 돌아다녔어요.',
        days: [
            {
                day: 1,
                date: '3월 1일 (금)',
                places: [
                    {
                        name: '자갈치시장',
                        address: '부산 중구 자갈치해안로',
                        image: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&h=400&fit=crop&q=80',
                        rating: 5,
                        time: '11:00 ~ 14:00',
                        review: '자갈치시장에서 먹은 회는 정말 인생 회였어요. 싱싱한 회와 매운탕, 그리고 시장 특유의 분위기까지 모든 게 완벽했습니다.'
                    }
                ]
            }
        ],
        outro: '다음에 부산 오면 또 먹방 투어 해야겠어요. 부산 음식은 정말 최고!',
        commentsList: [
            { author: 'travel_lover', avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80', text: '맛집 리스트 공유 부탁드려요!', time: '4일 전', likes: 15 }
        ]
    }
};

// 모달 열기
function openTravellogModal(id) {
    viewCount++;

    // 비회원은 일정 개수 이상 보면 로그인 유도
    if (!isLoggedIn && viewCount > 3) {
        showLoginOverlay();
        return;
    }

    if (!travellogModal) {
        var modalElement = document.getElementById('travellogModal');
        if (modalElement) {
            travellogModal = new bootstrap.Modal(modalElement);
        } else {
            console.error('Modal element not found');
            return;
        }
    }

    // 데이터 가져오기 (없으면 기본 데이터 사용)
    var data = travellogData[id] || travellogData[1];
    var disabledAttr = !isLoggedIn ? 'disabled' : '';

    // 별점 HTML 생성 함수
    function generateStars(rating) {
        var stars = '';
        for (var i = 1; i <= 5; i++) {
            stars += '<i class="bi bi-star' + (i <= rating ? '-fill' : '') + '"></i>';
        }
        return stars;
    }

    // 일차별 콘텐츠 생성
    var daysHtml = '';
    data.days.forEach(function(day) {
        daysHtml += '<div class="detail-day-section">' +
            '<div class="detail-day-header">' +
                '<span class="detail-day-badge">DAY ' + day.day + '</span>' +
                '<span class="detail-day-date">' + day.date + '</span>' +
            '</div>';

        day.places.forEach(function(place) {
            daysHtml += '<div class="detail-place-card">' +
                '<div class="detail-place-image">' +
                    '<img src="' + place.image + '" alt="' + place.name + '">' +
                '</div>' +
                '<div class="detail-place-info">' +
                    '<div class="detail-place-header">' +
                        '<h4><i class="bi bi-geo-alt-fill"></i> ' + place.name + '</h4>' +
                        '<div class="detail-place-rating">' + generateStars(place.rating) + '</div>' +
                    '</div>' +
                    '<p class="detail-place-address">' + place.address + '</p>' +
                    '<p class="detail-place-time"><i class="bi bi-clock"></i> ' + place.time + '</p>' +
                    '<p class="detail-place-review">' + place.review + '</p>' +
                '</div>' +
            '</div>';
        });

        daysHtml += '</div>';
    });

    // 태그 HTML
    var tagsHtml = data.tags.map(function(tag) {
        return '<span class="detail-tag">#' + tag + '</span>';
    }).join('');

    // 댓글 HTML
    var commentsHtml = data.commentsList.map(function(comment) {
        var reportBtn = (isLoggedIn && userType !== 'BUSINESS') ?
            '<button onclick="reportTravellogComment(\'' + comment.id + '\', \'' + escapeHtml(comment.text) + '\')"><i class="bi bi-flag"></i> 신고</button>' : '';
        return '<div class="detail-comment">' +
            '<img src="' + comment.avatar + '" alt="' + comment.author + '" class="detail-comment-avatar">' +
            '<div class="detail-comment-content">' +
                '<div class="detail-comment-header">' +
                    '<span class="detail-comment-author">' + comment.author + '</span>' +
                    '<span class="detail-comment-time">' + comment.time + '</span>' +
                '</div>' +
                '<p class="detail-comment-text">' + comment.text + '</p>' +
                '<div class="detail-comment-actions">' +
                    '<button><i class="bi bi-heart"></i> ' + comment.likes + '</button>' +
                    '<button><i class="bi bi-reply"></i> 답글</button>' +
                    reportBtn +
                '</div>' +
            '</div>' +
        '</div>';
    }).join('');

    var modalHtml =
        '<div class="travellog-detail">' +
            // 커버 이미지
            '<div class="detail-cover">' +
                '<img src="' + data.coverImage + '" alt="커버">' +
                '<div class="detail-cover-overlay"></div>' +
            '</div>' +

            // 본문 컨테이너
            '<div class="detail-container">' +
                // 작성자 정보
                '<div class="detail-author-card">' +
                    '<img src="' + data.authorAvatar + '" alt="' + data.author + '" class="detail-author-avatar">' +
                    '<div class="detail-author-info">' +
                        '<span class="detail-author-name">' + data.author + '</span>' +
                        '<span class="detail-author-meta">' + data.createdAt + ' · ' + data.location + '</span>' +
                    '</div>' +
                '</div>' +

                // 제목
                '<h1 class="detail-title">' + data.title + '</h1>' +

                // 여행 정보
                '<div class="detail-trip-info">' +
                    '<span><i class="bi bi-geo-alt"></i> ' + data.location + '</span>' +
                    '<span><i class="bi bi-calendar3"></i> ' + data.dateRange + '</span>' +
                '</div>' +

                // 인트로
                '<p class="detail-intro">' + data.intro + '</p>' +

                // 구분선
                '<hr class="detail-divider">' +

                // 일차별 콘텐츠
                daysHtml +

                // 아웃트로
                '<div class="detail-outro">' +
                    '<p>' + data.outro + '</p>' +
                '</div>' +

                // 태그
                '<div class="detail-tags">' + tagsHtml + '</div>' +

                // 액션 바
                '<div class="detail-actions">' +
                    '<button class="detail-action-btn" onclick="toggleDetailLike(this)">' +
                        '<i class="bi bi-heart"></i>' +
                        '<span>' + data.likes + '</span>' +
                    '</button>' +
                    '<button class="detail-action-btn">' +
                        '<i class="bi bi-chat"></i>' +
                        '<span>' + data.comments + '</span>' +
                    '</button>' +
                    '<button class="detail-action-btn" onclick="shareDetail()">' +
                        '<i class="bi bi-send"></i>' +
                        '<span>공유</span>' +
                    '</button>' +
                    '<button class="detail-action-btn" onclick="toggleDetailBookmark(this)">' +
                        '<i class="bi bi-bookmark"></i>' +
                        '<span>저장</span>' +
                    '</button>' +
                    (isLoggedIn && userType !== 'BUSINESS' ?
                    '<button class="detail-action-btn report" onclick="reportCurrentTravellog()">' +
                        '<i class="bi bi-flag"></i>' +
                        '<span>신고</span>' +
                    '</button>' : '') +
                '</div>' +

                // 댓글 섹션
                '<div class="detail-comments-section">' +
                    '<h3 class="detail-comments-title"><i class="bi bi-chat-dots me-2"></i>댓글 ' + data.comments + '개</h3>' +

                    // 댓글 입력
                    '<div class="detail-comment-input">' +
                        '<input type="text" placeholder="댓글을 입력하세요..." ' + disabledAttr + '>' +
                        '<button ' + disabledAttr + '>게시</button>' +
                    '</div>' +

                    // 댓글 목록
                    '<div class="detail-comments-list">' + commentsHtml + '</div>' +
                '</div>' +
            '</div>' +
        '</div>';

    document.getElementById('travellogModalBody').innerHTML = modalHtml;
    travellogModal.show();
}

// 상세 좋아요 토글
function toggleDetailLike(btn) {
    if (!isLoggedIn) {
        showLoginOverlay();
        travellogModal.hide();
        return;
    }
    btn.classList.toggle('active');
    var icon = btn.querySelector('i');
    var count = btn.querySelector('span');
    var num = parseInt(count.textContent);

    if (btn.classList.contains('active')) {
        icon.className = 'bi bi-heart-fill';
        count.textContent = num + 1;
    } else {
        icon.className = 'bi bi-heart';
        count.textContent = num - 1;
    }
}

// 상세 북마크 토글
function toggleDetailBookmark(btn) {
    if (!isLoggedIn) {
        showLoginOverlay();
        travellogModal.hide();
        return;
    }
    btn.classList.toggle('active');
    var icon = btn.querySelector('i');
    var text = btn.querySelector('span');

    if (btn.classList.contains('active')) {
        icon.className = 'bi bi-bookmark-fill';
        text.textContent = '저장됨';
        showToast('북마크에 저장되었습니다.', 'success');
    } else {
        icon.className = 'bi bi-bookmark';
        text.textContent = '저장';
        showToast('북마크가 해제되었습니다.', 'info');
    }
}

// 공유
function shareDetail() {
    showToast('링크가 복사되었습니다.', 'success');
}

// 로그인 오버레이 표시
function showLoginOverlay() {
    document.getElementById('loginOverlay').classList.add('active');
}

// ==================== 인피니티 스크롤 ====================
var currentPage = 1;
var isLoadingMore = false;
var hasMoreData = true;
var totalPages = 5; // 데모: 총 5페이지

// 추가 데모 데이터
var additionalCards = [
    {
        id: 7,
        username: 'sunset_chaser',
        avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&q=80',
        location: '통영, 대한민국',
        image: 'https://images.unsplash.com/photo-1540979388789-6cee28a1cdc9?w=600&h=600&fit=crop&q=80',
        imageCount: 7,
        likes: 234,
        comments: 18,
        text: '통영의 노을은 정말 예술이에요. 케이블카에서 바라본 풍경이 잊을 수 없어요!',
        date: '3주 전'
    },
    {
        id: 8,
        username: 'nature_lover',
        avatar: 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=100&h=100&fit=crop&q=80',
        location: '설악산, 대한민국',
        image: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600&h=600&fit=crop&q=80',
        imageCount: 15,
        likes: 567,
        comments: 42,
        text: '설악산 단풍 트레킹! 정상에서 바라본 풍경은 말로 표현할 수 없어요.',
        date: '3주 전'
    },
    {
        id: 9,
        username: 'city_explorer',
        avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop&q=80',
        location: '전주, 대한민국',
        image: 'https://images.unsplash.com/photo-1534854638093-bada1813ca19?w=600&h=600&fit=crop&q=80',
        imageCount: 10,
        likes: 389,
        comments: 28,
        text: '전주 한옥마을에서의 하루. 한복 입고 거리 산책하니 시간여행 온 기분!',
        date: '4주 전'
    }
];

// 페이지 로드시 인피니티 스크롤 초기화
document.addEventListener('DOMContentLoaded', function() {
    initInfiniteScroll();
});

// 인피니티 스크롤 초기화
function initInfiniteScroll() {
    var loader = document.getElementById('scrollLoader');
    if (!loader) return;

    // Intersection Observer 생성
    var observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting && !isLoadingMore && hasMoreData) {
                loadMoreTravellogs();
            }
        });
    }, {
        root: null,
        rootMargin: '100px',
        threshold: 0
    });

    observer.observe(loader);
}

// 더 많은 여행기록 불러오기
function loadMoreTravellogs() {
    if (isLoadingMore || !hasMoreData) return;

    // 비로그인 상태에서는 일정 페이지 이상 제한
    if (!isLoggedIn && currentPage >= 2) {
        showLoginOverlay();
        document.getElementById('scrollLoader').style.display = 'none';
        return;
    }

    isLoadingMore = true;
    document.getElementById('scrollLoader').style.display = 'block';

    // 서버 요청 시뮬레이션 (실제 구현시 AJAX 호출)
    setTimeout(function() {
        currentPage++;

        if (currentPage > totalPages) {
            hasMoreData = false;
            document.getElementById('scrollLoader').style.display = 'none';
            document.getElementById('scrollEnd').style.display = 'block';
            isLoadingMore = false;
            return;
        }

        // 새 카드 추가
        var grid = document.getElementById('travellogGrid');
        var cardsToAdd = getCardsForPage(currentPage);

        cardsToAdd.forEach(function(card, index) {
            var cardHtml = createTravellogCard(card);
            var tempDiv = document.createElement('div');
            tempDiv.innerHTML = cardHtml;
            var newCard = tempDiv.firstElementChild;

            // 애니메이션을 위해 opacity 0으로 시작
            newCard.style.opacity = '0';
            newCard.style.transform = 'translateY(20px)';
            grid.appendChild(newCard);

            // 순차적 페이드인 애니메이션
            setTimeout(function() {
                newCard.style.transition = 'all 0.4s ease';
                newCard.style.opacity = '1';
                newCard.style.transform = 'translateY(0)';
            }, index * 100);
        });

        isLoadingMore = false;
    }, 800);
}

// 페이지별 카드 데이터 반환
function getCardsForPage(page) {
    var baseIndex = (page - 2) * 3;
    var cards = [];

    for (var i = 0; i < 3; i++) {
        var dataIndex = (baseIndex + i) % additionalCards.length;
        var card = Object.assign({}, additionalCards[dataIndex]);
        card.id = 6 + baseIndex + i + 1;
        cards.push(card);
    }

    return cards;
}

// 카드 HTML 생성
function createTravellogCard(data) {
    var imageCountHtml = data.imageCount ? '<span class="travellog-image-count"><i class="bi bi-images"></i> ' + data.imageCount + '</span>' : '';

    return '<div class="travellog-card" data-id="' + data.id + '">' +
        '<div class="travellog-card-header">' +
            '<img src="' + data.avatar + '" alt="프로필" class="travellog-avatar">' +
            '<div class="travellog-user-info">' +
                '<span class="travellog-username">' + data.username + '</span>' +
                '<span class="travellog-location">' + data.location + '</span>' +
            '</div>' +
            '<button class="travellog-more-btn"><i class="bi bi-three-dots"></i></button>' +
        '</div>' +
        '<div class="travellog-card-image" onclick="openTravellogModal(' + data.id + ')">' +
            '<img src="' + data.image + '" alt="여행사진">' +
            imageCountHtml +
        '</div>' +
        '<div class="travellog-card-actions">' +
            '<button class="travellog-action-btn" onclick="toggleLike(this, ' + data.id + ')">' +
                '<i class="bi bi-heart"></i>' +
                '<span>' + data.likes + '</span>' +
            '</button>' +
            '<button class="travellog-action-btn" onclick="openTravellogModal(' + data.id + ')">' +
                '<i class="bi bi-chat"></i>' +
                '<span>' + data.comments + '</span>' +
            '</button>' +
            '<button class="travellog-action-btn" onclick="shareTravellog(' + data.id + ')">' +
                '<i class="bi bi-send"></i>' +
            '</button>' +
            '<button class="travellog-action-btn" onclick="toggleBookmark(this, ' + data.id + ')" style="margin-left: auto;">' +
                '<i class="bi bi-bookmark"></i>' +
            '</button>' +
        '</div>' +
        '<div class="travellog-card-content">' +
            '<p class="travellog-likes">좋아요 ' + data.likes + '개</p>' +
            '<p class="travellog-text">' +
                '<span class="username">' + data.username + '</span>' +
                data.text +
            '</p>' +
            '<p class="travellog-date">' + data.date + '</p>' +
        '</div>' +
    '</div>';
}

// ==================== 신고 기능 ====================

var currentTravellogId = null;
var currentTravellogTitle = '';

// 카드 메뉴 토글
function toggleCardMenu(btn) {
    event.stopPropagation();
    const menu = btn.nextElementSibling;
    const allMenus = document.querySelectorAll('.travellog-card-menu');

    // 다른 열린 메뉴 닫기
    allMenus.forEach(m => {
        if (m !== menu) m.classList.remove('active');
    });

    menu.classList.toggle('active');
}

// 문서 클릭 시 메뉴 닫기
document.addEventListener('click', function(e) {
    if (!e.target.closest('.travellog-more-wrapper')) {
        document.querySelectorAll('.travellog-card-menu').forEach(m => {
            m.classList.remove('active');
        });
    }
});

// 여행기록 신고 (카드에서)
function reportTravellog(id, title) {
    openReportModal('post', id, title);
}

// 현재 모달의 여행기록 신고
function reportCurrentTravellog() {
    if (currentTravellogId) {
        openReportModal('post', currentTravellogId, currentTravellogTitle);
    }
}

// 댓글 신고
function reportTravellogComment(commentId, commentText) {
    openReportModal('comment', commentId, commentText);
}

// openTravellogModal 함수 수정 - 현재 ID 저장
var originalOpenTravellogModal = openTravellogModal;
openTravellogModal = function(id) {
    currentTravellogId = id;
    var data = travellogData[id];
    if (data) {
        currentTravellogTitle = data.text ? data.text.substring(0, 50) + '...' : '';
    }
    originalOpenTravellogModal(id);
};
</script>

<c:set var="pageJs" value="community" />
<%@ include file="../common/footer.jsp" %>
