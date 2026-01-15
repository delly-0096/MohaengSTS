<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>

<!-- 현재 로그인/권한 상태를 JS가 읽어가게 심어둠 -->
<span id="authRole" style="display: none;"> <sec:authorize
		access="hasAuthority('ROLE_MEMBER')">ROLE_MEMBER</sec:authorize> <sec:authorize
		access="hasAuthority('ROLE_BUSINESS')">ROLE_BUSINESS</sec:authorize> <sec:authorize
		access="!isAuthenticated()">ANON</sec:authorize>
</span>

<c:set var="pageTitle" value="여행기록 상세" />
<c:set var="pageCss" value="community" />

<%@ include file="../common/header.jsp"%>

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<!-- ==================== DETAIL 전용 스타일(인라인) ==================== -->
<style>
/* 전체 래퍼(리스트 톤 유지) */
.travellog-page {
	background: transparent;
}

.travellog-detail-card {
	background: #fff;
	border: 1px solid #e2e8f0;
	border-radius: 16px;
	overflow: hidden;
	box-shadow: 0 6px 18px rgba(0, 0, 0, .06);
}

/* 커버 */
.travellog-detail-cover {
	position: relative;
	height: 280px;
	overflow: hidden;
	background: #f1f5f9;
}

.travellog-detail-cover img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block;
}

.travellog-detail-cover-overlay {
	position: absolute;
	inset: 0;
	background: linear-gradient(180deg, rgba(0, 0, 0, .10) 0%,
		rgba(0, 0, 0, .35) 100%);
	pointer-events: none;
}

.travellog-detail-back {
	position: absolute;
	top: 16px;
	left: 16px;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	padding: 10px 14px;
	border-radius: 999px;
	background: rgba(255, 255, 255, .92);
	color: #111827;
	text-decoration: none;
	font-weight: 600;
	font-size: 13px;
	border: 1px solid rgba(226, 232, 240, .9);
	backdrop-filter: blur(6px);
}

.travellog-detail-back:hover {
	background: rgba(255, 255, 255, 1);
}

/* 본문 영역 */
.travellog-detail-body {
	padding: 22px 24px 26px;
}

/* 작성자 */
.travellog-detail-author {
	display: flex;
	gap: 12px;
	align-items: center;
	margin-bottom: 14px;
}

.travellog-detail-avatar {
	width: 44px;
	height: 44px;
	border-radius: 50%;
	object-fit: cover;
	flex-shrink: 0;
	border: 1px solid #e2e8f0;
}

.travellog-detail-author-name {
	font-weight: 700;
	font-size: 14px;
	color: #0f172a;
	line-height: 1.2;
}

.travellog-detail-author-meta {
	margin-top: 2px;
	font-size: 12px;
	color: #64748b;
	display: flex;
	align-items: center;
	gap: 8px;
	flex-wrap: wrap;
}

.travellog-detail-author-meta i {
	color: var(--primary-color);
}

.travellog-detail-author-meta .dot {
	opacity: .6;
}

.travellog-detail-actions-right {
	margin-left: auto;
}

/* 제목 */
.travellog-detail-title {
	font-size: 26px;
	font-weight: 800;
	color: #0f172a;
	line-height: 1.25;
	margin: 8px 0 12px;
}

/* 메타 pill */
.travellog-detail-meta {
	display: flex;
	flex-wrap: wrap;
	gap: 10px;
	margin-bottom: 14px;
}

.meta-pill {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	padding: 8px 12px;
	border-radius: 999px;
	border: 1px solid #e2e8f0;
	background: #f8fafc;
	color: #475569;
	font-size: 13px;
	font-weight: 600;
}

.meta-pill i {
	color: var(--primary-color);
}

/* 본문 */
.travellog-detail-content {
	white-space: pre-wrap;
	line-height: 1.8;
	font-size: 15px;
	color: #334155;
	padding: 14px 2px 10px;
}

/* 액션바 (리스트 버튼 느낌) */
.travellog-detail-actionbar {
	display: flex;
	gap: 10px;
	padding: 14px 0 10px;
	border-top: 1px solid #e2e8f0;
	border-bottom: 1px solid #e2e8f0;
	margin-top: 10px;
	margin-bottom: 18px;
	flex-wrap: wrap;
}

.travellog-action-btn {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	padding: 10px 14px;
	border-radius: 999px;
	border: 1px solid #e2e8f0;
	background: #fff;
	color: #334155;
	font-size: 14px;
	font-weight: 700;
	cursor: pointer;
	transition: all .15s ease;
}

.travellog-action-btn:hover {
	background: #f8fafc;
	border-color: #cbd5e1;
}

.travellog-action-btn i {
	font-size: 16px;
}

.travellog-action-btn.active {
	background: var(--primary-color);
	border-color: var(--primary-color);
	color: #fff;
}

.travellog-action-btn.active i {
	color: #fff;
}

/* 댓글 섹션 (너 travel-log.jsp의 스타일과 톤 맞춤) */
.detail-comments-section {
	margin-top: 8px;
}

.detail-comments-title {
	font-size: 18px;
	font-weight: 800;
	color: #0f172a;
	margin: 0 0 14px;
}

.detail-comment-input {
	display: flex;
	gap: 10px;
	margin-bottom: 16px;
}

.detail-comment-input input {
	flex: 1;
	padding: 12px 16px;
	border: 1px solid #e2e8f0;
	border-radius: 999px;
	font-size: 14px;
	outline: none;
}

.detail-comment-input input:focus {
	border-color: var(--primary-color);
	box-shadow: 0 0 0 3px rgba(26, 188, 156, .10);
}

.detail-comment-input button {
	padding: 12px 18px;
	border: none;
	border-radius: 999px;
	background: var(--primary-color);
	color: #fff;
	font-weight: 800;
	font-size: 14px;
	cursor: pointer;
}

.detail-comment-input button:hover {
	filter: brightness(.97);
}

.detail-comments-list {
	display: flex;
	flex-direction: column;
	gap: 14px;
}

.detail-comment {
	display: flex;
	gap: 12px;
	align-items: flex-start;
}

.detail-comment-avatar {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	object-fit: cover;
	border: 1px solid #e2e8f0;
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
	font-weight: 800;
	font-size: 13px;
	color: #0f172a;
}

.detail-comment-time {
	font-size: 12px;
	color: #94a3b8;
}

.detail-comment-text {
	margin: 0 0 8px;
	font-size: 14px;
	line-height: 1.6;
	color: #334155;
	background: #f8fafc;
	border: 1px solid #e2e8f0;
	border-radius: 14px;
	padding: 10px 12px;
}

.detail-comment-actions {
	display: flex;
	gap: 10px;
}

.detail-comment-actions button {
	border: none;
	background: transparent;
	color: #64748b;
	font-size: 12px;
	font-weight: 800;
	display: inline-flex;
	align-items: center;
	gap: 6px;
	cursor: pointer;
}

.detail-comment-actions button:hover {
	color: var(--primary-color);
}

/* ===== (강제) SweetAlert2 공유 토스트: 2번째 사진 스타일 ===== */

/* 위치: 상단 가운데 고정 */
.copy-toast-container.swal2-top {
	left: 50% !important;
	transform: translateX(-50%) !important;
	right: auto !important;
	width: auto !important;
	padding-top: 12px !important;
}

/* 초록 pill */
.copy-toast-popup.swal2-toast {
	background: #22c55e !important;
	color: #fff !important;
	border-radius: 14px !important; /* 🔥 999px → 14px */
	padding: 12px 18px !important;
	box-shadow: 0 10px 22px rgba(0, 0, 0, .16) !important;
}

/* ✅ SweetAlert2 기본 아이콘(큰 원 체크) 강제 제거 */
.copy-toast-popup .swal2-icon {
	display: none !important;
}

/* ✅ html 컨테이너가 숨거나 줄어드는 거 방지 */
.copy-toast-popup .swal2-html-container {
	display: flex !important;
	margin: 0 !important;
	padding: 0 !important;
	align-items: center !important;
}

/* 한 줄 정렬 */
.copy-toast-row {
	display: flex;
	align-items: center;
	gap: 12px;
	font-weight: 900;
	font-size: 15px;
	line-height: 1;
	white-space: nowrap;
}

/* 작은 흰 원 + 체크 */
.copy-toast-badge {
	width: 28px;
	height: 28px;
	border-radius: 8px;
	background: rgba(255, 255, 255, .18);
	display: flex;
	align-items: center;
	justify-content: center;
	border: 2px solid rgba(255, 255, 255, .85);
	flex: 0 0 auto;
}

.copy-toast-badge svg {
	width: 16px;
	height: 16px;
	display: block;
}

.copy-toast-text {
	color: #fff;
}

/* progress bar 숨김(사진과 더 유사) */
.copy-toast-popup .swal2-timer-progress-bar {
	display: none !important;
}

.copy-toast-badge svg {
	width: 16px;
	height: 16px;
	display: block;
}

.copy-toast-text {
	color: #fff;
}

/* 더보기 버튼 */
.travellog-more-wrapper {
	position: relative;
}

.travellog-more-btn {
	width: 36px;
	height: 36px;
	border-radius: 999px;
	border: 1px solid #e2e8f0;
	background: #fff;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
}

.travellog-more-btn:hover {
	background: #f8fafc;
}

.travellog-card-menu {
	position: absolute;
	top: 44px;
	right: 0;
	background: #fff;
	border-radius: 12px;
	box-shadow: 0 6px 18px rgba(0, 0, 0, .12);
	min-width: 140px;
	z-index: 1000;
	opacity: 0;
	visibility: hidden;
	transform: translateY(-8px);
	transition: all .18s ease;
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
	padding: 12px 14px;
	font-size: 14px;
	color: #ef4444;
	background: transparent;
	border: none;
	cursor: pointer;
}

.travellog-card-menu button:hover {
	background: #fef2f2;
}

/* ===== SweetAlert2 신고 모달 커스텀 ===== */
.rpt-swal-popup {
	border-radius: 18px !important;
	padding: 0 !important;
	overflow: hidden;
	box-shadow: 0 18px 40px rgba(0, 0, 0, .16) !important;
	font-family: inherit;
}

.rpt-swal-html {
	margin: 0 !important;
	padding: 0 !important;
}

/* 상단 헤더 */
.rpt-wrap {
	background: #fff;
}

.rpt-header {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 10px;
	padding: 16px 18px;
	background: linear-gradient(180deg, #f6fffc 0%, #ffffff 100%);
	border-bottom: 1px solid #e9ecef;
}

.rpt-title {
	display: flex;
	align-items: center;
	gap: 10px;
	font-weight: 900;
	font-size: 18px;
	color: #111827;
}

.rpt-icon {
	width: 34px;
	height: 34px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	border-radius: 12px;
	background: #e8fbf6;
	color: #1abc9c;
	font-size: 18px;
}

/* 바디 */
.rpt-body {
	padding: 16px 18px 18px;
}

/* 라디오를 "필" 형태로 정돈 */
.rpt-radio-list {
	display: flex;
	gap: 10px;
	flex-wrap: wrap;
	margin-bottom: 14px;
}

.rpt-radio-card {
	position: relative;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	padding: 10px 12px;
	border-radius: 999px;
	border: 1px solid #e9ecef;
	background: #fafafa;
	cursor: pointer;
	user-select: none;
	font-weight: 800;
	font-size: 13px;
	color: #374151;
	transition: all .15s ease;
}

.rpt-radio-card input {
	position: absolute;
	opacity: 0;
	pointer-events: none;
}

.rpt-radio-card .dot {
	width: 10px;
	height: 10px;
	border-radius: 50%;
	border: 2px solid #cbd5e1;
	background: #fff;
}

/* 체크되면 강조 */
.rpt-radio-card:has(input:checked) {
	background: #e8fbf6;
	border-color: #1abc9c;
	color: #0f172a;
}

.rpt-radio-card:has(input:checked) .dot {
	border-color: #1abc9c;
	background: #1abc9c;
}

/* 섹션 타이틀 */
.rpt-section-title {
	font-weight: 900;
	font-size: 13px;
	color: #111827;
	margin: 10px 0 8px;
}

/* 텍스트 영역 */
.rpt-textarea {
	width: 100%;
	min-height: 96px;
	resize: none;
	padding: 12px 14px;
	border-radius: 14px;
	border: 1px solid #e9ecef;
	background: #fff;
	font-size: 14px;
	line-height: 1.5;
	outline: none;
}

.rpt-textarea:focus {
	border-color: #1abc9c;
	box-shadow: 0 0 0 3px rgba(26, 188, 156, .12);
}

/* 안내문 */
.rpt-warning {
	margin-top: 12px;
	display: flex;
	gap: 10px;
	padding: 12px 12px;
	border-radius: 14px;
	background: #fafafa;
	border: 1px solid #e9ecef;
	color: #4b5563;
	font-size: 12.5px;
	line-height: 1.45;
}

.rpt-warning .warn-icon {
	flex-shrink: 0;
	width: 22px;
	height: 22px;
	border-radius: 999px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	background: #fff;
	border: 1px solid #e9ecef;
	color: #6b7280;
	font-weight: 900;
}

/* 버튼 영역 */
.swal2-actions {
	margin: 0 !important;
	padding: 14px 18px 18px !important;
	gap: 10px !important;
	background: #fff;
}

/* 공통 버튼 */
.rpt-btn {
	border-radius: 12px !important;
	padding: 12px 14px !important;
	font-weight: 900 !important;
	font-size: 14px !important;
	box-shadow: none !important;
}

/* 신고하기(강조) */
.rpt-btn-danger {
	background: #ef4444 !important;
	border: 1px solid #ef4444 !important;
}

.rpt-btn-danger:hover {
	filter: brightness(.98);
}

/* 취소(고스트) */
.rpt-btn-ghost {
	background: #fff !important;
	color: #111827 !important;
	border: 1px solid #e9ecef !important;
}

.rpt-btn-ghost:hover {
	background: #fafafa !important;
}

.cmnt-like-btn {
	border: none;
	background: transparent;
	color: #64748b;
	font-size: 12px;
	font-weight: 900;
	display: inline-flex;
	align-items: center;
	gap: 6px;
	cursor: pointer;
}

.cmnt-like-btn.active {
	color: var(--primary-color);
}

/* ===== 대댓글(스레드) UI ===== */
.detail-comment.is-reply{
  margin-left: 56px;        /* 들여쓰기 */
  position: relative;
}

/* (선택) 왼쪽 연결선 ㄴ 느낌 */
.detail-comment.is-reply::before{
  content:"";
  position:absolute;
  left:-18px;
  top: 10px;
  bottom: 10px;
  width: 2px;
  background:#e2e8f0;
  border-radius: 2px;
  opacity: .9;
}
.detail-comment.is-reply::after{
  content:"";
  position:absolute;
  left:-18px;
  top: 28px;
  width: 14px;
  height: 2px;
  background:#e2e8f0;
  border-radius: 2px;
  opacity: .9;
}

/* 대댓글 아바타는 살짝 작게 */
.detail-comment.is-reply .detail-comment-avatar {
	width: 32px;
	height: 32px;
}

/* 대댓글 말풍선/박스는 살짝 더 “붙는 느낌” */
.detail-comment.is-reply .detail-comment-text {
	border-radius: 12px;
	padding: 9px 11px;
}

/* 부모-자식 묶음 간격 */
.detail-comment-group {
	display: flex;
	flex-direction: column;
	gap: 10px; /* 부모와 첫 대댓글 간격 */
	margin-bottom: 14px; /* 다음 부모 그룹과 간격 */
}

.detail-comment-group .reply-list {
	display: flex;
	flex-direction: column;
	gap: 8px; /* 대댓글들끼리 간격 */
}

/* depth가 깊어져도 reply 내부에서 선이 자연스럽게 보이게 */
.detail-comment .reply-list {
	margin-top: 8px;
	display: flex;
	flex-direction: column;
	gap: 8px;
}

/* ===== 무한 대댓글(스레드) ===== */

/* 한 "댓글 노드" = (댓글 본문 + 자식 목록) 을 세로로 묶는 컨테이너 */
.cmnt-node {
	position: relative;
	display: flex;
	flex-direction: column;
	gap: 8px;
}

/* depth 들여쓰기: JS에서 padding-left로 넣을거라 기본은 0 */
.cmnt-node .detail-comment {
	/* 기존 detail-comment 스타일 유지 (flex) */
	
}

/* 자식 목록은 무조건 세로로 */
.cmnt-children {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

/* ㄴ 느낌의 연결선(선택) */
.cmnt-node.is-reply::before {
	content: "";
	position: absolute;
	left: 28px; /* 아바타 옆쪽 기준선 위치 */
	top: 0;
	bottom: 0;
	width: 2px;
	background: #e2e8f0;
	border-radius: 2px;
	opacity: .9;
}

/* ㄴ의 가로 팔(선택) */
.cmnt-node.is-reply::after {
	content: "";
	position: absolute;
	left: 28px;
	top: 28px; /* 아바타 중간쯤 */
	width: 18px;
	height: 2px;
	background: #e2e8f0;
	border-radius: 2px;
	opacity: .9;
}

/* depth가 깊어도 아바타는 살짝만 작게(선택) */
.cmnt-node.is-reply .detail-comment-avatar {
	width: 32px;
	height: 32px;
}

/* 말풍선도 살짝 컴팩트(선택) */
.cmnt-node.is-reply .detail-comment-text {
	border-radius: 12px;
	padding: 9px 11px;
}

@media ( max-width : 768px) {
	.travellog-detail-cover {
		height: 200px;
	}
	.travellog-detail-body {
		padding: 18px 16px 20px;
	}
	.travellog-detail-title {
		font-size: 20px;
	}
	.travellog-detail-actionbar {
		gap: 8px;
	}
	.travellog-action-btn {
		padding: 9px 12px;
		font-size: 13px;
	}
}
</style>

<div class="travellog-page">
	<div class="container" style="padding: 24px 0;">

		<c:if test="${empty detail}">
			<div class="alert alert-warning">게시글이 없거나 접근 권한이 없습니다.</div>
			<a class="btn btn-secondary"
				href="${pageContext.request.contextPath}/community/travel-log">목록으로</a>
		</c:if>

		<c:if test="${not empty detail}">
			<!-- ==================== 상세 카드 ==================== -->
			<div class="travellog-detail-card">
				<!-- 커버(대표 이미지) -->
				<div class="travellog-detail-cover">
					<!-- 실제 대표이미지 경로가 없어서 임시. 나중에 detail.coverUrl 같은 값으로 교체 -->
					<c:choose>
						<c:when test="${not empty detail.coverPath}">
							<img
								src="${pageContext.request.contextPath}/files${detail.coverPath}"
								alt="cover">
						</c:when>
						<c:otherwise>
							<img
								src="https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&h=600&fit=crop&q=80"
								alt="cover">
						</c:otherwise>
					</c:choose>

					<div class="travellog-detail-cover-overlay"></div>

					<a class="travellog-detail-back"
						href="${pageContext.request.contextPath}/community/travel-log">
						<i class="bi bi-arrow-left"></i> 목록
					</a>
				</div>

				<div class="travellog-detail-body">
					<!-- 작성자 영역 -->
					<div class="travellog-detail-author">
						<c:choose>
  <c:when test="${empty detail.profilePath or detail.profilePath == 'null'}">
    <img class="travellog-detail-avatar"
         src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80"
         alt="avatar">
  </c:when>
  <c:otherwise>
    <img class="travellog-detail-avatar"
         src="${pageContext.request.contextPath}/files${detail.profilePath}"
         alt="avatar"
         onerror="this.onerror=null;this.src='https://www.svgrepo.com/show/513078/user-circle.svg';">
  </c:otherwise>
</c:choose>

						<div class="travellog-detail-author-info">
							<div class="travellog-detail-author-name">
								<%--                 <c:out value="${detail.memId}" /> --%>
								<c:out value="${detail.nickname}(${detail.memId})" />
							</div>
							<div class="travellog-detail-author-meta">
								<span><i class="bi bi-eye"></i> <c:out
										value="${detail.viewCnt}" /></span> <span class="dot">·</span> <span><i
									class="bi bi-calendar3"></i> <fmt:formatDate
										value="${detail.regDt}" pattern="yyyy-MM-dd" /></span>
							</div>
						</div>

						<!-- 오른쪽(수정/삭제 같은 버튼 필요하면 여기) -->
						<%-- <div class="travellog-detail-actions-right">
               <button type="button" class="btn btn-outline-secondary btn-sm"
                      onclick="location.href='${pageContext.request.contextPath}/community/travel-log'">수정
              </button>
              <button type="button" class="btn btn-outline-secondary btn-sm"
                      onclick="location.href='${pageContext.request.contextPath}/community/travel-log'">삭제
              </button>
            </div> --%>

						<c:if test="${isWriter}">
							<div class="travellog-detail-actions-right">
								<button type="button" class="btn btn-outline-secondary btn-sm"
									onclick="goEdit(${detail.rcdNo})">수정</button>

								<button type="button" class="btn btn-outline-danger btn-sm"
									onclick="confirmDelete(${detail.rcdNo})">삭제</button>
							</div>
						</c:if>

						<c:if test="${!isWriter}">
							<sec:authorize access="hasAuthority('ROLE_MEMBER')">
								<div class="travellog-more-wrapper" style="margin-left: auto;">
									<button type="button" class="travellog-more-btn"
										onclick="toggleDetailMenu(event, this)">
										<i class="bi bi-three-dots"></i>
									</button>

									<div class="travellog-card-menu">
										<button type="button"
											onclick="reportPost(CURRENT_RCD_NO, '${fn:escapeXml(detail.rcdTitle)}')">
											<i class="bi bi-flag"></i> 신고하기
										</button>
									</div>
								</div>
							</sec:authorize>
						</c:if>

					</div>

					<!-- 제목 -->
					<h1 class="travellog-detail-title">
						<c:out value="${detail.rcdTitle}" />
					</h1>

					<!-- 여행 메타 -->
					<div class="travellog-detail-meta">
						<span class="meta-pill"> <i class="bi bi-geo-alt"></i> 지역:
							<c:out value="${detail.locCd}" />
						</span> <span class="meta-pill"> <i class="bi bi-calendar-range"></i>
							일정: <fmt:formatDate value="${detail.startDt}"
								pattern="yyyy년 M월 d일" /> ~ <fmt:formatDate
								value="${detail.endDt}" pattern="yyyy년 M월 d일" />
						</span>
						<c:if test="${not empty isWriter and isWriter}">
							<span class="meta-pill"> <i class="bi bi-globe2"></i> 공개:
								<c:out value="${detail.openScopeCd}" />
							</span>
						</c:if>
					</div>

					<!-- 본문 -->
					<div class="travellog-detail-content">
						<c:out value="${detail.rcdContent}" />
					</div>

					<!-- 액션 바 (반드시 래퍼로 감싸야 간격/구분선 적용됨) -->
					<div class="travellog-detail-actionbar">
						<button type="button"
							class="travellog-action-btn ${likeActiveClass}"
							onclick="toggleDetailLike(event,this);">

							<i
								class="bi ${detail.myLiked == 1 ? 'bi-heart-fill' : 'bi-heart'}"></i>
							<span id="likeCount">${detail.likeCount}</span>
						</button>

						<button type="button" class="travellog-action-btn"
							onclick="scrollToComments();">
							<i class="bi bi-chat"></i> <span id="commentCountTop">${detail.commentCount}</span>
						</button>

						<%--   <button type="button"
    class="travellog-action-btn"
    onclick="toggleDetailBookmark(this);">
    <i class="bi bi-bookmark"></i>
    <span id="bookmarkCount">${detail.bookmarkCount}</span>
  </button> --%>

						<%-- <sec:authorize access="hasRole('MEMBER')">
  <c:if test="${not empty isWriter and !isWriter}">
    <button type="button" class="travellog-action-btn" onclick="reportPost(CURRENT_RCD_NO, '${fn:escapeXml(detail.rcdTitle)}')">
      <i class="bi bi-flag"></i>
      <span>신고</span>
    </button>
  </c:if>
</sec:authorize> --%>



						<button type="button" class="travellog-action-btn"
							style="margin-left: auto;"
							onclick="if (!guardShareAction(event)) return; shareDetail();">
							<i class="bi bi-send"></i> <span>공유</span>
						</button>
					</div>

					<!-- ==================== 댓글 영역 ==================== -->
					<div class="detail-comments-section" id="commentsSection">
						<h3 class="detail-comments-title">
							댓글 <span id="commentCount"></span>
						</h3>

						<sec:authorize access="hasAuthority('ROLE_MEMBER')">
							<div class="detail-comment-input">
								<input id="commentInput" type="text" placeholder="댓글을 입력하세요..." />
								<button type="button" onclick="submitComment(CURRENT_RCD_NO)">등록</button>
							</div>
						</sec:authorize>

						<sec:authorize access="!hasAuthority('ROLE_MEMBER')">
							<div class="detail-comment-input">
								<input type="text" placeholder="일반회원만 댓글 작성 가능" disabled />
								<button disabled>등록</button>
							</div>
						</sec:authorize>

						<div id="commentList" class="detail-comments-list"></div>
					</div>




					<!-- ==================== 댓글 JS (500 방지: \${} 이스케이프 필수) ==================== -->
					<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
		</c:if>

	</div>
</div>

<script type="text/javascript">
// ===== 전역 상수(한 번만 선언) =====
const CTX = "${pageContext.request.contextPath}";
const CURRENT_RCD_NO = Number("${detail.rcdNo}" || 0);
const AUTH_ROLE = (document.getElementById('authRole')?.innerText || '').trim() || 'ANON';

const ROLE_MEMBER = 'ROLE_MEMBER';
const ROLE_BUSINESS = 'ROLE_BUSINESS';

	// ✅ 기본 프로필(민트 사람 아이콘) - 외부링크 없이 사용 가능
	const DEFAULT_AVATAR = (() => {
	  const svg = `
	  <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 80 80">
	    <circle cx="40" cy="40" r="40" fill="#1abc9c"/>
	    <circle cx="40" cy="30" r="12" fill="none" stroke="#ffffff" stroke-width="5"/>
	    <path d="M20 66c4-12 16-18 20-18s16 6 20 18" fill="none" stroke="#ffffff" stroke-width="5" stroke-linecap="round"/>
	  </svg>`;
	  return "data:image/svg+xml;charset=utf-8," + encodeURIComponent(svg.trim());
	})();

const token = document.querySelector('meta[name="_csrf"]').getAttribute('content');
const header = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

const ctxPath = '${pageContext.request.contextPath}';

function showCopyToast(message){
	const text = message || '링크가 복사되었습니다.';

	Swal.fire({
		toast: true,
		position: 'top',
		showConfirmButton: false,
		timer: 1600,
	    // ✅ progress bar 필요 없으면 꺼버리기(전역 CSS랑 충돌도 줄어듦)
	    timerProgressBar: false,

	    // ✅ 절대 icon/title 쓰지 않기 (기본 success UI 유입 차단)
	    icon: undefined,
	    title: undefined,

	    // ✅ html로만 구성
	    html: `
			<div class="copy-toast-row">
				<span class="copy-toast-badge" aria-hidden="true">
					<svg viewBox="0 0 24 24" fill="none">
						<path d="M20 6L9 17l-5-5" stroke="#ffffff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
	          		</svg>
				</span>
				<span class="copy-toast-text"></span>
			</div>`,

		didOpen: (popup) => {
			// 1) 텍스트 주입
			const txt = popup.querySelector('.copy-toast-text');
			if (txt) txt.textContent = text;

			// 2) ✅ SweetAlert2 기본 아이콘/타이틀이 혹시라도 생기면 제거
			popup.querySelectorAll('.swal2-icon, .swal2-title').forEach(el => el.remove());

			// 3) ✅ 전역 CSS가 html-container를 죽여도 강제로 살리기
			const html = popup.querySelector('.swal2-html-container');
			if (html) {
				html.style.margin = '0';
				html.style.padding = '0';
				html.style.display = 'flex';
				html.style.alignItems = 'center';
				html.style.justifyContent = 'center';
			}

			// 4) ✅ 토스트 pill 스타일을 inline으로 “강제”
			popup.style.background = '#22c55e';
			popup.style.color = '#fff';
			popup.style.borderRadius = '999px';
			popup.style.padding = '12px 18px';
			popup.style.boxShadow = '0 10px 22px rgba(0,0,0,.16)';
			popup.style.display = 'flex';
			popup.style.alignItems = 'center';
			popup.style.justifyContent = 'center';
			popup.style.width = 'fit-content';
			popup.style.maxWidth = 'calc(100vw - 24px)';
			popup.style.overflow = 'hidden';

			// 5) ✅ 컨테이너를 상단 가운데로 “강제”
			const container = popup.closest('.swal2-container');
			if (container) {
				container.style.left = '50%';
				container.style.transform = 'translateX(-50%)';
				container.style.right = 'auto';
				container.style.width = 'auto';
				container.style.paddingTop = '12px';
			}
		}
	});
}

function shareTravellog(id) {
	const url = location.origin + CTX + '/community/travel-log/detail?rcdNo=' + id; 
	// ↑ 너희 실제 상세 URL 규칙에 맞게만 바꿔줘 (예: /community/travel-log/' + id)

	navigator.clipboard.writeText(url).then(() => {
		showCopyToast('링크가 복사되었습니다.');
	}).catch(() => {
		Swal.fire({
			icon: 'info',
			title: '링크 복사',
			text: url
		});
	});
}

function getCsrf(){
	const tokenMeta  = document.querySelector('meta[name="_csrf"]');
	const headerMeta = document.querySelector('meta[name="_csrf_header"]');
	
	const token  = tokenMeta ? tokenMeta.getAttribute('content') : null;
	const header = headerMeta ? headerMeta.getAttribute('content') : null;
	
	return { token, header };
}

function getCookie(name) {
	const match = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
	return match ? decodeURIComponent(match[2]) : null;
}


// 상세 더보기 메뉴 토글
function toggleDetailMenu(e, btn){
	e.stopPropagation();
	const menu = btn.nextElementSibling;
	if (!menu) return;

	// 다른 열린 메뉴 닫기
	document.querySelectorAll('.travellog-card-menu.active').forEach(m => { 
		if (m !== menu) m.classList.remove('active'); 
	});

	menu.classList.toggle('active');
}

// 바깥 클릭 시 닫기
document.addEventListener('click', function(){
	document.querySelectorAll('.travellog-card-menu.active').forEach(m => m.classList.remove('active'));
});

async function reportPost(rcdNo, titlePreview){
	return openReportModal('TRIP_RECORD', Number(rcdNo), titlePreview);
}

function escapeHtml(text) {
	if (text == null) return '';
	return String(text)
		.replace(/&/g, '&amp;')
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;')
		.replace(/"/g, '&quot;')
		.replace(/'/g, '&#039;');
}

function escapeJsString(str){
	// JS 문자열 깨짐 방지 (따옴표/개행)
	return String(str)
		.replace(/\\/g, '\\\\')
		.replace(/'/g, "\\'")
		.replace(/\r/g, '\\r')
		.replace(/\n/g, '\\n');
}

async function openReportModal(targetType, targetNo, previewText){
	  const n = Number(targetNo);
	  if (!Number.isFinite(n) || n <= 0) {
	    console.error('잘못된 targetNo', targetNo, 'targetType=', targetType);
	    Swal.fire('오류', '신고 대상을 확인할 수 없습니다.', 'error');
	    return;
	  }

	  if (AUTH_ROLE !== ROLE_MEMBER) return;

	const modalHtml = `<div class="rpt-wrap">
	      <div class="rpt-header">
	        <div class="rpt-title"><span class="rpt-icon">⚠</span><span>신고하기</span></div>
	      </div>

	      <div class="rpt-body">
	        <div class="rpt-radio-list">
	        <label class="rpt-radio-card">
	          <input type="radio" name="rptReason" value="SPAM" checked />
  	        <span class="dot"></span><span class="txt">스팸/광고</span>
  	      </label>
  	      <label class="rpt-radio-card">
  	        <input type="radio" name="rptReason" value="ABUSE" />
  	        <span class="dot"></span><span class="txt">욕설/비방/혐오 표현</span>
  	      </label>	
	          <label class="rpt-radio-card">
	            <input type="radio" name="rptReason" value="FRAUD" />
	            <span class="dot"></span><span class="txt">사기/거짓 정보</span>
	          </label>
	          <label class="rpt-radio-card">
	            <input type="radio" name="rptReason" value="COPYRIGHT" />
	            <span class="dot"></span><span class="txt">저작권 침해</span>
	          </label>
	          <label class="rpt-radio-card">
	            <input type="radio" name="rptReason" value="ETC" />
	            <span class="dot"></span><span class="txt">기타</span>
	          </label>
	        </div>

	        <div class="rpt-section-title" style="margin-top:14px;">상세 내용 (선택)</div>
	        <textarea id="rptContent" class="rpt-textarea"
	          placeholder="신고 사유에 대한 상세 내용을 작성해주세요."></textarea>

	        <div class="rpt-warning">
	          <span class="warn-icon">ⓘ</span>
	          <span>허위 신고 시 서비스 이용이 제한될 수 있습니다. 신고 내용은 검토 후 처리됩니다.</span>
	        </div>
	      </div>
	    </div>
	`;

	const result = await Swal.fire({
		html: modalHtml,
	    showCancelButton: true,
	    confirmButtonText: '신고하기',
	    cancelButtonText: '취소',
	    focusConfirm: false,
	    width: 520,
	    padding: 0,
	    customClass: {
			popup: 'rpt-swal-popup',
			htmlContainer: 'rpt-swal-html',
			confirmButton: 'rpt-btn rpt-btn-danger',
			cancelButton: 'rpt-btn rpt-btn-ghost'
	    },
	    preConfirm: () => {
			const checked = Swal.getPopup().querySelector('input[name="rptReason"]:checked');
			const ctgryCd = checked ? checked.value : 'FRAUD'; // 기본값 확정
			const content = (Swal.getPopup().querySelector('#rptContent')?.value || '').trim();
			return { ctgryCd, content };
		}

	});

	if (!result.isConfirmed) return;

	const payload = {
		mgmtType: 'REPORT',
		targetType: targetType,
		targetNo: Number(targetNo),
		ctgryCd: result.value.ctgryCd,
		content: result.value.content || ''
	};

	const { token, header } = getCsrf();
	const headers = { 'Content-Type': 'application/json' };
	if (token && header) headers[header] = token;

	const res = await fetch(CTX + '/api/report', {
		method: 'POST',
		credentials: 'same-origin',
		headers,
		body: JSON.stringify(payload)
	});

	if (res.status === 409) {
		const msg = await res.text().catch(()=> '이미 신고한 내역이 존재합니다.');
		Swal.fire('안내', msg, 'info');
		return;
	}
			
	if (!res.ok) {
		const text = await res.text().catch(()=> '');
		console.error('report failed', res.status, text, payload);
		Swal.fire('실패', `신고 처리 오류 (${res.status})`, 'error');
		return;
	}

	Swal.fire('접수 완료', '신고가 접수되었습니다. 감사합니다.', 'success');
}

async function openEditComment(cmntNo, oldContent) {
	const result = await Swal.fire({
	  title: '댓글 수정',
	  input: 'text',
	  inputValue: oldContent,
	  showCancelButton: true,
	  confirmButtonText: '수정',
	  cancelButtonText: '취소',
	  confirmButtonColor: '#1abc9c',
	  inputValidator: (v) => (!v || !v.trim()) ? '내용을 입력하세요' : null
	});
	
	if (!result.isConfirmed) return;
	
	const csrf = getCsrf();
	const headers = { 'Content-Type': 'application/json' };
	if (csrf.token && csrf.header) headers[csrf.header] = csrf.token;
	
	const url = CTX + '/api/community/travel-log/comments/' + encodeURIComponent(cmntNo);
	
	const res = await fetch(url, {
	  method: 'PUT',
	  credentials: 'same-origin',
	  headers,
	  body: JSON.stringify({ content: result.value.trim() })
	});
	
	if (!res.ok) {
	  const text = await res.text().catch(() => '');
	  console.error('댓글 수정 실패', res.status, text);
	  Swal.fire('오류', '수정 실패(본인 댓글만 가능)', 'error');
	  return;
	}
	
	loadComments(CURRENT_RCD_NO);
}


async function reportComment(cmntNo, cmntContentPreview){
	  const targetNo = Number(cmntNo);

	  if (!Number.isFinite(targetNo) || targetNo <= 0) {
	    console.error('❌ 댓글 번호 이상', { cmntNo, targetNo, cmntContentPreview });
	    Swal.fire('오류', '댓글 번호를 확인할 수 없습니다.', 'error');
	    return;
	  }

	  return openReportModal('COMMENT', targetNo, cmntContentPreview);
}

// ===== 가드(한 번만 선언) =====

// ✅ 비로그인/권한 가드: alert → SweetAlert2로 변경
function guardMemberAction(e){
	if (e) e.preventDefault();

	// 비로그인
	if (AUTH_ROLE === 'ANON') {
		// showLoginOverlay가 있으면 그대로 쓰고,
		if (typeof showLoginOverlay === 'function') {
			showLoginOverlay();
			return false;
		}
		
		// 없으면 SweetAlert로 안내 + 로그인 이동
		Swal.fire({
			icon: 'info',
			title: '로그인이 필요해요',
			text: '좋아요는 로그인한 일반회원만 사용할 수 있어요.',
			showCancelButton: true,
			confirmButtonText: '로그인하기',
			cancelButtonText: '취소',
			confirmButtonColor: '#1abc9c'
		}).then((r) => {
			if (r.isConfirmed) {
			  location.href = CTX + '/member/login';
			}
		});
		return false;
	}

	// 기업회원 차단
	if (AUTH_ROLE === ROLE_BUSINESS) {
		Swal.fire({
			icon: 'warning',
			title: '이용 불가',
			text: '일반회원만 좋아요를 누를 수 있어요.',
			confirmButtonText: '확인',
			confirmButtonColor: '#1abc9c'
		});
		return false;
	}

	return true;
}

function guardShareAction(e){
	if (e) e.preventDefault();
    if (AUTH_ROLE === ROLE_BUSINESS) return false;
    return true; // ANON + MEMBER
}

function scrollToComments(){
	const el = document.getElementById('commentsSection');
	if (el) el.scrollIntoView({behavior:'smooth', block:'start'});
}

// ===== 좋아요(서버 토글) =====
async function toggleDetailLike(e, btn){
	if (!guardMemberAction(e)) return;
	
	const { token, header } = getCsrf();
	const headers = { 'Content-Type': 'application/json' };
	if (token && header) headers[header] = token;
	
	const res = await fetch(CTX + '/api/community/travel-log/likes/toggle', {
		method: 'POST',
		credentials: 'same-origin',
		headers,
		body: JSON.stringify({ rcdNo: CURRENT_RCD_NO })
	});
	
	if (!res.ok) {
		Swal.fire('오류', '좋아요 처리 중 오류가 발생했어요.', 'error');
		return;
	}
	
	const data = await res.json();
	const icon = btn.querySelector('i');
	const countEl = document.getElementById('likeCount');
	
	icon.className = data.liked ? 'bi bi-heart-fill' : 'bi bi-heart';
	countEl.textContent = data.likeCount;
	btn.classList.toggle('active', !!data.liked);
}

  // ===== 공유 =====
function shareDetail() {
	const url = location.href;
	navigator.clipboard.writeText(url).then(() => {
		showCopyToast('링크가 복사되었습니다.');
	}).catch(() => {
		Swal.fire({ icon: 'info', title: '링크 복사', text: url });
	});
}

//✅ 댓글 시간 포맷: "2026-01-15 16:30" (KST 기준)
function formatCommentDt(regDt) {
  if (!regDt) return '';

  // 1) 이미 "YYYY-MM-DD HH:mm:ss" 또는 "YYYY-MM-DD HH:mm"로 내려오는 경우(문자열)
  //    -> 그대로 분까지만 잘라서 사용
  if (typeof regDt === 'string') {
    // "2026-01-15 16:30:12" / "2026-01-15 16:30"
    if (/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}/.test(regDt)) {
      return regDt.slice(0, 16);
    }
  }

  // 2) ISO 문자열("2026-01-15T07:23:33.000+00:00") or Date 파싱
  const d = new Date(regDt);
  if (isNaN(d.getTime())) return String(regDt);

  // ✅ KST로 변환해서 "YYYY-MM-DD HH:mm:ss" 형태로 뽑기 (sv-SE가 포맷이 딱 좋음)
  const s = d.toLocaleString('sv-SE', {
    timeZone: 'Asia/Seoul',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false
  });

  // s 예시: "2026-01-15 16:30:12" -> "2026-01-15 16:30"
  return s.slice(0, 16);
}
  
  
async function loadComments(rcdNo) {
	
	const url = CTX + '/api/community/travel-log/comments?rcdNo=' + encodeURIComponent(rcdNo);
	
	const res = await fetch(url, { credentials: 'same-origin' });

	if (!res.ok) {
		const text = await res.text().catch(() => '');
  		console.error('댓글 조회 실패', res.status, text);
  		return;
	}

	
	const list = await res.json();
	
	document.getElementById("commentCount").textContent = list.length;
	
	const topCnt = document.getElementById("commentCountTop");
  	if (topCnt) topCnt.textContent = list.length;	
	
  	const wrap = document.getElementById("commentList");
  	wrap.innerHTML = "";

  	// ===== 1) 부모/자식 그룹핑 =====
  	const parents = [];
  	const childrenMap = new Map(); // key: parentCmntNo, value: children[]

  	list.forEach((c) => {
  	  const parentNo = (c.parentCmntNo ?? c.parent_cmnt_no ?? c.parentNo ?? null);
  	  const parentKey = (parentNo == null || parentNo === '' ? null : Number(parentNo));

  	  if (parentKey == null || !Number.isFinite(parentKey)) {
  	    parents.push(c);
  	  } else {
  	    if (!childrenMap.has(parentKey)) childrenMap.set(parentKey, []);
  	    childrenMap.get(parentKey).push(c);
  	  }
  	});

  	// (선택) 정렬: 같은 그룹 내 작성시간/번호 기준 정렬하고 싶으면 켜기
  	const byNoAsc = (a,b) => Number(a.cmntNo ?? a.commentNo ?? 0) - Number(b.cmntNo ?? b.commentNo ?? 0);
  	parents.sort(byNoAsc);
  	childrenMap.forEach(arr => arr.sort(byNoAsc));

  	// ===== 2) 렌더 함수(부모/자식 공통) =====
  	function renderOneComment(c, rcdNo, isReply){
  	  const contentRaw = (c.cmntContent ?? '');

  	  const rawCmntNo =
  	        c.cmntNo
  	     ?? c.commentNo
  	     ?? c.cmnt_no
  	     ?? c.comment_no
  	     ?? c.cmntId
  	     ?? c.commentId
  	     ?? c.cmnt_id
  	     ?? c.comment_id
  	     ?? c.id
  	     ?? c.no;

  	  const cmntNo = Number(rawCmntNo);
  	  
//   	  const rootParentNo = Number(c.rootCmntNo || c.root_cmnt_no || c.ROOT_CMNT_NO || cmntNo);

  	  // ✅ 삭제 여부(서버 필드명 자동 대응)
  	  const isDeleted =
  	    (c.delYn === 'Y') ||
  	    (c.deleteYn === 'Y') ||
  	    (c.deleted === true) ||
  	    (c.cmntDelYn === 'Y') ||
  	    (String(c.status || '').toUpperCase() === 'DELETED') ||
  	    (typeof contentRaw === 'string' && contentRaw.trim() === '삭제된 댓글입니다.');
	
  		const hasProfile = (c.profilePath && String(c.profilePath).trim() !== '' && String(c.profilePath).trim() !== 'null');

	 // profilePath가 "/2026/01/..../a.jpg" 처럼 오면 그대로 붙이고,
	 // 혹시 "2026/01/..."처럼 슬래시가 없으면 앞에 '/'를 보정
	 const profilePath = hasProfile ? String(c.profilePath).trim() : '';
	 const normalized = (profilePath && profilePath.startsWith('/')) ? profilePath : ('/' + profilePath);
	
	 const avatar = hasProfile ? (CTX + '/files' + normalized) : DEFAULT_AVATAR;


  	  const isWriter = (Number(c.isWriter) === 1);

  	  const canReply  = (!isDeleted && AUTH_ROLE === ROLE_MEMBER);
  	  const canReport = (!isDeleted && AUTH_ROLE === ROLE_MEMBER && !isWriter);

  	  const myLiked = (Number(c.myLiked) === 1);
  	  const likeCount = Number(c.likeCount || 0);

  	  const iconCls = myLiked ? 'bi-heart-fill' : 'bi-heart';
  	  const btnCls  = 'cmnt-like-btn' + (myLiked ? ' active' : '');

  	  const likeBtnHtml = (!isDeleted && Number.isFinite(cmntNo))
  	    ? '<button type="button" class="' + btnCls + '" onclick="toggleCommentLike(' + cmntNo + ', this)">' +
  	        '<i class="bi ' + iconCls + '"></i>' +
  	        '<span class="cmnt-like-count">' + likeCount + '</span>' +
  	      '</button>'
  	    : '';

  	  const reportBtnHtml =
  	    (!isDeleted && canReport && Number.isFinite(cmntNo) && cmntNo > 0)
  	      ? '<button type="button" onclick="reportComment(' + cmntNo + ', \'' + escapeJsString(contentRaw) + '\')">' +
  	          '<i class="bi bi-flag"></i> 신고' +
  	        '</button>'
  	      : '';

  	  const contentHtml = isDeleted ? '삭제된 댓글입니다.' : escapeHtml(contentRaw);
  	  const contentForJs = escapeJsString(contentRaw);

  	  const editDelHtml = (!isDeleted && isWriter && Number.isFinite(cmntNo))
  	    ? '<button type="button" onclick="openEditComment(' + cmntNo + ', \'' + contentForJs + '\')">' +
  	        '<i class="bi bi-pencil"></i> 수정' +
  	      '</button>' +
  	      '<button type="button" onclick="deleteComment(' + cmntNo + ')">' +
  	        '<i class="bi bi-trash"></i> 삭제' +
  	      '</button>'
  	    : '';

	  const replyBtnHtml = canReply && Number.isFinite(cmntNo)
  	    ? '<button type="button" onclick="toggleReplyBox(' + cmntNo + ')">' +
  	        '<i class="bi bi-reply"></i> 답글' +
  	      '</button>'
  	    : '';

  	  const replyBoxHtml = canReply && Number.isFinite(cmntNo)
  	    ? '<div id="replyBox-' + cmntNo + '" style="display:none; margin-top:10px;">' +
  	        '<div class="detail-comment-input" style="margin-bottom:0;">' +
  	          '<input id="replyInput-' + cmntNo + '" placeholder="대댓글을 입력하세요...">' +
  	          '<button type="button" onclick="submitReply(' + rcdNo + ', ' + cmntNo + ')">등록</button>' +
  	        '</div>' +
  	      '</div>'
  	    : '';


  	  const item = document.createElement("div");
  	  item.className = "detail-comment" + (isReply ? " is-reply" : "");

  	item.innerHTML =
  	  '<img class="detail-comment-avatar" src="' + avatar + '" alt="avatar" ' +
  	    'onerror="this.onerror=null;this.src=\'' + DEFAULT_AVATAR + '\';" />' +
  	  '<div class="detail-comment-content">' +
  	    '<div class="detail-comment-header">' +
  	      '<span class="detail-comment-author">' + (c.nickname || c.writerId || 'unknown') + '</span>' +
  	      '<span class="detail-comment-time">' + formatCommentDt(c.regDt || c.reg_dt) + '</span>' +
  	    '</div>' +
  	    '<p class="detail-comment-text">' + contentHtml + '</p>' +
  	    '<div class="detail-comment-actions">' +
  	      likeBtnHtml +
  	      replyBtnHtml +
  	      editDelHtml +
  	      reportBtnHtml +
  	    '</div>' +
  	    replyBoxHtml +
  	  '</div>';

  	  return item;
  	}

  	// ===== 3) 실제 출력: 부모 → 자식들(바로 아래) =====
  	/* parents.forEach((p) => {
  	  const pNo = Number(p.cmntNo ?? p.commentNo ?? 0);

  	  // 그룹 래퍼(부모+대댓글 묶음)
  	  const group = document.createElement('div');
  	  group.className = 'detail-comment-group';

  	  // 부모 추가
  	  group.appendChild(renderOneComment(p, rcdNo, false));

  	  // 자식 리스트가 있으면 바로 이어서 추가
  	  const children = childrenMap.get(pNo) || [];
  	  if (children.length > 0) {
  	    const replyList = document.createElement('div');
  	    replyList.className = 'reply-list';

  	    children.forEach((ch) => {
  	      replyList.appendChild(renderOneComment(ch, rcdNo, true));
  	    });

  	    group.appendChild(replyList);
  	  }

  	  wrap.appendChild(group);
  	}); */
  	
 // depth별 들여쓰기 px (원하면 숫자 바꿔도 됨)
  	const INDENT_PX = 56;

  	function getCmntNo(node){
  	  const raw =
  	        node.cmntNo
  	     ?? node.commentNo
  	     ?? node.cmnt_no
  	     ?? node.comment_no
  	     ?? node.cmntId
  	     ?? node.commentId
  	     ?? node.id
  	     ?? node.no;
  	  return Number(raw);
  	}

  	function renderThread(node, depth){
  	  const nodeNo = getCmntNo(node);

  	  // ✅ 1) "노드 컨테이너"(세로) 생성
  	  const nodeWrap = document.createElement('div');
  	  nodeWrap.className = 'cmnt-node' + (depth >= 1 ? ' is-reply' : '');

  	  // ✅ 2) 들여쓰기는 margin-left가 아니라 "padding-left"로 (선 + 내용 같이 이동)
  	  if (depth >= 1) {
  	    nodeWrap.style.paddingLeft = (INDENT_PX * depth) + 'px';
  	  }

  	  // ✅ 3) 댓글 본문(기존 renderOneComment는 .detail-comment flex 덩어리)
  	  const bodyEl = renderOneComment(node, rcdNo, depth >= 1);
  	  nodeWrap.appendChild(bodyEl);

  	  // ✅ 4) 자식들은 "아래로 계속" (세로 컨테이너에 붙임)
  	  const kids = (Number.isFinite(nodeNo) && nodeNo > 0) ? (childrenMap.get(nodeNo) || []) : [];
  	  if (kids.length > 0) {
  	    const childrenEl = document.createElement('div');
  	    childrenEl.className = 'cmnt-children';

  	    kids.forEach((ch) => {
  	      childrenEl.appendChild(renderThread(ch, depth + 1));
  	    });

  	    nodeWrap.appendChild(childrenEl);
  	  }

  	  return nodeWrap;
  	}

 // ✅ ROOT 기준으로 "부모 아래로만" 쌓이게 2단 고정 렌더링

  	function getNo(c){
  	  const raw =
  	    c.cmntNo ?? c.commentNo ?? c.cmnt_no ?? c.comment_no ??
  	    c.cmntId ?? c.commentId ?? c.id ?? c.no;
  	  return Number(raw);
  	}

  	function getRoot(c){
  	  const raw = c.rootCmntNo ?? c.root_cmnt_no ?? c.ROOT_CMNT_NO;
  	  const n = Number(raw);
  	  return Number.isFinite(n) && n > 0 ? n : null;
  	}

  	const parents2 = [];
  	const repliesByRoot = new Map(); // key=rootCmntNo, value=replies[]

  	list.forEach((c) => {
  	  const parentNo = (c.parentCmntNo ?? c.parent_cmnt_no ?? c.parentNo ?? null);
  	  const parentKey = (parentNo == null || parentNo === '' ? null : Number(parentNo));

  	  // 최상위 댓글
  	  if (parentKey == null || !Number.isFinite(parentKey)) {
  	    parents2.push(c);
  	    return;
  	  }

  	  // 대댓글/대대댓글 포함: root 기준으로 모으기
  	  const root = getRoot(c) || parentKey;
  	  if (!repliesByRoot.has(root)) repliesByRoot.set(root, []);
  	  repliesByRoot.get(root).push(c);
  	});

  	// 정렬(번호순)
  	const byNoAsc2 = (a,b) => getNo(a) - getNo(b);
  	parents2.sort(byNoAsc2);
  	repliesByRoot.forEach(arr => arr.sort(byNoAsc2));

  	// 출력: 부모 -> reply-list(아래로만)
  	parents2.forEach((p) => {
  	  const pNo = getNo(p);

  	  const group = document.createElement('div');
  	  group.className = 'detail-comment-group';

  	  group.appendChild(renderOneComment(p, rcdNo, false));

  	  const replies = repliesByRoot.get(pNo) || [];
  	  if (replies.length > 0) {
  	    const replyList = document.createElement('div');
  	    replyList.className = 'reply-list';

  	    replies.forEach((r) => {
  	      replyList.appendChild(renderOneComment(r, rcdNo, true));
  	    });

  	    group.appendChild(replyList);
  	  }

  	  wrap.appendChild(group);
  	});


}

function toggleReplyBox(cmntNo) {
	  // 다른 입력칸 닫기
	  document.querySelectorAll('[id^="replyBox-"]').forEach(el => {
	    if (el.id !== 'replyBox-' + cmntNo) el.style.display = 'none';
	  });

	  const box = document.getElementById('replyBox-' + cmntNo);
	  if (!box) return;

	  box.style.display = (box.style.display === "none" ? "block" : "none");
	}


async function submitComment(rcdNo) {
 	if (AUTH_ROLE !== ROLE_MEMBER) return;
	
 	const input = document.getElementById("commentInput");
	const content = (input.value || "").trim();
	if (!content) return;
	
	const csrf = getCsrf();
	const headers = { "Content-Type": "application/json" };
	if (csrf.token && csrf.header) headers[csrf.header] = csrf.token;
	
	const url = CTX + '/api/community/travel-log/comments?rcdNo=' + encodeURIComponent(rcdNo);
	
	const res = await fetch(url, {
	  method: "POST",
	  credentials: "same-origin",
	  headers,
	  body: JSON.stringify({ content })
	});
	
	if (!res.ok) {
	  const text = await res.text().catch(() => '');
	  console.error('댓글 등록 실패', res.status, text);
	  Swal.fire('오류', '댓글 등록 실패', 'error');
	  return;
	}
	
	input.value = "";
	loadComments(rcdNo);
}

async function submitReply(rcdNo, parentCmntNo) {
	if (AUTH_ROLE !== ROLE_MEMBER) return;
	
	const input = document.getElementById('replyInput-' + parentCmntNo);
	const content = (input?.value || "").trim();
	if (!content) return;
	
	const csrf = getCsrf();
	const headers = { "Content-Type": "application/json" };
	if (csrf.token && csrf.header) headers[csrf.header] = csrf.token;
	
	const url = CTX + '/api/community/travel-log/comments?rcdNo=' + encodeURIComponent(rcdNo);
	
	const res = await fetch(url, {
	  method: "POST",
	  credentials: "same-origin",
	  headers,
	  body: JSON.stringify({ content, parentCmntNo })
	});
	
	if (!res.ok) {
	  const text = await res.text().catch(() => '');
	  console.error('답글 등록 실패', res.status, text);
	  Swal.fire('오류', '답글 등록 실패', 'error');
	  return;
	}
	
	if (input) input.value = "";
	loadComments(rcdNo);
}


async function deleteComment(cmntNo) {
	if (AUTH_ROLE !== ROLE_MEMBER) return;
	
	const ok = await Swal.fire({
	  icon: 'warning',
	  title: '댓글을 삭제할까요?',
	  showCancelButton: true,
	  confirmButtonText: '삭제',
	  cancelButtonText: '취소',
	  confirmButtonColor: '#ef4444'
	}).then(r => r.isConfirmed);
	
	if (!ok) return;
	
	const csrf = getCsrf();
	const headers = {};
	if (csrf.token && csrf.header) headers[csrf.header] = csrf.token;
	
	const url = CTX + '/api/community/travel-log/comments/' + encodeURIComponent(cmntNo);
	
	const res = await fetch(url, {
	  method: "DELETE",
	  credentials: "same-origin",
	  headers
	});
	
	if (!res.ok) {
	  const text = await res.text().catch(() => '');
	  console.error('댓글 삭제 실패', res.status, text);
	  Swal.fire('오류', '삭제 실패(본인 댓글만 가능)', 'error');
	  return;
	}
	
	loadComments(CURRENT_RCD_NO);
}

async function toggleCommentLike(cmntNo, btn) {
	if (AUTH_ROLE !== ROLE_MEMBER) {
	  Swal.fire('안내', '일반회원만 좋아요가 가능해요.', 'info');
	  return;
	}
	
	const csrf = getCsrf();
	const headers = { 'Content-Type': 'application/json' };
	if (csrf.token && csrf.header) headers[csrf.header] = csrf.token;
	
	const url = CTX + '/api/community/travel-log/comments/' + encodeURIComponent(cmntNo) + '/likes/toggle';
	
	const res = await fetch(url, {
	  method: 'POST',
	  credentials: 'same-origin',
	  headers
	});
	
	if (!res.ok) {
	  const text = await res.text().catch(() => '');
	  console.error('댓글 좋아요 실패', res.status, text);
	  Swal.fire('오류', '댓글 좋아요 처리 실패', 'error');
	  return;
	}
	
	const data = await res.json(); // { liked, likeCount }
	
	btn.classList.toggle('active', !!data.liked);
	
	const icon = btn.querySelector('i');
	if (icon) icon.className = 'bi ' + (data.liked ? 'bi-heart-fill' : 'bi-heart');
	
	const cnt = btn.querySelector('.cmnt-like-count');
	if (cnt) cnt.textContent = data.likeCount;
}


document.addEventListener("DOMContentLoaded", () => {
  	loadComments(CURRENT_RCD_NO);
});

</script>

<%@ include file="../common/footer.jsp"%>
