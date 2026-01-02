<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="공지사항" />
<c:set var="pageCss" value="support" />

<%@ include file="../common/header.jsp" %>

<div class="support-page">
    <div class="container">
        <!-- 헤더 -->
        <div class="support-header">
            <h1><i class="bi bi-megaphone me-3"></i>공지사항</h1>
            <p>모행의 새로운 소식을 확인하세요</p>
        </div>

        <!-- 고객지원 네비게이션 -->
        <div class="support-nav">
            <a href="${pageContext.request.contextPath}/support/faq" class="support-nav-item">
                <i class="bi bi-question-circle me-2"></i>FAQ
            </a>
            <a href="${pageContext.request.contextPath}/support/notice" class="support-nav-item active">
                <i class="bi bi-megaphone me-2"></i>공지사항
            </a>
            <a href="${pageContext.request.contextPath}/support/inquiry" class="support-nav-item">
                <i class="bi bi-chat-dots me-2"></i>1:1 문의
            </a>
        </div>

        <div class="notice-container">
            <!-- 검색 -->
            <div class="faq-search">
                <div class="faq-search-input">
                    <input type="text" placeholder="공지사항을 검색해보세요" id="noticeSearch">
                    <button class="btn btn-primary">
                        <i class="bi bi-search me-2"></i>검색
                    </button>
                </div>
            </div>

            <!-- 카테고리 탭 -->
            <div class="faq-categories mb-4">
                <button class="faq-category active" data-category="all">전체</button>
                <button class="faq-category" data-category="notice">공지</button>
                <button class="faq-category" data-category="event">이벤트</button>
                <button class="faq-category" data-category="update">업데이트</button>
            </div>

			<!-- 공지사항 리스트 -->
			<div class="notice-list">

			  <c:choose>
			    <c:when test="${empty noticeList}">
			      <div class="notice-item" style="justify-content:center;">
			        등록된 공지사항이 없습니다.
			      </div>
			    </c:when>
		
			    <c:otherwise>
			      <c:forEach var="item" items="${noticeList}">
			        <div class="notice-item" data-category="${item.ntcType}">
			          <!-- 배지(카테고리) -->
					  <span class="notice-badge ${item.ntcType}">
					    <c:choose>
					      <c:when test="${item.ntcType eq 'notice'}">공지</c:when>
					      <c:when test="${item.ntcType eq 'event'}">이벤트</c:when>
					      <c:when test="${item.ntcType eq 'update'}">업데이트</c:when>
					      <c:otherwise>공지</c:otherwise>
					    </c:choose>
					  </span>


			          <div class="notice-content">
			            <!-- ✅ 제목 클릭 → 상세 이동 -->
			            <h4 class="notice-title">
			              <a href="${pageContext.request.contextPath}/support/notice/detail?ntcNo=${item.ntcNo}">
			                ${item.ntcTitle}
			              </a>
			            </h4>
			            <div class="notice-meta">${item.regDt}</div>
			          </div>

			          <div class="notice-views">
			            <i class="bi bi-eye me-1"></i> ${item.viewCnt}
			          </div>
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
                        <li class="page-item"><a class="page-link" href="#">4</a></li>
                        <li class="page-item"><a class="page-link" href="#">5</a></li>
                        <li class="page-item">
                            <a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>

<script>
// 카테고리 필터링
document.querySelectorAll('.faq-category').forEach(category => {
    category.addEventListener('click', function() {
        document.querySelectorAll('.faq-category').forEach(c => c.classList.remove('active'));
        this.classList.add('active');

        const cat = this.dataset.category;
        const items = document.querySelectorAll('.notice-item');

        items.forEach(item => {
            if (cat === 'all') {
                item.style.display = 'flex';
            } else {
                item.style.display = item.dataset.category === cat ? 'flex' : 'none';
            }
        });
    });
});

// 검색
document.getElementById('noticeSearch').addEventListener('input', function() {
    const searchText = this.value.toLowerCase();
    const items = document.querySelectorAll('.notice-item');

    items.forEach(item => {
        const text = item.textContent.toLowerCase();
        item.style.display = text.includes(searchText) ? 'flex' : 'none';
    });

    // 카테고리 선택 초기화
    document.querySelectorAll('.faq-category').forEach(c => c.classList.remove('active'));
    document.querySelector('.faq-category[data-category="all"]').classList.add('active');
});
</script>

<c:set var="pageJs" value="support" />
<%@ include file="../common/footer.jsp" %>
