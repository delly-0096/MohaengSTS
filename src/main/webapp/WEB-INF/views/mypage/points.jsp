<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="pageTitle" value="포인트 내역" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../common/header.jsp" %>

<div class="mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
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
                            <div class="value"><span id="totalPoints">0</span> <span class="unit">P</span></div>
                        </div>
                        <div class="points-info">
                            <div class="points-info-item">
                                <div class="label">이번 달 적립</div>
                                <div class="value">+<span id="earnedThisMonth">0</span> P</div>
                            </div>
                            <div class="points-info-item">
                                <div class="label">이번 달 사용</div>
                                <div class="value">-<span id="usedThisMonth">0</span> P</div>
                            </div>
                            <div class="points-info-item">
                                <div class="label">소멸 예정</div>
                                <div class="value"><span id="expireSoonPoint">0</span> P</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 포인트 안내 -->
                <div class="alert alert-info mb-4">
                    <i class="bi bi-info-circle me-2"></i>
                    <strong>포인트 안내</strong>
                    <ul class="mb-0 mt-2 ps-3">
                        <li>회원가입 시 5,000P, 여행기록 작성 시 첫 1,000P/이후 500P, 상품리뷰 작성 시 500P가 적립됩니다.</li>
                        <li>상품 구매 시 결제 금액의 3%가 적립됩니다.</li>
                        <li>적립된 포인트는 6개월간 유효하며, 미사용 시 자동 소멸됩니다.</li>
                        <li>3,000P 이상 보유 시 결제 시 사용 가능합니다.</li>
                    </ul>
                </div>

                <!-- 탭 및 필터 -->
                <div class="mypage-tabs">
                    <button class="mypage-tab active" data-filter="all">전체</button>
                    <button class="mypage-tab" data-filter="P">적립</button>
                    <button class="mypage-tab" data-filter="M">사용</button>
                </div>

                <!-- 포인트 내역 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-list-ul"></i> 포인트 내역</h3>
                        <select id="periodFilter" class="form-select form-select-sm" style="width: 120px;">
                            <option value="3month">최근 3개월</option>
                            <option value="6month">최근 6개월</option>
                            <option value="1year">최근 1년</option>
                            <option value="all">전체</option>
                        </select>
                    </div>

                    <div class="point-list" id="pointList">
                        <!-- AJAX로 동적 로딩 -->
                    </div>
                </div>

                <!-- 페이지네이션 -->
                <div class="pagination-container" id="paginationArea">
                    <!-- AJAX로 동적 생성 -->
                </div>
            </div>
        </div>
    </div>
</div>

<script>
let currentPage = 1;
let currentType = 'all';
let currentPeriod = '3month';

// 페이지 로드 시 실행
$(document).ready(function() {
    loadSummary();
    loadHistory();
});

// 포인트 요약 정보 로드
function loadSummary() {
    $.ajax({
        url: '/mypage/points/summary',
        type: 'GET',
        success: function(response) {
            if (response.success) {
                const data = response.data;
                $('#totalPoints').text(data.totalPoints.toLocaleString());
                $('#earnedThisMonth').text(data.earnedThisMonth.toLocaleString());
                $('#usedThisMonth').text(data.usedThisMonth.toLocaleString());
                $('#expireSoonPoint').text(data.expireSoonPoint.toLocaleString());
            }
        },
        error: function() {
            alert('포인트 요약 정보를 불러오는데 실패했습니다.');
        }
    });
}

// 포인트 내역 로드
function loadHistory() {
    $.ajax({
        url: '/mypage/points/history',
        type: 'GET',
        data: {
            pointType: currentType,
            period: currentPeriod,
            page: currentPage
        },
        success: function(response) {
            if (response.success) {
                renderHistory(response.data);
                renderPagination(response.paginationVO);
            }
        },
        error: function() {
            alert('포인트 내역을 불러오는데 실패했습니다.');
        }
    });
}

// 포인트 내역 렌더링
function renderHistory(data) {
    let html = '';

    if (data.length === 0) {
        html = '<div class="empty-state"><p>포인트 내역이 없습니다.</p></div>';
    } else {
        data.forEach(function(item) {
            const isPlus = item.pointType === 'P';
            const typeClass = isPlus ? 'plus' : 'minus';
            const sign = isPlus ? '+' : '-';
            const amount = Math.abs(item.pointAmt);
            const date = new Date(item.regDt).toLocaleDateString('ko-KR');

            html += '<div class="point-item">';
            html += '  <div class="point-info">';
            html += '    <h4>' + item.pointDesc + '</h4>';
            html += '    <p>' + date + '</p>';
            html += '  </div>';
            html += '  <div class="point-amount ' + typeClass + '">' + sign + amount.toLocaleString() + ' P</div>';
            html += '</div>';
        });
    }

    $('#pointList').html(html);
}

// 페이지네이션 렌더링
function renderPagination(paginationVO) {
    $('#paginationArea').html(paginationVO.pagingHTML);

    // 페이지 클릭 이벤트
    $('.pagination a').on('click', function(e) {
        e.preventDefault();
        const page = $(this).data('page');
        if (page) {
            currentPage = page;
            loadHistory();
        }
    });
}

// 탭 클릭
$('.mypage-tab').on('click', function() {
    $('.mypage-tab').removeClass('active');
    $(this).addClass('active');

    const filter = $(this).data('filter');
    currentType = (filter === 'all') ? 'all' : filter;
    currentPage = 1;
    loadHistory();
});

// 기간 필터 변경
$('#periodFilter').on('change', function() {
    currentPeriod = $(this).val();
    currentPage = 1;
    loadHistory();
});
</script>

<c:set var="pageJs" value="mypage" />
<%@ include file="../common/footer.jsp" %>