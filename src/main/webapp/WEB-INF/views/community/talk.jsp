<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

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
        <!-- 게시판 -->
        <div class="board-container">
            <!-- 카테고리 탭 -->
            <div class="board-tabs">
                <button class="board-tab active" data-category="all">전체</button>
                <button class="board-tab" data-category="notice">공지사항</button>
                <button class="board-tab" data-category="free">자유게시판</button>
                <button class="board-tab" data-category="companion">동행 구하기</button>
                <button class="board-tab" data-category="info">정보 공유</button>
                <button class="board-tab" data-category="qna">여행 Q&A</button>
                <button class="board-tab" data-category="review">후기</button>
            </div>

            <!-- 게시판 헤더 -->
            <div class="board-header">
                <div class="board-search">
                    <select class="form-select search-type" id="searchType">
                        <option value="all">전체</option>
                        <option value="title">제목</option>
                        <option value="content">내용</option>
                        <option value="writer">작성자</option>
                    </select>
                    <input type="text" id="searchKeyword" placeholder="검색어를 입력하세요" onkeypress="handleSearchKeypress(event)">
                    <button class="btn btn-primary btn-sm" onclick="searchPosts()">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
                <sec:authorize access="hasRole('MEMBER')">
                <div class="board-actions">
                    <button class="btn btn-outline-primary" onclick="openChatRoomList()">
                        <i class="bi bi-chat-heart me-2"></i>지금모행
                    </button>
                    <button class="btn btn-primary" onclick="writePost()">
                        <i class="bi bi-pencil me-2"></i>글쓰기
                    </button>
                </div>
                </sec:authorize>
                <sec:authorize access="hasRole('BUSINESS')">
                <div class="board-actions">
                    <span class="business-notice">
                        <i class="bi bi-info-circle me-1"></i>기업회원은 여행톡 작성이 제한됩니다
                    </span>
                </div>
                </sec:authorize>
            </div>

            <!-- 게시글 리스트 -->
            <ul class="post-list">
            	<c:set value="${pagingVO.dataList }" var="boardList"/>
            	<c:choose>
            		<c:when test="${empty boardList }">
							<li class="post-item" data-post-id="1" onclick="openPostDetail(1)">
								<div class="post-content">
									조회하신 게시글이 존재하지 않습니다.
								</div>
							</li>
						</c:when>
						<c:otherwise>
							<c:forEach items="${boardList }" var="board">
								<c:set value="" var="type"/>
								<c:set value="" var="style"/>
								<c:choose>
									<c:when test="${board.boardCtgryCd eq 'notice' }">
										<c:set value="공지" var="type"/>
										<c:set value="notice" var="style"/>	
									</c:when>
									<c:when test="${board.boardCtgryCd eq 'talk' }">
										<c:set value="자유" var="type"/>	
									</c:when>
									<c:when test="${board.boardCtgryCd eq 'companion' }">
										<c:set value="동행" var="type"/>
										<c:set value="companion" var="style"/>
									</c:when>
									<c:when test="${board.boardCtgryCd eq 'info' }">
										<c:set value="정보" var="type"/>
										<c:set value="info" var="style"/>	
									</c:when>
									<c:when test="${board.boardCtgryCd eq 'qna' }">
										<c:set value="Q&A" var="type"/>	
									</c:when>
									<c:when test="${board.boardCtgryCd eq 'review' }">
										<c:set value="후기" var="type"/>	
									</c:when>
								</c:choose>
								<li class="post-item" data-post-id="1" onclick="openPostDetail(1)">
				                    <span class="post-category ${style }">${type }</span>
				                    <div class="post-content">
				                        <h4 class="post-title">
				                            <span>${board.boardTitle }</span>
				                        </h4>
				                        <div class="post-meta">
				                            <span class="writer">
												  ${board.writerNickname}
												  <small>(${board.writerId})</small>
											</span>
				                            <span>${board.regDt }</span>
				                        </div>
				                    </div>
				                    <div class="post-stats">
				                        <span><i class="bi bi-eye"></i> ${board.viewCnt }</span>
				                        <span><i class="bi bi-chat"></i> 0</span>
				                    </div>
				                </li>			
							</c:forEach>
						</c:otherwise>
            	</c:choose>
            </ul>

            <!-- 페이지네이션 -->
            <div class="pagination-container">
                <nav>
                    ${pagingVO.pagingHTML }
                </nav>
            </div>
        </div>
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

<!-- 채팅방 목록 모달 -->
<div class="chat-modal-overlay" id="chatRoomModal" onclick="closeChatRoomModal(event)">
    <div class="chat-modal" onclick="event.stopPropagation()">
        <div class="chat-modal-header">
            <h3><i class="bi bi-chat-heart me-2"></i>지금모행</h3>
            <button class="chat-modal-close" onclick="closeChatRoomList()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="chat-modal-body">
            <!-- 채팅방 생성 -->
            <div class="chat-create-section">
                <button class="btn btn-primary w-100" onclick="openCreateRoomForm()">
                    <i class="bi bi-plus-circle me-2"></i>새 채팅방 만들기
                </button>
                <div class="create-room-form" id="createRoomForm" style="display: none;">
                    <input type="text" class="form-control" id="newRoomName" placeholder="채팅방 이름을 입력하세요" maxlength="30">
                    <select class="form-control form-select" id="newRoomCategory">
                        <option value="FREE">자유 채팅</option>
                        <option value="COMPANION">동행 모집</option>
                        <option value="REGION">지역별 채팅</option>
                        <option value="THEME">테마별 채팅</option>
                    </select>
                    <input type="number" class="form-control" id="newRoomMaxUsers" placeholder="최대 인원 (기본 50명)" min="2" max="100" value="50">
                    <div class="create-room-actions">
                        <button class="btn btn-outline" onclick="cancelCreateRoom()">취소</button>
                        <button class="btn btn-primary" onclick="createChatRoom()">만들기</button>
                    </div>
                </div>
            </div>

            <!-- 채팅방 필터 -->
            <div class="chat-room-filter">
                <button class="chat-filter-btn active" data-filter="all">전체</button>
                <button class="chat-filter-btn" data-filter="free">자유</button>
                <button class="chat-filter-btn" data-filter="companion">동행</button>
                <button class="chat-filter-btn" data-filter="local">지역</button>
                <button class="chat-filter-btn" data-filter="theme">테마</button>
            </div>

            <!-- 채팅방 목록 -->
            <div class="chat-room-list" id="chatRoomList">
                <!-- 채팅방 아이템들이 여기에 동적으로 추가됨 -->
            </div>
        </div>
    </div>
</div>

<!-- 채팅 윈도우 -->
<div class="chat-window" id="chatWindow">
    <div class="chat-window-header">
        <div class="chat-room-info">
            <span class="chat-room-category-badge" id="chatRoomBadge">자유</span>
            <h4 id="chatRoomTitle">채팅방 이름</h4>
            <span class="chat-room-users"><i class="bi bi-people-fill"></i> <span id="chatUserCount">0</span>명</span>
        </div>
        <div class="chat-window-actions">
            <button class="chat-action-btn" onclick="toggleChatUserList()" title="참여자 목록">
                <i class="bi bi-people"></i>
            </button>
            <sec:authorize access="hasRole('MEMBER')">
            <button class="chat-action-btn" onclick="reportCurrentChatroom()" title="채팅방 신고">
                <i class="bi bi-flag"></i>
            </button>
            </sec:authorize>
            <button class="chat-action-btn" onclick="minimizeChat()" title="최소화">
                <i class="bi bi-dash-lg"></i>
            </button>
            <button class="chat-action-btn close" onclick="leaveChat()" title="나가기">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
    </div>

    <!-- 참여자 목록 사이드 패널 -->
    <div class="chat-user-panel" id="chatUserPanel">
        <div class="chat-user-panel-header">
            <h5>참여자 목록</h5>
            <button onclick="toggleChatUserList()"><i class="bi bi-x"></i></button>
        </div>
        <div class="chat-user-list" id="chatUserList">
            <!-- 참여자 목록이 여기에 표시됨 -->
        </div>
    </div>

    <div class="chat-messages" id="chatMessages">
        <!-- 메시지들이 여기에 표시됨 -->
        <div class="chat-welcome-message">
            <i class="bi bi-chat-heart"></i>
            <p>채팅방에 오신 것을 환영합니다!</p>
            <span>서로 존중하며 즐거운 대화를 나눠보세요.</span>
        </div>
    </div>

    <div class="chat-input-area">
        <div class="chat-attach-buttons">
            <button class="chat-attach-btn" onclick="openImageUpload()" title="사진 보내기">
                <i class="bi bi-image"></i>
            </button>
            <button class="chat-attach-btn" onclick="openFileUpload()" title="파일 보내기">
                <i class="bi bi-paperclip"></i>
            </button>
        </div>
        <input type="text" id="chatInput" placeholder="메시지를 입력하세요..." maxlength="500"
               onkeydown="handleChatKeydown(event)">
        <button class="chat-send-btn" onclick="sendMessage()">
            <i class="bi bi-send-fill"></i>
        </button>
    </div>
    <!-- 숨겨진 파일 입력 -->
    <input type="file" id="imageUploadInput" accept="image/*" style="display: none;" onchange="handleImageUpload(event)">
    <input type="file" id="fileUploadInput" style="display: none;" onchange="handleFileUpload(event)">
</div>

<!-- 최소화된 채팅 버튼 -->
<div class="chat-minimized" id="chatMinimized" onclick="maximizeChat()">
    <i class="bi bi-chat-heart-fill"></i>
    <span id="chatMinimizedTitle">채팅방</span>
    <span class="chat-unread-badge" id="chatUnreadBadge">0</span>
</div>

<style>
/* ==================== 채팅 버튼 영역 ==================== */
.board-actions {
    display: flex;
    gap: 10px;
    align-items: center;
}

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

.btn-outline-primary {
    border: 2px solid var(--primary-color);
    color: var(--primary-color);
    background: transparent;
    font-weight: 600;
}

.btn-outline-primary:hover {
    background: var(--primary-color);
    color: white;
}

/* ==================== 채팅방 목록 모달 ==================== */
.chat-modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    display: none;
    justify-content: center;
    align-items: center;
    z-index: 2000;
    padding: 20px;
}

.chat-modal-overlay.active {
    display: flex;
}

.chat-modal {
    background: white;
    border-radius: 20px;
    width: 100%;
    max-width: 500px;
    max-height: 80vh;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    animation: modalSlideIn 0.3s ease-out;
}

@keyframes modalSlideIn {
    from {
        opacity: 0;
        transform: translateY(-20px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

.chat-modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 24px;
    border-bottom: 1px solid #eee;
    background: linear-gradient(135deg, var(--primary-color) 0%, #667eea 100%);
    color: white;
}

.chat-modal-header h3 {
    margin: 0;
    font-size: 18px;
    font-weight: 600;
}

.chat-modal-close {
    background: rgba(255,255,255,0.2);
    border: none;
    color: white;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    cursor: pointer;
    transition: background 0.2s;
}

.chat-modal-close:hover {
    background: rgba(255,255,255,0.3);
}

.chat-modal-body {
    padding: 20px;
    overflow-y: auto;
    flex: 1;
}

/* 채팅방 생성 */
.chat-create-section {
    margin-bottom: 20px;
}

.create-room-form {
    margin-top: 12px;
    padding: 16px;
    background: #f8fafc;
    border-radius: 12px;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.create-room-actions {
    display: flex;
    gap: 10px;
    margin-top: 8px;
}

.create-room-actions .btn {
    flex: 1;
}

/* 채팅방 필터 */
.chat-room-filter {
    display: flex;
    gap: 8px;
    margin-bottom: 16px;
    flex-wrap: wrap;
}

.chat-filter-btn {
    padding: 6px 14px;
    border: 1px solid #ddd;
    border-radius: 20px;
    background: white;
    font-size: 13px;
    cursor: pointer;
    transition: all 0.2s;
}

.chat-filter-btn:hover {
    border-color: var(--primary-color);
    color: var(--primary-color);
}

.chat-filter-btn.active {
    background: var(--primary-color);
    color: white;
    border-color: var(--primary-color);
}

/* 채팅방 목록 */
.chat-room-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.chat-room-item {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 16px;
    background: #f8fafc;
    border-radius: 14px;
    cursor: pointer;
    transition: all 0.2s;
    border: 2px solid transparent;
}

.chat-room-item:hover {
    background: #f0f4ff;
    border-color: var(--primary-color);
    transform: translateX(4px);
}

.chat-room-icon {
    width: 50px;
    height: 50px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    color: white;
    flex-shrink: 0;
}

.chat-room-icon.free { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
.chat-room-icon.companion { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
.chat-room-icon.local { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
.chat-room-icon.theme { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }

.chat-room-details {
    flex: 1;
    min-width: 0;
}

.chat-room-name {
    font-weight: 600;
    font-size: 15px;
    margin-bottom: 4px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.chat-room-name .badge {
    font-size: 10px;
    padding: 2px 6px;
}

.chat-room-meta {
    display: flex;
    gap: 12px;
    font-size: 12px;
    color: #666;
}

.chat-room-meta span {
    display: flex;
    align-items: center;
    gap: 4px;
}

.chat-room-users-count {
    display: flex;
    align-items: center;
    gap: 6px;
    color: var(--primary-color);
    font-weight: 600;
    font-size: 14px;
}

.chat-room-users-count i {
    font-size: 16px;
}

/* 채팅방 없음 */
.no-chat-rooms {
    text-align: center;
    padding: 40px 20px;
    color: #999;
}

.no-chat-rooms i {
    font-size: 48px;
    margin-bottom: 16px;
    display: block;
}

/* ==================== 채팅 윈도우 ==================== */
.chat-window {
    position: fixed;
    bottom: 20px;
    right: 100px;
    width: 380px;
    height: 520px;
    background: white;
    border-radius: 20px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
    display: none;
    flex-direction: column;
    z-index: 1999;
    overflow: hidden;
    animation: chatWindowOpen 0.3s ease-out;
}

.chat-window.active {
    display: flex;
}

@keyframes chatWindowOpen {
    from {
        opacity: 0;
        transform: translateY(20px) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

.chat-window-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 16px;
    background: linear-gradient(135deg, var(--primary-color) 0%, #667eea 100%);
    color: white;
}

.chat-room-info {
    display: flex;
    align-items: center;
    gap: 10px;
    flex: 1;
    min-width: 0;
}

.chat-room-category-badge {
    padding: 3px 8px;
    background: rgba(255,255,255,0.2);
    border-radius: 10px;
    font-size: 11px;
    font-weight: 600;
}

.chat-room-info h4 {
    margin: 0;
    font-size: 15px;
    font-weight: 600;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.chat-room-users {
    font-size: 12px;
    opacity: 0.9;
    display: flex;
    align-items: center;
    gap: 4px;
}

.chat-window-actions {
    display: flex;
    gap: 6px;
}

.chat-action-btn {
    background: rgba(255,255,255,0.2);
    border: none;
    color: white;
    width: 32px;
    height: 32px;
    border-radius: 8px;
    cursor: pointer;
    transition: background 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
}

.chat-action-btn:hover {
    background: rgba(255,255,255,0.3);
}

.chat-action-btn.close:hover {
    background: #ef4444;
}

/* 참여자 패널 */
.chat-user-panel {
    position: absolute;
    top: 56px;
    right: 0;
    width: 200px;
    height: calc(100% - 56px - 60px);
    background: white;
    border-left: 1px solid #eee;
    display: none;
    flex-direction: column;
    z-index: 10;
}

.chat-user-panel.active {
    display: flex;
}

.chat-user-panel-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 14px;
    border-bottom: 1px solid #eee;
}

.chat-user-panel-header h5 {
    margin: 0;
    font-size: 14px;
}

.chat-user-panel-header button {
    background: none;
    border: none;
    cursor: pointer;
    color: #999;
}

.chat-user-list {
    flex: 1;
    overflow-y: auto;
    padding: 10px;
}

.chat-user-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px 10px;
    border-radius: 8px;
}

.chat-user-item:hover {
    background: #f5f5f5;
}

.chat-user-avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--primary-color), #667eea);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 12px;
    font-weight: 600;
    position: relative;
}

/* 접속 상태 표시 */
.chat-user-status {
    position: absolute;
    bottom: 0;
    right: 0;
    width: 10px;
    height: 10px;
    border-radius: 50%;
    border: 2px solid white;
}

.chat-user-status.online {
    background: #22c55e;
    box-shadow: 0 0 6px rgba(34, 197, 94, 0.6);
}

.chat-user-status.offline {
    background: #ef4444;
}

.chat-user-status.away {
    background: #f59e0b;
}

.chat-user-name {
    font-size: 13px;
    flex: 1;
}

.chat-user-name.me {
    color: var(--primary-color);
    font-weight: 600;
}

/* 접속 상태 텍스트 */
.chat-user-info {
    display: flex;
    flex-direction: column;
    flex: 1;
}

.chat-user-status-text {
    font-size: 11px;
    color: #999;
}

.chat-user-status-text.online {
    color: #22c55e;
}

/* 채팅 메시지 영역 */
.chat-messages {
    flex: 1;
    overflow-y: auto;
    padding: 16px;
    display: flex;
    flex-direction: column;
    gap: 12px;
    background: #f8fafc;
}

.chat-welcome-message {
    text-align: center;
    padding: 30px 20px;
    color: #999;
}

.chat-welcome-message i {
    font-size: 40px;
    margin-bottom: 12px;
    display: block;
    color: var(--primary-color);
    opacity: 0.5;
}

.chat-welcome-message p {
    margin: 0 0 4px;
    font-weight: 500;
    color: #666;
}

.chat-welcome-message span {
    font-size: 12px;
}

/* 메시지 스타일 */
.chat-message {
    display: flex;
    gap: 10px;
    max-width: 85%;
}

.chat-message.mine {
    margin-left: auto;
    flex-direction: row-reverse;
}

.chat-message-avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea, #764ba2);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 13px;
    font-weight: 600;
    flex-shrink: 0;
}

.chat-message.mine .chat-message-avatar {
    background: linear-gradient(135deg, var(--primary-color), #38b2ac);
}

.chat-message-content {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.chat-message.mine .chat-message-content {
    align-items: flex-end;
}

.chat-message-sender {
    font-size: 12px;
    color: #666;
    font-weight: 500;
}

.chat-message.mine .chat-message-sender {
    display: none;
}

.chat-message-bubble {
    padding: 10px 14px;
    background: white;
    border-radius: 16px;
    border-top-left-radius: 4px;
    font-size: 14px;
    line-height: 1.5;
    box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    word-break: break-word;
}

.chat-message.mine .chat-message-bubble {
    background: var(--primary-color);
    color: white;
    border-radius: 16px;
    border-top-right-radius: 4px;
}

.chat-message-time {
    font-size: 10px;
    color: #999;
}

/* 시스템 메시지 */
.chat-system-message {
    text-align: center;
    font-size: 12px;
    color: #999;
    padding: 8px 0;
}

.chat-system-message span {
    background: #e5e7eb;
    padding: 4px 12px;
    border-radius: 10px;
}

/* 채팅 입력 영역 */
.chat-input-area {
    display: flex;
    gap: 8px;
    padding: 12px 16px;
    border-top: 1px solid #eee;
    background: white;
    align-items: center;
}

.chat-attach-buttons {
    display: flex;
    gap: 4px;
}

.chat-attach-btn {
    width: 36px;
    height: 36px;
    border: none;
    border-radius: 50%;
    background: #f1f5f9;
    color: #64748b;
    cursor: pointer;
    transition: all 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
}

.chat-attach-btn:hover {
    background: var(--primary-color);
    color: white;
    transform: scale(1.1);
}

.chat-input-area input {
    flex: 1;
    padding: 10px 16px;
    border: 1px solid #ddd;
    border-radius: 24px;
    font-size: 14px;
    outline: none;
    transition: border-color 0.2s;
}

.chat-input-area input:focus {
    border-color: var(--primary-color);
}

.chat-send-btn {
    width: 44px;
    height: 44px;
    border: none;
    border-radius: 50%;
    background: var(--primary-color);
    color: white;
    cursor: pointer;
    transition: transform 0.2s, background 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
}

.chat-send-btn:hover {
    background: #0284c7;
    transform: scale(1.05);
}

.chat-send-btn:active {
    transform: scale(0.95);
}

/* 이미지/파일 메시지 */
.chat-message-image {
    max-width: 200px;
    border-radius: 12px;
    cursor: pointer;
    transition: transform 0.2s;
}

.chat-message-image:hover {
    transform: scale(1.02);
}

.chat-message-file {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px 16px;
    background: #f1f5f9;
    border-radius: 12px;
    cursor: pointer;
    transition: background 0.2s;
}

.chat-message.mine .chat-message-file {
    background: rgba(255,255,255,0.2);
}

.chat-message-file:hover {
    background: #e2e8f0;
}

.chat-message.mine .chat-message-file:hover {
    background: rgba(255,255,255,0.3);
}

.chat-file-icon {
    width: 36px;
    height: 36px;
    border-radius: 8px;
    background: var(--primary-color);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
}

.chat-file-info {
    flex: 1;
}

.chat-file-name {
    font-size: 13px;
    font-weight: 500;
    color: #333;
    word-break: break-all;
}

.chat-message.mine .chat-file-name {
    color: white;
}

.chat-file-size {
    font-size: 11px;
    color: #999;
}

.chat-message.mine .chat-file-size {
    color: rgba(255,255,255,0.8);
}

/* 이미지 미리보기 모달 */
.image-preview-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.9);
    z-index: 3000;
    display: none;
    align-items: center;
    justify-content: center;
    cursor: zoom-out;
}

.image-preview-overlay.active {
    display: flex;
}

.image-preview-overlay img {
    max-width: 90%;
    max-height: 90%;
    border-radius: 8px;
}

.image-preview-close {
    position: absolute;
    top: 20px;
    right: 20px;
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: rgba(255,255,255,0.2);
    border: none;
    color: white;
    font-size: 24px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* 최소화된 채팅 버튼 */
.chat-minimized {
    position: fixed;
    bottom: 20px;
    right: 100px;
    background: linear-gradient(135deg, var(--primary-color) 0%, #667eea 100%);
    color: white;
    padding: 12px 20px;
    border-radius: 30px;
    display: none;
    align-items: center;
    gap: 10px;
    cursor: pointer;
    box-shadow: 0 4px 20px rgba(14, 165, 233, 0.4);
    z-index: 1998;
    transition: transform 0.2s;
}

.chat-minimized:hover {
    transform: scale(1.05);
}

.chat-minimized.active {
    display: flex;
}

.chat-minimized i {
    font-size: 20px;
}

.chat-unread-badge {
    background: #ef4444;
    color: white;
    padding: 2px 8px;
    border-radius: 10px;
    font-size: 12px;
    font-weight: 600;
    display: none;
}

.chat-unread-badge.has-unread {
    display: block;
}

/* 반응형 */
@media (max-width: 768px) {
    .board-header {
        flex-direction: column;
        gap: 12px;
    }

    .board-actions {
        width: 100%;
    }

    .board-actions .btn {
        flex: 1;
    }

    .chat-window {
        right: 10px;
        left: 10px;
        width: auto;
        bottom: 10px;
        height: 70vh;
    }

    .chat-minimized {
        right: 10px;
    }

    .chat-modal {
        margin: 10px;
        max-height: 90vh;
    }
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

<script>
// 현재 선택된 n  
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

// ==================== 실시간 채팅 기능 ====================

// 현재 사용자 정보
const currentUser = {
    isLoggedIn: ${pageContext.request.userPrincipal != null},
    id: <sec:authorize access="isAuthenticated()">
            '${principal.member.memId}'
        </sec:authorize>
        <sec:authorize access="isAnonymous()">
            null
        </sec:authorize>,
    name: <sec:authorize access="isAuthenticated()">
              '${principal.member.memName}'
          </sec:authorize>
          <sec:authorize access="isAnonymous()">
              '게스트'
          </sec:authorize>
};
// 채팅방 데이터 (실제로는 서버에서 가져옴)
let chatRooms = [
    {
        id: 'room1',
        name: '제주도 여행 이야기',
        category: 'local',
        categoryLabel: '지역',
        currentUsers: 23,
        maxUsers: 50,
        createdBy: 'travel_master',
        createdAt: '2024-03-15'
    },
    {
        id: 'room2',
        name: '3월 도쿄 동행 구해요',
        category: 'companion',
        categoryLabel: '동행',
        currentUsers: 8,
        maxUsers: 10,
        createdBy: 'tokyo_lover',
        createdAt: '2024-03-14'
    },
    {
        id: 'room3',
        name: '여행 자유 수다방',
        category: 'free',
        categoryLabel: '자유',
        currentUsers: 45,
        maxUsers: 100,
        createdBy: 'mohaeng_admin',
        createdAt: '2024-03-01'
    },
    {
        id: 'room4',
        name: '맛집 탐방 동호회',
        category: 'theme',
        categoryLabel: '테마',
        currentUsers: 31,
        maxUsers: 50,
        createdBy: 'food_explorer',
        createdAt: '2024-03-10'
    },
    {
        id: 'room5',
        name: '오사카 여행 정보',
        category: 'local',
        categoryLabel: '지역',
        currentUsers: 17,
        maxUsers: 30,
        createdBy: 'osaka_guide',
        createdAt: '2024-03-12'
    }
];

// 현재 채팅방 정보
let currentChatRoom = null;
let chatMessages = [];
let chatUsers = [];
let unreadCount = 0;
let chatSimulationInterval = null;

// 카테고리 아이콘 매핑
const categoryIcons = {
    'FREE': 'bi-chat-dots',
    'COMPANION': 'bi-people',
    'REGION': 'bi-geo-alt',
    'THEME': 'bi-palette'
};

// ==================== 채팅방 목록 모달 ====================

// 채팅방 목록 열기
function openChatRoomList() {
    document.getElementById('chatRoomModal').classList.add('active');
    loadChatRooms();
    document.body.style.overflow = 'hidden';
}

function  loadChatRooms(category) {
	let url = '/chat/rooms';
	if(category) {
		url += '?category=' + category;
	}
	fetch(url)
	.then(res => res.json())
	.then(data => renderChatRoomListFromServer(data));
}

// 채팅방 목록 닫기
function closeChatRoomList() {
    document.getElementById('chatRoomModal').classList.remove('active');
    document.body.style.overflow = '';
}

// 오버레이 클릭 시 닫기
function closeChatRoomModal(event) {
    if (event.target === event.currentTarget) {
        closeChatRoomList();
    }
}

// 채팅방 목록 렌더링
function renderChatRoomList(rooms) {
	const listEl = document.getElementById('chatRoomList');

    if (!rooms || rooms.length === 0) {
        listEl.innerHTML = '<div class="no-chat-rooms">현재 열린 채팅방이 없습니다</div>';
        return;
    }

    let html = '';
    rooms.forEach(room => {
        html += `
        <div class="chat-room-item ${room.full ? 'full' : ''}"
             onclick="joinChatRoom(${room.chatId})">
            <div class="chat-room-details">
                <div class="chat-room-name">
                    ${room.chatName}
                    ${room.full ? '<span class="badge bg-danger">만석</span>' : ''}
                </div>
                <div class="chat-room-meta">
                    <span>${room.chatCtgryName}</span>
                    <span>${room.createdBy}</span>
                </div>
            </div>
            <div class="chat-room-users-count">
                ${room.currentUsers}/${room.maxUsers}
            </div>
        </div>
        `;
    });

    listEl.innerHTML = html;
}

// 채팅방 필터
document.querySelectorAll('.chat-filter-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        document.querySelectorAll('.chat-filter-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        renderChatRoomList(this.dataset.filter);
    });
});

// ==================== 채팅방 생성 ====================

// 생성 폼 열기
function openCreateRoomForm() {
    if (!currentUser.isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    document.getElementById('createRoomForm').style.display = 'flex';
    document.getElementById('newRoomName').focus();
}

// 생성 폼 닫기
function cancelCreateRoom() {
    document.getElementById('createRoomForm').style.display = 'none';
    document.getElementById('newRoomName').value = '';
}

// 채팅방 생성
function createChatRoom() {
    const name = document.getElementById('newRoomName').value.trim();
    const category = document.getElementById('newRoomCategory').value;
    const maxUsers = parseInt(document.getElementById('newRoomMaxUsers').value) || 50;

    if (!name) {
        showToast('채팅방 이름을 입력해주세요.', 'warning');
        return;
    }

    if (name.length < 2 || name.length > 30) {
        showToast('채팅방 이름은 2~30자로 입력해주세요.', 'warning');
        return;
    }

	const formData = new FormData();
	formData.append('chatName', name);
	formData.append('chatCtgry', category);
	formData.append('chatMax', maxUsers);
	
	fetch(`${contextPath}/chat/room`, {
		method : 'POST',
		body : formData
	})
	.then(res => res.json())
	.then(data => {
		if(!data.success) {
			showToast(data.message, 'warning');
			return;
		}
		
		showToast(data.message, 'success');

		// 생성 폼 닫기
		cancelCreateRoom();
		
		// 서버 기준으로 채팅방 목록 다시 불러오기
		loadChatRooms();
		
		if(data.chatId){
			joinChatRoom(data.chatId);
		}
	})
	.catch(err => {
		console.error(err);
		showToast('채팅방 생성 중 오류가 발생했습니다.', 'error');
	});


    showToast('채팅방이 생성되었습니다!', 'success');
}

// ==================== 채팅 참여 ====================

// 채팅방 참여
function joinChatRoom(roomId) {
    if (!currentUser.isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }
    
    fetch(`${contextPath}/chat/room/${roomId}/join`, {
    	method : 'POST'
    })
    .then(res => res.json())
    .then(data => {
    	if(!data.success) {
    		showToast(data.message, 'warning');
    		return;
    	}
    	
    	// 서버 승인 후 UI 세팅
    	const room = chatRooms.find(r => r.id === roomId);
    	if(!room) {
    		showToast('채팅방 정보를 찾을 수 없습니다.', 'error');
    		return;
    	}
    	
    	currentChatRoom = room;
	
	    // 채팅 UI 설정
	    setupChatWindow(room);
	
	    // 채팅 윈도우 열기
	    openChatWindow();
    	
	    // 시스템 메시지 추가
	    addSystemMessage(currentUser.name + '님이 입장하셨습니다.');

	    // 가상의 기존 메시지 로드
	    loadPreviousMessages();
	
	    // 가상 채팅 시뮬레이션 시작
	    startChatSimulation();
	    
    })
    .catch(err => {
    	console.error(err);
    	showToast('채팅방 입장 중 오류가 발생했습니다.', 'error');
    });
}

// 채팅 윈도우 설정
function setupChatWindow(room) {
    document.getElementById('chatRoomBadge').textContent = room.categoryLabel;
    document.getElementById('chatRoomTitle').textContent = room.name;
    document.getElementById('chatUserCount').textContent = room.currentUsers;
    document.getElementById('chatMinimizedTitle').textContent = room.name;

    // 메시지 초기화
    document.getElementById('chatMessages').innerHTML =
        '<div class="chat-welcome-message">' +
            '<i class="bi bi-chat-heart"></i>' +
            '<p>"' + room.name + '" 채팅방에 오신 것을 환영합니다!</p>' +
            '<span>서로 존중하며 즐거운 대화를 나눠보세요.</span>' +
        '</div>';

    // 참여자 목록 초기화
    chatUsers = generateFakeUsers(room.currentUsers - 1);
    chatUsers.push({ id: currentUser.id, name: currentUser.name, isMe: true, status: 'online' });
    renderChatUserList();
}

// 가상 사용자 생성
function generateFakeUsers(count) {
    const fakeNames = ['travel_kim', 'adventure_lee', 'trip_lover', 'wanderer', 'explorer_j',
                       'nomad_s', 'journey_h', 'voyage_m', 'trek_park', 'globetrotter'];
    const users = [];
    for (let i = 0; i < Math.min(count, fakeNames.length); i++) {
        // 랜덤하게 접속 상태 부여 (70% 온라인, 20% 자리비움, 10% 오프라인)
        const rand = Math.random();
        let status = 'online';
        if (rand > 0.9) status = 'offline';
        else if (rand > 0.7) status = 'away';

        users.push({
            id: 'user_' + i,
            name: fakeNames[i],
            isMe: false,
            status: status,
            lastSeen: status === 'offline' ? getRandomLastSeen() : null
        });
    }
    return users;
}

// 랜덤 마지막 접속 시간 생성
function getRandomLastSeen() {
    const times = ['5분 전', '10분 전', '30분 전', '1시간 전', '2시간 전'];
    return times[Math.floor(Math.random() * times.length)];
}

// 참여자 목록 렌더링
function renderChatUserList() {
    const listEl = document.getElementById('chatUserList');
    let html = '';

    // 온라인 사용자를 먼저 정렬
    const sortedUsers = [...chatUsers].sort((a, b) => {
        const statusOrder = { 'online': 0, 'away': 1, 'offline': 2 };
        return (statusOrder[a.status] || 0) - (statusOrder[b.status] || 0);
    });

    sortedUsers.forEach(user => {
        const initial = user.name.charAt(0).toUpperCase();
        const status = user.status || 'online';
        const statusText = status === 'online' ? '온라인' :
                          status === 'away' ? '자리비움' :
                          (user.lastSeen ? user.lastSeen : '오프라인');

        html += '<div class="chat-user-item">' +
            '<div class="chat-user-avatar">' +
                initial +
                '<span class="chat-user-status ' + status + '"></span>' +
            '</div>' +
            '<div class="chat-user-info">' +
                '<span class="chat-user-name' + (user.isMe ? ' me' : '') + '">' +
                    user.name + (user.isMe ? ' (나)' : '') +
                '</span>' +
                '<span class="chat-user-status-text ' + status + '">' + statusText + '</span>' +
            '</div>' +
        '</div>';
    });

    listEl.innerHTML = html;

    // 온라인 수 업데이트
    const onlineCount = chatUsers.filter(u => u.status === 'online' || u.isMe).length;
    document.getElementById('chatUserCount').textContent = onlineCount + '/' + chatUsers.length;
}

// 이전 메시지 로드 (데모용)
function loadPreviousMessages() {
    const demoMessages = [
        { sender: 'travel_kim', message: '안녕하세요~ 반갑습니다!', time: '14:30' },
        { sender: 'adventure_lee', message: '저도 반가워요! 어디 여행 계획 있으세요?', time: '14:31' },
        { sender: 'trip_lover', message: '저는 다음 달에 제주도 갈 예정이에요', time: '14:32' }
    ];

    demoMessages.forEach(msg => {
        addChatMessage(msg.sender, msg.message, msg.time, false);
    });
}

// ==================== 채팅 윈도우 제어 ====================

// 채팅 윈도우 열기
function openChatWindow() {
    document.getElementById('chatWindow').classList.add('active');
    document.getElementById('chatMinimized').classList.remove('active');
    document.getElementById('chatInput').focus();
    unreadCount = 0;
    updateUnreadBadge();
}

// 채팅 최소화
function minimizeChat() {
    document.getElementById('chatWindow').classList.remove('active');
    document.getElementById('chatMinimized').classList.add('active');
}

// 채팅 최대화
function maximizeChat() {
    openChatWindow();
}

// 채팅 나가기
function leaveChat() {
    if (!currentChatRoom) return;

    if (confirm('채팅방에서 나가시겠습니까?')) {
        // 퇴장 메시지
        addSystemMessage(currentUser.name + '님이 퇴장하셨습니다.');

        // 사용자 수 감소
        currentChatRoom.currentUsers--;

        // 시뮬레이션 중지
        stopChatSimulation();

        // UI 닫기
        document.getElementById('chatWindow').classList.remove('active');
        document.getElementById('chatMinimized').classList.remove('active');
        document.getElementById('chatUserPanel').classList.remove('active');

        currentChatRoom = null;
        chatMessages = [];
        chatUsers = [];

        showToast('채팅방에서 나왔습니다.', 'info');
    }
}

// 참여자 목록 토글
function toggleChatUserList() {
    document.getElementById('chatUserPanel').classList.toggle('active');
}

// ==================== 메시지 전송/수신 ====================

// 메시지 전송
function sendMessage() {
    const input = document.getElementById('chatInput');
    const message = input.value.trim();

    if (!message) return;

    // 내 메시지 추가
    const time = new Date().toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
    addChatMessage(currentUser.name, message, time, true);

    // 입력 초기화
    input.value = '';
    input.focus();
}

// 엔터키 처리
function handleChatKeydown(event) {
    if (event.key === 'Enter' && !event.shiftKey && !event.isComposing) {
        event.preventDefault();
        sendMessage();
    }
}

// 채팅 메시지 추가
function addChatMessage(sender, message, time, isMine) {
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
                '<div class="chat-message-bubble">' + escapeHtml(message) + '</div>' +
                '<span class="chat-message-time">' + time + '</span>' +
            '</div>' +
        '</div>';

    messagesEl.insertAdjacentHTML('beforeend', messageHtml);
    messagesEl.scrollTop = messagesEl.scrollHeight;

    // 최소화 상태일 때 읽지 않은 메시지 카운트
    if (!isMine && !document.getElementById('chatWindow').classList.contains('active')) {
        unreadCount++;
        updateUnreadBadge();
    }
}

// 시스템 메시지 추가
function addSystemMessage(message) {
    const messagesEl = document.getElementById('chatMessages');

    // 환영 메시지 제거
    const welcomeMsg = messagesEl.querySelector('.chat-welcome-message');
    if (welcomeMsg) welcomeMsg.remove();

    const messageHtml =
        '<div class="chat-system-message">' +
            '<span>' + message + '</span>' +
        '</div>';

    messagesEl.insertAdjacentHTML('beforeend', messageHtml);
    messagesEl.scrollTop = messagesEl.scrollHeight;
}

// 읽지 않은 메시지 배지 업데이트
function updateUnreadBadge() {
    const badge = document.getElementById('chatUnreadBadge');
    badge.textContent = unreadCount;
    if (unreadCount > 0) {
        badge.classList.add('has-unread');
    } else {
        badge.classList.remove('has-unread');
    }
}

// HTML 이스케이프
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
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

// ==================== 채팅 시뮬레이션 ====================

// 가상 채팅 시뮬레이션 (데모용)
function startChatSimulation() {
    const simulatedMessages = [
        { sender: 'travel_kim', message: '오~ 새로운 분이 오셨네요! 환영해요 👋' },
        { sender: 'adventure_lee', message: '안녕하세요!' },
        { sender: 'trip_lover', message: '반갑습니다~' },
        { sender: 'wanderer', message: '저도 다음 달에 여행 가려고 계획 중이에요' },
        { sender: 'explorer_j', message: '어디로 가세요?' },
        { sender: 'travel_kim', message: '좋은 여행지 추천 있으면 알려주세요!' },
        { sender: 'adventure_lee', message: '저는 최근에 후쿠오카 다녀왔는데 너무 좋았어요' },
        { sender: 'trip_lover', message: '후쿠오카 음식이 정말 맛있죠' }
    ];

    let index = 0;

    chatSimulationInterval = setInterval(() => {
        if (index < simulatedMessages.length && currentChatRoom) {
            const msg = simulatedMessages[index];
            const time = new Date().toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
            addChatMessage(msg.sender, msg.message, time, false);
            index++;
        } else {
            stopChatSimulation();
        }
    }, 5000 + Math.random() * 5000); // 5~10초 랜덤 간격
}

// 시뮬레이션 중지
function stopChatSimulation() {
    if (chatSimulationInterval) {
        clearInterval(chatSimulationInterval);
        chatSimulationInterval = null;
    }
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

// ==================== 게시글 상세 모달 ====================

// 게시글 데이터 (실제로는 서버에서 가져옴)
const postsData = {
    1: {
        id: 1,
        category: 'notice',
        categoryLabel: '공지',
        title: '[필독] 여행톡 이용 규칙 안내',
        author: '운영자',
        authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&q=80',
        date: '2024.03.01',
        views: 1234,
        likes: 56,
        tags: ['공지사항', '필독', '이용규칙'],
        content: '<p>안녕하세요, 모행 여행톡 이용자 여러분!</p><p>여행톡은 여행자들이 서로 소통하고 정보를 나누는 커뮤니티입니다. 원활한 커뮤니티 운영을 위해 아래 규칙을 꼭 지켜주세요.</p><h4>📌 기본 규칙</h4><ul><li>서로를 존중하는 언어를 사용해주세요</li><li>광고성 게시글은 삭제될 수 있습니다</li><li>개인정보를 공개적으로 공유하지 마세요</li><li>저작권을 존중해주세요</li></ul><h4>📌 카테고리별 안내</h4><ul><li><strong>자유게시판</strong>: 여행 관련 자유로운 이야기</li><li><strong>동행 구하기</strong>: 함께 여행할 동행자 모집</li><li><strong>정보 공유</strong>: 유용한 여행 정보 나눔</li><li><strong>여행 Q&A</strong>: 여행 관련 질문과 답변</li><li><strong>후기</strong>: 여행 후기 및 경험담</li></ul><p>즐거운 여행톡 되세요! 🌍✈️</p>',
        comments: []
    },
    2: {
        id: 2,
        category: 'companion',
        categoryLabel: '동행',
        title: '3월 말 제주도 2박3일 같이 가실 분~',
        author: 'travel_lover',
        authorAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80',
        date: '2024.03.15',
        views: 328,
        likes: 24,
        tags: ['제주도', '동행구함', '2박3일', '3월여행'],
        content: '<p>안녕하세요! 3월 28일부터 30일까지 제주도 여행 계획 중인데 같이 가실 분 계신가요?</p><p><strong>📅 일정</strong>: 3/28(목) ~ 3/30(토) 2박 3일</p><p><strong>🏨 숙소</strong>: 서귀포 게스트하우스 예정 (도미토리)</p><p><strong>💰 예상 비용</strong>: 항공권 별도, 숙소+렌트카+식비 약 15~20만원</p><p><strong>👥 모집 인원</strong>: 2~3명</p><p><strong>📍 대략적인 일정</strong></p><ul><li>1일차: 서귀포 올레길, 천지연폭포</li><li>2일차: 성산일출봉, 섭지코지, 우도</li><li>3일차: 협재해변, 오설록</li></ul><p>편하게 연락주세요! 카톡 오픈채팅방 만들어놓겠습니다 😊</p>',
        comments: [
            { id: 1, author: '여행좋아', avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&q=80', date: '2024.03.15 14:30', text: '저도 가고 싶어요! 혹시 여자만 가능한가요?' },
            { id: 2, author: 'travel_lover', avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80', date: '2024.03.15 14:45', text: '성별 무관해요~ 편하게 연락주세요!' },
            { id: 3, author: 'jeju_lover', avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&q=80', date: '2024.03.15 15:20', text: '제주도민인데 맛집 추천해드릴게요! 서귀포 가시면 흑돼지 꼭 드세요' }
        ]
    },
    3: {
        id: 3,
        category: 'info',
        categoryLabel: '정보',
        title: '오사카 맛집 리스트 총정리 (2024년 최신)',
        author: 'foodie_kim',
        authorAvatar: 'https://images.unsplash.com/photo-1599566150163-29194dcabd36?w=100&h=100&fit=crop&q=80',
        date: '2024.03.14',
        views: 2156,
        likes: 187,
        tags: ['오사카', '일본맛집', '라멘', '스시', '맛집추천'],
        content: '<p>지난 2월에 오사카 다녀왔는데요, 직접 가본 맛집들 정리해봤습니다!</p><h4>🍜 라멘</h4><ul><li><strong>이치란 라멘 도톤보리점</strong> - 클래식한 돈코츠 라멘, 줄 서도 먹을 가치 있음</li><li><strong>킨류 라멘</strong> - 24시간 영업, 가성비 굿</li></ul><h4>🍣 스시/해산물</h4><ul><li><strong>쿠로몬 시장</strong> - 신선한 회 먹으러 꼭 가보세요</li><li><strong>다이키 스시</strong> - 스탠딩 스시바, 현지인 많음</li></ul><h4>🥘 기타</h4><ul><li><strong>도톤보리 타코야키</strong> - 쿠쿠루, 와나카 둘 다 맛있어요</li><li><strong>리쿠로 오지상 치즈케이크</strong> - 폭신폭신 맛있음!</li></ul><p>궁금한 거 있으시면 댓글로 물어봐주세요~ 🍽️</p>',
        comments: [
            { id: 1, author: 'japan_trip', avatar: 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=100&h=100&fit=crop&q=80', date: '2024.03.14 18:00', text: '와 정리 감사해요! 저장해놓고 가야겠어요' },
            { id: 2, author: 'osaka_fan', avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop&q=80', date: '2024.03.14 19:30', text: '이치란 진짜 맛있죠!! 이번에 또 가려구요' }
        ]
    },
    4: {
        id: 4,
        category: 'free',
        categoryLabel: '자유',
        title: '방콕 여행 다녀왔어요! 너무 좋았던 경험 공유합니다',
        author: 'adventure_park',
        authorAvatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=100&h=100&fit=crop&q=80',
        date: '2024.03.14',
        views: 567,
        likes: 43,
        tags: ['방콕', '태국여행', '왓아룬', '여행후기'],
        content: '<p>저번 주에 방콕 4박 5일 다녀왔는데 정말 최고였어요!</p><p>특히 왓아룬에서 본 일몰이 너무 아름다웠습니다. 배를 타고 가면서 보는 풍경도 좋고, 절 자체도 너무 웅장하고 예뻤어요.</p><p><strong>가장 좋았던 곳:</strong></p><ul><li>왓아룬 (일몰 시간 추천!)</li><li>짜뚜짝 주말시장</li><li>아이콘시암 (백화점인데 구경만 해도 재밌어요)</li></ul><p><strong>꿀팁:</strong></p><ul><li>그랩 필수 설치하세요! 택시보다 훨씬 편해요</li><li>물가 진짜 싸요, 마사지는 매일 받으세요 ㅎㅎ</li><li>더위 대비 물 많이 챙기세요</li></ul><p>다음에는 파타야도 가보려구요! 🌴</p>',
        comments: [
            { id: 1, author: 'thai_lover', avatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop&q=80', date: '2024.03.14 16:00', text: '방콕 진짜 좋죠! 저도 왓아룬 일몰 보고 감동받았어요' }
        ]
    },
    5: {
        id: 5,
        category: 'qna',
        categoryLabel: 'Q&A',
        title: '일본 교통카드 뭘로 사야 할까요?',
        author: 'newbie_traveler',
        authorAvatar: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=100&h=100&fit=crop&q=80',
        date: '2024.03.13',
        views: 445,
        likes: 12,
        tags: ['일본여행', '교통카드', '스이카', 'JR패스', '여행질문'],
        content: '<p>4월에 일본 여행 처음 가는데요, 교통카드 종류가 너무 많아서 뭘 사야 할지 모르겠어요 😅</p><p>도쿄, 오사카, 교토 3개 도시 갈 예정인데요:</p><ul><li>스이카(Suica)</li><li>파스모(Pasmo)</li><li>이코카(Icoca)</li></ul><p>이 중에서 뭐가 좋을까요? 아니면 다 비슷한가요?</p><p>그리고 JR패스도 사야 하는지 궁금합니다!</p>',
        comments: [
            { id: 1, author: 'japan_expert', avatar: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=100&h=100&fit=crop&q=80', date: '2024.03.13 10:00', text: '스이카나 이코카 아무거나 사셔도 돼요! 전국에서 다 쓸 수 있어요' },
            { id: 2, author: 'tokyo_guide', avatar: 'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=100&h=100&fit=crop&q=80', date: '2024.03.13 11:30', text: 'JR패스는 7일권 기준 도쿄-오사카 왕복 신칸센 타면 본전이에요. 일정 보시고 계산해보세요!' },
            { id: 3, author: 'travel_helper', avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop&q=80', date: '2024.03.13 14:00', text: '저도 처음에 고민 많이 했는데, 그냥 공항에서 스이카 사세요. 애플페이에 등록도 가능해요!' }
        ]
    },
    6: {
        id: 6,
        category: 'companion',
        categoryLabel: '동행',
        title: '4월 초 도쿄 디즈니 같이 가실 분 구해요!',
        author: 'disney_fan',
        authorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&q=80',
        date: '2024.03.13',
        views: 234,
        likes: 18,
        tags: ['도쿄', '디즈니랜드', '동행구함', '4월여행'],
        content: '<p>혼자 디즈니 가려니까 좀 외로울 것 같아서요 ㅠㅠ</p><p><strong>📅 일정</strong>: 4월 5일(금) 하루</p><p><strong>🎠 장소</strong>: 도쿄 디즈니랜드 (씨 말고 랜드요!)</p><p>디즈니 좋아하시는 분이면 좋겠어요! 같이 사진도 찍고 퍼레이드도 보고 싶습니다 🏰✨</p><p>20대 여자분이면 더 좋을 것 같아요! (저도 20대 여자입니다)</p>',
        comments: [
            { id: 1, author: 'disney_love', avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&q=80', date: '2024.03.13 20:00', text: '저 디즈니 너무 좋아해요!! 같이 가고 싶은데 일정이 안 맞네요 ㅠㅠ' }
        ]
    },
    7: {
        id: 7,
        category: 'info',
        categoryLabel: '정보',
        title: '제주도 렌트카 vs 대중교통, 뭐가 나을까요?',
        author: 'jeju_local',
        authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&q=80',
        date: '2024.03.12',
        views: 892,
        likes: 67,
        tags: ['제주도', '렌트카', '대중교통', '여행팁', '제주도민'],
        content: '<p>제주도민으로서 여행객분들께 정보 공유드려요!</p><h4>🚗 렌트카</h4><p><strong>장점:</strong></p><ul><li>자유로운 일정 조절</li><li>숨은 명소 방문 가능</li><li>짐 보관 편리</li></ul><p><strong>단점:</strong></p><ul><li>주차 어려운 곳 많음 (특히 성수기)</li><li>운전 피로</li><li>비용 (렌트비+주유비+주차비)</li></ul><h4>🚌 대중교통</h4><p><strong>장점:</strong></p><ul><li>저렴함</li><li>운전 스트레스 없음</li><li>급행버스 의외로 빠름</li></ul><p><strong>단점:</strong></p><ul><li>배차 간격 김</li><li>일정에 제약</li><li>동쪽/서쪽 이동 불편</li></ul><h4>💡 결론</h4><p>2박 이상이면 렌트카 추천, 1박이거나 제주시내/서귀포시내 위주면 대중교통도 괜찮아요!</p>',
        comments: [
            { id: 1, author: 'jeju_trip', avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&q=80', date: '2024.03.12 16:30', text: '저도 렌트카 추천이요! 버스 기다리다가 시간 다 갔어요 ㅠ' }
        ]
    },
    8: {
        id: 8,
        category: 'free',
        categoryLabel: '자유',
        title: '혼자 여행하는 분들 어떻게 사진 찍으세요?',
        author: 'solo_traveler',
        authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop&q=80',
        date: '2024.03.12',
        views: 412,
        likes: 35,
        tags: ['혼자여행', '솔로여행', '사진팁', '여행사진'],
        content: '<p>혼자 여행할 때 사진 찍기가 너무 어려워요 ㅠㅠ</p><p>셀카봉 들고 다니기도 좀 그렇고... 다들 어떻게 하시나요?</p><p>삼각대? 아니면 그냥 지나가는 분께 부탁하시나요?</p>',
        comments: [
            { id: 1, author: 'photo_master', avatar: 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=100&h=100&fit=crop&q=80', date: '2024.03.12 11:00', text: '저는 작은 삼각대 들고 다녀요! 타이머 맞춰놓고 찍으면 자연스럽게 나와요' },
            { id: 2, author: 'travel_photo', avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop&q=80', date: '2024.03.12 12:30', text: '그냥 풍경 위주로 찍어요 ㅋㅋ 나중에 보면 그것도 추억이에요' }
        ]
    }
};

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
