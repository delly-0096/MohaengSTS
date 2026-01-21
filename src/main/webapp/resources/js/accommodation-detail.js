/**
 * 숙소 상세 페이지 전용 JS
 */

/* =======================
   1. 전역 상태
======================= */
var reviewPage = 1;
var isLoadingReview = false;

const state = {
    contextPath: '',
    accNo: '',
    accName: '',
    selectedRooms: [], // 다중 선택 지원
    guests: { adult: 2, child: 0 },
    nights: 0,
    isLoggedIn: false
};

/* =======================
   2. 초기화
======================= */
function initDetail(config) {
    Object.assign(state, config);
    
    // JSP에 적힌 초기 인원수 동기화
    const adultEl = document.getElementById('adultCount');
    const childEl = document.getElementById('childCount');
    if(adultEl) state.guests.adult = parseInt(adultEl.textContent) || 2;
    if(childEl) state.guests.child = parseInt(childEl.textContent) || 0;
}
window.initDetail = initDetail;

/* =======================
   3. 인원 조절 로직
======================= */
function updateGuest(type, delta) {
	let newCount = state.guests[type] + delta;
	
    if (type === 'adult' && newCount < 1) return;
    if (type === 'child' && newCount < 0) return;

    // 선택된 방이 있다면, 그 방의 maxGuest를 넘지 않는지 확인
    if (state.selectedRooms.length > 0) {
        const currentMax = state.selectedRooms[0].maxGuest;
        const totalAfter = (type === 'adult' ? newCount : state.guests.adult) 
                         + (type === 'child' ? newCount : state.guests.child);

        if (totalAfter > currentMax) {
            alert(`선택된 객실의 최대 수용 인원(${currentMax}명)을 초과할 수 없습니다.`);
            return;
        }
    }

    state.guests[type] = newCount;
    document.getElementById(type + 'Count').textContent = newCount;
    updateTotalPrice();
}

/* =======================
   4. 객실 선택 및 렌더링
======================= */
function selectRoom(roomId, roomName, price, baseGuest, maxGuest, extraFee) {
	// 현재 선택한 인원수 합계 계산
	const currentTotal = state.guests.adult + state.guests.child;
	
	// 핵심: 최대 인원 체크
	if (currentTotal > maxGuest) {
	        alert(`이 객실은 최대 ${maxGuest}인까지만 이용 가능합니다. 인원수를 조정해주세요.`);
	        return;
	    }
		
	// 중복 선택 방지
    if (state.selectedRooms.some(r => r.id === roomId)) {
        alert("이미 선택된 객실입니다.");
        return;
    }

    state.selectedRooms.push({
        id: roomId,
        name: roomName,
        price: price,
        baseGuest: baseGuest,
		maxGuest: maxGuest,
        extraFee: extraFee
    });
    
    renderSelectedRooms();
    updateTotalPrice();
}
window.selectRoom = selectRoom;

function renderSelectedRooms() {
    const listEl = document.getElementById('selectedRoomList');
    const infoBox = document.getElementById('selectedRoomInfo');
    const bookingBtn = document.getElementById('bookingBtn');

    if (state.selectedRooms.length === 0) {
        if(infoBox) infoBox.style.display = 'none';
        if(bookingBtn) bookingBtn.disabled = true;
        return;
    }

    listEl.innerHTML = state.selectedRooms.map((room, index) => `
        <div class="selected-room-item" style="margin-bottom: 8px; font-size: 0.9rem; background: #f8f9fa; padding: 10px; border-radius: 4px; border: 1px solid #eee;">
            <div class="d-flex justify-content-between align-items-center">
                <span><strong>${room.name}</strong></span>
                <button type="button" onclick="removeRoom(${index})" style="border:none; background:none; color:red; cursor:pointer;">
                    <i class="bi bi-x-circle-fill"></i>
                </button>
            </div>
            <div class="text-end text-primary" style="font-weight:bold;">${room.price.toLocaleString()}원</div>
        </div>
    `).join('');

    if(infoBox) infoBox.style.display = 'block';
    if(bookingBtn) bookingBtn.disabled = false;
}

function removeRoom(index) {
    state.selectedRooms.splice(index, 1);
    renderSelectedRooms();
    updateTotalPrice();
}
window.removeRoom = removeRoom;

/* =======================
   5. 날짜 및 금액 계산
======================= */
function calculateNights() {
    const inVal = document.getElementById('checkInDate').value;
    const outVal = document.getElementById('checkOutDate').value;
    
    if (inVal && outVal) {
        const inDate = new Date(inVal);
        const outDate = new Date(outVal);
        state.nights = Math.ceil((outDate - inDate) / 86400000);
    } else {
        state.nights = 0;
    }
    updateTotalPrice();
}
window.calculateNights = calculateNights;

function updateTotalPrice() {
    // 1. 필요한 요소를 먼저 찾기 (id 일치 확인!)
    const totalEl = document.getElementById('totalPrice');
    const nightEl = document.getElementById('nightStayCount');
    const bookingBtn = document.getElementById('bookingBtn');

    // 2. 방어 로직: 숙박 일수가 없거나 선택된 객실이 없을 때
    if (state.nights <= 0 || state.selectedRooms.length === 0) {
        if (totalEl) totalEl.textContent = '-';
        if (nightEl) nightEl.textContent = '객실과 날짜를 선택해주세요.';
        if (bookingBtn) bookingBtn.disabled = true; // 예약 버튼 비활성화
        return;
    }

    // 3. 금액 계산 로직
    let totalAmount = 0;
    const totalGuests = state.guests.adult + state.guests.child;

    state.selectedRooms.forEach(room => {
        let roomPrice = room.price;
        // 기준 인원 초과 시 추가 요금 발생
        if (totalGuests > room.baseGuest) {
            roomPrice += (totalGuests - room.baseGuest) * room.extraFee;
        }
        totalAmount += (roomPrice * state.nights);
    });

    // 4. 화면에 값 뿌려주기
    if (totalEl) {
        totalEl.textContent = totalAmount.toLocaleString() + '원';
    }
    
    if (nightEl) {
        nightEl.textContent = `${state.nights}박 기준 (추가 인원 요금 포함)`;
    }

    // 5. 결제 버튼 활성화
    if (bookingBtn) {
        bookingBtn.disabled = false;
    }
}

/* =======================
   6. 예약 제출 (다중 선택 대응)
======================= */
function handleBookingSubmit(e) {
    e.preventDefault();
    
    if (!state.isLoggedIn) {
        if(confirm("로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?")) {
            location.href = state.contextPath + '/member/login';
        }
        return;
    }
    
    if(state.selectedRooms.length === 0) {
        alert("객실을 먼저 선택해주세요.");
        return;
    }

    const checkIn = document.getElementById('checkInDate').value;
    const checkOut = document.getElementById('checkOutDate').value;

    // 여러 개 선택 시 처리 (일단 첫 번째 객실 번호로 보냄, 필요시 수정)
    const roomNos = state.selectedRooms.map(r => r.id).join(',');

    location.href = `${state.contextPath}/product/accommodation/${state.accNo}/booking` +
                    `?roomNo=${roomNos}` + 
                    `&startDate=${checkIn}` +
                    `&endDate=${checkOut}` +
                    `&adultCount=${state.guests.adult}` +
                    `&childCount=${state.guests.child}`;
}
window.handleBookingSubmit = handleBookingSubmit;

/* =======================
   7. 갤러리 이미지 변경
======================= */
function changeMainImage(imgEl, index) {
    const mainImg = document.getElementById('mainImage');
    const badge = document.querySelector('.gallery-badge');
    
    // 메인 이미지 주소 교체
    mainImg.src = imgEl.src;
    
    // 배지 텍스트 업데이트 (예: 2/12)
    if (badge) {
        badge.innerHTML = `<i class="bi bi-images me-1"></i>${index}/12`;
    }
    
    // 선택된 이미지 강조 효과 (필요시)
    document.querySelectorAll('.gallery-grid img').forEach(img => img.style.opacity = '0.6');
    imgEl.style.opacity = '1';
}
window.changeMainImage = changeMainImage;

/* =======================
   8. 숙소 신고 기능 
======================= */
function reportAccommodation() {
    // 1. 신고 대상 정보 가져오기 (initDetail에서 받은 state 값 활용)
    const targetId = state.accNo;
    const targetName = state.accName;

    if (!targetId || targetId === "null") {
        alert('신고할 숙소 정보가 없습니다.');
        return;
    }

    // 2. 공통 신고 모달 호출 (채팅방 로직과 동일)
    if (typeof openReportModal === 'function') {
        // 타입은 'ACCOMMODATION'으로 구분해서 전송!
        openReportModal('ACCOMMODATION', targetId, targetName);
    } else {
        console.error("신고 모달 함수(openReportModal)를 찾을 수 없습니다.");
        alert("신고 기능을 현재 사용할 수 없습니다.");
    }
}
window.reportAccommodation = reportAccommodation;

/*=========================
	9. 카카오 API 지도 표시
==========================*/
document.addEventListener("DOMContentLoaded", function() {
    // 카카오 맵 API가 완전히 로드된 후 실행
    kakao.maps.load(function() {
        if (mapInfo && mapInfo.addr) {
            initAccommodationMap(mapInfo.addr, mapInfo.name);
        }
    });
});

function initAccommodationMap(address, placeName) {
    var mapContainer = document.getElementById('map'), 
        mapOption = {
            center: new kakao.maps.LatLng(33.450701, 126.570667), 
            level: 3 
        };  

    var map = new kakao.maps.Map(mapContainer, mapOption); 
    var geocoder = new kakao.maps.services.Geocoder();

    // 주소로 좌표를 검색합니다
    geocoder.addressSearch(address, function(result, status) {
         if (status === kakao.maps.services.Status.OK) {
            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

            var marker = new kakao.maps.Marker({
                map: map,
                position: coords
            });

            // 인포윈도우로 숙소 이름 표시
            var infowindow = new kakao.maps.InfoWindow({
                content: `<div style="width:150px;text-align:center;padding:6px 0;">${placeName}</div>`
            });
            infowindow.open(map, marker);

            map.setCenter(coords);
        } 
    });
}

/*=========================
	10. 숙소 리뷰 로직
==========================*/
// 1. 리뷰 더보기 (페이징 처리)
function loadMoreReviews() {
    if (isLoadingReview) return;
    
    isLoadingReview = true;
    reviewPage++;
    
    // 버튼 상태 변경
    var btn = document.querySelector('.review-more button');
    var originalHtml = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>로딩 중...';
    
    // 리더의 숙소 번호(accNo)를 TRIP_PROD_NO 대신 사용!
    fetch(CONTEXT_PATH + '/accommodation/reviews?accNo=' + accNo + '&page=' + reviewPage)
        .then(res => res.json())
        .then(data => {
            if (data.reviews && data.reviews.length > 0) {
                data.reviews.forEach(rv => appendReviewUI(rv));
            }
            
            // 더 불러올 리뷰가 없으면 버튼 숨기기
            if (!data.hasMore) {
                document.querySelector('.review-more').style.display = 'none';
            } else {
                btn.disabled = false;
                btn.innerHTML = originalHtml;
            }
            isLoadingReview = false;
        })
        .catch(err => {
            console.error('리뷰 로드 에러:', err);
            btn.disabled = false;
            btn.innerHTML = originalHtml;
            reviewPage--;
            isLoadingReview = false;
        });
}

// 2. 리뷰 동적 추가 (UI 생성)
function appendReviewUI(rv) {
    const reviewList = document.getElementById('reviewList');
    
    // 별점 렌더링
    let starsHtml = '';
    for (let i = 1; i <= 5; i++) {
        starsHtml += (i <= rv.rating) ? '<i class="bi bi-star-fill"></i>' : '<i class="bi bi-star"></i>';
    }

    // 본인 확인 (시큐리티 principal.memNo 사용)
    let dropdownHtml = '';
    if (loginMemNo && loginMemNo === rv.memNo) {
        dropdownHtml = `
            <div class="dropdown">
                <button class="btn-more" type="button" data-bs-toggle="dropdown">
                    <i class="bi bi-three-dots-vertical"></i>
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="javascript:void(0)" onclick="openEditReviewModal(${rv.prodRvNo}, ${rv.rating}, '${rv.prodReview}')">수정</a></li>
                    <li><a class="dropdown-item text-danger" href="javascript:void(0)" onclick="deleteReview(${rv.prodRvNo})">삭제</a></li>
                </ul>
            </div>`;
    }

    // 리뷰 아이템 HTML
    const html = `
        <div class="review-item" data-review-id="${rv.prodRvNo}">
            <div class="review-item-header">
                <div class="reviewer-info">
                    <div class="reviewer-avatar">
                        ${rv.profileImage ? `<img src="${CONTEXT_PATH}/upload${rv.profileImage}">` : '<i class="bi bi-person"></i>'}
                    </div>
                    <div>
                        <span class="reviewer-name">${rv.nickname}</span>
                        <span class="review-date">${rv.regDtStr}</span>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <div class="review-rating">${starsHtml}</div>
                    ${dropdownHtml}
                </div>
            </div>
            <div class="review-content"><p>${rv.prodReview}</p></div>
        </div>`;
    
    reviewList.insertAdjacentHTML('beforeend', html);
}

// 3. 리뷰 이미지 확대 보기
function openReviewImage(src) {
    const modal = document.createElement('div');
    modal.className = 'review-image-modal';
    modal.innerHTML = `
        <div class="review-image-modal-content">
            <button class="review-image-close" onclick="this.parentElement.parentElement.remove()">&times;</button>
            <img src="${src}" style="max-width:100%; max-height:80vh;">
        </div>`;
    document.body.appendChild(modal);
}

/*=========================
	10. 숙소 문의하기 로직
==========================*/
// 1. 문의 등록하기
document.addEventListener('DOMContentLoaded', function() {
    const inquiryForm = document.getElementById('inquiryForm');
    if (inquiryForm) {
        inquiryForm.addEventListener('submit', function(e) {
            e.preventDefault();

            // 로그인 체크 (시큐리티 isLoggedIn 변수 활용)
            if (typeof isLoggedIn !== 'undefined' && !isLoggedIn) {
                alert('로그인이 필요한 서비스입니다.');
                return;
            }

            const inquiryData = {
                accNo: accNo, // 리더의 숙소 번호
                inquiryCtgry: document.getElementById('inquiryType').value,
                prodInqryCn: document.getElementById('inquiryContent').value.trim(),
                secretYn: document.getElementById('inquirySecret').checked ? 'Y' : 'N'
            };

            if (!inquiryData.prodInqryCn || inquiryData.prodInqryCn.length < 10) {
                alert('문의 내용을 10자 이상 입력해주세요.');
                return;
            }

            // Ajax 요청 (투어 친구가 쓴 경로를 숙소 경로로 살짝 수정)
            fetch(CONTEXT_PATH + '/accommodation/inquiry/insert', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(inquiryData)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert('문의가 등록되었습니다.');
                    location.reload(); // 가장 깔끔한 방법!
                }
            });
        });
    }
});

// 2. 문의 더보기 (페이징)
var inquiryPage = 1;
function loadMoreInquiries() {
    inquiryPage++;
    const btn = document.querySelector('#inquiryMoreBtn button');
    
    fetch(`${CONTEXT_PATH}/accommodation/inquiries?accNo=${accNo}&page=${inquiryPage}`)
        .then(res => res.json())
        .then(data => {
            if (data.inquiries && data.inquiries.length > 0) {
                data.inquiries.forEach(inq => appendInquiryUI(inq));
            }
            if (!data.hasMore) {
                document.getElementById('inquiryMoreBtn').style.display = 'none';
            }
        });
}

// 3. 문의 삭제
function deleteInquiry(inquiryId) {
    if(!confirm("문의를 삭제하시겠습니까?")) return;
    
    fetch(CONTEXT_PATH + '/accommodation/inquiry/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ prodInqryNo: inquiryId })
    })
    .then(res => res.json())
    .then(data => {
        if(data.success) {
            alert('삭제되었습니다.');
            location.reload();
        }
    });
}

// 스크립트(XSS공격) 방지
function escapeHtml(text) {
    var div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}