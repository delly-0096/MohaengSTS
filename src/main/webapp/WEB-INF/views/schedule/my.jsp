<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="내 일정" />
<c:set var="pageCss" value="schedule" />

<%@ include file="../common/header.jsp" %>


<div class="my-schedule-page">
    <div class="container">
        <!-- 페이지 헤더 -->
        <div class="section-header" style="text-align: left; margin-bottom: 32px;">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="section-title" style="margin-bottom: 8px;">내 일정</h1>
                    <p class="section-subtitle" style="margin: 0;">저장한 여행 일정을 관리하세요</p>
                </div>
                <a href="${pageContext.request.contextPath}/schedule/search" class="btn btn-primary">
                    <i class="bi bi-plus-lg me-2"></i>새 일정 만들기
                </a>
            </div>
        </div>

        <!-- 캘린더 섹션 -->
        <div class="calendar-section mb-4">
            <div class="calendar-header">
                <h3><i class="bi bi-calendar3 me-2"></i>일정 캘린더</h3>
                <div class="calendar-legend">
                    <span class="legend-item"><span class="legend-dot upcoming"></span>다가오는 여행</span>
                    <span class="legend-item"><span class="legend-dot ongoing"></span>진행중</span>
                    <span class="legend-item"><span class="legend-dot completed"></span>완료된 여행</span>
                </div>
            </div>
            <div id="scheduleCalendar"></div>
        </div>

        <!-- 필터 탭 -->
        <div class="schedule-tabs mb-4">
            <ul class="nav nav-pills gap-2">
                <li class="nav-item">
                    <a class="nav-link active" href="#" data-filter="all">
                        <i class="bi bi-grid-3x3-gap me-2"></i>전체 <span class="badge bg-primary ms-1">3</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-filter="upcoming">
                        <i class="bi bi-airplane me-2"></i>다가오는 여행 <span class="badge bg-primary ms-1">2</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-filter="ongoing">
                        <i class="bi bi-play-circle me-2"></i>진행중 <span class="badge bg-primary ms-1">0</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-filter="completed">
                        <i class="bi bi-check-circle me-2"></i>완료된 여행 <span class="badge bg-primary ms-1">1</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- 일정 그리드 -->
        <div class="schedule-grid" id="scheduleGrid">
            <!-- 다가오는 여행 -->
            <c:forEach var="schedule" items="${scheduleList}">
                <div class="schedule-card" data-status="upcoming" data-schdl-no="${schedule.schdlNo}">

                    <div class="schedule-card-image">
                        <%-- <img src="${schedule.thumbnail}" alt="썸네일"> --%>
                        <c:choose>
                            <c:when test="${schedule.linkThumbnail != null && schedule.linkThumbnail != ''}">
                                <img src="${schedule.linkThumbnail}" alt="일정 썸네일" id="thumbnailImage">
                            </c:when>
                            <c:when test="${schedule.attachNo != null && schedule.attachNo != 0}">
                                <img src="${pageContext.request.contextPath }/file/searchthumbnail?path=${schedule.attachFile.filePath}" alt="일정 썸네일" id="thumbnailImage">
                            </c:when>
                            <c:otherwise>
                                <%-- 이미지를 찾았는지 확인할 플래그 변수 선언 --%>
                                <c:set var="imageFound" value="false" />
                                <c:forEach items="${schedule.tripScheduleDetailsList}" var="detail">
                                    <%-- 이미 이미지를 찾았다면 더 이상 안쪽 로직을 수행하지 않음 --%>
                                    <c:if test="${not imageFound}">
                                        <c:forEach items="${detail.tripSchedulePlaceList}" var="place">
                                            <c:if test="${not imageFound}">
                                                <%-- 1. 첨부파일이 있는 경우 --%><!-- 해당 케이스 미정 -->
                                                <c:if test="${place.tourPlace.attachNo != null && place.tourPlace.attachNo != 0}">
                                                    <img src="https://images.unsplash.com/photo-1578469645742-46cae010e5d4?w=200&h=150&fit=crop&q=80" alt="일정 썸네일" id="thumbnailImage">
                                                    <c:set var="imageFound" value="true" /> <%-- 찾았으므로 true로 변경 --%>
                                                </c:if>
                                                
                                                <%-- 2. 기본 이미지가 있는 경우 --%>
                                                <c:if test="${place.tourPlace.attachNo == null || place.tourPlace.attachNo == 0}">
                                                    <img src="${place.tourPlace.defaultImg}" alt="일정 썸네일" id="thumbnailImage">
                                                    <c:set var="imageFound" value="true" /> <%-- 찾았으므로 true로 변경 --%>
                                                </c:if>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        <span class="schedule-card-status upcoming">D-8</span>
                        <button class="schedule-card-bookmark ${schedule.bkmkYn eq 'Y' ? 'active' : ''}" onclick="toggleScheduleBookmark(this)">
                            <i class="bi ${schedule.bkmkYn eq 'Y' ? 'bi-bookmark-fill' : 'bi-bookmark'}"></i>
                        </button>
                    </div>
                    <div class="schedule-card-body">
                        <h3 class="schedule-card-title">${schedule.schdlNm}</h3>
                        <div class="schedule-card-dates">
                            <i class="bi bi-calendar3"></i>
                            <span>
                                ${fn:replace(schedule.schdlStartDt, '-', '.')} - 
                                ${fn:replace(schedule.schdlEndDt, '-', '.')}
                            </span>
                            <span class="text-muted">
                                (${schedule.tripDuration }박 ${schedule.tripDuration + 1}일)
                            </span>
                        </div>
                        <div class="schedule-card-places">
                            <c:forEach var="name" items="${schedule.displayPlaceNames}">
                                <span class="place-tag">${name}</span>
                            </c:forEach>
                            <c:if test="${schedule.placeCnt > 2}">
                                <span class="place-tag">+${schedule.placeCnt -2}</span>
                            </c:if>
                        </div>
                    </div>
                    <div class="schedule-card-footer">
                        <a href="${pageContext.request.contextPath}/schedule/view/${schedule.schdlNo}" class="btn btn-outline btn-sm">
                            상세보기
                        </a>
                        <a href="${pageContext.request.contextPath}/schedule/planner/${schedule.schdlNo}" class="btn btn-primary btn-sm">
                            수정하기
                        </a>
                    </div>
                </div>
            </c:forEach>




            <div class="schedule-card" data-status="upcoming">
                <div class="schedule-card-image">
                    <img src="https://images.unsplash.com/photo-1590650046871-92c887180603?w=400&h=300&fit=crop&q=80" alt="제주도">
                    <span class="schedule-card-status upcoming">D-8</span>
                    <button class="schedule-card-bookmark active" onclick="toggleScheduleBookmark(this)">
                        <i class="bi bi-bookmark-fill"></i>
                    </button>
                </div>
                <div class="schedule-card-body">
                    <h3 class="schedule-card-title">제주도 힐링 여행</h3>
                    <div class="schedule-card-dates">
                        <i class="bi bi-calendar3"></i>
                        <span>2026.01.01 - 2026.01.04</span>
                        <span class="text-muted">(3박 4일)</span>
                    </div>
                    <div class="schedule-card-places">
                        <span class="place-tag">성산일출봉</span>
                        <span class="place-tag">우도</span>
                        <span class="place-tag">+5</span>
                    </div>
                </div>
                <div class="schedule-card-footer">
                    <a href="${pageContext.request.contextPath}/schedule/view/1" class="btn btn-outline btn-sm">
                        상세보기
                    </a>
                    <a href="${pageContext.request.contextPath}/schedule/planner?id=1" class="btn btn-primary btn-sm">
                        수정하기
                    </a>
                </div>
            </div>

            <!-- 다가오는 여행 2 -->
            <div class="schedule-card" data-status="upcoming">
                <div class="schedule-card-image">
                    <img src="https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=400&h=300&fit=crop&q=80" alt="오사카">
                    <span class="schedule-card-status upcoming">D-22</span>
                    <button class="schedule-card-bookmark" onclick="toggleScheduleBookmark(this)">
                        <i class="bi bi-bookmark"></i>
                    </button>
                </div>
                <div class="schedule-card-body">
                    <h3 class="schedule-card-title">오사카 맛집 투어</h3>
                    <div class="schedule-card-dates">
                        <i class="bi bi-calendar3"></i>
                        <span>2026.01.15 - 2026.01.18</span>
                        <span class="text-muted">(3박 4일)</span>
                    </div>
                    <div class="schedule-card-places">
                        <span class="place-tag">도톤보리</span>
                        <span class="place-tag">구로몬시장</span>
                        <span class="place-tag">+8</span>
                    </div>
                </div>
                <div class="schedule-card-footer">
                    <a href="${pageContext.request.contextPath}/schedule/view/2" class="btn btn-outline btn-sm">
                        상세보기
                    </a>
                    <a href="${pageContext.request.contextPath}/schedule/planner?id=2" class="btn btn-primary btn-sm">
                        수정하기
                    </a>
                </div>
            </div>

            <!-- 완료된 여행 -->
            <div class="schedule-card" data-status="completed">
                <div class="schedule-card-image">
                    <img src="https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=400&h=300&fit=crop&q=80" alt="방콕">
                    <span class="schedule-card-status completed">완료</span>
                    <button class="schedule-card-bookmark" onclick="toggleScheduleBookmark(this)">
                        <i class="bi bi-bookmark"></i>
                    </button>
                </div>
                <div class="schedule-card-body">
                    <h3 class="schedule-card-title">방콕 휴양 여행</h3>
                    <div class="schedule-card-dates">
                        <i class="bi bi-calendar3"></i>
                        <span>2025.12.10 - 2025.12.14</span>
                        <span class="text-muted">(4박 5일)</span>
                    </div>
                    <div class="schedule-card-places">
                        <span class="place-tag">왓아룬</span>
                        <span class="place-tag">카오산로드</span>
                        <span class="place-tag">+6</span>
                    </div>
                </div>
                <div class="schedule-card-footer">
                    <a href="${pageContext.request.contextPath}/schedule/view/3" class="btn btn-outline btn-sm">
                        상세보기
                    </a>
                    <a href="${pageContext.request.contextPath}/community/travel-log/write?schedule=3" class="btn btn-secondary btn-sm">
                        여행기록 작성
                    </a>
                </div>
            </div>
        </div>

        <!-- 빈 상태 (일정이 없을 때) -->
        <div class="empty-state" id="emptyState" style="display: none;">
            <div class="empty-state-icon">
                <i class="bi bi-calendar-x"></i>
            </div>
            <h3 class="empty-state-title">저장된 일정이 없습니다</h3>
            <p class="empty-state-desc">새로운 여행 일정을 만들어보세요!</p>
            <a href="${pageContext.request.contextPath}/schedule/search" class="btn btn-primary">
                <i class="bi bi-plus-lg me-2"></i>일정 만들기
            </a>
        </div>
    </div>
</div>

<!-- 캘린더 스타일 -->
<style>
/* 캘린더 섹션 */
.calendar-section {
    background: white;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    margin-bottom: 32px;
}

.calendar-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    flex-wrap: wrap;
    gap: 12px;
}

.calendar-header h3 {
    font-size: 18px;
    font-weight: 600;
    margin: 0;
    display: flex;
    align-items: center;
    color: #333;
}

.calendar-legend {
    display: flex;
    gap: 20px;
    flex-wrap: wrap;
}

.legend-item {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    color: #666;
}

.legend-dot {
    width: 12px;
    height: 12px;
    border-radius: 50%;
}

.legend-dot.upcoming {
    background: linear-gradient(135deg, #4A90D9 0%, #357ABD 100%);
}

.legend-dot.ongoing {
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
}

.legend-dot.completed {
    background: linear-gradient(135deg, #9ca3af 0%, #6b7280 100%);
}

/* FullCalendar 커스텀 스타일 */
#scheduleCalendar {
    font-family: inherit;
}

#scheduleCalendar .fc {
    font-family: inherit;
}

#scheduleCalendar .fc-toolbar-title {
    font-size: 1.3rem !important;
    font-weight: 600;
}

#scheduleCalendar .fc-daygrid-day {
    min-height: 80px;
}

#scheduleCalendar .fc-daygrid-day-frame {
    min-height: 100%;
}

#scheduleCalendar .fc-button-primary {
    background: var(--primary-color, #4A90D9) !important;
    border-color: var(--primary-color, #4A90D9) !important;
    font-weight: 500;
    padding: 8px 16px;
    border-radius: 8px !important;
}

#scheduleCalendar .fc-button-primary:hover {
    background: #357ABD !important;
    border-color: #357ABD !important;
}

#scheduleCalendar .fc-button-primary:disabled {
    background: #ccc !important;
    border-color: #ccc !important;
}

#scheduleCalendar .fc-button-primary:not(:disabled).fc-button-active {
    background: #2d6aa3 !important;
    border-color: #2d6aa3 !important;
}

#scheduleCalendar .fc-daygrid-day-number {
    font-weight: 500;
    color: #333;
    padding: 4px 8px;
    font-size: 14px;
    white-space: nowrap;
}

#scheduleCalendar .fc-daygrid-day-top {
    display: flex;
    justify-content: flex-end;
}

#scheduleCalendar .fc-day-today {
    background: rgba(74, 144, 217, 0.08) !important;
}

#scheduleCalendar .fc-day-today .fc-daygrid-day-number {
    background: var(--primary-color, #4A90D9);
    color: white !important;
    border-radius: 16px;
    padding: 2px 8px !important;
    margin: 4px;
    font-size: 13px;
    line-height: 1.4;
    white-space: nowrap;
    display: inline-block;
}

/* FullCalendar 이벤트 스타일 - 강제 적용 */
#scheduleCalendar .fc-event,
#scheduleCalendar .fc-daygrid-event,
#scheduleCalendar .fc-h-event,
#scheduleCalendar .fc-daygrid-block-event {
    border-radius: 6px !important;
    padding: 4px 8px !important;
    font-size: 12px !important;
    font-weight: 500 !important;
    border: none !important;
    cursor: pointer !important;
    margin: 1px 2px !important;
    min-height: 22px !important;
    display: block !important;
    opacity: 1 !important;
    visibility: visible !important;
}

#scheduleCalendar .fc-event-main,
#scheduleCalendar .fc-event-title {
    color: #ffffff !important;
    padding: 0 !important;
}

#scheduleCalendar .fc-daygrid-event-dot {
    display: none !important;
}

#scheduleCalendar .fc-event:hover {
    transform: translateY(-1px);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

#scheduleCalendar .fc-daygrid-day-events {
    min-height: 2em !important;
}

#scheduleCalendar .fc-col-header-cell-cushion {
    font-weight: 600;
    color: #555;
    padding: 12px 4px;
}

#scheduleCalendar .fc-scrollgrid {
    border-radius: 12px;
    overflow: hidden;
    border-color: #e5e7eb !important;
}

#scheduleCalendar .fc-scrollgrid td,
#scheduleCalendar .fc-scrollgrid th {
    border-color: #e5e7eb !important;
}

#scheduleCalendar .fc-daygrid-day:hover {
    background: #f9fafb;
}

/* 툴팁 스타일 */
.schedule-tooltip {
    position: absolute;
    background: white;
    border-radius: 12px;
    padding: 16px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
    z-index: 1000;
    min-width: 250px;
    max-width: 300px;
}

.schedule-tooltip-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 12px;
}

.schedule-tooltip-title {
    font-size: 16px;
    font-weight: 600;
    color: #333;
    margin: 0;
}

.schedule-tooltip-status {
    padding: 3px 10px;
    border-radius: 12px;
    font-size: 11px;
    font-weight: 500;
    color: white;
}

.schedule-tooltip-status.upcoming {
    background: var(--primary-color, #4A90D9);
}

.schedule-tooltip-status.ongoing {
    background: #10b981;
}

.schedule-tooltip-status.completed {
    background: #9ca3af;
}

.schedule-tooltip-info {
    font-size: 13px;
    color: #666;
    margin-bottom: 12px;
}

.schedule-tooltip-info p {
    margin: 4px 0;
    display: flex;
    align-items: center;
    gap: 6px;
}

.schedule-tooltip-actions {
    display: flex;
    gap: 8px;
}

.schedule-tooltip-actions .btn {
    flex: 1;
    padding: 8px 12px;
    font-size: 13px;
}

/* 반응형 */
@media (max-width: 768px) {
    .calendar-header {
        flex-direction: column;
        align-items: flex-start;
    }

    .calendar-legend {
        gap: 12px;
    }

    #scheduleCalendar .fc-toolbar {
        flex-direction: column;
        gap: 12px;
    }

    #scheduleCalendar .fc-toolbar-chunk {
        display: flex;
        justify-content: center;
    }
}
</style>

<!-- FullCalendar JS (CDN) -->
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.5/main.min.js'></script>
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.5/main.min.css' rel='stylesheet' />

<script>
// FullCalendar 초기화
document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('scheduleCalendar');

    if (!calendarEl) {
        console.error('캘린더 요소를 찾을 수 없습니다.');
        return;
    }

    // 일정 데이터 직접 정의 (오늘: 2025-12-24 기준)
    var contextPath = '${pageContext.request.contextPath}';
    
    var calendarEvents = [
        <c:forEach var="schedule" items="${scheduleList}" varStatus="s">
        {
            id: '${schedule.schdlNo}',
            title: '${schedule.schdlNm}',
            start: '${schedule.schdlStartDt}',
            end: '${schedule.calendarEndDt}',
            allDay: true,
            // backgroundColor: '$schedule.backgroundColor',
            // borderColor: '$schedule.borderColor',
            // textColor: '$schedule.textColor',
            extendedProps: {
                status: '${schedule.schdlStatus}',
                location: '${schedule.rgnNm}',
                people: ${schedule.travelerCnt},
                url: contextPath + '/schedule/view/${schedule.schdlNo}'
            }
        }<c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];

    console.log('캘린더 이벤트 개수:', calendarEvents.length);
    console.log('FullCalendar 존재 여부:', typeof FullCalendar);

    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,dayGridWeek'
        },
        buttonText: {
            today: '오늘',
            month: '월',
            week: '주'
        },
        height: 'auto',
        dayMaxEvents: 3,
        moreLinkText: function(num) {
            return '+' + num + '개 더보기';
        },
        events: calendarEvents,
        eventClick: function(info) {
            info.jsEvent.preventDefault();

            // 기존 툴팁 제거
            removeTooltip();

            var event = info.event;
            var props = event.extendedProps;

            // 상태 텍스트
            var statusText = {
                'upcoming': '다가오는 여행',
                'ongoing': '진행중',
                'completed': '완료'
            };

            // 날짜 포맷
            var startDate = event.start.toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' });
            var endDate = event.end ? new Date(event.end.getTime() - 86400000).toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' }) : startDate;

            // 툴팁 생성
            var tooltip = document.createElement('div');
            tooltip.className = 'schedule-tooltip';
            tooltip.id = 'scheduleTooltip';
            tooltip.innerHTML =
                '<div class="schedule-tooltip-header">' +
                    '<h4 class="schedule-tooltip-title">' + event.title + '</h4>' +
                    '<span class="schedule-tooltip-status ' + props.status + '">' + statusText[props.status] + '</span>' +
                '</div>' +
                '<div class="schedule-tooltip-info">' +
                    '<p><i class="bi bi-calendar3"></i> ' + startDate + ' - ' + endDate + '</p>' +
                    '<p><i class="bi bi-geo-alt"></i> ' + props.location + '</p>' +
                    '<p><i class="bi bi-people"></i> ' + props.people + '명</p>' +
                '</div>' +
                '<div class="schedule-tooltip-actions">' +
                    '<a href="' + props.url + '" class="btn btn-outline btn-sm">상세보기</a>' +
                    (props.status !== 'completed' ?
                        '<a href="' + contextPath + '/schedule/planner/' + event.id + '" class="btn btn-primary btn-sm">수정하기</a>' :
                        '<a href="' + contextPath + '/community/travel-log/write?schedule=' + event.id + '" class="btn btn-secondary btn-sm">여행기록</a>') +
                '</div>';

            document.body.appendChild(tooltip);

            // 툴팁 위치 설정
            var rect = info.el.getBoundingClientRect();
            var tooltipRect = tooltip.getBoundingClientRect();

            var left = rect.left + window.scrollX;
            var top = rect.bottom + window.scrollY + 8;

            // 화면 밖으로 나가지 않도록 조정
            if (left + tooltipRect.width > window.innerWidth) {
                left = window.innerWidth - tooltipRect.width - 20;
            }
            if (top + tooltipRect.height > window.innerHeight + window.scrollY) {
                top = rect.top + window.scrollY - tooltipRect.height - 8;
            }

            tooltip.style.left = left + 'px';
            tooltip.style.top = top + 'px';
        },
        dateClick: function(info) {
            removeTooltip();
        }
    });

    calendar.render();
    console.log('캘린더 렌더링 완료');
    console.log('등록된 이벤트:', calendar.getEvents());

    // 바깥 클릭 시 툴팁 닫기
    document.addEventListener('click', function(e) {
        var tooltip = document.getElementById('scheduleTooltip');
        if (tooltip && !tooltip.contains(e.target) && !e.target.closest('.fc-event')) {
            removeTooltip();
        }
    });
});

function removeTooltip() {
    var tooltip = document.getElementById('scheduleTooltip');
    if (tooltip) {
        tooltip.remove();
    }
}

// 필터 기능
document.querySelectorAll('.nav-pills .nav-link').forEach(link => {
    link.addEventListener('click', function(e) {
        e.preventDefault();

        // 활성화 상태 변경
        document.querySelectorAll('.nav-pills .nav-link').forEach(l => l.classList.remove('active'));
        this.classList.add('active');

        const filter = this.dataset.filter;
        filterSchedules(filter);
    });
});

function filterSchedules(filter) {
    const cards = document.querySelectorAll('.schedule-card');
    let visibleCount = 0;

    cards.forEach(card => {
        if (filter === 'all' || card.dataset.status === filter) {
            card.style.display = 'block';
            visibleCount++;
        } else {
            card.style.display = 'none';
        }
    });

    // 빈 상태 표시
    document.getElementById('emptyState').style.display = visibleCount === 0 ? 'block' : 'none';
    document.getElementById('scheduleGrid').style.display = visibleCount === 0 ? 'none' : 'grid';
}

async function toggleScheduleBookmark(button) {
    button.classList.toggle('active');
    const icon = button.querySelector('i');

    let bkmkYn = 'N';

    if (button.classList.contains('active')) {
        icon.className = 'bi bi-bookmark-fill';
        showToast('북마크에 추가되었습니다.', 'success');
        bkmkYn = 'Y';
    } else {
        icon.className = 'bi bi-bookmark';
        showToast('북마크가 해제되었습니다.', 'info');
        bkmkYn = 'N';
    }
    
    await fetch('${pageContext.request.contextPath}/schedule/schbookmark/modify', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            schdlNo: button.closest('.schedule-card').dataset.schdlNo,
            bkmkYn: bkmkYn
        })
    });
}
</script>

<%@ include file="../common/footer.jsp" %>
