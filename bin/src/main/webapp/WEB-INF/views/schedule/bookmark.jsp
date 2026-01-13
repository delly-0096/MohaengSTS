<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="내 북마크" />
<c:set var="pageCss" value="schedule" />

<%@ include file="../common/header.jsp" %>

<div class="bookmark-page">
    <div class="container">
        <!-- 페이지 헤더 -->
        <div class="section-header" style="text-align: left; margin-bottom: 32px;">
            <div>
                <h1 class="section-title" style="margin-bottom: 8px;">
                    <i class="bi bi-bookmark-heart me-2"></i>내 북마크
                </h1>
                <p class="section-subtitle" style="margin: 0;">관심있는 일정과 장소, 상품을 모아보세요</p>
            </div>
        </div>

        <!-- 탭 메뉴 -->
        <div class="bookmark-tabs mb-4">
            <ul class="nav nav-pills gap-2">
                <li class="nav-item">
                    <a class="nav-link active" href="#" data-tab="schedules">
                        <i class="bi bi-calendar3 me-2"></i>일정 <span class="badge bg-primary ms-1">3</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-tab="places">
                        <i class="bi bi-geo-alt me-2"></i>장소 <span class="badge bg-primary ms-1">12</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-tab="products">
                        <i class="bi bi-bag me-2"></i>상품 <span class="badge bg-primary ms-1">5</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- 선택 삭제 툴바 -->
        <div class="selection-toolbar" id="selectionToolbar">
            <div class="selection-toolbar-left">
                <label class="select-all-checkbox">
                    <input type="checkbox" id="selectAllCheckbox" onchange="toggleSelectAll()">
                    <span>전체 선택</span>
                </label>
                <span class="selected-count" id="selectedCount">0개 선택됨</span>
            </div>
            <div class="selection-toolbar-right">
                <button class="btn btn-outline btn-sm" onclick="cancelSelection()">
                    <i class="bi bi-x-lg me-1"></i>선택 취소
                </button>
                <button class="btn btn-danger btn-sm" id="deleteSelectedBtn" onclick="deleteSelectedBookmarks()" disabled>
                    <i class="bi bi-trash me-1"></i>선택 삭제
                </button>
            </div>
        </div>

        <!-- 일정 북마크 -->
        <div class="bookmark-content" id="bookmarkSchedules">
            <div class="schedule-grid">
                <!-- 일정 1 -->
                <div class="schedule-card" data-id="schedule-1">
                    <label class="card-checkbox">
                        <input type="checkbox" onchange="updateSelection()">
                        <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                    </label>
                    <div class="schedule-card-image">
                        <img src="https://images.unsplash.com/photo-1590650046871-92c887180603?w=400&h=300&fit=crop&q=80" alt="제주도">
                        <button class="schedule-card-bookmark active" onclick="removeBookmark(this, 'schedule', 1)">
                            <i class="bi bi-bookmark-fill"></i>
                        </button>
                    </div>
                    <div class="schedule-card-body">
                        <h3 class="schedule-card-title">제주도 3박4일 힐링 코스</h3>
                        <div class="schedule-card-dates">
                            <i class="bi bi-calendar3"></i>
                            <span>3박 4일 코스</span>
                        </div>
                        <div class="schedule-card-places">
                            <span class="place-tag">성산일출봉</span>
                            <span class="place-tag">우도</span>
                            <span class="place-tag">+5</span>
                        </div>
                        <div class="schedule-card-meta">
                            <span><i class="bi bi-heart-fill text-danger"></i> 1.2K</span>
                            <span><i class="bi bi-eye"></i> 5.4K</span>
                        </div>
                    </div>
                    <div class="schedule-card-footer">
                        <a href="${pageContext.request.contextPath}/schedule/view/1" class="btn btn-outline btn-sm">
                            상세보기
                        </a>
                        <a href="${pageContext.request.contextPath}/schedule/planner?copy=1" class="btn btn-primary btn-sm">
                            내 일정으로 복사
                        </a>
                    </div>
                </div>

                <!-- 일정 2 -->
                <div class="schedule-card" data-id="schedule-2">
                    <label class="card-checkbox">
                        <input type="checkbox" onchange="updateSelection()">
                        <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                    </label>
                    <div class="schedule-card-image">
                        <img src="https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=400&h=300&fit=crop&q=80" alt="오사카">
                        <button class="schedule-card-bookmark active" onclick="removeBookmark(this, 'schedule', 2)">
                            <i class="bi bi-bookmark-fill"></i>
                        </button>
                    </div>
                    <div class="schedule-card-body">
                        <h3 class="schedule-card-title">오사카 먹방 여행 4일</h3>
                        <div class="schedule-card-dates">
                            <i class="bi bi-calendar3"></i>
                            <span>3박 4일 코스</span>
                        </div>
                        <div class="schedule-card-places">
                            <span class="place-tag">도톤보리</span>
                            <span class="place-tag">구로몬시장</span>
                            <span class="place-tag">+8</span>
                        </div>
                        <div class="schedule-card-meta">
                            <span><i class="bi bi-heart-fill text-danger"></i> 892</span>
                            <span><i class="bi bi-eye"></i> 3.1K</span>
                        </div>
                    </div>
                    <div class="schedule-card-footer">
                        <a href="${pageContext.request.contextPath}/schedule/view/2" class="btn btn-outline btn-sm">
                            상세보기
                        </a>
                        <a href="${pageContext.request.contextPath}/schedule/planner?copy=2" class="btn btn-primary btn-sm">
                            내 일정으로 복사
                        </a>
                    </div>
                </div>

                <!-- 일정 3 -->
                <div class="schedule-card" data-id="schedule-3">
                    <label class="card-checkbox">
                        <input type="checkbox" onchange="updateSelection()">
                        <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                    </label>
                    <div class="schedule-card-image">
                        <img src="https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400&h=300&fit=crop&q=80" alt="파리">
                        <button class="schedule-card-bookmark active" onclick="removeBookmark(this, 'schedule', 3)">
                            <i class="bi bi-bookmark-fill"></i>
                        </button>
                    </div>
                    <div class="schedule-card-body">
                        <h3 class="schedule-card-title">파리 로맨틱 여행 5일</h3>
                        <div class="schedule-card-dates">
                            <i class="bi bi-calendar3"></i>
                            <span>4박 5일 코스</span>
                        </div>
                        <div class="schedule-card-places">
                            <span class="place-tag">에펠탑</span>
                            <span class="place-tag">루브르 박물관</span>
                            <span class="place-tag">+10</span>
                        </div>
                        <div class="schedule-card-meta">
                            <span><i class="bi bi-heart-fill text-danger"></i> 2.3K</span>
                            <span><i class="bi bi-eye"></i> 8.7K</span>
                        </div>
                    </div>
                    <div class="schedule-card-footer">
                        <a href="${pageContext.request.contextPath}/schedule/view/3" class="btn btn-outline btn-sm">
                            상세보기
                        </a>
                        <a href="${pageContext.request.contextPath}/schedule/planner?copy=3" class="btn btn-primary btn-sm">
                            내 일정으로 복사
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- 장소 북마크 -->
        <div class="bookmark-content" id="bookmarkPlaces" style="display: none;">
            <div class="places-grid">
                <!-- 장소 1 -->
                <div class="place-card" data-id="place-1">
                    <label class="card-checkbox">
                        <input type="checkbox" onchange="updateSelection()">
                        <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                    </label>
                    <div class="place-card-image">
                        <img src="https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&h=300&fit=crop&q=80" alt="성산일출봉">
                        <button class="place-card-bookmark active" onclick="removeBookmark(this, 'place', 1)">
                            <i class="bi bi-bookmark-fill"></i>
                        </button>
                    </div>
                    <div class="place-card-body">
                        <span class="place-card-category">자연/경관</span>
                        <h4 class="place-card-title">성산일출봉</h4>
                        <p class="place-card-location"><i class="bi bi-geo-alt"></i> 제주 서귀포시</p>
                        <div class="place-card-rating">
                            <i class="bi bi-star-fill text-warning"></i>
                            <span>4.8</span>
                            <span class="text-muted">(2,341)</span>
                        </div>
                    </div>
                </div>

                <!-- 장소 2 -->
                <div class="place-card" data-id="place-2">
                    <label class="card-checkbox">
                        <input type="checkbox" onchange="updateSelection()">
                        <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                    </label>
                    <div class="place-card-image">
                        <img src="https://images.unsplash.com/photo-1545569341-9eb8b30979d9?w=400&h=300&fit=crop&q=80" alt="후시미이나리">
                        <button class="place-card-bookmark active" onclick="removeBookmark(this, 'place', 2)">
                            <i class="bi bi-bookmark-fill"></i>
                        </button>
                    </div>
                    <div class="place-card-body">
                        <span class="place-card-category">명소/관광</span>
                        <h4 class="place-card-title">후시미이나리 신사</h4>
                        <p class="place-card-location"><i class="bi bi-geo-alt"></i> 교토, 일본</p>
                        <div class="place-card-rating">
                            <i class="bi bi-star-fill text-warning"></i>
                            <span>4.9</span>
                            <span class="text-muted">(5,672)</span>
                        </div>
                    </div>
                </div>

                <!-- 장소 3 -->
                <div class="place-card" data-id="place-3">
                    <label class="card-checkbox">
                        <input type="checkbox" onchange="updateSelection()">
                        <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                    </label>
                    <div class="place-card-image">
                        <img src="https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?w=400&h=300&fit=crop&q=80" alt="도톤보리">
                        <button class="place-card-bookmark active" onclick="removeBookmark(this, 'place', 3)">
                            <i class="bi bi-bookmark-fill"></i>
                        </button>
                    </div>
                    <div class="place-card-body">
                        <span class="place-card-category">맛집/거리</span>
                        <h4 class="place-card-title">도톤보리</h4>
                        <p class="place-card-location"><i class="bi bi-geo-alt"></i> 오사카, 일본</p>
                        <div class="place-card-rating">
                            <i class="bi bi-star-fill text-warning"></i>
                            <span>4.7</span>
                            <span class="text-muted">(8,923)</span>
                        </div>
                    </div>
                </div>

                <!-- 장소 4 -->
                <div class="place-card" data-id="place-4">
                    <label class="card-checkbox">
                        <input type="checkbox" onchange="updateSelection()">
                        <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                    </label>
                    <div class="place-card-image">
                        <img src="https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=400&h=300&fit=crop&q=80" alt="에펠탑">
                        <button class="place-card-bookmark active" onclick="removeBookmark(this, 'place', 4)">
                            <i class="bi bi-bookmark-fill"></i>
                        </button>
                    </div>
                    <div class="place-card-body">
                        <span class="place-card-category">랜드마크</span>
                        <h4 class="place-card-title">에펠탑</h4>
                        <p class="place-card-location"><i class="bi bi-geo-alt"></i> 파리, 프랑스</p>
                        <div class="place-card-rating">
                            <i class="bi bi-star-fill text-warning"></i>
                            <span>4.9</span>
                            <span class="text-muted">(15,234)</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 상품 북마크 -->
        <div class="bookmark-content" id="bookmarkProducts" style="display: none;">
            <div class="products-grid">
                <!-- 상품 1 -->
                <div class="product-card" data-id="product-1">
                    <label class="card-checkbox">
                        <input type="checkbox" onchange="updateSelection()">
                        <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                    </label>
                    <div class="product-card-image">
                        <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=300&fit=crop&q=80" alt="스쿠버다이빙">
                        <button class="product-card-bookmark active" onclick="removeBookmark(this, 'product', 1)">
                            <i class="bi bi-bookmark-fill"></i>
                        </button>
                    </div>
                    <div class="product-card-body">
                        <span class="product-card-category">액티비티</span>
                        <h4 class="product-card-title">제주 스쿠버다이빙 체험</h4>
                        <p class="product-card-location"><i class="bi bi-geo-alt"></i> 제주 서귀포시</p>
                        <div class="product-card-rating">
                            <i class="bi bi-star-fill text-warning"></i>
                            <span>4.9</span>
                            <span class="text-muted">(328)</span>
                        </div>
                        <div class="product-card-price">
                            <span class="original-price">85,000원</span>
                            <span class="sale-price">68,000원</span>
                        </div>
                    </div>
                    <div class="product-card-footer">
                        <a href="${pageContext.request.contextPath}/product/tour/1" class="btn btn-primary btn-sm w-100">
                            상세보기
                        </a>
                    </div>
                </div>

                <!-- 상품 2 -->
                <div class="product-card" data-id="product-2">
                    <label class="card-checkbox">
                        <input type="checkbox" onchange="updateSelection()">
                        <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                    </label>
                    <div class="product-card-image">
                        <img src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400&h=300&fit=crop&q=80" alt="도쿄타워">
                        <button class="product-card-bookmark active" onclick="removeBookmark(this, 'product', 2)">
                            <i class="bi bi-bookmark-fill"></i>
                        </button>
                    </div>
                    <div class="product-card-body">
                        <span class="product-card-category">티켓</span>
                        <h4 class="product-card-title">도쿄타워 전망대 입장권</h4>
                        <p class="product-card-location"><i class="bi bi-geo-alt"></i> 도쿄, 일본</p>
                        <div class="product-card-rating">
                            <i class="bi bi-star-fill text-warning"></i>
                            <span>4.7</span>
                            <span class="text-muted">(1,234)</span>
                        </div>
                        <div class="product-card-price">
                            <span class="sale-price">15,000원</span>
                        </div>
                    </div>
                    <div class="product-card-footer">
                        <a href="${pageContext.request.contextPath}/product/tour/2" class="btn btn-primary btn-sm w-100">
                            상세보기
                        </a>
                    </div>
                </div>

                <!-- 상품 3 -->
                <div class="product-card" data-id="product-3">
                    <label class="card-checkbox">
                        <input type="checkbox" onchange="updateSelection()">
                        <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                    </label>
                    <div class="product-card-image">
                        <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop&q=80" alt="호텔">
                        <button class="product-card-bookmark active" onclick="removeBookmark(this, 'product', 3)">
                            <i class="bi bi-bookmark-fill"></i>
                        </button>
                    </div>
                    <div class="product-card-body">
                        <span class="product-card-category">숙박</span>
                        <h4 class="product-card-title">제주 신라호텔</h4>
                        <p class="product-card-location"><i class="bi bi-geo-alt"></i> 제주 서귀포시</p>
                        <div class="product-card-rating">
                            <i class="bi bi-star-fill text-warning"></i>
                            <span>4.8</span>
                            <span class="text-muted">(892)</span>
                        </div>
                        <div class="product-card-price">
                            <span class="sale-price">280,000원</span>
                            <span class="text-muted">/박</span>
                        </div>
                    </div>
                    <div class="product-card-footer">
                        <a href="${pageContext.request.contextPath}/product/accommodation/1" class="btn btn-primary btn-sm w-100">
                            상세보기
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- 빈 상태 -->
        <div class="empty-state" id="emptyState" style="display: none;">
            <div class="empty-state-icon">
                <i class="bi bi-bookmark-x"></i>
            </div>
            <h3 class="empty-state-title">북마크가 없습니다</h3>
            <p class="empty-state-desc">마음에 드는 일정, 장소, 상품을 북마크해보세요!</p>
            <a href="${pageContext.request.contextPath}/schedule/search" class="btn btn-primary">
                <i class="bi bi-search me-2"></i>일정 검색하기
            </a>
        </div>
    </div>
</div>

<style>
/* 선택 삭제 툴바 */
.selection-toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 20px;
    background: var(--light-color);
    border-radius: var(--radius-md);
    margin-bottom: 20px;
    border: 1px solid var(--gray-lighter);
}

.selection-toolbar-left {
    display: flex;
    align-items: center;
    gap: 20px;
}

.selection-toolbar-right {
    display: flex;
    gap: 8px;
}

.select-all-checkbox {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    font-weight: 500;
}

.select-all-checkbox input[type="checkbox"] {
    width: 18px;
    height: 18px;
    accent-color: var(--primary-color);
    cursor: pointer;
}

.selected-count {
    color: var(--gray-dark);
    font-size: 14px;
}

/* 카드 체크박스 */
.card-checkbox {
    position: absolute;
    top: 12px;
    left: 12px;
    z-index: 10;
    cursor: pointer;
}

.card-checkbox input[type="checkbox"] {
    display: none;
}

.card-checkbox .checkmark {
    width: 24px;
    height: 24px;
    background: rgba(255, 255, 255, 0.9);
    border: 2px solid var(--gray-light);
    border-radius: 6px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all var(--transition-fast);
}

.card-checkbox .checkmark i {
    color: white;
    font-size: 14px;
    opacity: 0;
    transition: opacity var(--transition-fast);
}

.card-checkbox input:checked + .checkmark {
    background: var(--primary-color);
    border-color: var(--primary-color);
}

.card-checkbox input:checked + .checkmark i {
    opacity: 1;
}

.card-checkbox:hover .checkmark {
    border-color: var(--primary-color);
}

/* 선택된 카드 스타일 */
.schedule-card.selected,
.place-card.selected,
.product-card.selected {
    outline: 3px solid var(--primary-color);
    outline-offset: -3px;
}

/* 카드 상대 위치 설정 */
.schedule-card,
.place-card,
.product-card {
    position: relative;
}

@media (max-width: 576px) {
    .selection-toolbar {
        flex-direction: column;
        gap: 12px;
    }

    .selection-toolbar-left,
    .selection-toolbar-right {
        width: 100%;
        justify-content: center;
    }
}
</style>

<script>
// 탭 전환
document.querySelectorAll('.bookmark-tabs .nav-link').forEach(tab => {
    tab.addEventListener('click', function(e) {
        e.preventDefault();

        // 활성화 상태 변경
        document.querySelectorAll('.bookmark-tabs .nav-link').forEach(t => t.classList.remove('active'));
        this.classList.add('active');

        // 콘텐츠 표시
        const tabName = this.dataset.tab;
        showBookmarkContent(tabName);

        // 탭 전환 시 선택 초기화
        cancelSelection();
    });
});

function showBookmarkContent(tabName) {
    // 모든 콘텐츠 숨기기
    document.querySelectorAll('.bookmark-content').forEach(content => {
        content.style.display = 'none';
    });

    // 선택된 콘텐츠 표시
    const targetId = 'bookmark' + tabName.charAt(0).toUpperCase() + tabName.slice(1);
    const targetContent = document.getElementById(targetId);
    if (targetContent) {
        targetContent.style.display = 'block';
    }
}

// 전체 선택 토글
function toggleSelectAll() {
    var selectAllCheckbox = document.getElementById('selectAllCheckbox');
    var isChecked = selectAllCheckbox.checked;

    // 현재 보이는 탭의 카드들만 선택
    var visibleContent = document.querySelector('.bookmark-content:not([style*="display: none"])');
    if (visibleContent) {
        var checkboxes = visibleContent.querySelectorAll('.card-checkbox input[type="checkbox"]');
        checkboxes.forEach(function(checkbox) {
            checkbox.checked = isChecked;
            var card = checkbox.closest('.schedule-card, .place-card, .product-card');
            if (card) {
                if (isChecked) {
                    card.classList.add('selected');
                } else {
                    card.classList.remove('selected');
                }
            }
        });
    }

    updateSelection();
}

// 선택 상태 업데이트
function updateSelection() {
    var visibleContent = document.querySelector('.bookmark-content:not([style*="display: none"])');
    var selectedCount = 0;
    var totalCount = 0;

    if (visibleContent) {
        var checkboxes = visibleContent.querySelectorAll('.card-checkbox input[type="checkbox"]');
        totalCount = checkboxes.length;

        checkboxes.forEach(function(checkbox) {
            var card = checkbox.closest('.schedule-card, .place-card, .product-card');
            if (checkbox.checked) {
                selectedCount++;
                if (card) card.classList.add('selected');
            } else {
                if (card) card.classList.remove('selected');
            }
        });
    }

    // 선택 개수 표시
    document.getElementById('selectedCount').textContent = selectedCount + '개 선택됨';

    // 전체 선택 체크박스 상태 업데이트
    var selectAllCheckbox = document.getElementById('selectAllCheckbox');
    if (totalCount > 0 && selectedCount === totalCount) {
        selectAllCheckbox.checked = true;
        selectAllCheckbox.indeterminate = false;
    } else if (selectedCount > 0) {
        selectAllCheckbox.checked = false;
        selectAllCheckbox.indeterminate = true;
    } else {
        selectAllCheckbox.checked = false;
        selectAllCheckbox.indeterminate = false;
    }

    // 삭제 버튼 활성화/비활성화
    var deleteBtn = document.getElementById('deleteSelectedBtn');
    deleteBtn.disabled = selectedCount === 0;
}

// 선택 취소
function cancelSelection() {
    var checkboxes = document.querySelectorAll('.card-checkbox input[type="checkbox"]');
    checkboxes.forEach(function(checkbox) {
        checkbox.checked = false;
        var card = checkbox.closest('.schedule-card, .place-card, .product-card');
        if (card) card.classList.remove('selected');
    });

    document.getElementById('selectAllCheckbox').checked = false;
    document.getElementById('selectAllCheckbox').indeterminate = false;
    updateSelection();
}

// 선택된 북마크 삭제
function deleteSelectedBookmarks() {
    var visibleContent = document.querySelector('.bookmark-content:not([style*="display: none"])');
    if (!visibleContent) return;

    var selectedCards = visibleContent.querySelectorAll('.schedule-card.selected, .place-card.selected, .product-card.selected');

    if (selectedCards.length === 0) {
        showToast('선택된 북마크가 없습니다.', 'warning');
        return;
    }

    if (!confirm(selectedCards.length + '개의 북마크를 삭제하시겠습니까?')) {
        return;
    }

    selectedCards.forEach(function(card, index) {
        setTimeout(function() {
            card.style.transition = 'all 0.3s ease';
            card.style.opacity = '0';
            card.style.transform = 'scale(0.8)';

            setTimeout(function() {
                // 카드 타입 확인
                var type = 'schedule';
                if (card.classList.contains('place-card')) type = 'place';
                if (card.classList.contains('product-card')) type = 'product';

                card.remove();
                updateBookmarkCount(type);
            }, 300);
        }, index * 100);
    });

    setTimeout(function() {
        cancelSelection();
        showToast(selectedCards.length + '개의 북마크가 삭제되었습니다.', 'success');
    }, selectedCards.length * 100 + 300);
}

// 북마크 제거
function removeBookmark(button, type, id) {
    if (!confirm('북마크를 해제하시겠습니까?')) {
        return;
    }

    const card = button.closest('.schedule-card, .place-card, .product-card');
    card.style.opacity = '0.5';
    card.style.transform = 'scale(0.95)';

    setTimeout(() => {
        card.remove();
        showToast('북마크가 해제되었습니다.', 'info');

        // 해당 탭의 아이템 수 업데이트
        updateBookmarkCount(type);
        updateSelection();
    }, 300);
}

// 북마크 카운트 업데이트
function updateBookmarkCount(type) {
    let selector, tabSelector;

    switch(type) {
        case 'schedule':
            selector = '#bookmarkSchedules .schedule-card';
            tabSelector = '[data-tab="schedules"] .badge';
            break;
        case 'place':
            selector = '#bookmarkPlaces .place-card';
            tabSelector = '[data-tab="places"] .badge';
            break;
        case 'product':
            selector = '#bookmarkProducts .product-card';
            tabSelector = '[data-tab="products"] .badge';
            break;
    }

    const count = document.querySelectorAll(selector).length;
    const badge = document.querySelector(tabSelector);
    if (badge) {
        badge.textContent = count;
    }

    // 모든 북마크가 비었는지 확인
    const totalCount = document.querySelectorAll('.schedule-card, .place-card, .product-card').length;
    if (totalCount === 0) {
        document.querySelectorAll('.bookmark-content').forEach(c => c.style.display = 'none');
        document.getElementById('emptyState').style.display = 'block';
        document.getElementById('selectionToolbar').style.display = 'none';
    }
}
</script>

<%@ include file="../common/footer.jsp" %>
