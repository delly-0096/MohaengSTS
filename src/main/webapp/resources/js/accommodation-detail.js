/**
 * 숙소 상세 페이지 전용 JS
 */

/* =======================
   1. 전역 상태
======================= */
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
   3. 인원 조절 로직 (추가됨!)
======================= */
function updateGuest(type, delta) {
    const limit = type === 'adult' ? [1, 10] : [0, 5];
    state.guests[type] = Math.max(limit[0], Math.min(limit[1], state.guests[type] + delta));
    
    const el = document.getElementById(type + 'Count');
    if(el) el.textContent = state.guests[type];
    
    updateTotalPrice(); // 인원 바뀌면 금액도 다시!
}
window.updateGuest = updateGuest;

/* =======================
   4. 객실 선택 및 렌더링
======================= */
function selectRoom(roomId, roomName, price, baseGuest, extraFee) {
    if (state.selectedRooms.some(r => r.id === roomId)) {
        alert("이미 선택된 객실입니다.");
        return;
    }

    state.selectedRooms.push({
        id: roomId,
        name: roomName,
        price: price,
        baseGuest: baseGuest,
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
    const totalEl = document.getElementById('totalPrice');
    const nightEl = document.getElementById('nightStayCount');
    
    if (state.selectedRooms.length === 0 || state.nights <= 0) {
        if(totalEl) totalEl.textContent = '-';
        if(nightEl) nightEl.textContent = '';
        return;
    }

    let totalAmount = 0;
    const totalGuests = state.guests.adult + state.guests.child;

    state.selectedRooms.forEach(room => {
        let roomPrice = room.price;
        if (totalGuests > room.baseGuest) {
            roomPrice += (totalGuests - room.baseGuest) * room.extraFee;
        }
        totalAmount += (roomPrice * state.nights);
    });

    if(totalEl) totalEl.textContent = totalAmount.toLocaleString() + '원';
    if(nightEl) nightEl.textContent = state.nights + "박 기준 (인원 요금 포함)";
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
