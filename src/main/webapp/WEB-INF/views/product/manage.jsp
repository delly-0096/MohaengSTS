<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="상품 관리" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product-manage.css">

<div class="product-manage-page">
    <div class="container">
        <!-- 페이지 헤더 -->
        <div class="page-header">
            <div class="page-header-content">
                <h1 class="page-title">상품 관리</h1>
                <p class="page-subtitle">등록한 상품을 관리하고 새 상품을 등록하세요</p>
            </div>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#productModal" onclick="setModalForNew()">
                <i class="bi bi-plus-lg me-2"></i>새 상품 등록
            </button>
        </div>

        <!-- 통계 카드 -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-icon primary">
                    <i class="bi bi-box-seam"></i>
                </div>
                <div class="stat-info">
	                <span class="stat-value">${prodAggregate.totalCount}</span>
                    <span class="stat-label">전체 상품</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon success">
                    <i class="bi bi-check-circle"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${prodAggregate.approveCount}</span>
                    <span class="stat-label">판매중</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon warning">
                    <i class="bi bi-pause-circle"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${prodAggregate.unapproveCount}</span>
                    <span class="stat-label">판매중지</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon info">
                    <i class="bi bi-cart-check"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${prodAggregate.totalSales}</span>
                    <span class="stat-label">총 판매건수</span>
                </div>
            </div>
        </div>

        <!-- 필터 및 검색 -->
        <div class="filter-bar">
            <div class="filter-group">
            	<!-- 바뀔때마다 해당 상품만 조회 -->
                <select class="form-select" id="categoryFilter">
                    <option value="all">전체 카테고리</option>
                    <option value="tour">투어</option>
                    <option value="activity">액티비티</option>
                    <option value="ticket">입장권/티켓</option>
                    <option value="class">클래스/체험</option>
                    <option value="transfer">교통/이동</option>
                    <option value="accommodation">숙박</option>
                </select>
                <select class="form-select" id="statusFilter">
                    <option value="all">전체 상태</option>
                    <option value="active">판매중</option>
                    <option value="inactive">판매중지</option>
                </select>
            </div>
            <div class="search-group">
                <div class="search-input-wrapper">
                    <i class="bi bi-search"></i>
                    <input type="text" class="form-control" placeholder="상품명 검색" id="productSearch" />
                </div>
            </div>
        </div>

        <!-- 선택 기능 영역 -->
        <div class="product-selection-bar" id="productSelectionBar">
            <div class="selection-left">
                <label class="select-all-checkbox">
                    <input type="checkbox" id="selectAllProducts" onchange="toggleSelectAll(this)">
                    <span>전체 선택</span>
                </label>
                <span class="selected-count" id="selectedCount">개 선택됨</span>
            </div>
            <div class="selection-actions" id="selectionActions">
            	<!-- 인자 넣고 data-set하기? -->
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

        <!-- 상품 목록 -->
        <!-- 활성화 = active 비활성화 = inactive -->
        <div class="product-list">
        	<c:choose>
        		<c:when test="${empty prodList }">
        				<div class="no-results-msg">상품이 존재하지 않습니다.</div>
        		</c:when>
        		<c:otherwise>
		        	<c:forEach items="${prodList}" var="prod">
			        	<c:set var="status" value="${prod.approveStatus }"/>
			        	<c:set var="dataStatus" value="active"/>
			        	<c:if test="${status == '판매중지'}">
				        	<c:set var="dataStatus" value="inactive"/>
			        	</c:if>
			        	<c:set var="accNo" value="${not empty prod.accommodation and prod.prodCtgryType eq 'accommodation' ? prod.accommodation.accNo : 0}"/>
			            <div class="product-manage-card" data-id="${prod.tripProdNo}" data-status="${dataStatus}" data-no="${accNo}">
			                <label class="product-checkbox">
			                    <input type="checkbox" class="product-select-checkbox" value="${prod.tripProdNo}" onchange="toggleProductSelect(this)">
			                </label>
			                <div class="product-image">
			                    <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=200&h=150&fit=crop&q=80" alt="스쿠버다이빙">
			                    <span class="product-status ${dataStatus}">${status}</span>
			                </div>
			                <div class="product-info">
			                    <div class="product-category">${prod.prodCtgryType}</div>
			                    <c:set var="title" value="${not empty prod.accommodation and prod.prodCtgryType eq 'accommodation' ? prod.accommodation.accName : prod.tripProdTitle}"/>
			                    <h3 class="product-name">${title}</h3>
			                    <div class="product-meta">
			                        <span><i class="bi bi-geo-alt"></i>${prod.ctyNm}</span><!-- 지역 코드 -->
			                        <span>
			                        	<c:set var="avgRating" value="${empty prod.avgRating or prod.avgRating == 0 ? 0.0 : prod.avgRating}"/>
			                        	<c:set var="reviewCount" value="${empty prod.reviewCount or prod.reviewCount == 0 ? 0 : prod.reviewCount}"/>
										<i class="bi bi-star-fill text-warning"></i> ${avgRating} (${reviewCount })
			                        </span>
			                    </div>
			                    <div class="product-period">
			                        <i class="bi bi-calendar-range"></i>
			                        <span>
				                        <fmt:formatDate value="${prod.saleStartDt}" pattern="yyyy.MM.dd" /> ~ 
				                        <fmt:formatDate value="${prod.saleEndDt}" pattern="yyyy.MM.dd" />
			                        </span>
			                    </div>
			                    <div class="product-price">
			                    <c:choose>
			                    	<c:when test="${not empty prod.prodSale and prod.prodSale.discount > 0}">
				                        <span class="original-price">
				                        	<fmt:formatNumber value="${prod.prodSale.netprc}" pattern="#,###"/>원
				                        </span>
				                        <span class="sale-price">
				                        	<fmt:formatNumber value="${prod.displayPrice}" pattern="#,###"/>원
				                        </span>
				                        <span class="discount-rate">${prod.prodSale.discount}% 할인</span>
			                    	</c:when>
			                    	<c:when test="${not empty prod.prodSale and prod.prodSale.netprc > 0 and empty prod.prodSale.discount}">
			                    		<span class="sale-price">
				                        	<fmt:formatNumber value="${prod.displayPrice}" pattern="#,###"/>원
				                        </span>
			                    	</c:when>
			                    	<c:otherwise>
				                    	<!-- 숙박 상품인 경우, 할인된 가격도 가져와야됨  -->
				                        <span class="sale-price">
				                        	<fmt:formatNumber value="${prod.displayPrice}" pattern="#,###"/>원 ~
				                        </span>
			                    	</c:otherwise>
			                    </c:choose>
			                    </div>
			                </div>
			                <div class="product-stats">
			                	<!-- 여기도 값이 없을때 처리 해줘야됨
			                		price가 2개 있음
			                		숙소 = price
			                		다른 거는 여러 price
			                	 -->
			                    <div class="stat-item">
			                        <span class="stat-label">총 재고</span>
			                        <span class="stat-value stock-value">${prod.prodSale.totalStock}개</span>
			                    </div>
			                    <div class="stat-item">
			                        <span class="stat-label">현재 재고</span>
			                        <span class="stat-value stock-value">${prod.prodSale.curStock}개</span>
			                    </div>
			                    <div class="stat-item">
			                        <span class="stat-label">조회수</span>
			                        <span class="stat-value">${prod.viewCnt}</span>
			                    </div>
			                    <div class="stat-item">
			                        <span class="stat-label">예약수</span>
			                        <span class="stat-value">${prod.prodSale.totalStock - prod.prodSale.curStock}</span>
			                    </div>
			                    <div class="stat-item">
			                        <span class="stat-label">매출</span>
			                        <span class="stat-value">
			                        	<c:choose>
			                        		<c:when test="${not empty prod.prodSale.price and prod.prodSale.price > 0}">
					                        	<c:set var="price" value="${prod.prodSale.price * (prod.prodSale.totalStock - prod.prodSale.curStock)}"/>
					                        	<fmt:formatNumber value="${price}" pattern="#,###"/>원
			                        		</c:when>
			                        		<c:otherwise>
												<div>아직 안불러옴</div>
			                        		</c:otherwise>
			                        	</c:choose>
			                        </span>
			                    </div>
			                </div>
			                <div class="product-actions">
			                    <a href="/business/product/tourDetail/${prod.tripProdNo}" class="btn btn-outline btn-sm">
			                        <i class="bi bi-eye"></i> 상세보기
			                    </a>
			                    <button class="btn btn-outline btn-sm" onclick="editProduct(this)"
			                    	data-id="${prod.tripProdNo}" data-no="${accNo}">
			                        <i class="bi bi-pencil"></i> 수정
			                    </button>
			                    <button class="btn btn-outline btn-sm" onclick="toggleProductStatus(this)"
			                    	data-id="${prod.tripProdNo}" data-status="${prod.approveStatus}">
			                        <i class="bi bi-pause"></i> 
			                        ${prod.approveStatus == '판매중' ? '중지' : '재개'}
			                    </button>
			                    <!-- prod.aprvYn == 'Y' ? '승인' : 'wait = 대기' / 'N = 불허' -->
			                    <button class="btn btn-outline btn-sm text-danger" onclick="deleteProduct(this)"
			                    	data-id="${prod.tripProdNo}">
			                        <i class="bi bi-trash"></i> 삭제
			                    </button>
			                </div>
			            </div>
		            </c:forEach>
        		</c:otherwise>
        	</c:choose>
        </div>

        <!-- 인피니티?? 할지 말지 -->
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
	                <input type="hidden" name="tripProdNo"/>
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label">카테고리 <span class="text-danger">*</span></label>
                            <select class="form-select" name="prodCtgryType" id="productCategory" required onchange="toggleCategoryFields()">
                                <option value="">선택하세요</option>
                                <option value="tour">투어</option>
                                <option value="activity">액티비티</option>
                                <option value="ticket">입장권/티켓</option>
                                <option value="class">클래스/체험</option>
                                <option value="transfer">교통/이동</option>
                                <option value="accommodation">숙박</option>
                            </select>
                        </div>
                        <div class="col-md-4" id="regionField">
                            <label class="form-label">지역 <span class="text-danger">*</span></label>
                            <select class="form-select" name="ctyNm">
                            	<!-- 일단 나중에 상의 -->
                                <option value="">선택하세요</option>
                                <optgroup label="수도권">
                                    <option value="1">서울</option>
                                    <option value="31">경기</option>
                                    <option value="2">인천</option>
                                </optgroup>
                                <optgroup label="강원권">
                                    <option value="32">강원</option>
                                </optgroup>
                                <optgroup label="충청권">
                                    <option value="3">대전</option>
                                    <option value="8">세종</option>
                                    <option value="33">충북</option>
                                    <option value="34">충남</option>
                                </optgroup>
                                <optgroup label="전라권">
                                    <option value="5">광주</option>
                                    <option value="37">전북</option>
                                    <option value="38">전남</option>
                                </optgroup>
                                <optgroup label="경상권">
                                    <option value="6">부산</option>
                                    <option value="4">대구</option>
                                    <option value="7">울산</option>
                                    <option value="35">경북</option>
                                    <option value="36">경남</option>
                                </optgroup>
                                <optgroup label="제주권">
                                    <option value="39">제주</option>
                                </optgroup>
                            </select>
                        </div>
                        <div class="col-md-4" id="durationField">
                            <label class="form-label">소요시간 <span class="text-danger">*</span></label>
                            <select class="form-select" name="prodSale.leadTime">
                                <option value="">선택하세요</option>
                                <option value="1">1시간 이내</option>
                                <option value="3">1~3시간</option>
                                <option value="6">3~6시간</option>
                                <option value="24">하루 이상</option>
                            </select>
                        </div>
                    </div>
                    
                    
                    <div class="mb-3" id="productNameField">
                        <label class="form-label">상품명 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="tripProdTitle" placeholder="상품명을 입력하세요" required>
                    </div>
                    <div class="mb-3" id="locationField">
                        <label class="form-label">위치 정보 <span class="text-danger">*</span></label>
                        <div class="row g-2">
                            <div class="col-md-10">
                                <input type="text" class="form-control" name="prodPlace.addr1" id="productAddress" placeholder="주소를 검색하세요" required readonly>
                            </div>
                            <div class="col-md-2">
                                <button type="button" class="btn btn-outline w-100" onclick="searchAddress()">
                                    <i class="bi bi-search"></i> 검색
                                </button>
                            </div>
                        </div>
                        <input type="text" class="form-control mt-2" name="prodPlace.addr2" placeholder="상세주소 (건물명, 층, 호수 등)">
                        <div class="mb-3" id="mapSection" style="display: none;">
						    <label class="form-label">위치 확인</label>
						    <div id="registerMap" style="width: 100%; height: 250px; border-radius:12px; border: 1px solid #ddd;"></div>
						</div>
                        
                        <input type="hidden" name="latitude" id="productLatitude"/>
                        <input type="hidden" name="longitude" id="productLongitude"/>
                        
                        <!-- 상품용 -->
                        <input type="hidden" name="accommodation.addr1" id="accAddr1">
					    <input type="hidden" name="accommodation.addr2" id="accAddr2">
					    
					    <!-- 숙박용 -->
					    <input type="hidden" name="accommodation.mapx" id="productLongitude"> 
					    <input type="hidden" name="accommodation.mapy" id="productLatitude">  
					    <input type="hidden" class="form-control mt-2" id="detailAddressInput" 
					           placeholder="상세주소 (건물명, 층, 호수 등)" oninput="syncDetailAddress(this.value)">
                        
                    </div>
                    <div class="mb-3" id="descriptionField">
                        <label class="form-label">상품 설명 <span class="text-danger">*</span></label>
                        <textarea class="form-control" name="tripProdContent" rows="4" placeholder="상품에 대한 상세 설명을 입력하세요"></textarea>
                    </div>

                    <!-- 이용 안내 섹션 (기본 상품용) -->
                    <div id="defaultInfoSection">
	                    <div class="form-section-title">
	                        <i class="bi bi-info-circle me-2"></i>이용 안내
	                    </div>
	                    <div class="row mb-3">
	                        <div class="col-md-4">
	                        	<!-- 시간을 ~로 해야될지 감이 안잡힌다 -->
	                            <label class="form-label">운영 시간 <span class="text-danger">*</span></label>
	                            <input type="text" class="form-control" name="prodInfo.prodRuntime" placeholder="예: 09:00 ~ 18:00" required>
	                        </div>
	                        <div class="col-md-4">
	                            <label class="form-label">소요 시간 <span class="text-danger">*</span></label>
	                            <input type="text" class="form-control" name="prodInfo.prodDuration" placeholder="예: 약 2시간 (실제 체험 40분)" required>
	                            <div class="form-text">고객에게 보여질 상세 소요시간을 입력하세요</div>
	                        </div>
	                        <div class="col-md-4">
	                            <label class="form-label">연령 제한</label>
	                            <input type="text" class="form-control" name="prodInfo.prodLimAge" placeholder="예: 만 10세 이상">
	                        </div>
	                    </div>
	                    <div class="row mb-3">
	                        <div class="col-md-4">
	                            <label class="form-label">최소 인원</label>
	                            <input type="number" class="form-control" name="prodInfo.prodMinPeople" placeholder="1" min="1" value="1">
	                        </div>
	                        <div class="col-md-4">
	                            <label class="form-label">최대 인원</label>
	                            <input type="number" class="form-control" name="prodInfo.prodMaxPeople" placeholder="10" min="1" max="15"/>
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
	                                    <input type="time" class="form-control" id="newBookingTime"/>
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
	                        <input type="hidden" name="bookingTimes" id="bookingTimesInput"/>	<!-- 시간 정보 저장 -->
	                    </div>
	                    <div class="row mb-3">
	                        <div class="col-md-6">
	                            <label class="form-label">포함 사항</label>
	                            <textarea class="form-control" name="prodInfo.prodInclude" rows="3" placeholder="포함되는 항목을 줄바꿈으로 구분하여 입력하세요&#10;예:&#10;전문 강사 1:1 지도&#10;장비 대여&#10;수중 사진 촬영"></textarea>
	                        </div>
	                        <div class="col-md-6">
	                            <label class="form-label">불포함 사항</label>
	                            <textarea class="form-control" name="prodInfo.prodExclude" rows="3" placeholder="포함되지 않는 항목을 줄바꿈으로 구분하여 입력하세요&#10;예:&#10;픽업/샌딩 서비스&#10;개인 물품"></textarea>
	                        </div>
	                    </div>
	                    <div class="mb-3">
	                        <label class="form-label">유의 사항</label>
	                        <textarea class="form-control" name="prodInfo.prodNotice" rows="3" placeholder="예약 및 이용 시 유의해야 할 사항을 입력하세요"></textarea>
	                    </div>
                    </div><!-- /defaultInfoSection -->


                    <!-- 숙박 전용 필드 여기에 그냥 추가를 하자 너무 김-->
                    <div id="accommodationFields" style="display: none;">
						<input type="hidden" name="accommodation.accNo"/>
                        <div class="form-section-title">
                            <i class="bi bi-building me-2"></i>숙소 정보
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label class="form-label">숙소 유형 <span class="text-danger">*</span></label>
                                <select class="form-select" name="accommodation.accCatCd">
                                    <option value="">선택하세요</option>
                                    <option value="B02010100">호텔</option>
                                    <option value="B02010500">리조트</option>
                                    <option value="B02010700">펜션</option>
                                    <option value="B02011100">게스트하우스</option>
<!--                                     <option value="motel">모텔</option>
                                    <option value="hanok">한옥</option>
                                    <option value="condo">콘도</option>
                                    <option value="camping">캠핑/글램핑</option> -->
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">등급</label>
                                <select class="form-select" name="accommodation.starGrade">
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
                                <input type="number" class="form-control" name="accommodation.totalRoomCnt" placeholder="0" min="1">
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">체크인 시간 <span class="text-danger">*</span></label>
                                <input type="time" class="form-control" name="accommodation.checkInTime">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">체크아웃 시간 <span class="text-danger">*</span></label>
                                <input type="time" class="form-control" name="accommodation.checkOutTime">
                            </div>
                        </div>

                        <div class="form-section-title">
                            <i class="bi bi-door-open me-2"></i>객실 정보
                        </div>
                        <div class="room-type-container" id="roomTypeContainer">
                        	<!-- 객실 정보 출력 -->
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
                            <!-- 추가옵션 -->
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
	                            <input type="number" class="form-control" name="prodSale.netprc" placeholder="0">
	                        </div>
	                        <div class="col-md-3">
	                            <label class="form-label">판매가 <span class="text-danger">*</span></label>
	                            <input type="number" class="form-control" name="prodSale.price" placeholder="0" required>
	                        </div>
	                        <div class="col-md-3">
	                            <label class="form-label">할인율</label>
	                            <div class="input-group">
	                                <input type="number" class="form-control" name="prodSale.discount" placeholder="0" max="100">
	                                <span class="input-group-text">%</span>
	                            </div>
	                        </div>
	                        <div class="col-md-3">
	                        <!-- 전체? 현재? -->
	                            <label class="form-label">재고 수량 <span class="text-danger">*</span></label>
	                            <div class="input-group">
	                                <input type="number" class="form-control" name="prodSale.totalStock" placeholder="0" min="1" required>
	                                <span class="input-group-text">개</span>
	                            </div>
	                        </div>
							<!--  애는 등록시애는 그냥 보내는데 totalStock이랑 같은 값으로 설정 
							그래서 처음 등록시에는 display:none -->
	                        <!-- style="display:none;" -->
	                        <div class="col-md-3 curStock" >
	                            <label class="form-label">현재 수량 <span class="text-danger">*</span></label>
	                            <div class="input-group">
	                                <input type="number" class="form-control" name="prodSale.curStock" placeholder="0" min="0" readonly required>
	                                <span class="input-group-text">개</span>
	                            </div>
	                        </div>
	                    </div>
                    </div><!-- /defaultPriceSection -->
                    
                    
<!-- 	                    <div class="mb-3">
	                        <label class="form-label">상품 이미지</label>
	                         multipart, 선택한 이미지 보여주기. attachNo에 맞는게 대표이미지. 이거에 뭔가 걸어야겠다.
	                        <input type="file" class="form-control" name="productImage" accept="image/*"  onchange="renderImageList(this)" multiple/>
	                        <input type="hidden" name="image.attachNo" />상품 이미지

	                        <div class="productImageList"></div>
	                        <div class="form-text">권장 크기: 800x600px, 최대 5MB</div>
	                    </div> -->

                    <!-- 공통 판매 기간 (숙박용) -->
                    <!-- <div id="accomDateSection" style="display: none;">
                        <div class="form-section-title">
                            <i class="bi bi-calendar-range me-2"></i>판매 기간
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">판매 시작일 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control date-picker" name="saleStartDt" placeholder="시작일 선택">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">판매 종료일 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control date-picker" name="saleEndDt" placeholder="종료일 선택">
                            </div>
                        </div>
                        <div class="mb-3" id="accomImageField">
                            <label class="form-label">상품 이미지</label>
                            <input type="file" class="form-control" name="productImageAlt" accept="image/*" multiple>
                             숙소 이미지
                            <div class="form-text" id="imageList">숙소 대표 이미지를 등록하세요 (최대 5장)</div>
                        </div>
                    </div> -->
                    
                    <!-- 공통파트 -->
                    <div id="commonSaleSection">
					    <div class="form-section-title">
					        <i class="bi bi-calendar-check me-2"></i>판매 기간 및 이미지
					    </div>
					    <div class="row mb-3">
					        <div class="col-md-6">
					            <label class="form-label">판매 시작일 <span class="text-danger">*</span></label>
					            <input type="text" class="form-control date-picker" name="saleStartDt" placeholder="시작일 선택" required>
					        </div>
					        <div class="col-md-6">
					            <label class="form-label">판매 종료일 <span class="text-danger">*</span></label>
					            <input type="text" class="form-control date-picker" name="saleEndDt" placeholder="종료일 선택" required>
					        </div>
					    </div>
                        
					    <div class="mb-3">
					        <label class="form-label">상품 이미지 <span class="text-danger">*</span></label>
					        <input type="file" class="form-control" name="mainImage" accept="image/*" onchange="renderImageList(this)" multiple />
					        <div id="mainImagePreview" class="mt-2"></div>
					        <div class="form-text">권장 크기: 800x600px, 최대 5MB</div>
					    </div>
                        <input type="hidden" name="image.attachNo" />
                        <div class="productImageList"></div>
					    
					
					    <div id="accommodationAdditionalImages" style="display: none;">
					        <label class="form-label">숙소 대표이미지</label>
<!-- 					        <input type="file" class="form-control" name="" accept="image/*" onchange="renderSubImagesPreview(this)"/> -->
							<img alt="객실" src="accommodation.accFilePath">
					        <label class="form-label">숙소 이미지</label>
<!-- 					        <input type="file" name="accommodation.accFileNo" accept="image/*" multiple/> -->
					        <div id="subImagesPreview" class="productImageList mt-2"></div>
					    </div>
					</div>
                    
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="register" onclick="saveProduct(this)">등록</button>
                <button type="button" class="btn btn-primary" id="update" onclick="saveProduct(this)" style="display: none;">수정</button>
            </div>
        </div>
    </div>
</div>

<!-- 상세 조회도 모달로? -->

<c:set var="hasInlineScript" value="true" />
<!-- 다음 주소 검색 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- 카카오맵 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=0a4b8e6c128016aa0df7300b3ab799f1&libraries=services&autoload=false"></script>
<%@ include file="../common/footer.jsp" %>


<script>
let modal = null;			// 모달 객체
let bookingTimes = [];		// 예약 가능 시간 목록
let imageList = [];			// 이미지 정보 목록

let timeListContainer;		// 예약가능시간 출력란
let imageContainer;			// 사진출력란
let roomTypeContainer;		// 숙소 타입 출력란
let addonOptionsContainer; 	// 추가 옵션 출력란
let category;				// 카테고리

let startDatePicker;
let endDatePicker;

document.addEventListener('DOMContentLoaded', function() {
	const modalElem = document.getElementById('productModal');
    if (modalElem) modal = new bootstrap.Modal(modalElem);
	
    // 컨테이너 지정
	timeListContainer = document.getElementById('bookingTimeList');
	imageContainer = document.querySelector(".productImageList");
	roomTypeContainer = document.getElementById('roomTypeContainer');
	addonOptionsContainer = document.getElementById('addonOptionsContainer');
	
	// 카테고리 
	category = document.getElementById('productCategory');
	
	const startDateInput = document.querySelector('input[name="startDate"]');
	const endDateInput = document.querySelector('input[name="endDate"]');
	
	// endDate는 그걸로
	if (startDateInput && typeof flatpickr !== 'undefined') {
	    startDatePicker = flatpickr(startDateInput, {
	        locale: 'ko',
	        dateFormat: 'Y-m-d',
	        minDate: 'today',
	        disableMobile: true,
	        onChange: function(selectedDates) {
	            if (selectedDates.length > 0 && endDatePicker) endDatePicker.set('minDate', selectedDates[0]);
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
	
	// 초기화
    updateSelectedCount();
});

// 새 상품 등록 모달 설정
function setModalForNew() {
    document.getElementById('productModalTitle').textContent = '새 상품 등록';
	document.querySelector("#register").style.display = "block";
	document.querySelector("#update").style.display = "none";
	
    document.getElementById('productForm').reset();
    
    if (startDatePicker) startDatePicker.clear();
    if (endDatePicker) {
        endDatePicker.clear();
        endDatePicker.set('minDate', 'today');
    }
    
    // 예약 시간 초기화
    bookingTimes = [];
    renderBookingTimes();
    // 카테고리 필드 초기화
    toggleCategoryFields();
    // 객실 타입, 추가 옵션 인덱스 초기화
    roomTypeIndex = 1;
    addonOptionIndex = 1;
}

// 상품 수정 모달 설정
async function editProduct(data) {
	const { id, no } = data.dataset;	// tripProdNo랑 accNo
	console.log("editProduct : id, no" +  id  + " " + no);
	
	timeListContainer.innerHTML = ``;
	imageContainer.innerHTML = ``;
	roomTypeContainer.innerHTML = ``;
	
	bookingTimes = [];
	imageList = [];
	
	// 정보를 불러와야지
	try {
		const requestData = {tripProdNo: id}; 
		if (no != 0)  requestData.accNo = no;
		
        const response = await axios.post(`/product/manage/productDetail`, requestData);
        const data = response.data;
        console.log("data : ", data);
        
        // 미리 세팅
        category.value = data.prodCtgryType;
		toggleCategoryFields();
        
		// 숙박 타입일때 그만큼 방 만들기
		// 빈 폼 생성 (이 함수 안에서 name이 순서대로 부여되어야 함)
		if (data.prodCtgryType === 'accommodation' && data.accommodation) {
	        const acc = data.accommodation;

	        // 방 목록 동적 생성 및 매핑 (prefix 없이 roomTypeList[index]... 로 바로 꽂음)
	        if (acc.roomTypeList && acc.roomTypeList.length > 0) {
	            acc.roomTypeList.forEach(() => addRoomType());
	            renderProductData({ roomTypeList: acc.roomTypeList });
	        }
	        acc.roomTypeList = null;

	        // 숙소 상세 정보 매핑 (name="accommodation.addr1" 등)
	        renderProductData(acc, "accommodation");
	        
	        // [중요] 이미 처리한 객체는 원본에서 참조 제거 (무한루프 및 중복매핑 방지)
	        data.accommodation = null; 
	    }
		
		// 시간 담기
        if(data.prodTimeList && data.prodTimeList.length > 0){
        	bookingTimes = data.prodTimeList.map(time => time.rsvtAvailableTime);
        	renderBookingTimes();
        	data.prodTimeList = null;
        }
        
		// 사진 담기
        if(data.imageList && data.imageList.length > 0 ){
        	imageList = [...data.imageList];	// 여기서 꺼내서 쓰자
        	renderImageList();
        	data.imageList = null;
        }
        
		renderProductData(data);	// 상품 불러오기
		
		// 6. [추가] 화면용 주소창 동기화 (Hidden 필드 말고 검색창에 보여주기)
// 		if (data.prodCtgryType === 'accommodation' && data.accommodation) {
//             document.getElementById('productAddress').value = data.accommodation.addr1 || '';
//             // 주소가 있다면 지도도 바로 띄워주기 (선택사항)
//             if(data.accommodation.addr1) {
//                 setTimeout(() => showMapForAcc(data.accommodation.addr1), 500);
//             }
//         } else if (data.prodPlace) {
//             document.getElementById('productAddress').value = data.prodPlace.addr1 || '';
//         }
		
        document.getElementById('productModalTitle').textContent = '상품 수정';
		document.querySelector("#update").style.display = "block";
		document.querySelector("#register").style.display = "none";
        
		// 방 수만큼 넣어야됨
		modal.show()
//         setTimeout(() => {modal.show()}, 300);
    } catch (error) {
        console.error("데이터 로드 중 error 발생: ", error);
    }
}

// 수정할 상품 사진 modal에 세팅 - imageData는 선택시 썸네일 보여주려고
function renderImageList(imageData = ""){
	// imageList = 5개까지만 가능
// 	console.log("imageData : ", imageData.files[0]);	// 이래야 사진 정보 볼수 있다. - 왜냐면 얘는 list타입의 객체? File이라는 객체여서
// 	const form = new FormData(imageData.value);
// 	console.log("form : ", form);
	
	let html = ``;
	if(imageList.length >= 5){
		showToast("사진은 5개까지만 가능합니다!!", "error");
		return;
	}
	
	if(imageData !== "" && imageList.length < 5) imageList.push(imageData);
		
	imageContainer.innerHTML = '';
    if (imageList.length === 0) {
    	html = `<div>사진이 없습니다</div>`; 
    	return imageContainer.innerHTML = html;
    }
    else {
        html = imageList.map((image, index) => {
//         	if({image})	// 사진은 담기면 어떻게 될까요??
            return `<img src="${pageContext.request.contextPath}/upload/product/\${image.filePath}" 
                alt="\${image.tripProdTitle}" id="image\${index}">`
        }).join('');
        if (imageList[0].attachNo !== null) document.querySelector("input[name='image.attachNo']").value = imageList[0].attachNo;
        imageContainer.innerHTML += html;
    }
    // hidden input에 JSON으로 저장
//     console.log("JSON.stringify(imageList) : ", JSON.stringify(imageList));
//     document.getElementById(' ').value = imageList;
// 사진정보는 어떻게 hidden 에 넣어말어
}

// 수정할 상품 정보 modal에 세팅
function renderProductData(data, prefix = ""){
	if (!data) return;
	
    Object.keys(data).forEach(key => {
        const value = data[key];
        const nameAttr = prefix ? `\${prefix}.\${key}` : key;
        console.log("nameAttr : , ", nameAttr, ",  key  : ", key);
        
        if (key === "roomTypeList" && Array.isArray(value)) {
            value.forEach((room, index) => {
                // 이미 addRoomType()으로 생성된 행에 값을 채움
                renderProductData(room, `roomTypeList[\${index}]`);
            });
            return;
        }
        
        if (value !== null && typeof value === 'object' && key !== "prodTimeList") {	// key가 prodTimeList일때 value는 object
            // value가 객체(prodSale, prodInfo 등)인 경우 재귀 호출
            console.log("object key : ", key);
            renderProductData(value, nameAttr);
        } else {
            // 실제 DOM 요소 찾기
            const tag = document.querySelector(`[name="\${nameAttr}"]`);
            
            if (tag) {
                if (tag.type === 'checkbox') tag.checked = value === 'Y';
                else if(key === "saleStartDt" || key === "saleEndDt"){
                	let dateSet = data[key].split("T");
                	tag.value = dateSet[0];
                }  
                else tag.value = value ?? '';	  // 일반 text, number, hidden 등 value가 null이나 undefined일 경우는 ''가 된다
            }
        }
    });
}

// 상품 저장 - insert / update(문구에 따라서)
async function saveProduct(data) {
    console.log("svae data : ", data.innerText);	// 이거에 따른 등록 수정 여부
    
    const form = document.getElementById('productForm');
    
    const formData = new FormData(form);	// key value 구조
	
    // update
    if(data.innerText === "수정"){
		const res = await axios.post(`/business/product/editProduct`, formData);
   		console.log("saveProduct res.data : " + res.data);
   		if(res.data == "OK") showToast('상품 정보 수정이 완료되었습니다.', 'success');
   		else showToast('상품 정보 수정에 실패했습니다.', 'warning');	
    } 
    
    // insert 구현해야된다
    else {
		const res = await axios.post(`/business/product/insert`, formData);
   		console.log("saveProduct res.data : " + res.data);
   		if(res.data == "OK") showToast('상품 정보 수정이 완료되었습니다.', 'success');
   		else showToast('상품 정보 수정에 실패했습니다.', 'warning');	
    }
    
    if (modal) modal.hide();
}

// 상품 상태 변경 - update
function toggleProductStatus(data) {
	const { id, status } = data.dataset;
	
    if (confirm('상품 상태를 변경하시겠습니까?')) {
        axios.post(`/business/product/changeProductStatus`, {
        	tripProdNo : id,
        	approveStatus : status
        })
        .then(res => {
        	if (res.data.ok) {
        		showToast('상품 상태가 변경되었습니다.', 'success');
		        location.reload();
        	}
        	else showToast('상품 상태가 변경되었습니다.', 'success');
        }).catch(err => {
        	console.log("error 발생 : ", err);
        });
    }
}

// 상품 삭제
function deleteProduct(data) {
	const { id } = data.dataset;
    if (confirm('정말 삭제하시겠습니까?\n삭제된 상품은 복구할 수 없습니다.')) {
        axios.post(`/business/product/removeProduct`, {
        	tripProdNo : id
        })
        .then(res => {
        	if (res.data.ok) {
        		showToast('상품이 삭제되었습니다.', 'success');
		        location.reload();
        	}
        	else showToast('상품이 삭제되지않았습니다.', 'error');
        }).catch(err => {
        	console.log("error 발생 : ", err);
        });
    }
}

// 필터링 - 검색(스크립트로)
function filterProducts() {
    // 스크립트
}

// ==================== 예약 가능 시간 관리 ====================
// 시간 추가 - 수정시 받은 데이터 만큼 넣기
function addBookingTime(getTime = "") {
    const timeInput = document.getElementById('newBookingTime');
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
    bookingTimes = bookingTimes.filter(t => t !== time);
    renderBookingTimes();
}

// 시간 목록 렌더링 - 여기서 데이터 받자
function renderBookingTimes() {

    if (bookingTimes.length === 0) timeListContainer.innerHTML = '';
    else {
        var html = bookingTimes.map(time => {
            let displayTime = ""; // 24시간 형식을 보기 좋게 변환
            if (time.length > 5) displayTime = formatTime(time);
            return `<span class="booking-time-slot">
                       <i class="bi bi-clock"></i>\${displayTime === "" ? time : displayTime}
                       <button type="button" class="remove-time" onclick="removeBookingTime('\${time}')">
                           <i class="bi bi-x"></i>
                       </button>
                   </span>`;
        }).join('');
        timeListContainer.innerHTML = html;
    }
    // hidden input에 JSON으로 저장
    document.getElementById('bookingTimesInput').value = bookingTimes.join(',');
    // JSON.stringify(bookingTimes) 시간 정보만 담김 -> rsvtAvailableTime이거에 매칭 시켜야됨
}

// 시간 포맷 변환 (HH:MM -> 오전/오후 표시)
function formatTime(time) {
    const parts = time.split(':');
    const hour = parseInt(parts[0]);
    const minute = parts[1];
    const period = hour < 12 ? '오전' : '오후';
    const displayHour = hour === 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return period + ' ' + displayHour + ':' + minute;
}

// 프리셋 시간 추가
function addPresetTimes(type) {
    var presets = {
        'morning': ['09:00', '10:00', '11:00'],
        'afternoon': ['13:00', '14:00', '15:00', '16:00'],
        'hourly': ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00']
    };
	
    let runTime = document.querySelector("input[name='prodInfo.prodRuntime']");
    console.log("runTime : ", runTime.value);
    
    var times = presets[type] || [];
    var addedCount = 0;
	
    // 운영 시간 내의 유효 시간만 담기
//     times.filter(time => { });
    times.forEach(time => {
        if (!bookingTimes.includes(time)) {
            bookingTimes.push(time);
            addedCount++;
        }
    });

    if (addedCount > 0) {
        bookingTimes.sort();
        renderBookingTimes();
        showToast(addedCount + '개의 시간이 추가되었습니다.', 'success');
    } else showToast('추가할 새 시간이 없습니다.', 'info');
}

// 주소 검색 (카카오 주소 API)
function searchAddress() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 주소 정보 설정
            const address = data.roadAddress || data.jibunAddress;
            document.getElementById('productAddress').value = address;

            // 좌표 검색 (카카오 맵 API) - 이건 천천히
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
    productCheckboxes.forEach((cb) => {
        cb.checked = checkbox.checked;
        var productCard = cb.closest('.product-manage-card');
        if (checkbox.checked) productCard.classList.add('selected');
        else productCard.classList.remove('selected');
    });
    updateSelectedCount();
}

// 개별 체크박스 클릭 시
function toggleProductSelect(checkbox) {
    var productCard = checkbox.closest('.product-manage-card');
    if (checkbox.checked) productCard.classList.add('selected');
    else productCard.classList.remove('selected');

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
    var actionButtons = document.querySelectorAll('#selectionActions .btn');	// 선택 상품 상태 변경, 삭제, 재게
    actionButtons.forEach(btn => btn.disabled = count === 0);
}

// 선택된 상품 ID 목록 가져오기
function getSelectedProductIds() {
	var checkedCheckboxes = document.querySelectorAll('.product-select-checkbox:checked');
    const ids = [];	// 
// 	    console.log("getSelectedProductIds id", cb.value);
    // approved 상태도 바꿔야될듯
    checkedCheckboxes.forEach(cb => ids.push(cb.value));
    return ids;
}

// 선택 상품 중지
function pauseSelectedProducts() {
	// status 바구기
    var selectedIds = getSelectedProductIds();
    if (selectedIds.length === 0) {
        if (typeof showToast === 'function') showToast('선택된 상품이 없습니다.', 'warning');
        return;
    }

    if (!confirm(selectedIds.length + '개의 상품을 중지하시겠습니까?')) return;

    // 선택된 상품들의 상태를 중지로 변경 (UI 업데이트)
    selectedIds.forEach(id => {
        var checkbox = document.querySelector('.product-select-checkbox[value="' + id + '"]');
        if (checkbox) {
            var productCard = checkbox.closest('.product-manage-card');
            var statusBadge = productCard.querySelector('.product-status');
            if (statusBadge && statusBadge.classList.contains('active')) {
                statusBadge.className = 'product-status inactive';
                statusBadge.textContent = '판매중지';
                productCard.classList.add('inactive');
                productCard.setAttribute('data-status', 'inactive');
            }
        }
    });

    // 선택 해제
    clearProductSelection();
    showToast(selectedIds.length + '개의 상품이 중지되었습니다.', 'success');

    // 통계 업데이트
    updateProductStats();
}

// 선택 상품 재개
function resumeSelectedProducts() {
    var selectedIds = getSelectedProductIds();
    if (selectedIds.length === 0) {
        if (typeof showToast === 'function') showToast('선택된 상품이 없습니다.', 'warning');
        return;
    }

    if (!confirm(selectedIds.length + '개의 상품을 재개하시겠습니까?')) return;
	// 변경함수 
    
    // 선택된 상품들의 상태를 판매중으로 변경 (UI 업데이트)
    selectedIds.forEach(id => {
        var checkbox = document.querySelector('.product-select-checkbox[value="' + id + '"]');
        if (checkbox) {
            var productCard = checkbox.closest('.product-manage-card');
            var statusBadge = productCard.querySelector('.product-status');
            if (statusBadge && statusBadge.classList.contains('inactive')) {
                statusBadge.className = 'product-status active';
                statusBadge.textContent = '판매중';
                productCard.classList.remove('inactive');
                productCard.setAttribute('data-status', 'active');
            }
        }
    });

    // 선택 해제
    clearProductSelection();
    showToast(selectedIds.length + '개의 상품이 재개되었습니다.', 'success');

    // 통계 업데이트
    updateProductStats();
}

// 선택 상품 삭제
function deleteSelectedProducts() {
    var selectedIds = getSelectedProductIds();
    if (selectedIds.length === 0) {
        if (typeof showToast === 'function') showToast('선택된 상품이 없습니다.', 'warning');
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
            var productCard = checkbox.closest('.product-manage-card');
            productCard.style.transition = 'opacity 0.3s, transform 0.3s';
            productCard.style.opacity = '0';
            productCard.style.transform = 'translateX(-20px)';
            setTimeout(function() {
                productCard.remove();
                updateProductStats();
            }, 300);
        }
    });

    // 선택 해제
    clearProductSelection();

	showToast(deleteCount + '개의 상품이 삭제되었습니다.', 'success');
}

// 선택 해제
function clearProductSelection() {
    var allCheckboxes = document.querySelectorAll('.product-select-checkbox');
    allCheckboxes.forEach(function(cb) {
        cb.checked = false;
        var productCard = cb.closest('.product-manage-card');
        if (productCard) productCard.classList.remove('selected');
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
    var allProducts = document.querySelectorAll('.product-manage-card');
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

// ==================== 카테고리별 필드 전환 ====================
function toggleCategoryFields() {
    // 기본 섹션들
    const regionField = document.getElementById('regionField');
    const durationField = document.getElementById('durationField');
    const descriptionField = document.getElementById('descriptionField');
    const defaultInfoSection = document.getElementById('defaultInfoSection');
    const defaultPriceSection = document.getElementById('defaultPriceSection');
    const productNameField = document.getElementById('productNameField');
    const locationField = document.getElementById('locationField');
	
    // 숙박 섹션들
    const accommodationFields = document.getElementById('accommodationFields');
//     const accomImageField = document.getElementById('accomImageField');
	const accommodationAdditionalImages = document.getElementById('accommodationAdditionalImages');	// 숙박에서만 보여줄것
    
    // 일반 정보 섹션 제어
    
    // 모든 섹션 초기화 (숨기기)
    accommodationFields.style.display = 'none';
    accommodationAdditionalImages.style.display = 'none';
    
    if (category.value === 'accommodation') {
        // 숙박 선택 시
        productNameField.style.display = 'block';
        locationField.style.display = 'block';
        regionField.style.display = 'block';
        durationField.style.display = 'none';
        descriptionField.style.display = 'block';  // 숙소 소개 표시
        defaultInfoSection.style.display = 'none';
        defaultPriceSection.style.display = 'none';

        accommodationFields.style.display = 'block';
//         accomImageField.style.display = 'block';
	    accommodationAdditionalImages.style.display = 'block';
    } else {
        // 기본 상품 (이외의 상품)
        productNameField.style.display = 'block';
        locationField.style.display = 'block';
        regionField.style.display = 'block';
        durationField.style.display = 'block';
        descriptionField.style.display = 'block';
        defaultInfoSection.style.display = 'block';
        defaultPriceSection.style.display = 'block';
        
	    accommodationAdditionalImages.style.display = 'none';
    }
}

// ==================== 객실 타입 관리 ====================
function addRoomType() {
	// 처음에는 아무것도 없기에 0부터 시작
	const index = roomTypeContainer.children.length;
	// 객실 타입 \${index + 1}은 화면에만 보여지는 것
	
    const roomHtml =
        `<div class="room-type-item" data-room-index="\${index}">
            <div class="room-type-header">
                <h6><i class="bi bi-door-closed me-2"></i>객실 타입 \${index + 1}</h6>
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeRoomType('\${index}')">
                    <i class="bi bi-x"></i> 삭제
                </button>
            </div>
            <input type="hidden" name="roomTypeList[\${index}].roomTypeNo" />
            <div class="row mb-3">
                <div class="col-md-4">
                    <label class="form-label">객실명 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="roomTypeList[\${index}].roomName" placeholder="예: 디럭스 트윈">
                </div>
                <div class="col-md-4">
                    <label class="form-label">기준 인원 <span class="text-danger">*</span></label>
                    <input type="number" class="form-control" name="roomTypeList[\${index}].baseGuestCount" placeholder="2" min="1">
                </div>
                <div class="col-md-4">
                    <label class="form-label">최대 인원</label>
                    <input type="number" class="form-control" name="roomTypeList[\${index}].maxGuestCount" placeholder="4" min="1">
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-md-3">
                    <label class="form-label">1박 가격 <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <input type="number" class="form-control" name="roomTypeList[\${index}].price" placeholder="0">
                        <span class="input-group-text">원</span>
                    </div>
                </div>
                <div class="col-md-2">
                    <label class="form-label">할인율</label>
                    <div class="input-group">
                        <input type="number" class="form-control" name="roomTypeList[\${index}].discount" placeholder="0" min="0" max="100">
                        <span class="input-group-text">%</span>
                    </div>
                </div>
                <div class="col-md-2">
                    <label class="form-label">잔여 객실 <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <input type="number" class="form-control" name="roomTypeList[\${index}].totalRoomCount" placeholder="0" min="0">
                        <span class="input-group-text">실</span>
                    </div>
                </div>
                <div class="col-md-2">
                    <label class="form-label">객실 크기</label>
                    <div class="input-group">
                        <input type="number" class="form-control" name="roomTypeList[\${index}].roomSize" placeholder="0">
                        <span class="input-group-text">㎡</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <label class="form-label">조식 포함</label>
                    <select class="form-select" name="roomBreakfast">
                        <option value="none">조식 미포함</option>
                        <option value="included">조식 포함</option>
                    </select>
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label">침대 타입</label>
                <div class="form-check-group">
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" name="roomTypeList[\${index}].bedType" value="single" id="bedSingle">
                        <label class="form-check-label" for="bedSingle">싱글</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" name="bedType" value="double" id="bedDouble">
                        <label class="form-check-label" for="bedDouble">더블</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" name="bedType" value="queen" id="bedQueen">
                        <label class="form-check-label" for="bedQueen">퀸</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" name="bedType" value="king" id="bedKing">
                        <label class="form-check-label" for="bedKing">킹</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" name="bedType" value="ondol" id="bedOndol">
                        <label class="form-check-label" for="bedOndol">온돌</label>
                    </div>
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label">객실 특징</label>
                <div class="room-features-grid">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="roomFeature" value="free_cancel" id="featureFreeCancel">
                        <label class="form-check-label" for="featureFreeCancel"><i class="bi bi-check-circle me-1"></i>무료 취소</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="roomFeature" value="ocean_view" id="featureOceanView">
                        <label class="form-check-label" for="featureOceanView"><i class="bi bi-water me-1"></i>오션뷰</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="roomFeature" value="mountain_view" id="featureMountainView">
                        <label class="form-check-label" for="featureMountainView"><i class="bi bi-mountain me-1"></i>마운틴뷰</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="roomFeature" value="city_view" id="featureCityView">
                        <label class="form-check-label" for="featureCityView"><i class="bi bi-buildings me-1"></i>시티뷰</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="roomFeature" value="living_room" id="featureLivingRoom">
                        <label class="form-check-label" for="featureLivingRoom"><i class="bi bi-door-open me-1"></i>거실 포함</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="roomFeature" value="balcony" id="featureBalcony">
                        <label class="form-check-label" for="featureBalcony"><i class="bi bi-flower1 me-1"></i>발코니/테라스</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="roomFeature" value="no_smoking" id="featureNoSmoking">
                        <label class="form-check-label" for="featureNoSmoking"><i class="bi bi-slash-circle me-1"></i>금연</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="roomFeature" value="kitchen" id="featureKitchen">
                        <label class="form-check-label" for="featureKitchen"><i class="bi bi-cup-hot me-1"></i>주방/취사</label>
                    </div>
                </div>
            </div>
        </div>`;

    roomTypeContainer.insertAdjacentHTML('beforeend', roomHtml);

    // 첫 번째 객실 삭제 버튼 표시 (2개 이상일 때)
    updateRoomDeleteButtons();

	showToast('객실 타입이 추가되었습니다.', 'success');
}

// 선택 객실 삭제 -> 여기도 예약 고객 있는지 확인해서 삭제해야됨
// 삭제시 인덱스도 줄어들게 만들어야되고
function removeRoomType(index) {
    var roomItem = document.querySelector('.room-type-item[data-room-index="' + index + '"]');
    if (roomItem) {
        roomItem.style.transition = 'opacity 0.3s, transform 0.3s';
        roomItem.style.opacity = '0';
        roomItem.style.transform = 'translateX(-20px)';
        setTimeout(function() {
            roomItem.remove();
            updateRoomDeleteButtons();
        }, 300);
    }
}

// 여기서 삭제 버트 만듬
function updateRoomDeleteButtons() {
    var roomItems = document.querySelectorAll('.room-type-item');
    roomItems.forEach((item, idx) => {
        var deleteBtn = item.querySelector('.btn-outline-danger');
        if (deleteBtn) deleteBtn.style.display = roomItems.length > 1 ? 'block' : 'none';
    });
}

// ==================== 추가 옵션 관리 ====================
var addonOptionIndex = 1;

// 추가옵션 수 만큼 그거 하자
function addAddonOption() {
    var index = addonOptionIndex++;

    var addonHtml =
        `<div class="addon-option-item" data-addon-index="\${index}">
            <div class="row">
                <div class="col-md-5">
                    <label class="form-label">옵션명</label>
                    <input type="text" class="form-control" name="addonName" placeholder="예: 레이트 체크아웃">
                </div>
                <div class="col-md-2">
                    <label class="form-label">인원</label>
                    <div class="input-group">
                        <input type="number" class="form-control" name="addonPerson" placeholder="0" min="0" value="0">
                        <span class="input-group-text">명</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <label class="form-label">가격</label>
                    <div class="input-group">
                        <input type="number" class="form-control" name="addonPrice" placeholder="0">
                        <span class="input-group-text">원</span>
                    </div>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="button" class="btn btn-outline-danger w-100" onclick="removeAddonOption('\${index}')">
                        <i class="bi bi-x"></i>
                    </button>
                </div>
            </div>
        </div>`;

	addonOptionsContainer.insertAdjacentHTML('beforeend', addonHtml);

    // 첫 번째 추가 옵션에 삭제 버튼 표시 (2개 이상일 때)
    updateAddonDeleteButtons();
	showToast('추가 옵션이 추가되었습니다.', 'success');
}

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

function updateAddonDeleteButtons() {
    var addonItems = document.querySelectorAll('.addon-option-item');
    addonItems.forEach(function(item, idx) {
        var deleteBtn = item.querySelector('.btn-outline-danger');
        if (deleteBtn) deleteBtn.style.display = addonItems.length > 1 ? 'block' : 'none';
    });
}
</script>
</body>
</html>