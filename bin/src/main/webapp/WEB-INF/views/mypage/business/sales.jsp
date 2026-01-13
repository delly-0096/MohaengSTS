<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="매출 집계" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../../common/header.jsp" %>

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
                        <div class="stat-icon"><i class="bi bi-currency-won"></i></div>
                        <div class="stat-value">3,250,000</div>
                        <div class="stat-label">이번 달 매출</div>
                    </div>
                    <div class="stat-card secondary">
                        <div class="stat-icon"><i class="bi bi-graph-up-arrow"></i></div>
                        <div class="stat-value">+15%</div>
                        <div class="stat-label">전월 대비</div>
                    </div>
                    <div class="stat-card accent">
                        <div class="stat-icon"><i class="bi bi-wallet2"></i></div>
                        <div class="stat-value">2,437,500</div>
                        <div class="stat-label">정산 예정</div>
                    </div>
                    <div class="stat-card warning">
                        <div class="stat-icon"><i class="bi bi-check2-circle"></i></div>
                        <div class="stat-value">2,850,000</div>
                        <div class="stat-label">지난달 정산</div>
                    </div>
                </div>

                <!-- 기간 선택 -->
                <div class="content-section">
                    <div class="d-flex gap-3 align-items-center flex-wrap">
                        <div class="d-flex gap-2">
                            <button class="btn btn-outline btn-sm active">이번 달</button>
                            <button class="btn btn-outline btn-sm">지난 달</button>
                            <button class="btn btn-outline btn-sm">최근 3개월</button>
                            <button class="btn btn-outline btn-sm">최근 6개월</button>
                        </div>
                        <div class="d-flex gap-2 ms-auto">
                            <input type="date" class="form-control form-control-sm" style="width: 150px;">
                            <span class="align-self-center">~</span>
                            <input type="date" class="form-control form-control-sm" style="width: 150px;">
                            <button class="btn btn-primary btn-sm">조회</button>
                        </div>
                    </div>
                </div>

                <!-- 매출 차트 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-graph-up"></i> 월별 매출 추이</h3>
                        <button class="btn btn-outline btn-sm">
                            <i class="bi bi-download me-2"></i>엑셀 다운로드
                        </button>
                    </div>

                    <div class="sales-chart-container">
                        <!-- 차트 플레이스홀더 -->
                        <div style="width: 100%; height: 100%; background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center;">
                            <div class="text-center">
                                <i class="bi bi-bar-chart" style="font-size: 48px; color: var(--primary-color);"></i>
                                <p class="mt-2 text-muted">Chart.js 등을 사용하여 차트 구현</p>
                            </div>
                        </div>
                    </div>

                    <!-- 월별 요약 -->
                    <div class="row text-center">
                        <div class="col-md-3">
                            <div class="p-3 bg-light rounded">
                                <small class="text-muted">1월</small>
                                <h5 class="mb-0">2,150,000원</h5>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="p-3 bg-light rounded">
                                <small class="text-muted">2월</small>
                                <h5 class="mb-0">2,850,000원</h5>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="p-3 bg-light rounded">
                                <small class="text-muted">3월</small>
                                <h5 class="mb-0 text-primary">3,250,000원</h5>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="p-3 bg-light rounded">
                                <small class="text-muted">누적</small>
                                <h5 class="mb-0 text-success">8,250,000원</h5>
                            </div>
                        </div>
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
                                    <span>12위</span>
                                </div>
                                <div class="rank-info">
                                    <div class="rank-label">동종업계 순위</div>
                                    <div class="rank-total">전체 156개 업체 중</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="comparison-rank-card">
                                <div class="rank-badge up">
                                    <i class="bi bi-graph-up-arrow"></i>
                                    <span>상위 8%</span>
                                </div>
                                <div class="rank-info">
                                    <div class="rank-label">매출 상위</div>
                                    <div class="rank-total">지난달 대비 2단계 상승</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="comparison-rank-card">
                                <div class="rank-badge highlight">
                                    <i class="bi bi-award-fill"></i>
                                    <span>+23%</span>
                                </div>
                                <div class="rank-info">
                                    <div class="rank-label">평균 대비 매출</div>
                                    <div class="rank-total">업계 평균보다 높음</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 상세 비교 지표 -->
                    <div class="comparison-metrics">
                        <div class="comparison-item">
                            <div class="comparison-header">
                                <span class="metric-name">월 매출</span>
                                <div class="metric-values">
                                    <span class="my-value">3,250,000원</span>
                                    <span class="vs">vs</span>
                                    <span class="avg-value">2,640,000원</span>
                                </div>
                            </div>
                            <div class="comparison-bar-container">
                                <div class="comparison-bar">
                                    <div class="bar-fill my-bar" style="width: 100%;"></div>
                                </div>
                                <div class="comparison-bar">
                                    <div class="bar-fill avg-bar" style="width: 81%;"></div>
                                </div>
                            </div>
                            <div class="comparison-legend">
                                <span class="legend-item my"><i class="bi bi-circle-fill"></i> 우리 업체</span>
                                <span class="legend-item avg"><i class="bi bi-circle-fill"></i> 업계 평균</span>
                                <span class="diff-badge positive">+23%</span>
                            </div>
                        </div>

                        <div class="comparison-item">
                            <div class="comparison-header">
                                <span class="metric-name">월 예약 수</span>
                                <div class="metric-values">
                                    <span class="my-value">47건</span>
                                    <span class="vs">vs</span>
                                    <span class="avg-value">32건</span>
                                </div>
                            </div>
                            <div class="comparison-bar-container">
                                <div class="comparison-bar">
                                    <div class="bar-fill my-bar" style="width: 100%;"></div>
                                </div>
                                <div class="comparison-bar">
                                    <div class="bar-fill avg-bar" style="width: 68%;"></div>
                                </div>
                            </div>
                            <div class="comparison-legend">
                                <span class="legend-item my"><i class="bi bi-circle-fill"></i> 우리 업체</span>
                                <span class="legend-item avg"><i class="bi bi-circle-fill"></i> 업계 평균</span>
                                <span class="diff-badge positive">+47%</span>
                            </div>
                        </div>

                        <div class="comparison-item">
                            <div class="comparison-header">
                                <span class="metric-name">평균 평점</span>
                                <div class="metric-values">
                                    <span class="my-value">4.8점</span>
                                    <span class="vs">vs</span>
                                    <span class="avg-value">4.2점</span>
                                </div>
                            </div>
                            <div class="comparison-bar-container">
                                <div class="comparison-bar">
                                    <div class="bar-fill my-bar" style="width: 96%;"></div>
                                </div>
                                <div class="comparison-bar">
                                    <div class="bar-fill avg-bar" style="width: 84%;"></div>
                                </div>
                            </div>
                            <div class="comparison-legend">
                                <span class="legend-item my"><i class="bi bi-circle-fill"></i> 우리 업체</span>
                                <span class="legend-item avg"><i class="bi bi-circle-fill"></i> 업계 평균</span>
                                <span class="diff-badge positive">+14%</span>
                            </div>
                        </div>

                        <div class="comparison-item">
                            <div class="comparison-header">
                                <span class="metric-name">재예약률</span>
                                <div class="metric-values">
                                    <span class="my-value">18%</span>
                                    <span class="vs">vs</span>
                                    <span class="avg-value">22%</span>
                                </div>
                            </div>
                            <div class="comparison-bar-container">
                                <div class="comparison-bar">
                                    <div class="bar-fill my-bar" style="width: 82%;"></div>
                                </div>
                                <div class="comparison-bar">
                                    <div class="bar-fill avg-bar" style="width: 100%;"></div>
                                </div>
                            </div>
                            <div class="comparison-legend">
                                <span class="legend-item my"><i class="bi bi-circle-fill"></i> 우리 업체</span>
                                <span class="legend-item avg"><i class="bi bi-circle-fill"></i> 업계 평균</span>
                                <span class="diff-badge negative">-18%</span>
                            </div>
                        </div>

                        <div class="comparison-item">
                            <div class="comparison-header">
                                <span class="metric-name">취소율</span>
                                <div class="metric-values">
                                    <span class="my-value">5%</span>
                                    <span class="vs">vs</span>
                                    <span class="avg-value">8%</span>
                                </div>
                            </div>
                            <div class="comparison-bar-container">
                                <div class="comparison-bar">
                                    <div class="bar-fill my-bar good" style="width: 62%;"></div>
                                </div>
                                <div class="comparison-bar">
                                    <div class="bar-fill avg-bar" style="width: 100%;"></div>
                                </div>
                            </div>
                            <div class="comparison-legend">
                                <span class="legend-item my"><i class="bi bi-circle-fill"></i> 우리 업체</span>
                                <span class="legend-item avg"><i class="bi bi-circle-fill"></i> 업계 평균</span>
                                <span class="diff-badge positive">-37% (양호)</span>
                            </div>
                        </div>
                    </div>

                    <!-- 개선 제안 -->
                    <div class="improvement-tips">
                        <h5><i class="bi bi-lightbulb me-2"></i>개선 포인트</h5>
                        <div class="tips-list">
                            <div class="tip-item warning">
                                <i class="bi bi-exclamation-circle"></i>
                                <div class="tip-content">
                                    <strong>재예약률이 평균보다 낮습니다.</strong>
                                    <p>리뷰 작성 고객에게 재예약 할인 쿠폰을 제공해보세요.</p>
                                </div>
                            </div>
                            <div class="tip-item success">
                                <i class="bi bi-check-circle"></i>
                                <div class="tip-content">
                                    <strong>평균 평점이 우수합니다!</strong>
                                    <p>높은 평점을 유지하며 리뷰 수를 늘려 신뢰도를 높이세요.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 상세 내역 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-list-ul"></i> 상세 내역</h3>
                        <div class="d-flex gap-2">
                            <select class="form-select form-select-sm" style="width: 120px;">
                                <option>전체 상태</option>
                                <option>확정</option>
                                <option>취소</option>
                            </select>
                            <div class="search-input-wrapper">
                                <input type="text" class="form-control form-control-sm"
                                       placeholder="예약번호, 상품명, 예약자 검색"
                                       style="width: 220px;" id="salesSearchInput">
                                <button type="button" class="search-btn" onclick="searchSalesDetail()">
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
                            <tbody>
                                <tr>
                                    <td>MH2403015</td>
                                    <td>2024.03.15 14:32</td>
                                    <td>제주 스쿠버다이빙 체험</td>
                                    <td>김OO</td>
                                    <td>2024.04.20</td>
                                    <td>136,000원</td>
                                    <td class="text-danger">-13,600원</td>
                                    <td class="fw-bold">122,400원</td>
                                    <td><span class="payment-status completed">확정</span></td>
                                </tr>
                                <tr>
                                    <td>MH2403014</td>
                                    <td>2024.03.14 11:20</td>
                                    <td>한라산 트레킹 투어</td>
                                    <td>이OO</td>
                                    <td>2024.03.25</td>
                                    <td>85,000원</td>
                                    <td class="text-danger">-8,500원</td>
                                    <td class="fw-bold">76,500원</td>
                                    <td><span class="payment-status completed">확정</span></td>
                                </tr>
                                <tr>
                                    <td>MH2403013</td>
                                    <td>2024.03.13 16:45</td>
                                    <td>제주 서핑 레슨</td>
                                    <td>박OO</td>
                                    <td>2024.03.20</td>
                                    <td>65,000원</td>
                                    <td class="text-danger">-6,500원</td>
                                    <td class="fw-bold">58,500원</td>
                                    <td><span class="payment-status completed">확정</span></td>
                                </tr>
                                <tr>
                                    <td>MH2403012</td>
                                    <td>2024.03.12 09:15</td>
                                    <td>제주 스쿠버다이빙 체험</td>
                                    <td>최OO</td>
                                    <td>2024.03.18</td>
                                    <td>204,000원</td>
                                    <td class="text-danger">-20,400원</td>
                                    <td class="fw-bold">183,600원</td>
                                    <td><span class="payment-status completed">확정</span></td>
                                </tr>
                                <tr>
                                    <td>MH2403011</td>
                                    <td>2024.03.11 18:30</td>
                                    <td>우도 자전거 투어</td>
                                    <td>정OO</td>
                                    <td>2024.03.15</td>
                                    <td>45,000원</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td><span class="payment-status cancelled">취소</span></td>
                                </tr>
                                <tr>
                                    <td>MH2403010</td>
                                    <td>2024.03.10 10:22</td>
                                    <td>한라산 트레킹 투어</td>
                                    <td>강OO</td>
                                    <td>2024.03.16</td>
                                    <td>170,000원</td>
                                    <td class="text-danger">-17,000원</td>
                                    <td class="fw-bold">153,000원</td>
                                    <td><span class="payment-status completed">확정</span></td>
                                </tr>
                            </tbody>
                            <tfoot>
                                <tr style="background: var(--light-color);">
                                    <td colspan="5" class="text-end fw-bold">합계</td>
                                    <td class="fw-bold">705,000원</td>
                                    <td class="text-danger fw-bold">-66,000원</td>
                                    <td class="fw-bold text-primary">594,000원</td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </table>
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
// 상세 내역 검색 기능
function searchSalesDetail() {
    const searchInput = document.getElementById('salesSearchInput');
    const keyword = searchInput.value.trim().toLowerCase();
    const tableRows = document.querySelectorAll('.sales-table tbody tr');

    // 검색어가 없으면 모든 행 표시
    if (!keyword) {
        tableRows.forEach(row => {
            row.classList.remove('search-hidden', 'search-highlight');
        });
        return;
    }

    let foundCount = 0;

    tableRows.forEach(row => {
        const cells = row.querySelectorAll('td');
        let rowText = '';

        cells.forEach(cell => {
            rowText += cell.textContent.toLowerCase() + ' ';
        });

        if (rowText.includes(keyword)) {
            row.classList.remove('search-hidden');
            row.classList.add('search-highlight');
            foundCount++;
        } else {
            row.classList.add('search-hidden');
            row.classList.remove('search-highlight');
        }
    });

    // 검색 결과 토스트 메시지
    if (foundCount > 0) {
        showToast(foundCount + '건의 검색 결과가 있습니다.', 'success');
    } else {
        showToast('검색 결과가 없습니다.', 'warning');
    }
}

// Enter 키로 검색
document.getElementById('salesSearchInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        searchSalesDetail();
    }
});

// 검색어 지우면 초기화
document.getElementById('salesSearchInput').addEventListener('input', function() {
    if (this.value === '') {
        const tableRows = document.querySelectorAll('.sales-table tbody tr');
        tableRows.forEach(row => {
            row.classList.remove('search-hidden', 'search-highlight');
        });
    }
});
</script>
</body>
</html>
