/**
 * [숙박 예약 페이지 전용 스크립트]
 * 구성: 설정값, 초기화, 이미지 핸들링, 금액 계산, 동적 UI 생성, 폼 전송
 */

// 1. 전역 설정값 (중앙 관리)
let bookingConfig = {
    roomPricePerNight: 0,
    nights: 0,
    extraGuestPrice: 30000,
    addonsTotal: 0,
    roomImages: [],
    currentRoomImageIndex: 0,
    isLoggedIn: false,
    userType: '',
    contextPath: ''
};

// 2. 초기화 (엔트리 포인트)
function initBooking(config) {
    bookingConfig = { ...bookingConfig, ...config };
    
    // UI 동적 생성
    setupGuestOptions(config.baseGuestCount, config.maxGuestCount); // 인원수
    setupArrivalTimeOptions(config.checkInTime);                    // 도착시간
    
    // 이벤트 바인딩
    initAdditionalServices(); // 추가옵션 체크박스
    calculateTotal();         // 최초 금액 계산
}

// ---------------------------------------------------------
// 3. 이미지 갤러리 핸들러
// ---------------------------------------------------------

function changeRoomImage(index) {
    bookingConfig.currentRoomImageIndex = index;
    const mainImage = document.getElementById('roomMainImage');
    if (mainImage && bookingConfig.roomImages[index]) {
        mainImage.src = bookingConfig.roomImages[index].replace('w=800', 'w=600').replace('h=600', 'h=400');
    }
    document.querySelectorAll('.room-thumb').forEach((thumb, i) => {
        thumb.classList.toggle('active', i === index);
    });
}

function openRoomImageModal(index) {
    bookingConfig.currentRoomImageIndex = index;
    const modal = new bootstrap.Modal(document.getElementById('roomImageModal'));
    updateModalImage();
    modal.show();
}

function updateModalImage() {
    document.getElementById('roomModalImage').src = bookingConfig.roomImages[bookingConfig.currentRoomImageIndex];
    document.getElementById('currentImageIndex').textContent = bookingConfig.currentRoomImageIndex + 1;
    document.getElementById('totalImageCount').textContent = bookingConfig.roomImages.length;
}

function prevRoomImage() {
    bookingConfig.currentRoomImageIndex = (bookingConfig.currentRoomImageIndex - 1 + bookingConfig.roomImages.length) % bookingConfig.roomImages.length;
    updateModalImage();
    changeRoomImage(bookingConfig.currentRoomImageIndex);
}

function nextRoomImage() {
    bookingConfig.currentRoomImageIndex = (bookingConfig.currentRoomImageIndex + 1) % bookingConfig.roomImages.length;
    updateModalImage();
    changeRoomImage(bookingConfig.currentRoomImageIndex);
}

// ---------------------------------------------------------
// 4. 금액 및 옵션 계산 로직
// ---------------------------------------------------------

// 추가 옵션 이벤트 바인딩
function initAdditionalServices() {
    document.querySelectorAll('.service-option input').forEach(checkbox => {
        checkbox.addEventListener('change', () => {
            calculateAddons();
            calculateTotal();
        });
    });
}

// 추가 옵션 합계 계산
function calculateAddons() {
    bookingConfig.addonsTotal = 0;
    document.querySelectorAll('.service-option input:checked').forEach(checkbox => {
        bookingConfig.addonsTotal += parseInt(checkbox.dataset.price);
    });

    const row = document.getElementById('summaryAddonsRow');
    if (row) {
        row.style.display = bookingConfig.addonsTotal > 0 ? 'flex' : 'none';
        document.getElementById('summaryAddons').textContent = bookingConfig.addonsTotal.toLocaleString() + '원';
    }
}

// 인원 변경 시 가격 업데이트
function updateGuestPrice() {
    const guestCount = parseInt(document.getElementById('guestCount').value);
    const extraGuest = guestCount > 2 ? (guestCount - 2) * bookingConfig.extraGuestPrice : 0;

    document.getElementById('summaryGuests').textContent = `성인 ${guestCount}명`;
    const row = document.getElementById('summaryExtraGuestRow');
    if (row) {
        row.style.display = extraGuest > 0 ? 'flex' : 'none';
        document.getElementById('summaryExtraGuest').textContent = `+${extraGuest.toLocaleString()}원`;
    }
    calculateTotal();
}

// 최종 금액 합산 및 화면 갱신
function calculateTotal() {
    const guestCount = document.getElementById('guestCount') ? parseInt(document.getElementById('guestCount').value) : 2;
    const extraGuest = guestCount > 2 ? (guestCount - 2) * bookingConfig.extraGuestPrice : 0;
    const total = (bookingConfig.roomPricePerNight * bookingConfig.nights) + extraGuest + bookingConfig.addonsTotal;

    const elPrice = document.getElementById('summaryRoomPrice');
    const elTotal = document.getElementById('totalAmount');
    const elBtn = document.getElementById('payBtnText');

    if (elPrice) elPrice.textContent = `${bookingConfig.roomPricePerNight.toLocaleString()}원 x ${bookingConfig.nights}박`;
    if (elTotal) elTotal.textContent = `${total.toLocaleString()}원`;
    if (elBtn) elBtn.textContent = `${total.toLocaleString()}원 결제하기`;
}

// ---------------------------------------------------------
// 5. 동적 UI 생성 함수
// ---------------------------------------------------------

// 투숙객 선택 옵션 생성
function setupGuestOptions(baseCount, maxCount) {
    const select = document.getElementById('guestCount');
    if (!select) return;
    
    select.innerHTML = '';
    for (let i = 1; i <= maxCount; i++) {
        const option = document.createElement('option');
        option.value = i;
        let text = `성인 ${i}명`;
        if (i > baseCount) {
            const extraFee = (i - baseCount) * bookingConfig.extraGuestPrice;
            text += ` (+${extraFee.toLocaleString()}원)`;
        }
        option.textContent = text;
        
        // 검색 인원 우선 선택, 없으면 2명 기본
        if (i == bookingConfig.currentAdultCount) option.selected = true;
        else if (!bookingConfig.currentAdultCount && i === 2) option.selected = true;
        
        select.appendChild(option);
    }
}

// 예상 도착 시간 옵션 생성
function setupArrivalTimeOptions(checkInTime) {
    const select = document.getElementById('arrivalTime');
    if (!select) return;

    select.innerHTML = '<option value="">선택 안함</option>';
    let startHour = parseInt(checkInTime?.split(':')[0]) || 15;
    
    for (let i = startHour; i <= 22; i++) {
        const option = document.createElement('option');
        const timeStr = `${i}:00`;
        option.value = timeStr;
        option.textContent = (i === 22) ? `${timeStr} 이후` : `${timeStr} - ${i + 1}:00`;
        select.appendChild(option);
    }
}

// ---------------------------------------------------------
// 6. 권한 및 폼 제출
// ---------------------------------------------------------

function showLoginRequired() { /* ... 로그인 안내 HTML 코드 ... */ }
function showBusinessRestricted() { /* ... 기업제한 HTML 코드 ... */ }

// 약관 동의 체크 핸들러
function initAgreementEvents() {
    document.querySelectorAll('.agree-item').forEach(item => {
        item.addEventListener('change', () => {
            const requiredCount = document.querySelectorAll('.agree-item').length;
            const checkedCount = document.querySelectorAll('.agree-item:checked').length;
            const marketingChecked = document.getElementById('agreeMarketing')?.checked ?? true;
            document.getElementById('agreeAll').checked = (checkedCount === requiredCount && marketingChecked);
        });
    });
}

// 최종 폼 제출 (예약하기)
function initBookingForm() {
    const form = document.getElementById('accommodationBookingForm');
    if (!form) return;

    form.addEventListener('submit', function(e) {
        e.preventDefault();
        // ... 필수값 및 약관 검증 로직 ...
        // ... 최종 fetch 또는 결제 완료 처리 ...
    });
}

// ---------------------------------------------------------
// 6. 연령별 요금 정책 로직 주입
// ---------------------------------------------------------
// 1. 카운트 변경 및 정책 적용
function changeGuestCount(type, delta) {
    const adultEl = document.getElementById('adultCount');
    const childEl = document.getElementById('childCount');
    const infantEl = document.getElementById('infantCount');
    
    let adult = parseInt(adultEl.value);
    let child = parseInt(childEl.value);
    let infant = parseInt(infantEl.value);
    
    // 최소/최대 제한 체크
    if (type === 'adult') {
        adult = Math.max(1, adult + delta); // 성인은 최소 1명 필수
    } else if (type === 'child') {
        child = Math.max(0, child + delta);
    } else if (type === 'infant') {
        infant = Math.max(0, infant + delta);
    }
    
    // 전체 인원수 합계가 최대 인원을 넘지 않는지 체크
    const total = adult + child + infant;
    if (total > bookingConfig.maxGuestCount) {
        alert(`본 객실의 최대 투숙 인원은 ${bookingConfig.maxGuestCount}명입니다.`);
        return;
    }
    
    // 화면 반영
    adultEl.value = adult;
    childEl.value = child;
    infantEl.value = infant;
    
    // 요금 업데이트 호출
    updateGuestPriceWithPolicy(adult, child, infant);
}

// 2. 연령별 요금 정책 적용 계산기
function updateGuestPriceWithPolicy(adult, child, infant) {
    const base = bookingConfig.baseGuestCount; // 기준 인원 (예: 2명)
    let extraFee = 0;
    
    // 정책: 성인부터 채우고 나머지는 아동이 채움 (유아 무료)
    let remainingBase = base;
    
    // 성인 먼저 기준 인원 차감
    remainingBase -= adult;
    if (remainingBase < 0) {
        extraFee += Math.abs(remainingBase) * bookingConfig.extraGuestPrice; // 성인 추가금 100%
        remainingBase = 0;
    }
    
    // 남은 기준 인원 자리에 아동 차감
    if (remainingBase > 0) {
        remainingBase -= child;
        if (remainingBase < 0) {
            extraFee += Math.abs(remainingBase) * (bookingConfig.extraGuestPrice * 0.5); // 아동은 50%만!
        }
    } else {
        // 이미 성인이 기준인원을 넘었다면 아동은 전원 추가금 (50%)
        extraFee += child * (bookingConfig.extraGuestPrice * 0.5);
    }

    // 화면 갱신
    document.getElementById('summaryGuests').textContent = `성인 ${adult}, 아동 ${child}, 유아 ${infant}`;
    const row = document.getElementById('summaryExtraGuestRow');
    if (row) {
        row.style.display = extraFee > 0 ? 'flex' : 'none';
        document.getElementById('summaryExtraGuest').textContent = `+${extraFee.toLocaleString()}원`;
    }
    
    // 전역 변수 업데이트 후 총액 계산
    bookingConfig.currentExtraFee = extraFee; 
    calculateTotal();
}
