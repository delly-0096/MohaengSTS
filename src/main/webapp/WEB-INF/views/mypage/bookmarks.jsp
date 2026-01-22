<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

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

				<!-- 통계 카드 -->
				<div class="stats-grid">
					<div class="stat-card primary">
						<div class="stat-icon">
							<i class="bi bi-bookmark-fill"></i>
						</div>
						<div class="stat-value">${stats.TOTAL_CNT}</div>
						<div class="stat-label">전체 북마크</div>
					</div>
					<div class="stat-card secondary">
						<div class="stat-icon">
							<i class="bi bi-calendar3"></i>
						</div>
						<div class="stat-value">${stats.SCHEDULE_CNT}</div>
						<div class="stat-label">일정</div>
					</div>
					<div class="stat-card accent">
						<div class="stat-icon">
							<i class="bi bi-building"></i>
						</div>
						<div class="stat-value">${stats.ACCOMMODATION_CNT}</div>
						<div class="stat-label">숙소</div>
					</div>
					<div class="stat-card warning">
						<div class="stat-icon">
							<i class="bi bi-ticket-perforated"></i>
						</div>
						<div class="stat-value">${stats.TOUR_CNT}</div>
						<div class="stat-label">투어/체험/티켓</div>
					</div>
				</div> 

				<div class="bookmark-search">
	                <form class="bookmark-search-input" id="searchForm" method="post">
	                	<input type="hidden" name="page" id="page"/>
	                </form>
            	</div>
				            
				<!-- 탭 -->
				<div class="mypage-tabs mb-4">
					<button class="mypage-tab <c:if test="${not empty contentType and contentType eq 'all' }">active</c:if>" data-category="all">전체</button>
					<button class="mypage-tab <c:if test="${not empty contentType and contentType eq 'schedule' }">active</c:if>" data-category="schedule">일정</button>
					<button class="mypage-tab <c:if test="${not empty contentType and contentType eq 'accommodation' }">active</c:if>" data-category="accommodation">숙소</button>
					<button class="mypage-tab <c:if test="${not empty contentType and contentType eq 'tour' }">active</c:if>" data-category="tour">투어/체험/티켓</button>
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
						<c:set value="${pagingVO.dataList }" var="bookMarkList"/>
						<c:choose>
							<c:when test="${empty bookMarkList }">
								북마크가 존재하지 않습니다.
							</c:when>
							<c:otherwise>
								<c:forEach var="bookmark" items="${bookMarkList }">
									<c:set value="일정" var="contentType"/>
									<c:set value="bg-success" var="color"/>
									<c:set value="${pageContext.request.contextPath}/schedule/view/${bookmark.contentId }" var="link"/>
									<c:choose>
										<c:when test="${bookmark.contentType eq 'ACCOMMODATION' }">
											<c:set value="숙소" var="contentType"/>
											<c:set value="bg-info" var="color"/>
											<c:set value="${pageContext.request.contextPath}/product/accommodation/${bookmark.contentId }" var="link"/>
										</c:when>
										<c:when test="${bookmark.contentType eq 'TOUR' }">
											<c:set value="투어" var="contentType"/>
											<c:set value="bg-warning" var="color"/>
											<c:set value="${pageContext.request.contextPath}/tour/${bookmark.contentId }" var="link"/>
										</c:when>
									</c:choose>
									<div class="bookmark-card" data-link="${link }" data-category="${fn:toLowerCase(bookmark.contentType) }" data-id="${fn:toLowerCase(bookmark.contentType) }-1">
										<label class="card-checkbox"> 
											<input type="checkbox" onchange="updateSelection()"> 
											<span class="checkmark">
												<i class="bi bi-check-lg"></i>
											</span>
										</label>
			
										<!-- 이미지 구현 해야함............. -->
										<div class="bookmark-card-image">
											<img src="https://images.unsplash.com/photo-1590650046871-92c887180603?w=400&h=300&fit=crop&q=80" alt="제주도">
											<button class="bookmark-remove active" onclick="removeScheduleBookmark(this)">
												<i class="bi bi-bookmark-fill"></i>
											</button>
										</div>
			
										<div class="bookmark-card-content">
											<span class="badge ${color } mb-2">
												${contentType }
											</span>
											<h4>${bookmark.title }</h4>
											<p>
												<c:if test="${bookmark.contentType eq 'SCHEDULE' }">
													<i class="bi bi-calendar3"></i> 
													${bookmark.bmkDayCount }박 ${bookmark.bmkDayCount+1 }일 코스
												</c:if>
												<c:if test="${bookmark.contentType ne 'SCHEDULE' }">
													<i class="bi bi-geo-alt"></i>
													${fn:split(bookmark.addr1, ' ')[0] } ${fn:split(bookmark.addr1, ' ')[1] }
												</c:if>
											</p>
											<c:if test="${bookmark.contentType ne 'SCHEDULE' }">
												<div class="price">
													<fmt:formatNumber value="${bookmark.price }" pattern="#,###,###"/>원
												</div>
											</c:if>
										</div>
									</div>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<!-- 페이지네이션 -->
				<div class="pagination-container" id="pagingArea">
					<nav>
						${pagingVO.pagingHTML }
					</nav>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
$(function(){
	let category = $(".mypage-tab");
	let pagingArea = $("#pagingArea");
	let searchForm = $("#searchForm");
	
	pagingArea.on("click", "a", function(e){
		e.preventDefault();
		let pageNo = $(this).data("page");
		searchForm.find("#page").val(pageNo);
		searchForm.submit();
	});
	
	category.on("click", function(){
		let category = $(this).data("category");
		location.href = "${pageContext.request.contextPath}/mypage/bookmarks?contentType=" + category;
	});
});

//helper: 현재 탭 기준으로 "화면에 보이는 카드들"만 가져오기
function getVisibleCardsByActiveTab() {
    var activeTab = document.querySelector('.mypage-tab.active');
    var activeCategory = activeTab ? activeTab.dataset.category : 'all';

    var cards = Array.from(document.querySelectorAll('.bookmark-card'));

    if (activeCategory === 'all') return cards;
    return cards.filter(function(c){ return c.dataset.category === activeCategory; });
} 

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
