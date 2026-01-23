<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="pageTitle" value="기업 대시보드" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../../common/header.jsp" %>
<!-- chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script> 

<div class="mypage business-mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>대시보드</h1>
                    <p>비즈니스 현황을 한눈에 확인하세요</p>
                </div>

                <!-- 통계 카드 -->
                <div class="stats-grid">
                    <div class="stat-card primary">
                        <div class="stat-icon"><i class="bi bi-currency-won"></i></div>
                        <div class="stat-value" id="monthlySales">${dashboard.kpi.monthlySales}</div>
                        <div class="stat-label">이번 달 매출</div>
                    </div>
                    <div class="stat-card secondary">
                        <div class="stat-icon"><i class="bi bi-cart-check"></i></div>   
                        <div class="stat-value" id="monthlyReservations">${dashboard.kpi.monthlyReservations}</div>
                        <div class="stat-label">이번 달 예약</div>
                    </div>
                    <div class="stat-card accent">
                        <div class="stat-icon"><i class="bi bi-box-seam"></i></div>
                        <div class="stat-value" id="sellingProductCount">${dashboard.kpi.sellingProductCount}</div>
                        <div class="stat-label">등록 상품</div>
                    </div>
                    <div class="stat-card warning">
                        <div class="stat-icon"><i class="bi bi-star-fill"></i></div>
                        <div class="stat-value">4.8</div>
                        <div class="stat-label">평균 평점</div>
                    </div>
                </div>

                <div class="row">
					<!-- 차트 영역 -->
					<div class="dashboard-charts-row" style="display: flex; gap: 10px;">
						<div class="content-section" style="flex: 1; min-width: 0; "> <div class="section-header">
					            <h3><i class="bi bi-pie-chart"></i> 상품 구성</h3>
					        </div>
					       <div class="chart-container" style="
						        position: relative; flex: 1; display: flex;  justify-content: center;
						        align-items: center; min-height: 250px; padding: 10px;
						    ">
					            <canvas id="categoryChart"></canvas>
					        </div>
					    </div>
					    
					    <div class="content-section" style="flex: 3; min-width: 0; display: flex; flex-direction: column;"> <div class="section-header">
					            <h3><i class="bi bi-graph-up"></i> 매출 현황 (최근 6개월)</h3>
					        </div>
					        <div class="chart-container" style="
					        	justify-content: center;
						        position: relative; 
						        height: 280px;   
						        width: 95%;         
						        margin: auto;   
						    ">
					            <canvas id="myChart" style="max-width: 95%; max-height: 95%;"></canvas>
					        </div>
					    </div>
					</div>
					
					<div class="dashboard-row" style="display: flex; gap: 20px; margin-top: 20px;">
					    <div class="content-section" style="flex: 1; min-width: 0;">
					        <div class="section-header" style="display: flex; justify-content: space-between;">
					            <h3><i class="bi bi-calendar-check"></i> 다가오는 예약</h3>
					            <span class="badge bg-primary">오늘 ${dashboard.todayArrivalCount}건</span>
					        </div>
					        <div class="list-container" id="upcomingReservations" style="height: 300px; overflow-y: auto;">
					            <ul class="list-group list-group-flush">
					                </ul>
					        </div>
					    </div>
					
					    <div class="content-section" style="flex: 1; min-width: 0;">
					        <div class="section-header">
					            <h3><i class="bi bi-chat-left-dots"></i> 최근 리뷰</h3>
					        </div>
					        <div class="list-container" id="recentReviews" style="height: 300px; overflow-y: auto;">
					            </div>
					    </div>
					</div>
					
                    <!-- 최근 예약 -->
                    <div class="col-lg-8">
                        <div class="content-section">
                            <div class="section-header">
                                <h3><i class="bi bi-receipt"></i> 최근 예약</h3>
                               <a href="${pageContext.request.contextPath}/mypage/business/products" class="view-all">
   									 전체보기 <i class="bi bi-arrow-right"></i>
							   </a>

                            </div>

                            <div class="table-responsive">
                                <table class="sales-table">
                                    <thead>
                                        <tr>
                                            <th>예약번호</th>
                                            <th>상품명</th>
                                            <th>예약자</th>
                                            <th>금액</th>
                                            <th>상태</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:choose>
                                    		<c:when test="${empty paymentList }">
                                    			<tr>
                                    				<td colspan="5">조회하신 결제 내역이 존재하지 않습니다.</td>
                                    			</tr>	
                                    		</c:when>
                                    		<c:otherwise>
                                    			<c:forEach items="${paymentList }" var="payment">
                                    				<c:set value="" var="etc"/>
                                    				<c:if test="${fn:length(payment.tripProdList) > 1 }">
                                    					<c:set value="외 ${fn:length(payment.tripProdList)-1 }개" var="etc"/>
                                    				</c:if>
                                    				<tr>
			                                            <td>${payment.payNo }</td>
			                                            <td>${payment.tripProdList[0].tripProdName } ${etc }</td>
			                                            <td>${payment.memName }</td>
			                                            <td class="text-primary fw-bold"><fmt:formatNumber value="${payment.payTotalAmt }" pattern="#,###,###"/> 원</td>
			                                            <td>
			                                            	<c:choose>
			                                            		<c:when test="${payment.payStatus eq 'DONE' }">
			                                            			<span class="payment-status completed">확정</span>
			                                            		</c:when>
			                                            		<c:otherwise>
			                                            			<span class="payment-status">취소</span>
			                                            		</c:otherwise>
			                                            	</c:choose>
			                                            </td>
			                                        </tr>
                                    			</c:forEach>
                                    		</c:otherwise>
                                    	</c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- 알림 -->
                    <div class="col-lg-4">
                        <div class="content-section">
							  <div class="section-header">
							    <h3><i class="bi bi-bell"></i> 알림</h3>
							    <a href="${pageContext.request.contextPath}/mypage/business/notifications" class="view-all">
							      전체보기 <i class="bi bi-arrow-right"></i>
							    </a>
							  </div>
							
							  <!-- ✅ 리스트형 -->
							  <ul class="noti-list" id="notiList">
							    <!-- JS로 렌더링 -->
							    <li class="noti-empty">알림을 불러오는 중...</li>
							  </ul>
							</div>


                   		 <!-- <div class="notification-list">
                                <div class="notification-item unread">
                                    <div class="notification-icon order">
                                        <i class="bi bi-cart-check"></i>
                                    </div>
                                    <div class="notification-content">
                                        <h4>새 예약이 들어왔습니다</h4>
                                        <p>제주 스쿠버다이빙 체험</p>
                                    </div>
                                    <span class="notification-time">10분 전</span>
                                </div>
                                <div class="notification-item unread">
                                    <div class="notification-icon review">
                                        <i class="bi bi-star"></i>
                                    </div>
                                    <div class="notification-content">
                                        <h4>새 후기가 등록되었습니다</h4>
                                        <p>한라산 트레킹 투어</p>
                                    </div>
                                    <span class="notification-time">1시간 전</span>
                                </div>
                                <div class="notification-item">
                                    <div class="notification-icon inquiry">
                                        <i class="bi bi-chat-dots"></i>
                                    </div>
                                    <div class="notification-content">
                                        <h4>문의가 접수되었습니다</h4>
                                        <p>제주 서핑 레슨 관련</p>
                                    </div>
                                    <span class="notification-time">3시간 전</span>
                                </div>
                                <div class="notification-item">
                                    <div class="notification-icon system">
                                        <i class="bi bi-gear"></i>
                                    </div>
                                    <div class="notification-content">
                                        <h4>정산 완료</h4>
                                        <p>2월 정산금 입금 완료</p>
                                    </div> 
                                    <span class="notification-time">어제</span>  -->
                                </div>
                            </div>
                        </div>
                    </div> 

                <!-- 상품 현황 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-box-seam"></i> 상품 현황</h3>
                        <a href="${pageContext.request.contextPath}/mypage/business/products" class="view-all">
                            전체보기 <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>

                    <div class="product-manage-list">
                        <c:choose>
				            <c:when test="${empty dashboard.productList}"> <div class="noti-empty">등록된 상품이 없습니다.</div>
				            </c:when>
				            <c:otherwise>
				                <c:forEach items="${dashboard.productList}" var="prod">
				                    <div class="product-manage-item">
				                        <div class="product-manage-info">
				                            <img src="${not empty prod.thumbImage ? prod.thumbImage : 'https://via.placeholder.com/80'}" alt="상품">
				                            <div class="product-manage-details">
				                            <a href="${pageContext.request.contextPath}${prod.prodCtgryType eq 'accommodation' ? '/product/accommodation' : '/tour'}/${prod.tripProdNo}" 
       												style="text-decoration: none; color: inherit;">
				                                <h4>${prod.title}</h4>
				                                </a>
				                                <span class="category">${prod.prodCtgryType eq 'ACCOMMODATION' ? '숙박' : '투어/체험'}</span>
				                                <div class="price"><fmt:formatNumber value="${prod.price}" pattern="#,###"/>원</div>
				                            </div>
				                        </div>
				                        <div class="product-stats">
				                            <div class="product-stat">
				                                <div class="value">${prod.viewCount}</div> <div class="label">조회</div>
				                            </div>
				                            <div class="product-stat">
				                                <div class="value">${prod.resvCount}</div> <div class="label">예약</div>
				                            </div>
				                            <div class="product-stat">
				                                <div class="value">${not empty prod.rating ? prod.rating : '0.0'}</div>
				                                <div class="label">평점</div>
				                            </div>
				                        </div>
				                        <span class="product-status active">판매중</span>
				                    </div>
				                </c:forEach>
				            </c:otherwise>
				        </c:choose>
                    </div>
                </div>
                				
            </div>
		</div>


<script>
(async function () {
  const contextPath = "${pageContext.request.contextPath}";
  const url = contextPath + "/api/company/dashboard";

  try {
    const res = await fetch(url, { method: "GET", headers: { "Accept": "application/json" }});
    if (!res.ok) throw new Error("HTTP " + res.status);

    const data = await res.json();
    
    // KPI 데이터 채우기
    const kpi = data.kpi || {};
    const won = (n) => (n ?? 0).toLocaleString("ko-KR") + "원";
    const num = (n) => (n ?? 0).toLocaleString("ko-KR");

    document.querySelector("#monthlySales").textContent = won(kpi.monthlySales);
    document.querySelector("#monthlyReservations").textContent = num(kpi.monthlyReservations);
    document.querySelector("#sellingProductCount").textContent = num(kpi.sellingProductCount);

    // 매출 현황 꺾은선 그래프
    const salesData = data.monthlySalesChart || [];
    const salesLabels = salesData.map(item => item.month); // 진짜 월 데이터
    const salesTotals = salesData.map(item => item.total); // 진짜 금액 데이터

    const salesCtx = document.getElementById('myChart').getContext('2d');
    new Chart(salesCtx, {
        type: 'line',
        data: {
            labels: salesLabels.length ? salesLabels : ['데이터 없음'], 
            datasets: [{
                label: '월별 매출액',
                data: salesTotals.length ? salesTotals : [0],
                borderColor: '#1f6feb',
                backgroundColor: 'rgba(31, 111, 235, 0.1)',
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, ticks: { callback: (v) => v.toLocaleString() + '원' } }
            }
        }
    });

    // 상품 카테고리 비중 (도넛 차트)
    const categoryData = data.categoryRatio || []; // 서버에서 준 리스트 (없으면 빈배열)
    
    // DB값이 'ACCOMMODATION'이면 '숙박', 그 외엔 '투어'로 이름표 바꿔주기
    const catLabels = categoryData.map(item => item.type === 'accommodation' ? '숙박' : '투어/체험');
    const catCounts = categoryData.map(item => item.cnt);

    const pieCtx = document.getElementById('categoryChart').getContext('2d');
    new Chart(pieCtx, {
        type: 'doughnut',
        data: {
            labels: catLabels.length ? catLabels : ['상품 없음'],
            datasets: [{
                data: catCounts.length ? catCounts : [1], // 데이터 없으면 회색 원이라도 나오게
                backgroundColor: ['#1f6feb', '#3fb950', '#dddddd'],
                borderWidth: 0
            }]
        },
        options: {
            cutout: '70%',
            plugins: { legend: { position: 'bottom' } }
        }
    });

  } catch (e) {
    console.error("대시보드 로딩 실패:", e);
  }
  
//1. 다가오는 예약 리스트 렌더링
  const resvList = document.querySelector("#upcomingReservations ul");
  const reservations = data.upcomingReservations || [];

  if(reservations.length > 0) {
      resvList.innerHTML = reservations.map(r => `
          <li class="list-group-item d-flex justify-content-between align-items-center">
              <div>
                  <strong style="font-size: 1.1em;">\${r.memName}</strong>
                  <div style="font-size: 0.85em; color: #666;">\${r.prodName}</div>
              </div>
              <span class="badge bg-light text-dark border">\${r.resvDate}</span>
          </li>
      `).join('');
  } else {
      resvList.innerHTML = '<li class="list-group-item text-center">예약 일정이 없습니다.</li>';
  }

// 2. 최근 리뷰 피드 렌더링
const reviewDiv = document.querySelector("#recentReviews");
const reviews = data.recentReviews || [];

if(reviews.length > 0) {
    reviewDiv.innerHTML = reviews.map(v => `
        <div class="review-card" style="padding: 15px; border-bottom: 1px solid #eee;">
            <div class="d-flex justify-content-between">
                <span style="font-weight: bold;">\${v.memName}</span>
                <span style="color: #ffc107;">\${'★'.repeat(v.reviewStar)}</span>
            </div>
            <div style="font-size: 0.9em; color: #444; margin-top: 5px;" class="text-truncate">
                \${v.reviewContent}
            </div>
            <div style="font-size: 0.8em; color: #999; margin-top: 5px;">\${v.regDate}</div>
        </div>
    `).join('');
} else {
    reviewDiv.innerHTML = '<div class="text-center" style="padding: 50px;">등록된 리뷰가 없습니다.</div>';
}
})();
</script>

<style>
/* 알림 리스트 */
.noti-list{
  list-style:none;
  padding:0;
  margin:0;
  display:flex;
  flex-direction:column;
  gap:10px;
}

.noti-item{
  display:flex;
  align-items:flex-start;
  gap:12px;
  padding:12px 12px;
  border:1px solid #eee;
  border-radius:14px;
  background:#fff;
  cursor:pointer;
  transition:transform .08s ease, box-shadow .08s ease;
}

.noti-item:hover{
  transform:translateY(-1px);
  box-shadow:0 6px 18px rgba(0,0,0,.06);
}

/* 읽지 않음 강조 */
.noti-item.unread{
  background:#f5fbff;
  border-color:#d9efff;
}

.noti-icon{
  width:36px;
  height:36px;
  border-radius:50%;
  display:flex;
  align-items:center;
  justify-content:center;
  flex:0 0 36px;
  font-size:18px;
}

/* 타입별 컬러(원하는대로 수정) */
.noti-item.type-order .noti-icon{ background:#e8f5ff; color:#1f6feb; }
.noti-item.type-review .noti-icon{ background:#fff5e6; color:#f59f00; }
.noti-item.type-inquiry .noti-icon{ background:#e6fff7; color:#0ca678; }
.noti-item.type-settle .noti-icon{ background:#f2f2f2; color:#495057; }

.noti-body{
  flex:1;
  min-width:0; /* ✅ 이거 없으면 줄바꿈 깨지고 세로로 찢어짐 */
}

.noti-title{
  font-weight:700;
  font-size:14px;
  margin:0 0 2px 0;
  white-space:nowrap;
  overflow:hidden;
  text-overflow:ellipsis;
}

.noti-desc{
  font-size:13px;
  margin:0;
  color:#666;
  overflow:hidden;
  display:-webkit-box;
  -webkit-line-clamp:1;
  -webkit-box-orient:vertical;
}

.noti-meta{
  flex:0 0 auto;
  font-size:12px;
  color:#8a8a8a;
  margin-left:auto;
  padding-left:10px;
  white-space:nowrap;
}

.noti-empty{
  padding:12px;
  color:#888;
  text-align:center;
}



</style>
<c:set var="pageJs" value="mypage" />
<%@ include file="../../common/footer.jsp" %>
