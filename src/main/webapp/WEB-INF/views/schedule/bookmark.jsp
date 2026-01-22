<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="내 북마크" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../common/header.jsp"%>

<div class="mypage">
	<div class="container">
		<div class="mypage-container no-sidebar">
			<!-- 메인 콘텐츠 -->
			<div class="mypage-content full-width">
				<div class="mypage-header">
					<h1>내 북마크</h1>
					<p>저장한 일정과 상품을 확인하세요</p>
				</div>

				<!-- 탭 -->
				<div class="mypage-tabs">
					<button class="mypage-tab active" data-category="all">전체</button>
					<button class="mypage-tab" data-category="schedule">일정</button>
					<button class="mypage-tab" data-category="accommodation">숙소</button>
					<button class="mypage-tab" data-category="tour">투어/체험/티켓</button>
				</div>

				<!-- 북마크 그리드 -->
				<div class="content-section">
					<!-- 선택 삭제 툴바 -->
					<div class="selection-toolbar" id="selectionToolbar">
						<div class="selection-toolbar-left">
							<label class="select-all-checkbox"> <input
								type="checkbox" id="selectAllCheckbox"
								onchange="toggleSelectAll()"> <span>전체 선택</span>
							</label> <span class="selected-count" id="selectedCount">0개 선택됨</span>
						</div>
						<div class="selection-toolbar-right">
							<button class="btn btn-outline btn-sm"
								onclick="cancelSelection()">
								<i class="bi bi-x-lg me-1"></i>선택 취소
							</button>
							<button class="btn btn-danger btn-sm" id="deleteSelectedBtn"
								onclick="deleteSelectedBookmarks()" disabled>
								<i class="bi bi-trash me-1"></i>선택 삭제
							</button>
						</div>
					</div>

					<div class="bookmark-grid">
						<!-- 일정 1 -->
						<div class="bookmark-card"
							data-link="${pageContext.request.contextPath}/schedule/view/1"
							data-category="schedule" data-id="schedule-1">
							<label class="card-checkbox"> <input type="checkbox"
								onchange="updateSelection()"> <span class="checkmark"><i
									class="bi bi-check-lg"></i></span>
							</label>

							<div class="bookmark-card-image">
								<img
									src="https://images.unsplash.com/photo-1590650046871-92c887180603?w=400&h=300&fit=crop&q=80"
									alt="제주도">
								<button class="bookmark-remove active"
									onclick="removeScheduleBookmark(this)">
									<i class="bi bi-bookmark-fill"></i>
								</button>
							</div>

							<div class="bookmark-card-content">
								<span class="badge bg-success mb-2">일정</span>
								<h4>제주도 3박4일 힐링 코스</h4>
								<p>
									<i class="bi bi-calendar3"></i> 3박 4일 코스
								</p>
							</div>
						</div>

						<!-- 숙소 -->
						<div class="bookmark-card" data-category="accommodation"
							data-link="${pageContext.request.contextPath}/product/accommodation/1"
							data-id="bookmark-2">
							<label class="card-checkbox"> <input type="checkbox"
								onchange="updateSelection()"> <span class="checkmark"><i
									class="bi bi-check-lg"></i></span>
							</label>
							<div class="bookmark-card-image">
								<img
									src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop&q=80"
									alt="숙소">
								<button class="bookmark-remove active"
									onclick="removeBookmark(this)">
									<i class="bi bi-bookmark-fill"></i>
								</button>
							</div>
							<div class="bookmark-card-content">
								<span class="badge bg-info mb-2">숙소</span>
								<h4>제주 신라 호텔</h4>
								<p>
									<i class="bi bi-geo-alt"></i> 제주시 중문관광로
								</p>
								<div class="price">160,000원~</div>
							</div>
						</div>

						<!-- 투어 -->
						<div class="bookmark-card" data-category="tour"
							data-link="${pageContext.request.contextPath}/product/tour/1"
							data-id="bookmark-3">
							<label class="card-checkbox"> <input type="checkbox"
								onchange="updateSelection()"> <span class="checkmark"><i
									class="bi bi-check-lg"></i></span>
							</label>
							<div class="bookmark-card-image">
								<img
									src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=300&fit=crop&q=80"
									alt="스쿠버다이빙">
								<button class="bookmark-remove active"
									onclick="removeBookmark(this)">
									<i class="bi bi-bookmark-fill"></i>
								</button>
							</div>
							<div class="bookmark-card-content">
								<span class="badge bg-warning mb-2">투어</span>
								<h4>제주 스쿠버다이빙 체험</h4>
								<p>
									<i class="bi bi-geo-alt"></i> 서귀포시 중문
								</p>
								<div class="price">68,000원</div>
							</div>
						</div>

						<!-- 숙소 -->
						<div class="bookmark-card" data-category="accommodation"
							data-id="bookmark-5">
							<label class="card-checkbox"> <input type="checkbox"
								onchange="updateSelection()"> <span class="checkmark"><i
									class="bi bi-check-lg"></i></span>
							</label>
							<div class="bookmark-card-image">
								<img
									src="https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400&h=300&fit=crop&q=80"
									alt="숙소">
								<button class="bookmark-remove active"
									onclick="removeBookmark(this)">
									<i class="bi bi-bookmark-fill"></i>
								</button>
							</div>
							<div class="bookmark-card-content">
								<span class="badge bg-info mb-2">숙소</span>
								<h4>부산 파크하얏트</h4>
								<p>
									<i class="bi bi-geo-alt"></i> 부산 해운대구
								</p>
								<div class="price">280,000원~</div>
							</div>
						</div>

						<!-- 투어 -->
						<div class="bookmark-card" data-category="tour"
							data-id="bookmark-6">
							<label class="card-checkbox"> <input type="checkbox"
								onchange="updateSelection()"> <span class="checkmark"><i
									class="bi bi-check-lg"></i></span>
							</label>
							<div class="bookmark-card-image">
								<img
									src="https://images.unsplash.com/photo-1472745942893-4b9f730c7668?w=400&h=300&fit=crop&q=80"
									alt="카약">
								<button class="bookmark-remove active"
									onclick="removeBookmark(this)">
									<i class="bi bi-bookmark-fill"></i>
								</button>
							</div>
							<div class="bookmark-card-content">
								<span class="badge bg-warning mb-2">투어</span>
								<h4>부산 해운대 카약 체험</h4>
								<p>
									<i class="bi bi-geo-alt"></i> 부산 해운대해수욕장
								</p>
								<div class="price">15,000원</div>
							</div>
						</div>

						<!-- 투어 -->
						<div class="bookmark-card" data-category="tour"
							data-id="bookmark-8">
							<label class="card-checkbox"> <input type="checkbox"
								onchange="updateSelection()"> <span class="checkmark"><i
									class="bi bi-check-lg"></i></span>
							</label>
							<div class="bookmark-card-image">
								<img
									src="https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=400&h=300&fit=crop&q=80"
									alt="요리체험">
								<button class="bookmark-remove active"
									onclick="removeBookmark(this)">
									<i class="bi bi-bookmark-fill"></i>
								</button>
							</div>
							<div class="bookmark-card-content">
								<span class="badge bg-warning mb-2">투어</span>
								<h4>경주 한과 만들기</h4>
								<p>
									<i class="bi bi-geo-alt"></i> 경주시 황남동
								</p>
								<div class="price">24,000원</div>
							</div>
						</div>

						<!-- 숙소 -->
						<div class="bookmark-card" data-category="accommodation"
							data-id="bookmark-9">
							<label class="card-checkbox"> <input type="checkbox"
								onchange="updateSelection()"> <span class="checkmark"><i
									class="bi bi-check-lg"></i></span>
							</label>
							<div class="bookmark-card-image">
								<img
									src="https://images.unsplash.com/photo-1587061949409-02df41d5e562?w=400&h=300&fit=crop&q=80"
									alt="펜션">
								<button class="bookmark-remove active"
									onclick="removeBookmark(this)">
									<i class="bi bi-bookmark-fill"></i>
								</button>
							</div>
							<div class="bookmark-card-content">
								<span class="badge bg-info mb-2">숙소</span>
								<h4>강릉 바다뷰 펜션</h4>
								<p>
									<i class="bi bi-geo-alt"></i> 강릉시 주문진읍
								</p>
								<div class="price">120,000원~</div>
							</div>
						</div>
					</div>
				</div>

				<!-- 페이지네이션 -->
				<div class="pagination-container">
					<nav>
						<ul class="pagination">
							<li class="page-item"><a class="page-link" href="#"><i
									class="bi bi-chevron-left"></i></a></li>
							<li class="page-item active"><a class="page-link" href="#">1</a></li>
							<li class="page-item"><a class="page-link" href="#">2</a></li>
							<li class="page-item"><a class="page-link" href="#"><i
									class="bi bi-chevron-right"></i></a></li>
						</ul>
					</nav>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 북마크 상세 모달 -->
<div class="modal fade bookmark-detail-modal" id="bookmarkDetailModal"
	tabindex="-1">
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
				<button type="button" class="btn btn-outline"
					data-bs-dismiss="modal">닫기</button>
				<button type="button" class="btn btn-danger"
					onclick="removeCurrentBookmark()">
					<i class="bi bi-trash me-1"></i>북마크 삭제
				</button>
				<button type="button" class="btn btn-primary"
					onclick="addToSchedule()">
					<i class="bi bi-calendar-plus me-1"></i>일정에 추가
				</button>
			</div>
		</div>
	</div>
</div>

<script>
// helper: 현재 탭 기준으로 "화면에 보이는 카드들"만 가져오기
function getVisibleCardsByActiveTab() {
    var activeTab = document.querySelector('.mypage-tab.active');
    var activeCategory = activeTab ? activeTab.dataset.category : 'all';

    var cards = [];

    // schedule 섹션
    var scheduleSection = document.getElementById('scheduleSection');
    var scheduleCards = document.querySelectorAll('.schedule-card');

    // bookmark 섹션(기존)
    var bookmarkCards = document.querySelectorAll('.bookmark-card');

    if (activeCategory === 'all') {
        // 전체: 일정 + 북마크 전부(보이는 것 기준)
        scheduleCards.forEach(function(c) {
            if (scheduleSection && scheduleSection.style.display !== 'none') cards.push(c);
        });
        bookmarkCards.forEach(function(c) {
            if (c.style.display !== 'none') cards.push(c);
        });
        return cards;
    }

    if (activeCategory === 'schedule') {
        scheduleCards.forEach(function(c) {
            if (scheduleSection && scheduleSection.style.display !== 'none') cards.push(c);
        });
        return cards;
    }

    // destination / accommodation / tour
    bookmarkCards.forEach(function(c) {
        if (c.style.display !== 'none' && c.dataset.category === activeCategory) {
            cards.push(c);
        }
    });

    return cards;
}

// 탭 필터링 
document.querySelectorAll('.mypage-tab').forEach(function(tab) {
  tab.addEventListener('click', function() {
    document.querySelectorAll('.mypage-tab').forEach(t => t.classList.remove('active'));
    this.classList.add('active');

    var category = this.dataset.category;

    // schedule 섹션 표시/숨김
    var scheduleSection = document.getElementById('scheduleSection');
    if (scheduleSection) scheduleSection.style.display = (category === 'all' || category === 'schedule') ? 'block' : 'none';

    // 북마크 카드(여행지/숙소/투어) 필터
    document.querySelectorAll('.bookmark-grid .bookmark-card').forEach(function(card) {
      var cat = card.dataset.category;
      card.style.display = (category === 'all' || cat === category) ? 'block' : 'none';
    });

    cancelSelection();
  });
});

//카드 클릭하면 상세로 이동
document.querySelectorAll('.bookmark-card').forEach(function(card) {
  card.addEventListener('click', function(e) {
    // 체크박스/북마크버튼 눌렀을 땐 이동 막기
    if (e.target.closest('.card-checkbox') || e.target.closest('.bookmark-remove')) return;

    var link = card.dataset.link;
    if (link) location.href = link;   // replace 쓰지 말 것!
  });
});


// 전체 선택 토글 
function toggleSelectAll() {
    var selectAllCheckbox = document.getElementById('selectAllCheckbox');
    var isChecked = selectAllCheckbox.checked;

    var visibleCards = getVisibleCardsByActiveTab();
    visibleCards.forEach(function(card) {
        var checkbox = card.querySelector('.card-checkbox input[type="checkbox"]');
        if (checkbox) {
            checkbox.checked = isChecked;
            card.classList.toggle('selected', isChecked);
        }
    });

    updateSelection();
}

// 선택 상태 업데이트 
function updateSelection() {
    var visibleCards = getVisibleCardsByActiveTab();
    var selectedCount = 0;
    var totalCount = visibleCards.length;

    visibleCards.forEach(function(card) {
        var checkbox = card.querySelector('.card-checkbox input[type="checkbox"]');
        if (checkbox && checkbox.checked) {
            selectedCount++;
            card.classList.add('selected');
        } else {
            card.classList.remove('selected');
        }
    });

    document.getElementById('selectedCount').textContent = selectedCount + '개 선택됨';

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

    document.getElementById('deleteSelectedBtn').disabled = (selectedCount === 0);
}

// 선택 취소
function cancelSelection() {
    document.querySelectorAll('.card-checkbox input[type="checkbox"]').forEach(function(checkbox) {
        checkbox.checked = false;
        var card = checkbox.closest('.bookmark-card, .schedule-card');
        if (card) card.classList.remove('selected');
    });

    var all = document.getElementById('selectAllCheckbox');
    all.checked = false;
    all.indeterminate = false;

    updateSelection();
}

// 선택 삭제 
function deleteSelectedBookmarks() {
    var selectedCards = document.querySelectorAll('.bookmark-card.selected, .schedule-card.selected');

    if (selectedCards.length === 0) {
        showToast('선택된 북마크가 없습니다.', 'warning');
        return;
    }

    if (!confirm(selectedCards.length + '개의 북마크를 삭제하시겠습니까?')) return;

    selectedCards.forEach(function(card, index) {
        setTimeout(function() {
            card.style.transition = 'all 0.3s ease';
            card.style.opacity = '0';
            card.style.transform = 'scale(0.8)';
            setTimeout(function() { card.remove(); }, 300);
        }, index * 100);
    });

    setTimeout(function() {
        cancelSelection();
        showToast(selectedCards.length + '개의 북마크가 삭제되었습니다.', 'success');
    }, selectedCards.length * 100 + 350);
}

// 일정 전용 북마크 해제
function removeScheduleBookmark(btn) {
    event.stopPropagation();
    if (!confirm('일정 북마크를 삭제하시겠습니까?')) return;

    var card = btn.closest('.schedule-card');
    card.style.animation = 'fadeOut 0.3s ease';
    setTimeout(function() { card.remove(); }, 300);

    if (typeof showToast === 'function') showToast('일정 북마크가 삭제되었습니다.', 'info');

    updateSelection();
}



</script>

<style>
@
keyframes fadeOut {from { opacity:1;
	transform: scale(1);
}

to {
	opacity: 0;
	transform: scale(0.8);
}

}

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

.card-checkbox input:checked+.checkmark {
	background: var(--primary-color);
	border-color: var(--primary-color);
}

.card-checkbox input:checked+.checkmark i {
	opacity: 1;
}

.card-checkbox:hover .checkmark {
	border-color: var(--primary-color);
}

.bookmark-card.selected, .schedule-card.selected {
	outline: 3px solid var(--primary-color);
	outline-offset: -3px;
}

.bookmark-card, .schedule-card {
	position: relative;
}

@media ( max-width : 576px) {
	.selection-toolbar {
		flex-direction: column;
		gap: 12px;
	}
	.selection-toolbar-left, .selection-toolbar-right {
		width: 100%;
		justify-content: center;
	}
}
</style>

<c:set var="pageJs" value="mypage" />
<%@ include file="../common/footer.jsp"%>
