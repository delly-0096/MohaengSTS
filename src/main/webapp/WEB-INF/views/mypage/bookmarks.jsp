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
				<c:if test="${showStats eq 'Y'}">
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
				</c:if>

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
									<div class="bookmark-card" data-link="${link }" data-bmkno="${bookmark.bmkNo}" 
										data-category="${fn:toLowerCase(bookmark.contentType) }" data-id="${fn:toLowerCase(bookmark.contentType) }-1">
										<label class="card-checkbox"> 
											<input type="checkbox" onchange="updateSelection()"> 
											<span class="checkmark">
												<i class="bi bi-check-lg"></i>
											</span>
										</label>
			
										<!-- 이미지 구현 해야함............. -->
										<div class="bookmark-card-image">
										    <c:choose>
										        <c:when test="${fn:startsWith(bookmark.thumbImg, 'http')}">
										            <img src="${bookmark.thumbImg}" alt="${bookmark.title}">
										        </c:when>
										        <c:otherwise>
										            <img src="${pageContext.request.contextPath}/resources${bookmark.thumbImg}" alt="${bookmark.title}">
										        </c:otherwise>
										    </c:choose>
										    
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

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
$(function(){
    // 현재 접속한 경로를 자동으로 인식 (/mypage/bookmarks 또는 /schedule/bookmark)
    const currentPath = window.location.pathname;
    
    let pagingArea = $("#pagingArea");
    let searchForm = $("#searchForm");
    
    // 페이징 이벤트 수정
    pagingArea.on("click", "a", function(e){
        e.preventDefault();
        let pageNo = $(this).data("page");
        
        // action 주소를 현재 경로로 설정하여 다른 메뉴에서도 자기 자신을 호출하게 함
        searchForm.attr("action", currentPath); 
        searchForm.find("#page").val(pageNo);
        searchForm.submit();
    });
    
    // 탭 클릭 이벤트 수정
    $(".mypage-tab").on("click", function(){
        let category = $(this).data("category");
        // [수정] 고정된 주소 대신 currentPath 사용
        location.href = currentPath + "?contentType=" + category;
    });

    // 카드 클릭 이벤트 (상세 이동)
    $(document).on('click', '.bookmark-card', function(e) {
        if ($(e.target).closest('.card-checkbox, .bookmark-remove').length) return;
        var link = $(this).data("link");
        if (link) location.href = link;
    });

    window.updateSelection = function() {
        let visibleCards = $(".bookmark-card");
        let selectedCards = $(".bookmark-card").filter(function() {
            return $(this).find(".card-checkbox input").is(":checked");
        });

        let selectedCount = selectedCards.length;
        let totalCount = visibleCards.length;

        $(".bookmark-card").removeClass("selected");
        selectedCards.addClass("selected");

        $("#selectedCount").text(selectedCount + "개 선택됨");

        let selectAll = $("#selectAllCheckbox");
        if (totalCount > 0 && selectedCount === totalCount) {
            selectAll.prop("checked", true).prop("indeterminate", false);
        } else if (selectedCount > 0) {
            selectAll.prop("checked", false).prop("indeterminate", true);
        } else {
            selectAll.prop("checked", false).prop("indeterminate", false);
        }

        let deleteBtn = $("#deleteSelectedBtn");
        if (selectedCount > 0) {
            deleteBtn.prop("disabled", false).css({"cursor": "pointer", "opacity": "1"});
        } else {
            deleteBtn.prop("disabled", true).css({"cursor": "not-allowed", "opacity": "0.6"});
        }
    };

    window.toggleSelectAll = function() {
        let isChecked = $("#selectAllCheckbox").is(":checked");
        $(".card-checkbox input").prop("checked", isChecked);
        updateSelection();
    };

    window.cancelSelection = function() {
        $(".card-checkbox input").prop("checked", false);
        $("#selectAllCheckbox").prop("checked", false).prop("indeterminate", false);
        updateSelection();
    };
});

// 삭제 함수 내의 URL도 유동적으로 변경
function deleteBookmarksFromServer(bmkNos) {
    const currentPath = window.location.pathname; // 현재 경로 인식
    const token = $("meta[name='_csrf']").attr("content");
    const header = $("meta[name='_csrf_header']").attr("content");

    $.ajax({
        // 현재 경로 뒤에 /delete를 붙여 요청
        url: currentPath + "/delete", 
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify({ bmkNos: bmkNos }),
        beforeSend: function(xhr) {
            if(token && header) xhr.setRequestHeader(header, token);
        },
        success: function(res) {
            if (res === "SUCCESS") {
                Swal.fire({ icon: 'success', title: '삭제 완료', confirmButtonColor: '#3085d6' }).then(() => {
                    location.reload(); 
                });
            } else {
                Swal.fire('실패', '삭제 처리에 실패했습니다.', 'error');
            }
        },
        error: function() { Swal.fire('오류', '서버 통신 중 오류가 발생했습니다.', 'error'); }
    });
}

// 선택 삭제 함수
function deleteSelectedBookmarks() {
    const selectedBmkNos = [];
    $(".bookmark-card.selected").each(function() {
        const bmkNo = $(this).data("bmkno");
        if(bmkNo) selectedBmkNos.push(parseInt(bmkNo));
    });

    if (selectedBmkNos.length === 0) return;

    // confirm 대용 SweetAlert
    Swal.fire({
        title: '정말 삭제하시겠습니까?',
        text: selectedBmkNos.length + "개의 북마크가 목록에서 제거됩니다.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: '삭제',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            deleteBookmarksFromServer(selectedBmkNos);
        }
    });
}

// 개별 삭제 함수
function removeScheduleBookmark(btn) {
    event.stopPropagation();
    const card = $(btn).closest('.bookmark-card');
    const bmkNo = card.data("bmkno");

    Swal.fire({
        title: '북마크 삭제',
        text: "해당 북마크를 삭제하시겠습니까?",
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: '삭제',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            deleteBookmarksFromServer([bmkNo]);
        }
    });
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
