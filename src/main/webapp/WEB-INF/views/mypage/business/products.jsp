<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="내 상품 현황" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../../common/header.jsp" %>

<div class="mypage business-mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>내 상품 현황</h1>
                    <p>등록한 상품을 관리하세요</p>
                </div>

                <!-- 통계 카드 -->
                <div class="stats-grid">
                    <div class="stat-card primary">
                        <div class="stat-icon"><i class="bi bi-box-seam"></i></div>
                        <div class="stat-value">8</div>
                        <div class="stat-label">전체 상품</div>
                    </div>
                    <div class="stat-card secondary">
                        <div class="stat-icon"><i class="bi bi-check-circle"></i></div>
                        <div class="stat-value">6</div>
                        <div class="stat-label">판매중</div>
                    </div>
                    <div class="stat-card accent">
                        <div class="stat-icon"><i class="bi bi-pause-circle"></i></div>
                        <div class="stat-value">1</div>
                        <div class="stat-label">판매 중지</div>
                    </div>
                    <div class="stat-card warning clickable" onclick="openAllInquiries()">
                        <div class="stat-icon"><i class="bi bi-chat-dots"></i></div>
                        <div class="stat-value">5</div>
                        <div class="stat-label">미답변 문의</div>
                    </div>
                </div>

                <!-- 탭 & 버튼 -->
                <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                    <div class="mypage-tabs mb-0">
                        <button class="mypage-tab active" data-status="all">전체</button>
                        <button class="mypage-tab" data-status="active">판매중</button>
                        <button class="mypage-tab" data-status="inactive">판매 중지</button>
                        <button class="mypage-tab" data-status="pending">승인 대기</button>
                    </div>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#productModal" onclick="setModalForNew()">
                        <i class="bi bi-plus-lg me-2"></i>상품 등록
                    </button>
                </div>

                <!-- 상품 목록 -->
                <div class="content-section">
                    <!-- 선택 기능 영역 -->
                    <div class="product-selection-bar" id="productSelectionBar">
                        <div class="selection-left">
                            <label class="select-all-checkbox">
                                <input type="checkbox" id="selectAllProducts" onchange="toggleSelectAll(this)">
                                <span>전체 선택</span>
                            </label>
                            <span class="selected-count" id="selectedCount">0개 선택됨</span>
                        </div>
                        <div class="selection-actions" id="selectionActions">
                            <button class="btn btn-outline btn-sm" onclick="pauseSelectedProducts()" title="선택한 상품 판매 중지">
                                <i class="bi bi-pause-circle me-1"></i>선택중지
                            </button>
                            <button class="btn btn-outline btn-sm" onclick="resumeSelectedProducts()" title="선택한 상품 판매 재개">
                                <i class="bi bi-play-circle me-1"></i>선택재개
                            </button>
                            <button class="btn btn-outline btn-sm text-danger" onclick="deleteSelectedProducts()" title="선택한 상품 삭제">
                                <i class="bi bi-trash me-1"></i>선택삭제
                            </button>
                        </div>
                    </div>

                    <div class="product-manage-list">
                        <!-- 상품 1 -->
                        <div class="product-manage-item" data-status="active" data-id="1">
                            <label class="product-checkbox">
                                <input type="checkbox" class="product-select-checkbox" value="1" onchange="toggleProductSelect(this)">
                            </label>
                            <div class="product-manage-info">
                                <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=80&h=80&fit=crop&q=80" alt="상품">
                                <div class="product-manage-details">
                                    <h4>제주 스쿠버다이빙 체험</h4>
                                    <span class="category">액티비티</span>
                                    <div class="price">68,000원</div>
                                </div>
                            </div>
                            <div class="product-stats">
                                <div class="product-stat">
                                    <div class="value">1,234</div>
                                    <div class="label">조회</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">156</div>
                                    <div class="label">예약</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">4.9</div>
                                    <div class="label">평점</div>
                                </div>
                            </div>
                            <span class="product-status active">판매중</span>
                            <div class="product-actions">
                                <button class="btn btn-outline btn-sm inquiry-btn" onclick="openProductInquiries(1, '제주 스쿠버다이빙 체험')" title="문의 관리">
                                    <i class="bi bi-chat-dots"></i>
                                    <span class="inquiry-badge">3</span>
                                </button>
                                <button class="btn btn-outline btn-sm" onclick="editProduct(1)">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-outline btn-sm" onclick="toggleStatus(1)">
                                    <i class="bi bi-pause"></i>
                                </button>
                                <button class="btn btn-outline btn-sm text-danger" onclick="deleteProduct(1)">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>

                        <!-- 상품 2 -->
                        <div class="product-manage-item" data-status="active" data-id="2">
                            <label class="product-checkbox">
                                <input type="checkbox" class="product-select-checkbox" value="2" onchange="toggleProductSelect(this)">
                            </label>
                            <div class="product-manage-info">
                                <img src="https://images.unsplash.com/photo-1551632811-561732d1e306?w=80&h=80&fit=crop&q=80" alt="상품">
                                <div class="product-manage-details">
                                    <h4>한라산 트레킹 투어</h4>
                                    <span class="category">투어</span>
                                    <div class="price">85,000원</div>
                                </div>
                            </div>
                            <div class="product-stats">
                                <div class="product-stat">
                                    <div class="value">856</div>
                                    <div class="label">조회</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">89</div>
                                    <div class="label">예약</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">4.7</div>
                                    <div class="label">평점</div>
                                </div>
                            </div>
                            <span class="product-status active">판매중</span>
                            <div class="product-actions">
                                <button class="btn btn-outline btn-sm inquiry-btn" onclick="openProductInquiries(2, '한라산 트레킹 투어')" title="문의 관리">
                                    <i class="bi bi-chat-dots"></i>
                                    <span class="inquiry-badge">1</span>
                                </button>
                                <button class="btn btn-outline btn-sm" onclick="editProduct(2)">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-outline btn-sm" onclick="toggleStatus(2)">
                                    <i class="bi bi-pause"></i>
                                </button>
                                <button class="btn btn-outline btn-sm text-danger" onclick="deleteProduct(2)">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>

                        <!-- 상품 3 -->
                        <div class="product-manage-item" data-status="active" data-id="3">
                            <label class="product-checkbox">
                                <input type="checkbox" class="product-select-checkbox" value="3" onchange="toggleProductSelect(this)">
                            </label>
                            <div class="product-manage-info">
                                <img src="https://images.unsplash.com/photo-1502680390469-be75c86b636f?w=80&h=80&fit=crop&q=80" alt="상품">
                                <div class="product-manage-details">
                                    <h4>제주 서핑 레슨</h4>
                                    <span class="category">클래스/체험</span>
                                    <div class="price">65,000원</div>
                                </div>
                            </div>
                            <div class="product-stats">
                                <div class="product-stat">
                                    <div class="value">567</div>
                                    <div class="label">조회</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">45</div>
                                    <div class="label">예약</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">4.8</div>
                                    <div class="label">평점</div>
                                </div>
                            </div>
                            <span class="product-status active">판매중</span>
                            <div class="product-actions">
                                <button class="btn btn-outline btn-sm inquiry-btn" onclick="openProductInquiries(3, '제주 서핑 레슨')" title="문의 관리">
                                    <i class="bi bi-chat-dots"></i>
                                    <span class="inquiry-badge">1</span>
                                </button>
                                <button class="btn btn-outline btn-sm" onclick="editProduct(3)">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-outline btn-sm" onclick="toggleStatus(3)">
                                    <i class="bi bi-pause"></i>
                                </button>
                                <button class="btn btn-outline btn-sm text-danger" onclick="deleteProduct(3)">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>

                        <!-- 상품 4 - 판매 중지 -->
                        <div class="product-manage-item" data-status="inactive" data-id="4">
                            <label class="product-checkbox">
                                <input type="checkbox" class="product-select-checkbox" value="4" onchange="toggleProductSelect(this)">
                            </label>
                            <div class="product-manage-info">
                                <img src="https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=80&h=80&fit=crop&q=80" alt="상품">
                                <div class="product-manage-details">
                                    <h4>우도 자전거 투어</h4>
                                    <span class="category">액티비티</span>
                                    <div class="price">45,000원</div>
                                </div>
                            </div>
                            <div class="product-stats">
                                <div class="product-stat">
                                    <div class="value">234</div>
                                    <div class="label">조회</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">23</div>
                                    <div class="label">예약</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">4.5</div>
                                    <div class="label">평점</div>
                                </div>
                            </div>
                            <span class="product-status inactive">판매중지</span>
                            <div class="product-actions">
                                <button class="btn btn-outline btn-sm" onclick="editProduct(4)">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-outline btn-sm" onclick="toggleStatus(4)">
                                    <i class="bi bi-play"></i>
                                </button>
                                <button class="btn btn-outline btn-sm text-danger" onclick="deleteProduct(4)">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>

                        <!-- 상품 5 - 승인 대기 -->
                        <div class="product-manage-item" data-status="pending" data-id="5">
                            <label class="product-checkbox">
                                <input type="checkbox" class="product-select-checkbox" value="5" onchange="toggleProductSelect(this)">
                            </label>
                            <div class="product-manage-info">
                                <img src="https://images.unsplash.com/photo-1544551763-77ef2d0cfc6c?w=80&h=80&fit=crop&q=80" alt="상품">
                                <div class="product-manage-details">
                                    <h4>제주 요트 투어</h4>
                                    <span class="category">투어</span>
                                    <div class="price">120,000원</div>
                                </div>
                            </div>
                            <div class="product-stats">
                                <div class="product-stat">
                                    <div class="value">-</div>
                                    <div class="label">조회</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">-</div>
                                    <div class="label">예약</div>
                                </div>
                                <div class="product-stat">
                                    <div class="value">-</div>
                                    <div class="label">평점</div>
                                </div>
                            </div>
                            <span class="product-status pending">승인대기</span>
                            <div class="product-actions">
                                <button class="btn btn-outline btn-sm" onclick="editProduct(5)">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-outline btn-sm text-danger" onclick="deleteProduct(5)">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
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

<!-- 상품 등록/수정 모달 -->
<div class="modal fade" id="productModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="productModalTitle">새 상품 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="productForm">
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label">카테고리 <span class="text-danger">*</span></label>
                            <select class="form-select" name="category" id="productCategory" required onchange="toggleCategoryFields()">
                                <option value="">선택하세요</option>
                                <option value="tour">투어</option>
                                <option value="activity">액티비티</option>
                                <option value="ticket">입장권/티켓</option>
                                <option value="class">클래스/체험</option>
                                <option value="transfer">교통/이동</option>
                                <option value="flight">항공</option>
                                <option value="accommodation">숙박</option>
                            </select>
                        </div>
                        <div class="col-md-4" id="regionField">
                            <label class="form-label">지역 <span class="text-danger">*</span></label>
                            <select class="form-select" name="region">
                                <option value="">선택하세요</option>
                                <optgroup label="수도권">
                                    <option value="seoul">서울</option>
                                    <option value="gyeonggi">경기</option>
                                    <option value="incheon">인천</option>
                                </optgroup>
                                <optgroup label="강원권">
                                    <option value="gangwon">강원</option>
                                </optgroup>
                                <optgroup label="충청권">
                                    <option value="daejeon">대전</option>
                                    <option value="sejong">세종</option>
                                    <option value="chungbuk">충북</option>
                                    <option value="chungnam">충남</option>
                                </optgroup>
                                <optgroup label="전라권">
                                    <option value="gwangju">광주</option>
                                    <option value="jeonbuk">전북</option>
                                    <option value="jeonnam">전남</option>
                                </optgroup>
                                <optgroup label="경상권">
                                    <option value="busan">부산</option>
                                    <option value="daegu">대구</option>
                                    <option value="ulsan">울산</option>
                                    <option value="gyeongbuk">경북</option>
                                    <option value="gyeongnam">경남</option>
                                </optgroup>
                                <optgroup label="제주권">
                                    <option value="jeju">제주</option>
                                </optgroup>
                            </select>
                        </div>
                        <div class="col-md-4" id="durationField">
                            <label class="form-label">소요시간 <span class="text-danger">*</span></label>
                            <select class="form-select" name="duration">
                                <option value="">선택하세요</option>
                                <option value="1">1시간 이내</option>
                                <option value="3">1~3시간</option>
                                <option value="6">3~6시간</option>
                                <option value="day">하루 이상</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3" id="productNameField">
                        <label class="form-label">상품명 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="productName" placeholder="상품명을 입력하세요" required>
                    </div>
                    <div class="mb-3" id="locationField">
                        <label class="form-label">위치 정보 <span class="text-danger">*</span></label>
                        <div class="row g-2">
                            <div class="col-md-10">
                                <input type="text" class="form-control" name="address" id="productAddress" placeholder="주소를 검색하세요" required readonly>
                            </div>
                            <div class="col-md-2">
                                <button type="button" class="btn btn-outline w-100" onclick="searchAddress()">
                                    <i class="bi bi-search"></i> 검색
                                </button>
                            </div>
                        </div>
                        <input type="text" class="form-control mt-2" name="addressDetail" placeholder="상세주소 (건물명, 층, 호수 등)">
                        <input type="hidden" name="latitude" id="productLatitude">
                        <input type="hidden" name="longitude" id="productLongitude">
                    </div>
                    <div class="mb-3" id="descriptionField">
                        <label class="form-label">상품 설명 <span class="text-danger">*</span></label>
                        <textarea class="form-control" name="description" rows="4" placeholder="상품에 대한 상세 설명을 입력하세요"></textarea>
                    </div>

                    <!-- 이용 안내 섹션 (기본 상품용) -->
                    <div id="defaultInfoSection">
                    <div class="form-section-title">
                        <i class="bi bi-info-circle me-2"></i>이용 안내
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label">운영 시간 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="operatingHours" placeholder="예: 09:00 ~ 18:00" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">소요 시간 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="durationText" placeholder="예: 약 2시간 (실제 체험 40분)" required>
                            <div class="form-text">고객에게 보여질 상세 소요시간을 입력하세요</div>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">연령 제한</label>
                            <input type="text" class="form-control" name="ageLimit" placeholder="예: 만 10세 이상">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label">최소 인원</label>
                            <input type="number" class="form-control" name="minPeople" placeholder="1" min="1" value="1">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">최대 인원</label>
                            <input type="number" class="form-control" name="maxPeople" placeholder="10" min="1">
                        </div>
                    </div>

                    <!-- 예약 가능 시간 설정 -->
                    <div class="mb-3">
                        <label class="form-label">예약 가능 시간 <span class="text-danger">*</span></label>
                        <div class="form-text mb-2">고객이 선택할 수 있는 예약 시간대를 설정하세요</div>
                        <div class="booking-times-container" id="bookingTimesContainer">
                            <div class="booking-time-list" id="bookingTimeList">
                                <!-- 동적으로 시간 슬롯 추가 -->
                            </div>
                            <div class="booking-time-add">
                                <div class="input-group">
                                    <input type="time" class="form-control" id="newBookingTime">
                                    <button type="button" class="btn btn-outline" onclick="addBookingTime()">
                                        <i class="bi bi-plus-lg"></i> 시간 추가
                                    </button>
                                </div>
                            </div>
                            <div class="booking-time-presets mt-2">
                                <span class="text-muted small me-2">빠른 추가:</span>
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="addPresetTimes('morning')">오전 타임</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="addPresetTimes('afternoon')">오후 타임</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="addPresetTimes('hourly')">1시간 단위</button>
                            </div>
                        </div>
                        <input type="hidden" name="bookingTimes" id="bookingTimesInput">
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">포함 사항</label>
                            <textarea class="form-control" name="includes" rows="3" placeholder="포함되는 항목을 줄바꿈으로 구분하여 입력하세요&#10;예:&#10;전문 강사 1:1 지도&#10;장비 대여&#10;수중 사진 촬영"></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">불포함 사항</label>
                            <textarea class="form-control" name="excludes" rows="3" placeholder="포함되지 않는 항목을 줄바꿈으로 구분하여 입력하세요&#10;예:&#10;픽업/샌딩 서비스&#10;개인 물품"></textarea>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">유의 사항</label>
                        <textarea class="form-control" name="notice" rows="3" placeholder="예약 및 이용 시 유의해야 할 사항을 입력하세요"></textarea>
                    </div>
                    </div><!-- /defaultInfoSection -->

                    <!-- 항공 전용 필드 -->
                    <div id="flightFields" style="display: none;">
                        <div class="form-section-title">
                            <i class="bi bi-airplane me-2"></i>항공편 정보
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">항공사 <span class="text-danger">*</span></label>
                                <select class="form-select" name="airline">
                                    <option value="">선택하세요</option>
                                    <option value="korean_air">대한항공</option>
                                    <option value="asiana">아시아나항공</option>
                                    <option value="jeju_air">제주항공</option>
                                    <option value="jinair">진에어</option>
                                    <option value="tway">티웨이항공</option>
                                    <option value="airbusan">에어부산</option>
                                    <option value="airseoul">에어서울</option>
                                    <option value="eastarjet">이스타항공</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">항공편명 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="flightNumber" placeholder="예: KE1234">
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">출발지 <span class="text-danger">*</span></label>
                                <select class="form-select" name="departureAirport">
                                    <option value="">선택하세요</option>
                                    <option value="ICN">인천국제공항 (ICN)</option>
                                    <option value="GMP">김포국제공항 (GMP)</option>
                                    <option value="PUS">김해국제공항 (PUS)</option>
                                    <option value="CJU">제주국제공항 (CJU)</option>
                                    <option value="TAE">대구국제공항 (TAE)</option>
                                    <option value="CJJ">청주국제공항 (CJJ)</option>
                                    <option value="KWJ">광주공항 (KWJ)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">도착지 <span class="text-danger">*</span></label>
                                <select class="form-select" name="arrivalAirport">
                                    <option value="">선택하세요</option>
                                    <option value="ICN">인천국제공항 (ICN)</option>
                                    <option value="GMP">김포국제공항 (GMP)</option>
                                    <option value="PUS">김해국제공항 (PUS)</option>
                                    <option value="CJU">제주국제공항 (CJU)</option>
                                    <option value="TAE">대구국제공항 (TAE)</option>
                                    <option value="CJJ">청주국제공항 (CJJ)</option>
                                    <option value="KWJ">광주공항 (KWJ)</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">출발 시간 <span class="text-danger">*</span></label>
                                <input type="time" class="form-control" name="departureTime">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">도착 시간 <span class="text-danger">*</span></label>
                                <input type="time" class="form-control" name="arrivalTime">
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">기종</label>
                                <input type="text" class="form-control" name="aircraftType" placeholder="예: Boeing 737-800">
                            </div>
                        </div>

                        <div class="form-section-title">
                            <i class="bi bi-ticket-perforated me-2"></i>좌석 등급별 가격
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label class="form-label">이코노미 가격 <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="number" class="form-control" name="economyPrice" placeholder="0">
                                    <span class="input-group-text">원</span>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">비즈니스 가격</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" name="businessPrice" placeholder="0">
                                    <span class="input-group-text">원</span>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">퍼스트 가격</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" name="firstClassPrice" placeholder="0">
                                    <span class="input-group-text">원</span>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label class="form-label">이코노미 잔여석</label>
                                <input type="number" class="form-control" name="economySeats" placeholder="0" min="0">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">비즈니스 잔여석</label>
                                <input type="number" class="form-control" name="businessSeats" placeholder="0" min="0">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">퍼스트 잔여석</label>
                                <input type="number" class="form-control" name="firstClassSeats" placeholder="0" min="0">
                            </div>
                        </div>

                        <div class="form-section-title">
                            <i class="bi bi-bag me-2"></i>수하물 정보
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">무료 위탁 수하물</label>
                                <input type="text" class="form-control" name="checkedBaggage" placeholder="예: 23kg x 1개">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">기내 수하물</label>
                                <input type="text" class="form-control" name="cabinBaggage" placeholder="예: 10kg x 1개">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">기내 서비스</label>
                            <div class="form-check-group">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="flightServices" value="meal" id="serviceMeal">
                                    <label class="form-check-label" for="serviceMeal">기내식</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="flightServices" value="entertainment" id="serviceEntertainment">
                                    <label class="form-check-label" for="serviceEntertainment">엔터테인먼트</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="flightServices" value="wifi" id="serviceWifi">
                                    <label class="form-check-label" for="serviceWifi">기내 WiFi</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" name="flightServices" value="usb" id="serviceUsb">
                                    <label class="form-check-label" for="serviceUsb">USB 충전</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 숙박 전용 필드 -->
                    <div id="accommodationFields" style="display: none;">
                        <div class="form-section-title">
                            <i class="bi bi-building me-2"></i>숙소 정보
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label class="form-label">숙소 유형 <span class="text-danger">*</span></label>
                                <select class="form-select" name="accommodationType">
                                    <option value="">선택하세요</option>
                                    <option value="hotel">호텔</option>
                                    <option value="resort">리조트</option>
                                    <option value="pension">펜션</option>
                                    <option value="motel">모텔</option>
                                    <option value="guesthouse">게스트하우스</option>
                                    <option value="hanok">한옥</option>
                                    <option value="condo">콘도</option>
                                    <option value="camping">캠핑/글램핑</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">등급</label>
                                <select class="form-select" name="starRating">
                                    <option value="">선택하세요</option>
                                    <option value="5">5성급</option>
                                    <option value="4">4성급</option>
                                    <option value="3">3성급</option>
                                    <option value="2">2성급</option>
                                    <option value="1">1성급</option>
                                    <option value="0">무등급</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">총 객실 수</label>
                                <input type="number" class="form-control" name="totalRooms" placeholder="0" min="1">
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">체크인 시간 <span class="text-danger">*</span></label>
                                <input type="time" class="form-control" name="checkInTime" value="15:00">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">체크아웃 시간 <span class="text-danger">*</span></label>
                                <input type="time" class="form-control" name="checkOutTime" value="11:00">
                            </div>
                        </div>

                        <div class="form-section-title">
                            <i class="bi bi-door-open me-2"></i>객실 정보
                        </div>
                        <div class="room-type-container" id="roomTypeContainer">
                            <div class="room-type-item" data-room-index="0">
                                <div class="room-type-header">
                                    <h6><i class="bi bi-door-closed me-2"></i>객실 타입 1</h6>
                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeRoomType(0)" style="display: none;">
                                        <i class="bi bi-x"></i>
                                    </button>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="form-label">객실명 <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="roomName_0" placeholder="예: 스탠다드 더블">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">기준 인원 <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" name="roomCapacity_0" placeholder="2" min="1">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">최대 인원</label>
                                        <input type="number" class="form-control" name="roomMaxCapacity_0" placeholder="4" min="1">
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-3">
                                        <label class="form-label">1박 가격 <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" name="roomPrice_0" placeholder="0">
                                            <span class="input-group-text">원</span>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label">할인율</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" name="roomDiscount_0" placeholder="0" min="0" max="100">
                                            <span class="input-group-text">%</span>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label">잔여 객실 <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" name="roomStock_0" placeholder="0" min="0">
                                            <span class="input-group-text">실</span>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label">객실 크기</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" name="roomSize_0" placeholder="0">
                                            <span class="input-group-text">㎡</span>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">조식 포함</label>
                                        <select class="form-select" name="roomBreakfast_0">
                                            <option value="none">조식 미포함</option>
                                            <option value="included">조식 포함</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">침대 타입</label>
                                    <div class="form-check-group">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="bedType_0" value="single" id="bedSingle_0">
                                            <label class="form-check-label" for="bedSingle_0">싱글</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="bedType_0" value="double" id="bedDouble_0">
                                            <label class="form-check-label" for="bedDouble_0">더블</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="bedType_0" value="queen" id="bedQueen_0">
                                            <label class="form-check-label" for="bedQueen_0">퀸</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="bedType_0" value="king" id="bedKing_0">
                                            <label class="form-check-label" for="bedKing_0">킹</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="bedType_0" value="ondol" id="bedOndol_0">
                                            <label class="form-check-label" for="bedOndol_0">온돌</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">객실 특징</label>
                                    <div class="room-features-grid">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="roomFeature_0" value="free_cancel" id="featureFreeCancel_0">
                                            <label class="form-check-label" for="featureFreeCancel_0"><i class="bi bi-check-circle me-1"></i>무료 취소</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="roomFeature_0" value="ocean_view" id="featureOceanView_0">
                                            <label class="form-check-label" for="featureOceanView_0"><i class="bi bi-water me-1"></i>오션뷰</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="roomFeature_0" value="mountain_view" id="featureMountainView_0">
                                            <label class="form-check-label" for="featureMountainView_0"><i class="bi bi-mountain me-1"></i>마운틴뷰</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="roomFeature_0" value="city_view" id="featureCityView_0">
                                            <label class="form-check-label" for="featureCityView_0"><i class="bi bi-buildings me-1"></i>시티뷰</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="roomFeature_0" value="living_room" id="featureLivingRoom_0">
                                            <label class="form-check-label" for="featureLivingRoom_0"><i class="bi bi-door-open me-1"></i>거실 포함</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="roomFeature_0" value="balcony" id="featureBalcony_0">
                                            <label class="form-check-label" for="featureBalcony_0"><i class="bi bi-flower1 me-1"></i>발코니/테라스</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="roomFeature_0" value="no_smoking" id="featureNoSmoking_0">
                                            <label class="form-check-label" for="featureNoSmoking_0"><i class="bi bi-slash-circle me-1"></i>금연</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="roomFeature_0" value="kitchen" id="featureKitchen_0">
                                            <label class="form-check-label" for="featureKitchen_0"><i class="bi bi-cup-hot me-1"></i>주방/취사</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn btn-outline w-100 mb-3" onclick="addRoomType()">
                            <i class="bi bi-plus-lg me-2"></i>객실 타입 추가
                        </button>

                        <div class="form-section-title">
                            <i class="bi bi-stars me-2"></i>편의시설 및 서비스
                        </div>
                        <div class="mb-3">
                            <label class="form-label">숙소 편의시설</label>
                            <div class="amenities-grid">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="wifi" id="amenityWifi">
                                    <label class="form-check-label" for="amenityWifi"><i class="bi bi-wifi me-1"></i>무료 WiFi</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="parking" id="amenityParking">
                                    <label class="form-check-label" for="amenityParking"><i class="bi bi-p-circle me-1"></i>주차장</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="breakfast" id="amenityBreakfast">
                                    <label class="form-check-label" for="amenityBreakfast"><i class="bi bi-cup-hot me-1"></i>조식</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="pool" id="amenityPool">
                                    <label class="form-check-label" for="amenityPool"><i class="bi bi-water me-1"></i>수영장</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="fitness" id="amenityFitness">
                                    <label class="form-check-label" for="amenityFitness"><i class="bi bi-heart-pulse me-1"></i>피트니스</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="spa" id="amenitySpa">
                                    <label class="form-check-label" for="amenitySpa"><i class="bi bi-droplet me-1"></i>스파/사우나</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="restaurant" id="amenityRestaurant">
                                    <label class="form-check-label" for="amenityRestaurant"><i class="bi bi-shop me-1"></i>레스토랑</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="bar" id="amenityBar">
                                    <label class="form-check-label" for="amenityBar"><i class="bi bi-cup-straw me-1"></i>바/라운지</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="roomService" id="amenityRoomService">
                                    <label class="form-check-label" for="amenityRoomService"><i class="bi bi-bell me-1"></i>룸서비스</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="laundry" id="amenityLaundry">
                                    <label class="form-check-label" for="amenityLaundry"><i class="bi bi-basket me-1"></i>세탁 서비스</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="smoking" id="amenitySmoking">
                                    <label class="form-check-label" for="amenitySmoking"><i class="bi bi-cloud me-1"></i>흡연구역</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="amenities" value="petFriendly" id="amenityPet">
                                    <label class="form-check-label" for="amenityPet"><i class="bi bi-emoji-heart-eyes me-1"></i>반려동물 동반</label>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">객실 내 시설</label>
                            <div class="amenities-grid">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="roomAmenities" value="aircon" id="roomAircon">
                                    <label class="form-check-label" for="roomAircon"><i class="bi bi-snow me-1"></i>에어컨</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="roomAmenities" value="tv" id="roomTv">
                                    <label class="form-check-label" for="roomTv"><i class="bi bi-tv me-1"></i>TV</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="roomAmenities" value="minibar" id="roomMinibar">
                                    <label class="form-check-label" for="roomMinibar"><i class="bi bi-box me-1"></i>미니바</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="roomAmenities" value="refrigerator" id="roomRefrigerator">
                                    <label class="form-check-label" for="roomRefrigerator"><i class="bi bi-box-seam me-1"></i>냉장고</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="roomAmenities" value="safe" id="roomSafe">
                                    <label class="form-check-label" for="roomSafe"><i class="bi bi-safe me-1"></i>금고</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="roomAmenities" value="hairdryer" id="roomHairdryer">
                                    <label class="form-check-label" for="roomHairdryer"><i class="bi bi-wind me-1"></i>헤어드라이어</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="roomAmenities" value="bathtub" id="roomBathtub">
                                    <label class="form-check-label" for="roomBathtub"><i class="bi bi-droplet-half me-1"></i>욕조</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="roomAmenities" value="toiletries" id="roomToiletries">
                                    <label class="form-check-label" for="roomToiletries"><i class="bi bi-box2 me-1"></i>세면도구</label>
                                </div>
                            </div>
                        </div>

                        <div class="form-section-title">
                            <i class="bi bi-plus-circle me-2"></i>추가 옵션 (선택사항)
                        </div>
                        <div class="addon-options-container" id="addonOptionsContainer">
                            <div class="addon-option-item" data-addon-index="0">
                                <div class="row">
                                    <div class="col-md-5">
                                        <label class="form-label">옵션명</label>
                                        <input type="text" class="form-control" name="addonName_0" placeholder="예: 조식 뷔페">
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label">인원</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" name="addonPerson_0" placeholder="0" min="0" value="0">
                                            <span class="input-group-text">명</span>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">가격</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" name="addonPrice_0" placeholder="0">
                                            <span class="input-group-text">원</span>
                                        </div>
                                    </div>
                                    <div class="col-md-2 d-flex align-items-end">
                                        <button type="button" class="btn btn-outline-danger w-100" onclick="removeAddonOption(0)" style="display: none;">
                                            <i class="bi bi-x"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn btn-outline w-100 mb-3" onclick="addAddonOption()">
                            <i class="bi bi-plus-lg me-2"></i>추가 옵션 추가
                        </button>
                    </div>

                    <!-- 가격 정보 섹션 (기본 상품용) -->
                    <div id="defaultPriceSection">
                    <div class="form-section-title">
                        <i class="bi bi-currency-dollar me-2"></i>가격 및 재고 정보
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label class="form-label">정가</label>
                            <input type="number" class="form-control" name="originalPrice" placeholder="0">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">판매가 <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="salePrice" placeholder="0" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">할인율</label>
                            <div class="input-group">
                                <input type="number" class="form-control" name="discountRate" placeholder="0" max="100">
                                <span class="input-group-text">%</span>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">재고 수량 <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <input type="number" class="form-control" name="stock" placeholder="0" min="0" required>
                                <span class="input-group-text">개</span>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">판매 시작일 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control date-picker" name="startDate" placeholder="시작일 선택" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">판매 종료일 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control date-picker" name="endDate" placeholder="종료일 선택" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">상품 이미지</label>
                        <input type="file" class="form-control" name="productImage" accept="image/*">
                        <div class="form-text">권장 크기: 800x600px, 최대 5MB</div>
                    </div>
                    </div><!-- /defaultPriceSection -->

                    <!-- 공통 판매 기간 (항공/숙박용) -->
                    <div id="flightAccomDateSection" style="display: none;">
                        <div class="form-section-title">
                            <i class="bi bi-calendar-range me-2"></i>판매 기간
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">판매 시작일 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control date-picker" name="flightStartDate" placeholder="시작일 선택">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">판매 종료일 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control date-picker" name="flightEndDate" placeholder="종료일 선택">
                            </div>
                        </div>
                        <div class="mb-3" id="flightAccomImageField">
                            <label class="form-label">상품 이미지</label>
                            <input type="file" class="form-control" name="productImageAlt" accept="image/*" multiple>
                            <div class="form-text">숙소 대표 이미지를 등록하세요 (최대 5장)</div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="saveProduct()">저장</button>
            </div>
        </div>
    </div>
</div>

<!-- 고객 문의 관리 모달 -->
<div class="modal fade" id="inquiryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-chat-dots me-2"></i>
                    <span id="inquiryModalTitle">고객 문의 관리</span>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- 필터 탭 -->
                <div class="inquiry-modal-tabs">
                    <button class="inquiry-tab active" data-filter="all">전체 <span class="count">(5)</span></button>
                    <button class="inquiry-tab" data-filter="waiting">미답변 <span class="count waiting-count">(3)</span></button>
                    <button class="inquiry-tab" data-filter="answered">답변완료 <span class="count">(2)</span></button>
                </div>

                <!-- 문의 목록 -->
                <div class="inquiry-modal-list" id="inquiryModalList">
                    <!-- 문의 1 - 미답변 -->
                    <div class="inquiry-modal-item" data-status="waiting" data-id="1">
                        <div class="inquiry-modal-header">
                            <div class="inquiry-modal-info">
                                <span class="inquiry-type-badge product">상품 문의</span>
                                <span class="inquiry-author">travel_**</span>
                                <span class="inquiry-date">2024.03.18</span>
                            </div>
                            <span class="inquiry-status waiting">미답변</span>
                        </div>
                        <div class="inquiry-modal-question">
                            <p><strong>Q.</strong> 4명이 같이 가면 단체 할인이 있나요?</p>
                        </div>
                        <div class="inquiry-modal-reply">
                            <textarea class="form-control" placeholder="답변을 입력하세요..." rows="3"></textarea>
                            <div class="reply-actions">
                                <button class="btn btn-primary btn-sm" onclick="submitModalReply(1)">
                                    <i class="bi bi-send me-1"></i>답변 등록
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 문의 2 - 미답변 -->
                    <div class="inquiry-modal-item" data-status="waiting" data-id="2">
                        <div class="inquiry-modal-header">
                            <div class="inquiry-modal-info">
                                <span class="inquiry-type-badge booking">예약/일정</span>
                                <span class="inquiry-author">summer_**</span>
                                <span class="inquiry-date">2024.03.17</span>
                            </div>
                            <span class="inquiry-status waiting">미답변</span>
                        </div>
                        <div class="inquiry-modal-question">
                            <p><strong>Q.</strong> 우천 시에도 체험이 가능한가요? 비가 오면 취소해야 하나요?</p>
                        </div>
                        <div class="inquiry-modal-reply">
                            <textarea class="form-control" placeholder="답변을 입력하세요..." rows="3"></textarea>
                            <div class="reply-actions">
                                <button class="btn btn-primary btn-sm" onclick="submitModalReply(2)">
                                    <i class="bi bi-send me-1"></i>답변 등록
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 문의 3 - 미답변 -->
                    <div class="inquiry-modal-item" data-status="waiting" data-id="3">
                        <div class="inquiry-modal-header">
                            <div class="inquiry-modal-info">
                                <span class="inquiry-type-badge price">가격/결제</span>
                                <span class="inquiry-author">jeju_lo**</span>
                                <span class="inquiry-date">2024.03.16</span>
                            </div>
                            <span class="inquiry-status waiting">미답변</span>
                        </div>
                        <div class="inquiry-modal-question">
                            <p><strong>Q.</strong> 현장에서 카드 결제 가능한가요?</p>
                        </div>
                        <div class="inquiry-modal-reply">
                            <textarea class="form-control" placeholder="답변을 입력하세요..." rows="3"></textarea>
                            <div class="reply-actions">
                                <button class="btn btn-primary btn-sm" onclick="submitModalReply(3)">
                                    <i class="bi bi-send me-1"></i>답변 등록
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 문의 4 - 답변완료 -->
                    <div class="inquiry-modal-item" data-status="answered" data-id="4">
                        <div class="inquiry-modal-header">
                            <div class="inquiry-modal-info">
                                <span class="inquiry-type-badge product">상품 문의</span>
                                <span class="inquiry-author">happy_d**</span>
                                <span class="inquiry-date">2024.03.15</span>
                            </div>
                            <span class="inquiry-status answered">답변완료</span>
                        </div>
                        <div class="inquiry-modal-question">
                            <p><strong>Q.</strong> 수영을 전혀 못해도 체험이 가능한가요?</p>
                        </div>
                        <div class="inquiry-modal-answer">
                            <div class="answer-header">
                                <span><i class="bi bi-building"></i> 내 답변</span>
                                <div class="answer-actions">
                                    <span class="answer-date">2024.03.15</span>
                                    <button type="button" class="btn-edit-answer" onclick="editAnswer(4)" title="답변 수정">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button type="button" class="btn-delete-answer" onclick="deleteAnswer(4)" title="답변 삭제">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="answer-content">
                                <p><strong>A.</strong> <span class="answer-text">안녕하세요! 수영을 못하셔도 전혀 문제없습니다. 전문 강사가 1:1로 안전하게 안내해드립니다.</span></p>
                            </div>
                        </div>
                    </div>

                    <!-- 문의 5 - 답변완료 -->
                    <div class="inquiry-modal-item" data-status="answered" data-id="5">
                        <div class="inquiry-modal-header">
                            <div class="inquiry-modal-info">
                                <span class="inquiry-type-badge booking">예약/일정</span>
                                <span class="inquiry-author">ocean_l**</span>
                                <span class="inquiry-date">2024.03.12</span>
                            </div>
                            <span class="inquiry-status answered">답변완료</span>
                        </div>
                        <div class="inquiry-modal-question">
                            <p><strong>Q.</strong> 당일 예약도 가능한가요?</p>
                        </div>
                        <div class="inquiry-modal-answer">
                            <div class="answer-header">
                                <span><i class="bi bi-building"></i> 내 답변</span>
                                <div class="answer-actions">
                                    <span class="answer-date">2024.03.12</span>
                                    <button type="button" class="btn-edit-answer" onclick="editAnswer(5)" title="답변 수정">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button type="button" class="btn-delete-answer" onclick="deleteAnswer(5)" title="답변 삭제">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="answer-content">
                                <p><strong>A.</strong> <span class="answer-text">네, 당일 예약도 가능합니다! 다만 예약 상황에 따라 원하시는 시간대가 마감될 수 있으니, 가능하면 하루 전 예약을 권장드립니다.</span></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<style>
/* 선택 기능 바 */
.product-selection-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 20px;
    background: #f8fafc;
    border-radius: 12px;
    margin-bottom: 16px;
    flex-wrap: wrap;
    gap: 12px;
}

.selection-left {
    display: flex;
    align-items: center;
    gap: 16px;
}

.select-all-checkbox {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    font-size: 14px;
    font-weight: 500;
    color: #475569;
}

.select-all-checkbox input[type="checkbox"] {
    width: 18px;
    height: 18px;
    accent-color: var(--primary-color);
    cursor: pointer;
}

.selected-count {
    font-size: 13px;
    color: var(--primary-color);
    font-weight: 600;
    padding: 4px 12px;
    background: rgba(14, 165, 233, 0.1);
    border-radius: 20px;
}

.selection-actions {
    display: flex;
    gap: 8px;
    opacity: 0.5;
    pointer-events: none;
    transition: opacity 0.2s;
}

.selection-actions.active {
    opacity: 1;
    pointer-events: auto;
}

/* 상품 체크박스 */
.product-checkbox {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 12px;
    cursor: pointer;
}

.product-checkbox input[type="checkbox"] {
    width: 20px;
    height: 20px;
    accent-color: var(--primary-color);
    cursor: pointer;
}

.product-manage-item.selected {
    background: rgba(14, 165, 233, 0.05);
    border-color: var(--primary-color);
}

/* 클릭 가능한 통계 카드 */
.stat-card.clickable {
    cursor: pointer;
    transition: transform 0.2s, box-shadow 0.2s;
}
.stat-card.clickable:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(0,0,0,0.15);
}

/* 문의 버튼 배지 */
.inquiry-btn {
    position: relative;
}
.inquiry-badge {
    position: absolute;
    top: -6px;
    right: -6px;
    background: #ef4444;
    color: white;
    font-size: 10px;
    font-weight: 600;
    padding: 2px 6px;
    border-radius: 10px;
    min-width: 18px;
    text-align: center;
}
.inquiry-badge:empty {
    display: none;
}

/* 문의 모달 탭 */
.inquiry-modal-tabs {
    display: flex;
    gap: 8px;
    margin-bottom: 20px;
    padding-bottom: 16px;
    border-bottom: 1px solid #eee;
}
.inquiry-tab {
    padding: 8px 16px;
    border: 1px solid #ddd;
    border-radius: 20px;
    background: white;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.2s;
}
.inquiry-tab:hover {
    border-color: var(--primary-color);
    color: var(--primary-color);
}
.inquiry-tab.active {
    background: var(--primary-color);
    color: white;
    border-color: var(--primary-color);
}
.inquiry-tab .count {
    font-weight: 600;
}
.inquiry-tab .waiting-count {
    color: #ef4444;
}
.inquiry-tab.active .waiting-count {
    color: white;
}

/* 문의 모달 리스트 */
.inquiry-modal-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
}
.inquiry-modal-item {
    padding: 20px;
    background: #f8fafc;
    border-radius: 12px;
    border: 1px solid #e2e8f0;
}
.inquiry-modal-item[data-status="waiting"] {
    border-left: 4px solid #f59e0b;
}
.inquiry-modal-item[data-status="answered"] {
    border-left: 4px solid #10b981;
}

.inquiry-modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
    flex-wrap: wrap;
    gap: 8px;
}
.inquiry-modal-info {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
}
.inquiry-type-badge {
    padding: 4px 10px;
    border-radius: 12px;
    font-size: 11px;
    font-weight: 600;
}
.inquiry-type-badge.product { background: #dbeafe; color: #1d4ed8; }
.inquiry-type-badge.booking { background: #dcfce7; color: #15803d; }
.inquiry-type-badge.price { background: #fef3c7; color: #b45309; }
.inquiry-type-badge.cancel { background: #fee2e2; color: #dc2626; }
.inquiry-type-badge.other { background: #e5e7eb; color: #4b5563; }

.inquiry-author {
    font-size: 13px;
    color: #666;
}
.inquiry-date {
    font-size: 12px;
    color: #999;
}

.inquiry-status {
    padding: 4px 12px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: 600;
}
.inquiry-status.waiting {
    background: #fef3c7;
    color: #b45309;
}
.inquiry-status.answered {
    background: #dcfce7;
    color: #15803d;
}

.inquiry-modal-question {
    margin-bottom: 12px;
}
.inquiry-modal-question p {
    margin: 0;
    font-size: 14px;
    line-height: 1.6;
    color: #333;
}
.inquiry-modal-question strong {
    color: var(--primary-color);
}

/* 답변 입력 영역 */
.inquiry-modal-reply {
    margin-top: 12px;
    padding-top: 12px;
    border-top: 1px dashed #ddd;
}
.inquiry-modal-reply textarea {
    border: 1px solid #ddd;
    border-radius: 10px;
    font-size: 14px;
    resize: none;
}
.inquiry-modal-reply textarea:focus {
    border-color: var(--primary-color);
    outline: none;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
}
.reply-actions {
    display: flex;
    justify-content: flex-end;
    margin-top: 10px;
}

/* 답변 완료 영역 */
.inquiry-modal-answer {
    margin-top: 12px;
    padding: 14px;
    background: white;
    border-radius: 10px;
    border-left: 3px solid var(--primary-color);
}
.inquiry-modal-answer .answer-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
    font-size: 13px;
}
.inquiry-modal-answer .answer-header > span:first-child {
    color: var(--primary-color);
    font-weight: 600;
}
.inquiry-modal-answer .answer-actions {
    display: flex;
    align-items: center;
    gap: 10px;
}
.inquiry-modal-answer .answer-date {
    color: #999;
    font-size: 12px;
}
.inquiry-modal-answer .answer-content p {
    margin: 0;
    font-size: 14px;
    line-height: 1.6;
    color: #333;
}
.inquiry-modal-answer strong {
    color: #10b981;
}

/* 답변 수정/삭제 버튼 */
.btn-edit-answer,
.btn-delete-answer {
    background: none;
    border: 1px solid #ddd;
    color: #666;
    width: 28px;
    height: 28px;
    border-radius: 6px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
}
.btn-edit-answer:hover {
    background: var(--primary-color);
    border-color: var(--primary-color);
    color: white;
}
.btn-delete-answer:hover {
    background: #ef4444;
    border-color: #ef4444;
    color: white;
}

/* 답변 수정 모드 */
.inquiry-modal-answer.editing {
    border-left-color: #f59e0b;
}
.inquiry-modal-answer.editing .answer-header > span:first-child {
    color: #f59e0b;
}
.answer-edit-area {
    margin-top: 10px;
}
.answer-edit-area textarea {
    width: 100%;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 10px;
    font-size: 14px;
    resize: none;
    min-height: 80px;
}
.answer-edit-area textarea:focus {
    border-color: var(--primary-color);
    outline: none;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
}
.answer-edit-actions {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    margin-top: 10px;
}

/* 폼 섹션 타이틀 */
.form-section-title {
    font-size: 15px;
    font-weight: 600;
    color: var(--primary-color);
    padding: 12px 0;
    margin: 16px 0 12px;
    border-top: 1px solid #eee;
    display: flex;
    align-items: center;
}

.form-section-title:first-of-type {
    border-top: none;
    margin-top: 0;
}

/* 예약 가능 시간 설정 스타일 */
.booking-times-container {
    background: #f8fafc;
    border-radius: 10px;
    padding: 16px;
    border: 1px solid #e2e8f0;
}

.booking-time-list {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-bottom: 12px;
    min-height: 36px;
}

.booking-time-list:empty::before {
    content: '예약 가능한 시간을 추가하세요';
    color: #999;
    font-size: 13px;
    display: flex;
    align-items: center;
    padding: 8px 0;
}

.booking-time-slot {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: white;
    border: 1px solid var(--primary-color);
    color: var(--primary-color);
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 500;
}

.booking-time-slot .remove-time {
    width: 18px;
    height: 18px;
    border-radius: 50%;
    border: none;
    background: #fee2e2;
    color: #dc2626;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    padding: 0;
    transition: all 0.2s;
}

.booking-time-slot .remove-time:hover {
    background: #dc2626;
    color: white;
}

.booking-time-add .input-group {
    max-width: 280px;
}

.booking-time-add input[type="time"] {
    max-width: 140px;
}

.booking-time-presets .btn {
    font-size: 12px;
    padding: 4px 10px;
}

/* 항공/숙박 폼 스타일 */
.form-check-group {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
}

.amenities-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
    gap: 10px;
}

.amenities-grid .form-check {
    margin: 0;
    padding: 10px 12px;
    background: #f8fafc;
    border-radius: 8px;
    border: 1px solid #e2e8f0;
    transition: all 0.2s;
}

.amenities-grid .form-check:hover {
    border-color: var(--primary-color);
    background: #f0f9ff;
}

.amenities-grid .form-check-input:checked + .form-check-label {
    color: var(--primary-color);
    font-weight: 500;
}

.amenities-grid .form-check-label {
    display: flex;
    align-items: center;
    font-size: 13px;
    cursor: pointer;
}

/* 객실 타입 스타일 */
.room-type-container {
    display: flex;
    flex-direction: column;
    gap: 20px;
    margin-bottom: 16px;
}

.room-type-item {
    padding: 20px;
    background: #f8fafc;
    border-radius: 12px;
    border: 1px solid #e2e8f0;
}

.room-type-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    padding-bottom: 12px;
    border-bottom: 1px solid #e2e8f0;
}

.room-type-header h6 {
    margin: 0;
    font-weight: 600;
    color: var(--primary-color);
}

/* 객실 특징 그리드 */
.room-features-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 10px;
    padding: 12px;
    background: #fff;
    border-radius: 8px;
    border: 1px solid #e2e8f0;
}

.room-features-grid .form-check {
    margin: 0;
}

.room-features-grid .form-check-label {
    font-size: 13px;
    display: flex;
    align-items: center;
}

@media (max-width: 992px) {
    .room-features-grid {
        grid-template-columns: repeat(3, 1fr);
    }
}

@media (max-width: 576px) {
    .room-features-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

/* 항공/숙박 선택 시 모달 크기 조정 */
#productModal.modal-xl .modal-dialog {
    max-width: 900px;
}

/* 추가 옵션 스타일 */
.addon-options-container {
    display: flex;
    flex-direction: column;
    gap: 16px;
    margin-bottom: 16px;
}

.addon-option-item {
    padding: 16px;
    background: #f8fafc;
    border-radius: 10px;
    border: 1px solid #e2e8f0;
}

.addon-option-item .mb-3:last-child {
    margin-bottom: 0 !important;
}
</style>

<c:set var="hasInlineScript" value="true" />
<%@ include file="../../common/footer.jsp" %>

<script>
var startDatePicker;
var endDatePicker;

// 페이지 로드 완료 후 초기화
$(document).ready(function() {
    // 탭 필터링
    document.querySelectorAll('.mypage-tab').forEach(tab => {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.mypage-tab').forEach(t => t.classList.remove('active'));
            this.classList.add('active');

            const status = this.dataset.status;
            const products = document.querySelectorAll('.product-manage-item');

            products.forEach(product => {
                if (status === 'all') {
                    product.style.display = 'flex';
                } else {
                    const productStatus = product.dataset.status;
                    product.style.display = productStatus === status ? 'flex' : 'none';
                }
            });
        });
    });

    // 날짜 선택기 초기화
    var startDateInput = document.querySelector('input[name="startDate"]');
    var endDateInput = document.querySelector('input[name="endDate"]');

    if (startDateInput && typeof flatpickr !== 'undefined') {
        startDatePicker = flatpickr(startDateInput, {
            locale: 'ko',
            dateFormat: 'Y-m-d',
            minDate: 'today',
            disableMobile: true,
            onChange: function(selectedDates) {
                if (selectedDates.length > 0 && endDatePicker) {
                    endDatePicker.set('minDate', selectedDates[0]);
                }
            }
        });
    }

    if (endDateInput && typeof flatpickr !== 'undefined') {
        endDatePicker = flatpickr(endDateInput, {
            locale: 'ko',
            dateFormat: 'Y-m-d',
            minDate: 'today',
            disableMobile: true
        });
    }
});

// 새 상품 등록 모달 설정
function setModalForNew() {
    document.getElementById('productModalTitle').textContent = '새 상품 등록';
    document.getElementById('productForm').reset();
    if (startDatePicker) startDatePicker.clear();
    if (endDatePicker) {
        endDatePicker.clear();
        endDatePicker.set('minDate', 'today');
    }
    // 예약 시간 초기화
    bookingTimes = [];
    renderBookingTimes();
}

// ==================== 예약 가능 시간 관리 ====================
var bookingTimes = [];

// 시간 추가
function addBookingTime() {
    var timeInput = document.getElementById('newBookingTime');
    var time = timeInput.value;

    if (!time) {
        showToast('시간을 선택해주세요.', 'warning');
        return;
    }

    // 중복 체크
    if (bookingTimes.includes(time)) {
        showToast('이미 추가된 시간입니다.', 'warning');
        return;
    }

    bookingTimes.push(time);
    bookingTimes.sort(); // 시간순 정렬
    renderBookingTimes();
    timeInput.value = '';
}

// 시간 제거
function removeBookingTime(time) {
    bookingTimes = bookingTimes.filter(function(t) {
        return t !== time;
    });
    renderBookingTimes();
}

// 시간 목록 렌더링
function renderBookingTimes() {
    var container = document.getElementById('bookingTimeList');

    if (bookingTimes.length === 0) {
        container.innerHTML = '';
    } else {
        var html = bookingTimes.map(function(time) {
            // 24시간 형식을 보기 좋게 변환
            var displayTime = formatTime(time);
            return '<span class="booking-time-slot">' +
                       '<i class="bi bi-clock"></i>' +
                       displayTime +
                       '<button type="button" class="remove-time" onclick="removeBookingTime(\'' + time + '\')">' +
                           '<i class="bi bi-x"></i>' +
                       '</button>' +
                   '</span>';
        }).join('');
        container.innerHTML = html;
    }

    // hidden input에 JSON으로 저장
    document.getElementById('bookingTimesInput').value = JSON.stringify(bookingTimes);
}

// 시간 포맷 변환 (HH:MM -> 오전/오후 표시)
function formatTime(time) {
    var parts = time.split(':');
    var hour = parseInt(parts[0]);
    var minute = parts[1];
    var period = hour < 12 ? '오전' : '오후';
    var displayHour = hour === 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return period + ' ' + displayHour + ':' + minute;
}

// 프리셋 시간 추가
function addPresetTimes(type) {
    var presets = {
        'morning': ['09:00', '10:00', '11:00'],
        'afternoon': ['13:00', '14:00', '15:00', '16:00'],
        'hourly': ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00']
    };

    var times = presets[type] || [];
    var addedCount = 0;

    times.forEach(function(time) {
        if (!bookingTimes.includes(time)) {
            bookingTimes.push(time);
            addedCount++;
        }
    });

    if (addedCount > 0) {
        bookingTimes.sort();
        renderBookingTimes();
        showToast(addedCount + '개의 시간이 추가되었습니다.', 'success');
    } else {
        showToast('추가할 새 시간이 없습니다.', 'info');
    }
}

// 상품 수정 모달 설정
function editProduct(id) {
    document.getElementById('productModalTitle').textContent = '상품 수정';
    // TODO: 상품 데이터 로드
    var modal = new bootstrap.Modal(document.getElementById('productModal'));
    modal.show();
}

// 상품 저장
function saveProduct() {
    // TODO: 상품 저장 API 호출
    if (typeof showToast === 'function') {
        showToast('상품이 저장되었습니다.', 'success');
    }
    var modal = bootstrap.Modal.getInstance(document.getElementById('productModal'));
    if (modal) modal.hide();
}

// 상품 상태 변경
function toggleStatus(id) {
    if (confirm('상품 상태를 변경하시겠습니까?')) {
        if (typeof showToast === 'function') {
            showToast('상품 상태가 변경되었습니다.', 'success');
        }
    }
}

// 상품 삭제
function deleteProduct(id) {
    if (confirm('정말 이 상품을 삭제하시겠습니까?\n\n삭제된 상품은 복구할 수 없습니다.')) {
        if (typeof showToast === 'function') {
            showToast('상품이 삭제되었습니다.', 'info');
        }
    }
}

// ==================== 고객 문의 관리 ====================

// 전체 문의 열기 (통계 카드 클릭)
function openAllInquiries() {
    document.getElementById('inquiryModalTitle').textContent = '전체 고객 문의';
    var modal = new bootstrap.Modal(document.getElementById('inquiryModal'));
    modal.show();
}

// 특정 상품 문의 열기
function openProductInquiries(productId, productName) {
    document.getElementById('inquiryModalTitle').textContent = productName + ' - 고객 문의';
    var modal = new bootstrap.Modal(document.getElementById('inquiryModal'));
    modal.show();

    // TODO: 상품별 문의 데이터 필터링
    console.log('상품 문의 열기:', productId, productName);
}

// 문의 탭 필터링
document.querySelectorAll('.inquiry-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        document.querySelectorAll('.inquiry-tab').forEach(t => t.classList.remove('active'));
        this.classList.add('active');

        const filter = this.dataset.filter;
        const items = document.querySelectorAll('.inquiry-modal-item');

        items.forEach(item => {
            if (filter === 'all') {
                item.style.display = 'block';
            } else {
                const status = item.dataset.status;
                item.style.display = status === filter ? 'block' : 'none';
            }
        });
    });
});

// 모달에서 답변 등록
function submitModalReply(inquiryId) {
    var item = document.querySelector('.inquiry-modal-item[data-id="' + inquiryId + '"]');
    var textarea = item.querySelector('textarea');
    var content = textarea.value.trim();

    if (!content) {
        if (typeof showToast === 'function') {
            showToast('답변 내용을 입력해주세요.', 'warning');
        }
        return;
    }

    if (content.length < 10) {
        if (typeof showToast === 'function') {
            showToast('답변은 10자 이상 입력해주세요.', 'warning');
        }
        return;
    }

    // TODO: 실제 API 호출
    console.log('답변 등록:', { inquiryId: inquiryId, content: content });

    // 상태 변경
    item.dataset.status = 'answered';
    var statusBadge = item.querySelector('.inquiry-status');
    statusBadge.className = 'inquiry-status answered';
    statusBadge.textContent = '답변완료';

    // 답변 영역으로 변경
    var replySection = item.querySelector('.inquiry-modal-reply');
    var today = new Date();
    var dateStr = today.getFullYear() + '.' +
                  String(today.getMonth() + 1).padStart(2, '0') + '.' +
                  String(today.getDate()).padStart(2, '0');

    replySection.outerHTML =
        '<div class="inquiry-modal-answer">' +
            '<div class="answer-header">' +
                '<span><i class="bi bi-building"></i> 내 답변</span>' +
                '<div class="answer-actions">' +
                    '<span class="answer-date">' + dateStr + '</span>' +
                    '<button type="button" class="btn-edit-answer" onclick="editAnswer(' + inquiryId + ')" title="답변 수정">' +
                        '<i class="bi bi-pencil"></i>' +
                    '</button>' +
                    '<button type="button" class="btn-delete-answer" onclick="deleteAnswer(' + inquiryId + ')" title="답변 삭제">' +
                        '<i class="bi bi-trash"></i>' +
                    '</button>' +
                '</div>' +
            '</div>' +
            '<div class="answer-content">' +
                '<p><strong>A.</strong> <span class="answer-text">' + escapeHtml(content) + '</span></p>' +
            '</div>' +
        '</div>';

    // 카운트 업데이트
    updateInquiryCounts();

    if (typeof showToast === 'function') {
        showToast('답변이 등록되었습니다.', 'success');
    }
}

// HTML 이스케이프
function escapeHtml(text) {
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// 문의 카운트 업데이트
function updateInquiryCounts() {
    var allItems = document.querySelectorAll('.inquiry-modal-item');
    var waitingItems = document.querySelectorAll('.inquiry-modal-item[data-status="waiting"]');
    var answeredItems = document.querySelectorAll('.inquiry-modal-item[data-status="answered"]');

    var tabs = document.querySelectorAll('.inquiry-tab');
    tabs[0].querySelector('.count').textContent = '(' + allItems.length + ')';
    tabs[1].querySelector('.count').textContent = '(' + waitingItems.length + ')';
    tabs[2].querySelector('.count').textContent = '(' + answeredItems.length + ')';

    // 통계 카드 업데이트
    var statCard = document.querySelector('.stat-card.warning .stat-value');
    if (statCard) {
        statCard.textContent = waitingItems.length;
    }
}

// ==================== 답변 수정 기능 ====================

// 답변 수정 모드 전환
function editAnswer(inquiryId) {
    var item = document.querySelector('.inquiry-modal-item[data-id="' + inquiryId + '"]');
    var answerArea = item.querySelector('.inquiry-modal-answer');
    var answerContent = answerArea.querySelector('.answer-content');
    var answerText = answerArea.querySelector('.answer-text');

    // 이미 수정 모드인 경우 무시
    if (answerArea.classList.contains('editing')) {
        return;
    }

    // 현재 답변 내용 가져오기
    var currentText = answerText.textContent;

    // 수정 모드로 변경
    answerArea.classList.add('editing');

    // 수정 버튼 숨기기
    var editBtn = answerArea.querySelector('.btn-edit-answer');
    editBtn.style.display = 'none';

    // 답변 내용을 textarea로 변경
    answerContent.innerHTML =
        '<div class="answer-edit-area">' +
            '<textarea id="editAnswerText-' + inquiryId + '" rows="4">' + escapeHtml(currentText) + '</textarea>' +
            '<div class="answer-edit-actions">' +
                '<button type="button" class="btn btn-outline btn-sm" onclick="cancelEditAnswer(' + inquiryId + ', \'' + escapeAttr(currentText) + '\')">' +
                    '<i class="bi bi-x me-1"></i>취소' +
                '</button>' +
                '<button type="button" class="btn btn-primary btn-sm" onclick="saveEditAnswer(' + inquiryId + ')">' +
                    '<i class="bi bi-check me-1"></i>수정 완료' +
                '</button>' +
            '</div>' +
        '</div>';

    // textarea에 포커스
    document.getElementById('editAnswerText-' + inquiryId).focus();
}

// 답변 수정 취소
function cancelEditAnswer(inquiryId, originalText) {
    var item = document.querySelector('.inquiry-modal-item[data-id="' + inquiryId + '"]');
    var answerArea = item.querySelector('.inquiry-modal-answer');
    var answerContent = answerArea.querySelector('.answer-content');

    // 수정 모드 해제
    answerArea.classList.remove('editing');

    // 수정 버튼 다시 표시
    var editBtn = answerArea.querySelector('.btn-edit-answer');
    editBtn.style.display = '';

    // 원래 답변 내용 복원
    answerContent.innerHTML = '<p><strong>A.</strong> <span class="answer-text">' + originalText + '</span></p>';
}

// 답변 수정 저장
function saveEditAnswer(inquiryId) {
    var textarea = document.getElementById('editAnswerText-' + inquiryId);
    var newText = textarea.value.trim();

    if (!newText) {
        if (typeof showToast === 'function') {
            showToast('답변 내용을 입력해주세요.', 'warning');
        }
        return;
    }

    if (newText.length < 10) {
        if (typeof showToast === 'function') {
            showToast('답변은 10자 이상 입력해주세요.', 'warning');
        }
        return;
    }

    var item = document.querySelector('.inquiry-modal-item[data-id="' + inquiryId + '"]');
    var answerArea = item.querySelector('.inquiry-modal-answer');
    var answerContent = answerArea.querySelector('.answer-content');

    // 수정 모드 해제
    answerArea.classList.remove('editing');

    // 수정 버튼 다시 표시
    var editBtn = answerArea.querySelector('.btn-edit-answer');
    editBtn.style.display = '';

    // 날짜 업데이트
    var today = new Date();
    var dateStr = today.getFullYear() + '.' +
                  String(today.getMonth() + 1).padStart(2, '0') + '.' +
                  String(today.getDate()).padStart(2, '0');
    var dateSpan = answerArea.querySelector('.answer-date');
    dateSpan.textContent = dateStr + ' (수정됨)';

    // 수정된 답변 내용으로 업데이트
    answerContent.innerHTML = '<p><strong>A.</strong> <span class="answer-text">' + escapeHtml(newText) + '</span></p>';

    // TODO: 실제 API 호출
    console.log('답변 수정:', { inquiryId: inquiryId, content: newText });

    if (typeof showToast === 'function') {
        showToast('답변이 수정되었습니다.', 'success');
    }
}

// 답변 삭제
function deleteAnswer(inquiryId) {
    if (!confirm('답변을 삭제하시겠습니까?\n삭제된 답변은 복구할 수 없습니다.')) {
        return;
    }

    var item = document.querySelector('.inquiry-modal-item[data-id="' + inquiryId + '"]');
    var answerArea = item.querySelector('.inquiry-modal-answer');

    // 답변 영역을 다시 입력 영역으로 변경
    answerArea.outerHTML =
        '<div class="inquiry-modal-reply">' +
            '<textarea class="form-control" placeholder="답변을 입력하세요..." rows="3"></textarea>' +
            '<div class="reply-actions">' +
                '<button class="btn btn-primary btn-sm" onclick="submitModalReply(' + inquiryId + ')">' +
                    '<i class="bi bi-send me-1"></i>답변 등록' +
                '</button>' +
            '</div>' +
        '</div>';

    // 상태를 미답변으로 변경
    item.setAttribute('data-status', 'waiting');
    var statusBadge = item.querySelector('.inquiry-status');
    statusBadge.className = 'inquiry-status waiting';
    statusBadge.textContent = '미답변';

    // 미답변 카운트 업데이트
    updateInquiryModalCounts();

    // TODO: 실제 API 호출
    console.log('답변 삭제:', { inquiryId: inquiryId });

    if (typeof showToast === 'function') {
        showToast('답변이 삭제되었습니다.', 'success');
    }
}

// 문의 모달 카운트 업데이트
function updateInquiryModalCounts() {
    var allItems = document.querySelectorAll('.inquiry-modal-item');
    var waitingItems = document.querySelectorAll('.inquiry-modal-item[data-status="waiting"]');
    var answeredItems = document.querySelectorAll('.inquiry-modal-item[data-status="answered"]');

    var tabs = document.querySelectorAll('.inquiry-tab');
    tabs.forEach(function(tab) {
        var filter = tab.dataset.filter;
        var countSpan = tab.querySelector('.count');
        if (filter === 'all') {
            countSpan.textContent = '(' + allItems.length + ')';
        } else if (filter === 'waiting') {
            countSpan.textContent = '(' + waitingItems.length + ')';
        } else if (filter === 'answered') {
            countSpan.textContent = '(' + answeredItems.length + ')';
        }
    });
}

// 속성용 이스케이프
function escapeAttr(text) {
    return text.replace(/'/g, "\\'").replace(/"/g, '\\"');
}

// 주소 검색 (카카오 주소 API)
function searchAddress() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 주소 정보 설정
            var address = data.roadAddress || data.jibunAddress;
            document.getElementById('productAddress').value = address;

            // 좌표 검색 (카카오 맵 API)
            if (typeof kakao !== 'undefined' && kakao.maps && kakao.maps.services) {
                var geocoder = new kakao.maps.services.Geocoder();
                geocoder.addressSearch(address, function(result, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        document.getElementById('productLatitude').value = result[0].y;
                        document.getElementById('productLongitude').value = result[0].x;
                    }
                });
            }
        }
    }).open();
}

// ===== 상품 선택 기능 =====

// 전체 선택/해제
function toggleSelectAll(checkbox) {
    var productCheckboxes = document.querySelectorAll('.product-select-checkbox');
    productCheckboxes.forEach(function(cb) {
        cb.checked = checkbox.checked;
        var productItem = cb.closest('.product-manage-item');
        if (checkbox.checked) {
            productItem.classList.add('selected');
        } else {
            productItem.classList.remove('selected');
        }
    });
    updateSelectedCount();
}

// 개별 체크박스 클릭 시
function toggleProductSelect(checkbox) {
    var productItem = checkbox.closest('.product-manage-item');
    if (checkbox.checked) {
        productItem.classList.add('selected');
    } else {
        productItem.classList.remove('selected');
    }

    // 전체 선택 체크박스 상태 업데이트
    var allCheckboxes = document.querySelectorAll('.product-select-checkbox');
    var checkedCheckboxes = document.querySelectorAll('.product-select-checkbox:checked');
    var selectAllCheckbox = document.getElementById('selectAllProducts');

    if (checkedCheckboxes.length === allCheckboxes.length) {
        selectAllCheckbox.checked = true;
        selectAllCheckbox.indeterminate = false;
    } else if (checkedCheckboxes.length === 0) {
        selectAllCheckbox.checked = false;
        selectAllCheckbox.indeterminate = false;
    } else {
        selectAllCheckbox.checked = false;
        selectAllCheckbox.indeterminate = true;
    }

    updateSelectedCount();
}

// 선택된 상품 수 업데이트
function updateSelectedCount() {
    var checkedCheckboxes = document.querySelectorAll('.product-select-checkbox:checked');
    var count = checkedCheckboxes.length;

    document.getElementById('selectedCount').textContent = count + '개 선택됨';

    // 액션 버튼 활성화/비활성화
    var selectionActions = document.getElementById('selectionActions');
    if (count > 0) {
        selectionActions.classList.add('active');
    } else {
        selectionActions.classList.remove('active');
    }
}

// 선택된 상품 ID 목록 가져오기
function getSelectedProductIds() {
    var checkedCheckboxes = document.querySelectorAll('.product-select-checkbox:checked');
    var ids = [];
    checkedCheckboxes.forEach(function(cb) {
        ids.push(cb.value);
    });
    return ids;
}

// 선택 상품 중지
function pauseSelectedProducts() {
    var selectedIds = getSelectedProductIds();
    if (selectedIds.length === 0) {
        if (typeof showToast === 'function') {
            showToast('선택된 상품이 없습니다.', 'warning');
        }
        return;
    }

    if (!confirm(selectedIds.length + '개의 상품을 중지하시겠습니까?')) {
        return;
    }

    // 선택된 상품들의 상태를 중지로 변경 (UI 업데이트)
    selectedIds.forEach(function(id) {
        var checkbox = document.querySelector('.product-select-checkbox[value="' + id + '"]');
        if (checkbox) {
            var productItem = checkbox.closest('.product-manage-item');
            var statusBadge = productItem.querySelector('.product-status');
            if (statusBadge && !statusBadge.classList.contains('inactive')) {
                statusBadge.className = 'product-status inactive';
                statusBadge.textContent = '판매중지';
                productItem.setAttribute('data-status', 'inactive');
            }
        }
    });

    // 선택 해제
    clearProductSelection();

    if (typeof showToast === 'function') {
        showToast(selectedIds.length + '개의 상품이 중지되었습니다.', 'success');
    }

    // 통계 업데이트
    updateProductStats();

    // TODO: 실제 서버 요청
    // $.ajax({
    //     url: '${pageContext.request.contextPath}/api/products/pause',
    //     type: 'POST',
    //     data: JSON.stringify({ productIds: selectedIds }),
    //     contentType: 'application/json',
    //     success: function(response) { ... }
    // });
}

// 선택 상품 재개
function resumeSelectedProducts() {
    var selectedIds = getSelectedProductIds();
    if (selectedIds.length === 0) {
        if (typeof showToast === 'function') {
            showToast('선택된 상품이 없습니다.', 'warning');
        }
        return;
    }

    if (!confirm(selectedIds.length + '개의 상품을 재개하시겠습니까?')) {
        return;
    }

    // 선택된 상품들의 상태를 판매중으로 변경 (UI 업데이트)
    selectedIds.forEach(function(id) {
        var checkbox = document.querySelector('.product-select-checkbox[value="' + id + '"]');
        if (checkbox) {
            var productItem = checkbox.closest('.product-manage-item');
            var statusBadge = productItem.querySelector('.product-status');
            if (statusBadge && statusBadge.classList.contains('inactive')) {
                statusBadge.className = 'product-status active';
                statusBadge.textContent = '판매중';
                productItem.setAttribute('data-status', 'active');
            }
        }
    });

    // 선택 해제
    clearProductSelection();

    if (typeof showToast === 'function') {
        showToast(selectedIds.length + '개의 상품이 재개되었습니다.', 'success');
    }

    // 통계 업데이트
    updateProductStats();

    // TODO: 실제 서버 요청
}

// 선택 상품 삭제
function deleteSelectedProducts() {
    var selectedIds = getSelectedProductIds();
    if (selectedIds.length === 0) {
        if (typeof showToast === 'function') {
            showToast('선택된 상품이 없습니다.', 'warning');
        }
        return;
    }

    if (!confirm(selectedIds.length + '개의 상품을 삭제하시겠습니까?\n삭제된 상품은 복구할 수 없습니다.')) {
        return;
    }

    // 선택된 상품들 제거 (UI 업데이트)
    var deleteCount = selectedIds.length;
    selectedIds.forEach(function(id) {
        var checkbox = document.querySelector('.product-select-checkbox[value="' + id + '"]');
        if (checkbox) {
            var productItem = checkbox.closest('.product-manage-item');
            productItem.style.transition = 'opacity 0.3s, transform 0.3s';
            productItem.style.opacity = '0';
            productItem.style.transform = 'translateX(-20px)';
            setTimeout(function() {
                productItem.remove();
                updateProductStats();
            }, 300);
        }
    });

    // 선택 해제
    clearProductSelection();

    if (typeof showToast === 'function') {
        showToast(deleteCount + '개의 상품이 삭제되었습니다.', 'success');
    }

    // TODO: 실제 서버 요청
}

// 선택 해제
function clearProductSelection() {
    var allCheckboxes = document.querySelectorAll('.product-select-checkbox');
    allCheckboxes.forEach(function(cb) {
        cb.checked = false;
        var productItem = cb.closest('.product-manage-item');
        if (productItem) {
            productItem.classList.remove('selected');
        }
    });

    var selectAllCheckbox = document.getElementById('selectAllProducts');
    if (selectAllCheckbox) {
        selectAllCheckbox.checked = false;
        selectAllCheckbox.indeterminate = false;
    }

    updateSelectedCount();
}

// 상품 통계 업데이트
function updateProductStats() {
    var allProducts = document.querySelectorAll('.product-manage-item');
    var activeProducts = document.querySelectorAll('.product-status.active');
    var inactiveProducts = document.querySelectorAll('.product-status.inactive');

    // 통계 카드 업데이트
    var statCards = document.querySelectorAll('.stat-card .stat-value');
    if (statCards.length >= 3) {
        statCards[0].textContent = allProducts.length;
        statCards[1].textContent = activeProducts.length;
        statCards[2].textContent = inactiveProducts.length;
    }
}

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    // 개별 체크박스에 이벤트 리스너 추가
    var productCheckboxes = document.querySelectorAll('.product-select-checkbox');
    productCheckboxes.forEach(function(cb) {
        cb.addEventListener('change', function() {
            toggleProductSelect(this);
        });
    });

    // 초기 선택 수 업데이트
    updateSelectedCount();
});

// ==================== 카테고리별 폼 필드 전환 ====================

// 카테고리 변경 시 폼 필드 토글
function toggleCategoryFields() {
    var category = document.getElementById('productCategory').value;

    // 기본 섹션들
    var regionField = document.getElementById('regionField');
    var durationField = document.getElementById('durationField');
    var descriptionField = document.getElementById('descriptionField');
    var defaultInfoSection = document.getElementById('defaultInfoSection');
    var defaultPriceSection = document.getElementById('defaultPriceSection');
    var productNameField = document.getElementById('productNameField');
    var locationField = document.getElementById('locationField');

    // 항공/숙박 섹션들
    var flightFields = document.getElementById('flightFields');
    var accommodationFields = document.getElementById('accommodationFields');
    var flightAccomDateSection = document.getElementById('flightAccomDateSection');
    var flightAccomImageField = document.getElementById('flightAccomImageField');

    // 모든 섹션 초기화 (숨기기)
    flightFields.style.display = 'none';
    accommodationFields.style.display = 'none';
    flightAccomDateSection.style.display = 'none';

    if (category === 'flight') {
        // 항공 선택 시
        productNameField.style.display = 'none';
        locationField.style.display = 'none';
        regionField.style.display = 'none';
        durationField.style.display = 'none';
        descriptionField.style.display = 'none';
        defaultInfoSection.style.display = 'none';
        defaultPriceSection.style.display = 'none';

        flightFields.style.display = 'block';
        flightAccomDateSection.style.display = 'block';
        flightAccomImageField.style.display = 'none';

    } else if (category === 'accommodation') {
        // 숙박 선택 시
        productNameField.style.display = 'block';
        locationField.style.display = 'block';
        regionField.style.display = 'block';
        durationField.style.display = 'none';
        descriptionField.style.display = 'block';  // 숙소 소개 표시
        defaultInfoSection.style.display = 'none';
        defaultPriceSection.style.display = 'none';

        accommodationFields.style.display = 'block';
        flightAccomDateSection.style.display = 'block';
        flightAccomImageField.style.display = 'block';

    } else {
        // 기본 상품 (투어, 액티비티 등)
        productNameField.style.display = 'block';
        locationField.style.display = 'block';
        regionField.style.display = 'block';
        durationField.style.display = 'block';
        descriptionField.style.display = 'block';
        defaultInfoSection.style.display = 'block';
        defaultPriceSection.style.display = 'block';
    }
}

// ==================== 객실 타입 관리 (숙박용) ====================

var roomTypeIndex = 1; // 이미 0번 인덱스가 있으므로 1부터 시작

// 객실 타입 추가
function addRoomType() {
    var container = document.getElementById('roomTypeContainer');
    var index = roomTypeIndex++;

    var roomHtml =
        '<div class="room-type-item" data-room-index="' + index + '">' +
            '<div class="room-type-header">' +
                '<h6><i class="bi bi-door-closed me-2"></i>객실 타입 ' + (index + 1) + '</h6>' +
                '<button type="button" class="btn btn-sm btn-outline-danger" onclick="removeRoomType(' + index + ')">' +
                    '<i class="bi bi-x"></i> 삭제' +
                '</button>' +
            '</div>' +
            '<div class="row mb-3">' +
                '<div class="col-md-4">' +
                    '<label class="form-label">객실명 <span class="text-danger">*</span></label>' +
                    '<input type="text" class="form-control" name="roomName_' + index + '" placeholder="예: 디럭스 트윈">' +
                '</div>' +
                '<div class="col-md-4">' +
                    '<label class="form-label">기준 인원 <span class="text-danger">*</span></label>' +
                    '<input type="number" class="form-control" name="roomCapacity_' + index + '" placeholder="2" min="1">' +
                '</div>' +
                '<div class="col-md-4">' +
                    '<label class="form-label">최대 인원</label>' +
                    '<input type="number" class="form-control" name="roomMaxCapacity_' + index + '" placeholder="4" min="1">' +
                '</div>' +
            '</div>' +
            '<div class="row mb-3">' +
                '<div class="col-md-3">' +
                    '<label class="form-label">1박 가격 <span class="text-danger">*</span></label>' +
                    '<div class="input-group">' +
                        '<input type="number" class="form-control" name="roomPrice_' + index + '" placeholder="0">' +
                        '<span class="input-group-text">원</span>' +
                    '</div>' +
                '</div>' +
                '<div class="col-md-2">' +
                    '<label class="form-label">할인율</label>' +
                    '<div class="input-group">' +
                        '<input type="number" class="form-control" name="roomDiscount_' + index + '" placeholder="0" min="0" max="100">' +
                        '<span class="input-group-text">%</span>' +
                    '</div>' +
                '</div>' +
                '<div class="col-md-2">' +
                    '<label class="form-label">잔여 객실 <span class="text-danger">*</span></label>' +
                    '<div class="input-group">' +
                        '<input type="number" class="form-control" name="roomStock_' + index + '" placeholder="0" min="0">' +
                        '<span class="input-group-text">실</span>' +
                    '</div>' +
                '</div>' +
                '<div class="col-md-2">' +
                    '<label class="form-label">객실 크기</label>' +
                    '<div class="input-group">' +
                        '<input type="number" class="form-control" name="roomSize_' + index + '" placeholder="0">' +
                        '<span class="input-group-text">㎡</span>' +
                    '</div>' +
                '</div>' +
                '<div class="col-md-3">' +
                    '<label class="form-label">조식 포함</label>' +
                    '<select class="form-select" name="roomBreakfast_' + index + '">' +
                        '<option value="none">조식 미포함</option>' +
                        '<option value="included">조식 포함</option>' +
                    '</select>' +
                '</div>' +
            '</div>' +
            '<div class="mb-3">' +
                '<label class="form-label">침대 타입</label>' +
                '<div class="form-check-group">' +
                    '<div class="form-check form-check-inline">' +
                        '<input class="form-check-input" type="checkbox" name="bedType_' + index + '" value="single" id="bedSingle_' + index + '">' +
                        '<label class="form-check-label" for="bedSingle_' + index + '">싱글</label>' +
                    '</div>' +
                    '<div class="form-check form-check-inline">' +
                        '<input class="form-check-input" type="checkbox" name="bedType_' + index + '" value="double" id="bedDouble_' + index + '">' +
                        '<label class="form-check-label" for="bedDouble_' + index + '">더블</label>' +
                    '</div>' +
                    '<div class="form-check form-check-inline">' +
                        '<input class="form-check-input" type="checkbox" name="bedType_' + index + '" value="queen" id="bedQueen_' + index + '">' +
                        '<label class="form-check-label" for="bedQueen_' + index + '">퀸</label>' +
                    '</div>' +
                    '<div class="form-check form-check-inline">' +
                        '<input class="form-check-input" type="checkbox" name="bedType_' + index + '" value="king" id="bedKing_' + index + '">' +
                        '<label class="form-check-label" for="bedKing_' + index + '">킹</label>' +
                    '</div>' +
                    '<div class="form-check form-check-inline">' +
                        '<input class="form-check-input" type="checkbox" name="bedType_' + index + '" value="ondol" id="bedOndol_' + index + '">' +
                        '<label class="form-check-label" for="bedOndol_' + index + '">온돌</label>' +
                    '</div>' +
                '</div>' +
            '</div>' +
            '<div class="mb-3">' +
                '<label class="form-label">객실 특징</label>' +
                '<div class="room-features-grid">' +
                    '<div class="form-check">' +
                        '<input class="form-check-input" type="checkbox" name="roomFeature_' + index + '" value="free_cancel" id="featureFreeCancel_' + index + '">' +
                        '<label class="form-check-label" for="featureFreeCancel_' + index + '"><i class="bi bi-check-circle me-1"></i>무료 취소</label>' +
                    '</div>' +
                    '<div class="form-check">' +
                        '<input class="form-check-input" type="checkbox" name="roomFeature_' + index + '" value="ocean_view" id="featureOceanView_' + index + '">' +
                        '<label class="form-check-label" for="featureOceanView_' + index + '"><i class="bi bi-water me-1"></i>오션뷰</label>' +
                    '</div>' +
                    '<div class="form-check">' +
                        '<input class="form-check-input" type="checkbox" name="roomFeature_' + index + '" value="mountain_view" id="featureMountainView_' + index + '">' +
                        '<label class="form-check-label" for="featureMountainView_' + index + '"><i class="bi bi-mountain me-1"></i>마운틴뷰</label>' +
                    '</div>' +
                    '<div class="form-check">' +
                        '<input class="form-check-input" type="checkbox" name="roomFeature_' + index + '" value="city_view" id="featureCityView_' + index + '">' +
                        '<label class="form-check-label" for="featureCityView_' + index + '"><i class="bi bi-buildings me-1"></i>시티뷰</label>' +
                    '</div>' +
                    '<div class="form-check">' +
                        '<input class="form-check-input" type="checkbox" name="roomFeature_' + index + '" value="living_room" id="featureLivingRoom_' + index + '">' +
                        '<label class="form-check-label" for="featureLivingRoom_' + index + '"><i class="bi bi-door-open me-1"></i>거실 포함</label>' +
                    '</div>' +
                    '<div class="form-check">' +
                        '<input class="form-check-input" type="checkbox" name="roomFeature_' + index + '" value="balcony" id="featureBalcony_' + index + '">' +
                        '<label class="form-check-label" for="featureBalcony_' + index + '"><i class="bi bi-flower1 me-1"></i>발코니/테라스</label>' +
                    '</div>' +
                    '<div class="form-check">' +
                        '<input class="form-check-input" type="checkbox" name="roomFeature_' + index + '" value="no_smoking" id="featureNoSmoking_' + index + '">' +
                        '<label class="form-check-label" for="featureNoSmoking_' + index + '"><i class="bi bi-slash-circle me-1"></i>금연</label>' +
                    '</div>' +
                    '<div class="form-check">' +
                        '<input class="form-check-input" type="checkbox" name="roomFeature_' + index + '" value="kitchen" id="featureKitchen_' + index + '">' +
                        '<label class="form-check-label" for="featureKitchen_' + index + '"><i class="bi bi-cup-hot me-1"></i>주방/취사</label>' +
                    '</div>' +
                '</div>' +
            '</div>' +
        '</div>';

    container.insertAdjacentHTML('beforeend', roomHtml);

    // 첫 번째 객실 타입에 삭제 버튼 표시 (2개 이상일 때)
    updateRoomTypeDeleteButtons();

    if (typeof showToast === 'function') {
        showToast('객실 타입이 추가되었습니다.', 'success');
    }
}

// 객실 타입 삭제
function removeRoomType(index) {
    var roomItem = document.querySelector('.room-type-item[data-room-index="' + index + '"]');
    if (roomItem) {
        roomItem.style.transition = 'opacity 0.3s, transform 0.3s';
        roomItem.style.opacity = '0';
        roomItem.style.transform = 'translateX(-20px)';
        setTimeout(function() {
            roomItem.remove();
            updateRoomTypeDeleteButtons();
        }, 300);
    }
}

// 객실 타입 삭제 버튼 표시 업데이트
function updateRoomTypeDeleteButtons() {
    var roomItems = document.querySelectorAll('.room-type-item');
    roomItems.forEach(function(item, idx) {
        var deleteBtn = item.querySelector('.btn-outline-danger');
        if (deleteBtn) {
            // 객실 타입이 1개뿐이면 삭제 버튼 숨김
            deleteBtn.style.display = roomItems.length > 1 ? 'inline-flex' : 'none';
        }
    });
}

// ==================== 추가 옵션 관리 (숙박용) ====================

var addonOptionIndex = 1; // 이미 0번 인덱스가 있으므로 1부터 시작

// 추가 옵션 추가
function addAddonOption() {
    var container = document.getElementById('addonOptionsContainer');
    var index = addonOptionIndex++;

    var addonHtml =
        '<div class="addon-option-item" data-addon-index="' + index + '">' +
            '<div class="row">' +
                '<div class="col-md-5">' +
                    '<label class="form-label">옵션명</label>' +
                    '<input type="text" class="form-control" name="addonName_' + index + '" placeholder="예: 레이트 체크아웃">' +
                '</div>' +
                '<div class="col-md-2">' +
                    '<label class="form-label">인원</label>' +
                    '<div class="input-group">' +
                        '<input type="number" class="form-control" name="addonPerson_' + index + '" placeholder="0" min="0" value="0">' +
                        '<span class="input-group-text">명</span>' +
                    '</div>' +
                '</div>' +
                '<div class="col-md-3">' +
                    '<label class="form-label">가격</label>' +
                    '<div class="input-group">' +
                        '<input type="number" class="form-control" name="addonPrice_' + index + '" placeholder="0">' +
                        '<span class="input-group-text">원</span>' +
                    '</div>' +
                '</div>' +
                '<div class="col-md-2 d-flex align-items-end">' +
                    '<button type="button" class="btn btn-outline-danger w-100" onclick="removeAddonOption(' + index + ')">' +
                        '<i class="bi bi-x"></i>' +
                    '</button>' +
                '</div>' +
            '</div>' +
        '</div>';

    container.insertAdjacentHTML('beforeend', addonHtml);

    // 첫 번째 추가 옵션에 삭제 버튼 표시 (2개 이상일 때)
    updateAddonDeleteButtons();

    if (typeof showToast === 'function') {
        showToast('추가 옵션이 추가되었습니다.', 'success');
    }
}

// 추가 옵션 삭제
function removeAddonOption(index) {
    var addonItem = document.querySelector('.addon-option-item[data-addon-index="' + index + '"]');
    if (addonItem) {
        addonItem.style.transition = 'opacity 0.3s, transform 0.3s';
        addonItem.style.opacity = '0';
        addonItem.style.transform = 'translateX(-20px)';
        setTimeout(function() {
            addonItem.remove();
            updateAddonDeleteButtons();
        }, 300);
    }
}

// 추가 옵션 삭제 버튼 표시 업데이트
function updateAddonDeleteButtons() {
    var addonItems = document.querySelectorAll('.addon-option-item');
    addonItems.forEach(function(item, idx) {
        var deleteBtn = item.querySelector('.btn-outline-danger');
        if (deleteBtn) {
            // 추가 옵션이 1개뿐이면 삭제 버튼 숨김
            deleteBtn.style.display = addonItems.length > 1 ? 'inline-flex' : 'none';
        }
    });
}
</script>
</body>
</html>
