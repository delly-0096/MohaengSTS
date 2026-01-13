<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!-- 현재 로그인/권한 상태를 JS가 읽어가게 심어둠 -->
<span id="authRole" style="display:none;">
  <sec:authorize access="hasAuthority('ROLE_MEMBER')">ROLE_MEMBER</sec:authorize>
  <sec:authorize access="hasAuthority('ROLE_BUSINESS')">ROLE_BUSINESS</sec:authorize>
  <sec:authorize access="!isAuthenticated()">ANON</sec:authorize>
</span>

<c:set var="pageTitle" value="여행기록" />
<c:set var="pageCss" value="community" />

<%@ include file="../common/header.jsp" %>

<div class="travellog-page">
    <div class="container">
        <!-- 헤더 -->
        <div class="travellog-header">
            <h1><i class="bi bi-journal-richtext me-3"></i>여행기록</h1>
            
<%--     <c:if test="${not empty sessionScope.loginUser and sessionScope.loginUser.userType eq 'MEMBER'}"> --%>
<%--     <sec:authentication property="principal.member" var="member"/> --%>
    <sec:authorize access="hasAuthority('ROLE_MEMBER')" >
    <a href="${pageContext.request.contextPath}/community/travel-log/write"
       class="btn btn-primary">
        <i class="bi bi-plus-lg me-2"></i>기록 작성
    </a>
    </sec:authorize>
<%-- 	</c:if> --%>

           
<sec:authorize access="hasAuthority('ROLE_BUSINESS')">
    <span class="business-notice">
        <i class="bi bi-info-circle me-1"></i>
        기업회원은 기록 작성이 제한됩니다
    </span>
</sec:authorize>
        </div>

        <!-- 필터 -->
        <div class="travellog-filters">
            <span class="travellog-filter active" data-filter="all">전체</span>
            <span class="travellog-filter" data-filter="popular-bookmark">인기 북마크</span>
            <span class="travellog-filter" data-filter="popular-spot">인기 관광지</span>
            <sec:authorize access="hasAuthority('ROLE_MEMBER')" >
            	<span class="travellog-filter" data-filter="my-spot">내 관광지</span>
            </sec:authorize>
        </div>

        <!-- 여행기록 그리드 -->
        <div class="travellog-grid" id="travellogGrid">

	    <c:if test="${empty paged.content}">
	        <div style="grid-column: 1 / -1; text-align:center; padding:40px 0;">
	            등록된 여행기가 없습니다.
	        </div>
	    </c:if>

			<c:forEach var="row" items="${paged.content}">
				<div class="travellog-card" data-id="${row.rcdNo}"
					data-writer="${row.memId}" data-like="${row.likeCount}"
					data-bookmark="${row.bookmarkCount}"
					onclick="goDetail(${row.rcdNo})">
					
					<div class="travellog-card-header">
						<!-- 프로필 이미지: 지금 VO에 없으니 임시 고정(나중에 memProfile 등 컬럼/조인으로 교체) -->
						<img
							src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80"
							alt="프로필" class="travellog-avatar">

						<div class="travellog-user-info">
							<!-- 작성자 아이디 -->
							<%-- 	                    <span class="travellog-username">${row.memId}</span> --%>
							<span class="travellog-username"> <c:choose>
									<c:when test="${not empty row.nickname}">${row.nickname}(${row.memId })</c:when>
									<c:otherwise>${row.memId}</c:otherwise>
								</c:choose>
							</span>


							<!-- 지역코드(locCd)로 표시 (지금 리스트VO에 없으면 이 줄은 지우거나, ListVO에 locCd 추가 필요) -->
							<span class="travellog-location">${row.locCd}</span>
						</div>

						<div class="travellog-more-wrapper">
							<!-- 	                    <button class="travellog-more-btn" -->
							<!--     onclick="event.stopPropagation(); toggleCardMenu(this)"> -->

							<!-- 	                        <i class="bi bi-three-dots"></i> -->
							<!-- 	                    </button> -->

							<div class="travellog-card-menu">
								<c:if
									test="${not empty sessionScope.loginUser && sessionScope.loginUser.userType ne 'BUSINESS'}">
									<!-- 신고하기: id/title을 실제 데이터로 -->
									<button
										onclick="reportTravellog(${row.rcdNo}, '${row.rcdTitle}')">
										<i class="bi bi-flag"></i> 신고하기
									</button>
								</c:if>
							</div>
						</div>
					</div>

					<!-- 대표 이미지: 지금 attachNo만 있어서 실제 이미지 경로가 없으니 임시 고정 -->
					<div class="travellog-card-image"
						onclick="location.href='${pageContext.request.contextPath}/community/travel-log/detail?rcdNo=${row.rcdNo}'">
						<c:choose>
							<c:when test="${not empty row.coverPath}">
								<img
									src="${pageContext.request.contextPath}/files${row.coverPath}"
									alt="여행사진">
							</c:when>
							<c:otherwise>
								<img
									src="https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=600&h=600&fit=crop&q=80"
									alt="여행사진">
							</c:otherwise>
						</c:choose>

						<!-- 이미지 수: DB에 없으니 일단 숨기거나 임시 -->
						<!-- 	                <span class="travellog-image-count"><i class="bi bi-images"></i> 1</span> -->
					</div>

					<div class="travellog-card-actions">
						<!-- 좋아요 -->
						<button class="travellog-action-btn"
							onclick="event.stopPropagation(); toggleLike(this, ${row.rcdNo})">


							<i class="bi bi-heart"></i> <span>${row.likeCount}</span>
						</button>

						<!-- 댓글 -->
						<%-- 	                <button class="travellog-action-btn" onclick="location.href='${pageContext.request.contextPath}/community/travel-log/detail?rcdNo=${row.rcdNo}'"> --%>
						<button class="travellog-action-btn"
							onclick="event.stopPropagation(); goComment(${row.rcdNo});">
							<i class="bi bi-chat"></i> <span>${row.commentCount}</span>
						</button>

						<!-- 	                    <i class="bi bi-chat"></i> -->
						<%-- 	                    <span>${row.commentCount}</span> --%>
						<!-- 	                </button> -->



						<!-- 북마크 -->
						<button class="travellog-action-btn"
							onclick="event.stopPropagation(); toggleBookmark(this, ${row.rcdNo})">



							<i class="bi bi-bookmark"></i> <span>${row.bookmarkCount}</span>
						</button>

						<!-- <button class="travellog-action-btn" -->
						<!--         style="margin-left:auto;" -->
						<%--         onclick="event.stopPropagation(); if(!guardShare(event)) return; shareTravellog(${row.rcdNo});"> --%>
						<!--   <i class="bi bi-send"></i> -->
						<!-- </button> -->

						<button class="travellog-action-btn btn-share"
							style="margin-left: auto;"
							onclick="handleShare(event, ${row.rcdNo});">
							<i class="bi bi-send"></i>
						</button>



					</div>

					<div class="travellog-card-content">
						<%-- 	                <p class="travellog-likes">좋아요 ${row.likeCount}개</p> --%>

						<p class="travellog-text">
							<%-- 	                    <span class="username">${row.memId}</span> --%>
							<!-- 목록에서는 content가 없으니 title을 보여주거나,
	                         ListVO에 excerpt(요약) 추가해서 치환 -->
							${row.rcdTitle}
						</p>

						<p class="travellog-date">
							<fmt:formatDate value="${row.regDt}" pattern="yyyy-MM-dd" />
						</p>
					</div>

				</div>
			</c:forEach>

		</div>
	        

        <!-- 로딩 인디케이터 -->
        <!-- <div class="infinite-scroll-loader" id="scrollLoader">
            <div class="loader-spinner">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        </div> -->

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

.travellog-action-btn:disabled {
    opacity: 0.4;
    cursor: not-allowed;
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

.action-disabled {
  pointer-events: none;
}

.travellog-action-btn.is-disabled {
  opacity: 0.4;
  cursor: not-allowed;
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

/* //===== 권한(ROLE) 판별: authRole 기준으로 통일 =====
var ROLE = (document.getElementById('authRole')?.textContent || '').trim() || 'ANON';
var isLoggedIn = (ROLE !== 'ANON');
var isMember = (ROLE === 'MEMBER');
var isBusiness = (ROLE === 'BUSINESS');

var contextPath = '${pageContext.request.contextPath}'; */

//var contextPath = '${pageContext.request.contextPath}';
var cp = '${pageContext.request.contextPath}';

//authRole 기준(앞에서 말한대로)
var ROLE = (document.getElementById('authRole')?.textContent || '').trim() || 'ANON';

var isLoggedIn = (ROLE !== 'ANON');
var isMember   = (ROLE === 'ROLE_MEMBER');
var isBusiness = (ROLE === 'ROLE_BUSINESS');


function goComment(rcdNo){
if (isBusiness) return;
if (!isMember) { showLoginOverlay(); return; }
location.href = cp + '/community/travel-log/detail?rcdNo=' + rcdNo + '#commentSection';
}



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
/* document.addEventListener('DOMContentLoaded', function() {
    var modalElement = document.getElementById('travellogModal');
    if (modalElement) {
        travellogModal = new bootstrap.Modal(modalElement);
    }
}); */
// document.addEventListener('DOMContentLoaded', function () {
// 	  // 기업회원이면 액션버튼 비활성 + 클릭 막기
// 	  if (isBusiness) {
// 	    document.querySelectorAll('.travellog-card-actions .travellog-action-btn').forEach(btn => {
// 	      // 공유 버튼(맨 오른쪽)은 제외하고 싶으면 아래 조건 추가 가능
// 	      // if (btn.querySelector('.bi-send')) return;

// 	      if (btn.querySelector('.bi-send')) return;
	      
// 	      btn.disabled = true;
// 	      btn.classList.add('action-disabled');
// 	      btn.setAttribute('aria-disabled', 'true');
// 	    });
// 	  }

// 	  // 오버레이 안쪽 클릭은 닫히지 않게(배경 클릭만 닫히도록)
// 	  const overlayContent = document.querySelector('#loginOverlay .login-overlay-content');
// 	  overlayContent?.addEventListener('click', function(e){ e.stopPropagation(); });
// 	});

document.addEventListener('DOMContentLoaded', function () {
	  if (isBusiness) {
	    // 공유 버튼도 통일감 있게 "비활성 UI" 처리
	    document.querySelectorAll('.travellog-card-actions .btn-share').forEach(btn => {
	      btn.classList.add('is-disabled');        // 비활성처럼 보이게
	      btn.setAttribute('aria-disabled', 'true');
	    });

	    // 나머지 버튼도 동일하게
	    document.querySelectorAll('.travellog-card-actions .travellog-action-btn:not(.btn-share)').forEach(btn => {
	      btn.classList.add('is-disabled');
	      btn.setAttribute('aria-disabled', 'true');
	    });
	  }
	  
	// 오버레이 안쪽 클릭은 닫히지 않게(배경 클릭만 닫히도록)
	  const overlayContent = document.querySelector('#loginOverlay .login-overlay-content');
	  overlayContent?.addEventListener('click', function(e){ e.stopPropagation(); });
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
function toggleLike(btn, rcdNo) {
  if (isBusiness) return;
  if (!isMember) {
    showLoginOverlay();
    return;
  }

  fetch(cp + '/api/community/travel-log/likes/toggle', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ rcdNo: rcdNo })
  })
  .then(res => res.json())
  .then(data => {
    const icon = btn.querySelector('i');
    const count = btn.querySelector('span');

    if (data.liked) {
      icon.className = 'bi bi-heart-fill';
    } else {
      icon.className = 'bi bi-heart';
    }

    count.textContent = data.likeCount;
  })
  .catch(err => {
    console.error(err);
    alert('좋아요 처리 중 오류 발생');
  });
}


// 북마크 토글
function toggleBookmark(btn, id) {
	if (isBusiness) return;
    if (!isMember) {
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
  const url = cp + '/community/travel-log/detail?rcdNo=' + id;

  // HTTPS/localhost면 clipboard API 동작
  if (navigator.clipboard && window.isSecureContext) {
    navigator.clipboard.writeText(url).then(() => {
      if (typeof showToast === 'function') showToast('링크가 복사되었습니다.', 'success');
      else alert('링크가 복사되었습니다.');
    }).catch(() => {
      prompt('복사해서 사용하세요:', url);
    });
    return;
  }

  // http 환경(또는 권한 문제) fallback
  prompt('복사해서 사용하세요:', url);
}



/* // 모달 열기
function openTravellogModal(id) {
    if (!travellogModal) {
        travellogModal = new bootstrap.Modal(
            document.getElementById('travellogModal')
        );
    }

    document.getElementById('travellogModalBody').innerHTML =
        '<div style="padding:40px;text-align:center;">불러오는 중...</div>';

    fetch(contextPath + '/community/travel-log/detail-frag?rcdNo=' + id)
        .then(res => res.text())
        .then(html => {
            document.getElementById('travellogModalBody').innerHTML = html;
            travellogModal.show();
        });
} */


// 상세 좋아요 토글
function toggleDetailLike(btn) {
    if (!isMember) {
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
    if (!isMember) {
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
/* function getCardsForPage(page) {
    var baseIndex = (page - 2) * 3;
    var cards = [];

    for (var i = 0; i < 3; i++) {
        var dataIndex = (baseIndex + i) % additionalCards.length;
        var card = Object.assign({}, additionalCards[dataIndex]);
        card.id = 6 + baseIndex + i + 1;
        cards.push(card);
    }

    return cards;
} */

// 카드 HTML 생성
// function createTravellogCard(data) {
//     var imageCountHtml = data.imageCount ? '<span class="travellog-image-count"><i class="bi bi-images"></i> ' + data.imageCount + '</span>' : '';

//     return '<div class="travellog-card" data-id="' + data.id + '">' +
//         '<div class="travellog-card-header">' +
//             '<img src="' + data.avatar + '" alt="프로필" class="travellog-avatar">' +
//             '<div class="travellog-user-info">' +
//                 '<span class="travellog-username">' + data.username + '</span>' +
//                 '<span class="travellog-location">' + data.location + '</span>' +
//             '</div>' +
//             '<button class="travellog-more-btn"><i class="bi bi-three-dots"></i></button>' +
//         '</div>' +
//         '<div class="travellog-card-image" onclick="openTravellogModal(' + data.id + ')">' +
//             '<img src="' + data.image + '" alt="여행사진">' +
//             imageCountHtml +
//         '</div>' +
//         '<div class="travellog-card-actions">' +
//             '<button class="travellog-action-btn" onclick="toggleLike(this, ' + data.id + ')">' +
//                 '<i class="bi bi-heart"></i>' +
//                 '<span>' + data.likes + '</span>' +
//             '</button>' +
//             '<button class="travellog-action-btn" onclick="openTravellogModal(' + data.id + ')">' +
//                 '<i class="bi bi-chat"></i>' +
//                 '<span>' + data.comments + '</span>' +
//             '</button>' +
//             /* '<button class="travellog-action-btn" onclick="shareTravellog(' + data.id + ')">' +
//                 '<i class="bi bi-send"></i>' +
//             '</button>' + */
//             '<button class="travellog-action-btn" onclick="toggleBookmark(this, ' + data.id + ')">' +
//                 '<i class="bi bi-bookmark"></i>' +
//             '</button>' +
//             '<button class="travellog-action-btn" onclick="shareTravellog(' + data.id + ')" style="margin-left: auto;">' +
//             '<i class="bi bi-send"></i>' +
//         '</button>' +
//         '</div>' +
//         '<div class="travellog-card-content">' +
// //             '<p class="travellog-likes">좋아요 ' + data.likes + '개</p>' +
//             '<p class="travellog-text">' +
//                 '<span class="username">' + data.username + '</span>' +
//                 data.text +
//             '</p>' +
//             '<p class="travellog-date">' + data.date + '</p>' +
//         '</div>' +
//     '</div>';
// }

//카드 HTML 생성 (인피니티로 추가되는 카드에도 동일 정책 적용)
function createTravellogCard(data) {
  var imageCountHtml = data.imageCount
    ? '<span class="travellog-image-count"><i class="bi bi-images"></i> ' + data.imageCount + '</span>'
    : '';

  // 기업회원: 액션버튼 비활성
  var disabledAttr = isBusiness ? ' disabled aria-disabled="true" ' : '';
  var disabledClass = isBusiness ? ' action-disabled' : '';

  return ''
  + '<div class="travellog-card" data-id="' + data.id + '" onclick="goDetail(' + data.id + ')">' 
    + '<div class="travellog-card-header">'
      + '<img src="' + data.avatar + '" alt="프로필" class="travellog-avatar">'
      + '<div class="travellog-user-info">'
        + '<span class="travellog-username">' + data.username + '</span>'
        + '<span class="travellog-location">' + data.location + '</span>'
      + '</div>'
      + '<button class="travellog-more-btn" onclick="event.stopPropagation();"><i class="bi bi-three-dots"></i></button>'
    + '</div>'

    + '<div class="travellog-card-image" onclick="event.stopPropagation(); goDetail(' + data.id + ')">'
      + '<img src="' + data.image + '" alt="여행사진">'
      + imageCountHtml
    + '</div>'

    + '<div class="travellog-card-actions">'

      // 좋아요
      + '<button class="travellog-action-btn' + disabledClass + '"'
        + disabledAttr
        + ' onclick="event.stopPropagation(); toggleLike(this, ' + data.id + ')">'
        + '<i class="bi bi-heart"></i>'
        + '<span>' + data.likes + '</span>'
      + '</button>'

      // 댓글(비회원이면 오버레이, 일반회원이면 상세#commentSection)
      + '<button class="travellog-action-btn' + disabledClass + '"'
        + disabledAttr
        + ' onclick="event.stopPropagation(); goComment(' + data.id + ')">'
        + '<i class="bi bi-chat"></i>'
        + '<span>' + data.comments + '</span>'
      + '</button>'

      // 북마크
      + '<button class="travellog-action-btn' + disabledClass + '"'
        + disabledAttr
        + ' onclick="event.stopPropagation(); toggleBookmark(this, ' + data.id + ')">'
        + '<i class="bi bi-bookmark"></i>'
      + '</button>'

      // 공유(기업회원도 가능하게 둘 거면 disabled 처리 제외 가능)
      + '<button class="travellog-action-btn" style="margin-left:auto;" onclick="event.stopPropagation(); shareTravellog(' + data.id + ')">'
        + '<i class="bi bi-send"></i>'
      + '</button>'

    + '</div>'

    + '<div class="travellog-card-content">'
      + '<p class="travellog-text">'
        + '<span class="username">' + data.username + '</span> '
        + data.text
      + '</p>'
      + '<p class="travellog-date">' + data.date + '</p>'
    + '</div>'

  + '</div>';
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
// var originalOpenTravellogModal = openTravellogModal;
openTravellogModal = function(id) {
    currentTravellogId = id;
//     var data = travellogData[id];
    if (data) {
        currentTravellogTitle = data.text ? data.text.substring(0, 50) + '...' : '';
    }
    originalOpenTravellogModal(id);
};

function goDetail(rcdNo) {
  location.href = '${pageContext.request.contextPath}/community/travel-log/detail?rcdNo=' + rcdNo;
}


function showLoginOverlay() {
	  const el = document.getElementById('loginOverlay');
	  if (!el) return;
	  el.classList.add('active');
	  document.body.style.overflow = 'hidden';
	}

	function hideLoginOverlay() {
	  const el = document.getElementById('loginOverlay');
	  if (!el) return;
	  el.classList.remove('active');
	  document.body.style.overflow = '';
	}

	// 배경 클릭하면 닫히게(원하면 유지)
	document.addEventListener('click', function(e){
	  const overlay = document.getElementById('loginOverlay');
	  if (!overlay) return;
	  if (overlay.classList.contains('active') && e.target === overlay) {
	    hideLoginOverlay();
	  }
	});

	// ESC로 닫기(원하면 유지)
	document.addEventListener('keydown', function(e){
	  if (e.key === 'Escape') hideLoginOverlay();
	});

/* 	function goComment(rcdNo) {
		  // 기업회원: 아예 동작 안 함(이미 disabled 걸지만 안전하게)
		  if (isBusiness) return;

		  // 비회원: 오버레이
		  if (!isMember) {
		    showLoginOverlay();
		    return;
		  }

		  // 일반회원: 상세로 이동 + 댓글 위치로(원하면 #commentSection)
		  location.href = contextPath + '/community/travel-log/detail?rcdNo=' + rcdNo + '#commentSection';
		} */

		function guardShare(e){
			  if (e) e.preventDefault();

			  // 기업회원: 공유 불가
			  if (isBusiness) {
			    // 조용히 막고 싶으면 return false만
			    if (typeof showToast === 'function') showToast('기업회원은 공유할 수 없습니다.', 'info');
			    return false;
			  }

			  // 비회원/일반회원: 공유 가능
			  return true;
			}

		function handleShare(e, rcdNo){
			  // 카드 클릭(goDetail)로 이벤트 전파되는 거 확실히 차단
			  e.preventDefault();
			  e.stopPropagation();
			  if (e.stopImmediatePropagation) e.stopImmediatePropagation();

			  // 기업회원이면 안내만
			  if (isBusiness) {
			    if (typeof showToast === 'function') showToast('기업회원은 공유할 수 없습니다.', 'info');
			    else alert('기업회원은 공유할 수 없습니다.');
			    return;
			  }

			  // 비회원/일반회원: 링크 복사 실행
			  shareTravellog(rcdNo);
			}

		console.log('showToast =', typeof window.showToast, window.showToast);
		
		<sec:authorize access="isAuthenticated()">
		  <sec:authentication property="name" var="loginName"/>
		</sec:authorize>
		
		document.addEventListener('DOMContentLoaded', function () {

			  // 로그인 아이디(ROLE_MEMBER일 때만 의미 있음)
			   const LOGIN_MEM_ID = '${loginName != null ? loginName : ""}';

			  // ✅ 탭 클릭 이벤트 (여기서 한 번만!)
			  document.querySelectorAll('.travellog-filter').forEach(tab => {
			    tab.addEventListener('click', function () {
			      document.querySelectorAll('.travellog-filter').forEach(t => t.classList.remove('active'));
			      this.classList.add('active');

			      const filter = this.dataset.filter;
			      applyFilter(filter, LOGIN_MEM_ID);
			    });
			  });

			  // 페이지 첫 진입 시 기본 all 적용(선택사항)
			  applyFilter('all', LOGIN_MEM_ID);
			});

			function applyFilter(filter, LOGIN_MEM_ID) {
			  const grid = document.getElementById('travellogGrid');
			  if (!grid) return;

			  const cards = Array.from(grid.querySelectorAll('.travellog-card'));

			  // 전부 보이게 초기화
			  cards.forEach(c => c.style.display = 'block');

			  if (filter === 'my-spot') {
			    cards.forEach(card => {
			      if ((card.dataset.writer || '').trim() !== LOGIN_MEM_ID) {
			        card.style.display = 'none';
			      }
			    });
			    return;
			  }

			  if (filter === 'popular-bookmark') {
			    sortCards(grid, cards, 'bookmark');
			    return;
			  }

			  if (filter === 'popular-spot') {
			    sortCards(grid, cards, 'like');
			    return;
			  }

			  // all → 그대로
			}

			function sortCards(grid, cards, type) {
			  const key = (type === 'like') ? 'like' : 'bookmark';

			  cards.sort((a, b) => {
			    const aVal = parseInt(a.dataset[key] || 0, 10);
			    const bVal = parseInt(b.dataset[key] || 0, 10);
			    return bVal - aVal;
			  }).forEach(card => grid.appendChild(card));
			}
			
			console.log('LOGIN_MEM_ID', LOGIN_MEM_ID);
			console.log('first writer', document.querySelector('.travellog-card')?.dataset.writer);



</script>

<c:set var="pageJs" value="community" />
<%@ include file="../common/footer.jsp" %>
