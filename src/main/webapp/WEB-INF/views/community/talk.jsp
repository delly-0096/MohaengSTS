<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<c:set var="pageTitle" value="여행톡" />
<c:set var="pageCss" value="community" />

<%@ include file="../common/header.jsp" %>
<body data-logged-in="<sec:authorize access='isAuthenticated()'>true</sec:authorize><sec:authorize access='isAnonymous()'>false</sec:authorize>">
<div class="community-page">
    <div class="container">
        <!-- 헤더 -->
        <div class="community-header">
            <h1><i class="bi bi-chat-dots me-3"></i>여행톡</h1>
            <p>여행자들과 자유롭게 소통하고 정보를 나눠보세요</p>
        </div>
        <!-- boardVO있을때 상세출력 
			model.addAttribute("boardVO",boardVO);
		-->
				<c:if test="${not empty boardVO}">
				  <div class="card mb-4">
				    <div class="card-body">
				      <div class="d-flex justify-content-between align-items-center mb-2">
				        <span class="badge bg-primary">
				          ${boardVO.boardCtgryCd}
				        </span>
				
				        <a class="btn btn-sm btn-outline-secondary"
				           href="${pageContext.request.contextPath}/community/talk">
				          목록
				        </a>
				      </div>
				      
				
				      <h3 class="mb-2">${boardVO.boardTitle}</h3>
				
				      <div class="text-muted mb-3">
				          작성자: ${boardVO.writerNickname} <small>(${boardVO.writerId})</small>
				          작성일: ${boardVO.regDt}
				          조회수: ${boardVO.viewCnt}
				      </div>
				
				      <hr/>
				
				      <div style="white-space: pre-wrap;">
				        ${boardVO.boardContent}
				      </div>
				    </div>
				  </div>
				</c:if>
    </div>     
</div>
		
								
<!-- 게시글 상세 모달 -->
<div class="post-detail-overlay" id="postDetailOverlay" onclick="closePostDetail()">
    <div class="post-detail-modal" onclick="event.stopPropagation()">
        <div class="post-detail-header">
            <span class="post-detail-category" id="postDetailCategory">카테고리</span>
            <button class="post-detail-close" onclick="closePostDetail()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="post-detail-body">
            <h2 class="post-detail-title" id="postDetailTitle">게시글 제목</h2>
            <div class="post-detail-meta">
            <a href="${pageContext.request.contextPath}/community/talk?boardNo=${board.boardNo}">
			                ${board.boardTitle}
			              </a>
                <div class="post-author">
                    <img src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80" alt="프로필" id="postAuthorAvatar">
                    <div class="author-info">
                        <span class="author-name" id="postAuthorName">작성자</span>
                        <span class="post-date" id="postDate">2024.03.15</span>
                    </div>
                </div>
                <div class="post-detail-stats">
                    <span><i class="bi bi-eye"></i> <span id="postViews">0</span></span>
                    <span><i class="bi bi-chat"></i> <span id="postCommentCount">0</span></span>
                    <span><i class="bi bi-heart"></i> <span id="postLikes">0</span></span>
                </div>
            </div>
            <div class="post-detail-content" id="postDetailContent">
                <!-- 게시글 본문 -->
            </div>
            <div class="post-detail-tags" id="postDetailTags" style="display: none;">
                <!-- 태그 목록 -->
            </div>
            <div class="post-detail-actions">
                <button class="post-action-btn" onclick="togglePostLike()">
                    <i class="bi bi-heart" id="postLikeIcon"></i>
                    <span>좋아요</span>
                </button>
                <button class="post-action-btn" onclick="togglePostBookmark()">
                    <i class="bi bi-bookmark" id="postBookmarkIcon"></i>
                    <span>북마크</span>
                </button>
                <button class="post-action-btn" onclick="sharePost()">
                    <i class="bi bi-share"></i>
                    <span>공유</span>
                </button>
                <sec:authorize access="hasRole('MEMBER')">
                <button class="post-action-btn report" onclick="reportCurrentPost()">
                    <i class="bi bi-flag"></i>
                    <span>신고</span>
                </button>
                </sec:authorize>
            </div>
        </div>
        <div class="post-comments-section">
            <h4 class="comments-title"><i class="bi bi-chat-dots me-2"></i>댓글 <span id="commentsCount">0</span>개</h4>
            <div class="comments-list" id="commentsList">
                <!-- 댓글 목록 -->
            </div>
            <sec:authorize access="isAuthenticated()">
            <div class="comment-write">
                <img src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80" alt="내 프로필" class="comment-avatar">
                <div class="comment-input-wrapper">
                    <textarea class="comment-input" id="commentInput" placeholder="댓글을 작성해주세요..." rows="1" oninput="autoResizeTextarea(this)"></textarea>
                    <button class="comment-submit-btn" onclick="submitComment()">
                        <i class="bi bi-send-fill"></i>
                    </button>
                </div>
            </div>
            </sec:authorize>
            <sec:authorize access="isAnonymous()">
            <div class="comment-login-notice">
                <p><i class="bi bi-info-circle me-2"></i>댓글을 작성하려면 <a href="${pageContext.request.contextPath}/member/login">로그인</a>이 필요합니다.</p>
            </div>
            </sec:authorize>
        </div>
    </div>
</div>


<style>
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
    background: #10b981;
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

@media (max-width: 768px) {
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
<!-- Security 변수 추출  -->
<sec:authentication property="principal" var="principal" />
<sec:authorize access="isAuthenticated()">
    <%-- 시큐리티의 principal 객체에서 직접 변수 추출 --%>
    <c:set var="myId" value="${principal.member.memId}" />
    <c:set var="myName" value="${principal.member.memName}" />
</sec:authorize>
<script>

const api = (path) => contextPath + (path.startsWith('/') ? path : '/' + path);

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
// ==================== 파일/이미지 업로드 ====================

// 이미지 업로드 열기
function openImageUpload() {
    if (!currentChatRoom) {
        showToast('먼저 채팅방에 입장해주세요.', 'warning');
        return;
    }
    document.getElementById('imageUploadInput').click();
}

// 파일 업로드 열기
function openFileUpload() {
    if (!currentChatRoom) {
        showToast('먼저 채팅방에 입장해주세요.', 'warning');
        return;
    }
    document.getElementById('fileUploadInput').click();
}

// 이미지 업로드 처리
function handleImageUpload(event) {
    const file = event.target.files[0];
    if (!file) return;

    // 파일 타입 확인
    if (!file.type.startsWith('image/')) {
        showToast('이미지 파일만 업로드 가능합니다.', 'warning');
        return;
    }

    // 파일 크기 확인 (5MB 제한)
    if (file.size > 5 * 1024 * 1024) {
        showToast('이미지는 5MB 이하만 업로드 가능합니다.', 'warning');
        return;
    }

    // 이미지 미리보기 생성
    const reader = new FileReader();
    reader.onload = function(e) {
        const imageUrl = e.target.result;
        const time = new Date().toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
        addImageMessage(currentUser.name, imageUrl, time, true);
    };
    reader.readAsDataURL(file);

    // 입력 초기화
    event.target.value = '';
    showToast('이미지가 전송되었습니다.', 'success');
}

// 파일 업로드 처리
function handleFileUpload(event) {
    const file = event.target.files[0];
    if (!file) return;

    // 파일 크기 확인 (10MB 제한)
    if (file.size > 10 * 1024 * 1024) {
        showToast('파일은 10MB 이하만 업로드 가능합니다.', 'warning');
        return;
    }

    const time = new Date().toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
    addFileMessage(currentUser.name, file.name, file.size, time, true);

    // 입력 초기화
    event.target.value = '';
    showToast('파일이 전송되었습니다.', 'success');
}

// 이미지 메시지 추가
function addImageMessage(sender, imageUrl, time, isMine) {
    const messagesEl = document.getElementById('chatMessages');

    // 환영 메시지 제거
    const welcomeMsg = messagesEl.querySelector('.chat-welcome-message');
    if (welcomeMsg) welcomeMsg.remove();

    const initial = sender.charAt(0).toUpperCase();

    const messageHtml =
        '<div class="chat-message' + (isMine ? ' mine' : '') + '">' +
            '<div class="chat-message-avatar">' + initial + '</div>' +
            '<div class="chat-message-content">' +
                '<span class="chat-message-sender">' + sender + '</span>' +
                '<img src="' + imageUrl + '" class="chat-message-image" onclick="previewImage(\'' + imageUrl + '\')" alt="이미지">' +
                '<span class="chat-message-time">' + time + '</span>' +
            '</div>' +
        '</div>';

    messagesEl.insertAdjacentHTML('beforeend', messageHtml);
    messagesEl.scrollTop = messagesEl.scrollHeight;
}

// 파일 메시지 추가
function addFileMessage(sender, fileName, fileSize, time, isMine) {
    const messagesEl = document.getElementById('chatMessages');

    // 환영 메시지 제거
    const welcomeMsg = messagesEl.querySelector('.chat-welcome-message');
    if (welcomeMsg) welcomeMsg.remove();

    const initial = sender.charAt(0).toUpperCase();
    const fileSizeText = formatFileSize(fileSize);
    const fileIcon = getFileIcon(fileName);

    const messageHtml =
        '<div class="chat-message' + (isMine ? ' mine' : '') + '">' +
            '<div class="chat-message-avatar">' + initial + '</div>' +
            '<div class="chat-message-content">' +
                '<span class="chat-message-sender">' + sender + '</span>' +
                '<div class="chat-message-file" onclick="downloadFile(\'' + fileName + '\')">' +
                    '<div class="chat-file-icon"><i class="bi ' + fileIcon + '"></i></div>' +
                    '<div class="chat-file-info">' +
                        '<span class="chat-file-name">' + escapeHtml(fileName) + '</span>' +
                        '<span class="chat-file-size">' + fileSizeText + '</span>' +
                    '</div>' +
                '</div>' +
                '<span class="chat-message-time">' + time + '</span>' +
            '</div>' +
        '</div>';

    messagesEl.insertAdjacentHTML('beforeend', messageHtml);
    messagesEl.scrollTop = messagesEl.scrollHeight;
}

// 파일 크기 포맷
function formatFileSize(bytes) {
    if (bytes < 1024) return bytes + ' B';
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
    return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
}

// 파일 아이콘 결정
function getFileIcon(fileName) {
    const ext = fileName.split('.').pop().toLowerCase();
    const iconMap = {
        'pdf': 'bi-file-earmark-pdf',
        'doc': 'bi-file-earmark-word', 'docx': 'bi-file-earmark-word',
        'xls': 'bi-file-earmark-excel', 'xlsx': 'bi-file-earmark-excel',
        'ppt': 'bi-file-earmark-ppt', 'pptx': 'bi-file-earmark-ppt',
        'zip': 'bi-file-earmark-zip', 'rar': 'bi-file-earmark-zip', '7z': 'bi-file-earmark-zip',
        'txt': 'bi-file-earmark-text',
        'mp3': 'bi-file-earmark-music', 'wav': 'bi-file-earmark-music',
        'mp4': 'bi-file-earmark-play', 'avi': 'bi-file-earmark-play', 'mov': 'bi-file-earmark-play'
    };
    return iconMap[ext] || 'bi-file-earmark';
}

// 이미지 미리보기
function previewImage(imageUrl) {
    // 기존 미리보기 제거
    let overlay = document.getElementById('imagePreviewOverlay');
    if (!overlay) {
        overlay = document.createElement('div');
        overlay.id = 'imagePreviewOverlay';
        overlay.className = 'image-preview-overlay';
        overlay.onclick = closeImagePreview;
        overlay.innerHTML = '<button class="image-preview-close"><i class="bi bi-x-lg"></i></button><img src="" alt="미리보기">';
        document.body.appendChild(overlay);
    }

    overlay.querySelector('img').src = imageUrl;
    overlay.classList.add('active');
    document.body.style.overflow = 'hidden';
}

// 이미지 미리보기 닫기
function closeImagePreview() {
    const overlay = document.getElementById('imagePreviewOverlay');
    if (overlay) {
        overlay.classList.remove('active');
        document.body.style.overflow = '';
    }
}

// 파일 다운로드 (데모)
function downloadFile(fileName) {
    showToast('"' + fileName + '" 다운로드를 시작합니다.', 'info');
    // 실제로는 서버에서 파일을 다운로드하는 로직 구현
}

// ESC 키로 모달 닫기
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        if (document.getElementById('postDetailOverlay').classList.contains('active')) {
            closePostDetail();
        } else if (document.getElementById('chatRoomModal').classList.contains('active')) {
            closeChatRoomList();
        }
    }
});

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
function togglePostLike() {
    if (!currentUser.isLoggedIn) {
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

    if (isPostLiked) {
        icon.className = 'bi bi-heart-fill';
        icon.style.color = '#ef4444';
        likesEl.textContent = likes + 1;
        showToast('좋아요를 눌렀습니다.', 'success');
    } else {
        icon.className = 'bi bi-heart';
        icon.style.color = '';
        likesEl.textContent = likes - 1;
    }

    // 버튼 액티브 상태 토글
    icon.closest('.post-action-btn').classList.toggle('active', isPostLiked);
}

// 북마크 토글
function togglePostBookmark() {
    if (!currentUser.isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    isPostBookmarked = !isPostBookmarked;
    const icon = document.getElementById('postBookmarkIcon');

    if (isPostBookmarked) {
        icon.className = 'bi bi-bookmark-fill';
        showToast('게시글을 북마크했습니다.', 'success');
    } else {
        icon.className = 'bi bi-bookmark';
        showToast('북마크를 해제했습니다.', 'info');
    }

    // 버튼 액티브 상태 토글
    icon.closest('.post-action-btn').classList.toggle('active', isPostBookmarked);
}

// 게시글 공유
function sharePost() {
    const post = postsData[currentPostId];
    if (!post) return;

    // 현재 URL 복사
    const url = window.location.origin + window.location.pathname + '?postId=' + currentPostId;

    if (navigator.share) {
        // 모바일 공유 기능 사용
        navigator.share({
            title: post.title,
            text: post.title + ' - 모행 여행톡',
            url: url
        }).catch(() => {});
    } else {
        // 클립보드에 복사
        navigator.clipboard.writeText(url).then(() => {
            showToast('링크가 복사되었습니다.', 'success');
        }).catch(() => {
            showToast('링크 복사에 실패했습니다.', 'error');
        });
    }
}

// 댓글 작성
function submitComment() {
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

// 현재 게시글 신고
function reportCurrentPost() {
    if (!currentPostId) return;
    var post = postsData[currentPostId];
    if (!post) return;
    openReportModal('post', currentPostId, post.title);
}

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
<%@ include file="../common/footer.jsp" %>
