/**
 * 숙소 목록 페이지 전용 스크립트
 * 기능: 인피니티 스크롤, 숙소 카드 동적 생성, 드롭다운 제어, 북마크
 */

// ==================== 전역 변수 설정 ====================

var accomCurrentPage = 1;
var accomPageSize = 12; 
var accomIsLoading = false;
var accomHasMore = true;

// ==================== 인피니티 스크롤 로직 ====================
document.addEventListener('DOMContentLoaded', function() {
    if (typeof initialListSize !== 'undefined' && initialListSize < accomPageSize) {
        accomHasMore = false;
        const loader = document.getElementById('accomScrollLoader');
        if(loader) loader.style.display = 'none';
    } else {
        initAccomInfiniteScroll();
    }
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
    if(loader) loader.style.display = 'flex';

    const urlParams = new URLSearchParams(window.location.search);
    const areaCode = urlParams.get('areaCode') || '';

    fetch(`${contextPath}/product/accommodation/more?page=${accomCurrentPage + 1}&areaCode=${areaCode}`)        .then(res => res.json())
        .then(data => {
			const list = data.accList;
			
			if (!list || list.length === 0) {
			    accomHasMore = false;
                if(loader) loader.style.display = 'none';
                document.getElementById('accomScrollEnd').style.display = 'block';
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

			const loader = document.getElementById('accomScrollLoader');
			            const endDiv = document.getElementById('accomScrollEnd');
			            grid.appendChild(loader); // 로더를 맨 아래로 다시 이동
			            grid.appendChild(endDiv); // 종료 메시지도 맨 아래로 이동

            accomHasMore = data.hasMore;
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

// ==================== 카드 생성 함수 ====================
function createAccommodationCard(data) {
    const priceText = new Intl.NumberFormat().format(data.finalPrice || 0);
    const rating = data.starGrade || '0.0';
    const reviews = 124; 

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
                        <div class="room-option-price">
                            <span class="price">${new Intl.NumberFormat().format(room.price)}원</span>
                            <span class="per-night">/ 1박</span>
                        </div>
                        <a href="${contextPath}/product/accommodation/${data.accNo}/booking?roomNo=${room.roomTypeNo}" class="btn btn-primary btn-sm">결제</a>
                    </div>`;
                lastRoomName = room.roomName;
            }
        });
    } else {
        roomsHtml = '<div class="p-3 text-center text-muted">예약 가능한 객실이 없습니다.</div>';
    }

    // data-accommodation-id의 오타 수정 및 최종 조립
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