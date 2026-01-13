<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!-- 현재 로그인/권한 상태를 JS가 읽어가게 심어둠 -->
<span id="authRole" style="display:none;">
  <sec:authorize access="hasRole('ROLE_MEMBER')">MEMBER</sec:authorize>
  <sec:authorize access="hasRole('ROLE_BUSINESS')">BUSINESS</sec:authorize>
  <sec:authorize access="!isAuthenticated()">ANON</sec:authorize>
</span>

<c:set var="pageTitle" value="여행기록 상세" />
<c:set var="pageCss" value="community" />

<%@ include file="../common/header.jsp"%>

<div class="travellog-page">
  <div class="container" style="padding: 24px 0;">

    <c:if test="${empty detail}">
      <div class="alert alert-warning">게시글이 없거나 접근 권한이 없습니다.</div>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/community/travel-log">목록으로</a>
    </c:if>

    <c:if test="${not empty detail}">
      <!-- ==================== 상세 카드 ==================== -->
      <div class="travellog-detail-card">
        <!-- 커버(대표 이미지) -->
        <div class="travellog-detail-cover">
          <!-- 실제 대표이미지 경로가 없어서 임시. 나중에 detail.coverUrl 같은 값으로 교체 -->
          <c:choose>
  <c:when test="${not empty detail.coverPath}">
    <img src="${pageContext.request.contextPath}/files${detail.coverPath}" alt="cover">
  </c:when>
  <c:otherwise>
    <img src="https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&h=600&fit=crop&q=80" alt="cover">
  </c:otherwise>
</c:choose>

          <div class="travellog-detail-cover-overlay"></div>

          <a class="travellog-detail-back"
             href="${pageContext.request.contextPath}/community/travel-log">
            <i class="bi bi-arrow-left"></i>
            목록
          </a>
        </div>

        <div class="travellog-detail-body">
          <!-- 작성자 영역 -->
          <div class="travellog-detail-author">
            <img class="travellog-detail-avatar"
                 src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&q=80"
                 alt="avatar">
            <div class="travellog-detail-author-info">
              <div class="travellog-detail-author-name">
<%--                 <c:out value="${detail.memId}" /> --%>
                <c:out value="${detail.nickname}(${detail.memId})" />
              </div>
              <div class="travellog-detail-author-meta">
                <span><i class="bi bi-eye"></i> <c:out value="${detail.viewCnt}" /></span>
                <span class="dot">·</span>
                <span><i class="bi bi-calendar3"></i> <fmt:formatDate value="${detail.regDt}" pattern="yyyy-MM-dd" /></span>
              </div>
            </div>

            <!-- 오른쪽(수정/삭제 같은 버튼 필요하면 여기) -->
            <div class="travellog-detail-actions-right">
               <button type="button" class="btn btn-outline-secondary btn-sm"
                      onclick="location.href='${pageContext.request.contextPath}/community/travel-log'">수정
              </button>
              <button type="button" class="btn btn-outline-secondary btn-sm"
                      onclick="location.href='${pageContext.request.contextPath}/community/travel-log'">삭제
              </button>
            </div>
          </div>

          <!-- 제목 -->
          <h1 class="travellog-detail-title">
            <c:out value="${detail.rcdTitle}" />
          </h1>

          <!-- 여행 메타 -->
          <div class="travellog-detail-meta">
            <span class="meta-pill">
              <i class="bi bi-geo-alt"></i>
              지역: <c:out value="${detail.locCd}" />
            </span>
            <span class="meta-pill">
              <i class="bi bi-calendar-range"></i>
              일정: <fmt:formatDate value="${detail.startDt}" pattern="yyyy년 M월 d일" />
~
<fmt:formatDate value="${detail.endDt}" pattern="yyyy년 M월 d일" />
            </span>
            <span class="meta-pill">
              <i class="bi bi-globe2"></i>
              공개: <c:out value="${detail.openScopeCd}" />
            </span>
          </div>

          <!-- 본문 -->
          <div class="travellog-detail-content">
            <c:out value="${detail.rcdContent}" />
          </div>

          <!-- 액션 바 (LIST 톤처럼 버튼형) -->
          <div class="travellog-detail-actionbar">
            <button type="button"
  class="travellog-action-btn"
  onclick="if (!guardMemberAction(event)) return; toggleDetailLike(this);">
  <i class="bi bi-heart"></i>
  <span id="likeCount">${detail.likeCount}</span>
</button>

<button type="button"
  class="travellog-action-btn"
  onclick="if (!guardMemberAction(event)) return; scrollToComments();">
  <i class="bi bi-chat"></i>
  <span id="commentCountTop">${detail.commentCount}</span>
</button>


           

            <button type="button"
  class="travellog-action-btn"
  onclick="if (!guardMemberAction(event)) return; toggleDetailBookmark(this);">
  <i class="bi bi-bookmark"></i>
  <span id="bookmarkCount">${detail.bookmarkCount}</span>
</button>

            
<button type="button"
  class="travellog-action-btn"
  style="margin-left:auto;"
  onclick="if (!guardShareAction(event)) return; shareDetail();">
  <i class="bi bi-send"></i>
  <span>공유</span>
</button>


          </div>

          <!-- ==================== 댓글 영역 ==================== -->
          <div class="detail-comments-section" id="commentsSection">
            <h3 class="detail-comments-title">
              댓글 <span id="commentCount">0</span>개
            </h3>

            <!-- 댓글 입력 -->
<%--             <c:if test="${not empty sessionScope.loginUser  --%>
<%--              and sessionScope.loginUser.userType eq 'MEMBER'}"> --%>
<!--     <div class="detail-comment-input"> -->
<!--         <input id="commentInput" type="text" placeholder="댓글을 입력하세요..." /> -->
<!--         <button type="button" onclick="submitComment(CURRENT_RCD_NO)">등록</button> -->
<!--     </div> -->
<%-- </c:if> --%>

<%-- <c:if test="${empty sessionScope.loginUser}"> --%>
<!--     <div class="detail-comment-input"> -->
<!--         <input type="text" placeholder="로그인 후 댓글 작성 가능" disabled /> -->
<!--         <button disabled>등록</button> -->
<!--     </div> -->
<%-- </c:if> --%>

<sec:authorize access="hasRole('ROLE_MEMBER')">
  <div class="detail-comment-input">
    <input id="commentInput" type="text" placeholder="댓글을 입력하세요..." />
    <button type="button" onclick="submitComment(CURRENT_RCD_NO)">등록</button>
  </div>
</sec:authorize>

<sec:authorize access="!hasRole('ROLE_MEMBER')">
  <div class="detail-comment-input">
    <input type="text" placeholder="일반회원만 댓글 작성 가능" disabled />
    <button disabled>등록</button>
  </div>
</sec:authorize>




            <!-- 댓글 목록 -->
            <div id="commentList" class="detail-comments-list"></div>
          </div>

        </div>
      </div>

      <!-- ==================== DETAIL 전용 스타일(인라인) ==================== -->
      <style>
        /* 전체 래퍼(리스트 톤 유지) */
        .travellog-page { background: transparent; }
        .travellog-detail-card{
          background:#fff;
          border:1px solid #e2e8f0;
          border-radius:16px;
          overflow:hidden;
          box-shadow: 0 6px 18px rgba(0,0,0,.06);
        }

        /* 커버 */
        .travellog-detail-cover{
          position:relative;
          height: 280px;
          overflow:hidden;
          background:#f1f5f9;
        }
        .travellog-detail-cover img{
          width:100%;
          height:100%;
          object-fit:cover;
          display:block;
        }
        .travellog-detail-cover-overlay{
          position:absolute;
          inset:0;
          background: linear-gradient(180deg, rgba(0,0,0,.10) 0%, rgba(0,0,0,.35) 100%);
          pointer-events:none;
        }
        .travellog-detail-back{
          position:absolute;
          top:16px; left:16px;
          display:inline-flex;
          align-items:center;
          gap:8px;
          padding:10px 14px;
          border-radius:999px;
          background: rgba(255,255,255,.92);
          color:#111827;
          text-decoration:none;
          font-weight:600;
          font-size:13px;
          border:1px solid rgba(226,232,240,.9);
          backdrop-filter: blur(6px);
        }
        .travellog-detail-back:hover{ background: rgba(255,255,255,1); }

        /* 본문 영역 */
        .travellog-detail-body{
          padding: 22px 24px 26px;
        }

        /* 작성자 */
        .travellog-detail-author{
          display:flex;
          gap:12px;
          align-items:center;
          margin-bottom: 14px;
        }
        .travellog-detail-avatar{
          width:44px; height:44px;
          border-radius:50%;
          object-fit:cover;
          flex-shrink:0;
          border:1px solid #e2e8f0;
        }
        .travellog-detail-author-name{
          font-weight:700;
          font-size:14px;
          color:#0f172a;
          line-height:1.2;
        }
        .travellog-detail-author-meta{
          margin-top:2px;
          font-size:12px;
          color:#64748b;
          display:flex;
          align-items:center;
          gap:8px;
          flex-wrap:wrap;
        }
        .travellog-detail-author-meta i{ color: var(--primary-color); }
        .travellog-detail-author-meta .dot{ opacity:.6; }
        .travellog-detail-actions-right{ margin-left:auto; }

        /* 제목 */
        .travellog-detail-title{
          font-size: 26px;
          font-weight: 800;
          color:#0f172a;
          line-height:1.25;
          margin: 8px 0 12px;
        }

        /* 메타 pill */
        .travellog-detail-meta{
          display:flex;
          flex-wrap:wrap;
          gap:10px;
          margin-bottom: 14px;
        }
        .meta-pill{
          display:inline-flex;
          align-items:center;
          gap:8px;
          padding: 8px 12px;
          border-radius: 999px;
          border:1px solid #e2e8f0;
          background:#f8fafc;
          color:#475569;
          font-size: 13px;
          font-weight: 600;
        }
        .meta-pill i{ color: var(--primary-color); }

        /* 본문 */
        .travellog-detail-content{
          white-space: pre-wrap;
          line-height: 1.8;
          font-size: 15px;
          color:#334155;
          padding: 14px 2px 10px;
        }

        /* 액션바 (리스트 버튼 느낌) */
        .travellog-detail-actionbar{
          display:flex;
          gap:10px;
          padding: 14px 0 10px;
          border-top:1px solid #e2e8f0;
          border-bottom:1px solid #e2e8f0;
          margin-top: 10px;
          margin-bottom: 18px;
          flex-wrap:wrap;
        }
        .travellog-action-btn{
          display:inline-flex;
          align-items:center;
          gap:8px;
          padding: 10px 14px;
          border-radius: 999px;
          border:1px solid #e2e8f0;
          background:#fff;
          color:#334155;
          font-size: 14px;
          font-weight:700;
          cursor:pointer;
          transition: all .15s ease;
        }
        .travellog-action-btn:hover{
          background:#f8fafc;
          border-color:#cbd5e1;
        }
        .travellog-action-btn i{ font-size: 16px; }
        .travellog-action-btn.active{
          background: var(--primary-color);
          border-color: var(--primary-color);
          color:#fff;
        }
        .travellog-action-btn.active i{ color:#fff; }

        /* 댓글 섹션 (너 travel-log.jsp의 스타일과 톤 맞춤) */
        .detail-comments-section{ margin-top: 8px; }
        .detail-comments-title{
          font-size: 18px;
          font-weight: 800;
          color:#0f172a;
          margin: 0 0 14px;
        }
        .detail-comment-input{
          display:flex;
          gap:10px;
          margin-bottom: 16px;
        }
        .detail-comment-input input{
          flex:1;
          padding: 12px 16px;
          border:1px solid #e2e8f0;
          border-radius: 999px;
          font-size: 14px;
          outline:none;
        }
        .detail-comment-input input:focus{
          border-color: var(--primary-color);
          box-shadow: 0 0 0 3px rgba(26,188,156,.10);
        }
        .detail-comment-input button{
          padding: 12px 18px;
          border:none;
          border-radius: 999px;
          background: var(--primary-color);
          color:#fff;
          font-weight:800;
          font-size:14px;
          cursor:pointer;
        }
        .detail-comment-input button:hover{ filter: brightness(.97); }

        .detail-comments-list{
          display:flex;
          flex-direction:column;
          gap:14px;
        }
        .detail-comment{
          display:flex;
          gap:12px;
          align-items:flex-start;
        }
        .detail-comment-avatar{
          width:40px; height:40px;
          border-radius:50%;
          object-fit:cover;
          border:1px solid #e2e8f0;
          flex-shrink:0;
        }
        .detail-comment-content{ flex:1; }
        .detail-comment-header{
          display:flex;
          align-items:center;
          gap:8px;
          margin-bottom: 4px;
        }
        .detail-comment-author{
          font-weight:800;
          font-size: 13px;
          color:#0f172a;
        }
        .detail-comment-time{
          font-size: 12px;
          color:#94a3b8;
        }
        .detail-comment-text{
          margin:0 0 8px;
          font-size: 14px;
          line-height: 1.6;
          color:#334155;
          background:#f8fafc;
          border:1px solid #e2e8f0;
          border-radius: 14px;
          padding: 10px 12px;
        }
        .detail-comment-actions{
          display:flex;
          gap:10px;
        }
        .detail-comment-actions button{
          border:none;
          background:transparent;
          color:#64748b;
          font-size: 12px;
          font-weight:800;
          display:inline-flex;
          align-items:center;
          gap:6px;
          cursor:pointer;
        }
        .detail-comment-actions button:hover{ color: var(--primary-color); }

        @media (max-width: 768px){
          .travellog-detail-cover{ height: 200px; }
          .travellog-detail-body{ padding: 18px 16px 20px; }
          .travellog-detail-title{ font-size: 20px; }
          .travellog-detail-actionbar{ gap:8px; }
          .travellog-action-btn{ padding: 9px 12px; font-size: 13px; }
        }
      </style>

      <!-- ==================== 댓글 JS (500 방지: \${} 이스케이프 필수) ==================== -->
      <script>
      const AUTH_ROLE = document.getElementById('authRole')?.innerText?.trim();

      function guardMemberAction(e) {
        if (e) e.preventDefault();

        if (AUTH_ROLE === 'ANON') {
          showLoginOverlay();
          return false;
        }
        if (AUTH_ROLE === 'BUSINESS') {
          return false;
        }
        return true; // MEMBER
      }

      // ✅ 공유 전용: 비회원 OK, 기업만 차단
      function guardShareAction(e) {
        if (e) e.preventDefault();
        if (AUTH_ROLE === 'BUSINESS') return false; // 기업만 막기
        return true; // ANON + MEMBER 허용
      }

      
        // ✅ 컨텍스트패스
        const CTX = "${pageContext.request.contextPath}";

        // ✅ 현재 게시글 번호
        const CURRENT_RCD_NO = Number("${detail.rcdNo}");

        console.log("CTX=", CTX, "CURRENT_RCD_NO=", CURRENT_RCD_NO);

        function escapeHtml(text) {
          if (text === null || text === undefined) return '';
          return String(text)
            .replace(/&/g,'&amp;')
            .replace(/</g,'&lt;')
            .replace(/>/g,'&gt;')
            .replace(/"/g,'&quot;')
            .replace(/'/g,'&#039;');
        }

        function scrollToComments(){
          const el = document.getElementById('commentsSection');
          if (el) el.scrollIntoView({behavior:'smooth', block:'start'});
        }

        // (옵션) 상세 좋아요/북마크: 지금은 UI 토글만(서버연결 전)
        function toggleDetailLike(btn){
          btn.classList.toggle('active');
          const icon = btn.querySelector('i');
          const countEl = document.getElementById('likeCount');
          let num = parseInt(countEl.textContent || '0', 10);

          if (btn.classList.contains('active')) {
            icon.className = 'bi bi-heart-fill';
            countEl.textContent = num + 1;
          } else {
            icon.className = 'bi bi-heart';
            countEl.textContent = Math.max(0, num - 1);
          }
        }

        function toggleDetailBookmark(btn){
          btn.classList.toggle('active');
          const icon = btn.querySelector('i');
          const countEl = document.getElementById('bookmarkCount');
          let num = parseInt(countEl.textContent || '0', 10);

          if (btn.classList.contains('active')) {
            icon.className = 'bi bi-bookmark-fill';
            countEl.textContent = num + 1;
            if (typeof showToast === 'function') showToast('북마크에 저장되었습니다.', 'success');
          } else {
            icon.className = 'bi bi-bookmark';
            countEl.textContent = Math.max(0, num - 1);
            if (typeof showToast === 'function') showToast('북마크가 해제되었습니다.', 'info');
          }
        }

        function shareDetail(){
          const url = location.href;
          navigator.clipboard?.writeText(url).then(() => {
            if (typeof showToast === 'function') showToast('링크가 복사되었습니다.', 'success');
            else alert('링크가 복사되었습니다.');
          }).catch(() => {
            prompt('링크 복사:', url);
          });
        }

        async function loadComments(rcdNo) {
        	  if (!rcdNo || Number.isNaN(Number(rcdNo))) {
        	    console.error("loadComments: invalid rcdNo =", rcdNo);
        	    return;
        	  }

        	  const res = await fetch(CTX + "/community/travel-log/comments?rcdNo=" + rcdNo);
        	  if (!res.ok) {
        	    console.error("loadComments failed", res.status);
        	    return;
        	  }

        	  const list = await res.json();
        	  document.getElementById("commentCount").textContent = list.length;

        	  const wrap = document.getElementById("commentList");
        	  wrap.innerHTML = "";

        	  list.forEach(function(c) {
        	    const cmntNo = Number(c.cmntNo);
        	    const avatar = "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=80&h=80&fit=crop&q=80";

        	    const item = document.createElement("div");
        	    item.className = "detail-comment";

        	    item.innerHTML =
        	      '<img class="detail-comment-avatar" src="' + avatar + '" alt="avatar">' +
        	      '<div class="detail-comment-content">' +
        	        '<div class="detail-comment-header">' +
        	          '<span class="detail-comment-author">' + escapeHtml(c.writerId || "unknown") + '</span>' +
        	          '<span class="detail-comment-time">' + escapeHtml(c.regDt || "") + '</span>' +
        	        '</div>' +

        	        '<p class="detail-comment-text">' + escapeHtml(c.cmntContent || "") + '</p>' +

        	        '<div class="detail-comment-actions">' +
        	          '<button type="button" onclick="toggleReplyBox(' + cmntNo + ')">' +
        	            '<i class="bi bi-reply"></i> 답글' +
        	          '</button>' +
        	          '<button type="button" onclick="deleteComment(' + cmntNo + ')">' +
        	            '<i class="bi bi-trash"></i> 삭제' +
        	          '</button>' +
        	        '</div>' +

        	        '<div id="replyBox-' + cmntNo + '" style="display:none; margin-top:10px;">' +
        	          '<div class="detail-comment-input" style="margin-bottom:0;">' +
        	            '<input id="replyInput-' + cmntNo + '" placeholder="대댓글을 입력하세요...">' +
        	            '<button type="button" onclick="submitReply(' + rcdNo + ', ' + cmntNo + ')">등록</button>' +
        	          '</div>' +
        	        '</div>' +
        	      '</div>';

        	    // 대댓글이면 들여쓰기
        	    if (Number(c.depth) === 1) {
        	      item.style.marginLeft = "28px";
        	    }

        	    wrap.appendChild(item);
        	  });
        	}


        function toggleReplyBox(cmntNo) {
          const box = document.getElementById(`replyBox-${cmntNo}`);
          if (!box) return;
          box.style.display = (box.style.display === "none" ? "block" : "none");
        }

        // ⚠️ 지금은 임시 writerNo=1 (로그인 연결되면 교체)
        async function submitComment(rcdNo) {
          const input = document.getElementById("commentInput");
          const content = (input.value || "").trim();
          if (!content) return;

          await fetch(`${CTX}/community/travel-log/comments?rcdNo=${rcdNo}&writerNo=1`, {
            method: "POST",
            headers: {"Content-Type":"application/json"},
            body: JSON.stringify({ content })
          });

          input.value = "";
          loadComments(rcdNo);
        }

        async function submitReply(rcdNo, parentCmntNo) {
          const input = document.getElementById(`replyInput-${parentCmntNo}`);
          const content = (input.value || "").trim();
          if (!content) return;

          await fetch(`${CTX}/community/travel-log/comments?rcdNo=${rcdNo}&writerNo=1`, {
            method: "POST",
            headers: {"Content-Type":"application/json"},
            body: JSON.stringify({ content, parentCmntNo })
          });

          loadComments(rcdNo);
        }

        async function deleteComment(cmntNo) {
          await fetch(`${CTX}/community/travel-log/comments/${cmntNo}?writerNo=1`, {
            method: "DELETE"
          });
          loadComments(CURRENT_RCD_NO);
        }

        document.addEventListener("DOMContentLoaded", () => {
          loadComments(CURRENT_RCD_NO);
        });
      </script>
    </c:if>

  </div>
</div>

<%@ include file="../common/footer.jsp"%>
