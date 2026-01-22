<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<c:set var="pageTitle" value="여행기록 상세" />
<c:set var="pageCss" value="community" />

<%@ include file="../common/header.jsp"%>

<!-- 현재 로그인/권한 상태를 JS가 읽어가게 심어둠 -->
<span id="authRole" style="display: none;"> <sec:authorize
		access="hasAuthority('ROLE_MEMBER')">ROLE_MEMBER</sec:authorize> <sec:authorize
		access="hasAuthority('ROLE_BUSINESS')">ROLE_BUSINESS</sec:authorize> <sec:authorize
		access="!isAuthenticated()">ANON</sec:authorize>
</span>

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<style>
/* ==================== DAY 배지 ==================== */
.day-header {
	display: flex;
	align-items: center;
	justify-content: flex-start; 
	gap: 12px;
	margin: 18px 0 10px;
}

.day-badge {
	display: inline-flex;
	align-items: center;
	gap: 10px;
	padding: 8px 14px;
	width: fit-content; 
	color: #111827;
	font-weight: 900;
	font-size: 13px;
	line-height: 1;
	letter-spacing: .2px;
}

.day-badge .day-dot {
	height: 28px;
	padding: 0 12px; 
	border-radius: 999px; 
	background: #107070;
	color: #fff;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	flex: 0 0 auto;
	box-shadow: 0 6px 18px rgba(0, 0, 0, .06);
	font-size: 12px;
	font-weight: 900;
	line-height: 1;
	letter-spacing: .2px;
}

.day-badge .day-date {
	margin-left: 0; 
	font-weight: 800;
	color: #64748b;
	font-size: 12px;
}

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

.travellog-detail-body {
	padding: 22px 24px 26px;
}

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

.travellog-detail-title {
	font-size: 26px;
	font-weight: 800;
	color: #0f172a;
	line-height: 1.25;
	margin: 8px 0 12px;
}

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

.travellog-detail-content {
	white-space: pre-wrap;
	line-height: 1.8;
	font-size: 15px;
	color: #334155;
	padding: 14px 2px 10px;
}

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

.copy-toast-container.swal2-top {
	left: 50% !important;
	transform: translateX(-50%) !important;
	right: auto !important;
	width: auto !important;
	padding-top: 12px !important;
}

.copy-toast-popup.swal2-toast {
	background: #22c55e !important;
	color: #fff !important;
	border-radius: 14px !important; /* 🔥 999px → 14px */
	padding: 12px 18px !important;
	box-shadow: 0 10px 22px rgba(0, 0, 0, .16) !important;
}

.copy-toast-popup .swal2-icon {
	display: none !important;
}

.copy-toast-popup .swal2-html-container {
	display: flex !important;
	margin: 0 !important;
	padding: 0 !important;
	align-items: center !important;
}

.copy-toast-row {
	display: flex;
	align-items: center;
	gap: 12px;
	font-weight: 900;
	font-size: 15px;
	line-height: 1;
	white-space: nowrap;
}

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

.rpt-body {
	padding: 16px 18px 18px;
}

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

.rpt-radio-card:has(input:checked) {
	background: #e8fbf6;
	border-color: #1abc9c;
	color: #0f172a;
}

.rpt-radio-card:has(input:checked) .dot {
	border-color: #1abc9c;
	background: #1abc9c;
}

.rpt-section-title {
	font-weight: 900;
	font-size: 13px;
	color: #111827;
	margin: 10px 0 8px;
}

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

.swal2-actions {
	margin: 0 !important;
	padding: 14px 18px 18px !important;
	gap: 10px !important;
	background: #fff;
}

.rpt-btn {
	border-radius: 12px !important;
	padding: 12px 14px !important;
	font-weight: 900 !important;
	font-size: 14px !important;
	box-shadow: none !important;
}

.rpt-btn-danger {
	background: #ef4444 !important;
	border: 1px solid #ef4444 !important;
}

.rpt-btn-danger:hover {
	filter: brightness(.98);
}

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

.detail-comment.is-reply {
	margin-left: 56px; 
	position: relative;
}

.detail-comment.is-reply::before {
	content: "";
	position: absolute;
	left: -18px;
	top: 10px;
	bottom: 10px;
	width: 2px;
	background: #e2e8f0;
	border-radius: 2px;
	opacity: .9;
}

.detail-comment.is-reply::after {
	content: "";
	position: absolute;
	left: -18px;
	top: 28px;
	width: 14px;
	height: 2px;
	background: #e2e8f0;
	border-radius: 2px;
	opacity: .9;
}

.detail-comment.is-reply .detail-comment-avatar {
	width: 32px;
	height: 32px;
}

.detail-comment.is-reply .detail-comment-text {
	border-radius: 12px;
	padding: 9px 11px;
}

.detail-comment-group {
	display: flex;
	flex-direction: column;
	gap: 10px; 
	margin-bottom: 14px; 
}

.detail-comment-group .reply-list {
	display: flex;
	flex-direction: column;
	gap: 8px; 
}

.detail-comment .reply-list {
	margin-top: 8px;
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.cmnt-node {
	position: relative;
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.cmnt-children {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.cmnt-node.is-reply::before {
	content: "";
	position: absolute;
	left: 28px; 
	top: 0;
	bottom: 0;
	width: 2px;
	background: #e2e8f0;
	border-radius: 2px;
	opacity: .9;
}

.cmnt-node.is-reply::after {
	content: "";
	position: absolute;
	left: 28px;
	top: 28px; 
	width: 18px;
	height: 2px;
	background: #e2e8f0;
	border-radius: 2px;
	opacity: .9;
}

.cmnt-node.is-reply .detail-comment-avatar {
	width: 32px;
	height: 32px;
}

.cmnt-node.is-reply .detail-comment-text {
	border-radius: 12px;
	padding: 9px 11px;
}

.travellog-block {
	margin: 14px 0;
}

.travellog-block-text {
	white-space: pre-wrap;
	line-height: 1.8;
	font-size: 15px;
	color: #334155;
}

.travellog-block-divider {
	height: 1px;
	background: #e2e8f0;
	margin: 18px 0;
	opacity: .9;
}

.travellog-block-image {
	border: 1px solid #e2e8f0;
	border-radius: 16px;
	overflow: hidden;
	background: #fff;
	box-shadow: 0 6px 18px rgba(0, 0, 0, .06);
}

.travellog-block-image img {
	width: 100%;
	display: block;
	max-height: 520px;
	object-fit: cover;
}

.travellog-block-image .caption {
	padding: 10px 12px;
	font-size: 13px;
	color: #64748b;
	border-top: 1px solid #e2e8f0;
	background: #f8fafc;
}

.place-card {
	display: flex;
	gap: 14px;
	border: 1px solid #e2e8f0;
	border-radius: 16px;
	overflow: hidden;
	background: #fff;
	box-shadow: 0 6px 18px rgba(0, 0, 0, .06);
	height: 180px;
	align-items: stretch; 
}

.place-thumb {
	width: 180px;
	min-width: 180px;
	background: #f1f5f9;
	overflow: hidden;
	padding: 0;
	display: block;
	align-self: stretch;
}

.place-thumb img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	object-position: center;
	display: block;
}

.place-body {
	flex: 1;
	padding: 12px 12px 12px 0;
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.place-title {
	font-weight: 900;
	font-size: 15px;
	color: #0f172a;
	line-height: 1.2;
}

.place-addr {
	font-size: 12.5px;
	color: #64748b;
	display: flex;
	align-items: center;
	gap: 6px;
}

.place-addr i {
	color: var(--primary-color);
}

.place-rating {
	display: flex;
	align-items: center;
	gap: 8px;
	font-size: 12.5px;
	color: #334155;
	font-weight: 800;
}

.place-stars {
	letter-spacing: 1px;
	color: #f59e0b;
	font-size: 13px;
}

.place-review {
	margin-top: 4px;
	font-size: 13.5px;
	line-height: 1.6;
	color: #334155;
	background: #f8fafc;
	border: 1px solid #e2e8f0;
	border-radius: 14px;
	padding: 10px 12px;
}

@media ( max-width : 768px) {
	.place-card {
		flex-direction: column;
	}
	.place-thumb {
		width: 100%;
		min-width: 100%;
		height: 200px;
	}
	.place-body {
		padding: 12px;
	}
}

.meta-tags {
	display: flex;
	align-items: center;
	gap: 10px;
	flex-wrap: wrap;
	margin-top: 6px;
}

.meta-tags i {
	color: var(--primary-color);
	font-size: 15px;
}

.tag-pill {
	display: inline-flex;
	align-items: center;
	padding: 7px 12px;
	border-radius: 999px;
	background: #e8fbf6;
	border: 1px solid #bff1e5;
	color: #0f172a;
	font-weight: 800;
	font-size: 12.5px;
	line-height: 1;
}

.tag-pill:hover {
	filter: brightness(.98);
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
						<c:set var="pp" value="${detail.profilePath}" />
						<c:choose>
							<c:when test="${not empty pp and pp != 'null'}">
								<c:choose>
									<c:when test="${fn:startsWith(pp, '/upload')}">
										<img class="travellog-detail-avatar"
											src="<c:url value='${pp}'/>" alt="avatar"
											onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80';">
									</c:when>
									<c:otherwise>
										<img class="travellog-detail-avatar"
											src="<c:url value='/upload${pp}'/>" alt="avatar"
											onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80';">
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<img class="travellog-detail-avatar"
									src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80"
									alt="avatar">
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

						<c:if test="${isWriter}">
							<div class="travellog-detail-actions-right">

								<span class="meta-pill"> <i class="bi bi-globe2"></i> 공개:
									<c:out value="${detail.openScopeCd}" />
								</span>

								<button type="button" class="btn btn-outline-secondary btn-sm"
									onclick="goEdit(${detail.rcdNo})">수정</button>

								<button type="button" class="btn btn-outline-danger btn-sm"
									onclick="confirmDelete(${detail.rcdNo})">삭제</button>
							</div>
						</c:if>

						<c:if test="${!isWriter}">
							<sec:authorize access="hasAuthority('ROLE_MEMBER')">
								<div class="travellog-more-wrapper" style="margin-left: auto;">
									<button type="button" class="travellog-more-btn" onclick="toggleDetailMenu(event, this)">
										<i class="bi bi-three-dots"></i>
									</button>

									<div class="travellog-card-menu">
										<button type="button" onclick="reportPost(CURRENT_RCD_NO, '${fn:escapeXml(detail.rcdTitle)}')">
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
						<span class="meta-pill"> <i class="bi bi-geo-alt"></i> 
							<c:out value="${detail.locName}" />
						</span> 
						<span class="meta-pill"> 
							<i class="bi bi-calendar-range"></i>
							일정: <fmt:formatDate value="${detail.startDt}" pattern="yyyy년 M월 d일" /> ~ <fmt:formatDate value="${detail.endDt}" pattern="yyyy년 M월 d일" />
						</span>

						<c:if test="${not empty detail.tagName}">
							<div class="meta-tags">

								<c:forEach var="t" items="${fn:split(detail.tagName, ',')}">
									<c:set var="tag" value="${fn:trim(t)}" />
									<c:if test="${not empty tag}">
										<c:choose>
											<c:when test="${fn:startsWith(tag, '#')}">
												<span class="tag-pill"><c:out value="${tag}" /></span>
											</c:when>
											<c:otherwise>
												<span class="tag-pill">#<c:out value="${tag}" /></span>
											</c:otherwise>
										</c:choose>
									</c:if>
								</c:forEach>
							</div>
						</c:if>
					</div>

					<!-- 본문 -->
					<div id="recordBlocks" class="travellog-detail-content"></div>

					<!-- (옵션) 예전 rcdContent fallback: blocks 로딩 실패 시에만 보여주고 싶으면 숨겨두기 -->
					<div id="recordContentFallback" class="travellog-detail-content"
						style="display: none;">
						<c:out value="${detail.rcdContent}" />
					</div>

					<!-- 액션 바 (반드시 래퍼로 감싸야 간격/구분선 적용됨) -->
					<div class="travellog-detail-actionbar">
						<button type="button"
							class="travellog-action-btn ${likeActiveClass}"
							onclick="toggleDetailLike(event,this);">

							<i class="bi ${detail.myLiked == 1 ? 'bi-heart-fill' : 'bi-heart'}"></i>
							<span id="likeCount">${detail.likeCount}</span>
						</button>

						<button type="button" class="travellog-action-btn"
							onclick="scrollToComments();">
							<i class="bi bi-chat"></i> <span id="commentCountTop">${detail.commentCount}</span>
						</button>

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
							<c:choose>
								<c:when test="${detail.replyEnblYn eq 'Y'}">
									<div class="detail-comment-input">
										<input id="commentInput" type="text"
											placeholder="댓글을 입력하세요..." />
										<button type="button" onclick="submitComment(CURRENT_RCD_NO)">등록</button>
									</div>
								</c:when>
								<c:otherwise>
									<div class="detail-comment-input">
										<input type="text" placeholder="작성자가 댓글을 비활성화했어요." disabled />
										<button type="button" disabled>등록</button>
									</div>
								</c:otherwise>
							</c:choose>
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

window.CTX = CTX;
window.CURRENT_RCD_NO = CURRENT_RCD_NO;

const ROLE_MEMBER = 'ROLE_MEMBER';
const ROLE_BUSINESS = 'ROLE_BUSINESS';


	
// 기본 프로필(외부 이미지로 고정)
const DEFAULT_AVATAR = "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80";

const ctxPath = '${pageContext.request.contextPath}';

function showCopyToast(message){
	const text = message || '링크가 복사되었습니다.';

	Swal.fire({
		toast: true,
		position: 'top',
		showConfirmButton: false,
		timer: 1600,
	    timerProgressBar: false,
	    icon: undefined,
	    title: undefined,
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

			// 2) SweetAlert2 기본 아이콘/타이틀이 혹시라도 생기면 제거
			popup.querySelectorAll('.swal2-icon, .swal2-title').forEach(el => el.remove());

			// 3) 전역 CSS가 html-container를 죽여도 강제로 살리기
			const html = popup.querySelector('.swal2-html-container');
			if (html) {
				html.style.margin = '0';
				html.style.padding = '0';
				html.style.display = 'flex';
				html.style.alignItems = 'center';
				html.style.justifyContent = 'center';
			}

			// 4) 토스트 pill 스타일을 inline으로 “강제”
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

			// 5) 컨테이너를 상단 가운데로 “강제”
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
	  return openDetailReportModal('TRIP_RECORD', Number(rcdNo), titlePreview);
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

function isReportSwalOpen(){
	  const p = (typeof Swal !== 'undefined') ? Swal.getPopup?.() : null;
	  return !!(p && p.classList.contains('rpt-swal-popup'));
}

async function openDetailReportModal(targetType, targetNo, previewText){
	  const n = Number(targetNo);
	  if (!Number.isFinite(n) || n <= 0) {
	    console.error('잘못된 targetNo', targetNo, 'targetType=', targetType);
	    Swal.fire('오류', '신고 대상을 확인할 수 없습니다.', 'error');
	    return;
	  }

	  if (AUTH_ROLE === 'ANON') {
		  Swal.fire({
		    icon: 'info',
		    title: '로그인이 필요해요',
		    text: '신고는 로그인한 일반회원만 사용할 수 있어요.',
		    showCancelButton: true,
		    confirmButtonText: '로그인하기',
		    cancelButtonText: '취소',
		    confirmButtonColor: '#1abc9c'
		  }).then(r => {
		    if (r.isConfirmed) location.href = CTX + '/member/login';
		  });
		  return;
		}
		if (AUTH_ROLE !== ROLE_MEMBER) {
		  Swal.fire({
		    icon: 'warning',
		    title: '이용 불가',
		    text: '일반회원만 신고할 수 있어요.',
		    confirmButtonText: '확인',
		    confirmButtonColor: '#1abc9c'
		  });
		  return;
		}

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

	const text = await res.text().catch(()=> '');

	if (res.status === 409) {
	  Swal.fire('안내', text || '이미 신고한 내역이 존재합니다.', 'info');
	  return;
	}

	if (!res.ok) {
	  console.error('report failed', res.status, text, payload);
	  Swal.fire('실패', text || `신고 처리 오류 (${res.status})`, 'error');
	  return;
	}

	// 성공 케이스: 서버가 1을 주든 json을 주든 상관없이 성공 처리
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

	  return openDetailReportModal('COMMENT', targetNo, cmntContentPreview);
}

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

// 댓글 시간 포맷(KST 기준)
function formatCommentDt(regDt) {
  if (!regDt) return '';

  // 1) 이미 "YYYY-MM-DD HH:mm:ss" 또는 "YYYY-MM-DD HH:mm"로 내려오는 경우(문자열)
  //    -> 그대로 분까지만 잘라서 사용
  if (typeof regDt === 'string') {
    if (/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}/.test(regDt)) {
      return regDt.slice(0, 16);
    }
  }

  // 2) ISO 문자열("2026-01-15T07:23:33.000+00:00") or Date 파싱
  const d = new Date(regDt);
  if (isNaN(d.getTime())) return String(regDt);

  // KST로 변환해서 "YYYY-MM-DD HH:mm:ss" 형태로 뽑기 (sv-SE가 포맷이 딱 좋음)
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

	  // 카운트 표시
	  const cnt = Array.isArray(list) ? list.length : 0;
	  const cc = document.getElementById("commentCount");
	  if (cc) cc.textContent = cnt;

	  const topCnt = document.getElementById("commentCountTop");
	  if (topCnt) topCnt.textContent = cnt;

	  const wrap = document.getElementById("commentList");
	  if (!wrap) return;
	  wrap.innerHTML = "";

	  // ===== 공통 유틸 =====
	  const getNo = (x) => Number(
	    x?.cmntNo ?? x?.commentNo ?? x?.cmnt_no ?? x?.comment_no ??
	    x?.cmntId ?? x?.commentId ?? x?.id ?? x?.no ?? 0
	  );

	  // ===== 댓글 렌더 =====
	  function renderOneComment(c, rcdNo, isReply) {
		  
		// ===== 작성자 표시: 닉네임(아이디) =====
		  const nick = (c.nickname || '').trim();
		  const id   = (c.writerId || '').trim();

		  let authorText = 'unknown';
		  if (nick && id) authorText = nick + '(' + id + ')';
		  else if (nick) authorText = nick;
		  else if (id) authorText = id;
		  
	    const contentRaw = (c.cmntContent ?? '');

	    const cmntNo = getNo(c);

	    // 삭제 여부(서버 필드명 자동 대응)
	    const isDeleted =
	      (c.delYn === 'Y') ||
	      (c.deleteYn === 'Y') ||
	      (c.deleted === true) ||
	      (c.cmntDelYn === 'Y') ||
	      (String(c.status || '').toUpperCase() === 'DELETED') ||
	      (typeof contentRaw === 'string' && contentRaw.trim() === '삭제된 댓글입니다.');

	    const isWriter = (Number(c.isWriter) === 1);

	    const canReply  = (!isDeleted && AUTH_ROLE === ROLE_MEMBER && ("${detail.replyEnblYn}" === "Y"));

	    const canReport = (!isDeleted && AUTH_ROLE === ROLE_MEMBER && !isWriter);

	    const myLiked = (Number(c.myLiked) === 1);
	    const likeCount = Number(c.likeCount || 0);

	    // ===== 아바타 =====
	    const hasProfile =
	      (c.profilePath && String(c.profilePath).trim() !== '' && String(c.profilePath).trim() !== 'null');

	    const profilePath = hasProfile ? String(c.profilePath).trim() : '';
		
		let normalized = profilePath.startsWith('/') ? profilePath : ('/' + profilePath);
		
		// 이미 /upload 로 시작하면 그대로 사용
		const avatar = hasProfile
		  ? (normalized.startsWith('/upload') ? (CTX + normalized) : (CTX + '/upload' + normalized))
		  : DEFAULT_AVATAR;

	    // ===== 버튼들 =====
	    const iconCls = myLiked ? 'bi-heart-fill' : 'bi-heart';
	    const btnCls  = 'cmnt-like-btn' + (myLiked ? ' active' : '');

	    const likeBtnHtml = (!isDeleted && Number.isFinite(cmntNo) && cmntNo > 0)
	      ? '<button type="button" class="' + btnCls + '" onclick="toggleCommentLike(' + cmntNo + ', this)">' +
	          '<i class="bi ' + iconCls + '"></i>' +
	          '<span class="cmnt-like-count">' + likeCount + '</span>' +
	        '</button>'
	      : '';

	    const replyBtnHtml = (canReply && Number.isFinite(cmntNo) && cmntNo > 0)
	      ? '<button type="button" onclick="toggleReplyBox(' + cmntNo + ')">' +
	          '<i class="bi bi-reply"></i> 답글' +
	        '</button>'
	      : '';

	    const editDelHtml = (!isDeleted && isWriter && Number.isFinite(cmntNo) && cmntNo > 0)
	      ? '<button type="button" onclick="openEditComment(' + cmntNo + ', \'' + escapeJsString(contentRaw) + '\')">' +
	          '<i class="bi bi-pencil"></i> 수정' +
	        '</button>' +
	        '<button type="button" onclick="deleteComment(' + cmntNo + ')">' +
	          '<i class="bi bi-trash"></i> 삭제' +
	        '</button>'
	      : '';

	    const reportBtnHtml = (!isDeleted && canReport && Number.isFinite(cmntNo) && cmntNo > 0)
	      ? '<button type="button" onclick="reportComment(' + cmntNo + ', \'' + escapeJsString(contentRaw) + '\')">' +
	          '<i class="bi bi-flag"></i> 신고' +
	        '</button>'
	      : '';

	    const replyBoxHtml = (canReply && Number.isFinite(cmntNo) && cmntNo > 0)
	      ? '<div id="replyBox-' + cmntNo + '" style="display:none; margin-top:10px;">' +
	          '<div class="detail-comment-input" style="margin-bottom:0;">' +
	            '<input id="replyInput-' + cmntNo + '" placeholder="대댓글을 입력하세요...">' +
	            '<button type="button" onclick="submitReply(' + rcdNo + ', ' + cmntNo + ')">등록</button>' +
	          '</div>' +
	        '</div>'
	      : '';

	    const contentHtml = isDeleted ? '삭제된 댓글입니다.' : escapeHtml(contentRaw);

	    const item = document.createElement("div");
	    item.className = "detail-comment" + (isReply ? " is-reply" : "");

	    item.innerHTML =
	      '<img class="detail-comment-avatar" src="' + avatar + '" alt="avatar" ' +
	        'onerror="this.onerror=null;this.src=\'' + DEFAULT_AVATAR + '\';" />' +
	      '<div class="detail-comment-content">' +
	        '<div class="detail-comment-header">' +
	        '<span class="detail-comment-author">' + escapeHtml(authorText) + '</span>' +
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

	  // ===== 2단 고정 렌더링(부모 + 모든 자식들을 root 기준으로 한 번 들여쓰기) =====
	  const parents2 = [];
	  const repliesByRoot = new Map(); 

	  (Array.isArray(list) ? list : []).forEach((c) => {
	    const parentNoRaw = (c.parentCmntNo ?? c.parent_cmnt_no ?? c.parentNo ?? null);
	    const parentKey = (parentNoRaw == null || parentNoRaw === '' ? null : Number(parentNoRaw));

	    // 최상위
	    if (parentKey == null || !Number.isFinite(parentKey)) {
	      parents2.push(c);
	      return;
	    }

	    // root 기준으로 묶기 (없으면 parentKey를 root로 사용)
	    const rootRaw = (c.rootCmntNo ?? c.root_cmnt_no ?? c.ROOT_CMNT_NO);
	    const root = Number(rootRaw) || parentKey;

	    if (!repliesByRoot.has(root)) repliesByRoot.set(root, []);
	    repliesByRoot.get(root).push(c);
	  });

	  // 정렬(번호순)
	  parents2.sort((a, b) => getNo(a) - getNo(b));
	  repliesByRoot.forEach(arr => arr.sort((a, b) => getNo(a) - getNo(b)));

	  // 출력
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
	        // ✅ 대댓글/대대댓글 포함해도 전부 2단(한 번 들여쓰기)로만 보이게
	        replyList.appendChild(renderOneComment(r, rcdNo, true));
	      });

	      group.appendChild(replyList);
	    }

	    wrap.appendChild(group);
	  });
}

// 전역: API 주소
const BLOCKS_API = CTX + '/api/travel-log/records/' + encodeURIComponent(CURRENT_RCD_NO) + '/blocks';

// ===== 유틸 =====
function safeText(v){ return (v == null) ? '' : String(v); }

function starString(rating){
  const r = Number(rating || 0);
  const full = Math.max(0, Math.min(5, Math.floor(r)));
  const empty = 5 - full;
  return '★'.repeat(full) + '☆'.repeat(empty);
}

function resolvePlaceImg(block){
  // 1) 첨부 이미지 경로 (DB에서 뽑은 FILE_PATH 등)
  const p = (block.placeImgPath || '').trim();
  if (p) return CTX + '/files' + p;

  // 2) 기본 이미지(URL 형태로 저장되어 있을 가능성)
  const d = (block.defaultImg || '').trim();
  if (d) return d;

  // 3) fallback
  return 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&h=600&fit=crop&q=80';
}

function tryParseJsonText(s){
  if (!s) return null;
  const t = String(s).trim();
  if (!(t.startsWith('{') && t.endsWith('}'))) return null;
  try { return JSON.parse(t); } catch(e){ return null; }
}

// day-header JSON에서 값 꺼내기 
function parseDayHeaderFromJson(obj){
  if (!obj) return null;
  const type = String(obj.type || '').toLowerCase();
  if (type !== 'day-header') return null;

  const dayNo   = obj.day ?? obj.dayNo ?? obj.order ?? '';
  const dateStr = obj.date ?? obj.dateStr ?? obj.dayDate ?? '';

  if (!dayNo) return null;
  return { dayNo: String(dayNo), dateStr: String(dateStr || '') };
}

function buildDayBadge(dayNo, dateStr){
  const wrap = document.createElement('div');
  wrap.className = 'travellog-block day-header';
  wrap.innerHTML =
    '<span class="day-badge">' +
      '<span class="day-dot">DAY ' + escapeHtml(String(dayNo)) + '</span>' +
      (dateStr ? ('<span class="day-date">' + escapeHtml(String(dateStr)) + '</span>') : '') +
    '</span>';
  return wrap;
}

function parseDayFromText(text){
  const m = String(text || '').trim().match(/^DAY\s*([0-9]+)\s*(\d{4}-\d{2}-\d{2})?\s*$/i);
  if (!m) return null;
  return { dayNo: m[1], dateStr: m[2] || '' };
}


function resolveImageSrc(rawPath){
	  const p = (rawPath ?? '').toString().trim();
	  if (!p || p === 'null' || p === 'undefined') return '';

	  // 절대 URL이면 그대로
	  if (/^https?:\/\//i.test(p)) return p;

	  // "/files/..." 로 이미 내려오면 CTX만 붙임
	  if (p.startsWith('/files/')) return CTX + p;

	  // "/upload/..." 로 내려오면 CTX만 붙임 
	  if (p.startsWith('/upload/')) return CTX + p;

	  // "/tripschedule/..." 같은 형태면 "/files" 붙여서 서빙
	  if (p.startsWith('/')) return CTX + '/files' + p;

	  // "tripschedule/..." 처럼 슬래시 없이 오면
	  return CTX + '/files/' + p;
	}

	function pickImagePath(block){
	  // 백엔드에서 필드명이 다를 수 있어서 후보를 넉넉히
	  return (
	    block?.imgPath ??
	    block?.imagePath ??
	    block?.filePath ??
	    block?.path ??
	    ''
	  );
}

// ===== 핵심: renderBlock은 딱 1개만! =====
function renderBlock(block){
  const typeRaw = (block.blockType || '').toString();
  const type = typeRaw.toUpperCase().replace(/[\s_-]/g, ''); // "DAY_HEADER" "day-header" 등 정규화

  // 1) DIVIDER
  if (type === 'DIVIDER') {
    const div = document.createElement('div');
    div.className = 'travellog-block travellog-block-divider';
    return div;
  }

  // 2) TEXT (여기서 day-header JSON 문자열 처리)
  if (type === 'TEXT') {
    const raw = safeText(block.text).trim();

    // 2-1) JSON day-header
    const obj = tryParseJsonText(raw);
    const dayJson = parseDayHeaderFromJson(obj);
    if (dayJson) return buildDayBadge(dayJson.dayNo, dayJson.dateStr);

    // 2-2) "DAY 1 2026-01-14" 패턴 (있으면)
    const dayText = parseDayFromText(raw);
    if (dayText) return buildDayBadge(dayText.dayNo, dayText.dateStr);

    // 2-3) 일반 텍스트
    const div = document.createElement('div');
    div.className = 'travellog-block travellog-block-text';
    div.innerHTML = escapeHtml(raw);
    return div;
  }

  // 3) IMAGE
  if (type === 'IMAGE') {
  const wrap = document.createElement('div');
  wrap.className = 'travellog-block travellog-block-image';

  const imgPathRaw = pickImagePath(block);
  const imgSrc = resolveImageSrc(imgPathRaw);

  // 캡션도 같이 숨길 수 있게 class 부여
  const captionHtml = block.desc
    ? ('<div class="caption">' + escapeHtml(block.desc) + '</div>')
    : '';

  // 이미지가 깨지면:
  // 1) 기본 이미지로 교체
  // 2) 그래도 깨지면(기본도 실패) 블록 전체 숨김(캡션 포함)
  const FALLBACK_IMG = 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&h=600&fit=crop&q=80';

  wrap.innerHTML =
    '<img src="' + escapeHtml(imgSrc || FALLBACK_IMG) + '" alt="image" ' +
      'onerror="' +
        'if(!this.dataset.fallback){' +
          'this.dataset.fallback=\'1\';' +
          'this.src=\'' + FALLBACK_IMG + '\';' +
        '}else{' +
          'this.closest(\'.travellog-block-image\').style.display=\'none\';' +
        '}' +
      '" />' +
    captionHtml;

  return wrap;
}

  // 4) PLACE
  if (type === 'PLACE') {
    const imgSrc = resolvePlaceImg(block);

    const addr1 = safeText(block.plcAddr1).trim();
    const addr2 = safeText(block.plcAddr2).trim();
    const addr = (addr1 + (addr2 ? (' ' + addr2) : '')).trim();

    const rating = (block.rating == null ? '' : String(block.rating));
    const stars = starString(block.rating);

    const card = document.createElement('div');
    card.className = 'travellog-block';

    card.innerHTML =
      '<div class="place-card">' +
        '<div class="place-thumb">' +
          '<img src="' + escapeHtml(imgSrc) + '" alt="place" ' +
               'onerror="this.onerror=null;this.src=\'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&h=600&fit=crop&q=80\';" />' +
        '</div>' +
        '<div class="place-body">' +
          '<div class="place-title">' + escapeHtml(safeText(block.plcNm || '장소')) + '</div>' +
          (addr ? ('<div class="place-addr"><i class="bi bi-geo-alt"></i>' + escapeHtml(addr) + '</div>') : '') +
          '<div class="place-rating">' +
            '<span class="place-stars">' + escapeHtml(stars) + '</span>' +
            (rating ? ('<span>' + escapeHtml(rating) + '</span>') : '') +
          '</div>' +
          (block.reviewConn ? ('<div class="place-review">' + escapeHtml(block.reviewConn) + '</div>') : '') +
        '</div>' +
      '</div>';

    return card;
  }

  // 5) fallback: 모르는 타입은 조용히 텍스트로
  const fallback = document.createElement('div');
  fallback.className = 'travellog-block travellog-block-text';
  fallback.innerHTML = ''; 
  return fallback;
}

// ===== 로드 =====
async function loadBlocks(rcdNo){
  const container = document.getElementById('recordBlocks');
  const fallback  = document.getElementById('recordContentFallback');
  if (!container) return;

  try{
    const res = await fetch(BLOCKS_API, { credentials:'same-origin' });

    if (!res.ok) throw new Error('blocks fetch failed: ' + res.status);

    const blocks = await res.json();

    container.innerHTML = '';

    if (!Array.isArray(blocks) || blocks.length === 0){
      if (fallback) fallback.style.display = 'block';
      return;
    }

    if (fallback) fallback.style.display = 'none';

    blocks.forEach(b => container.appendChild(renderBlock(b)));
  }catch(e){
    console.error(e);
    if (fallback) fallback.style.display = 'block';
  }
}

async function loadBlocks(rcdNo){
	  const container = document.getElementById('recordBlocks');
	  const fallback  = document.getElementById('recordContentFallback');
	  if (!container) return;

	  try{
	    const res = await fetch(BLOCKS_API, { credentials:'same-origin' });

	    if (!res.ok) throw new Error('blocks fetch failed: ' + res.status);

	    const blocks = await res.json();

	    container.innerHTML = '';

	    if (!Array.isArray(blocks) || blocks.length === 0){
	      if (fallback) fallback.style.display = 'block';
	      return;
	    }

	    if (fallback) fallback.style.display = 'none';

	    blocks.forEach(b => container.appendChild(renderBlock(b)));
	  }catch(e){
	    console.error(e);
	    if (fallback) fallback.style.display = 'block';
	  }
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
	
	const data = await res.json(); 
	
	btn.classList.toggle('active', !!data.liked);
	
	const icon = btn.querySelector('i');
	if (icon) icon.className = 'bi ' + (data.liked ? 'bi-heart-fill' : 'bi-heart');
	
	const cnt = btn.querySelector('.cmnt-like-count');
	if (cnt) cnt.textContent = data.likeCount;
}


document.addEventListener("DOMContentLoaded", () => {
	  loadBlocks(CURRENT_RCD_NO);
	  loadComments(CURRENT_RCD_NO);
});


function goEdit(rcdNo){
	  location.href = CTX + '/community/travel-log/write?rcdNo=' + encodeURIComponent(rcdNo);
	}

	async function confirmDelete(rcdNo){
	  const ok = await Swal.fire({
	    icon: 'warning',
	    title: '게시글을 삭제할까요?',
	    text: '삭제하면 복구할 수 없습니다.',
	    showCancelButton: true,
	    confirmButtonText: '삭제',
	    cancelButtonText: '취소',
	    confirmButtonColor: '#ef4444'
	  }).then(r => r.isConfirmed);

	  if (!ok) return;

	  const csrf = getCsrf();
	  const headers = {};
	  if (csrf.token && csrf.header) headers[csrf.header] = csrf.token;

	  const res = await fetch(CTX + '/api/travel-log/records/' + encodeURIComponent(rcdNo), {
	    method: 'DELETE',
	    credentials: 'same-origin',
	    headers
	  });

	  if (!res.ok){
	    const text = await res.text().catch(()=> '');
	    console.error('삭제 실패', res.status, text);
	    Swal.fire('오류', '삭제에 실패했어요.', 'error');
	    return;
	  }

	  Swal.fire({
	    icon: 'success',
	    title: '삭제 완료',
	    timer: 900,
	    showConfirmButton: false
	  }).then(() => {
	    location.href = CTX + '/community/travel-log';
	  });
}

</script>

<%@ include file="../common/footer.jsp"%>