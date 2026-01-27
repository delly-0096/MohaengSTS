/**
 * Tour Detail Page JavaScript
 * 
 * 전역 변수 (JSP에서 선언):
 * - CONTEXT_PATH: 컨텍스트 경로
 * - TRIP_PROD_NO: 상품 번호
 * - pricePerPerson: 1인당 가격
 * - loginMemNo: 로그인 회원 번호
 * - loginMemType: 로그인 회원 타입
 * - isLoggedIn: 로그인 여부
 * - totalReviewCount: 전체 리뷰 수
 * - totalInquiryCount: 전체 문의 수
 * - currentProduct: 현재 상품 정보 객체
 */

// 장바구니 데이터
var cart = [];

function changeMainImage(img, index) {
    if (typeof index !== 'undefined') {
        currentImageIndex = index;
    } else {
        // index가 없으면 src로 찾기
        var thumbs = document.querySelectorAll('#galleryThumbs img');
        thumbs.forEach(function(thumb, i) {
            if (thumb.src === img.src) {
                currentImageIndex = i;
            }
        });
    }
    
    var mainImage = document.getElementById('mainImage');
    mainImage.style.opacity = '0';
    
    setTimeout(function() {
        mainImage.src = img.src;
        mainImage.style.opacity = '1';
    }, 150);
    
    updateGalleryCounter();
    updateThumbnailActive();
}

function updateTotal() {
    var selectEl = document.getElementById('bookingPeople');
    var selectedValue = selectEl.value;
    
    // 5명 이상인 경우
    if (selectedValue === '5+') {
        document.getElementById('totalPrice').textContent = '문의 필요';
        return;
    }
    
    var people = parseInt(selectedValue);
    var total = pricePerPerson * people;
    document.getElementById('totalPrice').textContent = total.toLocaleString() + '원';
}

// ==================== 인원 선택 관련 ====================

// 5명 이상 선택 시 안내 메시지 표시
function checkGroupBooking() {
    var selectEl = document.getElementById('bookingPeople');
    var noticeEl = document.getElementById('groupBookingNotice');
    
    if (!selectEl || !noticeEl) return;
    
    var selectedValue = selectEl.value;
    
    if (selectedValue === '5+') {
        noticeEl.style.display = 'block';
        disableBookingButtons(true);
    } else {
        noticeEl.style.display = 'none';
        disableBookingButtons(false);
    }
}

// 결제/장바구니 버튼 비활성화
function disableBookingButtons(disable) {
    var bookingActions = document.querySelector('.booking-actions');
    if (!bookingActions) return;
    
    var buttons = bookingActions.querySelectorAll('button');
    buttons.forEach(function(btn) {
        if (disable) {
            btn.disabled = true;
            btn.classList.add('disabled');
        } else {
            btn.disabled = false;
            btn.classList.remove('disabled');
        }
    });
}

// 문의하기 섹션으로 스크롤
function scrollToInquiry() {
    var inquirySection = document.querySelector('.inquiry-section');
    if (inquirySection) {
        inquirySection.scrollIntoView({ behavior: 'smooth', block: 'start' });
        
        // 문의 유형을 '예약/일정 문의'로 자동 선택
        setTimeout(function() {
            var inquiryType = document.getElementById('inquiryType');
            if (inquiryType) {
                inquiryType.value = 'booking';
            }
            var inquiryContent = document.getElementById('inquiryContent');
            if (inquiryContent) {
                inquiryContent.focus();
            }
        }, 500);
    }
}

function addToBookmark() {
    if (!isLoggedIn) {
        sessionStorage.setItem('returnUrl', window.location.href);
        showToast('로그인이 필요한 서비스입니다.', 'warning');
        setTimeout(function() {
            window.location.href = CONTEXT_PATH + '/member/login';
        }, 1000);
        return;
    }

    showToast('북마크에 추가되었습니다.', 'success');
}

document.getElementById('bookingForm').addEventListener('submit', function(e) {
    e.preventDefault();

	if (!isLoggedIn) {
	    sessionStorage.setItem('returnUrl', window.location.href);
	    showToast('로그인이 필요한 서비스입니다.', 'warning');
	    setTimeout(function() {
	        window.location.href = CONTEXT_PATH + '/member/login';
	    }, 1000);
	    return;
	}

    const date = document.getElementById('bookingDate').value;
    const time = document.getElementById('bookingTime').value;
	const people = document.getElementById('bookingPeople').value;

    if (!date || !time) {
        showToast('날짜와 시간을 선택해주세요.', 'error');
        return;
    }
	
	// 5명 이상 선택 시 결제 차단
    if (people === '5+') {
        showToast('5명 이상 단체 예약은 판매자 문의를 이용해주세요.', 'warning');
        scrollToInquiry();
        return;
    }

    // 결제 페이지로 이동
    window.location.href = CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/booking?date=' + date + '&time=' + time +
                           '&people=' + people;
});

// 페이지 로드시
document.addEventListener('DOMContentLoaded', function() {
    loadCart();
    updateCartUI();
    updateTotal();
	initMap();
	initGalleryNavigation();
	initBookingDatePicker();
});


// ==================== 장바구니 기능 ====================

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
    var peopleValue = document.getElementById('bookingPeople').value;
    
    // 5명 이상 선택 시 장바구니 추가 차단
    if (peopleValue === '5+') {
        showToast('5명 이상 단체 예약은 판매자 문의를 이용해주세요.', 'warning');
        scrollToInquiry();
        return;
    }
    
    var people = parseInt(peopleValue) || minPeople;
	var stock = currentProduct.stock || 999;

    // 이미 장바구니에 있는지 확인
    var existingItem = cart.find(function(item) {
        return item.id === currentProduct.id;
    });

    if (existingItem) {
		var newQuantity = existingItem.quantity + people;
		
		if (newQuantity > stock) {
            showToast('재고가 부족합니다 (남은 재고: ' + stock + '개)', 'warning');
            return;
        }
		
	    if (newQuantity > 4) {
	        showToast('5명 이상 단체 예약은 판매자에게 문의해주세요', 'warning');
	        return;
	    }
		
	    existingItem.quantity = newQuantity;
	    showToast('장바구니에 ' + people + '명 추가되었습니다', 'success');
    } else {
		if (people > stock) {
	        showToast('재고가 부족합니다 (남은 재고: ' + stock + '개)', 'warning');
	        return;
	    }
		
        cart.push({
            id: currentProduct.id,
            name: currentProduct.name,
            price: currentProduct.price,
            image: currentProduct.image,
			location: currentProduct.location,
			minPeople: minPeople,
            quantity: people,
			stock: stock,
			saleEndDt: saleEndDt
        });
		
		if (minPeople > 1) {
            showToast('장바구니에 담겼습니다 (최소 ' + minPeople + '명)', 'success');
        } else {
            showToast('장바구니에 담겼습니다 (' + people + '명)', 'success');
        }
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
		var newQuantity = item.quantity + delta;
		var itemMinPeople = item.minPeople || 1;
		var maxPeople = 4;
		var stock = item.stock || 999;

		if (newQuantity < itemMinPeople) {
            showToast('최소 인원은 ' + itemMinPeople + '명입니다', 'warning');
            return;
        }
		
		if (newQuantity > stock) {
            showToast('재고가 부족합니다 (남은 재고: ' + stock + '개)', 'warning');
            return;
        }
		
		if (newQuantity > maxPeople) {
            showToast('5명 이상 단체 예약은 판매자에게 문의해주세요', 'warning');
            return;
        }

		item.quantity = newQuantity;
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
		var itemMinPeople = item.minPeople || 1;
		
		var minPeopleHtml = itemMinPeople > 1 
            ? '<div class="cart-item-min-people"><i class="bi bi-people"></i> 최소 ' + itemMinPeople + '명</div>' 
            : '';
		
        html += '<div class="cart-item" data-id="' + item.id + '">' +
            '<div class="cart-item-image">' +
                '<img src="' + item.image + '" alt="' + item.name + '">' +
            '</div>' +
            '<div class="cart-item-info">' +
                '<div class="cart-item-name">' + item.name + '</div>' +
				minPeopleHtml +
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
    var overlay = document.getElementById('cartOverlay');
    var sidebar = document.getElementById('cartSidebar');
    if (overlay) overlay.classList.add('active');
    if (sidebar) sidebar.classList.add('active');
    document.body.style.overflow = 'hidden';
}

// 장바구니 닫기
function closeCart() {
    var overlay = document.getElementById('cartOverlay');
    var sidebar = document.getElementById('cartSidebar');
    if (overlay) overlay.classList.remove('active');
    if (sidebar) sidebar.classList.remove('active');
    document.body.style.overflow = '';
}

// 결제하기 (체크아웃)
function checkout() {
    if (cart.length === 0) {
        showToast('장바구니가 비어있습니다', 'warning');
        return;
    }

    // 로그인 체크
	if (!isLoggedIn) {
	    sessionStorage.setItem('returnUrl', window.location.href);
	    showToast('로그인이 필요한 서비스입니다.', 'warning');
	    setTimeout(function() {
	        window.location.href = CONTEXT_PATH + '/member/login';
	    }, 1000);
	    return;
	}

    // 장바구니 데이터를 sessionStorage에 저장 (결제 페이지에서 사용)
    sessionStorage.setItem('tourCartCheckout', JSON.stringify(cart));

    // 결제 페이지로 이동
	var prodIds = cart.map(function(item) { return item.id; }).join(',');
    window.location.href = CONTEXT_PATH + '/tour/cart/booking?prodIds=' + prodIds;
}

// ESC 키로 장바구니 닫기
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeCart();
    }
});

// ==================== 리뷰 더보기 기능 ====================
var reviewPage = 1;
var isLoadingReview = false;

function loadMoreReviews() {
    if (isLoadingReview) return;
    
    isLoadingReview = true;
    reviewPage++;
    
    var btn = document.querySelector('#reviewMoreBtn button');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>불러오는 중...';
    
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/reviews?page=' + reviewPage)
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
    
    // 프로필 이미지 HTML
    var avatarHtml = '';
    if (rv.profileImage) {
        avatarHtml = '<img src="' + CONTEXT_PATH + '/upload' + rv.profileImage + '" alt="프로필">';
    } else {
        avatarHtml = '<i class="bi bi-person"></i>';
    }
    
    // 본인 리뷰인 경우 수정/삭제 드롭다운
    var actionHtml = '';
    if (loginMemNo && loginMemNo === rv.memNo) {
        actionHtml = 
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
	} else if (isLoggedIn && loginMemType !== 'BUSINESS') {
        var reviewContent = escapeHtml(rv.prodReview);
        var shortContent = reviewContent.length > 30 ? reviewContent.substring(0, 30) + '...' : reviewContent;
        actionHtml = 
            '<button class="btn-more" type="button" onclick="openReportModal(\'review\', \'' + rv.prodRvNo + '\', \'' + shortContent.replace(/'/g, "\\'") + '\', \'' + rv.memNo + '\')">' +
                '<i class="bi bi-flag"></i>' +
            '</button>';
    }
    
    // 리뷰 이미지 HTML 생성
    var imagesHtml = '';
    if (rv.reviewImages && rv.reviewImages.length > 0) {
        imagesHtml = '<div class="review-images">';
        rv.reviewImages.forEach(function(img) {
            imagesHtml += '<img src="' + CONTEXT_PATH + '/upload' + img + '" alt="리뷰 이미지" onclick="openReviewImage(this.src)">';
        });
        imagesHtml += '</div>';
    }
    
    var html = 
        '<div class="review-item" data-review-id="' + rv.prodRvNo + '" style="animation: fadeIn 0.3s ease;">' +
            '<div class="review-item-header">' +
                '<div class="reviewer-info">' +
                    '<div class="reviewer-avatar">' +
                        avatarHtml +
                    '</div>' +
                    '<div>' +
                        '<span class="reviewer-name">' + escapeHtml(rv.nickname) + '</span>' +
                        '<span class="review-date">' + dateStr + '</span>' +
                    '</div>' +
                '</div>' +
                '<div class="d-flex align-items-center gap-2">' +
                    '<div class="review-rating">' + starsHtml + '</div>' +
                    actionHtml +
                '</div>' +
            '</div>' +
            '<div class="review-content">' +
                '<p>' + escapeHtml(rv.prodReview) + '</p>' +
            '</div>' +
            imagesHtml +
        '</div>';
    
    reviewList.insertAdjacentHTML('beforeend', html);
}

// 리뷰 이미지 확대 보기
function openReviewImage(src) {
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

// ==================== 리뷰 수정/삭제 ====================
var editSelectedRating = 0;
var editExistingImages = [];  // 기존 이미지 목록
var editNewImages = [];       // 새로 추가할 이미지
var currentEditReviewId = null;

function openEditReviewModal(reviewId, rating, content) {
    currentEditReviewId = reviewId;
    document.getElementById('editReviewId').value = reviewId;
    document.getElementById('editReviewRating').value = rating;
    document.getElementById('editReviewContent').value = content;
    document.getElementById('editReviewCharCount').textContent = content.length;
    
    editSelectedRating = rating;
    updateEditStars(rating);
    updateEditRatingText(rating);
    
    // 이미지 초기화
    editExistingImages = [];
    editNewImages = [];
    
    // 기존 이미지 불러오기
    loadExistingReviewImages(reviewId);
    
    var modal = new bootstrap.Modal(document.getElementById('editReviewModal'));
    modal.show();
}

// 기존 이미지 불러오기
function loadExistingReviewImages(reviewId) {
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/review/' + reviewId + '/images')
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            if (data.success && data.images) {
                editExistingImages = data.images;
                renderEditImagePreviews();
            }
        })
        .catch(function(error) {
            console.error('Error loading images:', error);
        });
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

// 별점 클릭 이벤트 (DOMContentLoaded에서 등록)
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
    
    // 이미지 파일 선택 이벤트
    var editReviewImages = document.getElementById('editReviewImages');
    if (editReviewImages) {
        editReviewImages.addEventListener('change', function(e) {
            var files = Array.from(e.target.files);
            var totalCount = editExistingImages.length + editNewImages.length;
            
            if (totalCount + files.length > 5) {
                showToast('이미지는 최대 5장까지 첨부 가능합니다.', 'warning');
                e.target.value = '';
                return;
            }
            
            files.forEach(function(file) {
                if (file.type.startsWith('image/')) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        editNewImages.push({
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
    }
});

// 리뷰 수정 중복 방지 플래그
var isUpdatingReview = false;

// 리뷰 수정
function updateReview() {
    // 중복 클릭 방지
    if (isUpdatingReview) return;
    
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
    
    // 플래그 설정 & 버튼 비활성화
    isUpdatingReview = true;
    var submitBtn = document.querySelector('#editReviewModal .btn-primary');
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>수정 중...';
    
    // 1. 먼저 리뷰 텍스트 수정
    var reviewData = {
        prodRvNo: reviewId,
        rating: rating,
        prodReview: content
    };
    
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/review/update', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(reviewData)
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        if (data.success) {
            // 2. 새 이미지가 있으면 업로드
            if (editNewImages.length > 0) {
                uploadNewImages(reviewId, function() {
                    finishReviewUpdate(reviewId, rating, content);
                });
            } else {
                finishReviewUpdate(reviewId, rating, content);
            }
        } else {
            showToast(data.message, 'error');
            resetUpdateButton();
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
        showToast('리뷰 수정에 실패했습니다.', 'error');
        resetUpdateButton();
    });
}

// 버튼 상태 초기화
function resetUpdateButton() {
    isUpdatingReview = false;
    var submitBtn = document.querySelector('#editReviewModal .btn-primary');
    if (submitBtn) {
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="bi bi-check-lg me-1"></i>수정 완료';
    }
}

// 새 이미지 업로드
function uploadNewImages(reviewId, callback) {
    var formData = new FormData();
    editNewImages.forEach(function(img) {
        formData.append('files', img.file);
    });
    
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/review/' + reviewId + '/image/upload', {
        method: 'POST',
        body: formData
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        if (data.success) {
            callback();
        } else {
            showToast(data.message || '이미지 업로드에 실패했습니다.', 'warning');
            callback();
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
        callback();
    });
}

// 리뷰 수정 완료 처리
function finishReviewUpdate(reviewId, rating, content) {
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/review/' + reviewId + '/images')
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            var reviewItem = document.querySelector('[data-review-id="' + reviewId + '"]');
            if (reviewItem) {
                reviewItem.querySelector('.review-content p').textContent = content;
                
                var starsHtml = '';
                for (var i = 1; i <= 5; i++) {
                    starsHtml += i <= rating ? '<i class="bi bi-star-fill"></i> ' : '<i class="bi bi-star"></i> ';
                }
                reviewItem.querySelector('.review-rating').innerHTML = starsHtml;
                
                var imagesContainer = reviewItem.querySelector('.review-images');
                
                if (data.success && data.images && data.images.length > 0) {
                    var imagesHtml = '<div class="review-images">';
                    data.images.forEach(function(img) {
                        var filePath = img.FILE_PATH || img.filePath;
                        imagesHtml += '<img src="' + CONTEXT_PATH + '/upload' + filePath + '" ' +
                                      'alt="리뷰 이미지" onclick="openReviewImage(this.src)">';
                    });
                    imagesHtml += '</div>';
                    
                    if (imagesContainer) {
                        imagesContainer.outerHTML = imagesHtml;
                    } else {
                        reviewItem.querySelector('.review-content').insertAdjacentHTML('afterend', imagesHtml);
                    }
                } else {
                    if (imagesContainer) {
                        imagesContainer.remove();
                    }
                }
            }
            
            bootstrap.Modal.getInstance(document.getElementById('editReviewModal')).hide();
            showToast('리뷰가 수정되었습니다.', 'success');
            resetUpdateButton();
        })
        .catch(function(error) {
            console.error('Error:', error);
            bootstrap.Modal.getInstance(document.getElementById('editReviewModal')).hide();
            showToast('리뷰가 수정되었습니다.', 'success');
            resetUpdateButton();
        });
}

// 리뷰 아이템의 이미지 UI 업데이트
function updateReviewImagesUI(reviewItem) {
    var imagesContainer = reviewItem.querySelector('.review-images');
    
    if (editExistingImages.length > 0) {
        var imagesHtml = '<div class="review-images">';
        editExistingImages.forEach(function(img) {
            var filePath = img.FILE_PATH || img.filePath;
            imagesHtml += '<img src="' + CONTEXT_PATH + '/upload' + filePath + '" ' +
                          'alt="리뷰 이미지" onclick="openReviewImage(this.src)">';
        });
        imagesHtml += '</div>';
        
        if (imagesContainer) {
            imagesContainer.outerHTML = imagesHtml;
        } else {
            reviewItem.querySelector('.review-content').insertAdjacentHTML('afterend', imagesHtml);
        }
    } else if (imagesContainer) {
        imagesContainer.remove();
    }
}

function deleteReview(reviewId) {
    showCustomConfirm('리뷰 삭제', '삭제된 리뷰는 복구할 수 없습니다.<br>정말 삭제하시겠습니까?', function() {
        fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/review/delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ prodRvNo: reviewId })
        })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            if (data.success) {
                var reviewItem = document.querySelector('[data-review-id="' + reviewId + '"]');
                if (reviewItem) {
                    reviewItem.style.animation = 'fadeOut 0.3s ease';
                    setTimeout(function() {
                        reviewItem.remove();
                        
                        // 리뷰 카운트 업데이트
                        var countEl = document.querySelector('.review-header h3');
                        if (countEl) {
                            var match = countEl.textContent.match(/\((\d+)\)/);
                            if (match) {
                                var newCount = parseInt(match[1]) - 1;
                                countEl.innerHTML = '<i class="bi bi-star me-2"></i>리뷰 (' + newCount + ')';
                            }
                        }
                    }, 300);
                }
                
                showToast(data.message, 'success');
            } else {
                showToast(data.message, 'error');
            }
        })
        .catch(function(error) {
            console.error('Error:', error);
            showToast('리뷰 삭제에 실패했습니다.', 'error');
        });
    });
}

// ==================== 리뷰 이미지 업로드 ====================
var editUploadedImages = [];

function renderEditImagePreviews() {
    var container = document.getElementById('editImagePreviewList');
    var html = '';
    
    // 기존 이미지 (서버에 저장된 것)
    editExistingImages.forEach(function(img, index) {
        var filePath = img.FILE_PATH || img.filePath;
        var fileNo = img.FILE_NO || img.fileNo;
        html += 
            '<div class="image-preview-item existing-image" data-file-no="' + fileNo + '">' +
                '<img src="' + CONTEXT_PATH + '/upload' + filePath + '" ' +
                     'alt="기존 이미지" onclick="openReviewImage(this.src)">' +
                '<button type="button" class="remove-btn" onclick="removeExistingImage(' + index + ', ' + fileNo + ')" title="삭제">&times;</button>' +
                '<span class="image-badge existing">기존</span>' +
            '</div>';
    });
    
    // 새로 추가할 이미지
    editNewImages.forEach(function(img, index) {
        html += 
            '<div class="image-preview-item new-image">' +
                '<img src="' + img.data + '" alt="새 이미지" onclick="openReviewImage(this.src)">' +
                '<button type="button" class="remove-btn" onclick="removeNewImage(' + index + ')" title="삭제">&times;</button>' +
                '<span class="image-badge new">새로추가</span>' +
            '</div>';
    });
    
    container.innerHTML = html;
    
    // 이미지 개수 체크 (최대 5개)
    var totalCount = editExistingImages.length + editNewImages.length;
    var uploadArea = container.parentElement.querySelector('.image-upload-area');
    if (totalCount >= 5) {
        uploadArea.style.display = 'none';
    } else {
        uploadArea.style.display = 'flex';
    }
}

// 기존 이미지 삭제 (서버 호출)
function removeExistingImage(index, fileNo) {
    showCustomConfirm('이미지 삭제', '이 이미지를 삭제하시겠습니까?', function() {
        fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/review/' + currentEditReviewId + '/image/delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ fileNo: fileNo })
        })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            if (data.success) {
                editExistingImages.splice(index, 1);
                renderEditImagePreviews();
                showToast('이미지가 삭제되었습니다.', 'success');
            } else {
                showToast(data.message || '이미지 삭제에 실패했습니다.', 'error');
            }
        })
        .catch(function(error) {
            console.error('Error:', error);
            showToast('이미지 삭제 중 오류가 발생했습니다.', 'error');
        });
    });
}

// 새 이미지 삭제 (로컬에서만)
function removeNewImage(index) {
    editNewImages.splice(index, 1);
    renderEditImagePreviews();
}

function removeEditImage(index) {
    editUploadedImages.splice(index, 1);
    renderEditImagePreviews();
}

// ==================== 판매자 문의 기능 ====================

// 문의 폼 제출
document.addEventListener('DOMContentLoaded', function() {
    var inquiryForm = document.getElementById('inquiryForm');
    if (inquiryForm) {
        inquiryForm.addEventListener('submit', function(e) {
            e.preventDefault();

            // 로그인 체크
			if (!isLoggedIn) {
			    sessionStorage.setItem('returnUrl', window.location.href);
			    showToast('로그인이 필요한 서비스입니다.', 'warning');
			    setTimeout(function() {
			        window.location.href = CONTEXT_PATH + '/member/login';
			    }, 1000);
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
            fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/inquiry', {
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
    }
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
    var isSecretInq = inq.secretYn === 'Y';
    
    // 닉네임: 서버 응답값 또는 세션값 사용
    var nickname = inq.inquiryNickname || '회원';

    // 새 문의 HTML 생성
    var newInquiryHtml =
        '<div class="inquiry-item new-inquiry" data-inquiry-id="' + inq.prodInqryNo + '" style="animation: slideIn 0.3s ease-out;">' +
            '<div class="inquiry-item-header">' +
                '<div class="inquiry-item-info">' +
                    '<span class="inquiry-type-badge ' + typeClass + '">' + typeLabel + '</span>' +
                    '<span class="inquiry-author">' + escapeHtml(nickname) + '</span>' +
                    '<span class="inquiry-date">' + dateStr + '</span>' +
                    (isSecretInq ? '<span class="secret-badge"><i class="bi bi-lock"></i> 비밀글</span>' : '') +
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

// ==================== 문의 더보기 기능 ====================
var inquiryPage = 1;
var isLoadingInquiry = false;

function loadMoreInquiries() {
    if (isLoadingInquiry) return;
    
    isLoadingInquiry = true;
    inquiryPage++;
    
    var btn = document.querySelector('#inquiryMoreBtn button');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>불러오는 중...';
    
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/inquiries?page=' + inquiryPage)
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

function appendInquiry(inq, serverLoginMemNo) {
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
    var isSecretInq = inq.secretYn === 'Y';
    var isOwner = loginMemNo && loginMemNo === inq.inquiryMemNo;
    var isBusiness = loginMemType === 'BUSINESS';
    
    // 답변 상태
    var isAnswered = inq.inqryStatus === 'DONE';
    var statusClass = isAnswered ? 'answered' : 'waiting';
    var statusText = isAnswered ? '답변완료' : '답변대기';
    
    // 문의 내용 (비밀글 처리)
    var questionHtml = '';
    if (isSecretInq && !isOwner && !isBusiness) {
        questionHtml = '<p class="secret-content"><i class="bi bi-lock me-1"></i>비밀글로 작성된 문의입니다.</p>';
    } else {
        questionHtml = '<p><strong>Q.</strong> ' + escapeHtml(inq.prodInqryCn) + '</p>';
    }
	
	// 문의 액션 버튼 (본인: 수정/삭제, 타인: 신고)
    var inquiryActionHtml = '';
    if (isOwner && !isAnswered) {
        inquiryActionHtml = 
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
            '</div>';
    } else if (isLoggedIn && !isBusiness && !isOwner && !isSecretInq) {
        var inquiryContent = escapeHtml(inq.prodInqryCn);
        var shortContent = inquiryContent.length > 30 ? inquiryContent.substring(0, 30) + '...' : inquiryContent;
        inquiryActionHtml = 
            '<button class="btn-more" type="button" onclick="openReportModal(\'inquiry\', \'' + inq.prodInqryNo + '\', \'' + shortContent.replace(/'/g, "\\'") + '\', \'' + inq.inquiryMemNo + '\')">' +
                '<i class="bi bi-flag"></i>' +
            '</button>';
    }
    
    // 답변 내용
    var answerHtml = '';
    if (isAnswered && inq.replyCn && (!isSecretInq || isOwner || isBusiness)) {
        var replyDate = new Date(inq.replyDt);
        var replyDateStr = replyDate.getFullYear() + '.' + 
                           String(replyDate.getMonth() + 1).padStart(2, '0') + '.' + 
                           String(replyDate.getDate()).padStart(2, '0');
        
	   var replyActionHtml = '';
       if (isLoggedIn && !isBusiness) {
           var replyContent = escapeHtml(inq.replyCn);
           var shortReplyContent = replyContent.length > 30 ? replyContent.substring(0, 30) + '...' : replyContent;
           replyActionHtml = 
               '<button class="btn-more btn-more-sm" type="button" onclick="openReportModal(\'reply\', \'' + inq.prodInqryNo + '\', \'' + shortReplyContent.replace(/'/g, "\\'") + '\', \'' + inq.replyMemNo + '\')">' +
                   '<i class="bi bi-flag"></i>' +
               '</button>';
       }
						   
        answerHtml = 
            '<div class="inquiry-item-answer">' +
                '<div class="answer-header">' +
                    '<span class="answer-badge"><i class="bi bi-building"></i> 판매자 답변</span>' +
					'<div class="d-flex align-items-center gap-2">' +
						'<span class="answer-date">' + replyDateStr + '</span>' +
						replyActionHtml +
					'</div>' +
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
                    (isSecretInq ? '<span class="secret-badge"><i class="bi bi-lock"></i> 비밀글</span>' : '') +
                '</div>' +
				'<div class="d-flex align-items-center gap-2">' +
	                '<span class="inquiry-status ' + statusClass + '">' + statusText + '</span>' +
					inquiryActionHtml +
				'</div>' +
            '</div>' +
            '<div class="inquiry-item-question">' + questionHtml + '</div>' +
            answerHtml +
        '</div>';
    
    inquiryList.insertAdjacentHTML('beforeend', html);
}

// ==================== 문의 수정/삭제 ====================

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
    var isSecretChecked = document.getElementById('editInquirySecret').checked;
    
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
        secretYn: isSecretChecked ? 'Y' : 'N'
    };
    
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/inquiry/update', {
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
                if (isSecretChecked) {
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
        fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/inquiry/delete', {
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
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/inquiry/reply', {
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

// ==================== 답변 수정/삭제 ====================

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
    
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/inquiry/reply/update', {
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
        fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/inquiry/reply/delete', {
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

// ==================== 커스텀 확인 모달 (동적 생성) ====================
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

// ESC 키로 모달 닫기
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        var overlay = document.getElementById('customConfirmOverlay');
        if (overlay) {
            hideConfirm();
            confirmCallback = null;
        }
    }
});

// 카카오 지도 초기화
function initMap() {
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = {
	        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    };  

	// 지도를 생성합니다    
	var map = new kakao.maps.Map(mapContainer, mapOption); 

	// 주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();

	// 주소로 좌표를 검색합니다
	geocoder.addressSearch(placeAddr1, function(result, status) {

	    // 정상적으로 검색이 완료됐으면 
	     if (status === kakao.maps.services.Status.OK) {

	        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

	        // 결과값으로 받은 위치를 마커로 표시합니다
	        var marker = new kakao.maps.Marker({
	            map: map,
	            position: coords
	        });

	        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
	        map.setCenter(coords);
	    } 
	});
}

// ==================== 상품 이미지 관리 ====================
var newImageFiles = [];

function openImageUploadModal() {
    newImageFiles = [];
    document.getElementById('newImagesPreview').innerHTML = '';
    
    var modal = new bootstrap.Modal(document.getElementById('imageUploadModal'));
    modal.show();
    
    loadCurrentImages();
}

function loadCurrentImages() {
    var grid = document.getElementById('currentImagesGrid');

    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/images')
        .then(function(response) { return response.json(); })
        .then(function(data) {
            if (data.success && data.images && data.images.length > 0) {
                var html = '';
                data.images.forEach(function(img, index) {
                    // FILE_PATH에 슬래시가 없으면 product/ 폴더 추가
                    var imagePath = img.FILE_PATH;
                    
                    html += '<div class="current-image-item' + (index === 0 ? ' main-image' : '') + '" data-file-no="' + img.FILE_NO + '">' +
                        '<img src="' + CONTEXT_PATH + '/upload' + imagePath + '" alt="상품 이미지">' +
                        '<button class="delete-btn" onclick="deleteProductImage(' + img.FILE_NO + ')">' +
                            '<i class="bi bi-x"></i>' +
                        '</button>' +
                        (index === 0 ? '<span class="main-badge">대표</span>' : '') +
                    '</div>';
                });
                grid.innerHTML = html;
            } else {
                grid.innerHTML = '<div class="no-images-message">' +
                    '<i class="bi bi-image"></i>' +
                    '<p>등록된 이미지가 없습니다.</p>' +
                '</div>';
            }
        })
        .catch(function(error) {
            console.error('Error:', error);
            grid.innerHTML = '<div class="no-images-message">' +
                '<i class="bi bi-exclamation-circle"></i>' +
                '<p>이미지를 불러올 수 없습니다.</p>' +
            '</div>';
        });
}

function deleteProductImage(fileNo) {
    if (!confirm('이 이미지를 삭제하시겠습니까?')) return;
    
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/image/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ fileNo: fileNo })
    })
    .then(function(response) { return response.json(); })
    .then(function(data) {
        if (data.success) {
            showToast('이미지가 삭제되었습니다.', 'success');
            loadCurrentImages();
            refreshGallery();
        } else {
            showToast(data.message || '삭제에 실패했습니다.', 'error');
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
        showToast('오류가 발생했습니다.', 'error');
    });
}

// 드래그 앤 드롭
document.addEventListener('DOMContentLoaded', function() {
    var dropZone = document.getElementById('imageDropZone');
    if (!dropZone) return;
    
    dropZone.addEventListener('dragover', function(e) {
        e.preventDefault();
        this.classList.add('dragover');
    });
    
    dropZone.addEventListener('dragleave', function(e) {
        e.preventDefault();
        this.classList.remove('dragover');
    });
    
    dropZone.addEventListener('drop', function(e) {
        e.preventDefault();
        this.classList.remove('dragover');
        handleFiles(e.dataTransfer.files);
    });
    
    var fileInput = document.getElementById('productImageInput');
    if (fileInput) {
        fileInput.addEventListener('change', function() {
            handleFiles(this.files);
        });
    }
});

function handleFiles(files) {
    var maxFiles = 10 - document.querySelectorAll('.current-image-item').length;
    
    for (var i = 0; i < files.length && newImageFiles.length < maxFiles; i++) {
        var file = files[i];
        
        if (!file.type.startsWith('image/')) {
            showToast('이미지 파일만 업로드 가능합니다.', 'warning');
            continue;
        }
        
        if (file.size > 5 * 1024 * 1024) {
            showToast('파일 크기는 5MB 이하여야 합니다.', 'warning');
            continue;
        }
        
        newImageFiles.push(file);
        addImagePreview(file);
    }
}

function addImagePreview(file) {
    var reader = new FileReader();
    reader.onload = function(e) {
        var preview = document.getElementById('newImagesPreview');
        var index = newImageFiles.indexOf(file);
        
        var div = document.createElement('div');
        div.className = 'new-image-item';
        div.innerHTML = '<img src="' + e.target.result + '" alt="미리보기">' +
            '<button class="remove-btn" onclick="removeNewImage(' + index + ')">' +
                '<i class="bi bi-x"></i>' +
            '</button>';
        preview.appendChild(div);
    };
    reader.readAsDataURL(file);
}

function removeNewImage(index) {
    newImageFiles.splice(index, 1);
    
    // 미리보기 다시 렌더링
    var preview = document.getElementById('newImagesPreview');
    preview.innerHTML = '';
    newImageFiles.forEach(function(file) {
        addImagePreview(file);
    });
}

// 이미지 업로드 중복 방지 플래그
var isUploadingImages = false;

function uploadProductImages() {
    // 중복 클릭 방지
    if (isUploadingImages) return;
    
    if (newImageFiles.length === 0) {
        bootstrap.Modal.getInstance(document.getElementById('imageUploadModal')).hide();
        return;
    }
    
    // 플래그 설정 & 버튼 비활성화
    isUploadingImages = true;
    var submitBtn = document.querySelector('#imageUploadModal .btn-primary');
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>업로드 중...';
    
    var formData = new FormData();
    newImageFiles.forEach(function(file) {
        formData.append('files', file);
    });
    
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/image/upload', {
        method: 'POST',
        body: formData
    })
    .then(function(response) { return response.json(); })
    .then(function(data) {
        if (data.success) {
            showToast(data.message || '이미지가 업로드되었습니다.', 'success');
            newImageFiles = [];
            document.getElementById('newImagesPreview').innerHTML = '';
            loadCurrentImages();
            refreshGallery();
            bootstrap.Modal.getInstance(document.getElementById('imageUploadModal')).hide();
        } else {
            showToast(data.message || '업로드에 실패했습니다.', 'error');
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
        showToast('오류가 발생했습니다.', 'error');
    })
    .finally(function() {
        // 버튼 상태 복원
        isUploadingImages = false;
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="bi bi-check-lg me-1"></i>저장';
    });
}

function refreshGallery() {
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/images')
        .then(function(response) { return response.json(); })
        .then(function(data) {
            if (data.success && data.images && data.images.length > 0) {
                // FILE_PATH 경로 처리 추가
                var firstImagePath = data.images[0].FILE_PATH;
                
                // 메인 이미지 업데이트
                document.getElementById('mainImage').src = CONTEXT_PATH + '/upload' + firstImagePath;
                
                // 썸네일 업데이트
                var thumbs = document.getElementById('galleryThumbs');
                var html = '';
                data.images.forEach(function(img, index) {
                    var imagePath = img.FILE_PATH;
                    html += '<img src="' + CONTEXT_PATH + '/upload' + imagePath + '" ' +
                        'alt="썸네일" onclick="changeMainImage(this, ' + index + ')"' +
                        (index === 0 ? ' class="active"' : '') + '>';
                });
                thumbs.innerHTML = html;
                
                // 갤러리 네비게이션 재초기화
                currentImageIndex = 0;
                initGalleryNavigation();
                
                // 총 이미지 수 업데이트
                var totalCountEl = document.getElementById('totalImageCount');
                if (totalCountEl) {
                    totalCountEl.textContent = data.images.length;
                }
            } else {
                // 이미지가 없는 경우 기본 이미지로
                document.getElementById('mainImage').src = 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&h=500&fit=crop&q=80';
                document.getElementById('galleryThumbs').innerHTML = '';
                
                // 갤러리 네비게이션 재초기화
                currentImageIndex = 0;
                galleryImages = ['https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&h=500&fit=crop&q=80'];
                updateGalleryCounter();
                updateNavButtonsVisibility();
                
                var totalCountEl = document.getElementById('totalImageCount');
                if (totalCountEl) {
                    totalCountEl.textContent = 1;
                }
            }
        });
}

// ==================== 갤러리 네비게이션 ====================
var currentImageIndex = 0;
var galleryImages = [];

function initGalleryNavigation() {
    var thumbs = document.querySelectorAll('#galleryThumbs img');
    galleryImages = Array.from(thumbs).map(function(img) {
        return img.src;
    });
    
    // 이미지가 없으면 기본 이미지 사용
    if (galleryImages.length === 0) {
        galleryImages = ['https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&h=500&fit=crop&q=80'];
    }
    
    updateGalleryCounter();
    updateNavButtonsVisibility();
}

function prevImage() {
    if (galleryImages.length <= 1) return;
    
    currentImageIndex--;
    if (currentImageIndex < 0) {
        currentImageIndex = galleryImages.length - 1;
    }
    updateMainImage();
}

function nextImage() {
    if (galleryImages.length <= 1) return;
    
    currentImageIndex++;
    if (currentImageIndex >= galleryImages.length) {
        currentImageIndex = 0;
    }
    updateMainImage();
}

function updateMainImage() {
    var mainImage = document.getElementById('mainImage');
    mainImage.style.opacity = '0';
    
    setTimeout(function() {
        mainImage.src = galleryImages[currentImageIndex];
        mainImage.style.opacity = '1';
    }, 150);
    
    updateGalleryCounter();
    updateThumbnailActive();
}

function updateGalleryCounter() {
    var counterEl = document.getElementById('currentImageIndex');
    if (counterEl) {
        counterEl.textContent = currentImageIndex + 1;
    }
}

function updateThumbnailActive() {
    var thumbs = document.querySelectorAll('#galleryThumbs img');
    thumbs.forEach(function(thumb, index) {
        if (index === currentImageIndex) {
            thumb.classList.add('active');
        } else {
            thumb.classList.remove('active');
        }
    });
}

function updateNavButtonsVisibility() {
    var prevBtn = document.querySelector('.gallery-prev');
    var nextBtn = document.querySelector('.gallery-next');
    var counter = document.querySelector('.gallery-counter');
    
    if (galleryImages.length <= 1) {
        if (prevBtn) prevBtn.style.display = 'none';
        if (nextBtn) nextBtn.style.display = 'none';
        if (counter) counter.style.display = 'none';
    }
}

// ==================== 예약 날짜 선택기 초기화 ====================
function initBookingDatePicker() {
    var bookingDateInput = document.getElementById('bookingDate');
    if (!bookingDateInput) return;
    
    flatpickr(bookingDateInput, {
        locale: 'ko',
        dateFormat: 'Y-m-d',
        minDate: 'today',
        maxDate: saleEndDt || null,  // 판매 종료일까지만 선택 가능
        disableMobile: true,
        position: 'below'
    });
}

// ==================== 북마크 기능 ====================
function toggleTourBookmark() {
    if (!isLoggedIn) {
        sessionStorage.setItem('returnUrl', window.location.href);
        showToast('로그인이 필요한 서비스입니다.', 'warning');
        setTimeout(function() {
            window.location.href = CONTEXT_PATH + '/member/login';
        }, 1000);
        return;
    }
    
    fetch(CONTEXT_PATH + '/tour/' + TRIP_PROD_NO + '/bookmark', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        if (data.success) {
            showToast(data.message, data.bookmarked ? 'success' : 'info');
            updateBookmarkButton(data.bookmarked);
        } else {
            showToast(data.message, 'warning');
        }
    })
    .catch(function(error) {
        console.error('Error:', error);
        showToast('처리 중 오류가 발생했습니다.', 'error');
    });
}

function updateBookmarkButton(bookmarked) {
    var btn = document.getElementById('bookmarkBtn');
    btn.dataset.bookmarked = bookmarked;
    isBookmarked = bookmarked;
    
    if (bookmarked) {
        btn.innerHTML = '<i class="bi bi-bookmark-fill me-2"></i>북마크 삭제';
    } else {
        btn.innerHTML = '<i class="bi bi-bookmark me-2"></i>북마크';
    }
}