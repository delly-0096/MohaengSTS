<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="pageTitle" value="매출 집계" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../../common/header.jsp" %><!-- SheetJS (엑셀 다운로드) -->

<script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>

<div class="mypage business-mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>매출 집계</h1>
                    <p>매출 현황과 정산 내역을 확인하세요</p>
                </div>

                <!-- 통계 카드 -->
                <div class="stats-grid">
                    <div class="stat-card primary">
                        <div class="stat-icon">₩</div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${stats.thisMonthSales}" pattern="#,###"/>원
                        </div>
                        <div class="stat-label">이번 달 매출</div>
                    </div>
                    <div class="stat-card secondary">
                        <div class="stat-icon"><i class="bi bi-graph-up-arrow"></i></div>
                        <div class="stat-value">
                            <c:choose>
                                <c:when test="${stats.growthRate >= 0}">+</c:when>
                            </c:choose>${stats.growthRate}%
                        </div>
                        <div class="stat-label">전월 대비</div>
                    </div>
                    <div class="stat-card accent">
                        <div class="stat-icon"><i class="bi bi-wallet2"></i></div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${stats.pendingSettle}" pattern="#,###"/>원
                        </div>
                        <div class="stat-label">정산 예정</div>
                    </div>
                    <div class="stat-card warning">
                        <div class="stat-icon"><i class="bi bi-check2-circle"></i></div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${stats.lastMonthSettle}" pattern="#,###"/>원
                        </div>
                        <div class="stat-label">지난달 정산</div>
                    </div>
                </div>

                <!-- 기간 선택 -->
                <div class="content-section">
                    <div class="d-flex gap-3 align-items-center flex-wrap">
                        <div class="d-flex gap-2">
                            <button class="btn btn-outline btn-sm period-btn active" data-period="thisMonth">이번 달</button>
                            <button class="btn btn-outline btn-sm period-btn" data-period="lastMonth">지난 달</button>
                            <button class="btn btn-outline btn-sm period-btn" data-period="3months">최근 3개월</button>
                            <button class="btn btn-outline btn-sm period-btn" data-period="6months">최근 6개월</button>
                        </div>
                        <div class="d-flex gap-2 ms-auto">
                            <input type="date" class="form-control form-control-sm" style="width: 150px;" id="startDate">
                            <span class="align-self-center">~</span>
                            <input type="date" class="form-control form-control-sm" style="width: 150px;" id="endDate">
                            <button class="btn btn-primary btn-sm" id="searchDateBtn">조회</button>
                        </div>
                    </div>
                </div>

                <!-- 매출 차트 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-graph-up"></i> 월별 매출 추이</h3>
                    </div>

                    <div class="sales-chart-container">
                        <canvas id="salesChart" style="width: 100%; height: 300px;"></canvas>
                    </div>

                    <!-- 월별 요약 -->
                    <div class="row text-center" id="monthlySummary">
                        <!-- 동적으로 생성됨 -->
                    </div>
                </div>

                <!-- 타 기업 비교 분석 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-bar-chart-line"></i> 동종업계 비교 분석</h3>
                        <span class="text-muted" style="font-size: 0.875rem;">투어/체험 카테고리 기준</span>
                    </div>

                    <!-- 순위 및 요약 카드 -->
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <div class="comparison-rank-card">
                                <div class="rank-badge">
                                    <i class="bi bi-trophy-fill"></i>
                                    <span id="myRank">-위</span>
                                </div>
                                <div class="rank-info">
                                    <div class="rank-label">동종업계 순위</div>
                                    <div class="rank-total">전체 <span id="totalCompanyCnt">0</span>개 업체 중</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="comparison-rank-card">
                                <div class="rank-badge up">
                                    <i class="bi bi-graph-up-arrow"></i>
                                    <span id="rankPercent">-%</span>
                                </div>
                                <div class="rank-info">
                                    <div class="rank-label">매출 상위</div>
                                    <div class="rank-total" id="rankChange">-%</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="comparison-rank-card">
                                <div class="rank-badge highlight">
                                    <i class="bi bi-award-fill"></i>
                                    <span id="salesDiffPercent">-</span>
                                </div>
                                <div class="rank-info">
                                    <div class="rank-label">평균 대비 매출</div>
                                    <div class="rank-total" id="salesDiffText">-</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 상세 비교 지표 -->
                    <div class="comparison-metrics" id="comparisonMetrics">
                        <!-- 동적으로 생성됨 -->
                    </div>
                </div>
                
                <!-- 상품별 정산 목록 -->
				<div class="content-section">
				    <div class="section-header">
				        <h3><i class="bi bi-box-seam"></i> 상품별 정산 현황</h3>
				        <button class="btn btn-primary btn-sm" id="settleRequestBtn" disabled>
				            <i class="bi bi-cash-coin me-2"></i>정산 요청
				        </button>
				    </div>
				
				    <div class="table-responsive">
				        <table class="sales-table product-sales-table">
				            <thead>
				                <tr>
				                    <th style="width: 5%;">
				                        <input type="checkbox" id="selectAllProducts" onclick="toggleAllProducts()">
				                    </th>
				                    <th>상품명</th>
				                    <th style="width: 10%;">예약 건수</th>
				                    <th style="width: 12%;">결제 금액</th>
				                    <th style="width: 12%;">수수료</th>
				                    <th style="width: 12%;">정산가능 금액</th>
				                    <th style="width: 10%;">정산가능 건수</th>
				                </tr>
				            </thead>
				            <tbody id="productSalesTableBody">
				                <!-- 동적으로 생성됨 -->
				            </tbody>
				            <tfoot>
							    <tr style="background: var(--light-color);">
							        <td></td>
							        <td class="text-end fw-bold">합계</td>
							        <td></td>
							        <td class="fw-bold text-end" id="productTotalNetSales">0원</td>
							        <td class="text-danger fw-bold text-end" id="productTotalCommission">0원</td>
							        <td class="fw-bold text-primary text-end" id="productTotalSettleAmt">0원</td>
							        <td></td>
							    </tr>
							</tfoot>
				        </table>
				    </div>
				    
				    <!-- 데이터 없음 -->
				    <div class="text-center py-5" id="noProductDataMessage" style="display: none;">
				        <i class="bi bi-inbox" style="font-size: 48px; color: #ccc;"></i>
				        <p class="mt-3 text-muted">조회된 데이터가 없습니다.</p>
				    </div>
				
				    <!-- 페이지네이션 -->
				    <div class="pagination-container">
				        <nav>
				            <ul class="pagination" id="productPagination">
				                <!-- 동적으로 생성됨 -->
				            </ul>
				        </nav>
				    </div>
				</div>

                <!-- 상세 내역 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-list-ul"></i> 상세 내역</h3>
                        <div class="d-flex gap-2">
	                        <button class="btn btn-outline btn-sm" id="excelDownloadBtn">
				                <i class="bi bi-download me-2"></i>엑셀 다운로드
				            </button>
                            <select class="form-select form-select-sm" style="width: 120px;" id="statusFilter">
                                <option value="">전체 상태</option>
                                <option value="정산대기">정산대기</option>
                                <option value="정산가능">정산가능</option>
							    <option value="정산요청">정산요청</option>
                                <option value="정산완료">정산완료</option>
                                <option value="취소">취소</option>
                            </select>
                            <div class="search-input-wrapper">
                                <input type="text" class="form-control form-control-sm"
                                       placeholder="예약번호, 상품명, 예약자 검색"
                                       style="width: 220px;" id="salesSearchInput">
                                <button type="button" class="search-btn" id="searchBtn">
                                    <i class="bi bi-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="sales-table">
                            <thead>
                                <tr>
                                    <th>예약번호</th>
                                    <th>예약일시</th>
                                    <th>상품명</th>
                                    <th>예약자</th>
                                    <th>이용일</th>
                                    <th>금액</th>
                                    <th>수수료</th>
                                    <th>정산액</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody id="salesTableBody">
                                <!-- 동적으로 생성됨 -->
                            </tbody>
                            <tfoot>
                                <tr style="background: var(--light-color);">
                                    <td colspan="5" class="text-end fw-bold">합계</td>
                                    <td class="fw-bold" id="totalNetSales">0원</td>
                                    <td class="text-danger fw-bold" id="totalCommission">0원</td>
                                    <td class="fw-bold text-primary" id="totalSettleAmt">0원</td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                    
                    <!-- 데이터 없음 -->
                    <div class="text-center py-5" id="noDataMessage" style="display: none;">
                        <i class="bi bi-inbox" style="font-size: 48px; color: #ccc;"></i>
                        <p class="mt-3 text-muted">조회된 데이터가 없습니다.</p>
                    </div>
                </div>

                <!-- 페이지네이션 -->
                <div class="pagination-container">
                    <nav>
                        <ul class="pagination" id="pagination">
                            <!-- 동적으로 생성됨 -->
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
/* ===== 정산 상태 스타일 추가 ===== */
.payment-status.waiting {
    background: #fef3c7;
    color: #92400e;
}

.payment-status.ready {
    background: #dbeafe;
    color: #1e40af;
}

/* ===== 매출 상세 내역 테이블 컬럼 너비 ===== */
.sales-table th {
    text-align: center !important;
}

/* 컬럼 너비 */
.sales-table th:nth-child(1),
.sales-table td:nth-child(1) { width: 14%; }  /* 예약번호 */

.sales-table th:nth-child(2),
.sales-table td:nth-child(2) { width: 10%; }  /* 예약일시 */

.sales-table th:nth-child(3),
.sales-table td:nth-child(3) { width: auto; }  /* 상품명 */

.sales-table th:nth-child(4),
.sales-table td:nth-child(4) { width: 8%; }  /* 예약자 */

.sales-table th:nth-child(5),
.sales-table td:nth-child(5) { width: 10%; }  /* 이용일 */

.sales-table th:nth-child(6),
.sales-table td:nth-child(6) { width: 11%; }  /* 금액 */

.sales-table th:nth-child(7),
.sales-table td:nth-child(7) { width: 11%; }  /* 수수료 */

.sales-table th:nth-child(8),
.sales-table td:nth-child(8) { width: 11%; }  /* 정산액 */

.sales-table th:nth-child(9),
.sales-table td:nth-child(9) { width: 8%; }  /* 상태 */

/* 데이터 셀 정렬 (td만) */
.sales-table td:nth-child(4) { text-align: center; }  /* 예약자 */
.sales-table td:nth-child(6),
.sales-table td:nth-child(7),
.sales-table td:nth-child(8) { text-align: right; }   /* 금액, 수수료, 정산액 */
.sales-table td:nth-child(9) { text-align: center; }  /* 상태 */

/* 합계 행 정렬 */
.sales-table tfoot td:nth-child(2),
.sales-table tfoot td:nth-child(3),
.sales-table tfoot td:nth-child(4) {
    text-align: right;
}

/* ===== 상품별 정산 테이블 ===== */
.product-sales-table th {
    text-align: center !important;
}

.product-sales-table td {
    vertical-align: middle;
}

.product-sales-table input[type="checkbox"] {
    width: 18px;
    height: 18px;
    cursor: pointer;
}

.product-sales-table input[type="checkbox"]:disabled {
    cursor: not-allowed;
    opacity: 0.5;
}

.product-sales-table tr:hover {
    background: #f8fafc;
}

/* 정산요청 상태 */
.payment-status.requested {
    background: #e0e7ff;
    color: #3730a3;
}

/* ===== 상품별 정산 테이블 컬럼 너비 ===== */
.product-sales-table th:nth-child(1),
.product-sales-table td:nth-child(1) { width: 5%; }  /* 체크박스 */

.product-sales-table th:nth-child(2),
.product-sales-table td:nth-child(2) { width: auto; }  /* 상품명 - 자동 (넓게) */

.product-sales-table th:nth-child(3),
.product-sales-table td:nth-child(3) { width: 11%; }  /* 예약 건수 */

.product-sales-table th:nth-child(4),
.product-sales-table td:nth-child(4) { width: 11%; }  /* 결제 금액 */

.product-sales-table th:nth-child(5),
.product-sales-table td:nth-child(5) { width: 11%; }  /* 수수료 */

.product-sales-table th:nth-child(6),
.product-sales-table td:nth-child(6) { width: 11%; }  /* 정산가능 금액 */

.product-sales-table th:nth-child(7),
.product-sales-table td:nth-child(7) { width: 11%; }  /* 정산가능 건수 */

.stat-icon {
  font-size: 1.6rem;
  font-weight: 700;
}
</style>
<!-- Chart.js CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<c:set var="pageJs" value="mypage" />
<c:set var="hasInlineScript" value="true" />
<%@ include file="../../common/footer.jsp" %>

<script>
// 전역 변수
let salesChart = null;
let currentPage = 1;
const pageSize = 10;
let currentStartDate = '';
let currentEndDate = '';
let productCurrentPage = 1;
const productPageSize = 10;
let selectedProducts = [];

// 페이지 로드 시 실행
document.addEventListener('DOMContentLoaded', function() {
    // 이번 달 기간 설정
    setThisMonth();
    // 데이터 로드
    loadAllData();
    
    // 이벤트 리스너 등록
    initEventListeners();
});

// 이벤트 리스너 초기화
function initEventListeners() {
    // 기간 버튼 클릭
    document.querySelectorAll('.period-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.period-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            
            const period = this.dataset.period;
            setPeriod(period);
            loadAllData();
        });
    });
    
    // 날짜 조회 버튼
    document.getElementById('searchDateBtn').addEventListener('click', function() {
        document.querySelectorAll('.period-btn').forEach(b => b.classList.remove('active'));
        currentStartDate = document.getElementById('startDate').value;
        currentEndDate = document.getElementById('endDate').value;
        loadAllData();
    });
    
    // 상태 필터 변경
    document.getElementById('statusFilter').addEventListener('change', function() {
        currentPage = 1;
        loadSalesList();
    });
    
    // 검색 버튼
    document.getElementById('searchBtn').addEventListener('click', function() {
        currentPage = 1;
        loadSalesList();
    });
    
    // 검색어 Enter
    document.getElementById('salesSearchInput').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            currentPage = 1;
            loadSalesList();
        }
    });
}

// 기간 설정
function setPeriod(period) {
    const today = new Date();
    let startDate, endDate;
    
    switch(period) {
        case 'thisMonth':
            startDate = new Date(today.getFullYear(), today.getMonth(), 1);
            endDate = today;
            break;
        case 'lastMonth':
            startDate = new Date(today.getFullYear(), today.getMonth() - 1, 1);
            endDate = new Date(today.getFullYear(), today.getMonth(), 0);
            break;
        case '3months':
            startDate = new Date(today.getFullYear(), today.getMonth() - 2, 1);
            endDate = today;
            break;
        case '6months':
            startDate = new Date(today.getFullYear(), today.getMonth() - 5, 1);
            endDate = today;
            break;
    }
    
    currentStartDate = formatDate(startDate);
    currentEndDate = formatDate(endDate);
    
    document.getElementById('startDate').value = currentStartDate;
    document.getElementById('endDate').value = currentEndDate;
}

function setThisMonth() {
    setPeriod('thisMonth');
}

// 날짜 포맷
function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return year + '-' + month + '-' + day;
}

// 전체 데이터 로드
function loadAllData() {
    const params = new URLSearchParams({
        startDate: currentStartDate,
        endDate: currentEndDate,
        page: currentPage,
        pageSize: pageSize
    });
    
    fetch(contextPath + '/mypage/business/sales/data?' + params)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // 차트 업데이트
                updateChart(data.monthlySales);
                // 월별 요약 업데이트
                updateMonthlySummary(data.monthlySales);
                // 동종업계 비교 업데이트
                updateComparison(data.comparison);
                // 테이블 업데이트
                renderSalesTable(data.list);
                // 합계 업데이트
                updateSummary(data.summary);
                // 페이지네이션 업데이트
                renderPagination(data.totalCount, data.totalPages);
            } else {
                showToast(data.message || '데이터를 불러오는데 실패했습니다.', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('데이터를 불러오는데 실패했습니다.', 'error');
        });
    
    loadProductSales();
}

// 목록만 로드 (페이징, 검색, 필터)
function loadSalesList() {
    const params = new URLSearchParams({
        startDate: currentStartDate,
        endDate: currentEndDate,
        page: currentPage,
        pageSize: pageSize,
        status: document.getElementById('statusFilter').value,
        keyword: document.getElementById('salesSearchInput').value
    });
    
    fetch(contextPath + '/mypage/business/sales/list?' + params)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                renderSalesTable(data.list);
                updateSummary(data.summary);
                renderPagination(data.totalCount, data.totalPages);
            }
        })
        .catch(error => {
            console.error('Error:', error);
        });
}

// 차트 업데이트
function updateChart(monthlySales) {
    const ctx = document.getElementById('salesChart').getContext('2d');
    
    const labels = monthlySales.map(item => item.saleMonth);
    const data = monthlySales.map(item => item.monthlyTotal || 0);
    
    if (salesChart) {
        salesChart.destroy();
    }
    
    salesChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: '월별 매출',
                data: data,
                backgroundColor: 'rgba(59, 130, 246, 0.7)',
                borderColor: 'rgba(59, 130, 246, 1)',
                borderWidth: 1,
                borderRadius: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.parsed.y.toLocaleString() + '원';
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return value.toLocaleString() + '원';
                        }
                    }
                }
            }
        }
    });
}

// 월별 요약 업데이트
function updateMonthlySummary(monthlySales) {
    const container = document.getElementById('monthlySummary');
    
    if (!monthlySales || monthlySales.length === 0) {
        container.innerHTML = '<div class="col-12"><p class="text-muted">데이터가 없습니다.</p></div>';
        return;
    }
    
    // 최근 3개월 + 누적
    const recentMonths = monthlySales.slice(-3);
    const total = monthlySales.reduce((sum, item) => sum + (item.monthlyTotal || 0), 0);
    
    let html = '';
    recentMonths.forEach((item, index) => {
        const isLast = index === recentMonths.length - 1;
        html += '<div class="col-md-3">';
        html += '<div class="p-3 bg-light rounded">';
        html += '<small class="text-muted">' + item.saleMonth + '</small>';
        html += '<h5 class="mb-0' + (isLast ? ' text-primary' : '') + '">' + (item.monthlyTotal || 0).toLocaleString() + '원</h5>';
        html += '</div></div>';
    });
    
    html += '<div class="col-md-3">';
    html += '<div class="p-3 bg-light rounded">';
    html += '<small class="text-muted">누적</small>';
    html += '<h5 class="mb-0 text-success">' + total.toLocaleString() + '원</h5>';
    html += '</div></div>';
    
    container.innerHTML = html;
}

// 동종업계 비교 업데이트
function updateComparison(comparison) {
    if (!comparison) {
        return;
    }
    
    // 순위 카드
    document.getElementById('myRank').textContent = (comparison.myRank || '-') + '위';
    document.getElementById('totalCompanyCnt').textContent = comparison.totalCompanyCnt || 0;
    
    // 상위 퍼센트 계산
    if (comparison.totalCompanyCnt > 0) {
        const percent = Math.round((comparison.myRank / comparison.totalCompanyCnt) * 100);
        document.getElementById('rankPercent').textContent = percent + '%';
        document.getElementById('rankChange').textContent = percent + '%';
    }
    
    // 평균 대비 매출
    const mySales = comparison.netSales || 0;
    const avgSales = comparison.avgSales || 0;
    if (avgSales > 0) {
        const diff = Math.round(((mySales - avgSales) / avgSales) * 100);
        document.getElementById('salesDiffPercent').textContent = (diff >= 0 ? '+' : '') + diff + '%';
        document.getElementById('salesDiffText').textContent = diff >= 0 ? '업계 평균보다 높음' : '업계 평균보다 낮음';
    }
    
    // 상세 비교 지표
    renderComparisonMetrics(comparison);
}

// 비교 지표 렌더링
function renderComparisonMetrics(c) {
    const container = document.getElementById('comparisonMetrics');
    
    const metrics = [
        { name: '월 매출', myValue: c.netSales, avgValue: c.avgSales, unit: '원', reverse: false },
        { name: '월 예약 수', myValue: c.resvCount, avgValue: c.avgResvCount, unit: '건', reverse: false },
        { name: '평균 평점', myValue: c.avgRating, avgValue: c.industryAvgRating, unit: '점', reverse: false, max: 5 },
        { name: '취소율', myValue: c.cancelRate, avgValue: c.avgCancelRate, unit: '%', reverse: true }
    ];
    
    let html = '';
    metrics.forEach(m => {
        const myVal = m.myValue || 0;
        const avgVal = m.avgValue || 0;
        const maxVal = m.max || Math.max(myVal, avgVal) || 1;
        
        const myPercent = Math.min((myVal / maxVal) * 100, 100);
        const avgPercent = Math.min((avgVal / maxVal) * 100, 100);
        
        let diff = 0;
        if (avgVal > 0) {
            diff = Math.round(((myVal - avgVal) / avgVal) * 100);
        }
        
        const isGood = m.reverse ? diff <= 0 : diff >= 0;
        const diffClass = isGood ? 'positive' : 'negative';
        const diffText = m.reverse && diff < 0 ? diff + '% (양호)' : (diff >= 0 ? '+' : '') + diff + '%';
        
        html += '<div class="comparison-item">';
        html += '<div class="comparison-header">';
        html += '<span class="metric-name">' + m.name + '</span>';
        html += '<div class="metric-values">';
        html += '<span class="my-value">' + (m.unit === '원' ? myVal.toLocaleString() : myVal) + m.unit + '</span>';
        html += '<span class="vs">vs</span>';
        html += '<span class="avg-value">' + (m.unit === '원' ? avgVal.toLocaleString() : avgVal) + m.unit + '</span>';
        html += '</div></div>';
        html += '<div class="comparison-bar-container">';
        html += '<div class="comparison-bar"><div class="bar-fill my-bar' + (m.reverse && isGood ? ' good' : '') + '" style="width: ' + myPercent + '%;"></div></div>';
        html += '<div class="comparison-bar"><div class="bar-fill avg-bar" style="width: ' + avgPercent + '%;"></div></div>';
        html += '</div>';
        html += '<div class="comparison-legend">';
        html += '<span class="legend-item my"><i class="bi bi-circle-fill"></i> 우리 업체</span>';
        html += '<span class="legend-item avg"><i class="bi bi-circle-fill"></i> 업계 평균</span>';
        html += '<span class="diff-badge ' + diffClass + '">' + diffText + '</span>';
        html += '</div></div>';
    });
    
    container.innerHTML = html;
}

// 테이블 렌더링
function renderSalesTable(list) {
    const tbody = document.getElementById('salesTableBody');
    const noData = document.getElementById('noDataMessage');
    
    if (!list || list.length === 0) {
        tbody.innerHTML = '';
        noData.style.display = 'block';
        return;
    }
    
    noData.style.display = 'none';
    
    let html = '';
    list.forEach(sale => {
        const statusClass = getStatusClass(sale.settleStatCd);
        
        html += '<tr>';
        html += '<td>' + formatPayNo(sale.payDt, sale.payNo) + '</td>';
        html += '<td>' + formatDateTime(sale.payDt) + '</td>';
        html += '<td>' + (sale.tripProdTitle || '-') + '</td>';
        html += '<td>' + sale.buyerName + '</td>';
        html += '<td>' + formatDateOnly(sale.resvDt) + (sale.useTime ? ' ' + sale.useTime : '') + '</td>';
        html += '<td>' + (sale.netSales || 0).toLocaleString() + '원</td>';
        
        if (sale.settleStatCd === '취소') {
            html += '<td>-</td>';
            html += '<td>-</td>';
        } else {
            html += '<td class="text-danger">-' + (sale.commission || 0).toLocaleString() + '원</td>';
            html += '<td class="fw-bold">' + (sale.settleAmt || 0).toLocaleString() + '원</td>';
        }
        
        html += '<td><span class="payment-status ' + statusClass + '">' + sale.settleStatCd + '</span></td>';
        html += '</tr>';
    });
    
    tbody.innerHTML = html;
}

// 상태 클래스
function getStatusClass(status) {
    switch(status) {
        case '정산완료': return 'completed';
        case '정산요청': return 'requested';
        case '정산가능': return 'ready';
        case '정산대기': return 'waiting';
        case '취소': return 'cancelled';
        default: return '';
    }
}

// 이름 마스킹
function maskName(name) {
    if (!name || name.length < 2) return name || '-';
    return name.charAt(0) + 'O'.repeat(name.length - 1);
}

// 날짜 포맷 (yyyy.MM.dd HH:mm)
function formatDateTime(dateStr) {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hour = String(date.getHours()).padStart(2, '0');
    const min = String(date.getMinutes()).padStart(2, '0');
    return year + '.' + month + '.' + day + ' ' + hour + ':' + min;
}

// 날짜만 포맷 (yyyy.MM.dd)
function formatDateOnly(dateStr) {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return year + '.' + month + '.' + day;
}

// 합계 업데이트
function updateSummary(summary) {
    if (!summary) return;
    
    document.getElementById('totalNetSales').textContent = (summary.netSales || 0).toLocaleString() + '원';
    document.getElementById('totalCommission').textContent = '-' + (summary.commission || 0).toLocaleString() + '원';
    document.getElementById('totalSettleAmt').textContent = (summary.settleAmt || 0).toLocaleString() + '원';
}

// 페이지네이션 렌더링
function renderPagination(totalCount, totalPages) {
    const container = document.getElementById('pagination');
    
    if (totalPages <= 1) {
        container.innerHTML = '';
        return;
    }
    
    let html = '';
    
    // 이전 버튼
    html += '<li class="page-item' + (currentPage === 1 ? ' disabled' : '') + '">';
    html += '<a class="page-link" href="#" onclick="goToPage(' + (currentPage - 1) + '); return false;"><i class="bi bi-chevron-left"></i></a>';
    html += '</li>';
    
    // 페이지 번호
    const startPage = Math.max(1, currentPage - 2);
    const endPage = Math.min(totalPages, startPage + 4);
    
    for (let i = startPage; i <= endPage; i++) {
        html += '<li class="page-item' + (i === currentPage ? ' active' : '') + '">';
        html += '<a class="page-link" href="#" onclick="goToPage(' + i + '); return false;">' + i + '</a>';
        html += '</li>';
    }
    
    // 다음 버튼
    html += '<li class="page-item' + (currentPage === totalPages ? ' disabled' : '') + '">';
    html += '<a class="page-link" href="#" onclick="goToPage(' + (currentPage + 1) + '); return false;"><i class="bi bi-chevron-right"></i></a>';
    html += '</li>';
    
    container.innerHTML = html;
}

// 페이지 이동
function goToPage(page) {
    if (page < 1) return;
    currentPage = page;
    loadSalesList();
    
    // 테이블로 스크롤
    document.querySelector('.sales-table').scrollIntoView({ behavior: 'smooth' });
}

function formatPayNo(payDt, payNo) {
    if (!payDt || !payNo) return '-';
    
    // payDt에서 날짜 추출 (YYYYMMDD)
    var date = new Date(payDt);
    var dateStr = date.getFullYear() +
                  String(date.getMonth() + 1).padStart(2, '0') +
                  String(date.getDate()).padStart(2, '0');
    
    // payNo 8자리로 맞춤
    var payNoStr = String(payNo).padStart(8, '0');
    
    return dateStr + payNoStr;  // 예: 2026012400000093
}

//상품별 매출 목록 로드
function loadProductSales() {
    const params = new URLSearchParams({
        startDate: currentStartDate,
        endDate: currentEndDate,
        productPage: productCurrentPage,
        productPageSize: productPageSize
    });
    
    fetch(contextPath + '/mypage/business/sales/products?' + params)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                renderProductSalesTable(data.list);
                updateProductSummary(data.summary);
                renderProductPagination(data.totalCount, data.totalPages);
            }
        })
        .catch(error => {
            console.error('Error:', error);
        });
}

// 상품별 매출 테이블 렌더링
function renderProductSalesTable(list) {
    const tbody = document.getElementById('productSalesTableBody');
    const noData = document.getElementById('noProductDataMessage');
    
    if (!list || list.length === 0) {
        tbody.innerHTML = '';
        noData.style.display = 'block';
        return;
    }
    
    noData.style.display = 'none';
    
    let html = '';
    list.forEach(item => {
        const isChecked = selectedProducts.includes(item.tripProdNo) ? 'checked' : '';
        const isDisabled = item.settleCount === 0 ? 'disabled' : '';
        
        html += '<tr data-prod-no="' + item.tripProdNo + '">';
        html += '<td style="text-align: center;"><input type="checkbox" class="product-checkbox" value="' + item.tripProdNo + '" ' + isChecked + ' ' + isDisabled + ' onchange="updateSelectedProducts()"></td>';
        html += '<td>' + (item.tripProdTitle || '-') + '</td>';
        html += '<td style="text-align: center;">' + (item.resvCount || 0) + '건</td>';
        html += '<td style="text-align: right;">' + (item.netSales || 0).toLocaleString() + '원</td>';
        html += '<td style="text-align: right;" class="text-danger">-' + (item.commission || 0).toLocaleString() + '원</td>';
        html += '<td style="text-align: right;" class="fw-bold text-primary">' + (item.settleAmt || 0).toLocaleString() + '원</td>';
        html += '<td style="text-align: center;">' + (item.settleCount || 0) + '건</td>';
        html += '</tr>';
    });
    
    tbody.innerHTML = html;
    
    // 전체 선택 체크박스 상태 업데이트
    updateSelectAllState();
}

// 상품별 합계 업데이트
function updateProductSummary(summary) {
    if (!summary) return;
    
    document.getElementById('productTotalNetSales').textContent = (summary.netSales || 0).toLocaleString() + '원';
    document.getElementById('productTotalCommission').textContent = '-' + (summary.commission || 0).toLocaleString() + '원';
    document.getElementById('productTotalSettleAmt').textContent = (summary.settleAmt || 0).toLocaleString() + '원';
}

// 상품별 페이지네이션 렌더링
function renderProductPagination(totalCount, totalPages) {
    const container = document.getElementById('productPagination');
    
    if (totalPages <= 1) {
        container.innerHTML = '';
        return;
    }
    
    let html = '';
    
    // 이전 버튼
    html += '<li class="page-item' + (productCurrentPage === 1 ? ' disabled' : '') + '">';
    html += '<a class="page-link" href="#" onclick="goToProductPage(' + (productCurrentPage - 1) + '); return false;"><i class="bi bi-chevron-left"></i></a>';
    html += '</li>';
    
    // 페이지 번호
    const startPage = Math.max(1, productCurrentPage - 2);
    const endPage = Math.min(totalPages, startPage + 4);
    
    for (let i = startPage; i <= endPage; i++) {
        html += '<li class="page-item' + (i === productCurrentPage ? ' active' : '') + '">';
        html += '<a class="page-link" href="#" onclick="goToProductPage(' + i + '); return false;">' + i + '</a>';
        html += '</li>';
    }
    
    // 다음 버튼
    html += '<li class="page-item' + (productCurrentPage === totalPages ? ' disabled' : '') + '">';
    html += '<a class="page-link" href="#" onclick="goToProductPage(' + (productCurrentPage + 1) + '); return false;"><i class="bi bi-chevron-right"></i></a>';
    html += '</li>';
    
    container.innerHTML = html;
}

// 상품 페이지 이동
function goToProductPage(page) {
    if (page < 1) return;
    productCurrentPage = page;
    loadProductSales();
    
    document.querySelector('.product-sales-table').scrollIntoView({ behavior: 'smooth' });
}

// 전체 선택 토글
function toggleAllProducts() {
    const selectAll = document.getElementById('selectAllProducts');
    const checkboxes = document.querySelectorAll('.product-checkbox:not(:disabled)');
    
    checkboxes.forEach(cb => {
        cb.checked = selectAll.checked;
    });
    
    updateSelectedProducts();
}

// 선택된 상품 업데이트
function updateSelectedProducts() {
    const checkboxes = document.querySelectorAll('.product-checkbox:checked');
    selectedProducts = Array.from(checkboxes).map(cb => parseInt(cb.value));
    
    // 정산 요청 버튼 활성화/비활성화
    const settleBtn = document.getElementById('settleRequestBtn');
    settleBtn.disabled = selectedProducts.length === 0;
    
    // 전체 선택 체크박스 상태 업데이트
    updateSelectAllState();
}

// 전체 선택 체크박스 상태 업데이트
function updateSelectAllState() {
    const selectAll = document.getElementById('selectAllProducts');
    const checkboxes = document.querySelectorAll('.product-checkbox:not(:disabled)');
    const checkedBoxes = document.querySelectorAll('.product-checkbox:checked');
    
    if (checkboxes.length === 0) {
        selectAll.checked = false;
        selectAll.disabled = true;
    } else {
        selectAll.disabled = false;
        selectAll.checked = checkboxes.length === checkedBoxes.length;
    }
}

// 정산 요청
document.getElementById('settleRequestBtn').addEventListener('click', function() {
    if (selectedProducts.length === 0) {
        showToast('정산 요청할 상품을 선택해주세요.', 'warning');
        return;
    }
    
    if (!confirm('선택한 ' + selectedProducts.length + '개 상품의 정산을 요청하시겠습니까?')) {
        return;
    }
    
    fetch(contextPath + '/mypage/business/sales/settle', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ prodNoList: selectedProducts })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast(data.message, 'success');
            selectedProducts = [];
            loadAllData();  // 전체 데이터 새로고침
        } else {
            showToast(data.message || '정산 요청에 실패했습니다.', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('정산 요청에 실패했습니다.', 'error');
    });
});

//엑셀 다운로드
document.getElementById('excelDownloadBtn').addEventListener('click', function() {
    // 전체 데이터 조회 (페이징 없이)
    const params = new URLSearchParams({
        startDate: currentStartDate,
        endDate: currentEndDate,
        page: 1,
        pageSize: 9999  // 전체 조회
    });
    
    fetch(contextPath + '/mypage/business/sales/list?' + params)
        .then(response => response.json())
        .then(data => {
            if (data.success && data.list.length > 0) {
                downloadExcel(data.list);
            } else {
                showToast('다운로드할 데이터가 없습니다.', 'warning');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showToast('엑셀 다운로드에 실패했습니다.', 'error');
        });
});

// 엑셀 파일 생성 및 다운로드
function downloadExcel(list) {
    // 데이터 가공
    const excelData = list.map(sale => ({
        '예약번호': formatPayNo(sale.payDt, sale.payNo),
        '예약일시': formatDateTime(sale.payDt),
        '상품명': sale.tripProdTitle || '-',
        '예약자': sale.buyerName || '-',
        '이용일': formatDateOnly(sale.resvDt) + (sale.useTime ? ' ' + sale.useTime : ''),
        '금액': sale.netSales || 0,
        '수수료': sale.settleStatCd === '취소' ? 0 : (sale.commission || 0),
        '정산액': sale.settleStatCd === '취소' ? 0 : (sale.settleAmt || 0),
        '상태': sale.settleStatCd || '-'
    }));
    
    // 워크시트 생성
    const ws = XLSX.utils.json_to_sheet(excelData);
    
    // 컬럼 너비 설정
    ws['!cols'] = [
        { wch: 20 },  // 예약번호
        { wch: 18 },  // 예약일시
        { wch: 30 },  // 상품명
        { wch: 10 },  // 예약자
        { wch: 18 },  // 이용일
        { wch: 12 },  // 금액
        { wch: 12 },  // 수수료
        { wch: 12 },  // 정산액
        { wch: 10 }   // 상태
    ];
    
    // 워크북 생성
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, '매출내역');
    
    // 파일명 생성 (매출내역_2026-01-01_2026-01-31.xlsx)
    const fileName = '매출내역_' + currentStartDate + '_' + currentEndDate + '.xlsx';
    
    // 다운로드
    XLSX.writeFile(wb, fileName);
    
    showToast('엑셀 다운로드가 완료되었습니다.', 'success');
}
</script>
<style>
/* ===== 정산 상태 스타일 추가 ===== */
.payment-status.waiting {
    background: #fef3c7;
    color: #92400e;
}

.payment-status.ready {
    background: #dbeafe;
    color: #1e40af;
}

/* ===== 매출 상세 내역 테이블 컬럼 너비 ===== */
.sales-table th {
    text-align: center !important;
}

/* 컬럼 너비 */
.sales-table th:nth-child(1),
.sales-table td:nth-child(1) { width: 14%; }  /* 예약번호 */

.sales-table th:nth-child(2),
.sales-table td:nth-child(2) { width: 10%; }  /* 예약일시 */

.sales-table th:nth-child(3),
.sales-table td:nth-child(3) { width: auto; }  /* 상품명 */

.sales-table th:nth-child(4),
.sales-table td:nth-child(4) { width: 8%; }  /* 예약자 */

.sales-table th:nth-child(5),
.sales-table td:nth-child(5) { width: 10%; }  /* 이용일 */

.sales-table th:nth-child(6),
.sales-table td:nth-child(6) { width: 11%; }  /* 금액 */

.sales-table th:nth-child(7),
.sales-table td:nth-child(7) { width: 11%; }  /* 수수료 */

.sales-table th:nth-child(8),
.sales-table td:nth-child(8) { width: 11%; }  /* 정산액 */

.sales-table th:nth-child(9),
.sales-table td:nth-child(9) { width: 8%; }  /* 상태 */

/* 데이터 셀 정렬 (td만) */
.sales-table td:nth-child(4) { text-align: center; }  /* 예약자 */
.sales-table td:nth-child(6),
.sales-table td:nth-child(7),
.sales-table td:nth-child(8) { text-align: right; }   /* 금액, 수수료, 정산액 */
.sales-table td:nth-child(9) { text-align: center; }  /* 상태 */

/* 합계 행 정렬 */
.sales-table tfoot td:nth-child(2),
.sales-table tfoot td:nth-child(3),
.sales-table tfoot td:nth-child(4) {
    text-align: right;
}

/* ===== 상품별 정산 테이블 ===== */
.product-sales-table th {
    text-align: center !important;
}

.product-sales-table td {
    vertical-align: middle;
}

.product-sales-table input[type="checkbox"] {
    width: 18px;
    height: 18px;
    cursor: pointer;
}

.product-sales-table input[type="checkbox"]:disabled {
    cursor: not-allowed;
    opacity: 0.5;
}

.product-sales-table tr:hover {
    background: #f8fafc;
}

/* 정산요청 상태 */
.payment-status.requested {
    background: #e0e7ff;
    color: #3730a3;
}

/* ===== 상품별 정산 테이블 컬럼 너비 ===== */
.product-sales-table th:nth-child(1),
.product-sales-table td:nth-child(1) { width: 5%; }  /* 체크박스 */

.product-sales-table th:nth-child(2),
.product-sales-table td:nth-child(2) { width: auto; }  /* 상품명 - 자동 (넓게) */

.product-sales-table th:nth-child(3),
.product-sales-table td:nth-child(3) { width: 11%; }  /* 예약 건수 */

.product-sales-table th:nth-child(4),
.product-sales-table td:nth-child(4) { width: 11%; }  /* 결제 금액 */

.product-sales-table th:nth-child(5),
.product-sales-table td:nth-child(5) { width: 11%; }  /* 수수료 */

.product-sales-table th:nth-child(6),
.product-sales-table td:nth-child(6) { width: 11%; }  /* 정산가능 금액 */

.product-sales-table th:nth-child(7),
.product-sales-table td:nth-child(7) { width: 11%; }  /* 정산가능 건수 */
</style>
</body>
</html>