<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="포인트 내역" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../common/header.jsp" %>

<div class="mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>포인트 내역</h1>
                    <p>적립 및 사용 내역을 확인하세요</p>
                </div>

                <!-- 포인트 요약 -->
                <div class="content-section">
                    <div class="points-summary">
                        <div class="points-current">
                            <div class="label">보유 포인트</div>
                            <div class="value">12,500 <span class="unit">P</span></div>
                        </div>
                        <div class="points-info">
                            <div class="points-info-item">
                                <div class="label">이번 달 적립</div>
                                <div class="value">+3,200 P</div>
                            </div>
                            <div class="points-info-item">
                                <div class="label">이번 달 사용</div>
                                <div class="value">-500 P</div>
                            </div>
                            <div class="points-info-item">
                                <div class="label">소멸 예정</div>
                                <div class="value">1,000 P</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 포인트 안내 -->
                <div class="alert alert-info mb-4">
                    <i class="bi bi-info-circle me-2"></i>
                    <strong>포인트 안내</strong>
                    <ul class="mb-0 mt-2 ps-3">
                        <li>포인트는 결제 금액의 1~3%가 적립됩니다.</li>
                        <li>적립된 포인트는 1년간 유효하며, 미사용 시 자동 소멸됩니다.</li>
                        <li>1,000P 이상 보유 시 결제 시 사용 가능합니다.</li>
                    </ul>
                </div>

                <!-- 탭 -->
                <div class="mypage-tabs">
                    <button class="mypage-tab active" data-filter="all">전체</button>
                    <button class="mypage-tab" data-filter="earn">적립</button>
                    <button class="mypage-tab" data-filter="use">사용</button>
                    <button class="mypage-tab" data-filter="expire">소멸</button>
                </div>

                <!-- 포인트 내역 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-list-ul"></i> 포인트 내역</h3>
                        <select class="form-select form-select-sm" style="width: 120px;">
                            <option>최근 3개월</option>
                            <option>최근 6개월</option>
                            <option>최근 1년</option>
                            <option>전체</option>
                        </select>
                    </div>

                    <div class="point-list">
                        <!-- 적립 -->
                        <div class="point-item" data-type="earn">
                            <div class="point-info">
                                <h4>제주 스쿠버다이빙 체험 결제 적립</h4>
                                <p>2024.03.15</p>
                            </div>
                            <div class="point-amount plus">+1,360 P</div>
                        </div>

                        <!-- 적립 -->
                        <div class="point-item" data-type="earn">
                            <div class="point-info">
                                <h4>제주 신라 호텔 결제 적립</h4>
                                <p>2024.03.14</p>
                            </div>
                            <div class="point-amount plus">+3,200 P</div>
                        </div>

                        <!-- 사용 -->
                        <div class="point-item" data-type="use">
                            <div class="point-info">
                                <h4>부산 카약 체험 결제 사용</h4>
                                <p>2024.02.15</p>
                            </div>
                            <div class="point-amount minus">-500 P</div>
                        </div>

                        <!-- 적립 -->
                        <div class="point-item" data-type="earn">
                            <div class="point-info">
                                <h4>회원가입 축하 포인트</h4>
                                <p>2024.01.01</p>
                            </div>
                            <div class="point-amount plus">+5,000 P</div>
                        </div>

                        <!-- 적립 -->
                        <div class="point-item" data-type="earn">
                            <div class="point-info">
                                <h4>첫 예약 보너스 포인트</h4>
                                <p>2024.01.20</p>
                            </div>
                            <div class="point-amount plus">+2,000 P</div>
                        </div>

                        <!-- 적립 -->
                        <div class="point-item" data-type="earn">
                            <div class="point-info">
                                <h4>경주 한과 체험 결제 적립</h4>
                                <p>2024.01.20</p>
                            </div>
                            <div class="point-amount plus">+480 P</div>
                        </div>

                        <!-- 적립 -->
                        <div class="point-item" data-type="earn">
                            <div class="point-info">
                                <h4>후기 작성 보너스</h4>
                                <p>2024.02.01</p>
                            </div>
                            <div class="point-amount plus">+500 P</div>
                        </div>

                        <!-- 소멸 예정 -->
                        <div class="point-item" data-type="expire">
                            <div class="point-info">
                                <h4>소멸 예정 포인트</h4>
                                <p>소멸 예정일: 2025.01.01</p>
                            </div>
                            <div class="point-amount minus">-1,000 P</div>
                        </div>
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

<script>
// 탭 필터링
document.querySelectorAll('.mypage-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        document.querySelectorAll('.mypage-tab').forEach(t => t.classList.remove('active'));
        this.classList.add('active');

        const filter = this.dataset.filter;
        const points = document.querySelectorAll('.point-item');

        points.forEach(point => {
            if (filter === 'all') {
                point.style.display = 'flex';
            } else {
                const type = point.dataset.type;
                point.style.display = type === filter ? 'flex' : 'none';
            }
        });
    });
});
</script>

<c:set var="pageJs" value="mypage" />
<%@ include file="../common/footer.jsp" %>
