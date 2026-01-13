<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
                            <button class="btn btn-outline btn-sm">오늘</button>
                            <button class="btn btn-outline btn-sm">이번 주</button>
                            <button class="btn btn-outline btn-sm active">이번 달</button>
                            <button class="btn btn-outline btn-sm">최근 3개월</button>
                        </div>
                        <div class="d-flex gap-2 ms-auto">
                            <input type="date" class="form-control form-control-sm" style="width: 150px;">
                            <span class="align-self-center">~</span>
                            <input type="date" class="form-control form-control-sm" style="width: 150px;">
                            <button class="btn btn-primary btn-sm">조회</button>
                        </div>
                    </div>
                </div>

                <!-- 주요 지표 -->
                <div class="stats-grid">
                    <div class="stat-card primary">
                        <div class="stat-icon"><i class="bi bi-eye"></i></div>
                        <div class="stat-value">3,456</div>
                        <div class="stat-label">총 조회수</div>
                    </div>
                    <div class="stat-card secondary">
                        <div class="stat-icon"><i class="bi bi-cart-check"></i></div>
                        <div class="stat-value">47</div>
                        <div class="stat-label">총 예약수</div>
                    </div>
                    <div class="stat-card accent">
                        <div class="stat-icon"><i class="bi bi-percent"></i></div>
                        <div class="stat-value">1.36%</div>
                        <div class="stat-label">전환율</div>
                    </div>
                    <div class="stat-card warning">
                        <div class="stat-icon"><i class="bi bi-star-fill"></i></div>
                        <div class="stat-value">4.8</div>
                        <div class="stat-label">평균 평점</div>
                    </div>
                </div>

                <div class="row">
                    <!-- 조회수 추이 -->
                    <div class="col-lg-6">
                        <div class="content-section">
                            <div class="section-header">
                                <h3><i class="bi bi-graph-up"></i> 조회수 추이</h3>
                            </div>
                            <div class="chart-container">
                                <div style="width: 100%; height: 100%; background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center;">
                                    <div class="text-center">
                                        <i class="bi bi-graph-up" style="font-size: 36px; color: var(--primary-color);"></i>
                                        <p class="mt-2 mb-0 text-muted">조회수 라인 차트</p>
                                    </div>
                                </div>
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
                                <div style="width: 100%; height: 100%; background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center;">
                                    <div class="text-center">
                                        <i class="bi bi-bar-chart" style="font-size: 36px; color: var(--secondary-color);"></i>
                                        <p class="mt-2 mb-0 text-muted">예약수 바 차트</p>
                                    </div>
                                </div>
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
                                    <tbody>
                                        <tr>
                                            <td>제주 스쿠버다이빙 체험</td>
                                            <td class="text-center">1,234</td>
                                            <td class="text-center">32</td>
                                            <td class="text-center text-success">2.59%</td>
                                            <td class="text-center fw-bold">2,176,000원</td>
                                            <td class="text-center"><i class="bi bi-star-fill text-warning"></i> 4.9</td>
                                        </tr>
                                        <tr>
                                            <td>한라산 트레킹 투어</td>
                                            <td class="text-center">856</td>
                                            <td class="text-center">15</td>
                                            <td class="text-center text-warning">1.75%</td>
                                            <td class="text-center fw-bold">1,275,000원</td>
                                            <td class="text-center"><i class="bi bi-star-fill text-warning"></i> 4.7</td>
                                        </tr>
                                        <tr>
                                            <td>제주 서핑 레슨</td>
                                            <td class="text-center">567</td>
                                            <td class="text-center">8</td>
                                            <td class="text-center text-warning">1.41%</td>
                                            <td class="text-center fw-bold">520,000원</td>
                                            <td class="text-center"><i class="bi bi-star-fill text-warning"></i> 4.8</td>
                                        </tr>
                                        <tr>
                                            <td>우도 자전거 투어</td>
                                            <td class="text-center">234</td>
                                            <td class="text-center">3</td>
                                            <td class="text-center text-danger">1.28%</td>
                                            <td class="text-center fw-bold">135,000원</td>
                                            <td class="text-center"><i class="bi bi-star-fill text-warning"></i> 4.5</td>
                                        </tr>
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
                                    <span class="fw-bold">55%</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar" style="width: 55%; background: var(--primary-color);"></div>
                                </div>
                            </div>
                            <div class="mb-4">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>여성</span>
                                    <span class="fw-bold">45%</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar" style="width: 45%; background: var(--accent-color);"></div>
                                </div>
                            </div>

                            <!-- 연령대 분포 -->
                            <h6 class="mb-3">연령대 분포</h6>
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>20대</span>
                                    <span class="fw-bold">35%</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar" style="width: 35%; background: var(--secondary-color);"></div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>30대</span>
                                    <span class="fw-bold">40%</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar" style="width: 40%; background: var(--secondary-color);"></div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>40대</span>
                                    <span class="fw-bold">18%</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar" style="width: 18%; background: var(--secondary-color);"></div>
                                </div>
                            </div>
                            <div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span>50대 이상</span>
                                    <span class="fw-bold">7%</span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar" style="width: 7%; background: var(--secondary-color);"></div>
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
                                <div style="font-size: 48px; font-weight: 700; color: var(--primary-color);">4.8</div>
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
                        <h6 class="mb-3">자주 사용되는 키워드</h6>
                        <div class="d-flex flex-wrap gap-2">
                            <span class="badge bg-primary" style="font-size: 14px; padding: 8px 16px;">친절해요 (45)</span>
                            <span class="badge bg-primary" style="font-size: 14px; padding: 8px 16px;">재미있어요 (38)</span>
                            <span class="badge bg-primary" style="font-size: 14px; padding: 8px 16px;">추천해요 (35)</span>
                            <span class="badge bg-secondary" style="font-size: 13px; padding: 6px 12px;">안전해요 (28)</span>
                            <span class="badge bg-secondary" style="font-size: 13px; padding: 6px 12px;">가성비 좋아요 (22)</span>
                            <span class="badge bg-secondary" style="font-size: 13px; padding: 6px 12px;">경치가 좋아요 (18)</span>
                            <span class="badge bg-light text-dark" style="font-size: 12px; padding: 5px 10px;">초보자도 가능 (15)</span>
                            <span class="badge bg-light text-dark" style="font-size: 12px; padding: 5px 10px;">설명이 자세해요 (12)</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<c:set var="pageJs" value="mypage" />
<%@ include file="../../common/footer.jsp" %>
