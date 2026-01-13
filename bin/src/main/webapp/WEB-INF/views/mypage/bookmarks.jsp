<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="내 북마크" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../common/header.jsp" %>

<div class="mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>내 북마크</h1>
                    <p>저장한 여행지와 상품을 확인하세요</p>
                </div>

                <!-- 통계 카드 -->
                <div class="stats-grid">
                    <div class="stat-card primary">
                        <div class="stat-icon"><i class="bi bi-bookmark-fill"></i></div>
                        <div class="stat-value">15</div>
                        <div class="stat-label">전체 북마크</div>
                    </div>
                    <div class="stat-card secondary">
                        <div class="stat-icon"><i class="bi bi-geo-alt"></i></div>
                        <div class="stat-value">5</div>
                        <div class="stat-label">여행지</div>
                    </div>
                    <div class="stat-card accent">
                        <div class="stat-icon"><i class="bi bi-building"></i></div>
                        <div class="stat-value">4</div>
                        <div class="stat-label">숙소</div>
                    </div>
                    <div class="stat-card warning">
                        <div class="stat-icon"><i class="bi bi-ticket-perforated"></i></div>
                        <div class="stat-value">6</div>
                        <div class="stat-label">투어/티켓</div>
                    </div>
                </div>

                <!-- 탭 -->
                <div class="mypage-tabs">
                    <button class="mypage-tab active" data-category="all">전체</button>
                    <button class="mypage-tab" data-category="destination">여행지</button>
                    <button class="mypage-tab" data-category="accommodation">숙소</button>
                    <button class="mypage-tab" data-category="tour">투어/티켓</button>
                </div>

                <!-- 북마크 그리드 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-grid"></i> 북마크 목록</h3>
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

                    <div class="bookmark-grid">
                        <!-- 여행지 -->
                        <div class="bookmark-card" data-category="destination" data-id="bookmark-1">
                            <label class="card-checkbox">
                                <input type="checkbox" onchange="updateSelection()">
                                <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                            </label>
                            <div class="bookmark-card-image">
                                <img src="https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&h=300&fit=crop&q=80" alt="제주도">
                                <button class="bookmark-remove active" onclick="removeBookmark(this)">
                                    <i class="bi bi-bookmark-fill"></i>
                                </button>
                            </div>
                            <div class="bookmark-card-content">
                                <span class="badge bg-primary mb-2">여행지</span>
                                <h4>제주도</h4>
                                <p><i class="bi bi-geo-alt"></i> 대한민국 제주특별자치도</p>
                            </div>
                        </div>

                        <!-- 숙소 -->
                        <div class="bookmark-card" data-category="accommodation" data-id="bookmark-2">
                            <label class="card-checkbox">
                                <input type="checkbox" onchange="updateSelection()">
                                <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                            </label>
                            <div class="bookmark-card-image">
                                <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop&q=80" alt="숙소">
                                <button class="bookmark-remove active" onclick="removeBookmark(this)">
                                    <i class="bi bi-bookmark-fill"></i>
                                </button>
                            </div>
                            <div class="bookmark-card-content">
                                <span class="badge bg-info mb-2">숙소</span>
                                <h4>제주 신라 호텔</h4>
                                <p><i class="bi bi-geo-alt"></i> 제주시 중문관광로</p>
                                <div class="price">160,000원~</div>
                            </div>
                        </div>

                        <!-- 투어 -->
                        <div class="bookmark-card" data-category="tour" data-id="bookmark-3">
                            <label class="card-checkbox">
                                <input type="checkbox" onchange="updateSelection()">
                                <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                            </label>
                            <div class="bookmark-card-image">
                                <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=300&fit=crop&q=80" alt="스쿠버다이빙">
                                <button class="bookmark-remove active" onclick="removeBookmark(this)">
                                    <i class="bi bi-bookmark-fill"></i>
                                </button>
                            </div>
                            <div class="bookmark-card-content">
                                <span class="badge bg-warning mb-2">투어</span>
                                <h4>제주 스쿠버다이빙 체험</h4>
                                <p><i class="bi bi-geo-alt"></i> 서귀포시 중문</p>
                                <div class="price">68,000원</div>
                            </div>
                        </div>

                        <!-- 여행지 -->
                        <div class="bookmark-card" data-category="destination" data-id="bookmark-4">
                            <label class="card-checkbox">
                                <input type="checkbox" onchange="updateSelection()">
                                <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                            </label>
                            <div class="bookmark-card-image">
                                <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&h=300&fit=crop&q=80" alt="부산">
                                <button class="bookmark-remove active" onclick="removeBookmark(this)">
                                    <i class="bi bi-bookmark-fill"></i>
                                </button>
                            </div>
                            <div class="bookmark-card-content">
                                <span class="badge bg-primary mb-2">여행지</span>
                                <h4>부산 해운대</h4>
                                <p><i class="bi bi-geo-alt"></i> 부산광역시 해운대구</p>
                            </div>
                        </div>

                        <!-- 숙소 -->
                        <div class="bookmark-card" data-category="accommodation" data-id="bookmark-5">
                            <label class="card-checkbox">
                                <input type="checkbox" onchange="updateSelection()">
                                <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                            </label>
                            <div class="bookmark-card-image">
                                <img src="https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400&h=300&fit=crop&q=80" alt="숙소">
                                <button class="bookmark-remove active" onclick="removeBookmark(this)">
                                    <i class="bi bi-bookmark-fill"></i>
                                </button>
                            </div>
                            <div class="bookmark-card-content">
                                <span class="badge bg-info mb-2">숙소</span>
                                <h4>부산 파크하얏트</h4>
                                <p><i class="bi bi-geo-alt"></i> 부산 해운대구</p>
                                <div class="price">280,000원~</div>
                            </div>
                        </div>

                        <!-- 투어 -->
                        <div class="bookmark-card" data-category="tour" data-id="bookmark-6">
                            <label class="card-checkbox">
                                <input type="checkbox" onchange="updateSelection()">
                                <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                            </label>
                            <div class="bookmark-card-image">
                                <img src="https://images.unsplash.com/photo-1472745942893-4b9f730c7668?w=400&h=300&fit=crop&q=80" alt="카약">
                                <button class="bookmark-remove active" onclick="removeBookmark(this)">
                                    <i class="bi bi-bookmark-fill"></i>
                                </button>
                            </div>
                            <div class="bookmark-card-content">
                                <span class="badge bg-warning mb-2">투어</span>
                                <h4>부산 해운대 카약 체험</h4>
                                <p><i class="bi bi-geo-alt"></i> 부산 해운대해수욕장</p>
                                <div class="price">15,000원</div>
                            </div>
                        </div>

                        <!-- 여행지 -->
                        <div class="bookmark-card" data-category="destination" data-id="bookmark-7">
                            <label class="card-checkbox">
                                <input type="checkbox" onchange="updateSelection()">
                                <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                            </label>
                            <div class="bookmark-card-image">
                                <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop&q=80" alt="강릉">
                                <button class="bookmark-remove active" onclick="removeBookmark(this)">
                                    <i class="bi bi-bookmark-fill"></i>
                                </button>
                            </div>
                            <div class="bookmark-card-content">
                                <span class="badge bg-primary mb-2">여행지</span>
                                <h4>강릉 경포대</h4>
                                <p><i class="bi bi-geo-alt"></i> 강원도 강릉시</p>
                            </div>
                        </div>

                        <!-- 투어 -->
                        <div class="bookmark-card" data-category="tour" data-id="bookmark-8">
                            <label class="card-checkbox">
                                <input type="checkbox" onchange="updateSelection()">
                                <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                            </label>
                            <div class="bookmark-card-image">
                                <img src="https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=400&h=300&fit=crop&q=80" alt="요리체험">
                                <button class="bookmark-remove active" onclick="removeBookmark(this)">
                                    <i class="bi bi-bookmark-fill"></i>
                                </button>
                            </div>
                            <div class="bookmark-card-content">
                                <span class="badge bg-warning mb-2">투어</span>
                                <h4>경주 한과 만들기</h4>
                                <p><i class="bi bi-geo-alt"></i> 경주시 황남동</p>
                                <div class="price">24,000원</div>
                            </div>
                        </div>

                        <!-- 숙소 -->
                        <div class="bookmark-card" data-category="accommodation" data-id="bookmark-9">
                            <label class="card-checkbox">
                                <input type="checkbox" onchange="updateSelection()">
                                <span class="checkmark"><i class="bi bi-check-lg"></i></span>
                            </label>
                            <div class="bookmark-card-image">
                                <img src="https://images.unsplash.com/photo-1587061949409-02df41d5e562?w=400&h=300&fit=crop&q=80" alt="펜션">
                                <button class="bookmark-remove active" onclick="removeBookmark(this)">
                                    <i class="bi bi-bookmark-fill"></i>
                                </button>
                            </div>
                            <div class="bookmark-card-content">
                                <span class="badge bg-info mb-2">숙소</span>
                                <h4>강릉 바다뷰 펜션</h4>
                                <p><i class="bi bi-geo-alt"></i> 강릉시 주문진읍</p>
                                <div class="price">120,000원~</div>
                            </div>
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

<!-- 북마크 상세 모달 -->
<div class="modal fade bookmark-detail-modal" id="bookmarkDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="bookmarkDetailTitle">상세 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="bookmarkDetailBody">
                <!-- 동적 콘텐츠 -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-danger" onclick="removeCurrentBookmark()">
                    <i class="bi bi-trash me-1"></i>북마크 삭제
                </button>
                <button type="button" class="btn btn-primary" onclick="addToSchedule()">
                    <i class="bi bi-calendar-plus me-1"></i>일정에 추가
                </button>
            </div>
        </div>
    </div>
</div>

<script>
var currentBookmarkCard = null;
var bookmarkDetailModal;

document.addEventListener('DOMContentLoaded', function() {
    bookmarkDetailModal = new bootstrap.Modal(document.getElementById('bookmarkDetailModal'));

    // 북마크 카드 클릭 이벤트
    document.querySelectorAll('.bookmark-card').forEach(function(card) {
        card.style.cursor = 'pointer';
        card.addEventListener('click', function(e) {
            // 삭제 버튼, 체크박스 클릭 시 모달 열지 않음
            if (e.target.closest('.bookmark-remove') || e.target.closest('.card-checkbox')) return;

            currentBookmarkCard = card;
            showBookmarkDetail(card);
        });
    });
});

// 탭 필터링
document.querySelectorAll('.mypage-tab').forEach(function(tab) {
    tab.addEventListener('click', function() {
        var tabs = document.querySelectorAll('.mypage-tab');
        for (var i = 0; i < tabs.length; i++) {
            tabs[i].classList.remove('active');
        }
        this.classList.add('active');

        var category = this.dataset.category;
        var bookmarks = document.querySelectorAll('.bookmark-card');

        for (var j = 0; j < bookmarks.length; j++) {
            if (category === 'all') {
                bookmarks[j].style.display = 'block';
            } else {
                var cat = bookmarks[j].dataset.category;
                bookmarks[j].style.display = cat === category ? 'block' : 'none';
            }
        }

        // 탭 변경 시 선택 초기화
        cancelSelection();
    });
});

// 전체 선택 토글
function toggleSelectAll() {
    var selectAllCheckbox = document.getElementById('selectAllCheckbox');
    var isChecked = selectAllCheckbox.checked;
    var activeTab = document.querySelector('.mypage-tab.active');
    var activeCategory = activeTab ? activeTab.dataset.category : 'all';

    var bookmarks = document.querySelectorAll('.bookmark-card');
    bookmarks.forEach(function(card) {
        // 현재 보이는 카드만 선택
        if (activeCategory === 'all' || card.dataset.category === activeCategory) {
            if (card.style.display !== 'none') {
                var checkbox = card.querySelector('.card-checkbox input[type="checkbox"]');
                if (checkbox) {
                    checkbox.checked = isChecked;
                    if (isChecked) {
                        card.classList.add('selected');
                    } else {
                        card.classList.remove('selected');
                    }
                }
            }
        }
    });

    updateSelection();
}

// 선택 상태 업데이트
function updateSelection() {
    var activeTab = document.querySelector('.mypage-tab.active');
    var activeCategory = activeTab ? activeTab.dataset.category : 'all';
    var selectedCount = 0;
    var totalCount = 0;

    var bookmarks = document.querySelectorAll('.bookmark-card');
    bookmarks.forEach(function(card) {
        if (activeCategory === 'all' || card.dataset.category === activeCategory) {
            if (card.style.display !== 'none') {
                totalCount++;
                var checkbox = card.querySelector('.card-checkbox input[type="checkbox"]');
                if (checkbox && checkbox.checked) {
                    selectedCount++;
                    card.classList.add('selected');
                } else {
                    card.classList.remove('selected');
                }
            }
        }
    });

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
        var card = checkbox.closest('.bookmark-card');
        if (card) card.classList.remove('selected');
    });

    document.getElementById('selectAllCheckbox').checked = false;
    document.getElementById('selectAllCheckbox').indeterminate = false;
    updateSelection();
}

// 선택된 북마크 삭제
function deleteSelectedBookmarks() {
    var selectedCards = document.querySelectorAll('.bookmark-card.selected');

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
                card.remove();
            }, 300);
        }, index * 100);
    });

    setTimeout(function() {
        cancelSelection();
        showToast(selectedCards.length + '개의 북마크가 삭제되었습니다.', 'success');
    }, selectedCards.length * 100 + 300);
}

function showBookmarkDetail(card) {
    var category = card.dataset.category;
    var image = card.querySelector('.bookmark-card-image img').src;
    var title = card.querySelector('h4').textContent;
    var location = card.querySelector('p').textContent;
    var priceEl = card.querySelector('.price');
    var price = priceEl ? priceEl.textContent : '';

    var categoryLabel = '';
    var description = '';

    if (category === 'destination') {
        categoryLabel = '여행지';
        description = '아름다운 자연경관과 다양한 볼거리가 있는 인기 여행지입니다. 사계절 내내 방문객들에게 사랑받는 곳으로, 다양한 액티비티와 맛집을 경험할 수 있습니다.';
    } else if (category === 'accommodation') {
        categoryLabel = '숙소';
        description = '편안한 휴식을 위한 최적의 숙소입니다. 깨끗한 시설과 친절한 서비스로 여행의 피로를 풀어보세요.';
    } else if (category === 'tour') {
        categoryLabel = '투어/티켓';
        description = '특별한 경험을 선사하는 인기 투어입니다. 전문 가이드와 함께 잊지 못할 추억을 만들어보세요.';
    }

    var html =
        '<img src="' + image + '" alt="' + title + '" class="bookmark-detail-image">' +
        '<div class="bookmark-detail-content">' +
            '<span class="badge bg-primary mb-3">' + categoryLabel + '</span>' +
            '<h3>' + title + '</h3>' +
            '<p class="bookmark-detail-location"><i class="bi bi-geo-alt me-1"></i>' + location.replace('<i class="bi bi-geo-alt"></i>', '').trim() + '</p>' +
            '<p class="bookmark-detail-description">' + description + '</p>' +
            '<div class="bookmark-detail-info">' +
                '<div class="bookmark-detail-info-item">' +
                    '<i class="bi bi-star-fill text-warning"></i>' +
                    '<div><span class="label">평점</span><span class="value">4.7 (328)</span></div>' +
                '</div>' +
                '<div class="bookmark-detail-info-item">' +
                    '<i class="bi bi-clock"></i>' +
                    '<div><span class="label">영업시간</span><span class="value">09:00 - 18:00</span></div>' +
                '</div>' +
                (price ?
                '<div class="bookmark-detail-info-item">' +
                    '<i class="bi bi-currency-won"></i>' +
                    '<div><span class="label">가격</span><span class="value">' + price + '</span></div>' +
                '</div>' : '') +
                '<div class="bookmark-detail-info-item">' +
                    '<i class="bi bi-telephone"></i>' +
                    '<div><span class="label">문의</span><span class="value">064-123-4567</span></div>' +
                '</div>' +
            '</div>' +
        '</div>';

    document.getElementById('bookmarkDetailTitle').textContent = title;
    document.getElementById('bookmarkDetailBody').innerHTML = html;
    bookmarkDetailModal.show();
}

function removeBookmark(btn) {
    event.stopPropagation();
    if (confirm('북마크를 삭제하시겠습니까?')) {
        var card = btn.closest('.bookmark-card');
        card.style.animation = 'fadeOut 0.3s ease';
        setTimeout(function() { card.remove(); }, 300);
        if (typeof showToast === 'function') {
            showToast('북마크가 삭제되었습니다.', 'info');
        }
    }
}

function removeCurrentBookmark() {
    if (currentBookmarkCard && confirm('이 북마크를 삭제하시겠습니까?')) {
        currentBookmarkCard.style.animation = 'fadeOut 0.3s ease';
        setTimeout(function() { currentBookmarkCard.remove(); }, 300);
        bookmarkDetailModal.hide();
        if (typeof showToast === 'function') {
            showToast('북마크가 삭제되었습니다.', 'info');
        }
    }
}

function removeAllBookmarks() {
    if (confirm('모든 북마크를 삭제하시겠습니까?')) {
        var cards = document.querySelectorAll('.bookmark-card');
        for (var i = 0; i < cards.length; i++) {
            cards[i].remove();
        }
        if (typeof showToast === 'function') {
            showToast('모든 북마크가 삭제되었습니다.', 'info');
        }
    }
}

function addToSchedule() {
    bookmarkDetailModal.hide();
    if (typeof showToast === 'function') {
        showToast('일정에 추가되었습니다.', 'success');
    }
    setTimeout(function() {
        window.location.href = '${pageContext.request.contextPath}/schedule/planner';
    }, 1000);
}
</script>

<style>
@keyframes fadeOut {
    from { opacity: 1; transform: scale(1); }
    to { opacity: 0; transform: scale(0.8); }
}

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
.bookmark-card.selected {
    outline: 3px solid var(--primary-color);
    outline-offset: -3px;
}

/* 카드 상대 위치 설정 */
.bookmark-card {
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

<c:set var="pageJs" value="mypage" />
<%@ include file="../common/footer.jsp" %>
