<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="일정 상세" />
<c:set var="pageCss" value="schedule" />

<%@ include file="../common/header.jsp" %>

<div class="schedule-view-page">
    <div class="container">
        <!-- 상단 네비게이션 -->
        <nav class="breadcrumb-nav mb-4">
            <a href="${pageContext.request.contextPath}/schedule/my">
                <i class="bi bi-arrow-left me-2"></i>내 일정 목록
            </a>
        </nav>

        <!-- 일정 헤더 (썸네일 포함) -->
        <div class="schedule-view-header-wrapper">
            <!-- 썸네일 영역 -->
            <div class="schedule-thumbnail-section">
                <div class="schedule-thumbnail" id="scheduleThumbnail">
                    <img src="https://images.unsplash.com/photo-1590650046871-92c887180603?w=400&h=300&fit=crop&q=80"
                         alt="일정 썸네일" id="thumbnailImage">
                    <button class="thumbnail-change-btn" onclick="openThumbnailModal()">
                        <i class="bi bi-camera"></i>
                        <span>썸네일 변경</span>
                    </button>
                </div>
            </div>

            <!-- 일정 정보 -->
            <div class="schedule-view-header">
                <div class="schedule-view-title">
                    <h1>제주도 3박 4일</h1>
                    <div class="schedule-badges">
                        <span class="schedule-status-badge upcoming">예정</span>
                        <c:if test="${schedule.aiRecomYn == 'Y'}">
                            <span class="schedule-status-badge ai">AI 추천</span>
                        </c:if>
                    </div>
                </div>
                <div class="schedule-view-actions">
                    <button class="btn btn-outline" onclick="editSchedule()">
                        <i class="bi bi-pencil me-1"></i>수정
                    </button>
                    <button class="btn btn-outline" onclick="shareSchedule()">
                        <i class="bi bi-share me-1"></i>공유
                    </button>
                    <button class="btn btn-outline" onclick="toggleScheduleViewBookmark(this)">
                        <i class="bi bi-bookmark me-1"></i>북마크
                    </button>
                    <button class="btn btn-outline text-danger" onclick="deleteSchedule()">
                        <i class="bi bi-trash me-1"></i>삭제
                    </button>
                </div>
            </div>
        </div>

        <!-- 일정 요약 정보 -->
        <div class="schedule-summary">
            <div class="summary-item">
                <i class="bi bi-calendar3"></i>
                <div>
                    <span class="label">여행 기간</span>
                    <span class="value">
                        ${fn:replace(schedule.schdlStartDt, '-', '.')} - 
                        ${fn:replace(schedule.schdlEndDt, '-', '.')}
                    </span>
                </div>
            </div>
            <div class="summary-item">
                <i class="bi bi-geo-alt"></i>
                <div>
                    <span class="label">여행지</span>
                    <span class="value">${schedule.rgnNm}</span>
                </div>
            </div>
            <div class="summary-item">
                <i class="bi bi-people"></i>
                <div>
                    <span class="label">인원</span>
                    <span class="value">${schedule.travelerCnt}명</span>
                </div>
            </div>
            <div class="summary-item">
                <i class="bi bi-pin-map"></i>
                <div>
                    <span class="label">방문 장소</span>
                    <span class="value">${schedule.placeCnt}곳</span>
                </div>
            </div>
        </div>

        <!-- 일자별 탭 -->
        <div class="schedule-day-tabs">
            <c:forEach items="${schedule.tripScheduleDetailsList}" var="detail" varStatus="s">
                <fmt:parseDate value="${detail.schdlStartDt}" var="startDate" pattern="yyyy-MM-dd" />
                <button class="schedule-day-btn ${s.index == 0 ? 'active' : ''}" data-day="1" onclick="selectViewDay(${detail.schdlDt})">
                    <span class="day-num">${detail.schdlDt}</span>
                    <span class="day-date">
                        <fmt:formatDate value="${startDate}" pattern="M/d" />(<fmt:formatDate value="${startDate}" pattern="E" />)
                    </span>
                </button>
            </c:forEach>
        </div>

        <!-- 일정 타임라인 -->
        <div class="schedule-timeline-wrapper">
            <!-- Day 1 -->
            <c:forEach items="${schedule.tripScheduleDetailsList}" var="detail" varStatus="dst">
                <div class="schedule-day-content ${dst.index == 0 ? 'active' : ''}" id="viewDay${detail.schdlDt}" style="display: ${dst.index == 0 ? 'block' : 'none'};">
                    <div class="day-header">
                        <h3>${detail.schdlDt}일차 - ${detail.schdlTitle}</h3>
                        <span class="day-weather"><i class="bi bi-sun"></i> 18°C</span>
                    </div>

                    <div class="schedule-timeline">
                        <c:forEach items="${detail.tripSchedulePlaceList}" var="place" varStatus="pst">
                            <div class="timeline-item">
                                <div class="timeline-marker">${pst.count}</div>
                                <div class="timeline-content">
                                    <div class="timeline-time">${place.placeStartTime} - ${place.placeEndTime}</div>
                                    <div class="timeline-card with-image">
                                        <c:if test="${ place.tourPlace.attachNo != 0 }">
                                               <img src="https://images.unsplash.com/photo-1578469645742-46cae010e5d4?w=200&h=150&fit=crop&q=80" alt="성산일출봉">
                                        </c:if>
                                        <c:if test="${ place.tourPlace.attachNo == 0 }">
                                            <img src="${ place.tourPlace.defaultImg}" alt="성산일출봉">
                                        </c:if>
                                        <div class="timeline-info">
                                            <span class="category-tag attraction">${place.tourPlace.placeName}</span>
                                            <h4>${place.tourPlace.plcNm}</h4>
                                            <p><i class="bi bi-geo-alt"></i> 제주 서귀포시 성산읍</p>
                                            <div class="timeline-meta">
                                                <span><i class="bi bi-star-fill text-warning"></i> 4.7</span>
                                                <span><i class="bi bi-clock"></i> 약 1시간 30분</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
            

            <!-- Day 4 -->
            <%-- <div class="schedule-day-content" id="viewDay4" style="display: none;">
                <div class="day-header">
                    <h3>4일차 - 마지막 날</h3>
                    <span class="day-weather"><i class="bi bi-cloud"></i> 16°C</span>
                </div>
                <div class="schedule-timeline">
                    <div class="timeline-item">
                        <div class="timeline-marker">1</div>
                        <div class="timeline-content">
                            <div class="timeline-time">09:00 - 10:30</div>
                            <div class="timeline-card">
                                <div class="timeline-info">
                                    <span class="category-tag attraction">관광지</span>
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
                                    <span class="category-tag transport">이동</span>
                                    <h4>제주 → 김포 (항공편)</h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div> --%>
        </div>

        <!-- 하단 버튼 -->
        <div class="schedule-view-footer">
            <a href="${pageContext.request.contextPath}/schedule/my" class="btn btn-outline btn-lg">
                <i class="bi bi-list me-2"></i>목록으로
            </a>
            <a href="${pageContext.request.contextPath}/schedule/planner?id=${schedule.schdlNo}" class="btn btn-primary btn-lg">
                <i class="bi bi-pencil me-2"></i>일정 수정하기
            </a>
        </div>
    </div>
</div>

<!-- 썸네일 변경 모달 -->
<div class="modal fade" id="thumbnailModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-image me-2"></i>썸네일 변경</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- 탭 메뉴 -->
                <ul class="nav nav-tabs thumbnail-tabs mb-4" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#placeImages" type="button">
                            <i class="bi bi-pin-map me-2"></i>일정 장소에서 선택
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#uploadImage" type="button">
                            <i class="bi bi-upload me-2"></i>이미지 업로드
                        </button>
                    </li>
                </ul>

                <div class="tab-content">
                    <!-- 일정 장소에서 선택 -->
                    <div class="tab-pane fade show active" id="placeImages" role="tabpanel">
                        <p class="text-muted mb-3">일정에 포함된 장소의 이미지 중 하나를 선택하세요.</p>
                        <div class="thumbnail-select-grid" id="placeImageGrid">
                            <div class="thumbnail-option" onclick="selectThumbnailOption(this)">
                                <img src="https://images.unsplash.com/photo-1578469645742-46cae010e5d4?w=200&h=150&fit=crop&q=80" alt="성산일출봉">
                                <div class="thumbnail-option-overlay">
                                    <i class="bi bi-check-circle-fill"></i>
                                </div>
                                <span class="thumbnail-option-label">성산일출봉</span>
                            </div>
                            <div class="thumbnail-option" onclick="selectThumbnailOption(this)">
                                <img src="https://images.unsplash.com/photo-1553621042-f6e147245754?w=200&h=150&fit=crop&q=80" alt="해녀의집">
                                <div class="thumbnail-option-overlay">
                                    <i class="bi bi-check-circle-fill"></i>
                                </div>
                                <span class="thumbnail-option-label">해녀의집</span>
                            </div>
                            <div class="thumbnail-option" onclick="selectThumbnailOption(this)">
                                <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=200&h=150&fit=crop&q=80" alt="우도">
                                <div class="thumbnail-option-overlay">
                                    <i class="bi bi-check-circle-fill"></i>
                                </div>
                                <span class="thumbnail-option-label">우도</span>
                            </div>
                            <div class="thumbnail-option" onclick="selectThumbnailOption(this)">
                                <img src="https://images.unsplash.com/photo-1544025162-d76694265947?w=200&h=150&fit=crop&q=80" alt="흑돼지거리">
                                <div class="thumbnail-option-overlay">
                                    <i class="bi bi-check-circle-fill"></i>
                                </div>
                                <span class="thumbnail-option-label">흑돼지거리</span>
                            </div>
                            <div class="thumbnail-option" onclick="selectThumbnailOption(this)">
                                <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=200&h=150&fit=crop&q=80" alt="협재해수욕장">
                                <div class="thumbnail-option-overlay">
                                    <i class="bi bi-check-circle-fill"></i>
                                </div>
                                <span class="thumbnail-option-label">협재해수욕장</span>
                            </div>
                            <div class="thumbnail-option" onclick="selectThumbnailOption(this)">
                                <img src="https://images.unsplash.com/photo-1590650046871-92c887180603?w=400&h=300&fit=crop&q=80" alt="제주도">
                                <div class="thumbnail-option-overlay">
                                    <i class="bi bi-check-circle-fill"></i>
                                </div>
                                <span class="thumbnail-option-label">제주도 전경</span>
                            </div>
                        </div>
                    </div>

                    <!-- 이미지 업로드 -->
                    <div class="tab-pane fade" id="uploadImage" role="tabpanel">
                        <div class="upload-area" id="uploadArea">
                            <input type="file" id="thumbnailUpload" accept="image/*" hidden onchange="handleThumbnailUpload(this)">
                            <div class="upload-placeholder" onclick="document.getElementById('thumbnailUpload').click()">
                                <i class="bi bi-cloud-arrow-up"></i>
                                <p>클릭하거나 이미지를 드래그하여 업로드</p>
                                <span class="text-muted">JPG, PNG, GIF (최대 5MB)</span>
                            </div>
                            <div class="upload-preview" id="uploadPreview" style="display: none;">
                                <img src="" alt="미리보기" id="previewImage">
                                <button type="button" class="btn btn-outline btn-sm" onclick="clearUpload()">
                                    <i class="bi bi-x-lg me-1"></i>다시 선택
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="saveThumbnail()">
                    <i class="bi bi-check-lg me-1"></i>적용하기
                </button>
            </div>
        </div>
    </div>
</div>

<style>
.schedule-view-page {
    padding: 40px 0 80px;
}

/* 썸네일 헤더 래퍼 */
.schedule-view-header-wrapper {
    display: flex;
    gap: 32px;
    margin-bottom: 24px;
    flex-wrap: wrap;
}

/* 썸네일 섹션 */
.schedule-thumbnail-section {
    flex-shrink: 0;
}

.schedule-thumbnail {
    position: relative;
    width: 280px;
    height: 200px;
    border-radius: var(--radius-lg);
    overflow: hidden;
    box-shadow: var(--shadow-md);
}

.schedule-thumbnail img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform var(--transition-normal);
}

.schedule-thumbnail:hover img {
    transform: scale(1.05);
}

.thumbnail-change-btn {
    position: absolute;
    bottom: 12px;
    right: 12px;
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 8px 16px;
    background: rgba(0, 0, 0, 0.7);
    color: white;
    border: none;
    border-radius: var(--radius-md);
    font-size: 13px;
    cursor: pointer;
    transition: all var(--transition-fast);
    opacity: 0;
}

.schedule-thumbnail:hover .thumbnail-change-btn {
    opacity: 1;
}

.thumbnail-change-btn:hover {
    background: rgba(0, 0, 0, 0.85);
}

.thumbnail-change-btn i {
    font-size: 14px;
}

/* 썸네일 모달 스타일 */
.thumbnail-tabs .nav-link {
    color: var(--gray-dark);
    border: none;
    padding: 12px 20px;
}

.thumbnail-tabs .nav-link.active {
    color: var(--primary-color);
    border-bottom: 2px solid var(--primary-color);
    background: none;
}

.thumbnail-select-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
}

.thumbnail-option {
    position: relative;
    aspect-ratio: 4/3;
    border-radius: var(--radius-md);
    overflow: hidden;
    cursor: pointer;
    border: 3px solid transparent;
    transition: all var(--transition-fast);
}

.thumbnail-option:hover {
    border-color: var(--primary-color);
    transform: translateY(-2px);
}

.thumbnail-option.selected {
    border-color: var(--primary-color);
}

.thumbnail-option img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.thumbnail-option-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(74, 144, 217, 0.6);
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: opacity var(--transition-fast);
}

.thumbnail-option.selected .thumbnail-option-overlay {
    opacity: 1;
}

.thumbnail-option-overlay i {
    font-size: 32px;
    color: white;
}

.thumbnail-option-label {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    padding: 8px;
    background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
    color: white;
    font-size: 12px;
    text-align: center;
}

/* 업로드 영역 */
.upload-area {
    border: 2px dashed var(--gray-light);
    border-radius: var(--radius-lg);
    padding: 40px;
    text-align: center;
    transition: all var(--transition-fast);
}

.upload-area:hover {
    border-color: var(--primary-color);
    background: rgba(74, 144, 217, 0.02);
}

.upload-area.dragover {
    border-color: var(--primary-color);
    background: rgba(74, 144, 217, 0.05);
}

.upload-placeholder {
    cursor: pointer;
}

.upload-placeholder i {
    font-size: 48px;
    color: var(--primary-color);
    margin-bottom: 16px;
}

.upload-placeholder p {
    font-size: 16px;
    color: var(--dark-color);
    margin-bottom: 8px;
}

.upload-preview {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 16px;
}

.upload-preview img {
    max-width: 300px;
    max-height: 200px;
    border-radius: var(--radius-md);
    object-fit: contain;
}

@media (max-width: 768px) {
    .schedule-view-header-wrapper {
        flex-direction: column;
    }

    .schedule-thumbnail {
        width: 100%;
        height: 200px;
    }

    .thumbnail-change-btn {
        opacity: 1;
    }

    .thumbnail-select-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

.breadcrumb-nav a {
    color: var(--gray-dark);
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    transition: color var(--transition-fast);
}

.breadcrumb-nav a:hover {
    color: var(--primary-color);
}

.schedule-view-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 24px;
    flex-wrap: wrap;
    gap: 16px;
}

.schedule-view-title h1 {
    font-size: 28px;
    font-weight: 700;
    margin: 0 0 12px;
    color: var(--dark-color);
}

.schedule-badges {
    display: flex;
    gap: 8px;
}

.schedule-status-badge {
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 500;
}

.schedule-status-badge.upcoming {
    background: var(--primary-color);
    color: white;
}

.schedule-status-badge.completed {
    background: var(--success-color);
    color: white;
}

.schedule-status-badge.ai {
    background: linear-gradient(135deg, var(--accent-color), #FF8B8B);
    color: white;
}

.schedule-view-actions {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
}

.schedule-summary {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16px;
    background: var(--light-color);
    padding: 24px;
    border-radius: var(--radius-lg);
    margin-bottom: 32px;
}

.schedule-summary .summary-item {
    display: flex;
    align-items: center;
    gap: 12px;
}

.schedule-summary .summary-item > i {
    width: 48px;
    height: 48px;
    background: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    color: var(--primary-color);
    box-shadow: var(--shadow-sm);
}

.schedule-summary .summary-item .label {
    display: block;
    font-size: 12px;
    color: var(--gray-medium);
    margin-bottom: 2px;
}

.schedule-summary .summary-item .value {
    display: block;
    font-size: 16px;
    font-weight: 600;
    color: var(--dark-color);
}

.schedule-day-tabs {
    display: flex;
    gap: 12px;
    margin-bottom: 24px;
    overflow-x: auto;
    padding-bottom: 8px;
}

.schedule-day-btn {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 12px 24px;
    background: white;
    border: 2px solid var(--gray-lighter);
    border-radius: var(--radius-lg);
    cursor: pointer;
    transition: all var(--transition-fast);
    min-width: 80px;
}

.schedule-day-btn:hover {
    border-color: var(--primary-color);
}

.schedule-day-btn.active {
    background: var(--primary-color);
    border-color: var(--primary-color);
    color: white;
}

.schedule-day-btn .day-num {
    font-size: 18px;
    font-weight: 700;
}

.schedule-day-btn .day-date {
    font-size: 12px;
    color: var(--gray-medium);
}

.schedule-day-btn.active .day-date {
    color: rgba(255, 255, 255, 0.8);
}

.schedule-timeline-wrapper {
    background: white;
    border-radius: var(--radius-lg);
    padding: 24px;
    margin-bottom: 32px;
    box-shadow: var(--shadow-sm);
}

.day-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    padding-bottom: 16px;
    border-bottom: 1px solid var(--gray-lighter);
}

.day-header h3 {
    font-size: 20px;
    font-weight: 600;
    margin: 0;
}

.day-weather {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 14px;
    color: var(--gray-dark);
}

.schedule-timeline {
    position: relative;
    padding-left: 40px;
}

.schedule-timeline::before {
    content: '';
    position: absolute;
    left: 20px;
    top: 0;
    bottom: 0;
    width: 2px;
    background: var(--gray-lighter);
}

.timeline-item {
    position: relative;
    margin-bottom: 24px;
}

.timeline-item:last-child {
    margin-bottom: 0;
}

.timeline-marker {
    position: absolute;
    left: -40px;
    width: 40px;
    height: 40px;
    background: white;
    border: 2px solid var(--primary-color);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    font-size: 14px;
    color: var(--primary-color);
    z-index: 1;
}

.timeline-item.transport .timeline-marker {
    background: var(--gray-light);
    border-color: var(--gray-light);
    color: var(--gray-dark);
}

.timeline-time {
    font-size: 13px;
    color: var(--gray-medium);
    margin-bottom: 8px;
}

.timeline-card {
    background: var(--light-color);
    border-radius: var(--radius-md);
    padding: 16px;
}

.timeline-card.with-image {
    display: flex;
    gap: 16px;
}

.timeline-card.with-image img {
    width: 120px;
    height: 90px;
    object-fit: cover;
    border-radius: var(--radius-sm);
    flex-shrink: 0;
}

.timeline-info {
    flex: 1;
}

.category-tag {
    display: inline-block;
    padding: 3px 10px;
    border-radius: 12px;
    font-size: 11px;
    font-weight: 500;
    margin-bottom: 8px;
}

.category-tag.attraction {
    background: rgba(52, 152, 219, 0.15);
    color: #3498db;
}

.category-tag.restaurant {
    background: rgba(230, 126, 34, 0.15);
    color: #e67e22;
}

.category-tag.accommodation {
    background: rgba(155, 89, 182, 0.15);
    color: #9b59b6;
}

.category-tag.transport {
    background: rgba(149, 165, 166, 0.15);
    color: #7f8c8d;
}

.timeline-info h4 {
    font-size: 16px;
    font-weight: 600;
    margin: 0 0 6px;
}

.timeline-info p {
    font-size: 13px;
    color: var(--gray-dark);
    margin: 0 0 8px;
}

.timeline-meta {
    display: flex;
    gap: 12px;
    font-size: 13px;
    color: var(--gray-dark);
}

.schedule-view-footer {
    display: flex;
    justify-content: center;
    gap: 16px;
}

@media (max-width: 768px) {
    .schedule-view-header {
        flex-direction: column;
    }

    .schedule-summary {
        grid-template-columns: repeat(2, 1fr);
    }

    .timeline-card.with-image {
        flex-direction: column;
    }

    .timeline-card.with-image img {
        width: 100%;
        height: 150px;
    }

    .schedule-view-footer {
        flex-direction: column;
    }

    .schedule-view-footer .btn {
        width: 100%;
    }
}
</style>

<script>
var selectedThumbnailUrl = null;
var uploadedImageData = null;
var thumbnailModal = null;

// 썸네일 모달 열기
function openThumbnailModal() {
    thumbnailModal = new bootstrap.Modal(document.getElementById('thumbnailModal'));
    thumbnailModal.show();

    // 선택 상태 초기화
    selectedThumbnailUrl = null;
    uploadedImageData = null;
    document.querySelectorAll('.thumbnail-option').forEach(function(opt) {
        opt.classList.remove('selected');
    });
    clearUpload();
}

// 썸네일 옵션 선택
function selectThumbnailOption(element) {
    // 모든 선택 해제
    document.querySelectorAll('.thumbnail-option').forEach(function(opt) {
        opt.classList.remove('selected');
    });

    // 현재 항목 선택
    element.classList.add('selected');

    // 이미지 URL 저장
    selectedThumbnailUrl = element.querySelector('img').src;
    uploadedImageData = null; // 업로드 이미지 초기화
}

// 썸네일 업로드 처리
function handleThumbnailUpload(input) {
    var file = input.files[0];
    if (!file) return;

    // 파일 크기 체크 (5MB)
    if (file.size > 5 * 1024 * 1024) {
        if (typeof showToast === 'function') {
            showToast('파일 크기는 5MB 이하여야 합니다.', 'error');
        } else {
            alert('파일 크기는 5MB 이하여야 합니다.');
        }
        return;
    }

    // 이미지 타입 체크
    if (!file.type.startsWith('image/')) {
        if (typeof showToast === 'function') {
            showToast('이미지 파일만 업로드 가능합니다.', 'error');
        } else {
            alert('이미지 파일만 업로드 가능합니다.');
        }
        return;
    }

    var reader = new FileReader();
    reader.onload = function(e) {
        uploadedImageData = e.target.result;
        selectedThumbnailUrl = null; // 선택된 URL 초기화

        // 미리보기 표시
        document.getElementById('previewImage').src = uploadedImageData;
        document.querySelector('.upload-placeholder').style.display = 'none';
        document.getElementById('uploadPreview').style.display = 'flex';

        // 선택 옵션 초기화
        document.querySelectorAll('.thumbnail-option').forEach(function(opt) {
            opt.classList.remove('selected');
        });
    };
    reader.readAsDataURL(file);
}

// 업로드 초기화
function clearUpload() {
    document.getElementById('thumbnailUpload').value = '';
    document.querySelector('.upload-placeholder').style.display = 'block';
    document.getElementById('uploadPreview').style.display = 'none';
    document.getElementById('previewImage').src = '';
    uploadedImageData = null;
}

// 썸네일 저장
function saveThumbnail() {
    var newThumbnailUrl = uploadedImageData || selectedThumbnailUrl;

    if (!newThumbnailUrl) {
        if (typeof showToast === 'function') {
            showToast('썸네일 이미지를 선택하거나 업로드해주세요.', 'warning');
        } else {
            alert('썸네일 이미지를 선택하거나 업로드해주세요.');
        }
        return;
    }

    // 썸네일 이미지 변경
    document.getElementById('thumbnailImage').src = newThumbnailUrl;

    // 모달 닫기
    thumbnailModal.hide();

    // 실제 서버 저장 로직 (AJAX)
    // TODO: 서버에 썸네일 URL 또는 이미지 데이터 전송

    if (typeof showToast === 'function') {
        showToast('썸네일이 변경되었습니다.', 'success');
    }
}

// 드래그 앤 드롭 처리
document.addEventListener('DOMContentLoaded', function() {
    var uploadArea = document.getElementById('uploadArea');

    if (uploadArea) {
        uploadArea.addEventListener('dragover', function(e) {
            e.preventDefault();
            this.classList.add('dragover');
        });

        uploadArea.addEventListener('dragleave', function(e) {
            e.preventDefault();
            this.classList.remove('dragover');
        });

        uploadArea.addEventListener('drop', function(e) {
            e.preventDefault();
            this.classList.remove('dragover');

            var files = e.dataTransfer.files;
            if (files.length > 0) {
                document.getElementById('thumbnailUpload').files = files;
                handleThumbnailUpload(document.getElementById('thumbnailUpload'));
            }
        });
    }
});

function selectViewDay(day) {
    // 버튼 활성화
    var buttons = document.querySelectorAll('.schedule-day-btn');
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].classList.remove('active');
    }
    var selectedBtn = document.querySelector('.schedule-day-btn[data-day="' + day + '"]');
    if (selectedBtn) {
        selectedBtn.classList.add('active');
    }

    // 컨텐츠 표시
    var contents = document.querySelectorAll('.schedule-day-content');
    for (var j = 0; j < contents.length; j++) {
        contents[j].style.display = 'none';
        contents[j].classList.remove('active');
    }
    var selectedContent = document.getElementById('viewDay' + day);
    if (selectedContent) {
        selectedContent.style.display = 'block';
        selectedContent.classList.add('active');
    }
}

function editSchedule() {
    window.location.href = '${pageContext.request.contextPath}/schedule/planner?id=${schedule.schdlNo}';
}

function shareSchedule() {
    if (navigator.share) {
        navigator.share({
            title: '제주도 3박 4일 여행 일정',
            text: '제주도 여행 일정을 공유합니다!',
            url: window.location.href
        });
    } else {
        navigator.clipboard.writeText(window.location.href).then(function() {
            if (typeof showToast === 'function') {
                showToast('링크가 복사되었습니다.', 'success');
            } else {
                alert('링크가 복사되었습니다.');
            }
        });
    }
}

// function toggleScheduleViewBookmark(button) {
//     var icon = button.querySelector('i');
//     if (icon.classList.contains('bi-bookmark')) {
//         icon.classList.remove('bi-bookmark');
//         icon.classList.add('bi-bookmark-fill');
//         button.innerHTML = '<i class="bi bi-bookmark-fill me-1"></i>북마크됨';
//         if (typeof showToast === 'function') {
//             showToast('북마크에 추가되었습니다.', 'success');
//         }
//     } else {
//         icon.classList.remove('bi-bookmark-fill');
//         icon.classList.add('bi-bookmark');
//         button.innerHTML = '<i class="bi bi-bookmark me-1"></i>북마크';
//         if (typeof showToast === 'function') {
//             showToast('북마크가 해제되었습니다.', 'info');
//         }
//     }
// }
async function toggleScheduleViewBookmark(button) {
    var icon = button.querySelector('i');

    let bkmkYn = 'N';
    var icon = button.querySelector('i');
    if (icon.classList.contains('bi-bookmark')) {
        icon.classList.remove('bi-bookmark');
        icon.classList.add('bi-bookmark-fill');
        button.innerHTML = '<i class="bi bi-bookmark-fill me-1"></i>북마크됨';
        if (typeof showToast === 'function') {
            showToast('북마크에 추가되었습니다.', 'success');
        }
        bkmkYn = 'Y';
    } else {
        icon.classList.remove('bi-bookmark-fill');
        icon.classList.add('bi-bookmark');
        button.innerHTML = '<i class="bi bi-bookmark me-1"></i>북마크';
        if (typeof showToast === 'function') {
            showToast('북마크가 해제되었습니다.', 'info');
        }
        bkmkYn = 'N';
    }
    
    await fetch('${pageContext.request.contextPath}/schedule/schbookmark/modify', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            schdlNo: '${schedule.schdlNo}',
            bkmkYn: bkmkYn
        })
    });
}
async function deleteSchedule() {
    if (confirm('이 일정을 삭제하시겠습니까?\n삭제된 일정은 복구할 수 없습니다.')) {

        let resultData = await fetch('${pageContext.request.contextPath}/schedule/delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                schdlNo: '${schedule.schdlNo}'
            })
        });

        console.log(resultData);

        if (typeof showToast === 'function') {
            showToast('일정이 삭제되었습니다.', 'success');
        }
        setTimeout(function() {
            window.location.href = '${pageContext.request.contextPath}/schedule/my';
        }, 1000);
    }
}
</script>

<c:set var="pageJs" value="schedule" />
<%@ include file="../common/footer.jsp" %>
