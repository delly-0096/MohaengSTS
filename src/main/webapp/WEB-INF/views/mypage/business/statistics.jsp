<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<c:set var="pageTitle" value="통계" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../../common/header.jsp" %>

<div class="mypage business-mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>통계</h1>
                    <p>상세 분석 데이터를 확인하세요</p>
                </div>

                <!-- 기간 선택 -->
                <div class="content-section">
                    <div class="d-flex gap-3 align-items-center flex-wrap">
                        <div class="d-flex gap-2">
                            <button class="btn btn-outline btn-sm period-btn" id="today" data-period="today">오늘</button>
                            <button class="btn btn-outline btn-sm period-btn" id="thisWeek" data-period="thisWeek">이번 주</button>
                            <button class="btn btn-outline btn-sm period-btn" id="thisMonth" data-period="thisMonth">이번 달</button>
                            <button class="btn btn-outline btn-sm period-btn active" id="last3Months" data-period="3months">최근 3개월</button>
                        </div>
                        <div class="d-flex gap-2 ms-auto">
                            <input type="date" class="form-control form-control-sm" id="startDate" style="width: 150px;">
                            <span class="align-self-center">~</span>
                            <input type="date" class="form-control form-control-sm" id="endDate" style="width: 150px;">
                            <button class="btn btn-primary btn-sm" id="searchBtn">조회</button>
                        </div>
                    </div>
                </div>

                <!-- 주요 지표 -->
                <div class="stats-grid">
                    <div class="stat-card primary">
                        <div class="stat-icon"><i class="bi bi-eye"></i></div>
                        <div class="stat-value" id="totalViews">3,456</div>
                        <div class="stat-label">총 조회수</div>
                    </div>
                    <div class="stat-card secondary">
                        <div class="stat-icon"><i class="bi bi-cart-check"></i></div>
                        <div class="stat-value" id="totalReservations">47</div>
                        <div class="stat-label">총 예약수</div>
                    </div>
                    <div class="stat-card accent">
                        <div class="stat-icon"><i class="bi bi-percent"></i></div>
                        <div class="stat-value" id="conversionRate">1.36%</div>
                        <div class="stat-label">전환율</div>
                    </div>
                    <div class="stat-card warning">
                        <div class="stat-icon"><i class="bi bi-star-fill"></i></div>
                        <div class="stat-value" id="avgRating">4.8</div>
                        <div class="stat-label">평균 평점</div>
                    </div>
                </div>

                <div class="row">
                    <!-- 조회수 추이 -->
                    <div class="col-lg-6">
                        <div class="content-section">
                            <div class="section-header">
                                <h3><i class="bi bi-graph-up"></i> 매출액 추이</h3>
                            </div>
                            <div class="chart-container">
								<canvas id="viewChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- 예약수 추이 -->
                    <div class="col-lg-6">
                        <div class="content-section">
                            <div class="section-header">
                                <h3><i class="bi bi-bar-chart"></i> 예약수 추이</h3>
                            </div>
                            <div class="chart-container">
								<canvas id="rsvChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- 상품별 통계 -->
                    <div class="col-lg-8">
                        <div class="content-section">
                            <div class="section-header">
                                <h3><i class="bi bi-box-seam"></i> 상품별 성과</h3>
                            </div>
                            <div class="table-responsive">
                                <table class="sales-table">
                                    <thead>
                                        <tr>
                                            <th>상품명</th>
                                            <th class="text-center">조회수</th>
                                            <th class="text-center">예약수</th>
                                            <th class="text-center">전환율</th>
                                            <th class="text-center">매출</th>
                                            <th class="text-center">평점</th>
                                        </tr>
                                    </thead>
                                    <tbody id="prodSgTable">
                                        <!-- 동적으로 데이터 삽입 -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- 예약자 분석 -->
                    <div class="col-lg-4">
                        <div class="content-section">
                            <div class="section-header">
                                <h3><i class="bi bi-people"></i> 예약자 분석</h3>
                            </div>

                            <!-- 성별 분포 -->
                            <h6 class="mb-3">성별 분포</h6>
                            <div class="mb-4">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>남성</span>
                                    <span class="fw-bold" id="malePercent">55%</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar" style="width: 55%; background: var(--primary-color);" id="maleProgress"></div>
                                </div>
                            </div>
                            <div class="mb-4">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>여성</span>
                                    <span class="fw-bold" id="femalePercent">45%</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar" style="width: 45%; background: var(--accent-color);" id="femaleProgress"></div>
                                </div>
                            </div>

                            <!-- 연령대 분포 -->
                            <h6 class="mb-3">연령대 분포</h6>
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>20대</span>
                                    <span class="fw-bold" id="age20Percent">35%</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar" style="width: 35%; background: var(--secondary-color);" id="age20Progress"></div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>30대</span>
                                    <span class="fw-bold" id="age30Percent">40%</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar" style="width: 40%; background: var(--secondary-color);" id="age30Progress"></div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>40대</span>
                                    <span class="fw-bold" id="age40Percent">18%</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar" style="width: 18%; background: var(--secondary-color);" id="age40Progress"></div>
                                </div>
                            </div>
                            <div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>50대 이상</span>
                                    <span class="fw-bold" id="age50Percent">7%</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar" style="width: 7%; background: var(--secondary-color);" id="age50Progress"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 후기 분석 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-chat-square-text"></i> 후기 분석</h3>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <div class="text-center p-4 bg-light rounded">
                                <div style="font-size: 48px; font-weight: 700; color: var(--primary-color);" id="averageRating">4.8</div>
                                <div class="mb-2">
                                    <i class="bi bi-star-fill text-warning"></i>
                                    <i class="bi bi-star-fill text-warning"></i>
                                    <i class="bi bi-star-fill text-warning"></i>
                                    <i class="bi bi-star-fill text-warning"></i>
                                    <i class="bi bi-star-half text-warning"></i>
                                </div>
                                <p class="text-muted mb-0">총 127개 후기</p>
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div class="p-3">
                                <div class="d-flex align-items-center mb-2">
                                    <span style="width: 40px;">5점</span>
                                    <div class="progress flex-grow-1 mx-3" style="height: 12px;">
                                        <div class="progress-bar bg-success" style="width: 75%;"></div>
                                    </div>
                                    <span style="width: 50px;">95개</span>
                                </div>
                                <div class="d-flex align-items-center mb-2">
                                    <span style="width: 40px;">4점</span>
                                    <div class="progress flex-grow-1 mx-3" style="height: 12px;">
                                        <div class="progress-bar bg-primary" style="width: 18%;"></div>
                                    </div>
                                    <span style="width: 50px;">23개</span>
                                </div>
                                <div class="d-flex align-items-center mb-2">
                                    <span style="width: 40px;">3점</span>
                                    <div class="progress flex-grow-1 mx-3" style="height: 12px;">
                                        <div class="progress-bar bg-warning" style="width: 5%;"></div>
                                    </div>
                                    <span style="width: 50px;">6개</span>
                                </div>
                                <div class="d-flex align-items-center mb-2">
                                    <span style="width: 40px;">2점</span>
                                    <div class="progress flex-grow-1 mx-3" style="height: 12px;">
                                        <div class="progress-bar bg-danger" style="width: 2%;"></div>
                                    </div>
                                    <span style="width: 50px;">2개</span>
                                </div>
                                <div class="d-flex align-items-center">
                                    <span style="width: 40px;">1점</span>
                                    <div class="progress flex-grow-1 mx-3" style="height: 12px;">
                                        <div class="progress-bar bg-danger" style="width: 1%;"></div>
                                    </div>
                                    <span style="width: 50px;">1개</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 자주 사용되는 키워드 -->
                    <div class="mt-4">
<!--                         <h6 class="mb-3">자주 사용되는 키워드</h6> -->
                        <div class="d-flex flex-wrap gap-2">
<!--                             <span class="badge bg-primary" style="font-size: 14px; padding: 8px 16px;">친절해요 (45)</span> -->
<!--                             <span class="badge bg-primary" style="font-size: 14px; padding: 8px 16px;">재미있어요 (38)</span> -->
<!--                             <span class="badge bg-primary" style="font-size: 14px; padding: 8px 16px;">추천해요 (35)</span> -->
<!--                             <span class="badge bg-secondary" style="font-size: 13px; padding: 6px 12px;">안전해요 (28)</span> -->
<!--                             <span class="badge bg-secondary" style="font-size: 13px; padding: 6px 12px;">가성비 좋아요 (22)</span> -->
<!--                             <span class="badge bg-secondary" style="font-size: 13px; padding: 6px 12px;">경치가 좋아요 (18)</span> -->
<!--                             <span class="badge bg-light text-dark" style="font-size: 12px; padding: 5px 10px;">초보자도 가능 (15)</span> -->
<!--                             <span class="badge bg-light text-dark" style="font-size: 12px; padding: 5px 10px;">설명이 자세해요 (12)</span> -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
//전역 변수로 차트 인스턴스 저장 (중복 생성 방지용)
let viewChartInstance = null;
let rsvChartInstance = null;

// [1] 페이지 로드 시 실행할 초기화 함수
document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll('.period-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.period-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            
            const period = this.dataset.period;
            console.log("Selected period:", period);
            setPeriod(period);
            // loadAllData();
        });
    });

    $("#searchBtn").on("click", function() {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        loadProdSgList(startDate, endDate);
        initSalesData(startDate, endDate);
        initGenderData(startDate, endDate);
        updateStatsByAge(startDate, endDate);
    });
    

    initDashboard();
    setPeriod('3months'); // 기본 기간 설정
});

function initDashboard() {
    // 임시 더미 데이터 생성 (최근 6개월 치)
    const dummyViews = [
        { month: '1월', count: 120 }, { month: '2월', count: 190 }, 
        { month: '3월', count: 300 }, { month: '4월', count: 250 }, 
        { month: '5월', count: 420 }, { month: '6월', count: 550 }
    ];

    const dummyRsvs = [
        { month: '1월', count: 15 }, { month: '2월', count: 23 }, 
        { month: '3월', count: 45 }, { month: '4월', count: 30 }, 
        { month: '5월', count: 60 }, { month: '6월', count: 85 }
    ];

    updateSalesChart(dummyViews);
    updateRsvChart(dummyRsvs);
}

// [2] 매출 차트 (Line Chart) 그리기
function updateSalesChart(dataList) {
    const ctx = document.getElementById('viewChart').getContext('2d');
    const labels = dataList.map(item => item.date);
    const data = dataList.map(item => item.sales);

    if (viewChartInstance) viewChartInstance.destroy(); // 기존 차트 삭제

    viewChartInstance = new Chart(ctx, {
        type: 'line', // 라인 차트
        data: {
            labels: labels,
            datasets: [{
                label: '월별 매출',
                data: data,
                borderColor: '#10B981', // 초록색 계열
                backgroundColor: 'rgba(16, 185, 129, 0.2)',
                tension: 0.3, // 곡선 부드럽게
                fill: true,
                pointRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.parsed.y + '회'; // 단위 변경
                        }
                    }
                }
            },
            scales: {
                y: { beginAtZero: true }
            }
        }
    });
}

// [3] 예약수 차트 (Bar Chart) 그리기
function updateRsvChart(dataList) {
    const ctx = document.getElementById('rsvChart').getContext('2d');
    const labels = dataList.map(item => item.month);
    const data = dataList.map(item => item.count);

    if (rsvChartInstance) rsvChartInstance.destroy();

    rsvChartInstance = new Chart(ctx, {
        type: 'bar', // 바 차트
        data: {
            labels: labels,
            datasets: [{
                label: '월별 예약수',
                data: data,
                backgroundColor: 'rgba(59, 130, 246, 0.7)', // 파란색 (기존 색상 유지)
                borderColor: 'rgba(59, 130, 246, 1)',
                borderWidth: 1,
                borderRadius: 4,
                barPercentage: 0.5 // 바 두께 조절
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.parsed.y + '건'; // 단위 변경
                        }
                    }
                }
            },
            scales: {
                y: { beginAtZero: true }
            }
        }
    });
}

function loadProdSgList(startDate, endDate) {
    let data = {
        startDate: startDate || '',
        endDate: endDate || ''
    };

	fetch('/statistics/prodSgList', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
        console.log(data);
        let prodSgBody = document.getElementById('prodSgTable');
        prodSgBody.innerHTML = ''; // 기존 내용 초기화
        prodsgBodyHtml = '';
        data.forEach(prodSg => {
            prodsgBodyHtml += `
            <tr>
                <td>\${prodSg.tripProdTitle}</td>
                <td class="text-center viewCnt">\${prodSg.viewCnt}</td>
                <td class="text-center reservCnt">\${prodSg.reserv}</td>
                <td class="text-center converate text-success">\${prodSg.converate}%</td>
                <td class="text-center fw-bold">\${prodSg.sales.toLocaleString()}원</td>
                <td class="text-center rating"><i class="bi bi-star-fill text-warning"></i>\${prodSg.rating}</td>
            </tr>
            `;
        });
        prodSgBody.innerHTML = prodsgBodyHtml;

        let totalViews = 0;
        let totalReservations = 0;
        let totalRatings = 0;
        let ratingCount = 0;
        let conversionRate = 0;

        $(".viewCnt").each(function() {
            totalViews += parseInt($(this).text());
        });

        $(".reservCnt").each(function() {
            totalReservations += parseInt($(this).text());
        });

        $(".converate").each(function() {
            let rateText = $(this).text().replace('%', '').trim();
            if (rateText && rateText !== '0') {
                conversionRate += parseFloat(rateText);
            }
        });

        $(".rating").each(function() {
            let ratingText = $(this).text().trim();
            if (ratingText && ratingText !== '0') {
                totalRatings += parseFloat(ratingText);
                ratingCount++;
            }
        });

        conversionRate /= $(".converate").length;
        let rating = (totalRatings / ratingCount).toFixed(1);
        rating = isNaN(rating) ? '0.0' : rating;

        $("#totalViews").text(totalViews);
        $("#totalReservations").text(totalReservations);
        $("#conversionRate").text((conversionRate).toFixed(1) + "%");
        $("#avgRating").text(rating);
        $("#averageRating").text(rating);
    });
}

// 기간 설정
function setPeriod(period) {
    const today = new Date();
    let startDate, endDate;
    
    switch(period) {
        case 'today':
            startDate = today;
            endDate = today;
            break;
        case 'thisWeek':
            startDate = new Date(today);
            startDate.setDate(today.getDate() - today.getDay());
            endDate = today;
            break;
        case 'thisMonth':
            startDate = new Date(today.getFullYear(), today.getMonth(), 1);
            endDate = today;
            break;
        case '3months':
            startDate = new Date(today.getFullYear(), today.getMonth() - 2, 1);
            endDate = today;
            break;
    }
    
    currentStartDate = formatDate(startDate);
    currentEndDate = formatDate(endDate);
    
    document.getElementById('startDate').value = currentStartDate;
    document.getElementById('endDate').value = currentEndDate;

    loadProdSgList(currentStartDate, currentEndDate);
    initSalesData(currentStartDate, currentEndDate);
    updateGenderData(currentStartDate, currentEndDate);
    updateStatsByAge(currentStartDate, currentEndDate);
}

function initSalesData(startDate, endDate) {
    let data = {
        startDate: startDate || '',
        endDate: endDate || ''
    };

	fetch('/statistics/salesTrend', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
        console.log(data);
        let SalesData = [];
        let RsvData = [];
        SalesData.push({
            date: 0,
            sales: 0
        })
        data.forEach(item => {
            SalesData.push({
                date: item.payDt,
                sales: item.sales
            });

            RsvData.push({
                month: item.payDt,
                count: item.rsvCnt
            });
        });
        updateSalesChart(SalesData);
        updateRsvChart(RsvData);
    });
}

function updateGenderData(startDate, endDate) {
    let data = {
        startDate: startDate || '',
        endDate: endDate || ''
    };

	fetch('/statistics/genderRatio', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
        console.log(data);
        let total = data.total || 1; // 0으로 나누기 방지
        let malePercent = ((data.male / total) * 100).toFixed(1);
        let femalePercent = ((data.female / total) * 100).toFixed(1);
        
        document.getElementById('malePercent').innerText = malePercent + '%';
        document.getElementById('femalePercent').innerText = femalePercent + '%';
        document.getElementById('maleProgress').style.width = malePercent + '%';
        document.getElementById('femaleProgress').style.width = femalePercent + '%';
    });
}

function updateStatsByAge(startDate, endDate) {
    let data = {
        startDate: startDate || '',
        endDate: endDate || ''
    };

	fetch('/statistics/statsByAge', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
        console.log(data);
        let total   = Number(data.totalCnt || data.total || 0);
        let count20 = Number(data.cnt20s || data.age20 || 0); // 값이 없으면 0으로 처리
        let count30 = Number(data.cnt30s || data.age30 || 0);
        let count40 = Number(data.cnt40s || data.age40 || 0);
        let count50 = Number(data.cntOver50s || data.age50Over || 0);
        

        // 2. 0 나누기 방지 로직 추가
        let age20Percent = (total === 0) ? "0.0" : ((count20 / total) * 100).toFixed(1);
        let age30Percent = (total === 0) ? "0.0" : ((count30 / total) * 100).toFixed(1);
        let age40Percent = (total === 0) ? "0.0" : ((count40 / total) * 100).toFixed(1);
        let age50Percent = (total === 0) ? "0.0" : ((count50 / total) * 100).toFixed(1);

        // 3. 화면 적용
        document.getElementById('age20Percent').innerText = age20Percent + '%';
        document.getElementById('age30Percent').innerText = age30Percent + '%';
        document.getElementById('age40Percent').innerText = age40Percent + '%';
        document.getElementById('age50Percent').innerText = age50Percent + '%';

        document.getElementById('age20Progress').style.width = age20Percent + '%';
        document.getElementById('age30Progress').style.width = age30Percent + '%';
        document.getElementById('age40Progress').style.width = age40Percent + '%';
        document.getElementById('age50Progress').style.width = age50Percent + '%';

    });
}
</script>

<c:set var="pageJs" value="mypage" />
<%@ include file="../../common/footer.jsp" %>
