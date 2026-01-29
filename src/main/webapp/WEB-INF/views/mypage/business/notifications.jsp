<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<c:set var="pageTitle" value="알림 내역" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../../common/header.jsp" %>
<style>

.mypage .notification-list .notification-item { display:flex; align-items:center; gap:16px; }
.mypage .notification-list .notification-content { flex:1; min-width:0; }
.mypage .notification-list .notification-content p { overflow-wrap:anywhere; word-break:break-word; }


</style>
<div class="mypage business-mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>알림 내역</h1>
                    <p>예약, 후기, 문의 등 알림을 확인하세요</p>
                </div>

                <!-- 탭 & 버튼 -->
                <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                    <div class="mypage-tabs mb-0">
                        <button class="mypage-tab active" data-type="all">전체</button>
                        <button class="mypage-tab" data-type="payment">결제</button>
                        <button class="mypage-tab" data-type="inquiry">문의</button>
                        <button class="mypage-tab" data-type="travel_log">여행기록</button>
                        <button class="mypage-tab" data-type="talk">여행톡</button>
                    </div>
                    <div class="d-flex gap-2">
                        <button class="btn btn-outline btn-sm" onclick="markAllRead()">
                            <i class="bi bi-check2-all me-2"></i>모두 읽음
                        </button>
                        <button class="btn btn-outline btn-sm text-danger" onclick="deleteAllNotifications()">
                            <i class="bi bi-trash me-2"></i>전체 삭제
                        </button>
                    </div>
                </div>

                <!-- 선택 액션 바 -->
                <div class="notification-selection-bar">
                    <div class="selection-left">
                        <label class="select-all-checkbox">
                            <input type="checkbox" id="selectAllNotifications" onchange="toggleSelectAllNotifications()">
                            <span>전체 선택</span>
                        </label>
                        <span class="selected-count" id="selectedNotificationCount">0개 선택됨</span>
                    </div>
                    <div class="selection-actions" id="notificationSelectionActions">
                        <button class="btn btn-primary btn-sm" onclick="markSelectedRead()">
                            <i class="bi bi-check2 me-1"></i>선택 읽음
                        </button>
                        <button class="btn btn-outline btn-sm text-danger" onclick="deleteSelectedNotifications()">
                            <i class="bi bi-trash me-1"></i>선택 삭제
                        </button>
                    </div>
                </div>

                <!-- 알림 목록 -->
                <div class="content-section">
                    <div class="notification-list">
                        <c:choose>
						    <c:when test="${empty alarmList}">
						      <div class="notification-item" data-type="${filterType}">
						        <div class="notification-content">
						          <h4>알림이 없습니다</h4>
						          <p>새로운 알림이 들어오면 여기에 표시됩니다.</p>
						        </div>
						      </div>
						    </c:when>
						
						    <c:otherwise>
						     <c:forEach items="${alarmList}" var="alarm">
							   <c:set value="" var="icon"/>
							   <c:set value="" var="type"/>
							    <c:set value="" var="color"/>
							    <c:set value="" var="filterType"/>
							   <c:choose>
							       <c:when test="${alarm.alarmType eq 'PAYMENT' }">
							         <c:set value="결제" var="type"/>
							         <c:set value="payment" var="filterType"/>
                        					<c:choose>
                        						<c:when test="${fn:contains(alarm.alarmCont, '완료') }">
		                        					<c:set value="bi bi-check-circle" var="icon"/>
                        							<c:set value="payment" var="color"/>
                        						</c:when>
                        						<c:otherwise>
                        							<c:set value="bi bi-x-circle" var="icon"/>
                        							<c:set value="payment cancel" var="color"/>
                        						</c:otherwise>
                        				</c:choose>
							    </c:when>
							  		<c:when test="${alarm.alarmType eq 'TRAVEL_LOG' }">
                        					<c:set value="여행기록" var="type"/>
                        					<c:set value="travel_log" var="filterType"/>
                        					<c:set value="bi bi-record-btn-fill" var="icon"/>
                        				</c:when>
                        				<c:when test="${alarm.alarmType eq 'TALK' }">
                        				<c:set value="여행톡" var="type"/>
                        				<c:set value="talk" var="filterType"/>
                        					<c:set value="bi bi-chat-text-fill" var="icon"/>                        				
                        				</c:when>
                        				<c:when test="${alarm.alarmType eq 'INQUIRY' or alarm.alarmType eq 'PROD_INQUIRY' }">
                        					<c:set value="문의" var="type"/>
                        					<c:set value="inquiry" var="filterType"/>
                        					<c:set value="bi bi-question-circle" var="icon"/>
                        				</c:when>
                        				<c:when test="${alarm.alarmType eq 'REVIEW' }">
                        					<c:set value="리뷰" var="type"/>
                        					
                        					<c:set value="bi bi-chat-left-quote" var="icon"/>
                        				</c:when>
                        				<c:when test="${alarm.alarmType eq 'PROD' }">
                        					<c:set value="상품" var="type"/>
                        					<c:set value="bi bi-calendar-event" var="icon"/>
                        				</c:when>
                        				<c:when test="${alarm.alarmType eq 'SETTLEMENT' }">
                        					<c:set value="정산" var="type"/>
                        					<c:set value="bi bi-cash" var="icon"/>
                        				</c:when>
                        				<c:when test="${alarm.alarmType eq 'REPORT' }">
                        					<c:set value="신고" var="type"/>
                        					<c:set value="bi bi-receipt" var="icon"/>
                        				</c:when>
                        			</c:choose>
			                        <div class="notification-item" data-type="${filterType}">
			                            <label class="notification-checkbox">
			                                <input type="checkbox" class="notification-select" onchange="updateNotificationSelectedCount()">
			                            </label>
			                            <div class="notification-icon ${color }">
			                                <i class="${icon }"></i>
			                            </div>
			                            <div class="notification-content">
			                                <h4>${alarm.alarmCont }</h4>
			                                <p><strong>${type }</strong></p>
			                            </div>
			                            <span class="notification-time">${alarm.regDtStr }</span>
			                        </div>
                        		</c:forEach>
                        	</c:otherwise>
                        </c:choose>
              		 </div>

                <!-- 페이지네이션 -->
              <div class="pagination-container">
  <nav>
    <ul class="pagination">
      <c:if test="${pagingVO.startPage > 1}">
        <li class="page-item">
          <a class="page-link"
             href="?type=${type}&page=${pagingVO.startPage - pagingVO.blockSize}">
            <i class="bi bi-chevron-left"></i>
          </a>
        </li>
      </c:if>

      <c:forEach var="p" begin="${pagingVO.startPage}"
                 end="${pagingVO.endPage < pagingVO.totalPage ? pagingVO.endPage : pagingVO.totalPage}">
        <li class="page-item ${p == pagingVO.currentPage ? 'active' : ''}">
          <a class="page-link" href="?type=${type}&page=${p}">${p}</a>
        </li>
      </c:forEach>

      <c:if test="${pagingVO.endPage < pagingVO.totalPage}">
        <li class="page-item">
          <a class="page-link" href="?type=${type}&page=${pagingVO.endPage + 1}">
            <i class="bi bi-chevron-right"></i>
          </a>
        </li>
      </c:if>
    </ul>
  </nav>
</div>

                   
            </div>
        </div>
    </div>
</div>

<c:set var="pageJs" value="mypage" />
<c:set var="hasInlineScript" value="true" />
<%@ include file="../../common/footer.jsp" %>

<script>
// 탭 필터링
document.querySelectorAll('.mypage-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        document.querySelectorAll('.mypage-tab').forEach(t => t.classList.remove('active'));
        this.classList.add('active');

        const type = this.dataset.type;
        const notifications = document.querySelectorAll('.notification-item');

        notifications.forEach(notification => {
            if (type === 'all') {
                notification.style.display = 'flex';
            } else {
                const notificationType = notification.dataset.type;
                notification.style.display = notificationType === type ? 'flex' : 'none';
            }
        });

        // 탭 변경 시 선택 초기화
        document.querySelectorAll('.notification-select').forEach(cb => cb.checked = false);
        document.getElementById('selectAllNotifications').checked = false;
        updateNotificationSelectedCount();
    });
});

// 전체 선택
function toggleSelectAllNotifications() {
    const selectAll = document.getElementById('selectAllNotifications');
    const checkboxes = document.querySelectorAll('.notification-item:not([style*="display: none"]) .notification-select');

    checkboxes.forEach(cb => {
        cb.checked = selectAll.checked;
    });

    updateNotificationSelectedCount();
}

// 선택 개수 업데이트
function updateNotificationSelectedCount() {
    const checkedCount = document.querySelectorAll('.notification-select:checked').length;
    const totalCount = document.querySelectorAll('.notification-item:not([style*="display: none"]) .notification-select').length;

    document.getElementById('selectedNotificationCount').textContent = checkedCount + '개 선택됨';

    // 액션 버튼 활성화/비활성화
    const selectionActions = document.getElementById('notificationSelectionActions');
    if (checkedCount > 0) {
        selectionActions.classList.add('active');
    } else {
        selectionActions.classList.remove('active');
    }

    // 전체 선택 체크박스 상태 업데이트
    const selectAll = document.getElementById('selectAllNotifications');
    if (checkedCount === 0) {
        selectAll.checked = false;
        selectAll.indeterminate = false;
    } else if (checkedCount === totalCount) {
        selectAll.checked = true;
        selectAll.indeterminate = false;
    } else {
        selectAll.checked = false;
        selectAll.indeterminate = true;
    }
}

// 선택 읽음 처리
function markSelectedRead() {
    const checkedItems = document.querySelectorAll('.notification-select:checked');

    if (checkedItems.length === 0) {
        showToast('선택된 알림이 없습니다.', 'warning');
        return;
    }

    checkedItems.forEach(cb => {
        const item = cb.closest('.notification-item');
        item.classList.remove('unread');
        cb.checked = false;
    });

    document.getElementById('selectAllNotifications').checked = false;
    updateNotificationSelectedCount();
    showToast(checkedItems.length + '개의 알림을 읽음으로 표시했습니다.', 'success');
}

// 선택 삭제
function deleteSelectedNotifications() {
    const checkedItems = document.querySelectorAll('.notification-select:checked');

    if (checkedItems.length === 0) {
        showToast('선택된 알림이 없습니다.', 'warning');
        return;
    }

    if (confirm(checkedItems.length + '개의 알림을 삭제하시겠습니까?')) {
        checkedItems.forEach(cb => {
            const item = cb.closest('.notification-item');
            item.remove();
        });

        document.getElementById('selectAllNotifications').checked = false;
        updateNotificationSelectedCount();
        showToast(checkedItems.length + '개의 알림이 삭제되었습니다.', 'info');
    }
}

// 모두 읽음
function markAllRead() {
    document.querySelectorAll('.notification-item.unread').forEach(item => {
        item.classList.remove('unread');
    });
    showToast('모든 알림을 읽음으로 표시했습니다.', 'success');
}

// 전체 삭제
function deleteAllNotifications() {
    if (confirm('모든 알림을 삭제하시겠습니까?')) {
        document.querySelectorAll('.notification-item').forEach(item => {
            item.remove();
        });
        updateNotificationSelectedCount();
        showToast('모든 알림이 삭제되었습니다.', 'info');
    }
}
<!-- ✅ 알림 실시간(뱃지) + 클릭 읽음처리 (애니메이션 제거/중복인터벌 방지/안전파싱) -->
(function(){
  if (typeof isLoggedIn !== 'undefined' && !isLoggedIn) return;

  const contextPath = '${pageContext.request.contextPath}';
  const api = (p) => contextPath + (p.startsWith('/') ? p : '/' + p);

  const badge = document.getElementById('notificationBadge');

  function setBadge(cnt){
    if(!badge) return;
    const n = Number(cnt);
    if(Number.isFinite(n) && n > 0){
      badge.textContent = n > 99 ? '99+' : String(n);
      badge.style.display = 'inline-block';
    }else{
      badge.style.display = 'none';
    }
  }

  async function fetchUnreadCount(){
    const res = await fetch(api('/api/alarm/unread-count'), { credentials:'same-origin' });

    const ct = (res.headers.get('content-type') || '').toLowerCase();
    if(!res.ok) return 0;
    if(!ct.includes('application/json')) return 0;

    const data = await res.json();
    const n = Number(data);
    return Number.isFinite(n) ? n : 0;
  }

  async function tick(){
    try{
      const cnt = await fetchUnreadCount();
      setBadge(cnt);
    }catch(e){
      setBadge(0);
    }
  }

  // ✅ 헤더가 중복 include 되는 경우 대비: interval 중복 생성 방지
  if (window.__alarmTickTimer) {
    clearInterval(window.__alarmTickTimer);
    window.__alarmTickTimer = null;
  }

  tick();
  window.__alarmTickTimer = setInterval(tick, 30000);

  // ✅ 알림 아이템 클릭: 읽음 처리 + 이동
  document.addEventListener('click', async (e)=>{
    const item = e.target.closest('.alarm-item');
    if(!item) return;

    const alarmNo = Number(item.dataset.alarmNo || 0);
    const moveUrl = item.dataset.moveUrl || '';

    if(alarmNo){
      try{
        await fetch(api('/api/alarm/read'), {
          method:'POST',
          headers:{'Content-Type':'application/json'},
          body: JSON.stringify({ alarmNo })
        });
        item.classList.remove('unread');
        tick();
      }catch(err){
        // 조용히 무시
      }
    }

    if(moveUrl){
      location.href = contextPath + moveUrl;
    }
  });
})();
</script>
</body>

</html>
