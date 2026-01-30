<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<c:set var="pageTitle" value="여행톡" />
<c:set var="pageCss" value="community" />

<%@ include file="../common/header.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>



<style>
.thumb-wrap {
	width: 120px;
	height: 120px;
	border-radius: 12px;
	overflow: hidden;
	display: inline-block;
	border: 1px solid #e5e7eb;
	background: #f8fafc;
}

.thumb-img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block;
}

/* ===== 게시글 상세 모달 ===== */
.post-detail-overlay {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background: rgba(0, 0, 0, 0.6);
	z-index: 1200;
	display: flex;
	align-items: center;
	justify-content: center;
	opacity: 0;
	visibility: hidden;
	transition: all 0.3s ease;
	padding: 20px;
}

.post-detail-overlay.active {
	opacity: 1;
	visibility: visible;
}

.post-detail-modal {
	background: white;
	border-radius: 16px;
	width: 100%;
	max-width: 800px;
	max-height: 90vh;
	overflow: hidden;
	display: flex;
	flex-direction: column;
	transform: translateY(20px);
	transition: transform 0.3s ease;
}

.post-detail-overlay.active .post-detail-modal {
	transform: translateY(0);
}

.post-detail-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 16px 20px;
	border-bottom: 1px solid #eee;
	background: #f8fafc;
}

.post-detail-category {
	padding: 6px 14px;
	border-radius: 20px;
	font-size: 13px;
	font-weight: 600;
	background: var(--primary-color);
	color: white;
}

.post-detail-category.notice {
	background: #ef4444;
}

.post-detail-category.companion {
	background: #0d5c5c;
}

.post-detail-category.info {
	background: #3b82f6;
}

.post-detail-category.qna {
	background: #8b5cf6;
}

.post-detail-category.review {
	background: #f59e0b;
}

.post-detail-close {
	width: 36px;
	height: 36px;
	border-radius: 50%;
	border: none;
	background: white;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 18px;
	color: #666;
	transition: all 0.2s ease;
}

.post-detail-close:hover {
	background: #fee2e2;
	color: #ef4444;
}

.post-detail-body {
	padding: 24px;
	overflow-y: auto;
	flex: 1;
}

.post-detail-title {
	font-size: 24px;
	font-weight: 700;
	color: #1a1a1a;
	margin-bottom: 16px;
	line-height: 1.4;
}

.post-detail-meta {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 24px;
	padding-bottom: 16px;
	border-bottom: 1px solid #eee;
}

.post-author {
	display: flex;
	align-items: center;
	gap: 12px;
}

.post-author img {
	width: 44px;
	height: 44px;
	border-radius: 50%;
	object-fit: cover;
}

.author-info {
	display: flex;
	flex-direction: column;
}

.author-name {
	font-weight: 600;
	color: #333;
}

.post-date {
	font-size: 13px;
	color: #999;
}

.post-detail-stats {
	display: flex;
	gap: 16px;
	color: #666;
	font-size: 14px;
}

.post-detail-stats span {
	display: flex;
	align-items: center;
	gap: 4px;
}

.post-detail-content {
	font-size: 15px;
	line-height: 1.8;
	color: #333;
	min-height: 150px;
}

.post-detail-content p {
	margin-bottom: 16px;
}

.post-detail-content img {
	max-width: 100%;
	border-radius: 8px;
	margin: 16px 0;
}

.post-detail-tags {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	gap: 8px;
	padding: 16px 0;
	margin-top: 16px;
	border-top: 1px solid #f0f0f0;
	color: #666;
}

.post-detail-tags i {
	color: var(--primary-color);
}

.post-tag {
	display: inline-block;
	padding: 4px 12px;
	background: var(--primary-color);
	color: white;
	border-radius: 20px;
	font-size: 13px;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.2s ease;
}

.post-tag:hover {
	background: var(--primary-dark, #0d5c5c);
	color: white;
}

.post-detail-actions {
	display: flex;
	gap: 12px;
	padding-top: 20px;
	border-top: 1px solid #eee;
	margin-top: 20px;
}

.post-action-btn {
	display: flex;
	align-items: center;
	gap: 6px;
	padding: 10px 16px;
	border: 1px solid #ddd;
	background: white;
	border-radius: 8px;
	font-size: 14px;
	color: #666;
	cursor: pointer;
	transition: all 0.2s ease;
}

.post-action-btn:hover {
	border-color: var(--primary-color);
	color: var(--primary-color);
}

.post-action-btn.active {
	background: var(--primary-color);
	border-color: var(--primary-color);
	color: white;
}

.post-action-btn.active i {
	color: white;
}

/* 댓글 섹션 */
.post-comments-section {
	padding: 20px 24px;
	background: #f8fafc;
	border-top: 1px solid #eee;
	max-height: 300px;
	overflow-y: auto;
}

.comments-title {
	font-size: 16px;
	font-weight: 600;
	margin-bottom: 16px;
	color: #333;
}

.comments-list {
	display: flex;
	flex-direction: column;
	gap: 16px;
	margin-bottom: 16px;
}

.comment-item {
	display: flex;
	gap: 12px;
}

.comment-item .comment-avatar {
	width: 36px;
	height: 36px;
	border-radius: 50%;
	object-fit: cover;
	flex-shrink: 0;
}

.comment-body {
	flex: 1;
}

.comment-header {
	display: flex;
	align-items: center;
	gap: 8px;
	margin-bottom: 4px;
}

.comment-author {
	font-weight: 600;
	font-size: 14px;
	color: #333;
}

.comment-date {
	font-size: 12px;
	color: #999;
}

.comment-text {
	font-size: 14px;
	color: #555;
	line-height: 1.5;
}

.comment-actions {
	display: flex;
	gap: 12px;
	margin-top: 6px;
}

.comment-action {
	font-size: 12px;
	color: #999;
	background: none;
	border: none;
	cursor: pointer;
	padding: 0;
}

.comment-action:hover {
	color: var(--primary-color);
}

/* 댓글 작성 */
.comment-write {
	display: flex;
	gap: 12px;
	padding-top: 16px;
	border-top: 1px solid #e5e5e5;
}

.comment-write .comment-avatar {
	width: 36px;
	height: 36px;
	border-radius: 50%;
	object-fit: cover;
}

.comment-input-wrapper {
	flex: 1;
	display: flex;
	gap: 8px;
	align-items: flex-end;
}

.comment-input {
	flex: 1;
	border: 1px solid #ddd;
	border-radius: 20px;
	padding: 10px 16px;
	font-size: 14px;
	resize: none;
	max-height: 100px;
	outline: none;
	transition: border-color 0.2s ease;
}

.comment-input:focus {
	border-color: var(--primary-color);
}

.comment-submit-btn {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	background: var(--primary-color);
	border: none;
	color: white;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	transition: all 0.2s ease;
}

.comment-submit-btn:hover {
	background: #357ABD;
	transform: scale(1.05);
}

.comment-login-notice {
	text-align: center;
	padding: 16px;
	background: #f1f5f9;
	border-radius: 8px;
	color: #666;
	font-size: 14px;
}

.comment-login-notice a {
	color: var(--primary-color);
	font-weight: 600;
}

/* 클릭 가능한 게시글 아이템 */
.post-item {
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.post-item:hover {
	background-color: #f8fafc;
}

.post-title span {
	color: inherit;
}

@media ( max-width : 768px) {
	.post-detail-modal {
		max-height: 95vh;
		border-radius: 12px;
	}
	.post-detail-title {
		font-size: 20px;
	}
	.post-detail-meta {
		flex-direction: column;
		align-items: flex-start;
		gap: 12px;
	}
	.post-detail-actions {
		flex-wrap: wrap;
	}
	.post-action-btn {
		flex: 1;
		justify-content: center;
	}
}
</style>
<div class="community-page">
	<div class="container">
		<!-- 헤더 -->
		<div class="community-header">
			<h1>
				<i class="bi bi-chat-dots me-3"></i>여행톡
			</h1>
			<p>여행자들과 자유롭게 소통하고 정보를 나눠보세요</p>
		</div>
		<!-- boardVO있을때 상세출력
			model.addAttribute("boardVO",boardVO);
		-->
		<!-- boardVO 있을 때 상세 출력 -->
		<c:if test="${not empty boardVO}">
			<div class="card mb-4">
				<div class="card-body">

					<!-- 둘 중 하나 카테고리 지우시면 됩니다 span tag -->
					<div class="post-detail-header">
					    <span class="post-detail-category ${boardVO.boardCtgryCd}" id="postDetailCategory">
					        <c:choose>
					            <c:when test="${boardVO.boardCtgryCd eq 'companion'}">동행</c:when>
					            <c:when test="${boardVO.boardCtgryCd eq 'notice'}">공지</c:when>
					            <c:when test="${boardVO.boardCtgryCd eq 'free'}">자유</c:when>
					            <c:when test="${boardVO.boardCtgryCd eq 'info'}">정보</c:when>
					            <c:when test="${boardVO.boardCtgryCd eq 'qna'}">Q&A</c:when>
					            <c:when test="${boardVO.boardCtgryCd eq 'review'}">후기</c:when>
					            <c:otherwise>${boardVO.boardCtgryCd}</c:otherwise>
					        </c:choose>
					    </span>
					    <a class="btn btn-sm btn-outline-secondary"
					        href="${pageContext.request.contextPath}/community/talk"> 목록
					    </a>
					</div>

					<div class="post-detail-body">
						<h2 class="post-detail-title" id="postDetailTitle">${boardVO.boardTitle}</h2>
						<div class="post-detail-meta">
							<a
								href="${pageContext.request.contextPath}/community/talk?boardNo=${boardVO.boardNo}"></a>
							<div class="post-author" style="width: 50%;">
								<img
									src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80"
									alt="프로필" id="postAuthorAvatar">
								<div class="author-info">
									<span class="author-name" id="postAuthorName">
										${boardVO.writerNickname}<small>(${boardVO.writerId})</small>
									</span> <span class="post-date" id="postDate">${boardVO.regDt}</span>
								</div>
							</div>
							<div class="post-detail" style="width: 100%; display: flex;"></div>
							<div class="post-detail-stats">
								<span><i class="bi bi-eye"></i> <span id="postViews">${boardVO.viewCnt}</span></span>
								<span><i class="bi bi-chat"></i> <span
									id="postCommentCount">${boardVO.commentCnt}</span></span> <span><i
									class="bi bi-heart"></i> <span id="postLikes">${boardVO.likeCnt }</span></span>
							</div>
						</div>


						<!-- ✅ 본문 -->

						<div class="post-detail-content" id="postDetailContent">
							${boardVO.boardContent}</div>


						<!-- ✅ 해시태그(1번만 출력) -->

						<c:if test="${not empty boardVO.boardTagList}">
							<div class="post-detail-tags" id="postDetailTags">
								<c:forEach items="${boardVO.boardTagList}" var="t">
									<span class="badge rounded-pill bg-light text-dark me-1">#${t}</span>
								</c:forEach>
							</div>
						</c:if>

						<!-- ✅ 첨부파일: 썸네일 + 다운로드 목록 -->
						<c:if test="${not empty boardVO.boardFileList}">

							<!-- ✅ 본문 안 이미지 썸네일 -->
							<div class="mt-4">
								<div class="d-flex flex-wrap gap-2">
									<c:forEach items="${boardVO.boardFileList}" var="file">
										<c:if test="${file.fileNo ne 0}">

											<c:set var="ext" value="${fn:toLowerCase(file.fileExt)}" />
											<c:set var="ext" value="${fn:replace(ext,'.','')}" />

											<c:if
												test="${ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'gif' || ext == 'webp'}">
												<a
													href="${pageContext.request.contextPath}/community/talk/preview/${file.fileNo}"
													target="_blank" class="thumb-wrap"> <img
													class="thumb-img"
													src="${pageContext.request.contextPath}/community/talk/preview/${file.fileNo}"
													alt="${file.fileOriginalName}" />
												</a>
											</c:if>
										</c:if>
									</c:forEach>
								</div>
							</div>

							<!-- ✅ 첨부파일 다운로드 목록 -->

							<div class="mt-3">
								<strong>💾첨부파일</strong>
								<ul class="list-unstyled mt-2 mb-0">
									<c:forEach items="${boardVO.boardFileList}" var="file">
										<c:if test="${file.fileNo ne 0}">
											<li class="mb-1"><a
												href="${pageContext.request.contextPath}/community/talk/download/${file.fileNo}"
												class="text-decoration-none"> <i class="bi bi-paperclip"></i>
													${file.fileOriginalName}
											</a> <small class="text-muted">(${file.fileFancysize})</small></li>
										</c:if>
									</c:forEach>
								</ul>
							</div>
						</c:if>

						<div class="post-detail-actions ">
							<c:set value="bi bi-heart" var="icon" />
							<c:set value="" var="active" />
							<c:set value="" var="color" />
							<c:set value="N" var="stat" />
							<c:if test="${not empty boardVO.likes and boardVO.likes > 0 }">
								<c:set value="bi bi-heart-fill" var="icon" />
								<c:set value="active" var="active" />
								<c:set value="color:#ef4444" var="color" />
								<c:set value="Y" var="stat" />
							</c:if>
							<button class="post-action-btn ${active }"
								onclick="togglePostLike(this)" data-status=${stat }>
								<i class="${icon }" id="postLikeIcon" style="${color}"></i> <span>좋아요</span>
							</button>
							<button class="post-action-btn" onclick="sharePost()">
								<i class="bi bi-share"></i> <span>공유</span>
							</button>
							<sec:authorize access="hasRole('MEMBER')">
								<button class="post-action-btn report"
									data-board-no="${boardVO.boardNo}"
									data-board-title="${fn:escapeXml(boardVO.boardTitle)}"
									data-writer-no="${boardVO.writerNo}"
									onclick="reportPost(this)">
									<i class="bi bi-flag"></i> <span>신고</span>
								</button>


							</sec:authorize>



						</div>
			

						<div class="comments-list" id="commentsList">
							<jsp:include page="comment.jsp" />
						</div>

					</div>
				</div>
		</c:if>




		<script type="text/javascript">
function reportPost(btn) {
  const boardNo = btn.dataset.boardNo;
  const title = btn.dataset.boardTitle || '';
  const writerNo = btn.dataset.writerNo || '';

	    openReportModal('post', boardNo, title, writerNo);
	}


function getBoardNo(){
  const section = document.getElementById("commentSection");
  return section ? section.dataset.boardNo : null;
}

async function loadComments(){
  const boardNo = getBoardNo();
  if(!boardNo){
    console.error("boardNo 못 가져옴");
    return;
  }

  const res = await fetch(`/api/talk/\${boardNo}/comments`);
  if(!res.ok){
    console.error("댓글 조회 실패", res.status);
    return;
  }

  const list = await res.json();
  document.getElementById("comment-count").textContent = "(" + list.length + ")";
  console.log(list[0])
  const root = document.getElementById("comment-list");
  root.innerHTML = "";

  list.forEach(c => {
    const isReply = (c.depth && c.depth > 0);
    const writer = (c.writerNickname && c.writerNickname.trim())
    ? c.writerNickname
    : (c.writerId || "익명");

    

    const date = c.regDt ? c.regDt : "";
    const content = c.cmntContent ? c.cmntContent : "";

    const div = document.createElement("div");
    div.className = "border rounded p-3 mb-2" + (isReply ? " ms-4 bg-light" : "");

   
    let html = "";
    html += '<div class="d-flex justify-content-between">';
    html += '  <strong>' + writer + '</strong>';
    html += '  <small class="text-muted">' + date + '</small>';
    html += '</div>';
    html += '<div class="mt-2" style="white-space: pre-wrap;">' + content + '</div>';

    // ✅ 여기! 댓글 신고 버튼 (로그인한 회원만 노출)
    /* *************** 여기 신고 때문에 if(c.cmntStatus !='3'){} 추가**************************  */
    if (c.cmntStatus !='3') {

	    if (isLoggedIn) {
	    	if (isLoggedIn) {

	    		html += '<div class="mt-2 d-flex justify-content-end">';
	    	    html += '  <button type="button" class="btn btn-sm btn-outline-danger" '
	    	         +  'onclick="openReportModal(\'comment\', ' + c.cmntNo + ', \'\', ' + (c.writerNo || 'null') + ')">신고</button>';
	    	    html += '</div>';
	    	}
	    }

	    if(!isReply){
	      html += '<div class="mt-2">';
	      html += '  <button class="btn btn-sm btn-link" type="button" onclick="toggleReplyForm(' + c.cmntNo + ')">답글</button>';
	      html += '</div>';

	      html += '<div id="replyForm-' + c.cmntNo + '" class="mt-2 d-none">';
	      html += '  <textarea id="replyContent-' + c.cmntNo + '" class="form-control mb-2" rows="2" placeholder="답글을 입력하세요"></textarea>';
	      html += '  <button class="btn btn-sm btn-primary" type="button" onclick="submitReply(' + c.cmntNo + ')">등록</button>';
	      html += '</div>';
	    }
	}

    div.innerHTML = html;
    root.appendChild(div);

  });
}

	function toggleReplyForm(cmntNo){
	  const el = document.getElementById("replyForm-" + cmntNo);
	  if(el) el.classList.toggle("d-none");
	}

	async function submitComment(){
	  const boardNo = getBoardNo();
	  const ta = document.getElementById("commentContentAuth");
	  if(!ta) return;

	  const content = ta.value.trim();
	  if(!content){ alert("댓글을 입력하세요"); return; }

	  const res = await fetch(`/api/talk/${boardNo}/comments`, {
	    method: "POST",
	    headers: {"Content-Type":"application/json"},
	    body: JSON.stringify({ content })
	  });

	  if(!res.ok){ alert("댓글 등록 실패"); return; }

	  ta.value = "";
	  await loadComments();
	}

	async function submitReply(parentCmntNo){
	  const boardNo = getBoardNo();
	  const ta = document.getElementById("replyContent-" + parentCmntNo);
	  if(!ta) return;

	  const content = ta.value.trim();
	  if(!content){ alert("답글을 입력하세요"); return; }

	  const res = await fetch(`/api/talk/\${boardNo}/comments`, {
	    method: "POST",
	    headers: {"Content-Type":"application/json"},
	    body: JSON.stringify({ cmntContent : content, 
	    					  parentCmntNo : parentCmntNo
	    					 })
	  });

	  if(!res.ok){ alert("답글 등록 실패"); return; }

	  await loadComments();
	}

	function login(){
	  location.href = "/login";
	}

	document.addEventListener("DOMContentLoaded", loadComments);

const api = (...parts) => {
	  const base = (contextPath || '').replace(/\/+$/, ''); // 끝 /
	  const path = parts
	    .filter(Boolean)
	    .map(p => String(p).trim())
	    .map(p => p.replace(/^\/+|\/+$/g, '')) // 앞뒤 / 제거
	    .join('/');
	console.log(base + '/' + path);
	  return base + '/' + path;
	};

// 현재 선택된 카테고리
 let currentCategory = 'all';

// 카테고리별 표시 텍스트 매핑
const categoryMap = {
    'all': '전체',
    'free': '자유',
    'companion': '동행',
    'info': '정보',
    'qna': 'Q&A',
    'review': '후기',
    'notice': '공지'
};

// 카테고리 탭 전환
document.querySelectorAll('.board-tab').forEach(tab => {

    tab.addEventListener('click', function() {
        document.querySelectorAll('.board-tab').forEach(t => t.classList.remove('active'));
        this.classList.add('active');

        currentCategory = this.dataset.category;
        filterPosts(currentCategory);
    });
});

// 게시글 필터링
function filterPosts(category) {
    const posts = document.querySelectorAll('.post-item');

    posts.forEach(post => {
        const postCategory = post.querySelector('.post-category');
        if (!postCategory) return;

        const categoryText = postCategory.textContent.trim();

        if (category === 'all') {
            post.style.display = '';
        } else {
            // 카테고리 매칭 확인
            const matchCategory = categoryMap[category];
            if (categoryText === matchCategory || postCategory.classList.contains(category)) {
                post.style.display = '';
            } else {
                post.style.display = 'none';
            }
        }
    });

    // 검색 결과 메시지 업데이트
    updateResultMessage();
}

// 검색 기능
function searchPosts() {
    const searchType = document.getElementById('searchType').value;
    const keyword = document.getElementById('searchKeyword').value.trim().toLowerCase();

    if (!keyword) {
        filterPosts(currentCategory);
        return;
    }

    const posts = document.querySelectorAll('.post-item');
    let visibleCount = 0;

    posts.forEach(post => {
        const title = post.querySelector('.post-title a')?.textContent.toLowerCase() || '';
        const writer = post.querySelector('.post-meta span:first-child')?.textContent.toLowerCase() || '';
        const postCategory = post.querySelector('.post-category');
        const categoryText = postCategory?.textContent.trim() || '';

        // 카테고리 필터 적용
        let categoryMatch = true;
        if (currentCategory !== 'all') {
            const matchCategory = categoryMap[currentCategory];
            categoryMatch = (categoryText === matchCategory || postCategory?.classList.contains(currentCategory));
        }

        // 검색어 매칭
        let keywordMatch = false;
        switch(searchType) {
            case 'title':
                keywordMatch = title.includes(keyword);
                break;
            case 'writer':
                keywordMatch = writer.includes(keyword);
                break;
            case 'content':
            case 'all':
            default:
                keywordMatch = title.includes(keyword) || writer.includes(keyword);
                break;
        }

        if (categoryMatch && keywordMatch) {
            post.style.display = '';
            visibleCount++;
        } else {
            post.style.display = 'none';
        }
    });

    updateResultMessage(keyword, visibleCount);
}

// 검색 엔터키 처리
function handleSearchKeypress(event) {
    if (event.key === 'Enter') {
        searchPosts();
    }
}

// 검색 결과 메시지 업데이트
function updateResultMessage(keyword, count) {
    let messageEl = document.querySelector('.search-result-message');

    if (keyword) {
        if (!messageEl) {
            messageEl = document.createElement('div');
            messageEl.className = 'search-result-message';
            document.querySelector('.post-list').before(messageEl);
        }
        messageEl.innerHTML = '<i class="bi bi-search me-2"></i>"<strong>' + keyword + '</strong>" 검색 결과: ' + count + '건';
        messageEl.style.display = 'block';
    } else if (messageEl) {
        messageEl.style.display = 'none';
    }
}

// 글쓰기
function writePost() {
    const isLoggedIn = <sec:authorize access="isAuthenticated()">true</sec:authorize>
    					<sec:authorize access="isAnonymous()">false</sec:authorize>;

    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    window.location.href = '${pageContext.request.contextPath}/community/talk/write';
}


// 현재 보고 있는 게시글 ID
let currentPostId = null;
let isPostLiked = false;
let isPostBookmarked = false;

// 게시글 상세 열기
function openPostDetail(postId) {
    const post = postsData[postId];
    if (!post) {
        showToast('게시글을 찾을 수 없습니다.', 'error');
        return;
    }

    currentPostId = postId;
    isPostLiked = false;
    isPostBookmarked = false;

    // 카테고리 설정
    const categoryEl = document.getElementById('postDetailCategory');
    categoryEl.textContent = post.categoryLabel;
    categoryEl.className = 'post-detail-category ' + post.category;

    // 게시글 정보 설정
    document.getElementById('postDetailTitle').textContent = post.title;
    document.getElementById('postAuthorName').textContent = post.author;
    document.getElementById('postAuthorAvatar').src = post.authorAvatar;
    document.getElementById('postDate').textContent = post.date;
    document.getElementById('postViews').textContent = post.views.toLocaleString();
    document.getElementById('postCommentCount').textContent = post.comments.length;
    document.getElementById('postLikes').textContent = post.likes;
    document.getElementById('postDetailContent').innerHTML = post.content;

    // 태그 렌더링
    const tagsContainer = document.getElementById('postDetailTags');
    if (post.tags && post.tags.length > 0) {
        let tagsHtml = '<i class="bi bi-tags me-2"></i>';
        post.tags.forEach(function(tag) {
            tagsHtml += '<span class="post-tag">#' + tag + '</span>';
        });
        tagsContainer.innerHTML = tagsHtml;
        tagsContainer.style.display = 'flex';
    } else {
        tagsContainer.style.display = 'none';
    }

    // 댓글 렌더링
    renderComments(post.comments);

    // 좋아요/북마크 아이콘 초기화
    document.getElementById('postLikeIcon').className = 'bi bi-heart';
    document.getElementById('postBookmarkIcon').className = 'bi bi-bookmark';

    // 모달 열기
    document.getElementById('postDetailOverlay').classList.add('active');
    document.body.style.overflow = 'hidden';
}

// 게시글 상세 닫기
function closePostDetail() {
    document.getElementById('postDetailOverlay').classList.remove('active');
    document.body.style.overflow = '';
    currentPostId = null;
}

// 댓글 렌더링

function renderComments(comments) {
    const listEl = document.getElementById('commentsList');
    document.getElementById('commentsCount').textContent = comments.length;

    if (comments.length === 0) {
        listEl.innerHTML = '<p style="text-align: center; color: #999; padding: 20px 0;">첫 번째 댓글을 작성해보세요!</p>';
        return;
    }

    let html = '';
    comments.forEach(comment => {
        html += '<div class="comment-item" data-comment-id="' + comment.id + '">' +
            '<img src="' + comment.avatar + '" alt="프로필" class="comment-avatar">' +
            '<div class="comment-body">' +
                '<div class="comment-header">' +
                    '<span class="comment-author">' + comment.author + '</span>' +
                    '<span class="comment-date">' + comment.date + '</span>' +
                '</div>' +
                '<p class="comment-text">' + comment.text + '</p>' +
                '<div class="comment-actions">' +
                    '<button class="comment-action"><i class="bi bi-heart"></i> 좋아요</button>' +
                    '<button class="comment-action"><i class="bi bi-reply"></i> 답글</button>' +
                    (currentUser.isLoggedIn && currentUser.userType !== 'BUSINESS' ?
                        '<button class="comment-action report" onclick="reportComment(\'' + comment.id + '\', \'' + escapeHtml(comment.text) + '\')"><i class="bi bi-flag"></i> 신고</button>' : '') +
                '</div>' +
            '</div>' +
        '</div>';
    });

    listEl.innerHTML = html;
}

// 좋아요 토글
function togglePostLike(ele) {
	let status = false;
    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    isPostLiked = !isPostLiked;
    const icon = document.getElementById('postLikeIcon');
    const likesEl = document.getElementById('postLikes');
    let likes = parseInt(likesEl.textContent);

    // 현재 좋아요의 상태(눌려있는지, 꺼져있는지)
    let currentStatus = ele.dataset.status;
    console.log("현재 좋아요 눌린 상태 : " + currentStatus);
    if (currentStatus == "N") {
        icon.className = 'bi bi-heart-fill';
        icon.style.color = '#ef4444';
        likesEl.textContent = likes + 1;
        showToast('좋아요를 눌렀습니다.', 'success');
        icon.closest('.post-action-btn').classList.add("active");
        status = true;
    } else {
        icon.className = 'bi bi-heart';
        icon.style.color = '';
        likesEl.textContent = likes - 1;
        icon.closest('.post-action-btn').classList.remove("active");
        status = false;
    }

    // 버튼 액티브 상태 토글
    // icon.closest('.post-action-btn').classList.toggle('active', isPostLiked);

    console.log("좋아요 클릭 상태 : " + status);
    // 서버로 전송해서 좋아요 기능 요청
    axios.post(`/community/talk/${boardVO.boardNo}/like`, {
    	status: status,
    	likesCatCd: 'talk',
    	likesKey: ${boardVO.boardNo}
    })
    .then(res => {
    	console.log("좋아요 처리 완 : " + res.data);
    }).catch(err => {
    	console.log("error 발생 : ", error);
    });
    //const prodData = response.data;

}


// 게시글 공유
function sharePost(){
  const boardNo = document.getElementById("commentSection")?.dataset.boardNo;

  if(!boardNo){
    alert("boardNo 없음");
    return;
  }

  const url = location.origin + location.pathname + "?boardNo=" + encodeURIComponent(boardNo);

  if (navigator.share) {
    navigator.share({ title: "여행톡", url: url }).catch(()=>{});
  } else {
    navigator.clipboard.writeText(url);
    alert("링크 복사됨!");
  }
}



// 댓글 작성
function modalSubmitComment() {
    const input = document.getElementById('commentInput');
    const text = input.value.trim();

    if (!text) {
        showToast('댓글 내용을 입력해주세요.', 'warning');
        return;
    }

    if (!currentUser.isLoggedIn) {
        showToast('로그인이 필요합니다.', 'warning');
        return;
    }




    // 새 댓글 추가 (데모용)
    const post = postsData[currentPostId];
    if (post) {
        const newComment = {
            id: post.comments.length + 1,
            author: currentUser.name || '사용자',
            avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80',
            date: new Date().toLocaleString('ko-KR', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            }).replace(/\./g, '.').replace(',', ''),
            text: text
        };

        post.comments.push(newComment);
        renderComments(post.comments);

        // 댓글 수 업데이트
        document.getElementById('postCommentCount').textContent = post.comments.length;

        // 입력 초기화
        input.value = '';
        input.style.height = 'auto';

        showToast('댓글이 등록되었습니다.', 'success');
    }
}

// 텍스트영역 자동 높이 조절
function autoResizeTextarea(el) {
    el.style.height = 'auto';
    el.style.height = Math.min(el.scrollHeight, 100) + 'px';
}

// 토스트 메시지 (기존 함수가 없는 경우)
if (typeof showToast !== 'function') {
    function showToast(message, type) {
        // 기존 토스트 제거
        const existingToast = document.querySelector('.toast-message');
        if (existingToast) existingToast.remove();

        const toast = document.createElement('div');
        toast.className = 'toast-message toast-' + (type || 'info');
        toast.innerHTML = '<i class="bi bi-' + (type === 'success' ? 'check-circle' : type === 'error' ? 'x-circle' : type === 'warning' ? 'exclamation-circle' : 'info-circle') + '"></i> ' + message;
        toast.style.cssText = 'position: fixed; bottom: 100px; left: 50%; transform: translateX(-50%); padding: 12px 24px; border-radius: 8px; background: #333; color: white; font-size: 14px; z-index: 9999; display: flex; align-items: center; gap: 8px; animation: toastIn 0.3s ease;';

        if (type === 'success') toast.style.background = '#10b981';
        else if (type === 'error') toast.style.background = '#ef4444';
        else if (type === 'warning') toast.style.background = '#f59e0b';

        document.body.appendChild(toast);

        setTimeout(() => {
            toast.style.animation = 'toastOut 0.3s ease forwards';
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }
}

// ==================== 신고 기능 ====================
// 댓글 신고
function reportComment(commentId, commentText) {

    openReportModal('comment', commentId, commentText);
}

// 현재 채팅방 신고
function reportCurrentChatroom() {
    if (!currentChatRoom) return;
    openReportModal('chatroom', currentChatRoom.id, currentChatRoom.name);
}

// 토스트 애니메이션 스타일 추가
if (!document.getElementById('toastStyles')) {
    const style = document.createElement('style');
    style.id = 'toastStyles';
    style.textContent = '@keyframes toastIn { from { opacity: 0; transform: translateX(-50%) translateY(20px); } to { opacity: 1; transform: translateX(-50%) translateY(0); } } @keyframes toastOut { from { opacity: 1; transform: translateX(-50%) translateY(0); } to { opacity: 0; transform: translateX(-50%) translateY(20px); } }';
    document.head.appendChild(style);
}

</script>
		<%@ include file="../common/footer.jsp"%>