<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="내 일정" />
<c:set var="pageCss" value="mypage" />
<%@ include file="../common/header.jsp" %>
<div class="mypage">
   <div class="container">
       <div class="mypage-container no-sidebar">
           <!-- 메인 콘텐츠 -->
           <div class="mypage-content full-width">
               <div class="mypage-header">
                   <h1>내 일정</h1>
                   <p>저장된 여행 일정을 확인하고 관리하세요</p>
               </div>
              
               <!-- 통계 카드 -->
               <div class="stats-grid">
                   <div class="stat-card primary">
                       <div class="stat-icon"><i class="bi bi-calendar-check"></i></div>
                       <div class="stat-value" id="allCount">${fn:length(scheduleList)}</div>
                       <div class="stat-label">전체 일정</div>
                   </div>
                   <div class="stat-card secondary">
                       <div class="stat-icon"><i class="bi bi-clock"></i></div>
                       <div class="stat-value" id="upcomingCount">12</div>
                       <div class="stat-label">예정된 여행</div>
                   </div>
                   <div class="stat-card accent">
                       <div class="stat-icon"><i class="bi bi-check-circle"></i></div>
                       <div class="stat-value" id="completedCount">10</div>
                       <div class="stat-label">완료된 여행</div>
                   </div>
                   <div class="stat-card warning">
                       <div class="stat-icon"><i class="bi bi-robot"></i></div>
                       <div class="stat-value" id="aiCount">8</div>
                       <div class="stat-label">AI 추천 일정</div>
                   </div>
               </div>
               <!-- 탭 -->
               <div class="mypage-tabs">
                   <button class="mypage-tab active" data-filter="all">전체</button>
                   <button class="mypage-tab" data-filter="upcoming">예정된 여행</button>
                   <button class="mypage-tab" data-filter="completed">완료된 여행</button>
                   <button class="mypage-tab" data-filter="ai">AI 추천</button>
               </div>
               <!-- 일정 리스트 -->
               <div class="content-section">
                   <div class="section-header">
                       <h3><i class="bi bi-list-ul"></i> 일정 목록</h3>
                       <a href="${pageContext.request.contextPath}/schedule/search" class="btn btn-primary btn-sm">
                           <i class="bi bi-plus me-2"></i>새 일정 만들기
                       </a>
                   </div>
                   <div class="schedule-list">
                       <!-- 일정 1 -->
                       <c:forEach items="${ scheduleList }" var="schedule">
	                        <div class="schedule-card" data-status="upcoming">
	                            <div class="schedule-card-header">
	                                <div class="schedule-destination">
	                                    <h4>${ schedule.schdlNm }</h4>
	                                    <span class="schedule-badge upcoming">예정</span>
	                                    <span class="schedule-badge ai">AI 추천</span>
	                                </div>
	                                <div class="schedule-actions">
	                                    <button class="btn btn-icon edit" title="수정" data-key="${schedule.schdlNo}">
	                                        <i class="bi bi-pencil"></i>
	                                    </button>
	                                    <button class="btn btn-icon" title="공유">
	                                        <i class="bi bi-share"></i>
	                                    </button>
	                                    <button class="btn btn-icon" title="삭제">
	                                        <i class="bi bi-trash"></i>
	                                    </button>
	                                </div>
	                            </div>
	                            <div class="schedule-card-body">
	                                <div class="schedule-info">
	                                    <span><i class="bi bi-calendar3"></i> ${fn:replace(schedule.schdlStartDt, '-', '.')} - ${fn:replace(schedule.schdlEndDt, '-', '.')}</span>
	                                    <span><i class="bi bi-geo-alt"></i> ${ schedule.getRgnNm() }</span>
	                                    <span><i class="bi bi-people"></i> ${ schedule.travelerCnt }명</span>
	                                </div>
	                                <div class="schedule-places">
	                                    <c:forEach var="name" items="${schedule.displayPlaceNames}">
			                                <span class="place-tag">${name}</span>
			                            </c:forEach>
			                            <c:if test="${schedule.placeCnt > 2}">
			                                <span class="place-tag">+${schedule.placeCnt -2}</span>
			                            </c:if>
	                                </div>
	                            </div>
	                            <div class="schedule-card-footer">
	                                <span class="schedule-date">최근 수정: ${fn:replace(schedule.modDt, '-', '.')}</span>
	                                <a href="${pageContext.request.contextPath}/schedule/view/${ schedule.schdlNo }" class="btn btn-outline btn-sm">
	                                    일정 보기 <i class="bi bi-arrow-right"></i>
	                                </a>
	                            </div>
	                        </div>
                       </c:forEach>
                      
<!--                         <div class="schedule-card" data-status="upcoming"> -->
<!--                             <div class="schedule-card-header"> -->
<!--                                 <div class="schedule-destination"> -->
<!--                                     <h4>도쿄 5박 6일</h4> -->
<!--                                     <span class="schedule-badge upcoming">예정</span> -->
<!--                                 </div> -->
<!--                                 <div class="schedule-actions"> -->
<!--                                     <button class="btn btn-icon" title="수정"> -->
<!--                                         <i class="bi bi-pencil"></i> -->
<!--                                     </button> -->
<!--                                     <button class="btn btn-icon" title="공유"> -->
<!--                                         <i class="bi bi-share"></i> -->
<!--                                     </button> -->
<!--                                     <button class="btn btn-icon" title="삭제"> -->
<!--                                         <i class="bi bi-trash"></i> -->
<!--                                     </button> -->
<!--                                 </div> -->
<!--                             </div> -->
<!--                             <div class="schedule-card-body"> -->
<!--                                 <div class="schedule-info"> -->
<!--                                     <span><i class="bi bi-calendar3"></i> 2024.05.01 - 2024.05.06</span> -->
<!--                                     <span><i class="bi bi-geo-alt"></i> 일본 도쿄</span> -->
<!--                                     <span><i class="bi bi-people"></i> 1명</span> -->
<!--                                 </div> -->
<!--                                 <div class="schedule-places"> -->
<!--                                     <span class="place-tag">시부야</span> -->
<!--                                     <span class="place-tag">아사쿠사</span> -->
<!--                                     <span class="place-tag">디즈니랜드</span> -->
<!--                                     <span class="place-tag">+8</span> -->
<!--                                 </div> -->
<!--                             </div> -->
<!--                             <div class="schedule-card-footer"> -->
<!--                                 <span class="schedule-date">최근 수정: 2024.03.10</span> -->
<%--                                 <a href="${pageContext.request.contextPath}/schedule/planner" class="btn btn-outline btn-sm"> --%>
<!--                                     일정 보기 <i class="bi bi-arrow-right"></i> -->
<!--                                 </a> -->
<!--                             </div> -->
<!--                         </div> -->
<!--                         <div class="schedule-card" data-status="completed"> -->
<!--                             <div class="schedule-card-header"> -->
<!--                                 <div class="schedule-destination"> -->
<!--                                     <h4>부산 2박 3일</h4> -->
<!--                                     <span class="schedule-badge completed">완료</span> -->
<!--                                     <span class="schedule-badge ai">AI 추천</span> -->
<!--                                 </div> -->
<!--                                 <div class="schedule-actions"> -->
<!--                                     <button class="btn btn-icon" title="후기 작성"> -->
<!--                                         <i class="bi bi-pencil-square"></i> -->
<!--                                     </button> -->
<!--                                     <button class="btn btn-icon" title="공유"> -->
<!--                                         <i class="bi bi-share"></i> -->
<!--                                     </button> -->
<!--                                     <button class="btn btn-icon" title="삭제"> -->
<!--                                         <i class="bi bi-trash"></i> -->
<!--                                     </button> -->
<!--                                 </div> -->
<!--                             </div> -->
<!--                             <div class="schedule-card-body"> -->
<!--                                 <div class="schedule-info"> -->
<!--                                     <span><i class="bi bi-calendar3"></i> 2024.02.20 - 2024.02.22</span> -->
<!--                                     <span><i class="bi bi-geo-alt"></i> 부산</span> -->
<!--                                     <span><i class="bi bi-people"></i> 3명</span> -->
<!--                                 </div> -->
<!--                                 <div class="schedule-places"> -->
<!--                                     <span class="place-tag">해운대</span> -->
<!--                                     <span class="place-tag">광안리</span> -->
<!--                                     <span class="place-tag">감천문화마을</span> -->
<!--                                     <span class="place-tag">+4</span> -->
<!--                                 </div> -->
<!--                             </div> -->
<!--                             <div class="schedule-card-footer"> -->
<!--                                 <span class="schedule-date">완료일: 2024.02.22</span> -->
<!--                                 <a href="#" class="btn btn-primary btn-sm" onclick="writeReview()"> -->
<!--                                     <i class="bi bi-pencil-square me-1"></i>여행기록 작성 -->
<!--                                 </a> -->
<!--                             </div> -->
<!--                         </div> -->
<!--                         <div class="schedule-card" data-status="completed"> -->
<!--                             <div class="schedule-card-header"> -->
<!--                                 <div class="schedule-destination"> -->
<!--                                     <h4>강릉 1박 2일</h4> -->
<!--                                     <span class="schedule-badge completed">완료</span> -->
<!--                                 </div> -->
<!--                                 <div class="schedule-actions"> -->
<!--                                     <button class="btn btn-icon" title="공유"> -->
<!--                                         <i class="bi bi-share"></i> -->
<!--                                     </button> -->
<!--                                     <button class="btn btn-icon" title="삭제"> -->
<!--                                         <i class="bi bi-trash"></i> -->
<!--                                     </button> -->
<!--                                 </div> -->
<!--                             </div> -->
<!--                             <div class="schedule-card-body"> -->
<!--                                 <div class="schedule-info"> -->
<!--                                     <span><i class="bi bi-calendar3"></i> 2024.01.15 - 2024.01.16</span> -->
<!--                                     <span><i class="bi bi-geo-alt"></i> 강릉</span> -->
<!--                                     <span><i class="bi bi-people"></i> 2명</span> -->
<!--                                 </div> -->
<!--                                 <div class="schedule-places"> -->
<!--                                     <span class="place-tag">정동진</span> -->
<!--                                     <span class="place-tag">안목해변</span> -->
<!--                                     <span class="place-tag">경포대</span> -->
<!--                                 </div> -->
<!--                             </div> -->
<!--                             <div class="schedule-card-footer"> -->
<!--                                 <span class="schedule-date">완료일: 2024.01.16</span> -->
<%--                                 <a href="${pageContext.request.contextPath}/schedule/planner" class="btn btn-outline btn-sm"> --%>
<!--                                     일정 보기 <i class="bi bi-arrow-right"></i> -->
<!--                                 </a> -->
<!--                             </div> -->
<!--                         </div> -->
                      
                   </div>
               </div>
           </div>
       </div>
   </div>
</div>
<style>
.schedule-list {
   display: flex;
   flex-direction: column;
   gap: 16px;
}
.schedule-card {
   background: var(--light-color);
   border-radius: var(--radius-lg);
   overflow: hidden;
}
.schedule-card-header {
   display: flex;
   justify-content: space-between;
   align-items: center;
   padding: 16px 20px;
   background: white;
   border-bottom: 1px solid var(--gray-lighter);
}
.schedule-destination {
   display: flex;
   align-items: center;
   gap: 12px;
}
.schedule-destination h4 {
   font-size: 18px;
   font-weight: 600;
   margin: 0;
}
.schedule-badge {
   padding: 4px 10px;
   border-radius: 20px;
   font-size: 11px;
   font-weight: 500;
}
.schedule-badge.upcoming {
   background: var(--primary-color);
   color: white;
}
.schedule-badge.completed {
   background: var(--success-color);
   color: white;
}
.schedule-badge.ai {
   background: linear-gradient(135deg, var(--accent-color), #FF8B8B);
   color: white;
}
.schedule-actions {
   display: flex;
   gap: 8px;
}
.btn-icon {
   width: 36px;
   height: 36px;
   padding: 0;
   display: flex;
   align-items: center;
   justify-content: center;
   border-radius: var(--radius-md);
   background: none;
   border: 1px solid var(--gray-light);
   color: var(--gray-dark);
   cursor: pointer;
   transition: all var(--transition-fast);
}
.btn-icon:hover {
   background: var(--primary-color);
   border-color: var(--primary-color);
   color: white;
}
.schedule-card-body {
   padding: 16px 20px;
}
.schedule-info {
   display: flex;
   flex-wrap: wrap;
   gap: 16px;
   margin-bottom: 12px;
   font-size: 14px;
   color: var(--gray-dark);
}
.schedule-info span {
   display: flex;
   align-items: center;
   gap: 6px;
}
.schedule-places {
   display: flex;
   flex-wrap: wrap;
   gap: 8px;
}
.place-tag {
   padding: 4px 12px;
   background: white;
   border-radius: 20px;
   font-size: 13px;
   color: var(--gray-dark);
}
.schedule-card-footer {
   display: flex;
   justify-content: space-between;
   align-items: center;
   padding: 12px 20px;
   background: rgba(0, 0, 0, 0.02);
}
.schedule-date {
   font-size: 13px;
   color: var(--gray-medium);
}
@media (max-width: 768px) {
   .schedule-card-header {
       flex-direction: column;
       gap: 12px;
       align-items: flex-start;
   }
   .schedule-destination {
       flex-wrap: wrap;
   }
   .schedule-info {
       flex-direction: column;
       gap: 8px;
   }
}
</style>
<script>
// 탭 필터링
document.querySelectorAll('.mypage-tab').forEach(tab => {
   tab.addEventListener('click', function() {
       document.querySelectorAll('.mypage-tab').forEach(t => t.classList.remove('active'));
       this.classList.add('active');
       const filter = this.dataset.filter;
       const schedules = document.querySelectorAll('.schedule-card');
       schedules.forEach(schedule => {
           if (filter === 'all') {
               schedule.style.display = 'block';
           } else if (filter === 'ai') {
               schedule.style.display = schedule.querySelector('.schedule-badge.ai') ? 'block' : 'none';
           } else {
               const status = schedule.dataset.status;
               schedule.style.display = status === filter ? 'block' : 'none';
           }
       });
   });
});
document.querySelectorAll('.edit').forEach(edt => {
   edt.addEventListener('click', function() {
		let no = this.dataset.key;
		location.href = "${pageContext.request.contextPath}/schedule/planner/"+no;
   });
});
function writeReview() {
   window.location.href = '${pageContext.request.contextPath}/community/travel-log/write';
}
</script>
<c:set var="pageJs" value="mypage" />
<%@ include file="../common/footer.jsp" %>

