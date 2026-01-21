/**
 * tour.js - 투어/체험/티켓 페이지 스크립트
 * 
 * 전역 변수 (JSP에서 선언):
 * - CONTEXT_PATH: 컨텍스트 경로
 * - totalCount: 전체 상품 수
 * - initialListSize: 초기 로드된 리스트 크기
 * - isBusiness: 비즈니스 회원 여부
 * - isLoggedIn: 로그인 여부
 * - popularKeywords: 인기 검색어 배열
 */

// ==================== 검색어 변수 ====================
var currentKeyword = '';
var currentDestination = '';
var currentCategory = '';
var currentTourDate = '';
var currentPeople = null;

// ==================== 필터 변수 ====================
var currentPriceMin = null;
var currentPriceMax = null;
var currentLeadTime = null;
var currentSortBy = 'recommend';

// ==================== 인피니티 스크롤 변수 ====================
var tourCurrentPage = 1;
var tourIsLoading = false;
var tourHasMore = true;
var tourPageSize = 12;

// ==================== 인기 검색어 변수 ====================
var currentKeywordIndex = 0;
var rotateInterval;
var isHovering = false;

// ==================== 장바구니 변수 ====================
var cart = [];

// ==================== 페이지 로드시 초기화 ====================
document.addEventListener('DOMContentLoaded', function() {
	// 품절 상품 처리 (결제 페이지에서 리다이렉트된 경우)
    var urlParams = new URLSearchParams(window.location.search);
    var soldout = urlParams.get('soldout');
    
    if (soldout) {
        var unavailableIds = soldout.split(',');
        
        // sessionStorage에서 해당 상품 제거
        var savedCart = sessionStorage.getItem('tourCart');
        if (savedCart) {
            var cart = JSON.parse(savedCart);
            cart = cart.filter(function(item) {
                return !unavailableIds.includes(item.id);
            });
            sessionStorage.setItem('tourCart', JSON.stringify(cart));
        }
        
        showToast('품절된 상품이 장바구니에서 제거되었습니다.', 'warning');
        
        // URL에서 파라미터 제거
        window.history.replaceState({}, document.title, window.location.pathname);
    }
		
    // 인피니티 스크롤 초기화
    if (initialListSize < tourPageSize) {
        tourHasMore = false;
        document.getElementById('tourScrollLoader').style.display = 'none';
        if (initialListSize > 0) {
            document.getElementById('tourScrollEnd').style.display = 'block';
        }
    } else {
        initTourInfiniteScroll();
    }
    
    // 장바구니 초기화
    loadCart();
    updateCartUI();
    
    // 인기 검색어 순환 시작
    rotateInterval = setInterval(rotateKeyword, 3000);
    
    // 이벤트 리스너 등록
    initEventListeners();
});

// ==================== 이벤트 리스너 초기화 ====================
function initEventListeners() {
    // 검색 폼
    document.getElementById('tourSearchForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        currentKeyword = document.getElementById('keyword').value.trim();
        currentDestination = document.getElementById('destination').value.trim();
        currentCategory = document.getElementById('category').value;
        currentTourDate = document.getElementById('tourDate').value;
        currentPeople = parseInt(document.getElementById('people').value) || 2;
        
        showToast('검색 결과를 불러오는 중...', 'info');
        applyFilter();
    });
    
    // 가격 필터
    document.getElementById('priceFilter').addEventListener('change', function() {
        var value = this.value;
        
        if (value === '') {
            currentPriceMin = null;
            currentPriceMax = null;
        } else if (value === '0') {
            currentPriceMin = 0;
            currentPriceMax = 30000;
        } else if (value === '3') {
            currentPriceMin = 30000;
            currentPriceMax = 50000;
        } else if (value === '5') {
            currentPriceMin = 50000;
            currentPriceMax = 100000;
        } else if (value === '10') {
            currentPriceMin = 100000;
            currentPriceMax = null;
        }
        
        applyFilter();
    });
    
    // 소요시간 필터
    document.getElementById('leadTimeFilter').addEventListener('change', function() {
        var value = this.value;
        currentLeadTime = value === '' ? null : parseInt(value);
        applyFilter();
    });
    
    // 정렬
    document.getElementById('sortBy').addEventListener('change', function() {
        currentSortBy = this.value;
        applyFilter();
    });
    
    // ESC 키로 장바구니 닫기
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeCart();
        }
    });
}

// ==================== 인기 검색어 ====================
function rotateKeyword() {
    if (isHovering) return;

    currentKeywordIndex = (currentKeywordIndex + 1) % popularKeywords.length;
    var keywordEl = document.getElementById('rotatingKeyword');
    if (keywordEl) {
        keywordEl.style.opacity = '0';
        keywordEl.style.transform = 'translateY(-10px)';

        setTimeout(function() {
            keywordEl.textContent = popularKeywords[currentKeywordIndex];
            keywordEl.style.opacity = '1';
            keywordEl.style.transform = 'translateY(0)';
        }, 300);
    }
}

function showMoreKeywords() {
    isHovering = true;
    var moreKeywordsEl = document.getElementById('moreKeywords');

    var html = '';
    for (var i = 1; i <= 4; i++) {
        var idx = (currentKeywordIndex + i) % popularKeywords.length;
        html += '<span class="more-keyword-item" onclick="selectKeywordByText(\'' + popularKeywords[idx] + '\')">' + popularKeywords[idx] + '</span>';
    }
    moreKeywordsEl.innerHTML = html;
    moreKeywordsEl.classList.add('active');
}

function hideMoreKeywords() {
    isHovering = false;
    var moreKeywordsEl = document.getElementById('moreKeywords');
    if (moreKeywordsEl) {
        moreKeywordsEl.classList.remove('active');
    }
}

function selectKeywordByText(keyword) {
    document.getElementById('keyword').value = keyword;
    hideMoreKeywords();
    currentKeyword = keyword;
    showToast('"' + keyword + '" 검색 결과를 불러오는 중...', 'info');
    applyFilter();
}

// ==================== 필터 URL 생성 ====================
function buildFilterUrl(page) {
    var url = CONTEXT_PATH + '/tour/more?page=' + page + '&pageSize=' + tourPageSize;
    
    if (currentKeyword) url += '&keyword=' + encodeURIComponent(currentKeyword);
    if (currentDestination) url += '&destination=' + encodeURIComponent(currentDestination);
    if (currentCategory) url += '&category=' + encodeURIComponent(currentCategory);
    if (currentTourDate) url += '&tourDate=' + encodeURIComponent(currentTourDate);
    if (currentPeople !== null) url += '&people=' + currentPeople;
    if (currentPriceMin !== null) url += '&priceMin=' + currentPriceMin;
    if (currentPriceMax !== null) url += '&priceMax=' + currentPriceMax;
    if (currentLeadTime !== null) url += '&leadTime=' + currentLeadTime;
    url += '&sortBy=' + currentSortBy;
    
    return url;
}

// ==================== 인피니티 스크롤 ====================
function initTourInfiniteScroll() {
    var loader = document.getElementById('tourScrollLoader');

    var observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting && !tourIsLoading && tourHasMore) {
                loadMore();
            }
        });
    }, {
        root: null,
        rootMargin: '100px',
        threshold: 0
    });

    observer.observe(loader);
}

function loadMore() {
    if (tourIsLoading || !tourHasMore) return;

    tourIsLoading = true;
    tourCurrentPage++;
    
    document.getElementById('tourScrollLoader').style.display = 'flex';

    var url = buildFilterUrl(tourCurrentPage);

    fetch(url)
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            var grid = document.querySelector('.tour-grid');
            var loader = document.getElementById('tourScrollLoader');
            
            grid.removeChild(loader);
            var endDiv = document.getElementById('tourScrollEnd');
            grid.removeChild(endDiv);
            
            data.tpList.forEach(function(tour, index) {
                var tourHtml = createTourCard(tour);
                var tempDiv = document.createElement('div');
                tempDiv.innerHTML = tourHtml;
                var newCard = tempDiv.firstElementChild;

                newCard.style.opacity = '0';
                newCard.style.transform = 'translateY(20px)';
                grid.appendChild(newCard);

                setTimeout(function() {
                    newCard.style.transition = 'all 0.4s ease';
                    newCard.style.opacity = '1';
                    newCard.style.transform = 'translateY(0)';
                }, index * 100);
            });
            
            grid.appendChild(loader);
            grid.appendChild(endDiv);

            if (!data.hasMore) {
                tourHasMore = false;
                loader.style.display = 'none';
                endDiv.style.display = 'block';
            }

            tourIsLoading = false;
        })
        .catch(function(error) {
            console.error('Error:', error);
            tourIsLoading = false;
        });
}

function createTourCard(data) {
    var categoryMap = {
        'tour': '투어',
        'activity': '액티비티',
        'ticket': '입장권/티켓',
        'class': '클래스/체험',
        'transfer': '교통/이동'
    };
    var categoryText = categoryMap[data.prodCtgryType];
    
    var ratingText = data.avgRating > 0 ? data.avgRating.toFixed(1) : '-';
    var reviewCountText = data.reviewCount || 0;

    var originalPriceHtml = '';
    if (data.netprc && data.netprc > data.price) {
        originalPriceHtml = '<span class="original">' + data.netprc.toLocaleString() + '원</span>';
    }

    var cartBtnHtml = !isBusiness ?
        '<button class="tour-cart-btn" onclick="addToCart(this)" title="장바구니 담기">' +
            '<i class="bi bi-cart-plus"></i>' +
        '</button>' : '';

    var stockClass = data.curStock <= 10 ? 'tour-stock stock-warning' : 'tour-stock';
    var stockIcon = data.curStock <= 10 ? 'bi-exclamation-triangle' : 'bi-box-seam';
    var stockLabel = data.curStock <= 10 ? '품절 임박:' : '남은 수량:';
    var stockHtml = '<div class="' + stockClass + '">' +
        '<i class="bi ' + stockIcon + '"></i> ' + stockLabel + ' <span class="stock-count">' + data.curStock + '개</span>' +
    '</div>';

    // 대표 이미지 처리
    var defaultImage = 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=300&fit=crop&q=80';
    var imageUrl = data.thumbImage 
        ? CONTEXT_PATH + '/upload/product/' + data.thumbImage 
        : defaultImage;

	var minPeople = data.prodMinPeople || 1;

    return '<div class="tour-card" data-id="' + data.tripProdNo + '" data-name="' + data.tripProdTitle + '" data-price="' + data.price + '" data-min-people="' + minPeople + '" data-stock="' + data.curStock + '" data-image="' + imageUrl + '" data-location="' + data.ctyNm + '">' +
        '<a href="' + CONTEXT_PATH + '/tour/' + data.tripProdNo + '" class="tour-link">' +
            '<div class="tour-image">' +
                '<img src="' + imageUrl + '" alt="' + data.tripProdTitle + '">' +
                '<span class="tour-category">' + categoryText + '</span>' +
            '</div>' +
            '<div class="tour-body">' +
                '<p class="tour-location"><i class="bi bi-geo-alt"></i> ' + data.ctyNm + '</p>' +
                '<h4 class="tour-name">' + data.tripProdTitle + '</h4>' +
                '<div class="tour-rating">' +
                    '<i class="bi bi-star-fill"></i>' +
                    '<span>' + ratingText + '</span>' +
                    '<span class="text-muted">(' + reviewCountText + ')</span>' +
                '</div>' +
                '<div class="tour-price">' +
                    originalPriceHtml +
                    '<span class="price">' + data.price.toLocaleString() + '원</span>' +
                '</div>' +
                stockHtml +
            '</div>' +
        '</a>' +
        cartBtnHtml +
    '</div>';
}

// ==================== 필터 적용 ====================
function applyFilter() {
    tourCurrentPage = 1;
    tourHasMore = true;
    tourIsLoading = true;
    
    var grid = document.querySelector('.tour-grid');
    var loader = document.getElementById('tourScrollLoader');
    var endDiv = document.getElementById('tourScrollEnd');
    
    var cards = grid.querySelectorAll('.tour-card');
    cards.forEach(function(card) {
        grid.removeChild(card);
    });
    
    var noResults = grid.querySelector('.no-results');
    if (noResults) {
        grid.removeChild(noResults);
    }
    
    endDiv.style.display = 'none';
    loader.style.display = 'flex';
    
    var url = buildFilterUrl(tourCurrentPage);
    
    fetch(url)
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            updateResultsHeader(data.totalCount);
            
            grid.removeChild(loader);
            grid.removeChild(endDiv);
            
            if (data.tpList.length === 0) {
                var noResultsDiv = document.createElement('div');
                noResultsDiv.className = 'no-results';
                noResultsDiv.innerHTML = '<i class="bi bi-search"></i><p>검색 결과가 없습니다.</p>';
                grid.appendChild(noResultsDiv);
                
                tourHasMore = false;
                grid.appendChild(loader);
                grid.appendChild(endDiv);
                loader.style.display = 'none';
                tourIsLoading = false;
                return;
            }
            
            data.tpList.forEach(function(tour, index) {
                var tourHtml = createTourCard(tour);
                var tempDiv = document.createElement('div');
                tempDiv.innerHTML = tourHtml;
                var newCard = tempDiv.firstElementChild;
                
                newCard.style.opacity = '0';
                newCard.style.transform = 'translateY(20px)';
                grid.appendChild(newCard);
                
                setTimeout(function() {
                    newCard.style.transition = 'all 0.4s ease';
                    newCard.style.opacity = '1';
                    newCard.style.transform = 'translateY(0)';
                }, index * 50);
            });
            
            grid.appendChild(loader);
            grid.appendChild(endDiv);
            
            if (!data.hasMore) {
                tourHasMore = false;
                loader.style.display = 'none';
                endDiv.style.display = 'block';
            } else {
                loader.style.display = 'flex';
            }
            
            tourIsLoading = false;
        })
        .catch(function(error) {
            console.error('Error:', error);
            tourIsLoading = false;
        });
}

function updateResultsHeader(totalCount) {
    var hasFilter = currentKeyword || currentDestination || currentCategory || currentTourDate;
    
    if (currentKeyword) {
        document.getElementById('resultsCount').innerHTML =
            '"<strong>' + currentKeyword + '</strong>" 검색 결과 <strong>' + totalCount + '</strong>개';
    } else if (hasFilter) {
        document.getElementById('resultsCount').innerHTML =
            '<strong>검색된</strong> 투어/체험/티켓 <strong>' + totalCount + '</strong>개';
    } else {
        document.getElementById('resultsCount').innerHTML =
            '<strong>전체</strong> 투어/체험/티켓 <strong>' + totalCount + '</strong>개';
    }
}

// ==================== 장바구니 기능 ====================
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

function saveCart() {
    sessionStorage.setItem('tourCart', JSON.stringify(cart));
}

function addToCart(btn) {
    event.stopPropagation();
    event.preventDefault();

    var card = btn.closest('.tour-card');
    var id = card.dataset.id;
    var name = card.dataset.name;
    var price = parseInt(card.dataset.price);
    var image = card.dataset.image;
	var minPeople = parseInt(card.dataset.minPeople) || 1;
	var location = card.dataset.location || '';

    var existingItem = cart.find(function(item) {
        return item.id === id;
    });

    if (existingItem) {
		if (existingItem.quantity >= existingItem.stock) {
	        showToast('재고가 부족합니다 (남은 재고: ' + existingItem.stock + '개)', 'warning');
	        return;
	    }
			
		if (existingItem.quantity >= 4) {
	        showToast('5명 이상 단체 예약은 판매자에게 문의해주세요', 'warning');
	        return;
	    }
        existingItem.quantity++;
        showToast('수량이 추가되었습니다', 'success');
    } else {
		var stock = parseInt(card.dataset.stock) || 999;
		    
	    if (minPeople > stock) {
	        showToast('재고가 부족합니다 (남은 재고: ' + stock + '개)', 'warning');
	        return;
	    }
			
        cart.push({
            id: id,
            name: name,
            price: price,
            image: image,
			location: location,
			minPeople: minPeople,
			quantity: minPeople,
			stock: parseInt(card.dataset.stock) || 999,
			saleEndDt: card.dataset.saleEndDt || ''
        });
		
		if (minPeople > 1) {
            showToast('장바구니에 담겼습니다 (최소 ' + minPeople + '명)', 'success');
        } else {
            showToast('장바구니에 담겼습니다', 'success');
        }
    }

    btn.classList.add('added');
    btn.innerHTML = '<i class="bi bi-cart-check"></i>';

    setTimeout(function() {
        btn.classList.remove('added');
        btn.innerHTML = '<i class="bi bi-cart-plus"></i>';
    }, 1500);

    saveCart();
    updateCartUI();
}

function removeFromCart(id) {
    cart = cart.filter(function(item) {
        return item.id !== id;
    });

    saveCart();
    updateCartUI();
    renderCart();
    showToast('상품이 제거되었습니다', 'info');
}

function updateQuantity(id, delta) {
    var item = cart.find(function(item) {
        return item.id === id;
    });

    if (item) {
		var newQuantity = item.quantity + delta;
		var minPeople = item.minPeople || 1;
		var maxPeople = 4;
		var stock = item.stock || 999;

		if (newQuantity < minPeople) {
            showToast('최소 인원은 ' + minPeople + '명입니다', 'warning');
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

function updateCartUI() {
    var totalItems = cart.reduce(function(sum, item) {
        return sum + item.quantity;
    }, 0);

    var totalPrice = cart.reduce(function(sum, item) {
        return sum + (item.price * item.quantity);
    }, 0);

    var badge = document.getElementById('cartBadge');
    if (badge) {
        badge.textContent = totalItems;
        badge.setAttribute('data-count', totalItems);
        badge.style.display = totalItems > 0 ? 'flex' : 'none';
    }

    var itemCount = document.getElementById('cartItemCount');
    if (itemCount) {
        itemCount.textContent = totalItems + '개';
    }

    var totalPriceEl = document.getElementById('cartTotalPrice');
    if (totalPriceEl) {
        totalPriceEl.textContent = totalPrice.toLocaleString() + '원';
    }

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
		var minPeople = item.minPeople || 1;
		
		var minPeopleHtml = minPeople > 1
		    ? '<div class="cart-item-min-people"><i class="bi bi-people"></i> 최소 ' + minPeople + '명</div>'
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

function openCart() {
    renderCart();
    document.getElementById('cartOverlay').classList.add('active');
    document.getElementById('cartSidebar').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function closeCart() {
    document.getElementById('cartOverlay').classList.remove('active');
    document.getElementById('cartSidebar').classList.remove('active');
    document.body.style.overflow = '';
}

function checkout() {
    if (cart.length === 0) {
        showToast('장바구니가 비어있습니다', 'warning');
        return;
    }

	if (!isLoggedIn) {
	    sessionStorage.setItem('returnUrl', window.location.href);
	    showToast('로그인이 필요한 서비스입니다.', 'warning');
	    setTimeout(function() {
	        window.location.href = CONTEXT_PATH + '/member/login';
	    }, 1000);
	    return;
	}

    sessionStorage.setItem('tourCartCheckout', JSON.stringify(cart));
	var prodIds = cart.map(function(item) { return item.id; }).join(',');
    window.location.href = CONTEXT_PATH + '/tour/cart/booking?prodIds=' + prodIds;
}