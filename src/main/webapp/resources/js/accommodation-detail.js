/**
 * 숙소 검색 / 상세 공용 JS
 * 작성일: 2026.01.18
 */

/* =======================
   1. 전역 상태
======================= */

let currentPage = 1;
const pageSize = 12;
let isLoading = false;

const state = {
    contextPath: '',
    accNo: '',
    accName: '',
    selectedRoom: null,
    guests: { adult: 2, child: 0 },
    nights: 0,
    isLoggedIn: false,
    reviewPage: 1,
    inquiryPage: 1
};

const searchData = {
    initialListSize: 0,
    totalCount: 0,
    areaCode: '',
    keyword: ''
};

/* =======================
   2. JSP 연동 초기화
======================= */

function initSearch(config) {
    Object.assign(searchData, config);
    console.log('[Search Init]', searchData);
}

function initDetail(config) {
    Object.assign(state, config);
    console.log('[Detail Init]', state.accName);
}

// JSP에서 반드시 접근해야 하는 함수
window.initSearch = initSearch;
window.initDetail = initDetail;

/* =======================
   3. 인원 수 조절 (검색 페이지)
======================= */

window.updateCount = function (type, delta) {
    const input = document.getElementById(type + 'Count');
    if (!input) return;

    const newValue = parseInt(input.value) + delta;
    if (newValue < 1 || newValue > 8) return;

    input.value = newValue;
    state.guests[type] = newValue;
};

/* =======================
   4. 인피니티 스크롤
======================= */

window.addEventListener('scroll', () => {
    if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 500) {
        if (!isLoading) loadNextPage();
    }
});

function loadNextPage() {
    const currentCount = document.querySelectorAll('.accommodation-card').length;
    if (currentCount >= searchData.totalCount) {
        toggleScrollEnd(true);
        return;
    }

    isLoading = true;
    currentPage++;

    const startRow = (currentPage - 1) * pageSize + 1;
    const endRow = currentPage * pageSize;

    const url =
        `${state.contextPath}/product/accommodation/api/list` +
        `?startRow=${startRow}&endRow=${endRow}` +
        `&areaCode=${searchData.areaCode || ''}` +
        `&keyword=${searchData.keyword || ''}`;

    fetch(url)
        .then(res => res.json())
        .then(renderList)
        .catch(console.error)
        .finally(() => isLoading = false);
}

function toggleScrollEnd(isEnd) {
    document.getElementById('accomScrollEnd').style.display = isEnd ? 'block' : 'none';
    document.getElementById('accomScrollLoader').style.display = isEnd ? 'none' : 'block';
}

function renderList(list = []) {
    if (list.length === 0) {
        toggleScrollEnd(true);
        return;
    }

    const grid = document.querySelector('.accommodation-grid');
    list.forEach(acc => {
        grid.insertAdjacentHTML('beforeend', `
            <div class="accommodation-card">
                <a href="${state.contextPath}/product/accommodation/${acc.accNo}">
                    <img src="${acc.accFilePath || ''}">
                </a>
                <h3>${acc.accName}</h3>
            </div>
        `);
    });
}

/* =======================
   5. 상세 페이지 기능
======================= */

function selectRoom(roomId, roomName, price) {
    state.selectedRoom = { id: roomId, name: roomName, price };
    document.getElementById('bookingBtn').disabled = false;
    updateTotalPrice();
}
window.selectRoom = selectRoom;

function updateGuest(type, delta) {
    const limit = type === 'adult' ? [1, 10] : [0, 5];
    state.guests[type] = Math.max(limit[0], Math.min(limit[1], state.guests[type] + delta));
    
    // JSP의 <span id="adultCount">2</span> 부분을 업데이트!
    const el = document.getElementById(type + 'Count');
    if(el) el.textContent = state.guests[type];
    
    updateTotalPrice();
}

function updateTotalPrice() {
    const el = document.getElementById('totalPrice');
    if (!state.selectedRoom || state.nights <= 0) {
        el.textContent = '-';
        return;
    }
    el.textContent = (state.selectedRoom.price * state.nights).toLocaleString() + '원';
}

/* =======================
   6. 날짜 선택
======================= */

document.addEventListener('DOMContentLoaded', () => {
    if (typeof flatpickr === 'undefined') return;

    const common = { locale: 'ko', dateFormat: 'Y-m-d', minDate: 'today' };

    const outPicker = flatpickr('#checkOutDate', {
        ...common,
        onChange: calculateNights
    });

    flatpickr('#checkInDate', {
        ...common,
        onChange: ([date]) => {
            outPicker.set('minDate', new Date(date.getTime() + 86400000));
            calculateNights();
        }
    });
});

function calculateNights() {
    const inDate = new Date(document.getElementById('checkInDate').value);
    const outDate = new Date(document.getElementById('checkOutDate').value);
    if (!inDate || !outDate) return;

    state.nights = Math.ceil((outDate - inDate) / 86400000);
    updateTotalPrice();
}

/* =======================
   7. 결제
======================= */

function handleBookingSubmit(e) {
    e.preventDefault();
    if (!state.isLoggedIn) {
        alert("로그인이 필요한 서비스입니다.");
        location.href = state.contextPath + '/login';
        return;
    }
    
    const checkIn = document.getElementById('checkInDate').value;
    const checkOut = document.getElementById('checkOutDate').value;

    location.href = `${state.contextPath}/product/accommodation/${state.accNo}/booking` +
                    `?roomNo=${state.selectedRoom.id}` +
                    `&startDate=${checkIn}` +
                    `&endDate=${checkOut}` +
                    `&adultCount=${state.guests.adult}`;
}

