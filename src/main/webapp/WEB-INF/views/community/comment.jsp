<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div class="comment-section mt-5" id="commentSection" data-board-no="${boardVO.boardNo}">
  <h5 class="mb-3">💬 댓글 <span class="text-muted" id="comment-count">(0)</span></h5>

  <div id="comment-list"></div>

  <div class="mt-4">
    <sec:authorize access="isAnonymous()">
      <textarea id="commentContentAnon" class="form-control mb-2" rows="3"
        placeholder="로그인 후 댓글을 작성할 수 있어요" disabled></textarea>
      <button class="btn btn-primary" type="button" onclick="login()">댓글 등록</button>
    </sec:authorize>

    <sec:authorize access="isAuthenticated()">
      <textarea id="commentContentAuth" class="form-control mb-2" rows="3"
        placeholder="댓글을 입력하세요"></textarea>
 <button type="button" onclick="talkSubmitComment(event)">댓글 등록</button>

    </sec:authorize>
  </div>
</div>

<script>
const BOARD_NO = '${boardVO.boardNo}';  // ✅ JSP가 41로 치환해줌

function talkSubmitComment(e){
  if(e) e.preventDefault();

  const boardNo = (BOARD_NO || '').trim();
  console.log("BOARD_NO =", boardNo);

  if(!boardNo){
    alert("boardNo 비었음! boardVO.boardNo 모델 확인");
    return;
  }

  const ta = document.getElementById("commentContentAuth");
  const content = (ta?.value || "").trim();
	console.log("content : " + content)
  if(!content){
    alert("댓글을 입력하세요");
    ta?.focus();
    return;
  }

  const url = `/api/talk/\${boardNo}/comments`;
  console.log("POST URL =", url);

  fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ cmntContent: content })
  })
  .then(async (res) => {
    if(!res.ok){
      const msg = await res.text().catch(()=> "");
      alert("댓글 등록 실패: " + res.status + "\n" + msg);
      return;
    }
    ta.value = "";
    if (typeof talkLoadComments === "function") talkLoadComments();
    if (typeof loadComments === "function") loadComments();
  });
}

window.talkSubmitComment = talkSubmitComment;
</script>






