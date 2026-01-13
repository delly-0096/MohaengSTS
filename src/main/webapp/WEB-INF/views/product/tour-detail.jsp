<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="${tp.tripProdTitle}" />
<c:set var="pageCss" value="product" />
<%-- 줄바꿈 문자 정의 --%>
<% pageContext.setAttribute("newline", "\n"); %>

<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/tour-detail.css">

<div class="product-detail-page">
    <div class="container">
        <!-- 브레드크럼 -->
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/">홈</a>
            <span class="mx-2">/</span>
            <a href="${pageContext.request.contextPath}/tour">투어/체험/티켓</a>
            <span class="mx-2">/</span>
            <span>${tp.tripProdTitle}</span>
        </nav>

        <!-- 갤러리 -->
        <div class="product-gallery">
            <div class="gallery-main">
                <img src="https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800&h=500&fit=crop&q=80"
                     alt="스쿠버다이빙" id="mainImage">
            </div>
            <div class="gallery-thumbs">
                <img src="https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=200&h=150&fit=crop&q=80"
                     alt="스쿠버다이빙" onclick="changeMainImage(this)">
                <img src="https://images.unsplash.com/photo-1682687220742-aba13b6e50ba?w=200&h=150&fit=crop&q=80"
                     alt="스쿠버다이빙" onclick="changeMainImage(this)">
            </div>
        </div>

        <div class="product-detail-content">
            <!-- 상품 정보 -->
            <div class="product-info">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <span class="badge bg-primary">
                    	<c:choose>
					        <c:when test="${tp.prodCtgryType eq 'tour'}">투어</c:when>
					        <c:when test="${tp.prodCtgryType eq 'activity'}">액티비티</c:when>
					        <c:when test="${tp.prodCtgryType eq 'ticket'}">입장권/티켓</c:when>
					        <c:when test="${tp.prodCtgryType eq 'class'}">클래스/체험</c:when>
					        <c:when test="${tp.prodCtgryType eq 'transfer'}">교통/이동</c:when>
					        <c:otherwise>${tp.prodCtgryType}</c:otherwise>
					    </c:choose>
                    </span>
                    <c:if test="${not empty sessionScope.loginMember && sessionScope.loginMember.memType ne 'BUSINESS'}">
                    <button class="report-btn" onclick="openReportModal('product', '${tp.tripProdNo}', '${tp.tripProdTitle}')">
                        <i class="bi bi-flag"></i> 신고
                    </button>
                    </c:if>
                </div>
                <h1>${tp.tripProdTitle}</h1>

                <div class="product-meta">
                    <span><i class="bi bi-geo-alt"></i> ${tp.ctyNm}</span>
                    <span><i class="bi bi-clock"></i> 
						<c:choose>
					        <c:when test="${sale.leadTime eq 1}">1시간 이내</c:when>
					        <c:when test="${sale.leadTime eq 3}">1~3시간</c:when>
					        <c:when test="${sale.leadTime eq 6}">3~6시간</c:when>
					        <c:when test="${sale.leadTime eq 24}">하루 이상</c:when>
					        <c:otherwise>${sale.leadTime}</c:otherwise>
					    </c:choose>
					</span>
                    <span><i class="bi bi-star-fill text-warning"></i> ${reviewStat.avgRating > 0 ? reviewStat.avgRating : '-'} (${reviewStat.reviewCount} 리뷰)</span>
                </div>

                <!-- 상품 설명 -->
                <div class="product-description">
                    <h3>상품 소개</h3>
                    <p class="preserve-line">
                        ${tp.tripProdContent}
                    </p>
                </div>

                <!-- 포함/불포함 -->
				<div class="product-description">
				    <h3>포함 사항</h3>
				    <c:choose>
				        <c:when test="${not empty info.prodInclude}">
				            <ul class="include-list mb-4">
				                <c:forTokens items="${info.prodInclude}" delims="${newline}" var="item">
				                    <c:if test="${not empty fn:trim(item)}">
				                        <li><i class="bi bi-check-circle text-success me-2"></i>${fn:trim(item)}</li>
				                    </c:if>
				                </c:forTokens>
				            </ul>
				        </c:when>
				        <c:otherwise>
				            <p class="text-muted">포함 사항 정보가 없습니다.</p>
				        </c:otherwise>
				    </c:choose>
				
				    <h3>불포함 사항</h3>
				    <c:choose>
				        <c:when test="${not empty info.prodExclude}">
				            <ul class="exclude-list">
				                <c:forTokens items="${info.prodExclude}" delims="${newline}" var="item">
				                    <c:if test="${not empty fn:trim(item)}">
				                        <li><i class="bi bi-x-circle text-danger me-2"></i>${fn:trim(item)}</li>
				                    </c:if>
				                </c:forTokens>
				            </ul>
				        </c:when>
				        <c:otherwise>
				            <p class="text-muted">불포함 사항 정보가 없습니다.</p>
				        </c:otherwise>
				    </c:choose>
				</div>

                <!-- 이용 안내 -->
				<div class="product-description">
				    <h3>이용 안내</h3>
				    <div class="row">
				        <c:if test="${not empty info.prodRuntime}">
				        <div class="col-md-6">
				            <p><strong>운영 시간</strong></p>
				            <p class="text-muted">${info.prodRuntime}</p>
				        </div>
				        </c:if>
				        <c:if test="${not empty info.prodDuration}">
				        <div class="col-md-6">
				            <p><strong>소요 시간</strong></p>
				            <p class="text-muted">${info.prodDuration}</p>
				        </div>
				        </c:if>
				        <c:if test="${not empty info.prodMinPeople}">
				        <div class="col-md-6">
				            <p><strong>최소 인원</strong></p>
				            <p class="text-muted">${info.prodMinPeople}명</p>
				        </div>
				        </c:if>
				        <c:if test="${not empty info.prodMaxPeople}">
				        <div class="col-md-6">
				            <p><strong>최대 인원</strong></p>
				            <p class="text-muted">${info.prodMaxPeople}명</p>
				        </div>
				        </c:if>
				        <c:if test="${not empty info.prodLimAge}">
				        <div class="col-md-6">
				            <p><strong>연령 제한</strong></p>
				            <p class="text-muted">${info.prodLimAge}</p>
				        </div>
				        </c:if>
				    </div>
				</div>
				
				<!-- 유의사항 -->
				<c:if test="${not empty info.prodNotice}">
				<div class="product-description notice-section">
				    <h3><i class="bi bi-exclamation-triangle-fill text-warning me-2"></i>유의사항</h3>
				    <ul class="notice-list">
				        <c:forTokens items="${info.prodNotice}" delims="${newline}" var="item">
				            <c:if test="${not empty fn:trim(item)}">
				                <li><i class="bi bi-dot"></i>${fn:trim(item)}</li>
				            </c:if>
				        </c:forTokens>
				    </ul>
				</div>
				</c:if>

                <!-- 위치 -->
                <div class="product-description" style="border-bottom: none;">
                    <h3>위치</h3>
                    <p><i class="bi bi-geo-alt me-2"></i>제주특별자치도 서귀포시 중문관광로 123</p>
                    <div class="bg-light rounded-3 p-4 text-center" style="height: 200px;">
                        <i class="bi bi-map" style="font-size: 48px; color: var(--gray-medium);"></i>
                        <p class="mt-2 text-muted">지도가 표시됩니다</p>
                    </div>
                </div>
            </div>

            <!-- 결제 사이드바 -->
            <aside class="booking-sidebar">
                <div class="booking-card">
                    <div class="booking-price">
                        <c:if test="${sale.netprc != null && sale.netprc > sale.price}">
					        <span class="original"><fmt:formatNumber value="${sale.netprc}" pattern="#,###"/>원</span>
					    </c:if>
                        <div>
                            <span class="price"><fmt:formatNumber value="${sale.price}" pattern="#,###"/></span>
        					<span class="per-person">원 / 1인</span>
                        </div>
                    </div>

                    <form class="booking-form" id="bookingForm">
                        <div class="form-group">
                            <label class="form-label">날짜 선택</label>
                            <input type="text" class="form-control date-picker" id="bookingDate"
                                   placeholder="날짜를 선택하세요" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">시간 선택</label>
                            <select class="form-control form-select" id="bookingTime" required>
                                <option value="">시간을 선택하세요</option>
                                <option value="09:00">09:00</option>
                                <option value="10:00">10:00</option>
                                <option value="11:00">11:00</option>
                                <option value="14:00">14:00</option>
                                <option value="15:00">15:00</option>
                                <option value="16:00">16:00</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">인원 선택</label>
                            <select class="form-control form-select" id="bookingPeople" onchange="updateTotal()">
                                <option value="1">1명</option>
                                <option value="2" selected>2명</option>
                                <option value="3">3명</option>
                                <option value="4">4명</option>
                            </select>
                        </div>

                        <div class="booking-total">
                            <span class="booking-total-label">총 금액</span>
                            <span class="booking-total-price" id="totalPrice">0원</span>
                        </div>

                        <div class="booking-actions">
                            <c:if test="${sessionScope.loginMember.memType ne 'BUSINESS'}">
                            <button type="button" class="btn btn-outline w-100" onclick="addToBookmark()">
                                <i class="bi bi-bookmark me-2"></i>북마크
                            </button>
                            <button type="button" class="btn btn-outline-primary w-100" onclick="addToCartFromDetail()">
                                <i class="bi bi-cart-plus me-2"></i>장바구니
                            </button>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-credit-card me-2"></i>바로 결제
                            </button>
                            </c:if>
                            <c:if test="${sessionScope.loginMember.memType eq 'BUSINESS'}">
                            <div class="business-notice mt-2">
                                <small class="text-muted"><i class="bi bi-info-circle me-1"></i>기업회원은 구매가 불가합니다.</small>
                            </div>
                            </c:if>
                        </div>
                    </form>
                </div>
            </aside>
        </div>

		<!-- 리뷰 섹션 -->
		<div class="review-section mt-5">
		    <div class="review-header">
		        <h3><i class="bi bi-star me-2"></i>리뷰 (${reviewStat.reviewCount})</h3>
		        <div class="review-summary">
		            <div class="review-score">
		                <span class="score">${reviewStat.avgRating > 0 ? reviewStat.avgRating : '-'}</span>
		                <div class="stars">
		                    <c:set var="rating" value="${reviewStat.avgRating != null ? reviewStat.avgRating : 0}" />
		                    <fmt:parseNumber var="fullStars" value="${rating}" integerOnly="true" />
		                    <c:set var="decimal" value="${rating - fullStars}" />
		                    
		                    <c:forEach begin="1" end="5" var="i">
		                        <c:choose>
		                            <c:when test="${i <= fullStars}">
		                                <i class="bi bi-star-fill"></i>
		                            </c:when>
		                            <c:when test="${i == fullStars + 1 && decimal >= 0.5}">
		                                <i class="bi bi-star-half"></i>
		                            </c:when>
		                            <c:otherwise>
		                                <i class="bi bi-star"></i>
		                            </c:otherwise>
		                        </c:choose>
		                    </c:forEach>
		                </div>
		            </div>
		        </div>
		    </div>
		
		    <div class="review-list" id="reviewList">
		        <c:choose>
		            <c:when test="${empty review}">
		                <div class="no-review">
		                    <i class="bi bi-chat-square-text"></i>
		                    <p>아직 리뷰가 없습니다.</p>
		                </div>
		            </c:when>
		            <c:otherwise>
		                <c:forEach items="${review}" var="rv">
						    <div class="review-item" data-review-id="${rv.prodRvNo}">
						        <div class="review-item-header">
						            <div class="reviewer-info">
						                <div class="reviewer-avatar">
										    <c:choose>
										        <c:when test="${not empty rv.profileImage}">
										            <img src="${pageContext.request.contextPath}/upload${rv.profileImage}" alt="프로필">
										        </c:when>
										        <c:otherwise>
										            <i class="bi bi-person"></i>
										        </c:otherwise>
										    </c:choose>
										</div>
						                <div>
						                    <span class="reviewer-name">${rv.nickname}</span>
						                    <span class="review-date">
						                        <fmt:formatDate value="${rv.prodRegdate}" pattern="yyyy.MM.dd"/>
						                    </span>
						                </div>
						            </div>
						            <div class="d-flex align-items-center gap-2">
						                <div class="review-rating">
						                    <c:forEach begin="1" end="5" var="i">
						                        <c:choose>
						                            <c:when test="${i <= rv.rating}">
						                                <i class="bi bi-star-fill"></i>
						                            </c:when>
						                            <c:otherwise>
						                                <i class="bi bi-star"></i>
						                            </c:otherwise>
						                        </c:choose>
						                    </c:forEach>
						                </div>
						                <c:if test="${not empty sessionScope.loginMember && sessionScope.loginMember.memNo == rv.memNo}">
						                    <div class="dropdown">
						                        <button class="btn-more" type="button" data-bs-toggle="dropdown">
						                            <i class="bi bi-three-dots-vertical"></i>
						                        </button>
						                        <ul class="dropdown-menu dropdown-menu-end">
						                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="openEditReviewModal(${rv.prodRvNo}, ${rv.rating}, '${fn:escapeXml(rv.prodReview)}')">
						                                <i class="bi bi-pencil me-2"></i>수정</a></li>
						                            <li><a class="dropdown-item text-danger" href="javascript:void(0)" onclick="deleteReview(${rv.prodRvNo})">
						                                <i class="bi bi-trash me-2"></i>삭제</a></li>
						                        </ul>
						                    </div>
						                </c:if>
						            </div>
						        </div>
						        <div class="review-content">
						            <p>${rv.prodReview}</p>
						        </div>
						        <!-- 리뷰 이미지 (이미지가 있는 경우만 표시) -->
								<c:if test="${not empty rv.reviewImages}">
								    <div class="review-images">
								        <c:forEach items="${rv.reviewImages}" var="img">
								            <img src="${pageContext.request.contextPath}/upload/review/${img}" 
								                 alt="리뷰 이미지" onclick="openReviewImage(this.src)">
								        </c:forEach>
								    </div>
								</c:if>
						    </div>
						</c:forEach>
		            </c:otherwise>
		        </c:choose>
		    </div>
		
		    <!-- 더보기 버튼: 6개 이상일 때만 표시 -->
		    <c:if test="${reviewStat.reviewCount > 5}">
		        <div class="review-more" id="reviewMoreBtn">
		            <button class="btn btn-outline" onclick="loadMoreReviews()">
		                더 많은 리뷰 보기 <i class="bi bi-chevron-down ms-1"></i>
		            </button>
		        </div>
		    </c:if>
		</div>

        <!-- 판매자 문의 섹션 -->
        <div class="inquiry-section mt-5">
            <div class="inquiry-header">
                <h3><i class="bi bi-chat-dots me-2"></i>판매자 문의</h3>
                <p class="text-muted">상품에 대해 궁금한 점이 있으신가요? 판매자에게 직접 문의해보세요.</p>
            </div>

            <!-- 판매자 정보 -->
            <div class="seller-info-card">
                <div class="seller-profile">
                    <div class="seller-logo">
                        <i class="bi bi-building"></i>
                    </div>
                    <div class="seller-details">
                        <h4>제주다이브센터</h4>
                        <div class="seller-meta">
                            <span><i class="bi bi-patch-check-fill text-primary"></i> 인증업체</span>
                            <span><i class="bi bi-star-fill text-warning"></i> 4.9</span>
                            <span><i class="bi bi-chat-dots"></i> 응답률 98%</span>
                        </div>
                        <p class="seller-desc">제주도 스쿠버다이빙 전문 업체로 10년 이상의 경험을 보유하고 있습니다.</p>
                    </div>
                </div>
                <div class="seller-contact">
                    <span><i class="bi bi-clock"></i> 평균 응답시간: 1시간 이내</span>
                </div>
            </div>

            <!-- 문의 작성 -->
            <div class="inquiry-form-card">
                <h4><i class="bi bi-pencil-square me-2"></i>문의하기</h4>
                <form id="inquiryForm">
                    <div class="form-group">
                        <label class="form-label">문의 유형</label>
                        <select class="form-control form-select" id="inquiryType" required>
                            <option value="">문의 유형을 선택하세요</option>
                            <option value="product">상품 문의</option>
                            <option value="booking">예약/일정 문의</option>
                            <option value="price">가격/결제 문의</option>
                            <option value="cancel">취소/환불 문의</option>
                            <option value="other">기타 문의</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">문의 내용</label>
                        <textarea class="form-control" id="inquiryContent" rows="4"
                                  placeholder="문의하실 내용을 작성해주세요." required></textarea>
                        <small class="text-muted">개인정보(연락처, 주소 등)는 입력하지 마세요.</small>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" class="form-check-input" id="inquirySecret">
                        <label class="form-check-label" for="inquirySecret">비밀글로 문의하기</label>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-send me-2"></i>문의 등록
                    </button>
                </form>
            </div>

            <!-- 문의 목록 -->
			<div class="inquiry-list-card">
			    <div class="inquiry-list-header">
			        <h4><i class="bi bi-list-ul me-2"></i>문의 내역 <span class="inquiry-count">(${inquiryCount})</span></h4>
			    </div>
			    <div class="inquiry-list" id="inquiryList">
			        <c:choose>
			            <c:when test="${empty inquiry}">
			                <div class="no-inquiry" style="text-align: center; padding: 40px; color: #999;">
			                    <i class="bi bi-chat-square-text" style="font-size: 48px; opacity: 0.5;"></i>
			                    <p style="margin-top: 16px;">아직 문의가 없습니다.</p>
			                </div>
			            </c:when>
			            <c:otherwise>
			                <c:forEach items="${inquiry}" var="inq" varStatus="status">
			                    <div class="inquiry-item" data-inquiry-id="${inq.prodInqryNo}">
			                        <div class="inquiry-item-header">
			                            <div class="inquiry-item-info">
			                                <!-- 문의 유형 뱃지 -->
			                                <c:choose>
			                                    <c:when test="${inq.inquiryCtgry eq 'product'}">
			                                        <span class="inquiry-type-badge product">상품 문의</span>
			                                    </c:when>
			                                    <c:when test="${inq.inquiryCtgry eq 'booking'}">
			                                        <span class="inquiry-type-badge booking">예약/일정</span>
			                                    </c:when>
			                                    <c:when test="${inq.inquiryCtgry eq 'price'}">
			                                        <span class="inquiry-type-badge price">가격/결제</span>
			                                    </c:when>
			                                    <c:when test="${inq.inquiryCtgry eq 'cancel'}">
			                                        <span class="inquiry-type-badge cancel">취소/환불</span>
			                                    </c:when>
			                                    <c:otherwise>
			                                        <span class="inquiry-type-badge other">기타</span>
			                                    </c:otherwise>
			                                </c:choose>
			                                
			                                <!-- 작성자 닉네임 마스킹 -->
			                                <span class="inquiry-author">${inq.inquiryNickname}</span>
			                                <span class="inquiry-date">
			                                    <fmt:formatDate value="${inq.regDt}" pattern="yyyy.MM.dd"/>
			                                </span>
			                                
			                                <!-- 비밀글 표시 -->
			                                <c:if test="${inq.secretYn eq 'Y'}">
			                                    <span class="secret-badge"><i class="bi bi-lock"></i> 비밀글</span>
			                                </c:if>
			                            </div>
			                            
			                            <!-- 답변 상태 -->
			                            <div class="d-flex align-items-center gap-2">
										    <!-- 답변 상태 -->
										    <c:choose>
										        <c:when test="${inq.inqryStatus eq 'DONE'}">
										            <span class="inquiry-status answered">답변완료</span>
										        </c:when>
										        <c:otherwise>
										            <span class="inquiry-status waiting">답변대기</span>
										        </c:otherwise>
										    </c:choose>
										    
										    <c:if test="${not empty sessionScope.loginMember && sessionScope.loginMember.memNo == inq.inquiryMemNo && inq.inqryStatus ne 'DONE'}">
										        <div class="dropdown">
										            <button class="btn-more" type="button" data-bs-toggle="dropdown">
										                <i class="bi bi-three-dots-vertical"></i>
										            </button>
										            <ul class="dropdown-menu dropdown-menu-end">
										                <li><a class="dropdown-item" href="javascript:void(0)" onclick="openEditInquiryModal(${inq.prodInqryNo}, '${inq.inquiryCtgry}', '${fn:escapeXml(inq.prodInqryCn)}', '${inq.secretYn}')">
										                    <i class="bi bi-pencil me-2"></i>수정</a></li>
										                <li><a class="dropdown-item text-danger" href="javascript:void(0)" onclick="deleteInquiry(${inq.prodInqryNo})">
										                    <i class="bi bi-trash me-2"></i>삭제</a></li>
										            </ul>
										        </div>
										    </c:if>
										</div>
			                        </div>
			                        
			                        <!-- 문의 내용 -->
			                        <div class="inquiry-item-question">
			                            <c:choose>
			                                <c:when test="${inq.secretYn eq 'Y' && (empty sessionScope.loginMember || (sessionScope.loginMember.memNo != inq.inquiryMemNo && sessionScope.loginMember.memType ne 'BUSINESS'))}">
			                                    <p class="secret-content"><i class="bi bi-lock me-1"></i>비밀글로 작성된 문의입니다.</p>
			                                </c:when>
			                                <c:otherwise>
			                                    <p><strong>Q.</strong> ${inq.prodInqryCn}</p>
			                                </c:otherwise>
			                            </c:choose>
			                        </div>
			                        
			                        <!-- 답변 내용 (답변완료 시) -->
									<c:if test="${inq.inqryStatus eq 'DONE' && not empty inq.replyCn}">
									    <!-- 비밀글이 아니거나 본인인 경우만 답변 표시 -->
									    <c:if test="${inq.secretYn ne 'Y' || (not empty sessionScope.loginMember && (sessionScope.loginMember.memNo == inq.inquiryMemNo || sessionScope.loginMember.memType eq 'BUSINESS'))}">
									    <div class="inquiry-item-answer" id="answer_${inq.prodInqryNo}">
									        <div class="answer-header">
									            <span class="answer-badge"><i class="bi bi-building"></i> 판매자 답변</span>
									            <div class="d-flex align-items-center gap-2">
									                <span class="answer-date">
									                    <fmt:formatDate value="${inq.replyDt}" pattern="yyyy.MM.dd"/>
									                </span>
									                <c:if test="${sessionScope.loginMember.memType eq 'BUSINESS' && sessionScope.loginMember.memNo == inq.replyMemNo}">
									                    <div class="dropdown">
									                        <button class="btn-more btn-more-sm" type="button" data-bs-toggle="dropdown">
									                            <i class="bi bi-three-dots-vertical"></i>
									                        </button>
									                        <ul class="dropdown-menu dropdown-menu-end">
									                            <li><a class="dropdown-item" href="javascript:void(0)" onclick="openEditReplyModal(${inq.prodInqryNo}, '${fn:escapeXml(inq.replyCn)}')">
									                                <i class="bi bi-pencil me-2"></i>수정</a></li>
									                            <li><a class="dropdown-item text-danger" href="javascript:void(0)" onclick="deleteReply(${inq.prodInqryNo})">
									                                <i class="bi bi-trash me-2"></i>삭제</a></li>
									                        </ul>
									                    </div>
									                </c:if>
									            </div>
									        </div>
									        <p class="answer-content"><strong>A.</strong> ${inq.replyCn}</p>
									    </div>
									    </c:if>
									</c:if>
			                        
			                        <!-- 기업회원 답변 영역 (답변대기 상태일 때만) -->
			                        <c:if test="${sessionScope.loginMember.memType eq 'BUSINESS' && inq.inqryStatus eq 'WAIT'}">
			                        <div class="business-reply-section">
			                            <button class="btn btn-sm btn-primary" onclick="toggleReplyForm(${inq.prodInqryNo})">
			                                <i class="bi bi-reply me-1"></i>답변하기
			                            </button>
			                            <div class="reply-form" id="replyForm_${inq.prodInqryNo}" style="display: none;">
			                                <textarea class="form-control" id="replyContent_${inq.prodInqryNo}" rows="3"
			                                          placeholder="답변 내용을 입력하세요..."></textarea>
			                                <div class="reply-form-actions">
			                                    <button class="btn btn-sm btn-outline" onclick="toggleReplyForm(${inq.prodInqryNo})">취소</button>
			                                    <button class="btn btn-sm btn-primary" onclick="submitReply(${inq.prodInqryNo})">답변 등록</button>
			                                </div>
			                            </div>
			                        </div>
			                        </c:if>
			                    </div>
			                </c:forEach>
			            </c:otherwise>
			        </c:choose>
			    </div>
			
			    <!-- 더보기 버튼: 6개 이상일 때만 표시 -->
			    <c:if test="${inquiryCount > 5}">
			        <div class="inquiry-more" id="inquiryMoreBtn">
			            <button class="btn btn-outline" onclick="loadMoreInquiries()">
			                더 많은 문의 보기 <i class="bi bi-chevron-down ms-1"></i>
			            </button>
			        </div>
			    </c:if>
			</div>
        </div>
    </div>
</div>

<!-- 리뷰 수정 모달 -->
<div class="modal fade" id="editReviewModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-star me-2"></i>리뷰 수정
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="editReviewForm">
                    <input type="hidden" id="editReviewId">
                    
                    <!-- 별점 -->
                    <div class="review-section">
                        <label class="review-label">별점 <span class="text-danger">*</span></label>
                        <div class="star-rating" id="editStarRating">
                            <i class="bi bi-star" data-rating="1"></i>
                            <i class="bi bi-star" data-rating="2"></i>
                            <i class="bi bi-star" data-rating="3"></i>
                            <i class="bi bi-star" data-rating="4"></i>
                            <i class="bi bi-star" data-rating="5"></i>
                        </div>
                        <span class="rating-text" id="editRatingText">별점을 선택해주세요</span>
                        <input type="hidden" id="editReviewRating" value="0">
                    </div>

                    <!-- 후기 내용 -->
                    <div class="review-section">
                        <label class="review-label">후기 내용 <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="editReviewContent" rows="5"
                                  placeholder="상품 이용 경험을 자세히 작성해주세요. (최소 20자 이상)"
                                  minlength="20" maxlength="1000"></textarea>
                        <div class="char-counter">
                            <span id="editReviewCharCount">0</span> / 1000자
                        </div>
                    </div>
                    
                    <!-- 사진 첨부 -->
					<div class="review-section">
					    <label class="review-label">사진 첨부 <span class="text-muted">(선택, 최대 5장)</span></label>
					    <div class="review-image-upload">
					        <input type="file" id="editReviewImages" accept="image/*" multiple style="display: none;">
					        <div class="image-upload-area" onclick="document.getElementById('editReviewImages').click()">
					            <i class="bi bi-camera"></i>
					            <span>사진 추가</span>
					        </div>
					        <div class="image-preview-list" id="editImagePreviewList"></div>
					    </div>
					</div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="updateReview()">
                    <i class="bi bi-check-lg me-1"></i>수정 완료
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 문의 수정 모달 -->
<div class="modal fade" id="editInquiryModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-pencil-square me-2"></i>문의 수정
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="editInquiryForm">
                    <input type="hidden" id="editInquiryId">
                    
                    <div class="form-group mb-3">
                        <label class="form-label">문의 유형</label>
                        <select class="form-control form-select" id="editInquiryType">
                            <option value="product">상품 문의</option>
                            <option value="booking">예약/일정 문의</option>
                            <option value="price">가격/결제 문의</option>
                            <option value="cancel">취소/환불 문의</option>
                            <option value="other">기타 문의</option>
                        </select>
                    </div>
                    <div class="form-group mb-3">
                        <label class="form-label">문의 내용</label>
                        <textarea class="form-control" id="editInquiryContent" rows="4"
                                  placeholder="문의 내용을 입력해주세요."></textarea>
                    </div>
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="editInquirySecret">
                        <label class="form-check-label" for="editInquirySecret">비밀글로 문의하기</label>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="updateInquiry()">
                    <i class="bi bi-check-lg me-1"></i>수정 완료
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 답변 수정 모달 -->
<div class="modal fade" id="editReplyModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-reply me-2"></i>답변 수정
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="editReplyInquiryId">
                <div class="form-group">
                    <label class="form-label">답변 내용</label>
                    <textarea class="form-control" id="editReplyContent" rows="4"
                              placeholder="답변 내용을 입력해주세요."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="updateReply()">
                    <i class="bi bi-check-lg me-1"></i>수정 완료
                </button>
            </div>
        </div>
    </div>
</div>

<c:if test="${sessionScope.loginMember.memType ne 'BUSINESS'}">
<!-- 플로팅 장바구니 버튼 -->
<button class="floating-cart-btn" onclick="openCart()" id="floatingCartBtn">
    <i class="bi bi-cart3"></i>
    <span class="cart-badge" id="cartBadge">0</span>
</button>

<!-- 장바구니 사이드바 -->
<div class="cart-overlay" id="cartOverlay" onclick="closeCart()"></div>
<div class="cart-sidebar" id="cartSidebar">
    <div class="cart-header">
        <h3><i class="bi bi-cart3"></i> 장바구니</h3>
        <button class="cart-close-btn" onclick="closeCart()">
            <i class="bi bi-x-lg"></i>
        </button>
    </div>
    <div class="cart-body" id="cartBody">
        <div class="cart-empty" id="cartEmpty">
            <i class="bi bi-cart-x"></i>
            <p>장바구니가 비어있습니다</p>
            <span>마음에 드는 상품을 담아보세요</span>
        </div>
        <div class="cart-items" id="cartItems">
            <!-- 장바구니 아이템들이 여기에 추가됨 -->
        </div>
    </div>
    <div class="cart-footer" id="cartFooter">
        <div class="cart-summary">
            <div class="summary-row">
                <span>상품 수</span>
                <span id="cartItemCount">0개</span>
            </div>
            <div class="summary-row total">
                <span>총 금액</span>
                <span id="cartTotalPrice">0원</span>
            </div>
        </div>
        <button class="btn btn-primary btn-lg cart-checkout-btn" onclick="checkout()">
            <i class="bi bi-credit-card me-2"></i>결제하기
        </button>
    </div>
</div>
</c:if>

<script>
const CONTEXT_PATH = '${pageContext.request.contextPath}';
const TRIP_PROD_NO = '${tp.tripProdNo}';
const pricePerPerson = ${sale != null ? sale.price : 0};
var loginMemNo = ${not empty sessionScope.loginMember ? sessionScope.loginMember.memNo : 'null'};
var loginMemType = '${sessionScope.loginMember.memType}';
var isLoggedIn = ${not empty sessionScope.loginMember};
var totalReviewCount = ${reviewStat.reviewCount != null ? reviewStat.reviewCount : 0};
var totalInquiryCount = ${inquiryCount != null ? inquiryCount : 0};

// 현재 상품 정보
const currentProduct = {
    id: '${tp.tripProdNo}',
    name: '${tp.tripProdTitle}',
    price: ${sale != null ? sale.price : 0},
    image: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=300&fit=crop&q=80'
};
</script>

<script src="${pageContext.request.contextPath}/resources/js/tour-detail.js"></script>

<%@ include file="../common/footer.jsp" %>
