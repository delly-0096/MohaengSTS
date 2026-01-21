<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="pageTitle" value="여행기록 작성" />
<c:set var="pageCss" value="community" />

<%@ include file="../common/header.jsp" %>


<sec:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_BUSINESS')">
    <script>
        alert('일반회원만 여행기록을 작성할 수 있습니다.');
        location.href = '${pageContext.request.contextPath}/member/login';
    </script>
</sec:authorize>




<style>
#locationSuggestions .location-item{
  height: 56px;
  box-sizing: border-box;
}
#locationSuggestions{
  max-height: calc(56px * 3);
  overflow-y: auto;
}

#locationSuggestions .location-item i { color: #1abc9c; }
#locationSuggestions .location-item small { color: #6b7280; }
#locationSuggestions .location-item:hover { background: #e8fbf6; }

/* 안내/빈결과 메시지도 동일 톤 */
#locationSuggestions .location-empty {
  padding: 12px;
  color: #6b7280;
}

</style>

<div class="travellog-write-page">
    <div class="travellog-write-container">
            <!-- 헤더 -->
            <div class="travellog-write-header">
                <button type="button" class="btn-back" onclick="goBack()">
                    <i class="bi bi-arrow-left"></i>
                </button>
                <h2>새 여행기록</h2>
                <button type="button" class="btn-submit" id="submitBtn" onclick="submitTravellog()">등록</button>
            </div>

            <div class="travellog-write-body-new">
                <!-- 왼쪽: 블로그 에디터 -->
                <div class="blog-editor-section">
                    <!-- 커버 이미지 -->
                    <div class="cover-image-wrapper" id="coverImageWrapper">
                        <div class="cover-image-placeholder" id="coverPlaceholder" onclick="document.getElementById('coverImageInput').click()">
                            <i class="bi bi-image"></i>
                            <span>커버 이미지 추가</span>
                            <p>여행의 대표 사진을 선택하세요</p>
                        </div>
                        <div class="cover-image-preview" id="coverPreview" style="display: none;">
                            <img src="" alt="커버 이미지" id="coverImg">
                            <div class="cover-image-overlay">
                                <button type="button" class="btn-cover-change" onclick="document.getElementById('coverImageInput').click()">
                                    <i class="bi bi-camera"></i> 변경
                                </button>
                                <button type="button" class="btn-cover-remove" onclick="removeCoverImage()">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>
                        <input type="file" id="coverImageInput" accept="image/*" style="display: none;" onchange="handleCoverImage(event)">
                    </div>

                    <!-- 제목 입력 -->
                    <div class="blog-title-input">
                        <input type="text" id="blogTitle" placeholder="여행 제목을 입력하세요" maxlength="100">
                    </div>

                    <!-- 일정 연결 배너 -->
                    <div class="schedule-link-banner" id="scheduleLinkBanner" onclick="openScheduleModal()">
                        <div class="schedule-link-icon">
                            <i class="bi bi-calendar-check"></i>
                        </div>
                        <div class="schedule-link-content">
                            <span class="schedule-link-title">내 일정 불러오기</span>
                            <span class="schedule-link-desc">저장된 여행 일정을 연결하면 장소 정보가 자동으로 추가됩니다</span>
                        </div>
                        <i class="bi bi-chevron-right"></i>
                    </div>

                    <!-- 연결된 일정 표시 (선택 후) -->
                    <div class="linked-schedule-card" id="linkedScheduleCard" style="display: none;">
                        <div class="linked-schedule-header">
                            <i class="bi bi-calendar-check-fill"></i>
                            <span>연결된 일정</span>
                            <button type="button" class="btn-unlink" onclick="unlinkSchedule()">
                                <i class="bi bi-x-lg"></i>
                            </button>
                        </div>
                        <div class="linked-schedule-body">
                            <h4 id="linkedScheduleTitle">제주도 힐링 여행</h4>
                            <div class="linked-schedule-meta">
                                <span><i class="bi bi-calendar3"></i> <span id="linkedScheduleDates">2024.03.15 - 2024.03.18</span></span>
                                <span><i class="bi bi-geo-alt"></i> <span id="linkedScheduleLocation">제주도</span></span>
                            </div>
                            <div class="linked-schedule-places" id="linkedSchedulePlaces">
                                <!-- 장소 태그들이 여기에 표시됩니다 -->
                            </div>
                        </div>
                    </div>

                    <!-- 블로그 에디터 (블록 기반) -->
                    <div class="blog-editor" id="blogEditor">
                        <!-- 블록들이 여기에 추가됩니다 -->
                        <div class="editor-block text-block" data-block-id="1">
                            <textarea class="block-textarea" placeholder="여행 이야기를 작성하세요..." oninput="autoResize(this)"></textarea>
                        </div>
                    </div>

                    <!-- 블록 추가 버튼 -->
                    <div class="add-block-toolbar">
                        <button type="button" class="add-block-btn" onclick="addTextBlock()">
                            <i class="bi bi-text-paragraph"></i>
                            <span>텍스트</span>
                        </button>
                        <button type="button" class="add-block-btn" onclick="document.getElementById('blockImageInput').click()">
                            <i class="bi bi-image"></i>
                            <span>이미지</span>
                        </button>
                        <button type="button" class="add-block-btn" onclick="addDividerBlock()">
                            <i class="bi bi-hr"></i>
                            <span>구분선</span>
                        </button>
                        <button type="button" class="add-block-btn" onclick="addPlaceBlock()">
                            <i class="bi bi-geo-alt"></i>
                            <span>장소</span>
                        </button>
                        <input type="file" id="blockImageInput" accept="image/*" multiple style="display: none;" onchange="addImageBlocks(event)">
                    </div>
                </div>

                <!-- 오른쪽: 설정 패널 -->
                <div class="settings-panel">
                    <!-- 작성자 정보 -->
                    <%-- <div class="writer-info-card">
                        <div class="writer-avatar">
                            <i class="bi bi-person-fill"></i>
                        </div>
                        <div class="writer-details">
                            <span class="writer-name">${sessionScope.loginUser.userName}</span>
                            <span class="writer-status">여행기록 작성 중</span>
                        </div>
                    </div> --%>

                    <!-- 여행 정보 설정 -->
                    <div class="settings-section">
                        <h3 class="settings-title"><i class="bi bi-info-circle"></i> 여행 정보</h3>

                        <!-- 위치 정보 -->
                        <div class="setting-item" id="locationSettingItem">
                            <div class="setting-icon"><i class="bi bi-geo-alt"></i></div>
                            <div class="setting-content">
                                <span class="setting-label">위치</span>
                                <span class="setting-value" id="locationValue">위치를 추가하세요</span>
                            </div>
                            <i class="bi bi-chevron-right setting-arrow"></i>
                        </div>
                        <div class="setting-input-area" id="locationInputArea">
                            <div class="search-input-wrapper">
                                <i class="bi bi-search"></i>
                                <input type="text" id="locationInput" placeholder="지역 검색" autocomplete="off"
       oninput="onLocationInput(event)"
       oncompositionend="onLocationInput(event)"
       onkeyup="onLocationInput(event)">
                            </div>
                            <div class="location-suggestions" id="locationSuggestions"></div>
                        </div>

                        <!-- 여행 기간 -->
                        <div class="setting-item" onclick="toggleSettingInput('date')">
                            <div class="setting-icon"><i class="bi bi-calendar-event"></i></div>
                            <div class="setting-content">
                                <span class="setting-label">여행 기간</span>
                                <span class="setting-value" id="dateValue">날짜를 선택하세요</span>
                            </div>
                            <i class="bi bi-chevron-right setting-arrow"></i>
                        </div>
                        <div class="setting-input-area" id="dateInputArea">
                            <input type="text" class="form-control date-range-picker" id="travelDateRange" placeholder="여행 기간 선택">
                        </div>

                        <!-- 태그 -->
                        <div class="setting-item" onclick="toggleSettingInput('tag')">
                            <div class="setting-icon"><i class="bi bi-hash"></i></div>
                            <div class="setting-content">
                                <span class="setting-label">태그</span>
                                <span class="setting-value" id="tagValue">태그를 추가하세요</span>
                            </div>
                            <i class="bi bi-chevron-right setting-arrow"></i>
                        </div>
                        <div class="setting-input-area" id="tagInputArea">
                            <input type="text" class="form-control" id="tagInput" placeholder="태그 입력 후 Enter" onkeypress="addTag(event)">
                            <div class="tag-list" id="tagList"></div>
                            <!-- <div class="popular-tags">
                                <span class="popular-tag-label">인기 태그</span>
                                <div class="popular-tag-list">
                                    <span class="popular-tag" onclick="addPopularTag('여행스타그램')">#여행스타그램</span>
                                    <span class="popular-tag" onclick="addPopularTag('여행에미치다')">#여행에미치다</span>
                                    <span class="popular-tag" onclick="addPopularTag('국내여행')">#국내여행</span>
                                    <span class="popular-tag" onclick="addPopularTag('제주도')">#제주도</span>
                                    <span class="popular-tag" onclick="addPopularTag('여행사진')">#여행사진</span>
                                    <span class="popular-tag" onclick="addPopularTag('힐링여행')">#힐링여행</span>
                                </div>
                            </div> -->
                        </div>
                    </div>

                    <!-- 공개 설정 -->
                    <div class="settings-section">
                        <h3 class="settings-title"><i class="bi bi-shield-check"></i> 공개 설정</h3>

                        <div class="setting-item no-arrow">
                            <div class="setting-icon"><i class="bi bi-globe"></i></div>
                            <div class="setting-content">
                                <span class="setting-label">공개 범위</span>
                            </div>
                            <select class="visibility-select" id="visibility">
                                <option value="public">전체 공개</option>
                                <option value="private">나만 보기</option>
                            </select>
                        </div>

                        <div class="setting-item no-arrow">
                            <div class="setting-icon"><i class="bi bi-map"></i></div>
                            <div class="setting-content">
                                <span class="setting-label">지도에 표시</span>
                                <span class="setting-desc">내 여행 지도에 이 기록을 표시합니다</span>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="showOnMap" checked>
                            </div>
                        </div>

                        <div class="setting-item no-arrow">
                            <div class="setting-icon"><i class="bi bi-chat-dots"></i></div>
                            <div class="setting-content">
                                <span class="setting-label">댓글 허용</span>
                                <span class="setting-desc">다른 사용자가 댓글을 작성할 수 있습니다</span>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="allowComments" checked>
                            </div>
                        </div>
                    </div>

                    <!-- 미리보기 및 저장 -->
                    <div class="settings-actions">
                        <button type="button" class="btn btn-outline w-100 mb-2" onclick="previewTravellog()">
                            <i class="bi bi-eye me-2"></i>미리보기
                        </button>
                       <!--  <button type="button" class="btn btn-secondary w-100 mb-2" onclick="saveDraft()">
                            <i class="bi bi-file-earmark me-2"></i>임시저장
                        </button> -->
                    </div>
                </div>
            </div>
        </div>
</div>

<!-- 일정 선택 모달 -->
<div class="modal fade" id="scheduleModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-calendar-check me-2"></i>내 일정 불러오기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- 필터 탭 -->
                <div class="schedule-modal-tabs">
				  <button class="schedule-modal-tab active" data-filter="all" onclick="filterScheduleModal('all')">전체</button>
				  <button class="schedule-modal-tab" data-filter="completed" onclick="filterScheduleModal('completed')">완료된 여행</button>
				  <button class="schedule-modal-tab" data-filter="ongoing" onclick="filterScheduleModal('ongoing')">진행중</button>
				  <button class="schedule-modal-tab" data-filter="upcoming" onclick="filterScheduleModal('upcoming')">예정된 여행</button>
				</div>

                <!-- 일정 목록 -->
				<div class="schedule-modal-list" id="scheduleModalList">

					<c:choose>
						<c:when test="${empty scheduleList}">
							<div class="schedule-modal-empty" id="scheduleModalEmpty">
								<i class="bi bi-calendar-x"></i>
								<p>저장된 일정이 없습니다</p>
							</div>
						</c:when>

						<c:otherwise>
							<c:forEach var="s" items="${scheduleList}">
								<%-- 상태: schdlStatus가 완료/예정 값이 뭐로 오는지 몰라서 일단 D-Day로 판단 --%>
								<c:set var="dday" value="${s.DDay}" />
								<c:set var="dur" value="${s.tripDuration}" />
								<c:set var="endDiff" value="${dday + dur}" />  <%-- ✅ 종료일까지 남은 일수 --%>
								
								<c:set var="status" value="${dday gt 0 ? 'upcoming' : (endDiff lt 0 ? 'completed' : 'ongoing')}" />
								
								<c:set var="scheduleThumb">
								  <c:choose>
								    <c:when test="${not empty s.attachFile and not empty s.attachFile.filePath}">
								      ${pageContext.request.contextPath}/file/searchthumbnail?path=${s.attachFile.filePath}
								    </c:when>
								    <c:when test="${not empty s.linkThumbnail}">
								      ${s.linkThumbnail}
								    </c:when>
								    <c:when test="${not empty s.thumbnail}">
								      ${s.thumbnail}
								    </c:when>
								    <c:otherwise>
								      https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=120&h=90&fit=crop&q=80
								    </c:otherwise>
								  </c:choose>
								</c:set>
								
								<div class="schedule-modal-item" 
									data-status="${status}"
									data-schedule-no="${s.schdlNo}"
									data-title="${fn:escapeXml(s.schdlNm)}"
									data-start="${s.schdlStartDt}" data-end="${s.schdlEndDt}"
									data-location="${fn:escapeXml(s.rgnNm)}"
									data-thumbnail="${fn:escapeXml(s.thumbnail)}"
									data-link-thumbnail="${fn:escapeXml(s.linkThumbnail)}"
									data-location-code="${s.rgnNo}"
									data-cover="${fn:escapeXml(scheduleThumb)}"
									data-attach-no="${s.attachNo}"
									data-attach-path="${not empty s.attachFile ? fn:escapeXml(s.attachFile.filePath) : ''}"
									>
									

									<div class="schedule-modal-image">
										<c:choose>
										  <%-- 1순위: 일정 첨부파일 썸네일 --%>
										  <c:when test="${not empty s.attachFile and not empty s.attachFile.filePath}">
										    <img src="${pageContext.request.contextPath}/file/searchthumbnail?path=${s.attachFile.filePath}"
										         alt="${fn:escapeXml(s.schdlNm)}">
										  </c:when>
										
										  <%-- 2순위: linkThumbnail --%>
										  <c:when test="${not empty s.linkThumbnail}">
										    <img src="${s.linkThumbnail}"
										         alt="${fn:escapeXml(s.schdlNm)}">
										  </c:when>
										
										  <%-- 3순위: 기본 이미지 --%>
										  <c:otherwise>
										    <img src="https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=120&h=90&fit=crop&q=80"
										         alt="일정">
										  </c:otherwise>
										</c:choose>


										<span class="schedule-modal-badge ${status}">
										  <c:choose>
										    <c:when test="${status eq 'completed'}">완료</c:when>
										    <c:when test="${status eq 'ongoing'}">진행중</c:when>
										    <c:otherwise>
										      <c:choose>
										        <c:when test="${dday eq 0}">D-DAY</c:when>
										        <c:otherwise>D-${dday}</c:otherwise>
										      </c:choose>
										    </c:otherwise>
										  </c:choose>
										</span>
									</div>

									<div class="schedule-modal-info">
										<h4>
											<c:out value="${s.schdlNm}" />
										</h4>

										<div class="schedule-modal-meta">
											<span> <i class="bi bi-calendar3"></i> <c:out
													value="${s.schdlStartDt}" /> - <c:out
													value="${s.schdlEndDt}" />
											</span> <span> <i class="bi bi-geo-alt"></i> <c:out
													value="${s.rgnNm}" />
											</span>
										</div>

										<div class="schedule-modal-places">
											<c:choose>
												<c:when test="${not empty s.displayPlaceNames}">
													<c:forEach var="p" items="${s.displayPlaceNames}"
														varStatus="st">
														<c:if test="${st.index lt 3}">
															<span class="place-chip"><c:out value="${p}" /></span>
														</c:if>
													</c:forEach>
													<c:if test="${fn:length(s.displayPlaceNames) gt 3}">
														<span class="place-chip more">+${fn:length(s.displayPlaceNames) - 3}</span>
													</c:if>
												</c:when>
												<c:otherwise>
													<span class="place-chip">일정 선택</span>
												</c:otherwise>
											</c:choose>
										</div>
									</div>

									<div class="schedule-modal-select">
										<i class="bi bi-check-circle"></i>
									</div>

								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>

				</div>

			</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <%-- <a href="${pageContext.request.contextPath}/schedule/search" class="btn btn-secondary">
                    <i class="bi bi-plus-lg me-1"></i>새 일정 만들기
                </a> --%>
            </div>
        </div>
    </div>
</div>

<!-- 장소 추가 모달 -->
<div class="modal fade" id="placeBlockModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-geo-alt me-2"></i>장소 추가</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="search-input-wrapper mb-3">
                    <i class="bi bi-search"></i>
                    <input type="text" id="placeSearchInput" placeholder="장소 이름 검색" onkeyup="searchPlaceForBlock(event)">
                </div>
                <div class="place-search-results" id="placeSearchResults">
                    
                    
                    
                    
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 미리보기 모달 -->
<div class="modal fade" id="previewModal" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-eye me-2"></i>미리보기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-0">
                <div class="preview-container" id="previewContainer">
                    <!-- 미리보기 내용이 여기에 렌더링됩니다 -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">닫기</button>
               <!--  <button type="button" class="btn btn-primary" onclick="submitTravellog()">
                    <i class="bi bi-send me-1"></i>공유하기
                </button> -->
            </div>
        </div>
    </div>
</div>
<iframe id="scheduleLoader" style="display:none;"></iframe>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
let travelStartDate = null; // Date 객체
let travelEndDate = null;   // Date 객체


window.__CTX__ = '${pageContext.request.contextPath}';
window.showToast = window.showToast || function (msg, type) { alert(msg); };
// 블록 ID 카운터
let blockIdCounter = 1;

// 데이터 저장용 변수
let coverImageData = null;
let linkedSchedule = null;
let tags = [];
let selectedLocationName = ''; // 화면 표시용 (RGN_NM)
let selectedLocationCode = ''; // 저장용 (RGN_NO 문자열)
let bodyImageFiles = [];
let __locJustOpened = false;


const __CTX = window.__CTX__ || '';
const __URL_PARAMS = new URLSearchParams(location.search);
const __RCD_NO__ = __URL_PARAMS.get('rcdNo'); // ✅ 수정 모드면 값 있음

let isEditMode = !!__RCD_NO__;
let editingRcdNo = isEditMode ? Number(__RCD_NO__) : null;

// ✅ 수정 모드에서 기존 커버/이미지 유지용
let existingCoverAttachNo = null;


function applyScheduleToEditor(schedule) {
	  // ✅ 배열이 아니면 빈 배열로 강제
	  const detailsRaw = schedule && schedule.tripScheduleDetailsList;
	  const details = Array.isArray(detailsRaw) ? detailsRaw.filter(Boolean) : [];

	  if (details.length === 0) {
	    showToast('이 일정에는 일차별 데이터가 없습니다.', 'info');
	    return;
	  }

	  resetEditorKeepFirstTextBlock();

	  details.forEach((d, idx) => {
	    if (!d) return;

	    const dayNo = d.schdlDt || (idx + 1);
	    const dateStr = d.schdlStartDt || '';

	    addDayHeaderBlock(dayNo, dateStr);

	    const placesRaw = d.tripSchedulePlaceList;
	    const places = Array.isArray(placesRaw) ? placesRaw.filter(Boolean) : [];

	    places.forEach(p => {
	      const info = extractPlaceInfo(p);   // ✅ 이제 null-safe
	      addPlaceBlockFromSchedule(info);
	    });
	  });
}


function resetEditorKeepFirstTextBlock() {
	  const editor = document.getElementById('blogEditor');
	  if (!editor) return;

	  const blocks = Array.from(editor.querySelectorAll('.editor-block'));
	  if (blocks.length === 0) return;

	  // 첫 text-block만 남기고 지우기
	  const first = blocks[0];
	  editor.innerHTML = '';
	  editor.appendChild(first);

	  // 첫 블록 textarea 비우고 포커스
	  const ta = first.querySelector('textarea');
	  if (ta) ta.value = '';
}

//✅ 전역 현재 일자 컨텍스트
let __CURRENT_DAY_NO__ = null;
let __CURRENT_DAY_DATE__ = null;

function addDayHeaderBlock(dayNo, dateStr) {
	  blockIdCounter++;
	  const currentId = blockIdCounter;

	  const editor = document.getElementById('blogEditor');
	  const block = document.createElement('div');
	  block.className = 'editor-block day-header-block';
	  block.dataset.blockId = currentId;
	  
	  block.dataset.fromSchedule = "1";
	  
	  // ✅ day/date를 dataset으로 저장
	  block.dataset.dayNo = String(dayNo ?? '');
	  block.dataset.dateStr = String(dateStr ?? '');

	  // ✅ 현재 컨텍스트 갱신
	  __CURRENT_DAY_NO__ = dayNo ?? null;
	  __CURRENT_DAY_DATE__ = dateStr ?? null;

	  block.innerHTML =
	    '<div class="block-actions">' +
	      '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + currentId + ')"><i class="bi bi-chevron-up"></i></button>' +
	      '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + currentId + ')"><i class="bi bi-chevron-down"></i></button>' +
	      '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + currentId + ')"><i class="bi bi-trash"></i></button>' +
	    '</div>' +
	    '<div class="day-header">' +
	      '<span class="day-badge">DAY ' + dayNo + '</span>' +
	      ' ' +
	      '<span class="day-date">' + (dateStr || '') + '</span>' +
	    '</div>';

	  editor.appendChild(block);
}

function extractPlaceInfo(placeVO) {
	  placeVO = placeVO || {};               // ✅ null-safe
	  const tp = (placeVO.tourPlace || {});

	  const plcNo = tp.plcNo || placeVO.placeId || placeVO.destId || null;

	  const name =
	    tp.plcNm ||
	    placeVO.plcNm ||
	    tp.placeName ||
	    '장소';

	  const addr1 = tp.plcAddr1 || '';
	  const addr2 = tp.plcAddr2 || '';
	  const address = (addr1 + ' ' + addr2).trim();

	  const imageUrl =
	    tp.defaultImg ||
	    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=300&h=200&fit=crop&q=80';

	  return { plcNo, name, address, imageUrl };
}


function addPlaceBlockFromSchedule(info) {
	  blockIdCounter++;
	  const currentId = blockIdCounter;

	  const editor = document.getElementById('blogEditor');
	  const block = document.createElement('div');
	  block.className = 'editor-block place-block';
	  block.dataset.blockId = currentId;
	  
	  block.dataset.fromSchedule = "1";

	  //저장용 plcNo 세팅
	  if (info.plcNo != null) {
	    block.dataset.plcNo = String(info.plcNo);
	  }
	  
	//일자/날짜 + 장소정보를 dataset에 저장
	  block.dataset.day = (__CURRENT_DAY_NO__ != null ? String(__CURRENT_DAY_NO__) : '');
	  block.dataset.date = (__CURRENT_DAY_DATE__ || '');

	  block.dataset.name = info.name || '';
	  block.dataset.address = info.address || '';
	  block.dataset.image = info.imageUrl || '';

	  block.innerHTML =
	    '<div class="block-actions">' +
	      '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + currentId + ')"><i class="bi bi-chevron-up"></i></button>' +
	      '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + currentId + ')"><i class="bi bi-chevron-down"></i></button>' +
	      '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + currentId + ')"><i class="bi bi-trash"></i></button>' +
	    '</div>' +
	    '<div class="place-block-content">' +
	      '<img src="' + info.imageUrl + '" alt="' + escapeHtml(info.name) + '">' +
	      '<div class="place-block-info">' +
	        '<h4><i class="bi bi-geo-alt-fill"></i> ' + escapeHtml(info.name) + '</h4>' +
	        '<p>' + escapeHtml(info.address || '') + '</p>' +
	        '<div class="place-rating" data-block-id="' + currentId + '">' +
	          '<span class="rating-label">별점</span>' +
	          '<div class="star-rating">' +
	            '<i class="bi bi-star" data-rating="1" onclick="setPlaceRating(' + currentId + ', 1)"></i>' +
	            '<i class="bi bi-star" data-rating="2" onclick="setPlaceRating(' + currentId + ', 2)"></i>' +
	            '<i class="bi bi-star" data-rating="3" onclick="setPlaceRating(' + currentId + ', 3)"></i>' +
	            '<i class="bi bi-star" data-rating="4" onclick="setPlaceRating(' + currentId + ', 4)"></i>' +
	            '<i class="bi bi-star" data-rating="5" onclick="setPlaceRating(' + currentId + ', 5)"></i>' +
	          '</div>' +
	          '<span class="rating-value">0.0</span>' +
	        '</div>' +
	      '</div>' +
	    '</div>' +
	    '<textarea class="block-textarea" placeholder="이 장소에 대한 이야기를 작성하세요..." oninput="autoResize(this)"></textarea>';

	  editor.appendChild(block);
}


function escapeHtml(s) {
	  return String(s ?? '')
	    .replaceAll('&', '&amp;')
	    .replaceAll('<', '&lt;')
	    .replaceAll('>', '&gt;')
	    .replaceAll('"', '&quot;')
	    .replaceAll("'", '&#39;');
}

function removeScheduleBlocksOnly() {
	  const editor = document.getElementById('blogEditor');
	  if (!editor) return;
	
	  // 일정에서 생성된 블록만 제거
	  editor.querySelectorAll('.editor-block[data-from-schedule="1"]').forEach(el => el.remove());
	
	  // 컨텍스트 초기화
	  __CURRENT_DAY_NO__ = null;
	  __CURRENT_DAY_DATE__ = null;
}

function resetLinkedScheduleUI() {
	  // UI 원복
	  linkedSchedule = null;
	  document.getElementById('scheduleLinkBanner').style.display = 'flex';
	  document.getElementById('linkedScheduleCard').style.display = 'none';
	
	  // 커버: 일정에서 자동 세팅한 경우만 제거
	  if (coverImageData && coverImageData.fromSchedule) {
	    removeCoverImage();   // 기존 함수 그대로 사용
	  }
	
	  // 위치 원복
	  selectedLocationName = '';
	  selectedLocationCode = '';
	  document.getElementById('locationValue').textContent = '위치를 추가하세요';
	  const locInput = document.getElementById('locationInput');
	  if (locInput) locInput.value = '';
	
	  // 날짜 원복
	  travelStartDate = null;
	  travelEndDate = null;
	  document.getElementById('dateValue').textContent = '날짜를 선택하세요';
	
	  const fp = document.getElementById('travelDateRange')?._flatpickr;
	  if (fp) fp.clear(); // 날짜 선택값 제거
	  
	  const titleInput = document.getElementById('blogTitle');
	  if (titleInput) {
	    if (titleInput.dataset.autoFromSchedule === "1") {
	      titleInput.value = '';
	    }
	    // 플래그 초기화
	    titleInput.dataset.autoFromSchedule = "0";
	    titleInput.dataset.autoTitleValue = '';
	  }
  
}

function initEditModeUI() {
	  // 제목/버튼 문구 변경
	  const h2 = document.querySelector('.travellog-write-header h2');
	  if (h2) h2.textContent = '여행기록 수정';

	  const btn = document.getElementById('submitBtn');
	  if (btn) {
	    btn.textContent = '수정';
	    btn.onclick = submitTravellog; // 그대로
	  }
}


async function loadExistingRecordForEdit(rcdNo) {
	  try {
	    // 1) detail 가져오기
	    const detailUrl = __CTX + '/api/travel-log/records/' + encodeURIComponent(rcdNo);
	    const detailRes = await fetch(detailUrl, { credentials:'include' });
	    if (!detailRes.ok) throw new Error('상세 조회 실패: ' + detailRes.status);

	    const detail = await detailRes.json();

	    // 2) blocks 가져오기 (detail에 없으면 별도 호출)
	    let blocks = detail.blocks;
	    if (!Array.isArray(blocks)) {
	      const blocksUrl = __CTX + '/api/travel-log/records/' + encodeURIComponent(rcdNo) + '/blocks';
	      const blocksRes = await fetch(blocksUrl, { credentials:'include' });
	      if (blocksRes.ok) blocks = await blocksRes.json();
	    }
	    if (!Array.isArray(blocks)) blocks = [];

	    // 3) 폼 채우기
	    fillFormForEdit(detail);
	    fillBlocksForEdit(blocks);

	  } catch (e) {
	    console.error(e);
	    showToast('수정 데이터를 불러오지 못했습니다.', 'error');
	  }
}


function toThumbUrlIfNeeded(pathOrUrl) {
	  if (!pathOrUrl) return '';

	  const s = String(pathOrUrl).trim();

	  // 이미 외부 URL이면 그대로
	  if (/^https?:\/\//i.test(s)) return s;

	  // 이미 searchthumbnail 형태면 그대로
	  if (s.includes('/file/searchthumbnail?path=')) return s;

	  // ✅ 404 나는 /travellog/cover/... 같은 URL이면 "path"로 간주해서 컨트롤러로 우회
	  //    (서버가 path 기반으로만 서빙한다는 전제)
	  //    만약 d.coverPath가 진짜 filePath(/upload/...)라면 이것도 그대로 인코딩되어 들어감.
	  return __CTX + '/file/searchthumbnail?path=' + encodeURIComponent(s);
}


function fillFormForEdit(d) {
	  // 제목
	  const titleEl = document.getElementById('blogTitle');
	  if (titleEl) titleEl.value = d.rcdTitle || '';

	  // 위치
	  selectedLocationCode = d.locCd ? String(d.locCd) : '';
	  selectedLocationName = d.locName || '';
	  document.getElementById('locationValue').textContent = selectedLocationName || '위치를 추가하세요';
	  const locInput = document.getElementById('locationInput');
	  if (locInput) locInput.value = selectedLocationName || '';

	  // 날짜
	  if (d.startDt && d.endDt) {
	    travelStartDate = new Date(d.startDt);
	    travelEndDate   = new Date(d.endDt);
	    document.getElementById('dateValue').textContent = d.startDt + ' ~ ' + d.endDt;
	    const fp = document.getElementById('travelDateRange')?._flatpickr;
	    if (fp) fp.setDate([travelStartDate, travelEndDate], true);
	  }

	  // 공개/지도/댓글
	  const visibility = document.getElementById('visibility');
	  if (visibility) visibility.value = (d.openScopeCd === 'PRIVATE') ? 'private' : 'public';
	  document.getElementById('showOnMap').checked = (d.mapDispYn !== 'N');
	  document.getElementById('allowComments').checked = (d.replyEnblYn !== 'N');

	  // 태그 (detail에서 tagText/tagName 중 뭐가 오는지 몰라서 방어)
	  tags = [];
	  const rawTag = d.tagText || d.tagName || '';
	  if (rawTag) {
	    tags = String(rawTag)
	      .split(',')
	      .map(x => x.trim().replace('#',''))
	      .filter(Boolean);
	  }
	  renderTags();

	  // 일정 연결(있는 경우)
	    // 일정 연결(있는 경우)
	  if (d.schdlNo) {
	    const schTitle = d.schdlNm || d.schdlName || d.scheduleTitle || '연결된 일정';
	
	    linkedSchedule = {
	      schdlNo: Number(d.schdlNo),
	      title: schTitle,
	      location: selectedLocationName
	    };
	
	    document.getElementById('scheduleLinkBanner').style.display = 'none';
	    document.getElementById('linkedScheduleCard').style.display = 'block';
	
	    document.getElementById('linkedScheduleTitle').textContent = schTitle;
	    document.getElementById('linkedScheduleLocation').textContent = selectedLocationName || '';
	
	    // ✅ 날짜는 YYYY-MM-DD로 정리해서 표시
	    const sYmd = toYmdString(d.startDt);
	    const eYmd = toYmdString(d.endDt);
	
	    document.getElementById('linkedScheduleDates').textContent =
	      (sYmd && eYmd) ? (sYmd + ' - ' + eYmd) : '';
	
	    // (선택) dateValue도 같이 통일하고 싶으면:
	    // if (sYmd && eYmd) document.getElementById('dateValue').textContent = sYmd + ' ~ ' + eYmd;
	  }


	  // 커버 (중요: 기존 커버는 “파일 업로드 없이도 유지”해야 함)
	  existingCoverAttachNo = d.attachNo || null;

	  // ✅ coverPath가 오면, 무조건 접근 가능한 URL로 변환해서 src에 넣기
	  if (d.coverPath) {
	    const coverUrl = toThumbUrlIfNeeded(d.coverPath);
	    document.getElementById('coverImg').src = coverUrl;
	    document.getElementById('coverPlaceholder').style.display = 'none';
	    document.getElementById('coverPreview').style.display = 'block';

	    coverImageData = {
	      fromExisting: true,
	      attachNo: existingCoverAttachNo,
	      dataUrl: coverUrl
	    };
	  }
	
}

	function fillBlocksForEdit(blocks) {
	  // 에디터 초기화(첫 블록 포함 싹 지우고 재구성)
	  const editor = document.getElementById('blogEditor');
	  editor.innerHTML = '';
	  bodyImageFiles = []; // ✅ 수정에서 새로 추가하는 파일만 여기 들어가야 함

	  blocks.forEach(b => {
	    const type = (b.blockType || b.type || '').toString().toUpperCase();

	    if (type === 'DIVIDER') {
	      addDividerBlock();
	      return;
	    }

	    if (type === 'IMAGE') {
	      addImageBlockFromServer(b);
	      return;
	    }

	    if (type === 'PLACE') {
	      addPlaceBlockFromServer(b);
	      return;
	    }

	    // TEXT: day-header JSON이면 day-header로 복원
	    const text = b.text || b.content || '';
	    const restored = tryRestoreDayHeaderFromText(text);
	    if (restored) {
	      addDayHeaderBlock(restored.dayNo, restored.dateStr);
	      return;
	    }

	    // 일반 텍스트
	    addTextBlock();
	    const last = editor.lastElementChild;
	    last.querySelector('textarea').value = text || '';
	    autoResize(last.querySelector('textarea'));
	  });

	  // 블록이 하나도 없으면 최소 1개
	  if (!editor.querySelector('.editor-block')) addTextBlock();
	}

	function tryRestoreDayHeaderFromText(text) {
	  if (!text) return null;
	  const t = String(text).trim();

	  // 1) JSON 형태로 저장된 경우
	  if (t.startsWith('{') && t.endsWith('}')) {
	    try {
	      const obj = JSON.parse(t);
	      if (obj && (obj.type === 'day-header' || obj.type === 'DAY_HEADER')) {
	        return { dayNo: obj.dayNo ?? obj.day ?? '', dateStr: obj.dateStr ?? obj.date ?? '' };
	      }
	    } catch (e) {}
	  }

	  // 2) "DAY 1 2024-01-01" 같은 문자열로 저장된 경우(너 현재 collectBlocksForSave가 이렇게 저장했었음)
	  const m = t.match(/^DAY\s*([0-9]+)\s*(.*)$/i);
	  if (m) return { dayNo: m[1], dateStr: (m[2] || '').trim() };

	  return null;
	}

	
	function pickExistingAttachNo(b) {
		  if (!b) return null;

		  // 서버가 내려주는 필드명이 제각각일 수 있어서 후보를 넓게 잡음
		  const candidates = [
		    b.attachNo,
		    b.imgAttachNo,
		    b.bodyAttachNo,
		    b.fileAttachNo,
		    b.attchNo,
		    b.attach_no,
		    b.ATTACH_NO,
		    b.targetPk,     // 어떤 구현은 TARGET_PK에 attachNo를 넣기도 함
		    b.targetNo,
		    b.fileNo
		  ];

		  for (const v of candidates) {
		    if (v === 0) return 0; // 혹시 0을 유효값으로 쓰는 구조면 살림(보통은 아니지만 방어)
		    if (v != null && String(v).trim() !== '') return Number(v);
		  }
		  return null;
		}

		function pickExistingImagePath(b) {
		  if (!b) return '';
		  // 서버가 내려주는 이미지 경로 키 후보
		  return (
		    b.imgPath ||
		    b.imageUrl ||
		    b.filePath ||
		    b.path ||
		    b.url ||
		    b.IMG_PATH ||
		    ''
		  );
		}

		function addImageBlockFromServer(b) {
		  blockIdCounter++;
		  const currentId = blockIdCounter;

		  const rawPath = pickExistingImagePath(b);
		  const imgUrl = toThumbUrlIfNeeded(rawPath);
		  const desc = b.desc || b.caption || b.text || '';

		  const editor = document.getElementById('blogEditor');
		  const block = document.createElement('div');
		  block.className = 'editor-block image-block';
		  block.dataset.blockId = currentId;

		  // ✅✅ 핵심: 기존 이미지 유지용 attachNo를 dataset에 반드시 박는다
		  const existingAttachNo = pickExistingAttachNo(b);
		  if (existingAttachNo != null) {
		    block.dataset.attachNo = String(existingAttachNo);
		  }

		  // ✅ 기존 블록은 새 업로드가 아니므로 fileIdx는 절대 넣지 않는다 (혹시 남아있으면 제거)
		  delete block.dataset.fileIdx;

		  block.innerHTML =
		    '<div class="block-actions">' +
		      '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + currentId + ')"><i class="bi bi-chevron-up"></i></button>' +
		      '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + currentId + ')"><i class="bi bi-chevron-down"></i></button>' +
		      '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + currentId + ')"><i class="bi bi-trash"></i></button>' +
		    '</div>' +
		    '<div class="image-block-content">' +
		      '<img src="' + imgUrl + '" alt="이미지">' +
		    '</div>' +
		    '<input type="text" class="image-caption" placeholder="사진 설명" value="' + escapeHtml(desc) + '">';

		  editor.appendChild(block);

		  // 🔎 디버그: 기존 이미지 블록이 attachNo를 제대로 갖는지 확인
		  console.log('[edit:image] restored', {
		    blockId: currentId,
		    attachNo: block.dataset.attachNo,
		    rawPath,
		    imgUrl
		  });
		}



	function addPlaceBlockFromServer(b) {
	  // place 블록은 너가 이미 만든 addPlaceToEditor랑 거의 동일
	  const plcNo = b.plcNo ?? null;
	  const name = b.plcNm || b.name || '장소';
	  const addr = ((b.plcAddr1 || '') + ' ' + (b.plcAddr2 || '')).trim() || (b.address || '');
	  const img = b.placeImgPath || b.defaultImg || b.image || 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=300&h=200&fit=crop&q=80';

	  addPlaceToEditor(plcNo, name, addr, img);

	  // 마지막 place-block에 리뷰/별점 세팅
	  const editor = document.getElementById('blogEditor');
	  const last = editor.lastElementChild;
	  if (!last) return;

	  // 리뷰(텍스트)
	  const ta = last.querySelector('textarea');
	  if (ta) {
	    ta.value = b.reviewConn || b.content || '';
	    autoResize(ta);
	  }

	  // 별점
	  const rating = Number(b.rating || 0);
	  if (rating > 0) setPlaceRating(Number(last.dataset.blockId), rating);
}




// 모달 인스턴스
let scheduleModal, placeBlockModal, previewModal;

// 컨텍스트 경로
// const contextPath = '${pageContext.request.contextPath}';

document.addEventListener('DOMContentLoaded', function() {
    // 모달 초기화
    scheduleModal = new bootstrap.Modal(document.getElementById('scheduleModal'));
    placeBlockModal = new bootstrap.Modal(document.getElementById('placeBlockModal'));
    previewModal = new bootstrap.Modal(document.getElementById('previewModal'));

    // Flatpickr 초기화   
    const dateInput = document.getElementById('travelDateRange');
	if (dateInput && typeof flatpickr !== 'undefined') {
	
	  // ✅ 이미 다른 곳에서 flatpickr가 붙어있다면 제거
	  if (dateInput._flatpickr) {
	    dateInput._flatpickr.destroy();
	  }
	
	  flatpickr(dateInput, {
	    locale: 'ko',
	    dateFormat: 'Y-m-d',
	    mode: 'range',
	    allowInput: true,
	
	    // ✅ 혹시 다른 곳에서 min/max 걸려도 여기서 "해제" 강제
	    minDate: null,
	    maxDate: null,
	
	    onChange: function(selectedDates, dateStr) {
	      if (selectedDates.length === 2) {
	        travelStartDate = selectedDates[0];
	        travelEndDate = selectedDates[1];
	        document.getElementById('dateValue').textContent = dateStr;
	      }
	    }
	  });
	}


    // URL 파라미터 체크 (일정에서 넘어온 경우)
    const urlParams = new URLSearchParams(window.location.search);
    const scheduleId = urlParams.get('schedule');
    if (scheduleId) {
        // TODO: 서버에서 일정 정보를 가져와서 자동 연결
        console.log('Schedule ID from URL:', scheduleId);
    }
    
    // ⭐ 여기로 위치 자동완성 init을 넣기
    initLocationAutocomplete();

    // 별점 hover init도 여기로
    initStarRatingHover();

    // datepicker force도 여기로
    initTravelDatePickerForce();
    setTimeout(initTravelDatePickerForce, 0);
    setTimeout(initTravelDatePickerForce, 300);
    
    document.getElementById('locationSettingItem')?.addEventListener('click', function(e){
    	  e.stopPropagation();
    	  toggleSettingInput('location');
    });
    
    if (isEditMode) {
    	  initEditModeUI();
    	  loadExistingRecordForEdit(editingRcdNo);
    }


    
});

		function initLocationAutocomplete() {
			  console.log('[loc] init');

			  const input = document.getElementById('locationInput');
			  const box = document.getElementById('locationSuggestions');
			  if (!input || !box) {
			    console.log('[loc] init failed: input/box not found');
			    return;
			  }

			  // ✅ input 기준으로 중복 바인딩 방지
			  if (input.dataset.locBound === '1') {
			    console.log('[loc] already bound (input)');
			    return;
			  }
			  input.dataset.locBound = '1';

			  function handleQuery() {
			    const q = (input.value || '').trim();
			    console.log('[loc] input=', q);
			    debounceFetchRegions(q);
			  }

			  // ✅ focus: 열기
			  input.addEventListener('focus', function () {
			    openLocationSuggestions();
			  }, true);

			  // ✅ 실제 타이핑: input에 직접 바인딩(가장 확실)
			  input.addEventListener('input', function () {
			    handleQuery();
			  }, true);

			  // ✅ 한글 IME 조합 끝
			  input.addEventListener('compositionend', function () {
			    handleQuery();
			  }, true);

			  // ✅ 혹시 input 이벤트가 이상하면 keyup로 보강
			  input.addEventListener('keyup', function (e) {
			    const k = e.key;
			    if (k === 'ArrowUp' || k === 'ArrowDown' || k === 'ArrowLeft' || k === 'ArrowRight' || k === 'Escape' || k === 'Enter') return;
			    handleQuery();
			  }, true);

			  // ESC 닫기
			  input.addEventListener('keydown', function (e) {
			    if (e.key === 'Escape') {
			      closeLocationSuggestions();
			      input.blur();
			    }
			  }, true);

			  // 바깥 클릭 닫기(이건 document가 편함)
			  document.addEventListener('click', function (e) {
			    const inputArea = document.getElementById('locationInputArea');
			    if (!inputArea) return;
			    if (inputArea.style.display !== 'block') return;
			    if (!inputArea.contains(e.target)) {
			      closeLocationSuggestions();
			      inputArea.style.display = 'none';
			    }
			  }, true);

			  console.log('[loc] bound OK (direct input listeners)');
			}



	
	
function collectBlocksForSave() {
			  const result = [];
			  const blocks = document.querySelectorAll('#blogEditor .editor-block');

			  blocks.forEach((block, idx) => {
			    const order = idx + 1;

			    // TEXT
			    if (block.classList.contains('text-block')) {
			      result.push({
			        type: 'text',
			        order,
			        content: block.querySelector('textarea')?.value || ''
			      });
			      return;
			    }

			    // IMAGE
			    if (block.classList.contains('image-block')) {
			      const fileIdxRaw = block.dataset.fileIdx;   // 새로 추가한 파일이면 존재
			      const attachNoRaw = block.dataset.attachNo; // 서버에서 불러온 기존 이미지면 존재

			      const payload = {
			        type: 'image',
			        order,
			        caption: block.querySelector('.image-caption')?.value || ''
			      };

			      // ✅ 새 파일이면 fileIdx
			      if (fileIdxRaw != null && fileIdxRaw !== '') {
			        payload.fileIdx = Number(fileIdxRaw);
			      }

			      // ✅ 기존 이미지 유지면 attachNo
			      if (attachNoRaw != null && attachNoRaw !== '') {
			        payload.attachNo = Number(attachNoRaw);
			      }

			      result.push(payload);
			      return;
			    }

			    // DIVIDER
			    if (block.classList.contains('divider-block')) {
			      result.push({ type: 'divider', order });
			      return;
			    }

			    // DAY_HEADER (진짜 타입으로 보내자: day-header)
			    // DAY_HEADER (진짜 타입으로 보내자: day-header)
				if (block.classList.contains('day-header-block')) {
				  const dayVal = block.dataset.dayNo || '';
				  const dateVal = block.dataset.dateStr || '';
				
				  result.push({
				    type: 'day-header',
				    order,
				    // ✅ 서버가 기대하는 키로 맞추기
				    day: dayVal !== '' ? Number(dayVal) : null,
				    date: dateVal || null
				  });
				  return;
				}


			    // PLACE
			    if (block.classList.contains('place-block')) {
			      const rating = block.querySelector('.place-rating')?.dataset?.rating || '0';

			      result.push({
			        type: 'place',
			        order,
			        plcNo: block.dataset.plcNo ? Number(block.dataset.plcNo) : null,
			        day: block.dataset.day ? Number(block.dataset.day) : null,
			        date: block.dataset.date || null,
			        name: block.dataset.name || null,
			        address: block.dataset.address || null,
			        image: block.dataset.image || null,
			        rating: Number(rating),
			        content: block.querySelector('textarea')?.value || ''
			      });
			      return;
			    }
			  });

			  return result;
}



		

// 커버 이미지 처리
function handleCoverImage(event) {
    const file = event.target.files[0];
    if (!file) return;

    if (file.size > 10 * 1024 * 1024) {
        showToast('이미지 크기는 10MB 이하여야 합니다.', 'error');
        return;
    }

    const reader = new FileReader();
    reader.onload = function(e) {
        coverImageData = {
            file: file,
            dataUrl: e.target.result
        };
        document.getElementById('coverImg').src = e.target.result;
        document.getElementById('coverPlaceholder').style.display = 'none';
        document.getElementById('coverPreview').style.display = 'block';
    };
    reader.readAsDataURL(file);
}

function removeCoverImage() {
    coverImageData = null;
    document.getElementById('coverImg').src = '';
    document.getElementById('coverPlaceholder').style.display = 'flex';
    document.getElementById('coverPreview').style.display = 'none';
    document.getElementById('coverImageInput').value = '';
}

// 텍스트 블록 추가
function addTextBlock() {
    blockIdCounter++;
    const editor = document.getElementById('blogEditor');
    const block = document.createElement('div');
    block.className = 'editor-block text-block';
    block.dataset.blockId = blockIdCounter;
    block.innerHTML =
        '<div class="block-actions">' +
            '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + blockIdCounter + ')"><i class="bi bi-chevron-up"></i></button>' +
            '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + blockIdCounter + ')"><i class="bi bi-chevron-down"></i></button>' +
            '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + blockIdCounter + ')"><i class="bi bi-trash"></i></button>' +
        '</div>' +
        '<textarea class="block-textarea" placeholder="내용을 입력하세요..." oninput="autoResize(this)"></textarea>';
    editor.appendChild(block);
    block.querySelector('textarea').focus();
}

// 이미지 블록 추가
function addImageBlocks(event) {
    const files = Array.from(event.target.files);

    files.forEach(file => {
        if (file.size > 10 * 1024 * 1024) {
            showToast(file.name + ' 파일이 너무 큽니다. (최대 10MB)', 'error');
            return;
        }

        // ✅ 여기 추가 (파일을 전역 배열에 보관)
        bodyImageFiles.push(file);
        
        const fileIdx = bodyImageFiles.length - 1; // 플러스
        

        const reader = new FileReader();
        reader.onload = function(e) {
            blockIdCounter++;
            const currentId = blockIdCounter;
            const editor = document.getElementById('blogEditor');
            const block = document.createElement('div');
            block.className = 'editor-block image-block';
            block.dataset.blockId = currentId;
            
            block.dataset.fileIdx = fileIdx;	// 플러스
            
            block.innerHTML =
                '<div class="block-actions">' +
                    '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + currentId + ')"><i class="bi bi-chevron-up"></i></button>' +
                    '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + currentId + ')"><i class="bi bi-chevron-down"></i></button>' +
                    '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + currentId + ')"><i class="bi bi-trash"></i></button>' +
                '</div>' +
                '<div class="image-block-content">' +
                    '<img src="' + e.target.result + '" alt="업로드 이미지">' +
                '</div>' +
                '<input type="text" class="image-caption" placeholder="사진에 대한 설명을 추가하세요 (선택사항)">';
            editor.appendChild(block);
        };
        reader.readAsDataURL(file);
    });

    // ❗ 이건 유지해도 됨 (input 초기화)
    event.target.value = '';
}


// 구분선 블록 추가
function addDividerBlock() {
    blockIdCounter++;
    const editor = document.getElementById('blogEditor');
    const block = document.createElement('div');
    block.className = 'editor-block divider-block';
    block.dataset.blockId = blockIdCounter;
    block.innerHTML =
        '<div class="block-actions">' +
            '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + blockIdCounter + ')"><i class="bi bi-chevron-up"></i></button>' +
            '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + blockIdCounter + ')"><i class="bi bi-chevron-down"></i></button>' +
            '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + blockIdCounter + ')"><i class="bi bi-trash"></i></button>' +
        '</div>' +
        '<hr class="block-divider">';
    editor.appendChild(block);
}

// 장소 블록 모달 열기
function addPlaceBlock() {
    placeBlockModal.show();
}

// 장소 블록을 에디터에 추가
// ✅ 장소 블록을 에디터에 추가 (plcNo 포함 버전)
function addPlaceToEditor(plcNo, name, address, imageUrl) {
  blockIdCounter++;
  const currentId = blockIdCounter;
  const editor = document.getElementById('blogEditor');
  const block = document.createElement('div');
  block.className = 'editor-block place-block';
  block.dataset.blockId = currentId;

  // ✅ 저장용 plcNo 세팅 (가장 중요)
  if (plcNo != null && plcNo !== '') {
    block.dataset.plcNo = String(plcNo);
  }

  // (선택) 수동 추가 장소는 day/date가 없으니 비워둬도 됨
  block.dataset.day = '';
  block.dataset.date = '';

  // 보기용/프리뷰용 데이터도 저장해두면 좋음
  block.dataset.name = name || '';
  block.dataset.address = address || '';
  block.dataset.image = imageUrl || '';

  block.innerHTML =
    '<div class="block-actions">' +
      '<button type="button" class="block-action-btn" onclick="moveBlockUp(' + currentId + ')"><i class="bi bi-chevron-up"></i></button>' +
      '<button type="button" class="block-action-btn" onclick="moveBlockDown(' + currentId + ')"><i class="bi bi-chevron-down"></i></button>' +
      '<button type="button" class="block-action-btn delete" onclick="deleteBlock(' + currentId + ')"><i class="bi bi-trash"></i></button>' +
    '</div>' +
    '<div class="place-block-content">' +
      '<img src="' + imageUrl + '" alt="' + escapeHtml(name) + '">' +
      '<div class="place-block-info">' +
        '<h4><i class="bi bi-geo-alt-fill"></i> ' + escapeHtml(name) + '</h4>' +
        '<p>' + escapeHtml(address || '') + '</p>' +
        '<div class="place-rating" data-block-id="' + currentId + '">' +
          '<span class="rating-label">별점</span>' +
          '<div class="star-rating">' +
            '<i class="bi bi-star" data-rating="1" onclick="setPlaceRating(' + currentId + ', 1)"></i>' +
            '<i class="bi bi-star" data-rating="2" onclick="setPlaceRating(' + currentId + ', 2)"></i>' +
            '<i class="bi bi-star" data-rating="3" onclick="setPlaceRating(' + currentId + ', 3)"></i>' +
            '<i class="bi bi-star" data-rating="4" onclick="setPlaceRating(' + currentId + ', 4)"></i>' +
            '<i class="bi bi-star" data-rating="5" onclick="setPlaceRating(' + currentId + ', 5)"></i>' +
          '</div>' +
          '<span class="rating-value">0.0</span>' +
        '</div>' +
      '</div>' +
    '</div>' +
    '<textarea class="block-textarea" placeholder="이 장소에 대한 이야기를 작성하세요..." oninput="autoResize(this)"></textarea>';

  editor.appendChild(block);

  // 모달 닫고 포커스
  placeBlockModal.hide();
  block.querySelector('textarea')?.focus();
}


// 장소 별점 설정
function setPlaceRating(blockId, rating) {
    const ratingContainer = document.querySelector('.place-rating[data-block-id="' + blockId + '"]');
    if (!ratingContainer) return;

    const stars = ratingContainer.querySelectorAll('.star-rating i');
    const ratingValue = ratingContainer.querySelector('.rating-value');

    // 모든 별 초기화
    stars.forEach(function(star, index) {
        if (index < rating) {
            star.classList.remove('bi-star');
            star.classList.add('bi-star-fill');
        } else {
            star.classList.remove('bi-star-fill');
            star.classList.add('bi-star');
        }
    });

    // 별점 값 표시
    ratingValue.textContent = rating + '.0';
    ratingContainer.dataset.rating = rating;
}

// 별점 호버 효과
function initStarRatingHover() {
    document.addEventListener('mouseover', function(e) {
        if (e.target.matches('.star-rating i')) {
            const starRating = e.target.closest('.star-rating');
            const stars = starRating.querySelectorAll('i');
            const hoverRating = parseInt(e.target.dataset.rating);

            stars.forEach(function(star, index) {
                if (index < hoverRating) {
                    star.classList.add('hovered');
                } else {
                    star.classList.remove('hovered');
                }
            });
        }
    });

    document.addEventListener('mouseout', function(e) {
        if (e.target.matches('.star-rating i')) {
            const starRating = e.target.closest('.star-rating');
            const stars = starRating.querySelectorAll('i');
            stars.forEach(function(star) {
                star.classList.remove('hovered');
            });
        }
    });
}

// 초기화 시 호버 효과 등록


// 블록 위로 이동
function moveBlockUp(blockId) {
    const block = document.querySelector('[data-block-id="' + blockId + '"]');
    const prev = block.previousElementSibling;
    if (prev && prev.classList.contains('editor-block')) {
        block.parentNode.insertBefore(block, prev);
    }
}

// 블록 아래로 이동
function moveBlockDown(blockId) {
    const block = document.querySelector('[data-block-id="' + blockId + '"]');
    const next = block.nextElementSibling;
    if (next && next.classList.contains('editor-block')) {
        block.parentNode.insertBefore(next, block);
    }
}

// 블록 삭제
function deleteBlock(blockId) {
    const block = document.querySelector('[data-block-id="' + blockId + '"]');
    if (document.querySelectorAll('.editor-block').length > 1) {
        block.remove();
    } else {
        showToast('최소 하나의 블록이 필요합니다.', 'warning');
    }
}

// 텍스트 영역 자동 크기 조절
function autoResize(textarea) {
    textarea.style.height = 'auto';
    textarea.style.height = textarea.scrollHeight + 'px';
}

// 일정 모달 열기
function openScheduleModal() {
    scheduleModal.show();
}

document.addEventListener('click', function(e){
	  const item = e.target.closest('.schedule-modal-item');
	  if (!item) return;

	  const modalEl = document.getElementById('scheduleModal');
	  if (!modalEl || !modalEl.contains(item)) return;

	  const schedule = {
	    schdlNo: Number(item.dataset.scheduleNo),
	    title: item.dataset.title || '',
	    location: item.dataset.location || '',
	    locationCode: item.dataset.locationCode || '',
	    start: item.dataset.start || '',
	    end: item.dataset.end || '',
	    dates: (item.dataset.start && item.dataset.end) ? (item.dataset.start + ' - ' + item.dataset.end) : '',
	    coverAttachNo: item.dataset.attachNo ? Number(item.dataset.attachNo) : null,
	    coverAttachPath: item.dataset.attachPath || null
	  };

	  selectScheduleFromList(schedule);
});


function selectScheduleFromList(schedule) {
	  linkedSchedule = schedule;

	  // 연결된 일정 카드 표시
	  document.getElementById('scheduleLinkBanner').style.display = 'none';
	  document.getElementById('linkedScheduleCard').style.display = 'block';

	  document.getElementById('linkedScheduleTitle').textContent = schedule.title || '제목 없음';
	  document.getElementById('linkedScheduleDates').textContent = schedule.dates || '';
	  document.getElementById('linkedScheduleLocation').textContent = schedule.location || '';

	  // 장소칩은 목록 데이터에 없을 수 있으니 안내만
	  const placesContainer = document.getElementById('linkedSchedulePlaces');

	  // 위치 자동 세팅
	  document.getElementById('locationValue').textContent = schedule.location || '위치를 추가하세요';
	  selectedLocationName = schedule.location || '';
	  selectedLocationCode = schedule.locationCode || '';

	  // 날짜 자동 세팅 (schdlStartDt/schdlEndDt는 YYYY-MM-DD 문자열이라 Date로 바로 가능)
	  if (schedule.start && schedule.end) {
	    travelStartDate = new Date(schedule.start);
	    travelEndDate   = new Date(schedule.end);

	    document.getElementById('dateValue').textContent = schedule.start + ' ~ ' + schedule.end;

	    const fp = document.getElementById('travelDateRange')?._flatpickr;
	    if (fp) fp.setDate([travelStartDate, travelEndDate], true);
	  }

	  // 제목 자동(비어있을 때만)
		const titleInput = document.getElementById('blogTitle');
		if (titleInput && !titleInput.value.trim()) {
		  titleInput.value = (schedule.title || '') + ' 여행기';
		
		  // ✅ "일정 연결로 자동 채움" 표시
		  titleInput.dataset.autoFromSchedule = "1";
		  titleInput.dataset.autoTitleValue = titleInput.value; // (선택) 참고용
		}

		// 커버 자동(비어있을 때만) - ✅ attach 기반일 때만
		if (!coverImageData) {
		  // 1) attachPath가 있으면 이걸로 썸네일 URL 만들기(가장 확실)
		  if (schedule.coverAttachPath) {
		    const coverUrl = window.__CTX__ + '/file/searchthumbnail?path=' + encodeURIComponent(schedule.coverAttachPath);

		    document.getElementById('coverImg').src = coverUrl;
		    document.getElementById('coverPlaceholder').style.display = 'none';
		    document.getElementById('coverPreview').style.display = 'block';

		    coverImageData = {
		      fromSchedule: true,
		      attachNo: schedule.coverAttachNo || null,
		      attachPath: schedule.coverAttachPath,
		      dataUrl: coverUrl   // 프리뷰용
		    };
		  }
		  // 2) attachNo만 있고 attachPath가 없으면 (엔드포인트가 attachNo 지원할 때만 사용)
		  // else if (schedule.coverAttachNo) { ... }
		}


	  scheduleModal.hide();
	  showToast('일정이 연결되었습니다!', 'success');
	  loadScheduleFull(schedule.schdlNo);
	}


// 일정 필터링
function filterScheduleModal(filter) {
    // 탭 활성화
    document.querySelectorAll('.schedule-modal-tab').forEach(function(tab) { tab.classList.remove('active'); });
    document.querySelector('.schedule-modal-tab[data-filter="' + filter + '"]').classList.add('active');

    // 아이템 필터링
    const items = document.querySelectorAll('.schedule-modal-item');
    let visibleCount = 0;

    items.forEach(function(item) {
        if (filter === 'all' || item.dataset.status === filter) {
            item.style.display = 'flex';
            visibleCount++;
        } else {
            item.style.display = 'none';
        }
    });

    // 빈 상태 표시
    const emptyEl = document.getElementById('scheduleModalEmpty');
    if (emptyEl) emptyEl.style.display = (visibleCount === 0 ? 'block' : 'none');
}



// 일정 연결 해제
function unlinkSchedule() {
	 // 1) 일정으로 생성된 블록만 삭제
	  removeScheduleBlocksOnly();

	  // 2) 연결 UI/자동세팅 값들 원복
	  resetLinkedScheduleUI();

	  showToast('일정 연결이 해제되었고, 불러온 일정 블록이 삭제되었습니다.', 'info');
}

// 설정 입력 영역 토글
function toggleSettingInput(type) {
	
    const area = document.getElementById(type + 'InputArea');
    const isVisible = area.style.display === 'block';

    // 모든 입력 영역 닫기
    document.querySelectorAll('.setting-input-area').forEach(function(el) { el.style.display = 'none'; });

    // 클릭한 영역 토글
    if (!isVisible) {
        area.style.display = 'block';
        const input = area.querySelector('input');
        if (input) input.focus();
        
        if (type === 'location') {
        	  initLocationAutocomplete();
        	  __locJustOpened = true;
        	  openLocationSuggestions();
        }
    }
}

// 위치 검색




//====== 위치 자동완성(지역) ======
let regionAbortController = null;
let regionDebounceTimer = null;

// DOMContentLoaded에서 이벤트를 "JS로" 묶어주면 JSP onfocus/oninput 없어도 됨.
// 너는 이미 onfocus/oninput을 걸어놨으니, 아래 init만 추가해도 OK.
async function openLocationSuggestions() {
	  console.log('[loc] open');

	  const input = document.getElementById('locationInput');
	  if (!input) return;

	  const v = (input.value || '').trim();
	  const q = (v && v !== (selectedLocationName || '')) ? v : '';

	  // ✅ 열릴 때(패널 열기 직후)만 한번 select
	  if (__locJustOpened) {
	    __locJustOpened = false;
	    input.select();
	  }

	  await fetchAndRenderRegions(q);
	}

function debounceFetchRegions(query) {
	  if (regionDebounceTimer) clearTimeout(regionDebounceTimer);
	  regionDebounceTimer = setTimeout(function () {
	    fetchAndRenderRegions(query);
	  }, 400);
}

function onLocationInput(e) {
	  const el = e && e.target ? e.target : document.getElementById('locationInput');
	  if (!el) return;

	  const q = (el.value || '').trim();
	  console.log('[loc] input=', q);

	  // 방향키/ESC/ENTER는 keyup에서 걸러주기(옵션)
	  if (e && e.type === 'keyup') {
	    const k = e.key;
	    if (k === 'ArrowUp' || k === 'ArrowDown' || k === 'ArrowLeft' || k === 'ArrowRight' || k === 'Escape' || k === 'Enter') return;
	  }

	  debounceFetchRegions(q);
	}


// 실제 호출 + 렌더
async function fetchAndRenderRegions(query) {
	
	console.log('[loc] base=', window.__CTX__);
	const url = window.__CTX__ + '/api/regions?keyword=' + encodeURIComponent(query || '') + '&size=10';
	console.log('[loc] url=', url);
	
	console.log('[loc] fetch query=', query);
  const suggestions = document.getElementById('locationSuggestions');
  if (!suggestions) return;
//base는 ''(루트)일 수도 있으니 체크하지 않는다
const base = (window.__CTX__ ?? '');

if (!suggestions) return;  

  suggestions.style.display = 'block';

  // 이전 요청 취소
  if (regionAbortController) regionAbortController.abort();
  regionAbortController = new AbortController();

  try {
    const url = base + '/api/regions?keyword=' + encodeURIComponent(query || '') + '&size=10';

    const res = await fetch(url, {
      method: 'GET',
      credentials: 'include',
      signal: regionAbortController.signal
    });
    
    console.log('[loc] res status=', res.status);

    if (!res.ok) throw new Error('지역 검색 실패');

    const list = await res.json();

    console.log('[loc] list len=', Array.isArray(list)? list.length : 'not array', list);
    
    // 목록 비우고 시작
    suggestions.innerHTML = '';

    // 결과 없을 때
    if (!Array.isArray(list) || list.length === 0) {
      const msg = document.createElement('div');
      msg.className = 'location-empty';

      if (!query || query.length === 0) {
        // 포커스 시 기본목록이 비는 경우: "없음" 대신 안내문만
        msg.textContent = '지역을 입력하면 목록이 표시됩니다';
      } else {
        msg.textContent = '검색 결과가 없습니다';
      }

      suggestions.appendChild(msg);
      suggestions.style.display = 'block';
      return;
    }

    // 결과 렌더: innerHTML 문자열로 만들지 말고 DOM으로 만들기(안전/EL 충돌 없음)
    for (let i = 0; i < list.length; i++) {
      const r = list[i] || {};
      const nm = (r.rgnNm || '').toString();
      const sub = (r.rgnDetail || '').toString();
      const no = (r.rgnNo == null ? '' : String(r.rgnNo));

      const item = document.createElement('div');
      item.className = 'location-item';
      item.setAttribute('data-no', no);

      const icon = document.createElement('i');
      icon.className = 'bi bi-geo-alt';

      const span = document.createElement('span');
      span.textContent = nm;

      if (sub && sub.length > 0) {
        const small = document.createElement('small');
        small.style.opacity = '0.7';
        small.textContent = ' (' + sub + ')';
        span.appendChild(small);
      }

      item.appendChild(icon);
      item.appendChild(span);

      item.addEventListener('click', function () {
        selectRegionItem(no, nm);
      });

      suggestions.appendChild(item);
    }

    suggestions.style.display = 'block';

  } catch (e) {
    // abort는 정상 흐름
    if (e && e.name === 'AbortError') return;

    console.error(e);
    suggestions.innerHTML = '';
    suggestions.style.display = 'none';
  }
}

function closeLocationSuggestions() {
  const suggestions = document.getElementById('locationSuggestions');
  if (!suggestions) return;
  suggestions.innerHTML = '';
  suggestions.style.display = 'none';
}

// 선택 시 처리(너가 이미 쓰던 변수/표시 유지)
function selectRegionItem(rgnNo, rgnNm) {
  selectedLocationCode = String(rgnNo || '');
  selectedLocationName = String(rgnNm || '');

  document.getElementById('locationValue').textContent = selectedLocationName;
  document.getElementById('locationInput').value = selectedLocationName;

  closeLocationSuggestions();
  document.getElementById('locationInputArea').style.display = 'none';
}

// 태그 관리
function addTag(event) {
    if (event.key !== 'Enter') return;
    event.preventDefault();

    const input = document.getElementById('tagInput');
    let tag = input.value.trim().replace('#', '');

    if (!tag) return;

    if (tags.length >= 10) {
        showToast('태그는 최대 10개까지 추가 가능합니다.', 'warning');
        return;
    }

    if (tags.includes(tag)) {
        showToast('이미 추가된 태그입니다.', 'warning');
        return;
    }

    tags.push(tag);
    input.value = '';
    renderTags();
}

function addPopularTag(tag) {
    tag = tag.replace('#', '');

    if (tags.length >= 10) {
        showToast('태그는 최대 10개까지 추가 가능합니다.', 'warning');
        return;
    }

    if (tags.includes(tag)) {
        showToast('이미 추가된 태그입니다.', 'warning');
        return;
    }

    tags.push(tag);
    renderTags();
}

function renderTags() {
    const container = document.getElementById('tagList');
    container.innerHTML = tags.map(function(tag, index) {
        return '<span class="tag-item">#' + tag + '<button type="button" onclick="removeTag(' + index + ')"><i class="bi bi-x"></i></button></span>';
    }).join('');

    if (tags.length > 0) {
        document.getElementById('tagValue').textContent = tags.map(function(t) { return '#' + t; }).join(' ');
    } else {
        document.getElementById('tagValue').textContent = '태그를 추가하세요';
    }
}

function removeTag(index) {
    tags.splice(index, 1);
    renderTags();
}

let placeAbortController = null;
let placeDebounceTimer = null;

function debouncePlaceSearch(q) {
  if (placeDebounceTimer) clearTimeout(placeDebounceTimer);
  placeDebounceTimer = setTimeout(() => fetchAndRenderPlaces(q), 300);
}

async function fetchAndRenderPlaces(keyword) {
  const box = document.getElementById('placeSearchResults');
  if (!box) return;

  // 이전 요청 취소
  if (placeAbortController) placeAbortController.abort();
  placeAbortController = new AbortController();

  const base = (window.__CTX__ ?? '');
  const q = (keyword || '').trim();

  // (추천) 지역 선택했으면 rgnNo 같이 보내기
  const rgnNo = (selectedLocationCode || '').trim();

  const url =
    base +
    '/api/community/travel-log/places?keyword=' + encodeURIComponent(q) +
    (rgnNo ? ('&rgnNo=' + encodeURIComponent(rgnNo)) : '') +
    '&size=20';

  // 로딩 UI
  box.innerHTML =
    '<div class="location-empty" style="padding:12px;color:#6b7280;">검색 중...</div>';

  try {
    const res = await fetch(url, {
      method: 'GET',
      credentials: 'include',
      signal: placeAbortController.signal
    });

    if (!res.ok) throw new Error('장소 검색 실패');

    const list = await res.json();

    box.innerHTML = '';

    if (!Array.isArray(list) || list.length === 0) {
      box.innerHTML =
        '<div class="location-empty" style="padding:12px;color:#6b7280;">검색 결과가 없습니다</div>';
      return;
    }

    list.forEach(p => {
      const plcNo = p.plcNo;
      const name = p.plcNm || '장소';
      const addr = ((p.plcAddr1 || '') + ' ' + (p.plcAddr2 || '')).trim();
      const img = p.defaultImg || 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=1200&h=600&fit=crop&q=80';

      const item = document.createElement('div');
      item.className = 'place-search-item';
      item.style.cursor = 'pointer';

      item.innerHTML =
        '<img src="' + img + '" alt="' + escapeHtml(name) + '">' +
        '<div class="place-search-info">' +
          '<span class="place-name">' + escapeHtml(name) + '</span>' +
          '<span class="place-address">' + escapeHtml(addr) + '</span>' +
        '</div>';

      item.addEventListener('click', function () {
        addPlaceToEditor(plcNo, name, addr, img);
      });

      box.appendChild(item);
    });

  } catch (e) {
    if (e && e.name === 'AbortError') return;
    console.error(e);
    box.innerHTML =
      '<div class="location-empty" style="padding:12px;color:#6b7280;">오류가 발생했습니다</div>';
  }
}

// ✅ 기존 searchPlaceForBlock을 서버 검색으로 교체
function searchPlaceForBlock(event) {
  const q = (event.target.value || '').trim();
  debouncePlaceSearch(q);
}

// ✅ 모달 열릴 때도 기본 로딩(지역 선택되어 있으면 그 지역 인기/전체)
function addPlaceBlock() {
  placeBlockModal.show();
  const input = document.getElementById('placeSearchInput');
  if (input) {
    input.focus();
    input.select();
  }
  fetchAndRenderPlaces(input ? input.value : '');
}


// 미리보기
function previewTravellog() {
    const title = document.getElementById('blogTitle').value || '제목 없음';
    const blocks = document.querySelectorAll('.editor-block');

    let contentHtml = '';

    // 커버 이미지
    if (coverImageData) {
        contentHtml += '<div class="preview-cover"><img src="' + coverImageData.dataUrl + '" alt="커버"></div>';
    }

    // 제목
    contentHtml += '<h1 class="preview-title">' + title + '</h1>';

    // 메타 정보
    contentHtml += '<div class="preview-meta">' +
        '<span><i class="bi bi-geo-alt"></i> ' + (selectedLocationName || '위치 미지정') + '</span>' +
        '<span><i class="bi bi-calendar3"></i> ' + document.getElementById('dateValue').textContent + '</span>' +
    '</div>';

    // 연결된 일정
    if (linkedSchedule) {
        contentHtml += '<div class="preview-schedule">' +
            '<i class="bi bi-calendar-check"></i> ' + linkedSchedule.title +
        '</div>';
    }

    // 블록 내용
    blocks.forEach(function(block) {
        if (block.classList.contains('text-block')) {
            const text = block.querySelector('textarea').value;
            if (text) {
                contentHtml += '<p class="preview-text">' + text.replace(/\n/g, '<br>') + '</p>';
            }
        } else if (block.classList.contains('image-block')) {
            const img = block.querySelector('img').src;
            const captionEl = block.querySelector('.image-caption');
            const caption = captionEl ? captionEl.value : '';
            contentHtml += '<figure class="preview-figure">' +
                '<img src="' + img + '" alt="">' +
                (caption ? '<figcaption>' + caption + '</figcaption>' : '') +
            '</figure>';
        } else if (block.classList.contains('divider-block')) {
            contentHtml += '<hr class="preview-divider">';
        } else if (block.classList.contains('day-header-block')) {
            const dayBadge = block.querySelector('.day-badge').textContent;
            const dayDate = block.querySelector('.day-date').textContent;
            contentHtml += '<div class="preview-day-header">' +
                '<span class="preview-day-badge">' + dayBadge + '</span>' +
                '<span class="preview-day-date">' + dayDate + '</span>' +
            '</div>';
        } else if (block.classList.contains('place-block')) {
            const placeImg = block.querySelector('.place-block-content img').src;
            const placeName = block.querySelector('.place-block-info h4').textContent;
            const placeAddress = block.querySelector('.place-block-info p').textContent;
            const placeTextEl = block.querySelector('.block-textarea');
            const placeText = placeTextEl ? placeTextEl.value : '';
            contentHtml += '<div class="preview-place">' +
                '<img src="' + placeImg + '" alt="' + placeName + '">' +
                '<div class="preview-place-info">' +
                    '<h4>' + placeName + '</h4>' +
                    '<p>' + placeAddress + '</p>' +
                '</div>' +
            '</div>';
            if (placeText) {
                contentHtml += '<p class="preview-text">' + placeText.replace(/\n/g, '<br>') + '</p>';
            }
        }
    });

    // 태그
    if (tags.length > 0) {
        contentHtml += '<div class="preview-tags">' + tags.map(function(t) { return '<span>#' + t + '</span>'; }).join(' ') + '</div>';
    }

    document.getElementById('previewContainer').innerHTML = contentHtml;
    previewModal.show();
}

// 폼 데이터 수집
function collectFormData() {
    const blocks = [];
    document.querySelectorAll('.editor-block').forEach(function(block) {
        const blockData = { id: block.dataset.blockId };

        if (block.classList.contains('text-block')) {
            blockData.type = 'text';
            blockData.content = block.querySelector('textarea').value;
        } else if (block.classList.contains('image-block')) {
            blockData.type = 'image';
            blockData.src = block.querySelector('img').src;
            const captionEl = block.querySelector('.image-caption');
            blockData.caption = captionEl ? captionEl.value : '';
        } else if (block.classList.contains('divider-block')) {
            blockData.type = 'divider';
        } else if (block.classList.contains('day-header-block')) {
            blockData.type = 'day-header';
            blockData.day = block.querySelector('.day-badge').textContent;
            blockData.date = block.querySelector('.day-date').textContent;
        } else if (block.classList.contains('place-block')) {
            blockData.type = 'place';
            blockData.name = block.querySelector('.place-block-info h4').textContent;
            blockData.address = block.querySelector('.place-block-info p').textContent;
            blockData.image = block.querySelector('.place-block-content img').src;
            const textareaEl = block.querySelector('.block-textarea');
            blockData.content = textareaEl ? textareaEl.value : '';
        }

        blocks.push(blockData);
    });

    return {
        title: document.getElementById('blogTitle').value,
        coverImage: coverImageData ? coverImageData.dataUrl : null,
        linkedSchedule: linkedSchedule,
        blocks: blocks,
        locationName: selectedLocationName,
        locationCode: selectedLocationCode,
        dateRange: document.getElementById('dateValue').textContent,
        tags: tags,
        visibility: document.getElementById('visibility').value,
        showOnMap: document.getElementById('showOnMap').checked,
        allowComments: document.getElementById('allowComments').checked
    };
}

// 플러스



// 뒤로가기
function goBack() {
	  const blogTitleEl = document.getElementById('blogTitle');
	  const textareaEl = document.querySelector('.editor-block textarea');

	  const hasContent =
	    (blogTitleEl && blogTitleEl.value.trim()) ||
	    coverImageData ||
	    document.querySelectorAll('.editor-block').length > 1 ||
	    (textareaEl && textareaEl.value.trim());

	  if (!hasContent) {
	    window.history.back();
	    return;
	  }

	  Swal.fire({
	    title: '페이지를 나가시겠어요?',
	    text: '작성 중인 내용은 저장되지 않습니다.',
	    icon: 'warning',
	    showCancelButton: true,
	    confirmButtonText: '나가기',
	    cancelButtonText: '취소',
	    reverseButtons: true,
	    confirmButtonColor: '#ef4444',   // 빨간색
	    cancelButtonColor: '#6b7280'
	  }).then((result) => {
	    if (result.isConfirmed) {
	      window.history.back();
	    }
	  });
	}



function getMainStoryText() {
	  // ✅ "여행 이야기를 작성하세요..."가 들어있는 첫 text-block textarea만 사용
	  const firstTextArea = document.querySelector('#blogEditor .text-block textarea');
	  return firstTextArea ? firstTextArea.value.trim() : '';
	}

	function formatDateToYMD(dateObj) {
	  if (!dateObj) return null;
	  const y = dateObj.getFullYear();
	  const m = String(dateObj.getMonth() + 1).padStart(2, '0');
	  const d = String(dateObj.getDate()).padStart(2, '0');
	  return y + '-' + m + '-' + d;
	}
	
	function toYmdString(v) {
		  if (!v) return '';
		  // 이미 YYYY-MM-DD면 그대로
		  const s = String(v);
		  if (/^\d{4}-\d{2}-\d{2}$/.test(s)) return s;
		  // ISO면 앞 10자리(YYYY-MM-DD)만
		  if (s.length >= 10 && /^\d{4}-\d{2}-\d{2}/.test(s)) return s.substring(0, 10);

		  // 혹시 Date 객체면 formatDateToYMD 사용
		  if (v instanceof Date && !isNaN(v.getTime())) return formatDateToYMD(v);

		  return s; // fallback
	}

	function isValidDate(d) {
		  return d instanceof Date && !isNaN(d.getTime());
	}

// 제출
function submitTravellog() {

	// fp에서 최신값 다시 동기화
  const fp = document.getElementById('travelDateRange')?._flatpickr;
  if (fp?.selectedDates?.length === 2) {
    travelStartDate = fp.selectedDates[0];
    travelEndDate = fp.selectedDates[1];
  }

  // ✅ Date 객체만 허용
  if (!isValidDate(travelStartDate) || !isValidDate(travelEndDate)) {
    showToast('여행 기간을 선택해주세요.', 'error');
    return;
  }

  // ✅ 제목(이미 있던 필수)
  const titleEl = document.getElementById('blogTitle');
  const title = titleEl.value.trim();
  if (!title) {
    showToast('여행 제목을 입력해주세요.', 'error');
    titleEl.focus();
    return;
  }

  // ✅ 커버 이미지 필수
  // 1) 직접 업로드한 파일이 있는지
  const coverInput = document.getElementById('coverImageInput');
  const hasCoverFile = coverInput?.files?.length > 0;

  // 2) 일정에서 자동 세팅된 coverImageData(이미지 URL)도 인정할지 여부
  //    -> "진짜 업로드만 허용"이면 hasCoverFile만 체크하면 됨
// ✅ 일정에서 자동세팅된 건 'attachPath or attachNo'가 있을 때만 인정
const hasAutoCover = !!(
  coverImageData &&
  (
    // 일정에서 자동 세팅
    (coverImageData.fromSchedule && (coverImageData.attachNo || coverImageData.attachPath)) ||
    // 수정 모드에서 기존 커버 유지
    (coverImageData.fromExisting && (coverImageData.attachNo || existingCoverAttachNo))
  )
);

//✅ 일정에서 자동세팅된 커버인지(attachPath/attachNo 있을 때)
const hasScheduleCover = !!(
  coverImageData &&
  coverImageData.fromSchedule &&
  (coverImageData.attachNo || coverImageData.attachPath)
);
  
if (!hasCoverFile && !hasAutoCover) {
  showToast('커버 이미지를 추가해주세요.', 'error');
  document.getElementById('coverPlaceholder')?.click();
  return;
}

  if (!selectedLocationCode) {
	  showToast('위치를 선택해주세요.', 'error');
	  toggleSettingInput('location');
	  document.getElementById('locationInput')?.focus();
	  return;
	}

  // ✅ 본문(원하면 유지)
  const mainContent = getMainStoryText();
  if (!mainContent) {
    showToast('여행 이야기를 입력해주세요.', 'error');
    const firstTextArea = document.querySelector('#blogEditor .text-block textarea');
    if (firstTextArea) firstTextArea.focus();
    return;
  }

	  const submitBtn = document.getElementById('submitBtn');
	  submitBtn.disabled = true;
	  submitBtn.textContent = '등록 중...';

	  const base = window.__CTX__;
	  
	  const req = {
		schdlNo: linkedSchedule ? linkedSchedule.schdlNo : null,                 // ✅ 일정 연결 지금 안함
	    rcdTitle: title,               // ✅ RCD_TITLE
	    rcdContent: mainContent,       // ✅ RCD_CONTENT (첫 텍스트만)
	    tripDaysCd: null,
	    locCd: selectedLocationCode, // ✅ REGION.RGN_NO를 문자열로 저장
	    
	    // ✅ 날짜는 YYYY-MM-DD 문자열로 보내기 (서버에서 DATE로 변환/매핑)
	    startDt: formatDateToYMD(travelStartDate),
	    endDt: formatDateToYMD(travelEndDate),

	    openScopeCd: document.getElementById('visibility').value === 'public' ? 'PUBLIC' : 'PRIVATE', // ✅ OPEN_SCOPE_CD
	    mapDispYn: document.getElementById('showOnMap').checked ? 'Y' : 'N',      // ✅ MAP_DISP_YN
	    replyEnblYn: document.getElementById('allowComments').checked ? 'Y' : 'N', // ✅ REPLY_ENBL_YN
	    // attachNo는 ✅ 서버가 coverFile 저장 후 생성해서 TRIP_RECORD.ATTACH_NO에 넣는 구조 권장
	    
	    tags: tags,
	    
	    coverAttachNo: (!hasCoverFile && hasScheduleCover && coverImageData.attachNo) ? Number(coverImageData.attachNo) : null
	  };

	  console.log('REQ JSON =>', req);
	  
	  const formData = new FormData();
	  
	  // 플러스
	  // blocks JSON 추가
	  const blocks = collectBlocksForSave();
	  
	  // ✅ 디버그/검증: 기존 이미지인데 attachNo가 없는 블록이 있으면 바로 알림
	  blocks.forEach((b, i) => {
	    if (b.type === 'image') {
	      const hasNew = (b.fileIdx != null);
	      const hasOld = (b.attachNo != null);
	      if (!hasNew && !hasOld) {
	        console.warn('[save:image] image block missing both fileIdx and attachNo', i, b);
	      }
	    }
	  });

	  
	  
	  formData.append("blocks", new Blob([JSON.stringify(blocks)], { type:"application/json" }));

	  // 본문 이미지 파일들 추가
	  bodyImageFiles.forEach(f => formData.append("bodyFiles", f));
	  //
	  
	  
	  // 1) JSON req
	  formData.append(
	    "req",
	    new Blob([JSON.stringify(req)], { type: "application/json" })
	  );

	  // 2) 커버 파일 1개
	  const coverFileInput = document.getElementById("coverImageInput");
	  if (coverFileInput && coverFileInput.files && coverFileInput.files.length > 0) {
	    formData.append("coverFile", coverFileInput.files[0]);
	  }

	  // ✅ 수정모드면 기존 커버 attachNo 유지(파일 업로드 안 할 때)
	  if (isEditMode && !hasCoverFile && existingCoverAttachNo) {
	    req.attachNo = Number(existingCoverAttachNo);
	  }

	  // (생성에서 일정커버 attachNo를 쓰고 싶다면 req.attachNo로 넣는 게 더 깔끔)
	  if (!hasCoverFile && hasScheduleCover && coverImageData.attachNo) {
	    req.attachNo = Number(coverImageData.attachNo);
	  }

	  // req 다시 append(수정된 attachNo 반영)
	  formData.set("req", new Blob([JSON.stringify(req)], { type:"application/json" }));

	  const url = isEditMode
	    ? (base + '/api/travel-log/records/' + encodeURIComponent(editingRcdNo))
	    : (base + '/api/travel-log/records');

	  const method = isEditMode ? 'PUT' : 'POST';

	  fetch(url, {
	    method,
	    body: formData,
	    credentials: 'include'
	  })
	    .then(res => {
	      if (!res.ok) return res.text().then(t => { throw new Error(t || (isEditMode ? '수정 실패' : '등록 실패')); });
	      return isEditMode ? Promise.resolve(editingRcdNo) : res.json();
	    })
	    .then(rcdNo => {
	      showToast(isEditMode ? '여행기록이 수정되었습니다!' : '여행기록이 등록되었습니다!', 'success');
	      window.location.href = base + '/community/travel-log/detail?rcdNo=' + rcdNo;
	    })
	    .catch(err => {
	      console.error(err);
	      showToast(isEditMode ? '여행기록 수정 중 오류가 발생했습니다.' : '여행기록 등록 중 오류가 발생했습니다.', 'error');
	    })
	    .finally(() => {
	      submitBtn.disabled = false;
	      submitBtn.textContent = isEditMode ? '수정' : '등록';
	    });
}

function initTravelDatePickerForce() {
	  const dateInput = document.getElementById('travelDateRange');
	  if (!dateInput || typeof flatpickr === 'undefined') return;

	  // 이미 걸려있는 flatpickr(공통 포함) 제거
	  if (dateInput._flatpickr) {
	    dateInput._flatpickr.destroy();
	  }

	  flatpickr(dateInput, {
	    locale: 'ko',
	    dateFormat: 'Y-m-d',
	    mode: 'range',
	    allowInput: true,

	    // ✅ 과거/미래 모두 허용
	    minDate: null,
	    maxDate: null,
	    disable: [],

	    onChange: function(selectedDates, dateStr) {
	      if (selectedDates.length === 2) {
	        travelStartDate = selectedDates[0];
	        travelEndDate = selectedDates[1];
	        document.getElementById('dateValue').textContent = dateStr;
	      } else {
	        travelStartDate = null;
	        travelEndDate = null;
	        document.getElementById('dateValue').textContent = '날짜를 선택하세요';
	      }
	    }
	  });
	}


async function loadScheduleFull(schdlNo) {
	  const frame = document.getElementById('scheduleLoader');
	  if (!frame) return;

	  const url = window.__CTX__ + '/schedule/view/' + schdlNo;
	  

	  frame.onload = function() {
	    try {
	      const data = frame.contentWindow && frame.contentWindow.__SCHEDULE__;
	      if (!data) {
	        showToast('일정 데이터를 불러오지 못했습니다.', 'error');
	        return;
	      }

	      applyScheduleToEditor(data);
	      showToast('일차별 일정이 불러와졌어요!', 'success');
	    } catch (e) {
	      console.error('[schedule apply error]', e);

	      // ✅ 에러 메시지 노출(원인 즉시 파악)
	      const msg = (e && (e.message || e.toString())) ? (e.message || e.toString()) : 'unknown error';
	      showToast('일정 적용 오류: ' + msg, 'error');
	    } finally {
	      frame.onload = null;
	    }
	  };

	  frame.src = url;
	}



</script>

<%@ include file="../common/footer.jsp" %>
