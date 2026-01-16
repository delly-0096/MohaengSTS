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
      <button class="btn btn-primary" type="button" onclick="submitComment()">댓글 등록</button>
    </sec:authorize>
  </div>
</div>

<script>
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

  const root = document.getElementById("comment-list");
  root.innerHTML = "";

  list.forEach(c => {
    const isReply = (c.depth && c.depth > 0);

    const writer = c.writerNickname ? c.writerNickname : "익명";
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

    if(!isReply){
      html += '<div class="mt-2">';
      html += '  <button class="btn btn-sm btn-link" type="button" onclick="toggleReplyForm(' + c.cmntNo + ')">답글</button>';
      html += '</div>';

      html += '<div id="replyForm-' + c.cmntNo + '" class="mt-2 d-none">';
      html += '  <textarea id="replyContent-' + c.cmntNo + '" class="form-control mb-2" rows="2" placeholder="답글을 입력하세요"></textarea>';
      html += '  <button class="btn btn-sm btn-primary" type="button" onclick="submitReply(' + c.cmntNo + ')">등록</button>';
      html += '</div>';
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

  const res = await fetch(`/api/talk/${boardNo}/comments`, {
    method: "POST",
    headers: {"Content-Type":"application/json"},
    body: JSON.stringify({ content, parentCmntNo })
  });

  if(!res.ok){ alert("답글 등록 실패"); return; }

  await loadComments();
}

function login(){
  location.href = "/login";
}

document.addEventListener("DOMContentLoaded", loadComments);
</script>

