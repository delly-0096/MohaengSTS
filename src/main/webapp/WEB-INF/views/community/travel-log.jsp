<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="pageTitle" value="여행기록" />
<c:set var="pageCss" value="community" />

<%@ include file="../common/header.jsp"%>


<!-- 현재 로그인/권한 상태를 JS가 읽어가게 심어둠 -->
<span id="authRole" style="display: none;"> <sec:authorize
		access="hasAuthority('ROLE_MEMBER')">ROLE_MEMBER</sec:authorize> <sec:authorize
		access="hasAuthority('ROLE_BUSINESS')">ROLE_BUSINESS</sec:authorize> <sec:authorize
		access="!isAuthenticated()">ANON</sec:authorize>
</span>



<sec:authorize access="isAuthenticated()">
		  <sec:authentication property="name" var="loginName"/>
</sec:authorize>

<div class="travellog-page">
	<div class="container">
		<!-- 헤더 -->
		<div class="travellog-header">
			<h1>
				<i class="bi bi-journal-richtext me-3"></i>여행기록
			</h1>

			<sec:authorize access="hasAuthority('ROLE_MEMBER')">
				<a
					href="${pageContext.request.contextPath}/community/travel-log/write"
					class="btn btn-primary"> <i class="bi bi-plus-lg me-2"></i>기록
					작성
				</a>
			</sec:authorize>


			<sec:authorize access="hasAuthority('ROLE_BUSINESS')">
				<span class="business-notice"> <i
					class="bi bi-info-circle me-1"></i> 기업회원은 기록 작성이 제한됩니다
				</span>
			</sec:authorize>
		</div>

		<!-- 필터 -->
		<div class="travellog-filters">
			<span class="travellog-filter active" data-filter="all">전체</span>
			<!--             <span class="travellog-filter" data-filter="popular-bookmark">인기 북마크</span> -->
			<span class="travellog-filter" data-filter="popular-spot">인기
				관광지</span>
			<sec:authorize access="hasAuthority('ROLE_MEMBER')">
				<span class="travellog-filter" data-filter="my-spot">내 관광지</span>
			</sec:authorize>
		</div>

		<!-- 여행기록 그리드 -->
		<div class="travellog-grid" id="travellogGrid" data-page="1"
			data-size="12" data-filter="all">

			<c:if test="${empty paged.content}">
				<div style="grid-column: 1/-1; text-align: center; padding: 40px 0;">
					등록된 여행기가 없습니다.</div>
			</c:if>

			<c:forEach var="row" items="${paged.content}" varStatus="st">
				<div class="travellog-card" data-index="${st.index}"
					data-id="${row.rcdNo}" data-writer="${row.memId}"
					data-like="${row.likeCount}" onclick="goDetail(${row.rcdNo})">


					<div class="travellog-card-header">
						<!-- 프로필 이미지: 지금 VO에 없으니 임시 고정(나중에 memProfile 등 컬럼/조인으로 교체) -->
						<c:set var="pp" value="${row.profilePath}" />

						<c:choose>
							<c:when test="${not empty pp and pp != 'null'}">
								<!-- pp가 /profile/... 이면 /upload + pp 로만 만든다 (추가 결합 금지) -->
								<img src="<c:url value='/upload${pp}'/>"
									class="travellog-avatar" alt="프로필"
									onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80';" />
							</c:when>
							<c:otherwise>
								<img
									src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80"
									class="travellog-avatar" alt="프로필" />
							</c:otherwise>
						</c:choose>



						<div class="travellog-user-info">
							<!-- 작성자 아이디 -->
							<span class="travellog-username"> <c:choose>
									<c:when test="${not empty row.nickname}">${row.nickname}(${row.memId })</c:when>
									<c:otherwise>${row.memId}</c:otherwise>
								</c:choose>
							</span>


							<!-- 지역코드(locCd)로 표시 (지금 리스트VO에 없으면 이 줄은 지우거나, ListVO에 locCd 추가 필요) -->
							<span class="travellog-location">${row.locName}</span>
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
  type="button"
  data-rcdno="${row.rcdNo}"
  data-title="${fn:escapeXml(row.rcdTitle)}"
  onclick="reportTravellogFromBtn(this)">
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
							onclick="event.stopPropagation(); toggleListLike(this, ${row.rcdNo});">
							<i class="bi ${row.myLiked == 1 ? 'bi-heart-fill' : 'bi-heart'}"></i>
							<span>${row.likeCount}</span>
						</button>


						<!-- 댓글 -->
						<button class="travellog-action-btn"
							onclick="event.stopPropagation(); goComment(${row.rcdNo});">
							<i class="bi bi-chat"></i> <span>${row.commentCount}</span>
						</button>





						<button class="travellog-action-btn btn-share"
							style="margin-left: auto;"
							onclick="handleShare(event, ${row.rcdNo});">
							<i class="bi bi-send"></i>
						</button>



					</div>

					<div class="travellog-card-content">

						<p class="travellog-text">
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
		<i class="bi bi-journal-richtext"
			style="font-size: 64px; color: var(--primary-color); margin-bottom: 24px;"></i>
		<h3>
			더 많은 여행기록을 이용하려면<br>로그인해주세요
		</h3>
		<p>로그인하고 다른 여행자들의 특별한 순간을 만나보세요!</p>
		<div class="d-flex gap-2 justify-content-center">
			<a href="${pageContext.request.contextPath}/member/login"
				class="btn btn-primary">로그인</a> <a
				href="${pageContext.request.contextPath}/member/register"
				class="btn btn-outline">회원가입</a>
		</div>
	</div>
</div>

<!-- 상세 모달 -->
<div class="modal fade travellog-detail-modal" id="travellogModal"
	tabindex="-1" aria-hidden="true">
	<div
		class="modal-dialog modal-dialog-centered modal-xl modal-dialog-scrollable">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
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
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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
	background: linear-gradient(135deg, var(--primary-color),
		var(--secondary-color));
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
	background: linear-gradient(135deg, rgba(74, 144, 217, 0.08),
		rgba(102, 126, 234, 0.08));
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
@media ( max-width : 768px) {
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

var cp = '<c:out value="${pageContext.request.contextPath}" />';

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

function reportTravellogFromBtn(btn){
	  const id = Number(btn.dataset.rcdno || 0);
	  const title = btn.dataset.title || '';
	  reportTravellog(id, title);
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

/* document.addEventListener('DOMContentLoaded', function () {
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
	}); */







// 좋아요 토글
function toggleListLike(btn, rcdNo) {
  if (!btn) return;

  // 혹시 아이콘/카운트 못 찾으면 빠르게 종료 (에러 방지)
  const icon = btn.querySelector('i');
  const count = btn.querySelector('span');
  if (!icon || !count) {
    console.warn('toggleLike: icon/span not found', btn);
    return;
  }

  if (isBusiness) return;
  if (!isMember) { showLoginOverlay(); return; }

  fetch(cp + '/api/community/travel-log/likes/toggle', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ rcdNo: rcdNo })
  })
  .then(res => res.json())
  .then(data => {
    icon.className = data.liked ? 'bi bi-heart-fill' : 'bi bi-heart';
    count.textContent = data.likeCount;
    
 	// ✅ 카드 dataset.like 갱신 (정렬/표시 일관성)
    const card = btn.closest('.travellog-card');
    if (card) card.dataset.like = String(data.likeCount);
  })
  .catch(err => {
    console.error(err);
    alert('좋아요 처리 중 오류 발생');
  });
}



// 북마크 토글
/* function toggleBookmark(btn, id) {
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
} */

// 공유
// 공유 (✅ 절대 URL로 복사)
function shareTravellog(id) {
  const path = cp + '/community/travel-log/detail?rcdNo=' + id;

  // ✅ 도메인(호스트) + contextPath + path
  const url = new URL(path, location.origin).href;

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

/* // 상세 북마크 토글
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
} */

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



//==================== 인피니티 스크롤 + 서버 로딩 ====================
let isLoadingMore = false;
let hasMoreData = true;

// ✅ 서버 API 엔드포인트(네 프로젝트에 맞춰 수정)
const LIST_API = cp + '/api/travel-log/records'; 
// 만약 실제가 /api/community/travel-log/records 이면 여기만 바꿔줘

function getLoginMemId() {
	  return '<c:out value="${loginName}" default="" />';
}

function getGrid() {
  return document.getElementById('travellogGrid');
}

function getActiveFilter() {
  return document.querySelector('.travellog-filter.active')?.dataset?.filter || 'all';
}

// ✅ 최초 1페이지(서버렌더) 카드들도 index 부여
function ensureInitialIndex() {
  const grid = getGrid();
  if (!grid) return;
  grid.querySelectorAll('.travellog-card').forEach((card, idx) => {
    if (!card.dataset.index) card.dataset.index = String(idx);
  });
}

// ✅ 필터 클릭 → 서버 기준으로 "새로 로드"
/* function applyFilter(filter) {
  const grid = getGrid();
  if (!grid) return;

  grid.dataset.filter = filter;
  grid.dataset.page = '1';
  hasMoreData = true;

  // ✅ 서버렌더 카드 전부 비우고(필터에 맞는 1페이지를 다시 받음)
  grid.innerHTML = '';

  // loader/end UI 초기화
  document.getElementById('scrollEnd').style.display = 'none';
  document.getElementById('scrollLoader').style.display = 'block';

  // ✅ 첫 페이지 다시 로딩
  loadMoreTravellogs(true);
} */
function applyFilter(filter) {
	  const grid = getGrid();
	  if (!grid) return;

	  grid.dataset.filter = filter;
	  grid.dataset.page = '1';

	  grid.innerHTML = '';

	  document.getElementById('scrollEnd').style.display = 'none';

	  // ✅ 비로그인: 로더 안 보여주고, 첫 페이지를 서버에서 새로 받는 건 허용할지 정책 선택
	  if (!isLoggedIn) {
	    stopInfiniteScrollForAnon();
	    // 여기서 "필터 적용 자체를 막고 오버레이 띄우기"도 가능
	    // showLoginOverlay();
	    showLoginOverlay();
	  }

	  hasMoreData = true;
	  document.getElementById('scrollLoader').style.display = 'block';
	  loadMoreTravellogs(true);
}

// ✅ IntersectionObserver 초기화
/* function initInfiniteScroll() {
  const loader = document.getElementById('scrollLoader');
  if (!loader) return;

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      if (isLoadingMore || !hasMoreData) return;
      loadMoreTravellogs(false);
    });
  }, {
    root: null,
    rootMargin: '150px',
    threshold: 0
  });

  observer.observe(loader);
} */
let infiniteObserver = null;

function initInfiniteScroll() {
  const loader = document.getElementById('scrollLoader');
  if (!loader) return;

  if (infiniteObserver) infiniteObserver.disconnect();

  infiniteObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      if (isLoadingMore || !hasMoreData) return;
      loadMoreTravellogs(false);
    });
  }, {
    root: null,
    rootMargin: '150px',
    threshold: 0
  });

  infiniteObserver.observe(loader);
}


function stopInfiniteScrollForAnon() {
	  hasMoreData = false;
	  isLoadingMore = false;

	  // 로더 숨김
	  const loader = document.getElementById('scrollLoader');
	  if (loader) loader.style.display = 'none';

	  // observer 끊기
	  if (infiniteObserver) infiniteObserver.disconnect();
}

function showLoginOverlay() {
	  const el = document.getElementById('loginOverlay');
	  if (!el) return;

	  el.classList.add('active');
	  document.body.style.overflow = 'hidden';

	  // ✅ 비로그인일 때만 무한스크롤 끊기
	  if (!isLoggedIn) stopInfiniteScrollForAnon();
}

function hideLoginOverlay() {
	  const el = document.getElementById('loginOverlay');
	  if (!el) return;

	  el.classList.remove('active');
	  document.body.style.overflow = '';
}

	
	



// ✅ 서버에서 목록 가져와서 카드 append
async function loadMoreTravellogs(isFirstPage) {
  const grid = getGrid();
  if (!grid) return;

  // ✅ 비로그인은 무한로딩 자체 금지
   if (!isLoggedIn) {
    showLoginOverlay();          // 오버레이 띄우고
    stopInfiniteScrollForAnon(); // 로더/옵저버 끊고
    return;
  }

  if (isLoadingMore || !hasMoreData) return;
  isLoadingMore = true;

  const loader = document.getElementById('scrollLoader');
  loader.style.display = 'block';

  const size = Number(grid.dataset.size || '12');
  const filter = grid.dataset.filter || 'all';

  // ✅ 다음에 가져올 page 계산
  const nextPage = isFirstPage ? 1 : (currentPage + 1);

  // ✅ 서버 요청 URL 구성
  const url = new URL(LIST_API, window.location.origin);
  url.searchParams.set('page', String(nextPage));
  url.searchParams.set('size', String(size));
  url.searchParams.set('filter', filter); // all / popular-spot / my-spot

  try {
    const res = await fetch(url.toString(), { credentials: 'include' });
    if (!res.ok) throw new Error('list api failed: ' + res.status);

    /** @type {{page:number,size:number,total:number,items:any[]}} */
    const data = await res.json();

    const items = data.content || [];
    const total = Number(data.totalElements || 0);
    const totalPages = Number(data.totalPages || 0);

    // ✅ 더 없음 처리
    if (items.length === 0 || nextPage > totalPages) {
      hasMoreData = false;
      loader.style.display = 'none';
      document.getElementById('scrollEnd').style.display = 'block';
      return;
    }

    // ✅ 카드 생성 + append
    const startIndex = grid.querySelectorAll('.travellog-card').length;
    items.forEach((row, i) => {
      const cardEl = buildCardElement(row, startIndex + i);
      grid.appendChild(cardEl);
    });

    // ✅ page 업데이트
    grid.dataset.page = String(nextPage);

    // ✅ 마지막 페이지면 종료 표시
    if (nextPage >= totalPages) {
      hasMoreData = false;
      loader.style.display = 'none';
      document.getElementById('scrollEnd').style.display = 'block';
    }

    // ✅ 기업회원 버튼 비활성 UI 유지(추가된 카드에도)
    if (isBusiness) {
      grid.querySelectorAll('.travellog-card-actions .travellog-action-btn').forEach(btn => {
        btn.classList.add('is-disabled');
        btn.setAttribute('aria-disabled', 'true');
      });
    }

  } catch (e) {
    console.error(e);
    // 실패해도 재시도 가능하게 로더만 켜둠
  } finally {
    isLoadingMore = false;
    loader.style.display = hasMoreData ? 'block' : 'none';
  }
}


//✅ 카드 DOM 만들기 (JSP EL 충돌 방지 버전: 템플릿리터럴)
function buildCardElement(row, index) {
  const rcdNo = Number(row.rcdNo);
  const likeCount = Number(row.likeCount || 0);
  const commentCount = Number(row.commentCount || 0);
  const myLiked = Number(row.myLiked || 0);
  const memId = row.memId || '';
  const nickname = row.nickname || '';
  const locName = row.locName || '';
  const title = row.rcdTitle || '';
  const regDt = row.regDt ? formatDate(row.regDt) : '';

  // 프로필/커버 fallback
  const profilePath = row.profilePath;
  const profileUrl = (profilePath && profilePath !== 'null')
    ? (cp + '/upload' + profilePath)
    : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80';

  const coverPath = row.coverPath;
  const coverUrl = (coverPath && coverPath !== 'null')
    ? (cp + '/files' + coverPath)
    : 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=600&h=600&fit=crop&q=80';

  const displayName = nickname
    ? (escapeHtml(nickname) + '(' + escapeHtml(memId) + ')')
    : escapeHtml(memId);

  // ====== root card ======
  const card = document.createElement('div');
  card.className = 'travellog-card';
  card.dataset.index = String(index);
  card.dataset.id = String(rcdNo);
  card.dataset.writer = memId;
  card.dataset.like = String(likeCount);

  card.addEventListener('click', function () {
    goDetail(rcdNo);
  });

  // ====== header ======
  const header = document.createElement('div');
  header.className = 'travellog-card-header';

  const avatar = document.createElement('img');
  avatar.className = 'travellog-avatar';
  avatar.alt = '프로필';
  avatar.src = profileUrl;
  avatar.onerror = function () {
    this.onerror = null;
    this.src = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80';
  };

  const userInfo = document.createElement('div');
  userInfo.className = 'travellog-user-info';

  const usernameSpan = document.createElement('span');
  usernameSpan.className = 'travellog-username';
  usernameSpan.innerHTML = displayName;

  const locSpan = document.createElement('span');
  locSpan.className = 'travellog-location';
  locSpan.textContent = locName;

  userInfo.appendChild(usernameSpan);
  userInfo.appendChild(locSpan);

  const moreWrap = document.createElement('div');
  moreWrap.className = 'travellog-more-wrapper';
  const menu = document.createElement('div');
  menu.className = 'travellog-card-menu';
  moreWrap.appendChild(menu);

  header.appendChild(avatar);
  header.appendChild(userInfo);
  header.appendChild(moreWrap);

  // ====== image ======
  const imgWrap = document.createElement('div');
  imgWrap.className = 'travellog-card-image';
  imgWrap.addEventListener('click', function (e) {
    e.stopPropagation();
    goDetail(rcdNo);
  });

  const coverImg = document.createElement('img');
  coverImg.alt = '여행사진';
  coverImg.src = coverUrl;

  imgWrap.appendChild(coverImg);

  // ====== actions ======
  const actions = document.createElement('div');
  actions.className = 'travellog-card-actions';

  // 좋아요 버튼
  const likeBtn = document.createElement('button');
  likeBtn.className = 'travellog-action-btn';
  likeBtn.type = 'button';
  likeBtn.addEventListener('click', function (e) {
    e.stopPropagation();
    toggleListLike(likeBtn, rcdNo);
  });

  const likeIcon = document.createElement('i');
  likeIcon.className = (myLiked === 1) ? 'bi bi-heart-fill' : 'bi bi-heart';

  const likeSpan = document.createElement('span');
  likeSpan.textContent = String(likeCount);

  likeBtn.appendChild(likeIcon);
  likeBtn.appendChild(likeSpan);

  // 댓글 버튼
  const cBtn = document.createElement('button');
  cBtn.className = 'travellog-action-btn';
  cBtn.type = 'button';
  cBtn.addEventListener('click', function (e) {
    e.stopPropagation();
    goComment(rcdNo);
  });

  const cIcon = document.createElement('i');
  cIcon.className = 'bi bi-chat';
  const cSpan = document.createElement('span');
  cSpan.textContent = String(commentCount);

  cBtn.appendChild(cIcon);
  cBtn.appendChild(cSpan);

  // 공유 버튼
  const shareBtn = document.createElement('button');
  shareBtn.className = 'travellog-action-btn btn-share';
  shareBtn.type = 'button';
  shareBtn.style.marginLeft = 'auto';
  shareBtn.addEventListener('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    handleShare(e, rcdNo);
  });

  const sIcon = document.createElement('i');
  sIcon.className = 'bi bi-send';
  shareBtn.appendChild(sIcon);

  actions.appendChild(likeBtn);
  actions.appendChild(cBtn);
  actions.appendChild(shareBtn);

  // ====== content ======
  const content = document.createElement('div');
  content.className = 'travellog-card-content';

  const textP = document.createElement('p');
  textP.className = 'travellog-text';
  textP.textContent = title;

  const dateP = document.createElement('p');
  dateP.className = 'travellog-date';
  dateP.textContent = regDt;

  content.appendChild(textP);
  content.appendChild(dateP);

  // ====== assemble ======
  card.appendChild(header);
  card.appendChild(imgWrap);
  card.appendChild(actions);
  card.appendChild(content);

  // 기업회원 비활성 UI 적용(추가카드도)
  if (isBusiness) {
    card.querySelectorAll('.travellog-card-actions .travellog-action-btn').forEach(function (btn) {
      btn.classList.add('is-disabled');
      btn.setAttribute('aria-disabled', 'true');
    });
  }

  return card;
}




// ✅ 서버에서 내려오는 regDt가 문자열/타임스탬프일 수 있으니 유연하게





function formatDate(value) {
	  // 1) 숫자면 epoch(ms)로 가정
	  if (typeof value === 'number') {
	    const d = new Date(value);
	    return d.getFullYear() + '-' + pad2(d.getMonth() + 1) + '-' + pad2(d.getDate());
	  }
	  // 2) 문자열이면 Date로 파싱 시도
	  const d = new Date(value);
	  if (!isNaN(d.getTime())) {
	    return d.getFullYear() + '-' + pad2(d.getMonth() + 1) + '-' + pad2(d.getDate());
	  }
	  // 3) 못 파싱하면 원문
	  return String(value);
}
function pad2(n){ return (n < 10 ? '0' : '') + n; }





// ✅ 좋아요 토글 후 dataset.like도 갱신(인기정렬/표시 일관성)
const _origToggleListLike = toggleListLike;
toggleListLike = function(btn, rcdNo){
  _origToggleListLike(btn, rcdNo);
  // _origToggleListLike 안의 fetch가 끝난 뒤에 dataset 갱신해야 정확함
  // 그래서 기존 fetch then 안에서 같이 처리하도록 아래처럼 약간만 고쳐주는 게 베스트.
};











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
        + ' onclick="event.stopPropagation(); toggleListLike(this, ' + data.id + ')">'
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
/*       + '<button class="travellog-action-btn' + disabledClass + '"'
        + disabledAttr
        + ' onclick="event.stopPropagation(); toggleBookmark(this, ' + data.id + ')">'
        + '<i class="bi bi-bookmark"></i>'
      + '</button>' */

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
  location.href = cp + '/community/travel-log/detail?rcdNo=' + rcdNo;
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
		
		
		

			
			document.addEventListener('DOMContentLoaded', function () {
				  ensureInitialIndex();

				  // ✅ 탭 클릭 이벤트
				  document.querySelectorAll('.travellog-filter').forEach(tab => {
				    tab.addEventListener('click', function () {
				      document.querySelectorAll('.travellog-filter').forEach(t => t.classList.remove('active'));
				      this.classList.add('active');

				      applyFilter(this.dataset.filter); // 서버 재조회
				    });
				  });

				  // ✅ 최초: 서버렌더 1페이지가 이미 보이므로, grid 상태만 맞춰두고 무한스크롤 시작
				  const grid = getGrid();
				  if (grid) {
				    grid.dataset.filter = 'all';
				    grid.dataset.page = '1';
				  }

				  initInfiniteScroll();
				});

			



			function sortCards(grid, cards, type) {
			  const key = (type === 'like') ? 'like' : 'bookmark';

			  cards.sort((a, b) => {
			    const aVal = parseInt(a.dataset[key] || 0, 10);
			    const bVal = parseInt(b.dataset[key] || 0, 10);
			    return bVal - aVal;
			  }).forEach(card => grid.appendChild(card));
			}
			

			
			const LOGIN_MEM_ID = '<c:out value="${loginName}" default="" />';



</script>



<c:set var="pageJs" value="community" />
<%@ include file="../common/footer.jsp"%>
