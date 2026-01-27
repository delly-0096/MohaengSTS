<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<c:set var="pageTitle" value="알림 내역" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../../common/header.jsp" %>
<style>
.notification-time{
  flex: 0 0 140px; /* 180 -> 140 줄이기 */
  text-align:right;
  white-space:nowrap;
  font-size: 12px;
  color:#888;
}

.notification-time{
  flex: 0 0 140px;
  text-align:right;
  white-space: normal;   /* 줄바꿈 허용 */
  word-break: break-word;
}
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
                        <button class="mypage-tab" data-type="order">예약</button>
                        <button class="mypage-tab" data-type="review">후기</button>
                        <button class="mypage-tab" data-type="inquiry">문의</button>
                        <button class="mypage-tab" data-type="system">시스템</button>
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
						      <div class="notification-item">
						        <div class="notification-content">
						          <h4>알림이 없습니다</h4>
						          <p>새로운 알림이 들어오면 여기에 표시됩니다.</p>
						        </div>
						      </div>
						    </c:when>
						
						    <c:otherwise>
						     <c:forEach items="${alarmList}" var="a">
							
							  <%-- ✅ 1) type 먼저 계산 --%>
							  <c:set var="type" value="system" />
							  <c:if test="${not empty a.alarmType}">
							    <c:choose>
							      <c:when test="${fn:contains(a.alarmType,'RESV') || fn:contains(a.alarmType,'ORDER')}">
							        <c:set var="type" value="order" />
							      </c:when>
							      <c:when test="${fn:contains(a.alarmType,'REVIEW')}">
							        <c:set var="type" value="review" />
							      </c:when>
							      <c:when test="${fn:contains(a.alarmType,'INQRY') || fn:contains(a.alarmType,'QNA')}">
							        <c:set var="type" value="inquiry" />
							      </c:when>
							    </c:choose>
							  </c:if>
							
							  <%-- ✅ 2) 이제 div를 열기 (data-type 정확히 들어감) --%>
							  <div class="notification-item ${a.readYn eq 'Y' ? '' : 'unread'}"
							       data-type="${type}">
							
							    <label class="notification-checkbox">
							      <input type="checkbox" class="notification-select" onchange="updateNotificationSelectedCount()">
							    </label>
							
							    <%-- ✅ icon도 type 기반으로 클래스 부여 --%>
							    <div class="notification-icon ${type}">
							      <c:choose>
							        <c:when test="${type eq 'order'}"><i class="bi bi-cart-check"></i></c:when>
							        <c:when test="${type eq 'review'}"><i class="bi bi-star"></i></c:when>
							        <c:when test="${type eq 'inquiry'}"><i class="bi bi-chat-dots"></i></c:when>
							        <c:otherwise><i class="bi bi-bell"></i></c:otherwise>
							      </c:choose>
							    </div>
							
							    <div class="notification-content">
							      <h4>${a.sender}</h4>
							      <p>${a.alarmCont}</p>
							    </div>
							
							    <span class="notification-time">
							      <c:out value="${a.regDt}" />
							    </span>
							  </div>
							
							</c:forEach>

						    </c:otherwise>
						  </c:choose>
						
						</div>
						
                <!-- 페이지네이션 -->
                <div class="pagination-container">
                    <nav>
                        <ul class="pagination">
                            <li class="page-item">
                                <a class="page-link" href="#"><i class="bi bi-chevron-left"></i></a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">3</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a>
                            </li>
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
</script>
</body>

</html>
