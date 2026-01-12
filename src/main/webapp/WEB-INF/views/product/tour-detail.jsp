<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="${tp.tripProdTitle}" />
<c:set var="pageCss" value="product" />
<%-- 줄바꿈 문자 정의 --%>
<% pageContext.setAttribute("newline", "\n"); %>

<%@ include file="../common/header.jsp" %>

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
						                    <i class="bi bi-person"></i>
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

<style>
/* 줄바꿈 유지 */
.preserve-line {
    white-space: pre-line;
    line-height: 1.8;
}
/* 플로팅 장바구니 버튼 */
.floating-cart-btn {
    position: fixed;
    bottom: 100px;
    right: 24px;
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background: linear-gradient(135deg, #4A90D9 0%, #357ABD 100%);
    color: white;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    box-shadow: 0 6px 20px rgba(74, 144, 217, 0.4);
    transition: all 0.3s ease;
    z-index: 998;
}

.floating-cart-btn:hover {
    transform: scale(1.1);
    box-shadow: 0 8px 25px rgba(74, 144, 217, 0.5);
}

.cart-badge {
    position: absolute;
    top: -5px;
    right: -5px;
    min-width: 24px;
    height: 24px;
    background: #ef4444;
    color: white;
    border-radius: 12px;
    font-size: 12px;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 6px;
}

.cart-badge:empty,
.cart-badge[data-count="0"] {
    display: none;
}

/* 장바구니 오버레이 */
.cart-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1100;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
}

.cart-overlay.active {
    opacity: 1;
    visibility: visible;
}

/* 장바구니 사이드바 */
.cart-sidebar {
    position: fixed;
    top: 0;
    right: -420px;
    width: 400px;
    max-width: 100%;
    height: 100%;
    background: white;
    z-index: 1200;
    display: flex;
    flex-direction: column;
    box-shadow: -5px 0 30px rgba(0, 0, 0, 0.15);
    transition: right 0.3s ease;
}

.cart-sidebar.active {
    right: 0;
}

.cart-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px;
    border-bottom: 1px solid #eee;
    background: #f8fafc;
}

.cart-header h3 {
    margin: 0;
    font-size: 18px;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 10px;
}

.cart-close-btn {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    border: none;
    background: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    color: #666;
    transition: all 0.2s ease;
}

.cart-close-btn:hover {
    background: #fee2e2;
    color: #ef4444;
}

.cart-body {
    flex: 1;
    overflow-y: auto;
    padding: 20px;
}

.cart-empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    color: #999;
    text-align: center;
}

.cart-empty i {
    font-size: 64px;
    margin-bottom: 16px;
    opacity: 0.5;
}

.cart-empty p {
    font-size: 16px;
    font-weight: 500;
    margin-bottom: 8px;
    color: #666;
}

.cart-empty span {
    font-size: 14px;
}

.cart-items {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

/* 장바구니 아이템 */
.cart-item {
    display: flex;
    gap: 12px;
    padding: 12px;
    background: #f8fafc;
    border-radius: 12px;
    position: relative;
}

.cart-item-image {
    width: 80px;
    height: 60px;
    border-radius: 8px;
    overflow: hidden;
    flex-shrink: 0;
}

.cart-item-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.cart-item-info {
    flex: 1;
    min-width: 0;
}

.cart-item-name {
    font-size: 14px;
    font-weight: 600;
    color: #333;
    margin-bottom: 4px;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.cart-item-price {
    font-size: 15px;
    font-weight: 700;
    color: var(--primary-color);
}

.cart-item-quantity {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-top: 8px;
}

.quantity-btn {
    width: 28px;
    height: 28px;
    border-radius: 6px;
    border: 1px solid #ddd;
    background: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    transition: all 0.2s ease;
}

.quantity-btn:hover {
    border-color: var(--primary-color);
    color: var(--primary-color);
}

.quantity-value {
    font-size: 14px;
    font-weight: 600;
    min-width: 24px;
    text-align: center;
}

.cart-item-remove {
    position: absolute;
    top: 8px;
    right: 8px;
    width: 24px;
    height: 24px;
    border-radius: 50%;
    border: none;
    background: transparent;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #999;
    font-size: 14px;
    transition: all 0.2s ease;
}

.cart-item-remove:hover {
    background: #fee2e2;
    color: #ef4444;
}

/* 장바구니 푸터 */
.cart-footer {
    padding: 20px;
    border-top: 1px solid #eee;
    background: #f8fafc;
}

.cart-summary {
    margin-bottom: 16px;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 0;
    font-size: 14px;
    color: #666;
}

.summary-row.total {
    font-size: 18px;
    font-weight: 700;
    color: #333;
    border-top: 1px solid #ddd;
    padding-top: 12px;
    margin-top: 8px;
}

.summary-row.total span:last-child {
    color: var(--primary-color);
}

.cart-checkout-btn {
    width: 100%;
    padding: 14px;
    font-size: 16px;
    font-weight: 600;
}

/* 버튼 스타일 추가 */
.btn-outline-primary {
    border: 2px solid var(--primary-color);
    color: var(--primary-color);
    background: transparent;
}

.btn-outline-primary:hover {
    background: var(--primary-color);
    color: white;
}

/* 반응형 */
@media (max-width: 480px) {
    .cart-sidebar {
        width: 100%;
        right: -100%;
    }

    .floating-cart-btn {
        right: 24px;
        bottom: 90px;
        width: 56px;
        height: 56px;
    }
}

/* 유의사항 섹션 */
.notice-section {
    background: #fffbeb;
    border: 1px solid #fcd34d;
    border-radius: 12px;
    padding: 20px 24px !important;
}

.notice-section h3 {
    color: #b45309;
    display: flex;
    align-items: center;
}

.notice-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.notice-list li {
    padding: 8px 0;
    color: #92400e;
    display: flex;
    align-items: flex-start;
    line-height: 1.6;
}

.notice-list li i {
    margin-right: 8px;
    margin-top: 2px;
    font-size: 20px;
}

/* 포함/불포함 리스트 */
.include-list, .exclude-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.include-list li, .exclude-list li {
    padding: 8px 0;
    display: flex;
    align-items: center;
}

/* ==================== 판매자 문의 섹션 ==================== */
.inquiry-section {
    margin-bottom: 60px;
}

.inquiry-header {
    margin-bottom: 24px;
}

.inquiry-header h3 {
    font-size: 22px;
    font-weight: 700;
    margin-bottom: 8px;
    display: flex;
    align-items: center;
}

.inquiry-header h3 i {
    color: var(--primary-color);
}

/* 판매자 정보 카드 */
.seller-info-card {
    background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
    border-radius: 16px;
    padding: 24px;
    margin-bottom: 24px;
    border: 1px solid #e2e8f0;
}

.seller-profile {
    display: flex;
    gap: 20px;
    align-items: flex-start;
}

.seller-logo {
    width: 64px;
    height: 64px;
    background: white;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 28px;
    color: var(--primary-color);
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    flex-shrink: 0;
}

.seller-details h4 {
    font-size: 18px;
    font-weight: 700;
    margin-bottom: 8px;
}

.seller-meta {
    display: flex;
    flex-wrap: wrap;
    gap: 16px;
    margin-bottom: 8px;
    font-size: 13px;
    color: #666;
}

.seller-meta span {
    display: flex;
    align-items: center;
    gap: 4px;
}

.seller-desc {
    font-size: 14px;
    color: #666;
    margin: 0;
}

.seller-contact {
    margin-top: 16px;
    padding-top: 16px;
    border-top: 1px solid #ddd;
    font-size: 13px;
    color: #666;
}

.seller-contact i {
    margin-right: 4px;
}

/* 리뷰 섹션 */
.review-section {
    background: white;
    border-radius: 16px;
    padding: 32px;
    margin-bottom: 32px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

.review-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    padding-bottom: 16px;
    border-bottom: 1px solid #eee;
}

.review-header h3 {
    font-size: 20px;
    font-weight: 700;
    margin: 0;
}

.review-score {
    display: flex;
    align-items: center;
    gap: 12px;
}

.review-score .score {
    font-size: 32px;
    font-weight: 700;
    color: #333;
}

.review-score .stars {
    color: #fbbf24;
}

.review-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.review-item {
    padding: 20px;
    background: #f8fafc;
    border-radius: 12px;
}

.review-item-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 12px;
}

.reviewer-info {
    display: flex;
    align-items: center;
    gap: 12px;
}

.reviewer-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: #e2e8f0;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #666;
}

.reviewer-name {
    font-weight: 600;
    display: block;
}

.review-date {
    font-size: 12px;
    color: #999;
}

.review-rating {
    color: #fbbf24;
}

.review-content p {
    margin: 0;
    line-height: 1.6;
    color: #333;
}

.review-images {
    display: flex;
    gap: 8px;
    margin-top: 12px;
}

.review-images img {
    width: 80px;
    height: 80px;
    object-fit: cover;
    border-radius: 8px;
    cursor: pointer;
}

.review-more {
    text-align: center;
    margin-top: 24px;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* 문의 작성 카드 */
.inquiry-form-card {
    background: white;
    border-radius: 16px;
    padding: 24px;
    margin-bottom: 24px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    border: 1px solid #eee;
}

.inquiry-form-card h4 {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
}

.inquiry-form-card h4 i {
    color: var(--primary-color);
}

.inquiry-form-card .form-group {
    margin-bottom: 16px;
}

.inquiry-form-card .form-label {
    font-weight: 500;
    margin-bottom: 8px;
}

.inquiry-form-card .btn-primary {
    padding: 12px 24px;
}

/* 문의 목록 카드 */
.inquiry-list-card {
    background: white;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    border: 1px solid #eee;
}

.inquiry-list-header {
    margin-bottom: 20px;
    padding-bottom: 16px;
    border-bottom: 1px solid #eee;
}

.inquiry-list-header h4 {
    font-size: 18px;
    font-weight: 600;
    margin: 0;
    display: flex;
    align-items: center;
}

.inquiry-list-header h4 i {
    color: var(--primary-color);
}

.inquiry-count {
    color: #666;
    font-weight: 400;
}

/* 문의 아이템 */
.inquiry-item {
    padding: 20px;
    background: #f8fafc;
    border-radius: 12px;
    margin-bottom: 16px;
}

.inquiry-item:last-child {
    margin-bottom: 0;
}

.inquiry-item-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
    flex-wrap: wrap;
    gap: 8px;
}

.inquiry-item-info {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
}

.inquiry-type-badge {
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
}

.inquiry-type-badge.product {
    background: #dbeafe;
    color: #1d4ed8;
}

.inquiry-type-badge.booking {
    background: #dcfce7;
    color: #15803d;
}

.inquiry-type-badge.price {
    background: #fef3c7;
    color: #b45309;
}

.inquiry-type-badge.cancel {
    background: #fee2e2;
    color: #dc2626;
}

.inquiry-type-badge.other {
    background: #e5e7eb;
    color: #4b5563;
}

.inquiry-author {
    font-size: 13px;
    color: #666;
}

.inquiry-date {
    font-size: 12px;
    color: #999;
}

.secret-badge {
    font-size: 12px;
    color: #666;
    display: flex;
    align-items: center;
    gap: 4px;
}

.inquiry-status {
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
}

.inquiry-status.answered {
    background: #dcfce7;
    color: #15803d;
}

.inquiry-status.waiting {
    background: #fef3c7;
    color: #b45309;
}

.inquiry-item-question p {
    margin: 0;
    font-size: 14px;
    line-height: 1.6;
    color: #333;
}

.inquiry-item-question strong {
    color: var(--primary-color);
}

.secret-content {
    color: #999 !important;
    font-style: italic;
}

/* 답변 스타일 */
.inquiry-item-answer {
    margin-top: 16px;
    padding: 16px;
    background: white;
    border-radius: 10px;
    border-left: 3px solid var(--primary-color);
}

.answer-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
}

.answer-badge {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    font-weight: 600;
    color: var(--primary-color);
}

.answer-date {
    font-size: 12px;
    color: #999;
}

.inquiry-item-answer p {
    margin: 0;
    font-size: 14px;
    line-height: 1.6;
    color: #333;
}

.inquiry-item-answer strong {
    color: #10b981;
}

/* 더보기 버튼 */
.inquiry-more {
    text-align: center;
    margin-top: 20px;
}

.inquiry-more .btn-outline {
    padding: 10px 24px;
}

/* 문의 섹션 반응형 */
@media (max-width: 768px) {
    .seller-profile {
        flex-direction: column;
        align-items: center;
        text-align: center;
    }

    .seller-meta {
        justify-content: center;
    }

    .inquiry-item-header {
        flex-direction: column;
        align-items: flex-start;
    }

    .inquiry-item-info {
        margin-bottom: 8px;
    }
}

/* 문의 추가 애니메이션 */
@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.new-inquiry {
    border: 2px solid var(--primary-color);
    background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
}

/* 기업회원 답변 영역 */
.business-reply-section {
    margin-top: 16px;
    padding-top: 16px;
    border-top: 1px dashed #ddd;
}

.reply-form {
    margin-top: 12px;
    animation: slideIn 0.2s ease-out;
}

.reply-form textarea {
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 12px;
    font-size: 14px;
    resize: none;
}

.reply-form textarea:focus {
    border-color: var(--primary-color);
    outline: none;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
}

.reply-form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    margin-top: 10px;
}

.reply-form-actions .btn-sm {
    padding: 6px 16px;
    font-size: 13px;
}
/* 더보기 버튼 */
.btn-more {
    width: 32px;
    height: 32px;
    border: none;
    background: transparent;
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #999;
    transition: all 0.2s ease;
}

.btn-more:hover {
    background: #f1f5f9;
    color: #333;
}

/* 드롭다운 메뉴 */
.dropdown-menu {
    border: none;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    border-radius: 8px;
    min-width: 120px;
}

.dropdown-item {
    padding: 8px 16px;
    font-size: 14px;
}

.dropdown-item:hover {
    background: #f8fafc;
}

.dropdown-item.text-danger:hover {
    background: #fef2f2;
}

/* 리뷰 수정 모달 */
.review-section {
    margin-bottom: 25px;
}

.review-label {
    display: block;
    font-size: 14px;
    font-weight: 600;
    color: #334155;
    margin-bottom: 10px;
}

.star-rating {
    display: flex;
    gap: 8px;
    margin-bottom: 8px;
}

.star-rating i {
    font-size: 32px;
    color: #e2e8f0;
    cursor: pointer;
    transition: all 0.2s;
}

.star-rating i:hover,
.star-rating i.bi-star-fill {
    color: #fbbf24;
}

.rating-text {
    font-size: 14px;
    color: #64748b;
}

.char-counter {
    text-align: right;
    font-size: 12px;
    color: #94a3b8;
    margin-top: 5px;
}
/* 답변 영역 작은 더보기 버튼 */
.btn-more-sm {
    width: 24px;
    height: 24px;
    font-size: 12px;
}

/* fadeOut 애니메이션 */
@keyframes fadeOut {
    from {
        opacity: 1;
        transform: translateY(0);
    }
    to {
        opacity: 0;
        transform: translateY(-10px);
    }
}

/* 이미지 업로드 스타일 */
.review-image-upload {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.image-upload-area {
    width: 80px;
    height: 80px;
    border: 2px dashed #e2e8f0;
    border-radius: 8px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s;
}

.image-upload-area:hover {
    border-color: var(--primary-color);
    background: #f0f7ff;
}

.image-upload-area i {
    font-size: 24px;
    color: #94a3b8;
}

.image-upload-area span {
    font-size: 11px;
    color: #94a3b8;
    margin-top: 5px;
}

.image-preview-list {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.image-preview-item {
    position: relative;
    width: 80px;
    height: 80px;
}

.image-preview-item img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: 8px;
}

.image-preview-item .remove-btn {
    position: absolute;
    top: -8px;
    right: -8px;
    width: 22px;
    height: 22px;
    border-radius: 50%;
    background: #ef4444;
    color: white;
    border: none;
    font-size: 12px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
}

.image-preview-item .remove-btn:hover {
    background: #dc2626;
}

/* 리뷰 이미지 */
.review-images {
    display: flex;
    gap: 8px;
    margin-top: 12px;
    flex-wrap: wrap;
}

.review-images img {
    width: 80px;
    height: 80px;
    object-fit: cover;
    border-radius: 8px;
    cursor: pointer;
    transition: transform 0.2s, opacity 0.2s;
}

.review-images img:hover {
    transform: scale(1.05);
    opacity: 0.9;
}

/* 이미지 확대 모달 */
.review-image-modal {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0,0,0,0.9);
    z-index: 9999;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
}

.review-image-modal-content {
    position: relative;
    max-width: 90%;
    max-height: 90%;
}

.review-image-modal-content img {
    max-width: 100%;
    max-height: 90vh;
    object-fit: contain;
    border-radius: 8px;
}

.review-image-close {
    position: absolute;
    top: -40px;
    right: 0;
    width: 36px;
    height: 36px;
    border: none;
    background: white;
    color: #333;
    border-radius: 50%;
    font-size: 24px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
}

.review-image-close:hover {
    background: #f0f0f0;
}

/* 커스텀 확인 모달 */
@keyframes confirmSlideIn {
    from {
        opacity: 0;
        transform: scale(0.9) translateY(-20px);
    }
    to {
        opacity: 1;
        transform: scale(1) translateY(0);
    }
}
</style>

<script>
const pricePerPerson = ${sale != null ? sale.price : 0};
var loginMemNo = ${not empty sessionScope.loginMember ? sessionScope.loginMember.memNo : 'null'};
var loginMemType = '${sessionScope.loginMember.memType}';

// 현재 상품 정보
const currentProduct = {
    id: '${tp.tripProdNo}',
    name: '${tp.tripProdTitle}',
    price: ${sale != null ? sale.price : 0},
    image: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=300&fit=crop&q=80'
};

// 장바구니 데이터
var cart = [];

function changeMainImage(thumb) {
    document.getElementById('mainImage').src = thumb.src;
}

function updateTotal() {
    const people = parseInt(document.getElementById('bookingPeople').value);
    const total = pricePerPerson * people;
    document.getElementById('totalPrice').textContent = total.toLocaleString() + '원';
}

function addToBookmark() {
    const isLoggedIn = ${not empty sessionScope.loginMember};

    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    showToast('북마크에 추가되었습니다.', 'success');
}

document.getElementById('bookingForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const isLoggedIn = ${not empty sessionScope.loginMember};

    if (!isLoggedIn) {
        sessionStorage.setItem('returnUrl', window.location.href);
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    const date = document.getElementById('bookingDate').value;
    const time = document.getElementById('bookingTime').value;

    if (!date || !time) {
        showToast('날짜와 시간을 선택해주세요.', 'error');
        return;
    }

    // 결제 페이지로 이동
    window.location.href = '${pageContext.request.contextPath}/tour/${tp.tripProdNo}/booking?date=' + date + '&time=' + time +
                           '&people=' + document.getElementById('bookingPeople').value;
});

// ==================== 장바구니 기능 ====================

// 페이지 로드시 장바구니 불러오기
document.addEventListener('DOMContentLoaded', function() {
    loadCart();
    updateCartUI();
    updateTotal()
});

// 세션스토리지에서 장바구니 불러오기
function loadCart() {
    var savedCart = sessionStorage.getItem('tourCart');
    if (savedCart) {
        try {
            cart = JSON.parse(savedCart);
        } catch (e) {
            cart = [];
        }
    }
}

// 세션스토리지에 장바구니 저장
function saveCart() {
	sessionStorage.setItem('tourCart', JSON.stringify(cart));
}

// 상세페이지에서 장바구니에 추가
function addToCartFromDetail() {
    var people = parseInt(document.getElementById('bookingPeople').value) || 1;

    // 이미 장바구니에 있는지 확인
    var existingItem = cart.find(function(item) {
        return item.id === currentProduct.id;
    });

    if (existingItem) {
        existingItem.quantity += people;
        showToast('장바구니에 ' + people + '개 추가되었습니다', 'success');
    } else {
        cart.push({
            id: currentProduct.id,
            name: currentProduct.name,
            price: currentProduct.price,
            image: currentProduct.image,
            quantity: people
        });
        showToast('장바구니에 담겼습니다 (' + people + '개)', 'success');
    }

    saveCart();
    updateCartUI();

    // 장바구니 사이드바 열기
    setTimeout(function() {
        openCart();
    }, 500);
}

// 장바구니에서 상품 제거
function removeFromCart(id) {
    cart = cart.filter(function(item) {
        return item.id !== id;
    });

    saveCart();
    updateCartUI();
    renderCart();
    showToast('상품이 제거되었습니다', 'info');
}

// 수량 변경
function updateQuantity(id, delta) {
    var item = cart.find(function(item) {
        return item.id === id;
    });

    if (item) {
        item.quantity += delta;

        if (item.quantity <= 0) {
            removeFromCart(id);
            return;
        }

        saveCart();
        updateCartUI();
        renderCart();
    }
}

// 장바구니 UI 업데이트 (뱃지, 총액)
function updateCartUI() {
    var totalItems = cart.reduce(function(sum, item) {
        return sum + item.quantity;
    }, 0);

    var totalPrice = cart.reduce(function(sum, item) {
        return sum + (item.price * item.quantity);
    }, 0);

    // 뱃지 업데이트
    var badge = document.getElementById('cartBadge');
    if (badge) {
        badge.textContent = totalItems;
        badge.setAttribute('data-count', totalItems);
        badge.style.display = totalItems > 0 ? 'flex' : 'none';
    }

    // 상품 수 업데이트
    var itemCount = document.getElementById('cartItemCount');
    if (itemCount) {
        itemCount.textContent = totalItems + '개';
    }

    // 총 금액 업데이트
    var totalPriceEl = document.getElementById('cartTotalPrice');
    if (totalPriceEl) {
        totalPriceEl.textContent = totalPrice.toLocaleString() + '원';
    }

    // 빈 장바구니 표시 처리
    var cartEmpty = document.getElementById('cartEmpty');
    var cartItems = document.getElementById('cartItems');
    var cartFooter = document.getElementById('cartFooter');

    if (cart.length === 0) {
        if (cartEmpty) cartEmpty.style.display = 'flex';
        if (cartItems) cartItems.style.display = 'none';
        if (cartFooter) cartFooter.style.display = 'none';
    } else {
        if (cartEmpty) cartEmpty.style.display = 'none';
        if (cartItems) cartItems.style.display = 'flex';
        if (cartFooter) cartFooter.style.display = 'block';
    }
}

// 장바구니 렌더링
function renderCart() {
    var cartItemsEl = document.getElementById('cartItems');
    if (!cartItemsEl) return;

    if (cart.length === 0) {
        cartItemsEl.innerHTML = '';
        updateCartUI();
        return;
    }

    var html = '';
    cart.forEach(function(item) {
        var itemTotal = item.price * item.quantity;
        html += '<div class="cart-item" data-id="' + item.id + '">' +
            '<div class="cart-item-image">' +
                '<img src="' + item.image + '" alt="' + item.name + '">' +
            '</div>' +
            '<div class="cart-item-info">' +
                '<div class="cart-item-name">' + item.name + '</div>' +
                '<div class="cart-item-price">' + itemTotal.toLocaleString() + '원</div>' +
                '<div class="cart-item-quantity">' +
                    '<button class="quantity-btn" onclick="updateQuantity(\'' + item.id + '\', -1)">' +
                        '<i class="bi bi-dash"></i>' +
                    '</button>' +
                    '<span class="quantity-value">' + item.quantity + '</span>' +
                    '<button class="quantity-btn" onclick="updateQuantity(\'' + item.id + '\', 1)">' +
                        '<i class="bi bi-plus"></i>' +
                    '</button>' +
                '</div>' +
            '</div>' +
            '<button class="cart-item-remove" onclick="removeFromCart(\'' + item.id + '\')" title="삭제">' +
                '<i class="bi bi-x"></i>' +
            '</button>' +
        '</div>';
    });

    cartItemsEl.innerHTML = html;
    updateCartUI();
}

// 장바구니 열기
function openCart() {
    renderCart();
    document.getElementById('cartOverlay').classList.add('active');
    document.getElementById('cartSidebar').classList.add('active');
    document.body.style.overflow = 'hidden';
}

// 장바구니 닫기
function closeCart() {
    document.getElementById('cartOverlay').classList.remove('active');
    document.getElementById('cartSidebar').classList.remove('active');
    document.body.style.overflow = '';
}

// 결제하기 (체크아웃)
function checkout() {
    if (cart.length === 0) {
        showToast('장바구니가 비어있습니다', 'warning');
        return;
    }

    // 로그인 체크
    var isLoggedIn = ${not empty sessionScope.loginMember};
    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    // 장바구니 데이터를 sessionStorage에 저장 (결제 페이지에서 사용)
    sessionStorage.setItem('tourCartCheckout', JSON.stringify(cart));

    // 결제 페이지로 이동
    window.location.href = '${pageContext.request.contextPath}/booking/tour/checkout';
}

// ESC 키로 장바구니 닫기
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeCart();
    }
});

//==================== 리뷰 더보기 기능 ====================
var reviewPage = 1;
var totalReviewCount = ${reviewStat.reviewCount != null ? reviewStat.reviewCount : 0};
var isLoadingReview = false;

function loadMoreReviews() {
    if (isLoadingReview) return;
    
    isLoadingReview = true;
    reviewPage++;
    
    var btn = document.querySelector('#reviewMoreBtn button');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>불러오는 중...';
    
    fetch('${pageContext.request.contextPath}/tour/${tp.tripProdNo}/reviews?page=' + reviewPage)
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            // 리뷰 추가
            data.reviews.forEach(function(rv) {
                appendReview(rv);
            });
            
            // 더보기 버튼 상태
            if (!data.hasMore) {
                document.getElementById('reviewMoreBtn').style.display = 'none';
                showToast('모든 리뷰를 불러왔습니다.', 'info');
            } else {
                btn.disabled = false;
                btn.innerHTML = '더 많은 리뷰 보기 <i class="bi bi-chevron-down ms-1"></i>';
            }
            
            isLoadingReview = false;
        })
        .catch(function(error) {
            console.error('Error:', error);
            showToast('리뷰를 불러오는데 실패했습니다.', 'error');
            btn.disabled = false;
            btn.innerHTML = '더 많은 리뷰 보기 <i class="bi bi-chevron-down ms-1"></i>';
            isLoadingReview = false;
            reviewPage--;
        });
}

function appendReview(rv) {
    var reviewList = document.getElementById('reviewList');
    
    // 별점 HTML 생성
    var starsHtml = '';
    for (var i = 1; i <= 5; i++) {
        if (i <= rv.rating) {
            starsHtml += '<i class="bi bi-star-fill"></i> ';
        } else {
            starsHtml += '<i class="bi bi-star"></i> ';
        }
    }
    
    // 날짜 포맷
    var date = new Date(rv.prodRegdate);
    var dateStr = date.getFullYear() + '.' + 
                  String(date.getMonth() + 1).padStart(2, '0') + '.' + 
                  String(date.getDate()).padStart(2, '0');
    
    // 본인 리뷰인 경우 수정/삭제 드롭다운 추가
    var dropdownHtml = '';
    if (loginMemNo && loginMemNo === rv.memNo) {
        dropdownHtml = 
            '<div class="dropdown">' +
                '<button class="btn-more" type="button" data-bs-toggle="dropdown">' +
                    '<i class="bi bi-three-dots-vertical"></i>' +
                '</button>' +
                '<ul class="dropdown-menu dropdown-menu-end">' +
                    '<li><a class="dropdown-item" href="javascript:void(0)" onclick="openEditReviewModal(' + rv.prodRvNo + ', ' + rv.rating + ', \'' + escapeHtml(rv.prodReview).replace(/'/g, "\\'") + '\')">' +
                        '<i class="bi bi-pencil me-2"></i>수정</a></li>' +
                    '<li><a class="dropdown-item text-danger" href="javascript:void(0)" onclick="deleteReview(' + rv.prodRvNo + ')">' +
                        '<i class="bi bi-trash me-2"></i>삭제</a></li>' +
                '</ul>' +
            '</div>';
    }
    
    // 리뷰 이미지 HTML 생성
    var imagesHtml = '';
    if (rv.reviewImages && rv.reviewImages.length > 0) {
        imagesHtml = '<div class="review-images">';
        rv.reviewImages.forEach(function(img) {
            imagesHtml += '<img src="${pageContext.request.contextPath}/upload/review/' + img + '" alt="리뷰 이미지" onclick="openReviewImage(this.src)">';
        });
        imagesHtml += '</div>';
    }
    
    var html = 
        '<div class="review-item" data-review-id="' + rv.prodRvNo + '" style="animation: fadeIn 0.3s ease;">' +
            '<div class="review-item-header">' +
                '<div class="reviewer-info">' +
                    '<div class="reviewer-avatar">' +
                        '<i class="bi bi-person"></i>' +
                    '</div>' +
                    '<div>' +
                        '<span class="reviewer-name">' + escapeHtml(rv.nickname) + '</span>' +
                        '<span class="review-date">' + dateStr + '</span>' +
                    '</div>' +
                '</div>' +
                '<div class="d-flex align-items-center gap-2">' +
                    '<div class="review-rating">' + starsHtml + '</div>' +
                    dropdownHtml +
                '</div>' +
            '</div>' +
            '<div class="review-content">' +
                '<p>' + escapeHtml(rv.prodReview) + '</p>' +
            '</div>' +
            imagesHtml +
        '</div>';
    
    reviewList.insertAdjacentHTML('beforeend', html);
}

//리뷰 이미지 확대 보기
function openReviewImage(src) {
    // 간단한 이미지 모달
    var modal = document.createElement('div');
    modal.className = 'review-image-modal';
    modal.innerHTML = 
        '<div class="review-image-modal-content">' +
            '<button class="review-image-close" onclick="this.parentElement.parentElement.remove()">&times;</button>' +
            '<img src="' + src + '" alt="리뷰 이미지">' +
        '</div>';
    modal.onclick = function(e) {
        if (e.target === modal) modal.remove();
    };
    document.body.appendChild(modal);
}

//==================== 리뷰 수정/삭제 ====================
var editSelectedRating = 0;

function openEditReviewModal(reviewId, rating, content) {
    document.getElementById('editReviewId').value = reviewId;
    document.getElementById('editReviewRating').value = rating;
    document.getElementById('editReviewContent').value = content;
    document.getElementById('editReviewCharCount').textContent = content.length;
    
    editSelectedRating = rating;
    updateEditStars(rating);
    updateEditRatingText(rating);
    
    // 이미지 초기화
    editUploadedImages = [];
    renderEditImagePreviews();
    
    var modal = new bootstrap.Modal(document.getElementById('editReviewModal'));
    modal.show();
}

function updateEditStars(rating) {
    var stars = document.querySelectorAll('#editStarRating i');
    stars.forEach(function(star, index) {
        if (index < rating) {
            star.classList.remove('bi-star');
            star.classList.add('bi-star-fill');
        } else {
            star.classList.remove('bi-star-fill');
            star.classList.add('bi-star');
        }
    });
}

function updateEditRatingText(rating) {
    var texts = ['별점을 선택해주세요', '별로예요', '그저 그래요', '보통이에요', '좋아요', '최고예요!'];
    document.getElementById('editRatingText').textContent = texts[rating];
}

// 별점 클릭 이벤트
document.addEventListener('DOMContentLoaded', function() {
    var editStarRating = document.getElementById('editStarRating');
    if (editStarRating) {
        editStarRating.addEventListener('click', function(e) {
            if (e.target.tagName === 'I') {
                editSelectedRating = parseInt(e.target.dataset.rating);
                document.getElementById('editReviewRating').value = editSelectedRating;
                updateEditStars(editSelectedRating);
                updateEditRatingText(editSelectedRating);
            }
        });
        
        editStarRating.addEventListener('mouseover', function(e) {
            if (e.target.tagName === 'I') {
                var rating = parseInt(e.target.dataset.rating);
                updateEditStars(rating);
            }
        });
        
        editStarRating.addEventListener('mouseout', function() {
            updateEditStars(editSelectedRating);
        });
    }
    
    // 글자수 카운터
    var editReviewContent = document.getElementById('editReviewContent');
    if (editReviewContent) {
        editReviewContent.addEventListener('input', function() {
            document.getElementById('editReviewCharCount').textContent = this.value.length;
        });
    }
});

function updateReview() {
    var reviewId = document.getElementById('editReviewId').value;
    var rating = document.getElementById('editReviewRating').value;
    var content = document.getElementById('editReviewContent').value.trim();
    
    if (rating == 0) {
        showToast('별점을 선택해주세요.', 'warning');
        return;
    }
    
    if (content.length < 20) {
        showToast('리뷰 내용을 20자 이상 입력해주세요.', 'warning');
        document.getElementById('editReviewContent').focus();
        return;
    }
    
    // 이미지 데이터도 함께 전송
    console.log('리뷰 수정:', { 
        reviewId: reviewId, 
        rating: rating, 
        content: content,
        images: editUploadedImages.length + '장'
    });
    
    // var formData = new FormData();
    // formData.append('reviewId', reviewId);
    // formData.append('rating', rating);
    // formData.append('content', content);
    // editUploadedImages.forEach(function(img, index) {
    //     formData.append('images', img.file);
    // });
    
    // UI 업데이트
    var reviewItem = document.querySelector('[data-review-id="' + reviewId + '"]');
    if (reviewItem) {
        reviewItem.querySelector('.review-content p').textContent = content;
        
        var starsHtml = '';
        for (var i = 1; i <= 5; i++) {
            starsHtml += i <= rating ? '<i class="bi bi-star-fill"></i>' : '<i class="bi bi-star"></i>';
        }
        reviewItem.querySelector('.review-rating').innerHTML = starsHtml;
    }
    
    bootstrap.Modal.getInstance(document.getElementById('editReviewModal')).hide();
    showToast('리뷰가 수정되었습니다.', 'success');
}

function deleteReview(reviewId) {
    showCustomConfirm('리뷰 삭제', '삭제된 리뷰는 복구할 수 없습니다.<br>정말 삭제하시겠습니까?', function() {
        console.log('리뷰 삭제:', reviewId);
        
        var reviewItem = document.querySelector('[data-review-id="' + reviewId + '"]');
        if (reviewItem) {
            reviewItem.style.animation = 'fadeOut 0.3s ease';
            setTimeout(function() {
                reviewItem.remove();
            }, 300);
        }
        
        showToast('리뷰가 삭제되었습니다.', 'success');
    });
}

//==================== 리뷰 이미지 업로드 ====================
var editUploadedImages = [];

// 이미지 업로드 이벤트
document.getElementById('editReviewImages').addEventListener('change', function(e) {
    var files = Array.from(e.target.files);
    
    if (editUploadedImages.length + files.length > 5) {
        showToast('이미지는 최대 5장까지 첨부 가능합니다.', 'warning');
        return;
    }
    
    files.forEach(function(file) {
        if (file.type.startsWith('image/')) {
            var reader = new FileReader();
            reader.onload = function(e) {
                editUploadedImages.push({
                    data: e.target.result,
                    file: file
                });
                renderEditImagePreviews();
            };
            reader.readAsDataURL(file);
        }
    });
    
    e.target.value = '';
});

function renderEditImagePreviews() {
    var container = document.getElementById('editImagePreviewList');
    var html = '';
    
    editUploadedImages.forEach(function(img, index) {
        html += 
            '<div class="image-preview-item">' +
                '<img src="' + img.data + '" alt="이미지">' +
                '<button type="button" class="remove-btn" onclick="removeEditImage(' + index + ')">&times;</button>' +
            '</div>';
    });
    
    container.innerHTML = html;
}

function removeEditImage(index) {
    editUploadedImages.splice(index, 1);
    renderEditImagePreviews();
}

// ==================== 판매자 문의 기능 ====================

// 문의 폼 제출
document.getElementById('inquiryForm').addEventListener('submit', function(e) {
    e.preventDefault();

    // 로그인 체크
    var isLoggedIn = ${not empty sessionScope.loginMember};
    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    // 폼 데이터 수집
    var inquiryType = document.getElementById('inquiryType').value;
    var inquiryContent = document.getElementById('inquiryContent').value;
    var isSecret = document.getElementById('inquirySecret').checked;

    // 유효성 검사
    if (!inquiryType) {
        showToast('문의 유형을 선택해주세요.', 'warning');
        document.getElementById('inquiryType').focus();
        return;
    }

    if (!inquiryContent.trim()) {
        showToast('문의 내용을 입력해주세요.', 'warning');
        document.getElementById('inquiryContent').focus();
        return;
    }

    if (inquiryContent.trim().length < 10) {
        showToast('문의 내용을 10자 이상 입력해주세요.', 'warning');
        document.getElementById('inquiryContent').focus();
        return;
    }

    // 문의 데이터 객체
    var inquiryData = {
        inquiryCtgry: inquiryType,
        prodInqryCn: inquiryContent.trim(),
        secretYn: isSecret ? 'Y' : 'N'
    };

    // 버튼 비활성화
    var submitBtn = this.querySelector('button[type="submit"]');
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>등록 중...';

    // Ajax 요청
    fetch('${pageContext.request.contextPath}/tour/${tp.tripProdNo}/inquiry', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(inquiryData)
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        if (data.success) {
            showToast(data.message, 'success');
            
            // 폼 초기화
            document.getElementById('inquiryForm').reset();
            
            // 새 문의를 목록에 추가
            addNewInquiryToList(data.inquiry);
            
            // 문의 개수 업데이트
            var countEl = document.querySelector('.inquiry-count');
            if (countEl) {
                var currentCount = parseInt(countEl.textContent.replace(/[()]/g, '')) || 0;
                countEl.textContent = '(' + (currentCount + 1) + ')';
            }
        } else {
            showToast(data.message, 'error');
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
        showToast('문의 등록에 실패했습니다.', 'error');
    })
    .finally(function() {
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="bi bi-send me-2"></i>문의 등록';
    });
});

// 새 문의를 목록에 추가
function addNewInquiryToList(inq) {
	var inquiryList = document.getElementById('inquiryList');
    if (!inquiryList) return;
    
    // 빈 문의 메시지 제거
    var noInquiry = inquiryList.querySelector('.no-inquiry');
    if (noInquiry) {
        noInquiry.remove();
    }

    // 문의 유형 라벨
    var typeLabels = {
        'product': '상품 문의',
        'booking': '예약/일정',
        'price': '가격/결제',
        'cancel': '취소/환불',
        'other': '기타'
    };

    // 날짜 포맷
    var today = new Date();
    var dateStr = today.getFullYear() + '.' +
                  String(today.getMonth() + 1).padStart(2, '0') + '.' +
                  String(today.getDate()).padStart(2, '0');

    var typeLabel = typeLabels[inq.inquiryCtgry] || '기타';
    var typeClass = inq.inquiryCtgry || 'other';
    var isSecret = inq.secretYn === 'Y';
    
    // 닉네임: 서버 응답값 또는 세션값 사용
    var nickname = inq.inquiryNickname || '${sessionScope.loginMember.memUser.nickname}' || '회원';

    // 새 문의 HTML 생성
    var newInquiryHtml =
        '<div class="inquiry-item new-inquiry" data-inquiry-id="' + inq.prodInqryNo + '" style="animation: slideIn 0.3s ease-out;">' +
            '<div class="inquiry-item-header">' +
                '<div class="inquiry-item-info">' +
                    '<span class="inquiry-type-badge ' + typeClass + '">' + typeLabel + '</span>' +
                    '<span class="inquiry-author">' + escapeHtml(nickname) + '</span>' +
                    '<span class="inquiry-date">' + dateStr + '</span>' +
                    (isSecret ? '<span class="secret-badge"><i class="bi bi-lock"></i> 비밀글</span>' : '') +
                '</div>' +
                '<div class="d-flex align-items-center gap-2">' +
                    '<span class="inquiry-status waiting">답변대기</span>' +
                    '<div class="dropdown">' +
                        '<button class="btn-more" type="button" data-bs-toggle="dropdown">' +
                            '<i class="bi bi-three-dots-vertical"></i>' +
                        '</button>' +
                        '<ul class="dropdown-menu dropdown-menu-end">' +
                            '<li><a class="dropdown-item" href="javascript:void(0)" onclick="openEditInquiryModal(' + inq.prodInqryNo + ', \'' + inq.inquiryCtgry + '\', \'' + escapeHtml(inq.prodInqryCn).replace(/'/g, "\\'") + '\', \'' + inq.secretYn + '\')">' +
                                '<i class="bi bi-pencil me-2"></i>수정</a></li>' +
                            '<li><a class="dropdown-item text-danger" href="javascript:void(0)" onclick="deleteInquiry(' + inq.prodInqryNo + ')">' +
                                '<i class="bi bi-trash me-2"></i>삭제</a></li>' +
                        '</ul>' +
                    '</div>' +
                '</div>' +
            '</div>' +
            '<div class="inquiry-item-question">' +
                '<p><strong>Q.</strong> ' + escapeHtml(inq.prodInqryCn) + '</p>' +
            '</div>' +
        '</div>';

    // 목록 맨 앞에 추가
    inquiryList.insertAdjacentHTML('afterbegin', newInquiryHtml);
}

// HTML 이스케이프 함수
function escapeHtml(text) {
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

//==================== 문의 더보기 기능 ====================
var inquiryPage = 1;
var totalInquiryCount = ${inquiryCount != null ? inquiryCount : 0};
var isLoadingInquiry = false;
var loginMemNo = ${sessionScope.loginMember != null ? sessionScope.loginMember.memNo : 'null'};

function loadMoreInquiries() {
    if (isLoadingInquiry) return;
    
    isLoadingInquiry = true;
    inquiryPage++;
    
    var btn = document.querySelector('#inquiryMoreBtn button');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>불러오는 중...';
    
    fetch('${pageContext.request.contextPath}/tour/${tp.tripProdNo}/inquiries?page=' + inquiryPage)
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            // 문의 추가
            data.inquiries.forEach(function(inq) {
                appendInquiry(inq, data.loginMemNo);
            });
            
            // 더보기 버튼 상태
            if (!data.hasMore) {
                document.getElementById('inquiryMoreBtn').style.display = 'none';
                showToast('모든 문의를 불러왔습니다.', 'info');
            } else {
                btn.disabled = false;
                btn.innerHTML = '더 많은 문의 보기 <i class="bi bi-chevron-down ms-1"></i>';
            }
            
            isLoadingInquiry = false;
        })
        .catch(function(error) {
            console.error('Error:', error);
            showToast('문의를 불러오는데 실패했습니다.', 'error');
            btn.disabled = false;
            btn.innerHTML = '더 많은 문의 보기 <i class="bi bi-chevron-down ms-1"></i>';
            isLoadingInquiry = false;
            inquiryPage--;
        });
}

function appendInquiry(inq, loginMemNo) {
    var inquiryList = document.getElementById('inquiryList');
    
    // 문의 유형 뱃지
    var typeLabels = {
        'product': '상품 문의',
        'booking': '예약/일정',
        'price': '가격/결제',
        'cancel': '취소/환불',
        'other': '기타'
    };
    var typeLabel = typeLabels[inq.inquiryCtgry] || '기타';
    var typeClass = inq.inquiryCtgry || 'other';
    
    // 날짜 포맷
    var regDate = new Date(inq.regDt);
    var regDateStr = regDate.getFullYear() + '.' + 
                     String(regDate.getMonth() + 1).padStart(2, '0') + '.' + 
                     String(regDate.getDate()).padStart(2, '0');
    
    // 닉네임
    var nickname = inq.inquiryNickname || '회원';
    
    // 비밀글 여부 및 본인 확인
    var isSecret = inq.secretYn === 'Y';
    var isOwner = loginMemNo && loginMemNo === inq.inquiryMemNo;
    var isBusiness = loginMemType === 'BUSINESS';
    
    // 답변 상태
    var isAnswered = inq.inqryStatus === 'DONE';
    var statusClass = isAnswered ? 'answered' : 'waiting';
    var statusText = isAnswered ? '답변완료' : '답변대기';
    
    // 문의 내용 (비밀글 처리)
    var questionHtml = '';
    if (isSecret && !isOwner && !isBusiness) {
        questionHtml = '<p class="secret-content"><i class="bi bi-lock me-1"></i>비밀글로 작성된 문의입니다.</p>';
    } else {
        questionHtml = '<p><strong>Q.</strong> ' + escapeHtml(inq.prodInqryCn) + '</p>';
    }
    
    // 답변 내용
    var answerHtml = '';
    if (isAnswered && inq.replyCn && (!isSecret || isOwner || isBusiness)) {
        var replyDate = new Date(inq.replyDt);
        var replyDateStr = replyDate.getFullYear() + '.' + 
                           String(replyDate.getMonth() + 1).padStart(2, '0') + '.' + 
                           String(replyDate.getDate()).padStart(2, '0');
        
        answerHtml = 
            '<div class="inquiry-item-answer">' +
                '<div class="answer-header">' +
                    '<span class="answer-badge"><i class="bi bi-building"></i> 판매자 답변</span>' +
                    '<span class="answer-date">' + replyDateStr + '</span>' +
                '</div>' +
                '<p><strong>A.</strong> ' + escapeHtml(inq.replyCn) + '</p>' +
            '</div>';
    }
    
    var html = 
        '<div class="inquiry-item" data-inquiry-id="' + inq.prodInqryNo + '" style="animation: slideIn 0.3s ease-out;">' +
            '<div class="inquiry-item-header">' +
                '<div class="inquiry-item-info">' +
                    '<span class="inquiry-type-badge ' + typeClass + '">' + typeLabel + '</span>' +
                    '<span class="inquiry-author">' + escapeHtml(nickname) + '</span>' +
                    '<span class="inquiry-date">' + regDateStr + '</span>' +
                    (isSecret ? '<span class="secret-badge"><i class="bi bi-lock"></i> 비밀글</span>' : '') +
                '</div>' +
                '<span class="inquiry-status ' + statusClass + '">' + statusText + '</span>' +
            '</div>' +
            '<div class="inquiry-item-question">' + questionHtml + '</div>' +
            answerHtml +
        '</div>';
    
    inquiryList.insertAdjacentHTML('beforeend', html);
}

//==================== 문의 수정/삭제 ====================

function openEditInquiryModal(inquiryId, type, content, secretYn) {
    document.getElementById('editInquiryId').value = inquiryId;
    document.getElementById('editInquiryType').value = type;
    document.getElementById('editInquiryContent').value = content;
    document.getElementById('editInquirySecret').checked = (secretYn === 'Y');
    
    var modal = new bootstrap.Modal(document.getElementById('editInquiryModal'));
    modal.show();
}

function updateInquiry() {
    var inquiryId = document.getElementById('editInquiryId').value;
    var type = document.getElementById('editInquiryType').value;
    var content = document.getElementById('editInquiryContent').value.trim();
    var isSecret = document.getElementById('editInquirySecret').checked;
    
    if (!content) {
        showToast('문의 내용을 입력해주세요.', 'warning');
        return;
    }
    
    if (content.length < 10) {
        showToast('문의 내용을 10자 이상 입력해주세요.', 'warning');
        return;
    }
    
    var inquiryData = {
        prodInqryNo: inquiryId,
        inquiryCtgry: type,
        prodInqryCn: content,
        secretYn: isSecret ? 'Y' : 'N'
    };
    
    fetch('${pageContext.request.contextPath}/tour/${tp.tripProdNo}/inquiry/update', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(inquiryData)
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        if (data.success) {
            var inquiryItem = document.querySelector('[data-inquiry-id="' + inquiryId + '"]');
            if (inquiryItem) {
                var typeLabels = {
                    'product': '상품 문의',
                    'booking': '예약/일정',
                    'price': '가격/결제',
                    'cancel': '취소/환불',
                    'other': '기타'
                };
                
                var badge = inquiryItem.querySelector('.inquiry-type-badge');
                badge.className = 'inquiry-type-badge ' + type;
                badge.textContent = typeLabels[type];
                
                var questionP = inquiryItem.querySelector('.inquiry-item-question p');
                questionP.className = '';
                questionP.innerHTML = '<strong>Q.</strong> ' + escapeHtml(content);
                
                // 비밀글 뱃지 처리
                var secretBadge = inquiryItem.querySelector('.secret-badge');
                if (isSecret) {
                    if (!secretBadge) {
                        var infoDiv = inquiryItem.querySelector('.inquiry-item-info');
                        infoDiv.insertAdjacentHTML('beforeend', '<span class="secret-badge"><i class="bi bi-lock"></i> 비밀글</span>');
                    }
                } else {
                    if (secretBadge) secretBadge.remove();
                }
            }
            
            bootstrap.Modal.getInstance(document.getElementById('editInquiryModal')).hide();
            showToast(data.message, 'success');
        } else {
            showToast(data.message, 'error');
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
        showToast('문의 수정에 실패했습니다.', 'error');
    });
}

function deleteInquiry(inquiryId) {
    showCustomConfirm('문의 삭제', '삭제된 문의는 복구할 수 없습니다.<br>정말 삭제하시겠습니까?', function() {
        fetch('${pageContext.request.contextPath}/tour/${tp.tripProdNo}/inquiry/delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ prodInqryNo: inquiryId })
        })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            if (data.success) {
                var inquiryItem = document.querySelector('[data-inquiry-id="' + inquiryId + '"]');
                if (inquiryItem) {
                    inquiryItem.style.animation = 'fadeOut 0.3s ease';
                    setTimeout(function() {
                        inquiryItem.remove();
                    }, 300);
                }
                
                var countEl = document.querySelector('.inquiry-count');
                if (countEl) {
                    var currentCount = parseInt(countEl.textContent.replace(/[()]/g, '')) || 0;
                    countEl.textContent = '(' + (currentCount - 1) + ')';
                }
                
                showToast(data.message, 'success');
            } else {
                showToast(data.message, 'error');
            }
        })
        .catch(function(error) {
            console.error('Error:', error);
            showToast('문의 삭제에 실패했습니다.', 'error');
        });
    });
}

// ==================== 기업회원 답변 기능 ====================

// 답변 폼 토글
function toggleReplyForm(inquiryId) {
    var form = document.getElementById('replyForm_' + inquiryId);
    var btn = form.previousElementSibling;

    if (form.style.display === 'none') {
        form.style.display = 'block';
        btn.style.display = 'none';
        document.getElementById('replyContent_' + inquiryId).focus();
    } else {
        form.style.display = 'none';
        btn.style.display = 'inline-flex';
    }
}

// 답변 등록
function submitReply(inquiryId) {
    var content = document.getElementById('replyContent_' + inquiryId).value.trim();

    if (!content) {
        showToast('답변 내용을 입력해주세요.', 'warning');
        return;
    }

    if (content.length < 10) {
        showToast('답변은 10자 이상 입력해주세요.', 'warning');
        return;
    }

    // 서버에 답변 등록 요청
    fetch('${pageContext.request.contextPath}/tour/${tp.tripProdNo}/inquiry/reply', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            prodInqryNo: inquiryId,
            replyCn: content
        })
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        if (data.success) {
            // 성공 시 UI 업데이트
            var inquiryItem = document.querySelector('[data-inquiry-id="' + inquiryId + '"]');
            if (inquiryItem) {
                // 상태 변경
                var statusBadge = inquiryItem.querySelector('.inquiry-status');
                statusBadge.className = 'inquiry-status answered';
                statusBadge.textContent = '답변완료';

                // 답변 영역 추가
                var questionDiv = inquiryItem.querySelector('.inquiry-item-question');
                var today = new Date();
                var dateStr = today.getFullYear() + '.' +
                              String(today.getMonth() + 1).padStart(2, '0') + '.' +
                              String(today.getDate()).padStart(2, '0');

                var answerHtml =
                    '<div class="inquiry-item-answer" id="answer_' + inquiryId + '" style="animation: slideIn 0.3s ease-out;">' +
                        '<div class="answer-header">' +
                            '<span class="answer-badge"><i class="bi bi-building"></i> 판매자 답변</span>' +
                            '<div class="d-flex align-items-center gap-2">' +
                                '<span class="answer-date">' + dateStr + '</span>' +
                                '<div class="dropdown">' +
                                    '<button class="btn-more btn-more-sm" type="button" data-bs-toggle="dropdown">' +
                                        '<i class="bi bi-three-dots-vertical"></i>' +
                                    '</button>' +
                                    '<ul class="dropdown-menu dropdown-menu-end">' +
                                        '<li><a class="dropdown-item" href="javascript:void(0)" onclick="openEditReplyModal(' + inquiryId + ', \'' + escapeHtml(content).replace(/'/g, "\\'") + '\')">' +
                                            '<i class="bi bi-pencil me-2"></i>수정</a></li>' +
                                        '<li><a class="dropdown-item text-danger" href="javascript:void(0)" onclick="deleteReply(' + inquiryId + ')">' +
                                            '<i class="bi bi-trash me-2"></i>삭제</a></li>' +
                                    '</ul>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                        '<p class="answer-content"><strong>A.</strong> ' + escapeHtml(content) + '</p>' +
                    '</div>';

                questionDiv.insertAdjacentHTML('afterend', answerHtml);

                // 답변 폼 영역 제거
                var replySection = inquiryItem.querySelector('.business-reply-section');
                if (replySection) {
                    replySection.remove();
                }
            }

            showToast(data.message, 'success');
        } else {
            showToast(data.message, 'error');
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
        showToast('답변 등록에 실패했습니다.', 'error');
    });
}

//==================== 답변 수정/삭제 ====================

function openEditReplyModal(inquiryId, content) {
    document.getElementById('editReplyInquiryId').value = inquiryId;
    document.getElementById('editReplyContent').value = content;
    
    var modal = new bootstrap.Modal(document.getElementById('editReplyModal'));
    modal.show();
}

function updateReply() {
    var inquiryId = document.getElementById('editReplyInquiryId').value;
    var content = document.getElementById('editReplyContent').value.trim();
    
    if (!content) {
        showToast('답변 내용을 입력해주세요.', 'warning');
        return;
    }
    
    if (content.length < 10) {
        showToast('답변은 10자 이상 입력해주세요.', 'warning');
        return;
    }
    
    fetch('${pageContext.request.contextPath}/tour/${tp.tripProdNo}/inquiry/reply/update', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            prodInqryNo: inquiryId,
            replyCn: content
        })
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        if (data.success) {
            // UI 업데이트
            var answerDiv = document.getElementById('answer_' + inquiryId);
            if (answerDiv) {
                var contentP = answerDiv.querySelector('.answer-content');
                if (contentP) {
                    contentP.innerHTML = '<strong>A.</strong> ' + escapeHtml(content);
                }
            }
            
            bootstrap.Modal.getInstance(document.getElementById('editReplyModal')).hide();
            showToast(data.message, 'success');
        } else {
            showToast(data.message, 'error');
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
        showToast('답변 수정에 실패했습니다.', 'error');
    });
}

function deleteReply(inquiryId) {
    showCustomConfirm('답변 삭제', '답변을 삭제하시겠습니까?<br><small class="text-muted">삭제 시 문의 상태가 답변대기로 변경됩니다.</small>', function() {
        fetch('${pageContext.request.contextPath}/tour/${tp.tripProdNo}/inquiry/reply/delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                prodInqryNo: inquiryId
            })
        })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            if (data.success) {
                var inquiryItem = document.querySelector('[data-inquiry-id="' + inquiryId + '"]');
                if (inquiryItem) {
                    var answerDiv = document.getElementById('answer_' + inquiryId);
                    if (answerDiv) {
                        answerDiv.remove();
                    }
                    
                    var statusBadge = inquiryItem.querySelector('.inquiry-status');
                    statusBadge.className = 'inquiry-status waiting';
                    statusBadge.textContent = '답변대기';
                    
                    var questionDiv = inquiryItem.querySelector('.inquiry-item-question');
                    var replySection = 
                        '<div class="business-reply-section">' +
                            '<button class="btn btn-sm btn-primary" onclick="toggleReplyForm(' + inquiryId + ')">' +
                                '<i class="bi bi-reply me-1"></i>답변하기' +
                            '</button>' +
                            '<div class="reply-form" id="replyForm_' + inquiryId + '" style="display: none;">' +
                                '<textarea class="form-control" id="replyContent_' + inquiryId + '" rows="3" placeholder="답변 내용을 입력하세요..."></textarea>' +
                                '<div class="reply-form-actions">' +
                                    '<button class="btn btn-sm btn-outline" onclick="toggleReplyForm(' + inquiryId + ')">취소</button>' +
                                    '<button class="btn btn-sm btn-primary" onclick="submitReply(' + inquiryId + ')">답변 등록</button>' +
                                '</div>' +
                            '</div>' +
                        '</div>';
                    questionDiv.insertAdjacentHTML('afterend', replySection);
                }
                
                showToast(data.message, 'success');
            } else {
                showToast(data.message, 'error');
            }
        })
        .catch(function(error) {
            console.error('Error:', error);
            showToast('답변 삭제에 실패했습니다.', 'error');
        });
    });
}

//==================== 커스텀 확인 모달 (동적 생성) ====================
var confirmCallback = null;

function showCustomConfirm(title, message, callback) {
    // 기존 모달 제거
    var existing = document.getElementById('customConfirmOverlay');
    if (existing) existing.remove();
    
    // 콜백 저장
    confirmCallback = callback;
    
    // 모달 HTML 동적 생성
    var modalHtml = 
        '<div class="custom-confirm-overlay" id="customConfirmOverlay" style="' +
            'display: flex; position: fixed; top: 0; left: 0; right: 0; bottom: 0; ' +
            'width: 100vw; height: 100vh; background: rgba(0,0,0,0.5); ' +
            'z-index: 2147483647; justify-content: center; align-items: center;">' +
            '<div class="custom-confirm-modal" style="' +
                'background: white; border-radius: 16px; box-shadow: 0 10px 40px rgba(0,0,0,0.3); ' +
                'width: 320px; max-width: 90%; animation: confirmSlideIn 0.2s ease-out;">' +
                '<div style="padding: 30px 24px 20px; text-align: center;">' +
                    '<div style="width: 70px; height: 70px; margin: 0 auto 16px; background: #fef3c7; ' +
                        'border-radius: 50%; display: flex; align-items: center; justify-content: center;">' +
                        '<i class="bi bi-exclamation-triangle text-warning" style="font-size: 36px;"></i>' +
                    '</div>' +
                    '<h5 style="font-size: 18px; font-weight: 600; color: #333; margin-bottom: 8px;">' + title + '</h5>' +
                    '<p style="font-size: 14px; color: #666; margin: 0; line-height: 1.5;">' + message + '</p>' +
                '</div>' +
                '<div style="display: flex; gap: 10px; padding: 16px 24px 24px; justify-content: center;">' +
                    '<button type="button" class="btn btn-outline" id="confirmCancelBtn" ' +
                        'style="min-width: 80px; padding: 10px 20px; border-radius: 8px;">취소</button>' +
                    '<button type="button" class="btn btn-danger" id="confirmOkBtn" ' +
                        'style="min-width: 80px; padding: 10px 20px; border-radius: 8px;">삭제</button>' +
                '</div>' +
            '</div>' +
        '</div>';
    
    // body 맨 끝에 추가
    document.body.insertAdjacentHTML('beforeend', modalHtml);
    document.body.style.overflow = 'hidden';
    
    // 이벤트 바인딩
    var overlay = document.getElementById('customConfirmOverlay');
    
    // 확인 버튼
    document.getElementById('confirmOkBtn').onclick = function() {
        hideConfirm();
        if (confirmCallback) {
            confirmCallback();
        }
        confirmCallback = null;
    };
    
    // 취소 버튼
    document.getElementById('confirmCancelBtn').onclick = function() {
        hideConfirm();
        confirmCallback = null;
    };
    
    // 오버레이 클릭
    overlay.onclick = function(e) {
        if (e.target === overlay) {
            hideConfirm();
            confirmCallback = null;
        }
    };
}

function hideConfirm() {
    var overlay = document.getElementById('customConfirmOverlay');
    if (overlay) {
        overlay.remove();
    }
    document.body.style.overflow = '';
}

// ESC 키로 닫기
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        var overlay = document.getElementById('customConfirmOverlay');
        if (overlay) {
            hideConfirm();
            confirmCallback = null;
        }
    }
});
</script>

<%@ include file="../common/footer.jsp" %>
