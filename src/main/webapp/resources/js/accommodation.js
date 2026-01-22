/**
 * 숙소 목록 페이지 전용 JS
 * 기능: 인피니티 스크롤, 숙소 카드 동적 생성, 드롭다운 제어, 북마크
 */

// ==================== 전역 변수 설정 ====================

const cp = document.querySelector('meta[name="context-path"]')?.content || '';
var accomCurrentPage = 1;
var accomPageSize = 12; 
var accomIsLoading = false;
var accomHasMore = true;


// ==================== 인피니티 스크롤 로직 ====================
document.addEventListener('DOMContentLoaded', function() {
	// 기존 인피니티 스크롤 설정 로직
    if (typeof initialListSize !== 'undefined' && initialListSize < accomPageSize) {
        accomHasMore = false;
        const loader = document.getElementById('accomScrollLoader');
        if(loader) loader.style.display = 'none';
    } else {
        initAccomInfiniteScroll();
    }
	
	// 필터 및 정렬 드롭다운 실시간 감시자
	const accomFilters = document.querySelectorAll('.tour-filters select');
	    
	    accomFilters.forEach(filter => {
	        filter.addEventListener('change', function() {
	            console.log('필터 감지됨:', this.name, '->', this.value);
	            
	            // 필터가 바뀌면 1페이지부터 다시 시작해야 함!
	            accomCurrentPage = 1; 
	            accomHasMore = true; // 더보기 가능성 열어주기
	            
	            // 목록을 싹 비우고 새로 불러오기 함수 호출
	            refreshAccomList();
	        });
	    });
	
});

function initAccomInfiniteScroll() {
    var loader = document.getElementById('accomScrollLoader');
    if (!loader) return;

    var observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting && !accomIsLoading && accomHasMore) {
                loadMore();
            }
        });
    }, {
		        root: null,
		        rootMargin: '300px', // 100px에서 300px로 늘려봐! 바닥 닿기 전에 미리 부름
		        threshold: 0
		    });

    observer.observe(loader);
}

function loadMore() {
	if (accomIsLoading || !accomHasMore) return;

	    accomIsLoading = true;
	    const loader = document.getElementById('accomScrollLoader');
	    const endDiv = document.getElementById('accomScrollEnd');
	    if(loader) loader.style.display = 'flex';

			// 화면에 있는 필터값
		    const accCatCd = document.querySelector('select[name="accCatCd"]')?.value || '';
		    const priceRange = document.querySelector('select[name="priceRange"]')?.value || '';
		    const starGrade = document.querySelector('select[name="starGrade"]')?.value || '';
		    const sortBy = document.getElementById('sortBy')?.value || 'recommend';
		    const keyword = document.getElementById('keyword')?.value || '';

		    const urlParams = new URLSearchParams(window.location.search);
		    const areaCode = urlParams.get('areaCode') || '';

		    const requestUrl = `${contextPath}/product/accommodation/api/loadMore?` 
		        + `page=${accomCurrentPage + 1}`
		        + `&pageSize=${accomPageSize}`
		        + `&accCatCd=${accCatCd}`
		        + `&priceRange=${priceRange}`
		        + `&starGrade=${starGrade}`
		        + `&sortBy=${sortBy}`
		        + `&areaCode=${areaCode}`
		        + `&keyword=${keyword}`;

	    // 모든 파라미터를 URLSearchParams로 변환 
	    fetch(`${contextPath}/product/accommodation/api/loadMore?` + new URLSearchParams(params))        
	    .then(res => res.json())
	    .then(data => {
	        console.log("서버 응답 전체 데이터:", data); 
			const list = data.accList || data.list;
	        console.log("필터 유지된 추가 리스트:", list);
	        
	        if (!list || list.length === 0) {
	            accomHasMore = false;
	            if(loader) loader.style.display = 'none';
	            if (accomCurrentPage > 1 && endDiv) {
	                endDiv.style.display = 'block';
	            }
	            return;
	        }

	        const grid = document.querySelector('.accommodation-grid');
	        
	        list.forEach((accom, index) => {
	            const accomHtml = createAccommodationCard(accom); 
	            const tempDiv = document.createElement('div');
	            tempDiv.innerHTML = accomHtml;
	            const newCard = tempDiv.firstElementChild;

	            newCard.style.opacity = '0';
	            newCard.style.transform = 'translateY(20px)';
	            grid.appendChild(newCard);

	            setTimeout(() => {
	                newCard.style.transition = 'all 0.4s ease';
	                newCard.style.opacity = '1';
	                newCard.style.transform = 'translateY(0)';
	            }, index * 100);
	        });

	        // 요소 재정렬
	        const currentLoader = document.getElementById('accomScrollLoader');
	        const currentEndDiv = document.getElementById('accomScrollEnd');
	        grid.appendChild(currentLoader); 
	        grid.appendChild(currentEndDiv); 

	        accomHasMore = data.hasMore;
	        
	        if (!accomHasMore && endDiv) {
	            if(currentLoader) currentLoader.style.display = 'none';
	            endDiv.style.display = 'block';
	        }
	        
	        accomCurrentPage++;
	        
	        setTimeout(() => {
	            accomIsLoading = false;
	        }, 300);
	    })
	    .catch(err => {
	        console.error("데이터 로드 실패:", err);
	        accomIsLoading = false;
	    });
}

// ======= 필터된 데이터로 목록을 새로고침하는 함수 =============
function refreshAccomList() {
	const loader = document.getElementById('accomScrollLoader');
	    if(loader) loader.style.display = 'block';

	    const params = {
	        page: 1,
	        pageSize: accomPageSize,
	        accCatCd: document.querySelector('select[name="accCatCd"]')?.value || '',
	        priceRange: document.querySelector('select[name="priceRange"]')?.value || '',
	        starGrade: document.querySelector('select[name="starGrade"]')?.value || '',
	        sortBy: document.getElementById('sortBy')?.value || 'recommend',
	        areaCode: document.getElementById('areaCode')?.value || '',
	        keyword: document.getElementById('keyword')?.value || ''
	    };

	    fetch(`${cp}/product/accommodation/api/loadMore?` + new URLSearchParams(params))
	        .then(res => res.json())
	        .then(data => {
	            const listContainer = document.getElementById('accommodationList');
	            if (!listContainer) return;

	            // 기존 목록 지우기 (확실하게!)
	            listContainer.innerHTML = ''; 

	            // 2. 중요: 컨트롤러에서 보낸 이름 "accList"로 확인하기
	            const currentList = data.accList || data.list; // 혹시 모르니 둘 다 체크!

	            if (currentList && currentList.length > 0) {
	                // 3. 렌더링 함수에 리스트 전달
	                renderAccomList(currentList); 
	                
	                // 4. 더보기 상태 업데이트 (data.hasMore도 컨트롤러에 있음!)
	                accomHasMore = data.hasMore;
	                if (!accomHasMore && loader) loader.style.display = 'none';
	                
	            } else {
	                listContainer.innerHTML = '<div class="no-result" style="padding:50px; text-align:center;">조건에 맞는 숙소가 없습니다.</div>';
	                accomHasMore = false;
	                if(loader) loader.style.display = 'none';
	            }
	        })
	        .catch(err => {
	            console.error('필터링 오류:', err);
	            if(loader) loader.style.display = 'none';
	        });
}

/**
 * 서버에서 받은 숙소 리스트를 HTML로 변환해서 화면에 출력
 */
function renderAccomList(accList) {
    const listContainer = document.getElementById('accommodationList');
    if (!listContainer) return;

    // 만약 데이터가 없으면 안내 문구 출력
    if (!accList || accList.length === 0) {
        listContainer.innerHTML = '<div class="no-result" style="padding:100px; text-align:center; width:100%;">검색 결과가 없습니다.</div>';
        return;
    }

    // 데이터를 하나씩 돌면서 HTML 카드 생성
    accList.forEach(acc => {
        const html = `
            <div class="col-md-4 mb-4">
                <div class="card tour-card h-100" onclick="location.href='${cp}/product/accommodation/${acc.tripProdNo}'">
                    <div class="position-relative">
                        <img src="${acc.accFilePath || cp + '/resources/images/no-image.png'}" class="card-img-top" alt="${acc.accName}">
                        <div class="wishlist-icon">
                            <i class="far fa-heart"></i>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="card-title mb-0">${acc.accName}</h5>
                            <span class="badge bg-primary">${acc.starGrade}성급</span>
                        </div>
                        <p class="card-text text-muted mb-2">
                            <i class="fas fa-map-marker-alt me-1"></i> ${acc.addr1}
                        </p>
                        <div class="d-flex align-items-center mb-2">
                            <div class="text-warning me-2">
                                ${renderStars(acc.avgRating)} </div>
                            <small class="text-muted">(${acc.reviewCount})</small>
                        </div>
                        <div class="text-end">
                            <span class="fs-5 fw-bold">${acc.finalPrice.toLocaleString()}원</span>
                            <small class="text-muted"> / 1박</small>
                        </div>
                    </div>
                </div>
            </div>
        `;
        listContainer.insertAdjacentHTML('beforeend', html);
    });
}

/**
 * 평점에 따른 별 모양 생성 함수 (간지용!)
 */
function renderStars(rating) {
    let stars = '';
    for (let i = 1; i <= 5; i++) {
        if (i <= rating) {
            stars += '<i class="fas fa-star"></i>';
        } else if (i - 0.5 <= rating) {
            stars += '<i class="fas fa-star-half-alt"></i>';
        } else {
            stars += '<i class="far fa-star"></i>';
        }
    }
    return stars;
}

// ==================== 카드 생성 함수 ====================
function createAccommodationCard(data) {
	console.log("들어온 데이터:", data);
    const priceText = new Intl.NumberFormat().format(data.finalPrice || 0);
    const rating = data.starGrade || '0.0';
    const reviews = 124; 
	const rPrice = room.price || room.PRICE || 0;
	const rDiscount = room.discount || room.DISCOUNT || 0;
	const finalRoomPrice = rPrice * (100 - rDiscount) / 100;
	

    let roomsHtml = '';
    if (data.roomList && data.roomList.length > 0) {
        let lastRoomName = "";
        data.roomList.forEach(room => {
            if (room.roomName !== lastRoomName) {
                roomsHtml += `
                    <div class="room-option">
                        <div class="room-option-info">
                            <h6>${room.roomName}</h6>
                            <p><i class="bi bi-people"></i> ${room.baseGuestCount}인 / <i class="bi bi-arrows-angle-expand"></i> ${room.roomSize}㎡</p>
                        </div>
						<div class="room-option-price" style="text-align: right;">
						            ${rDiscount > 0 ? `
						                <div style="margin-bottom: -5px;">
						                    <span style="color: #ff5a5f; font-weight: bold; font-size: 0.85rem;">${rDiscount}%</span>
						                    <span style="text-decoration: line-through; color: #bbb; font-size: 0.8rem; margin-left: 3px;">
						                        ${new Intl.NumberFormat().format(rPrice)}
						                    </span>
						                </div>
						            ` : ''}
						            <div style="font-size: 1.1rem; font-weight: 700; color: #333;">
						                ${new Intl.NumberFormat().format(finalRoomPrice)}원
						                <span style="font-size: 0.75rem; color: #888; font-weight: normal;">/ 1박</span>
						            </div>
						        </div>
                        <a href="${contextPath}/product/accommodation/${data.accNo}/booking?roomNo=${room.roomTypeNo}" class="btn btn-primary btn-sm">결제</a>
                    </div>`;
                lastRoomName = room.roomName;
            }
        });
    } else {
        roomsHtml = '<div class="p-3 text-center text-muted">예약 가능한 객실이 없습니다.</div>';
    }

    return `
    <div class="accommodation-card" data-accommodation-id="${data.accNo}">
        <div class="accommodation-image">
            <img src="${data.accFilePath || contextPath + '/resources/images/no-image.jpg'}" alt="${data.accName}">
            ${data.maxDiscount > 0 ? '<span class="accommodation-badge">특가</span>' : ''}
            <button class="accommodation-bookmark" onclick="toggleAccommodationBookmark(event, this)">
                <i class="bi bi-bookmark"></i>
            </button>
        </div>
        <div class="accommodation-body">
            <div class="accommodation-rating">
                <i class="bi bi-star-fill"></i>
                <span>${rating}</span>
                <span class="review-count">(${reviews.toLocaleString()})</span>
            </div>
            <h3 class="accommodation-name">${data.accName}</h3>
            <p class="accommodation-location">
                <i class="bi bi-geo-alt"></i> ${data.addr1}
            </p>
            <div class="accommodation-amenities">
                ${data.wifiYn === 'Y' ? '<span class="amenity"><i class="bi bi-wifi"></i> 와이파이</span>' : ''}
                ${data.parkingYn === 'Y' ? '<span class="amenity"><i class="bi bi-p-circle"></i> 주차</span>' : ''}
            </div>
            <div class="accommodation-price-row">
                <div class="accommodation-price">
                    <span class="price-label">최저가</span>
                    <span class="price">${priceText}원</span>
                    <span class="per-night">/ 1박</span>
                </div>
                <button class="btn btn-primary btn-sm accommodation-select-btn" onclick="toggleAccommodationDropdown(event, ${data.accNo})">
                    결제 <i class="bi bi-chevron-down"></i>
                </button>
            </div>
        </div>
        <div class="accommodation-booking-dropdown" id="accommodationDropdown${data.accNo}">
            <div class="booking-dropdown-content">
                <div class="room-options">${roomsHtml}</div>
            </div>
        </div>
    </div>`;
}

// ==================== 인터랙션 로직 ====================
function toggleAccommodationDropdown(e, accommodationId) {
    e.stopPropagation();
    const card = document.querySelector(`.accommodation-card[data-accommodation-id="${accommodationId}"]`);
    document.querySelectorAll('.accommodation-card.active').forEach(activeCard => {
        if (activeCard !== card) activeCard.classList.remove('active');
    });
    card.classList.toggle('active');
}

document.addEventListener('click', e => {
    if (!e.target.closest('.accommodation-card')) {
        document.querySelectorAll('.accommodation-card.active').forEach(card => card.classList.remove('active'));
    }
});

function toggleAccommodationBookmark(e, btn) {
    e.stopPropagation();
    // isLoggedIn 변수는 JSP 전역에서 넘겨줘야 해!
    if (typeof isLoggedIn === 'undefined' || !isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            window.location.href = `${contextPath}/member/login`;
        }
        return;
    }
    btn.classList.toggle('active');
    const icon = btn.querySelector('i');
    if (btn.classList.contains('active')) {
        icon.className = 'bi bi-bookmark-fill';
    } else {
        icon.className = 'bi bi-bookmark';
    }
}

function doSearch() {
    const keyword = document.querySelector('input[placeholder="도시, 지역 또는 숙소명"]').value;
    location.href = `${contextPath}/product/accommodation?keyword=` + encodeURIComponent(keyword);
}

/* =======================
   목적지 선택 자동완성
======================= */
$(document).ready(function() {
    const $input = $('#destination');
    const $dropdown = $('#destinationDropdown');
    const $areaCodeInput = $('#areaCode'); 
    const $accNoInput = $('#accNo');

    $input.on('input', function() {
        const keyword = $(this).val().trim();
        if (keyword.length < 1) { 
            $dropdown.hide(); 
            return; 
        }

        fetch(`${contextPath}/product/accommodation/api/search-location?keyword=${encodeURIComponent(keyword)}`)
            .then(res => res.json())
            .then(data => {
                if (data.length === 0) {
                    $dropdown.html('<div class="p-2 text-muted">검색 결과가 없습니다.</div>').show();
                    return;
                }

                let html = '<ul class="list-group shadow-sm">';
				data.forEach(item => {
				    const icon = item.TYPE === 'REGION'
				        ? '<i class="bi bi-geo-alt-fill me-2 text-success"></i>'
				        : '<i class="bi bi-house-door-fill me-2 text-primary"></i>';

				    const cssClass = item.TYPE === 'REGION' ? 'region-item' : 'acc-item';

				    html += `
				        <li class="list-group-item list-group-item-action ${cssClass}" 
				            data-id="${item.ID}" 
				            data-type="${item.TYPE}"
				            style="cursor:pointer;">
				            ${icon}<strong>${item.NAME}</strong>
				        </li>`;
                });
                html += '</ul>';
                $dropdown.html(html).show();
            });
    });

    // 자동완성 클릭 처리
    $(document).on('mousedown', '.region-item, .acc-item', function(e) {
        e.preventDefault();
        e.stopImmediatePropagation();

        const selectedName = $(this).find('strong').text().trim();
        const selectedId = $(this).data('id');
        const selectedType = $(this).data('type');

        console.log("[선택]", selectedName, selectedId, selectedType);

        $('#destination').val(selectedName);

        if (selectedType === 'REGION') {
            $areaCodeInput.val(selectedId);
            $accNoInput.val('');
        } else if (selectedType === 'ACCOMMODATION') {
            $accNoInput.val(selectedId);
            $areaCodeInput.val('');
        }

        $dropdown.empty().hide();

        console.log("[저장 상태] areaCode:", $areaCodeInput.val(), "accNo:", $accNoInput.val());
    });

    // 검색 버튼 눌렀을 때 검증
    $('#accommodationSearchForm').on('submit', function(e) {
        const areaCode = $areaCodeInput.val();
        const accNo = $accNoInput.val();
        const dest = $('#destination').val();

        if (!dest) {
            alert("목적지를 입력하거나 선택해주세요!");
            e.preventDefault();
            return;
        }

        console.log("최종 검색 전송 -> areaCode:", areaCode, "accNo:", accNo, "keyword:", dest);
    });
});
// =================== 체크인 / 체크아웃 ======================
document.addEventListener('DOMContentLoaded', () => {
    const common = { locale: 'ko', dateFormat: 'Y-m-d', minDate: 'today' };

    const outPicker = flatpickr('#checkOut', {
        ...common,
        onChange: function(selectedDates) {
            // 날짜 선택 시 로직 추가 가능
        }
    });

    flatpickr('#checkIn', {
        ...common,
        onChange: function([date]) {
            // 체크인 선택 시 체크아웃 최소 날짜를 다음날로 세정
            outPicker.set('minDate', new Date(date.getTime() + 86400000));
        }
    });
});

//==================== 인원 수 조절 (검색바 전용) ====================
window.updateCount = function(type, delta) {
    // 1. input 요소 찾기
    const input = document.getElementById(type + 'Count');
    if (!input) {
        console.error("adultCount input을 못 찾겠어!");
        return;
    }

    // 2. 값 계산
    let currentValue = parseInt(input.value) || 0;
    let newValue = currentValue + delta;

    // 3. 범위 제한 (성인 기준 최소 1명, 최대 8명)
    if (newValue >= 1 && newValue <= 8) {
        input.value = newValue;
        // input이 바뀌었다는걸 브라우저에 알림 (필요시)
        input.dispatchEvent(new Event('change'));
    }
};

//==================== 검색 폼 제출 로직 ====================
document.getElementById('accommodationSearchForm')?.addEventListener('submit', function(e) {
    const adultCount = document.getElementById('adultCount').value;
});

//==========================================================
// 결제 버튼 클릭 시 검색바의 날짜와 인원을 들고 튀는 함수
function goBooking(accNo, roomTypeNo, tripProdNo) {
		const urlParams = new URLSearchParams(window.location.search);
	// 1. 검색바에 입력된 값들 가져오기
		const startDate = urlParams.get('startDate') || document.getElementById('checkIn').value;
	    const endDate = urlParams.get('endDate') || document.getElementById('checkOut').value;
	    const adultCount = urlParams.get('adultCount') || document.getElementById('adultCount').value || 2;

	    // 2. 날짜 선택 안 했으면 경고 (방어 로직)
	    if (!startDate || !endDate) {
	        alert("체크인과 체크아웃 날짜를 먼저 선택해 주세요!");
	        document.getElementById('checkIn').focus();
	        return;
	    }

	    // 3. 최종 결제 주소 생성 (우리가 만든 컨트롤러 주소와 매칭)
	    // contextPath는 header.jsp에 있다고 했으니 그대로 사용!
	    const url = contextPath + "/product/accommodation/" + roomTypeNo + "/booking" +
	                "?tripProdNo=" + tripProdNo +
	                "&startDate=" + startDate +
	                "&endDate=" + endDate +
	                "&adultCount=" + adultCount;

	    // 4. 이동!
	    location.href = url;
	}

	// JSP에서 호출할 수 있게 window에 등록
	window.goBooking = goBooking;
	
	