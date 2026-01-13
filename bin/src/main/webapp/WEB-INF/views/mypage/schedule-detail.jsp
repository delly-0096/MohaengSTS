<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="일정 상세" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../common/header.jsp" %>

<div class="mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <!-- 상단 네비게이션 -->
                <nav class="breadcrumb-nav">
                    <a href="${pageContext.request.contextPath}/mypage/schedules"><i class="bi bi-arrow-left me-2"></i>내 일정 목록</a>
                </nav>

                <!-- 일정 헤더 -->
                <div class="schedule-detail-header">
                    <div class="schedule-detail-title">
                        <h1>제주도 3박 4일</h1>
                        <div class="schedule-badges">
                            <span class="schedule-badge upcoming">예정</span>
                            <span class="schedule-badge ai">AI 추천</span>
                        </div>
                    </div>
                    <div class="schedule-detail-actions">
                        <button class="btn btn-outline" onclick="editSchedule()">
                            <i class="bi bi-pencil me-1"></i>수정
                        </button>
                        <button class="btn btn-outline" onclick="shareSchedule()">
                            <i class="bi bi-share me-1"></i>공유
                        </button>
                        <button class="btn btn-outline text-danger" onclick="deleteSchedule()">
                            <i class="bi bi-trash me-1"></i>삭제
                        </button>
                    </div>
                </div>

                <!-- 일정 요약 정보 -->
                <div class="schedule-summary-card">
                    <div class="summary-item">
                        <i class="bi bi-calendar3"></i>
                        <div>
                            <span class="label">여행 기간</span>
                            <span class="value">2024.04.15 - 2024.04.18</span>
                        </div>
                    </div>
                    <div class="summary-item">
                        <i class="bi bi-geo-alt"></i>
                        <div>
                            <span class="label">여행지</span>
                            <span class="value">제주도</span>
                        </div>
                    </div>
                    <div class="summary-item">
                        <i class="bi bi-people"></i>
                        <div>
                            <span class="label">인원</span>
                            <span class="value">2명</span>
                        </div>
                    </div>
                    <div class="summary-item">
                        <i class="bi bi-pin-map"></i>
                        <div>
                            <span class="label">방문 장소</span>
                            <span class="value">8곳</span>
                        </div>
                    </div>
                </div>

                <!-- 일자별 탭 -->
                <div class="day-selector">
                    <button class="day-btn active" data-day="1" onclick="selectDetailDay(1)">
                        <span class="day-num">1</span>
                        <span class="day-date">4/15(월)</span>
                    </button>
                    <button class="day-btn" data-day="2" onclick="selectDetailDay(2)">
                        <span class="day-num">2</span>
                        <span class="day-date">4/16(화)</span>
                    </button>
                    <button class="day-btn" data-day="3" onclick="selectDetailDay(3)">
                        <span class="day-num">3</span>
                        <span class="day-date">4/17(수)</span>
                    </button>
                    <button class="day-btn" data-day="4" onclick="selectDetailDay(4)">
                        <span class="day-num">4</span>
                        <span class="day-date">4/18(목)</span>
                    </button>
                </div>

                <!-- 일정 타임라인 -->
                <div class="schedule-timeline-container">
                    <!-- Day 1 -->
                    <div class="day-timeline active" id="dayTimeline1">
                        <div class="day-title">
                            <h3>1일차 - 도착 & 동부 탐방</h3>
                            <span class="day-weather"><i class="bi bi-sun"></i> 18°C</span>
                        </div>

                        <div class="timeline-list">
                            <div class="timeline-item transport">
                                <div class="timeline-marker">
                                    <i class="bi bi-airplane"></i>
                                </div>
                                <div class="timeline-content">
                                    <div class="timeline-time">09:00 - 10:10</div>
                                    <div class="timeline-card">
                                        <div class="timeline-info">
                                            <span class="category-badge transport">이동</span>
                                            <h4>김포 → 제주 (항공편)</h4>
                                            <p><i class="bi bi-clock"></i> 비행시간 약 1시간 10분</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="timeline-item">
                                <div class="timeline-marker">1</div>
                                <div class="timeline-content">
                                    <div class="timeline-time">11:00 - 12:30</div>
                                    <div class="timeline-card with-image">
                                        <img src="https://images.unsplash.com/photo-1578469645742-46cae010e5d4?w=200&h=150&fit=crop&q=80" alt="성산일출봉">
                                        <div class="timeline-info">
                                            <span class="category-badge attraction">관광지</span>
                                            <h4>성산일출봉</h4>
                                            <p><i class="bi bi-geo-alt"></i> 제주 서귀포시 성산읍</p>
                                            <div class="timeline-meta">
                                                <span><i class="bi bi-star-fill text-warning"></i> 4.7</span>
                                                <span><i class="bi bi-clock"></i> 약 1시간 30분</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="timeline-item">
                                <div class="timeline-marker">2</div>
                                <div class="timeline-content">
                                    <div class="timeline-time">12:30 - 14:00</div>
                                    <div class="timeline-card with-image">
                                        <img src="https://images.unsplash.com/photo-1553621042-f6e147245754?w=200&h=150&fit=crop&q=80" alt="해녀의집">
                                        <div class="timeline-info">
                                            <span class="category-badge restaurant">맛집</span>
                                            <h4>해녀의집</h4>
                                            <p><i class="bi bi-geo-alt"></i> 제주 서귀포시 성산읍</p>
                                            <div class="timeline-meta">
                                                <span><i class="bi bi-star-fill text-warning"></i> 4.5</span>
                                                <span><i class="bi bi-currency-won"></i> 약 15,000원</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="timeline-item">
                                <div class="timeline-marker">3</div>
                                <div class="timeline-content">
                                    <div class="timeline-time">14:30 - 16:30</div>
                                    <div class="timeline-card with-image">
                                        <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=200&h=150&fit=crop&q=80" alt="우도">
                                        <div class="timeline-info">
                                            <span class="category-badge attraction">관광지</span>
                                            <h4>우도</h4>
                                            <p><i class="bi bi-geo-alt"></i> 제주 제주시 우도면</p>
                                            <div class="timeline-meta">
                                                <span><i class="bi bi-star-fill text-warning"></i> 4.8</span>
                                                <span><i class="bi bi-clock"></i> 약 2시간</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="timeline-item">
                                <div class="timeline-marker">4</div>
                                <div class="timeline-content">
                                    <div class="timeline-time">18:00 - 19:30</div>
                                    <div class="timeline-card with-image">
                                        <img src="https://images.unsplash.com/photo-1544025162-d76694265947?w=200&h=150&fit=crop&q=80" alt="흑돼지거리">
                                        <div class="timeline-info">
                                            <span class="category-badge restaurant">맛집</span>
                                            <h4>제주 흑돼지거리</h4>
                                            <p><i class="bi bi-geo-alt"></i> 제주 제주시 연동</p>
                                            <div class="timeline-meta">
                                                <span><i class="bi bi-star-fill text-warning"></i> 4.6</span>
                                                <span><i class="bi bi-currency-won"></i> 약 25,000원</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="timeline-item">
                                <div class="timeline-marker">
                                    <i class="bi bi-house"></i>
                                </div>
                                <div class="timeline-content">
                                    <div class="timeline-time">20:00</div>
                                    <div class="timeline-card">
                                        <div class="timeline-info">
                                            <span class="category-badge accommodation">숙소</span>
                                            <h4>제주 신라 호텔</h4>
                                            <p><i class="bi bi-geo-alt"></i> 제주시 중문관광로</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Day 2 -->
                    <div class="day-timeline" id="dayTimeline2" style="display: none;">
                        <div class="day-title">
                            <h3>2일차 - 서부 해안 드라이브</h3>
                            <span class="day-weather"><i class="bi bi-cloud-sun"></i> 17°C</span>
                        </div>
                        <div class="timeline-list">
                            <div class="timeline-item">
                                <div class="timeline-marker">1</div>
                                <div class="timeline-content">
                                    <div class="timeline-time">09:00 - 11:00</div>
                                    <div class="timeline-card with-image">
                                        <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=200&h=150&fit=crop&q=80" alt="협재해수욕장">
                                        <div class="timeline-info">
                                            <span class="category-badge attraction">관광지</span>
                                            <h4>협재해수욕장</h4>
                                            <p><i class="bi bi-geo-alt"></i> 제주 제주시 한림읍</p>
                                            <div class="timeline-meta">
                                                <span><i class="bi bi-star-fill text-warning"></i> 4.7</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Day 3 -->
                    <div class="day-timeline" id="dayTimeline3" style="display: none;">
                        <div class="day-title">
                            <h3>3일차 - 중문관광단지</h3>
                            <span class="day-weather"><i class="bi bi-sun"></i> 19°C</span>
                        </div>
                        <div class="timeline-list">
                            <div class="timeline-item">
                                <div class="timeline-marker">1</div>
                                <div class="timeline-content">
                                    <div class="timeline-time">10:00 - 12:00</div>
                                    <div class="timeline-card">
                                        <div class="timeline-info">
                                            <span class="category-badge attraction">관광지</span>
                                            <h4>중문대포해안 주상절리대</h4>
                                            <p><i class="bi bi-geo-alt"></i> 제주 서귀포시 중문동</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Day 4 -->
                    <div class="day-timeline" id="dayTimeline4" style="display: none;">
                        <div class="day-title">
                            <h3>4일차 - 마지막 날</h3>
                            <span class="day-weather"><i class="bi bi-cloud"></i> 16°C</span>
                        </div>
                        <div class="timeline-list">
                            <div class="timeline-item">
                                <div class="timeline-marker">1</div>
                                <div class="timeline-content">
                                    <div class="timeline-time">09:00 - 10:30</div>
                                    <div class="timeline-card">
                                        <div class="timeline-info">
                                            <span class="category-badge attraction">관광지</span>
                                            <h4>동문시장</h4>
                                            <p><i class="bi bi-geo-alt"></i> 제주 제주시 이도1동</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="timeline-item transport">
                                <div class="timeline-marker">
                                    <i class="bi bi-airplane"></i>
                                </div>
                                <div class="timeline-content">
                                    <div class="timeline-time">14:00 - 15:10</div>
                                    <div class="timeline-card">
                                        <div class="timeline-info">
                                            <span class="category-badge transport">이동</span>
                                            <h4>제주 → 김포 (항공편)</h4>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 하단 버튼 -->
                <div class="schedule-detail-footer">
                    <a href="${pageContext.request.contextPath}/mypage/schedules" class="btn btn-outline btn-lg">
                        <i class="bi bi-list me-2"></i>목록으로
                    </a>
                    <a href="${pageContext.request.contextPath}/schedule/planner?id=1" class="btn btn-primary btn-lg">
                        <i class="bi bi-pencil me-2"></i>일정 수정하기
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function selectDetailDay(day) {
    // 버튼 활성화
    var buttons = document.querySelectorAll('.day-btn');
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].classList.remove('active');
    }
    var selectedBtn = document.querySelector('.day-btn[data-day="' + day + '"]');
    if (selectedBtn) {
        selectedBtn.classList.add('active');
    }

    // 타임라인 표시
    var timelines = document.querySelectorAll('.day-timeline');
    for (var j = 0; j < timelines.length; j++) {
        timelines[j].style.display = 'none';
        timelines[j].classList.remove('active');
    }
    var selectedTimeline = document.getElementById('dayTimeline' + day);
    if (selectedTimeline) {
        selectedTimeline.style.display = 'block';
        selectedTimeline.classList.add('active');
    }
}

function editSchedule() {
    window.location.href = '${pageContext.request.contextPath}/schedule/planner?id=1';
}

function shareSchedule() {
    if (navigator.share) {
        navigator.share({
            title: '제주도 3박 4일 여행 일정',
            text: '제주도 여행 일정을 공유합니다!',
            url: window.location.href
        });
    } else {
        // 클립보드에 복사
        navigator.clipboard.writeText(window.location.href).then(function() {
            if (typeof showToast === 'function') {
                showToast('링크가 복사되었습니다.', 'success');
            } else {
                alert('링크가 복사되었습니다.');
            }
        });
    }
}

function deleteSchedule() {
    if (confirm('이 일정을 삭제하시겠습니까?\n삭제된 일정은 복구할 수 없습니다.')) {
        if (typeof showToast === 'function') {
            showToast('일정이 삭제되었습니다.', 'success');
        }
        setTimeout(function() {
            window.location.href = '${pageContext.request.contextPath}/mypage/schedules';
        }, 1000);
    }
}
</script>

<c:set var="pageJs" value="mypage" />
<%@ include file="../common/footer.jsp" %>
