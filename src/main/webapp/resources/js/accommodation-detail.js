/**
 * 숙소 상세 페이지 전용 JS (Final Version)
 */

/* =======================
   1. 전역 상태 (중복 선언 삭제 및 통합)
======================= */
var reviewPage = 1;
var isLoadingReview = false;

// 하나로 통합된 state 객체
const state = {
    contextPath: '',
    accNo: '',
    accName: '',
    tripProdNo: '',
    selectedRooms: [], 
    guests: { adult: 2, child: 0 },
    nights: 0,
    isLoggedIn: false,
    isBusiness: false
};

/* =======================
   2. 초기화 (JSP에서 호출됨)
======================= */
function initDetail(config) {
    Object.assign(state, config);
    
    // JSP에 적힌 초기 인원수 동기화
    const adultEl = document.getElementById('adultCount');
    const childEl = document.getElementById('childCount');
    if(adultEl) state.guests.adult = parseInt(adultEl.textContent) || 2;
    if(childEl) state.guests.child = parseInt(childEl.textContent) || 0;
    
    // 초기 박수 계산 및 금액 갱신
    calculateNights();
}
window.initDetail = initDetail;

/* =======================
   3. 인원 조절 로직
======================= */
function updateGuest(type, delta) {
    let newCount = state.guests[type] + delta;
    
    if (type === 'adult' && newCount < 1) return;
    if (type === 'child' && newCount < 0) return;

    // 선택된 방이 있다면, 그 방들의 maxGuest 중 가장 작은 값을 넘지 않는지 확인 (방어 로직)
    if (state.selectedRooms.length > 0) {
        const totalAfter = (type === 'adult' ? newCount : state.guests.adult) 
                         + (type === 'child' ? newCount : state.guests.child);
        
        // 선택된 모든 방에 대해 최대 인원 체크
        for (let room of state.selectedRooms) {
            if (totalAfter > room.maxGuest) {
                alert(`선택된 객실(${room.name})의 최대 수용 인원(${room.maxGuest}명)을 초과할 수 없습니다.`);
                return;
            }
        }
    }

    state.guests[type] = newCount;
    const el = document.getElementById(type + 'Count');
    if(el) el.textContent = newCount;
    
    updateTotalPrice(); // 인원 바뀌면 추가 요금 때문에 총액 갱신해야 함!
}
window.updateGuest = updateGuest;

/* =======================
   4. 객실 선택 및 렌더링
======================= */
function selectRoom(roomId, roomName, price, baseGuest, maxGuest, extraFee, unitPrice) {
    const currentTotal = state.guests.adult + state.guests.child;
    
    if (currentTotal > maxGuest) {
        alert(`이 객실은 최대 ${maxGuest}인까지만 이용 가능합니다. 인원수를 조정해주세요.`);
        return;
    }
        
    if (state.selectedRooms.some(r => r.id === roomId)) {
        alert("이미 선택된 객실입니다.");
        return;
    }

    state.selectedRooms.push({
        id: roomId,
        name: roomName,
        displayPrice: price,    // 할인가
        unitPrice: unitPrice,   // 판매단가
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
            <div class="text-end text-primary" style="font-weight:bold;">${room.displayPrice.toLocaleString()}원</div>
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
        const diff = outDate - inDate;
        state.nights = Math.max(0, Math.ceil(diff / (1000 * 60 * 60 * 24)));
    } else {
        state.nights = 0;
    }
    updateTotalPrice(); 
}
window.calculateNights = calculateNights;

function updateTotalPrice() {
    const totalEl = document.getElementById('totalPrice');
    const nightEl = document.getElementById('nightStayCount');
    const bookingBtn = document.getElementById('bookingBtn');

    if (state.nights <= 0 || state.selectedRooms.length === 0) {
        if (totalEl) totalEl.textContent = '-';
        if (nightEl) nightEl.textContent = '객실과 날짜를 선택해주세요.';
        if (bookingBtn) bookingBtn.disabled = true;
        return;
    }

    let totalAmount = 0;
    const totalGuests = state.guests.adult + state.guests.child;

    state.selectedRooms.forEach(room => {
        let roomPrice = room.displayPrice;
        // 인원 추가 요금 계산
        if (totalGuests > (room.baseGuest || 2)) {
            const extraCount = totalGuests - (room.baseGuest || 2);
            roomPrice += extraCount * (room.extraFee || 0);
        }
        totalAmount += (roomPrice * state.nights);
    });

    if (totalEl) totalEl.textContent = totalAmount.toLocaleString() + '원';
    if (nightEl) nightEl.textContent = `${state.nights}박 기준 (인원 추가 포함)`;
    if (bookingBtn) bookingBtn.disabled = false;
}

/* =======================
   6. 페이지 로드 및 Flatpickr (통합)
======================= */
document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const startDateParam = urlParams.get('startDate'); 
    const endDateParam = urlParams.get('endDate');   
    const adultParam = urlParams.get('adultCount');

    // 1. 인풋에 값 먼저 넣기
    if(startDateParam) document.getElementById('checkInDate').value = startDateParam;
    if(endDateParam) document.getElementById('checkOutDate').value = endDateParam;
    if(adultParam) {
        const adultEl = document.getElementById('adultCount');
        if(adultEl) adultEl.textContent = adultParam;
        state.guests.adult = parseInt(adultParam);
    }

    // 2. Flatpickr 초기화
    const fpIn = flatpickr("#checkInDate", {
        dateFormat: "Y-m-d",
        minDate: "today",
        defaultDate: startDateParam || "today",
        onChange: function(selectedDates, dateStr) {
            const nextDay = new Date(selectedDates[0]);
            nextDay.setDate(nextDay.getDate() + 1);
            fpOut.set('minDate', nextDay);
            calculateNights();
        }
    });

    const fpOut = flatpickr("#checkOutDate", {
        dateFormat: "Y-m-d",
        minDate: startDateParam ? new Date(new Date(startDateParam).getTime() + 86400000) : "today",
        defaultDate: endDateParam || new Date().fp_incr(1),
        onChange: function() {
            calculateNights();
        }
    });

    calculateNights(); // 초기 박수 계산
});
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
	const firstRoomNo = state.selectedRooms[0].id;

	const tripProdNo = document.getElementById('tripProdNo').value;
	const finalTripProdNo = tripProdNo || TRIP_PROD_NO;
	const unitPrice = state.selectedRooms[0].unitPrice; // 할인 전 단가 추출

	var url = state.contextPath + "/product/accommodation/" + firstRoomNo + "/booking" +
	              "?tripProdNo=" + finalTripProdNo + 
				  "&price=" + unitPrice +
	              "&roomNo=" + roomNos +       
	              "&startDate=" + checkIn +
	              "&endDate=" + checkOut +
	              "&adultCount=" + state.guests.adult +
	              "&childCount=" + state.guests.child;
				  
	console.log("최종 이동 주소:", url);
    location.href = url;
}
window.handleBookingSubmit = handleBookingSubmit;

/* =======================
   7. 갤러리 이미지 변경
======================= */
// ==================== [숙소] 상품 이미지 관리 ====================
var newImageFiles = [];
var isUploadingImages = false;

// 시큐리티 CSRF 토큰 정보 (JSP 메타태그에서 읽어옴)
const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;

function openImageUploadModal() {
    newImageFiles = [];
    document.getElementById('newImagesPreview').innerHTML = '';
    
    // 부트스트랩 모달 띄우기
    var modalElement = document.getElementById('imageUploadModal');
    if(modalElement) {
        var modal = new bootstrap.Modal(modalElement);
        modal.show();
        loadCurrentImages();
    }
}

// 1. 현재 등록된 이미지 목록 불러오기 (Ajax)
function loadCurrentImages() {
    var grid = document.getElementById('currentImagesGrid');
    if(!grid) return;

    // 경로를 accommodation용 API로 수정!
    fetch(`${cp}/product/accommodation/${TRIP_PROD_NO}/images`)
        .then(res => res.json())
        .then(data => {
            if (data.success && data.images && data.images.length > 0) {
                let html = '';
                data.images.forEach((img, index) => {
                    html += `
                        <div class="current-image-item ${index === 0 ? 'main-image' : ''}" data-file-no="${img.FILE_NO}">
                            <img src="${cp}/upload/product/${img.FILE_PATH}" alt="상품 이미지">
                            <button class="delete-btn" onclick="deleteProductImage(${img.FILE_NO})">
                                <i class="bi bi-x"></i>
                            </button>
                            ${index === 0 ? '<span class="main-badge">대표</span>' : ''}
                        </div>`;
                });
                grid.innerHTML = html;
            } else {
                grid.innerHTML = '<div class="no-images-message"><i class="bi bi-image"></i><p>등록된 이미지가 없습니다.</p></div>';
            }
        });
}

// 2. 이미지 삭제 (시큐리티 토큰 필수!)
function deleteProductImage(fileNo) {
    if (!confirm('이 이미지를 삭제하시겠습니까?')) return;
    
    fetch(`${cp}/product/accommodation/${TRIP_PROD_NO}/image/delete`, {
        method: 'POST',
        headers: { 
            'Content-Type': 'application/json',
            [csrfHeader]: csrfToken // 시큐리티 헤더 추가
        },
        body: JSON.stringify({ fileNo: fileNo })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            alert('이미지가 삭제되었습니다.');
            loadCurrentImages();
            refreshGallery(); // 메인 갤러리 새로고침
        } else {
            alert(data.message || '삭제에 실패했습니다.');
        }
    });
}

// 3. 이미지 업로드 (FormData 활용)
function uploadProductImages() {
    if (isUploadingImages) return;
    if (newImageFiles.length === 0) {
        bootstrap.Modal.getInstance(document.getElementById('imageUploadModal')).hide();
        return;
    }
    
    isUploadingImages = true;
    const submitBtn = document.querySelector('#imageUploadModal .btn-primary');
    const originalText = submitBtn.innerHTML;
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>처리 중...';
    
    const formData = new FormData();
    newImageFiles.forEach(file => formData.append('files', file));
    
    fetch(`${cp}/product/accommodation/${TRIP_PROD_NO}/image/upload`, {
        method: 'POST',
        headers: { [csrfHeader]: csrfToken }, // 시큐리티 헤더 추가 (FormData이므로 Content-Type은 생략)
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            alert(data.message);
            newImageFiles = [];
            loadCurrentImages();
            refreshGallery(); // 메인 갤러리 새로고침
            bootstrap.Modal.getInstance(document.getElementById('imageUploadModal')).hide();
        } else {
            alert(data.message);
        }
    })
    .finally(() => {
        isUploadingImages = false;
        submitBtn.disabled = false;
        submitBtn.innerHTML = originalText;
    });
}

// 4. 메인 화면 갤러리 동적 갱신
function refreshGallery() {
    fetch(`${cp}/product/accommodation/${TRIP_PROD_NO}/images`)
    .then(res => res.json())
    .then(data => {
        const mainGallery = document.querySelector('.accommodation-gallery');
        if(!mainGallery || !data.success) return;

        const images = data.images;
        if(images.length > 0) {
            // 메인 이미지 업데이트
            document.getElementById('mainImage').src = `${cp}/upload/product/${images[0].FILE_PATH}`;
            
            // 그리드 부분 업데이트 (팀원의 grid 레이아웃에 맞춰 그림)
            const grid = document.querySelector('.gallery-grid');
            let gridHtml = '';
            
            // 2~4번째 이미지
            for(let i=1; i < Math.min(images.length, 4); i++) {
                gridHtml += `<img src="${cp}/upload/product/${images[i].FILE_PATH}" onclick="changeMainImage(this.src, ${i+1})">`;
            }
            
            // 5번째 이미지 이상일 때 +N 오버레이
            if(images.length > 4) {
                gridHtml += `
                    <div class="gallery-more" onclick="openGalleryModal()">
                        <img src="${cp}/upload/product/${images[4].FILE_PATH}">
                        <div class="gallery-more-overlay"><span>+${images.length - 4}</span></div>
                    </div>`;
            }
            grid.innerHTML = gridHtml;
        }
    });
}
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
			

            if (typeof isLoggedIn !== 'undefined' && !isLoggedIn) {
                alert('로그인이 필요한 서비스입니다.');
                return;
            }

            // [수정 포인트 1] accNo 대신 서버가 필요로 하는 tripProdNo를 가져와야 해!
            // HTML 어딘가에 tripProdNo가 숨겨져 있어야 함 (예: hidden input)
            const tripProdNo = TRIP_PROD_NO; 
            
            if (!tripProdNo) {
                console.error("상품 번호(tripProdNo)를 찾을 수가 없어요");
                return;
            }

            const inquiryData = {
                // [수정 포인트 2] VO 구조에 맞춰서 데이터 세팅 (accNo가 아니라 tripProdNo가 핵심)
                inquiryCtgry: document.getElementById('inquiryType').value,
                prodInqryCn: document.getElementById('inquiryContent').value.trim(),
                secretYn: document.getElementById('inquirySecret').checked ? 'Y' : 'N'
            };

            if (!inquiryData.prodInqryCn || inquiryData.prodInqryCn.length < 10) {
                alert('문의 내용을 10자 이상 입력해주세요.');
                return;
            }

            // [수정 포인트 3] URL을 서버의 @PostMapping 구조와 똑같이 맞춰야 해!
            // PathVariable {tripProdNo}가 주소 중간에 들어감
            fetch(`${cp}/product/accommodation/${tripProdNo}/inquiry/insert`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(inquiryData)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert('문의가 등록되었습니다.');
                    location.reload(); 
                } else {
                    alert(data.message || '등록 실패');
                }
            })
            .catch(err => console.error("문의 등록 통신 에러:", err));
        });
    }
});

// 2. 문의 더보기 (페이징)
var inquiryPage = 1;
function loadMoreInquiries() {
    inquiryPage++;
    const btn = document.querySelector('#inquiryMoreBtn button');
	const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
	const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;
    
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

/*=========================
	10. 븍마크 로직
==========================*/

function addToBookmark() {
    // JSP에서 선언한 isLoggedIn 변수 활용
    if (!isLoggedIn) {
        if (confirm("로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?")) {
            sessionStorage.setItem('returnUrl', window.location.href);
            location.href = cp + '/member/login';
        }
        return;
    }

    // 리더의 컨트롤러 주소와 변수(cp, TRIP_PROD_NO)에 딱 맞춤
    fetch(`${cp}/product/accommodation/${TRIP_PROD_NO}/bookmark`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            // 토스트 알림 (showToast 함수가 있다고 가정)
            showToast(data.message, 'success');
            
            // 하트 아이콘 UI 변경 (ID가 bookmarkIcon인 경우)
            const icon = document.getElementById('bookmarkIcon');
            if (icon) {
                if (data.bookmarked) {
                    icon.classList.replace('bi-heart', 'bi-heart-fill');
                    icon.style.color = 'red';
                } else {
                    icon.classList.replace('bi-heart-fill', 'bi-heart');
                    icon.style.color = '';
                }
            }
        } else {
            showToast(data.message, 'error');
        }
    })
    .catch(err => {
        console.error("북마크 처리 중 에러:", err);
        showToast("처리 중 오류가 발생했습니다.", "error");
    });
}

// 페이지 로드시
document.addEventListener('DOMContentLoaded', function() {
    	if (typeof initMap === 'function') initMap();
	    if (typeof initGalleryNavigation === 'function') initGalleryNavigation();
	    
	    // 리더의 프로젝트에 장바구니가 없다면 loadCart 등은 빼도 돼!
	    console.log("숙소 상세 페이지 로드 완료 (TRIP_PROD_NO: " + TRIP_PROD_NO + ")");
});

