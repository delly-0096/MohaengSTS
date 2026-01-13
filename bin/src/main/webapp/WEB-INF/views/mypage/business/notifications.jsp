<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="알림 내역" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../../common/header.jsp" %>

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
                        <!-- 읽지 않은 알림 -->
                        <div class="notification-item unread" data-type="order">
                            <label class="notification-checkbox">
                                <input type="checkbox" class="notification-select" onchange="updateNotificationSelectedCount()">
                            </label>
                            <div class="notification-icon order">
                                <i class="bi bi-cart-check"></i>
                            </div>
                            <div class="notification-content">
                                <h4>새 예약이 들어왔습니다</h4>
                                <p><strong>제주 스쿠버다이빙 체험</strong> - 김OO님 (2명) / 2024.04.20 14:00</p>
                            </div>
                            <span class="notification-time">10분 전</span>
                        </div>

                        <div class="notification-item unread" data-type="review">
                            <label class="notification-checkbox">
                                <input type="checkbox" class="notification-select" onchange="updateNotificationSelectedCount()">
                            </label>
                            <div class="notification-icon review">
                                <i class="bi bi-star"></i>
                            </div>
                            <div class="notification-content">
                                <h4>새 후기가 등록되었습니다</h4>
                                <p><strong>한라산 트레킹 투어</strong> - 이OO님이 5점을 주셨습니다. "정말 좋은 경험이었어요!"</p>
                            </div>
                            <span class="notification-time">1시간 전</span>
                        </div>

                        <div class="notification-item unread" data-type="inquiry">
                            <label class="notification-checkbox">
                                <input type="checkbox" class="notification-select" onchange="updateNotificationSelectedCount()">
                            </label>
                            <div class="notification-icon inquiry">
                                <i class="bi bi-chat-dots"></i>
                            </div>
                            <div class="notification-content">
                                <h4>문의가 접수되었습니다</h4>
                                <p><strong>제주 서핑 레슨</strong> - 박OO님: "당일 예약도 가능한가요?"</p>
                            </div>
                            <span class="notification-time">3시간 전</span>
                        </div>

                        <!-- 읽은 알림 -->
                        <div class="notification-item" data-type="order">
                            <label class="notification-checkbox">
                                <input type="checkbox" class="notification-select" onchange="updateNotificationSelectedCount()">
                            </label>
                            <div class="notification-icon order">
                                <i class="bi bi-cart-check"></i>
                            </div>
                            <div class="notification-content">
                                <h4>예약이 확정되었습니다</h4>
                                <p><strong>제주 스쿠버다이빙 체험</strong> - 최OO님 (3명) / 2024.03.18 10:00</p>
                            </div>
                            <span class="notification-time">어제</span>
                        </div>

                        <div class="notification-item" data-type="order">
                            <label class="notification-checkbox">
                                <input type="checkbox" class="notification-select" onchange="updateNotificationSelectedCount()">
                            </label>
                            <div class="notification-icon order">
                                <i class="bi bi-x-circle"></i>
                            </div>
                            <div class="notification-content">
                                <h4>예약이 취소되었습니다</h4>
                                <p><strong>우도 자전거 투어</strong> - 정OO님 / 취소 사유: 일정 변경</p>
                            </div>
                            <span class="notification-time">어제</span>
                        </div>

                        <div class="notification-item" data-type="review">
                            <label class="notification-checkbox">
                                <input type="checkbox" class="notification-select" onchange="updateNotificationSelectedCount()">
                            </label>
                            <div class="notification-icon review">
                                <i class="bi bi-star"></i>
                            </div>
                            <div class="notification-content">
                                <h4>후기에 답글을 남겨주세요</h4>
                                <p><strong>제주 서핑 레슨</strong> - 강OO님의 후기에 아직 답글이 없습니다.</p>
                            </div>
                            <span class="notification-time">2일 전</span>
                        </div>

                        <div class="notification-item" data-type="system">
                            <label class="notification-checkbox">
                                <input type="checkbox" class="notification-select" onchange="updateNotificationSelectedCount()">
                            </label>
                            <div class="notification-icon system">
                                <i class="bi bi-gear"></i>
                            </div>
                            <div class="notification-content">
                                <h4>2월 정산이 완료되었습니다</h4>
                                <p>정산 금액 <strong>2,850,000원</strong>이 등록된 계좌로 입금되었습니다.</p>
                            </div>
                            <span class="notification-time">2024.03.05</span>
                        </div>

                        <div class="notification-item" data-type="system">
                            <label class="notification-checkbox">
                                <input type="checkbox" class="notification-select" onchange="updateNotificationSelectedCount()">
                            </label>
                            <div class="notification-icon system">
                                <i class="bi bi-megaphone"></i>
                            </div>
                            <div class="notification-content">
                                <h4>[공지] 서비스 점검 안내</h4>
                                <p>2024년 3월 20일 02:00~06:00 서비스 점검이 예정되어 있습니다.</p>
                            </div>
                            <span class="notification-time">2024.03.01</span>
                        </div>

                        <div class="notification-item" data-type="system">
                            <label class="notification-checkbox">
                                <input type="checkbox" class="notification-select" onchange="updateNotificationSelectedCount()">
                            </label>
                            <div class="notification-icon system">
                                <i class="bi bi-check-circle"></i>
                            </div>
                            <div class="notification-content">
                                <h4>상품이 승인되었습니다</h4>
                                <p><strong>제주 서핑 레슨</strong> 상품이 승인되어 판매가 시작되었습니다.</p>
                            </div>
                            <span class="notification-time">2024.02.28</span>
                        </div>

                        <div class="notification-item" data-type="inquiry">
                            <label class="notification-checkbox">
                                <input type="checkbox" class="notification-select" onchange="updateNotificationSelectedCount()">
                            </label>
                            <div class="notification-icon inquiry">
                                <i class="bi bi-chat-dots"></i>
                            </div>
                            <div class="notification-content">
                                <h4>문의 답변이 완료되었습니다</h4>
                                <p><strong>한라산 트레킹 투어</strong> 문의에 답변을 남기셨습니다.</p>
                            </div>
                            <span class="notification-time">2024.02.25</span>
                        </div>
                    </div>
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
