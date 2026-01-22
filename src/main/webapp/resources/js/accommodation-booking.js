/**
 * [숙박 예약 페이지 전용 스크립트]
 * 구성: 설정값, 초기화, 이미지 핸들링, 금액 계산, 동적 UI 생성, 폼 전송
 */

// 1. 전역 설정값 (중앙 관리)
let bookingConfig = {
	unitPrice : 0,
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
	// 설정값 복사 (여기 config에 파라미터로 넘어온 인원수가 담겨져 있어야 함)
    bookingConfig = { ...bookingConfig, ...config };
	
	// 인원수 input 요소 가져오기 (결제 페이지에 있는 ID 확인)
	const adultInput = document.getElementById('adultCount');
	const childInput = document.getElementById('childCount');
	const infantInput = document.getElementById('infantCount');
    
	// 넘어온 값이 있을 경우 화면에 출력
	if (adultInput && bookingConfig.adultCount) {
	        adultInput.value = bookingConfig.adultCount;
	    }
	if (childInput && bookingConfig.childCount) {
	        childInput.value = bookingConfig.childCount;
	    }
	if (infantInput && bookingConfig.infantCount) {
		       infantInput.value = bookingConfig.childCount;
	}
	
	// 세팅된 인원수로 가격 계산기 한 번 돌려주기
	updateGuestPriceWithPolicy(
	        parseInt(adultInput?.value || 2), 
	        parseInt(childInput?.value || 0), 
	        parseInt(infantInput?.value || 0)
	 );
		
    // UI 동적 생성
    setupGuestOptions(config.baseGuestCount, config.maxGuestCount); // 인원수
    setupArrivalTimeOptions(config.checkInTime);                    // 도착시간
    
    // 이벤트 바인딩
    initAdditionalServices(); // 추가옵션 체크박스
	
	// 초기 인원수에 따른 요금을 먼저 계산하고 합계 출력
	const initAdult = parseInt(bookingConfig.currentAdultCount || 2);
	updateGuestPriceWithPolicy(initAdult, 0, 0);
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
    // 1. 현재 화면에 표시된 성인, 아동, 유아 수 직접 긁어오기
    const adult = parseInt(document.getElementById('adultCount')?.value || 2);
    const child = parseInt(document.getElementById('childCount')?.value || 0);
    const infant = parseInt(document.getElementById('infantCount')?.value || 0);
    
    // 2. 인원 추가 요금 가져오기 (updateGuestPriceWithPolicy에서 계산해둔 값)
    // 만약 박당 계산이라면 뒤에 * bookingConfig.nights를 붙여줘!
    const extraGuest = (bookingConfig.currentExtraFee || 0); 

    // 3. 최종 합계 (방값 * 박수 + 인원추가비 + 옵션비)
    const roomTotal = bookingConfig.roomPricePerNight * bookingConfig.nights;
    const total = roomTotal + extraGuest + bookingConfig.addonsTotal;

    // --- 화면에 뿌려주기 ---
    const elPrice = document.getElementById('summaryRoomPrice');
    const elTotal = document.getElementById('totalAmount');
    const elBtn = document.getElementById('payBtnText');
    const elSummaryGuests = document.getElementById('summaryGuests');

    // 사이드바에 현재 선택된 총 인원 구성 보여주기
    if (elSummaryGuests) {
        elSummaryGuests.textContent = `성인 ${adult}, 아동 ${child}, 유아 ${infant}`;
    }

    if (elPrice) elPrice.textContent = `${bookingConfig.roomPricePerNight.toLocaleString()}원 x ${bookingConfig.nights}박`;
    if (elTotal) elTotal.textContent = `${total.toLocaleString()}원`;
    if (elBtn) elBtn.textContent = `${total.toLocaleString()}원 결제하기`;
	
	// 토스 위젯 동기화
	if (widgets) {
	        widgets.setAmount({
	            currency: "KRW",
	            value: total // 방금 계산한 따끈따끈한 총액!
	        });
	        console.log("토스 위젯 금액 업데이트 완료:", total);
	    }
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
    // 1. 필수 및 선택(마케팅) 모든 체크박스를 가져옴
    const allItems = document.querySelectorAll('.agree-item, #marketAgree');
    const agreeAll = document.getElementById('agreeAll');

    allItems.forEach(item => {
        item.addEventListener('change', () => {
            // 현재 체크된 개수와 전체 개수를 비교
            const totalCount = allItems.length;
            const checkedCount = document.querySelectorAll('.agree-item:checked, #marketAgree:checked').length;
            
            // 모두 체크되었다면 '전체 동의' 체크, 하나라도 비면 해제
            if (agreeAll) {
                agreeAll.checked = (totalCount === checkedCount);
            }
        });
    });
}

// 전체 동의 체크박스 클릭 시 실행되는 함수
function toggleAllAgree() {
    const allCheck = document.getElementById('agreeAll');
    const isChecked = allCheck.checked;
    
    // 1. 모든 개별 필수 항목(.agree-item) 체크 상태 변경
    document.querySelectorAll('.agree-item').forEach(item => {
        item.checked = isChecked;
    });
    
    // 2. 마케팅 수신 동의(#agreeMarketing)도 같이 변경
    const marketing = document.getElementById('marketAgree');
    if (marketing) {
        marketing.checked = isChecked;
    }
}

// 최종 폼 제출 (예약하기)
function initBookingForm() {
    const form = document.getElementById('accommodationBookingForm');
    const finalData = collectBookingData();
    if (!form) return;

	form.addEventListener('submit', async function(e) {
	    e.preventDefault();
	    
	    // 데이터 수집
		const finalData = collectBookingData();
		
	    console.table(finalData); // 테이블 형태로 데이터 확인
			
	    // 유효성 검사 (이름, 전화번호 등)
	    if (!finalData.bookerName || !finalData.bookerPhone) {
	        alert("결제자 정보를 입력해주세요!");
	        return;
	    }

		// 필수 약관 체크
		let allAgreed = true;
        document.querySelectorAll('.agree-item').forEach(agree => {
            if (!agree.checked) allAgreed = false;
        });
        if (!allAgreed) { showToast('필수 약관에 동의해주세요.'); return; }
		
		// 세션스토리지에 데이터 백업 (결제 완료 후 꺼내 쓸 용도)
        sessionStorage.setItem("pendingBooking", JSON.stringify(finalData));
		
		const timeStamp = Date.now();
		    try {
				await widgets.requestPayment({
		        orderId: `ACC-${finalData.startDt}-${timeStamp}`, 
		        orderName: `${document.getElementById('accommodationName').textContent} - ${finalData.roomTypeNo}번 객실`,
		        successUrl: window.location.origin + "/product/payment/success", 
		        failUrl: window.location.origin + "/product/payment/fail",
		        customerEmail: finalData.bookerEmail,
		        customerName: finalData.bookerName,
		        customerMobilePhone: finalData.bookerPhone
		        });
		        // 페이지가 성공/실패 URL로 이동하기 때문에 이 이후의 코드는 실행되지 않아!
		    } catch (error) {
		        console.error("결제 요청 에러:", error);
		    }
	})
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
    
    if (type === 'adult') adult = Math.max(1, adult + delta); // 성인은 최소 1명
    else if (type === 'child') child = Math.max(0, child + delta);
    else if (type === 'infant') infant = Math.max(0, infant + delta);
    
    // 최대 인원 체크 (bookingConfig.maxGuestCount 활용)
    if (adult + child + infant > bookingConfig.maxGuestCount) {
        alert(`이 객실은 최대 ${bookingConfig.maxGuestCount}명까지 가능합니다.`);
        return;
    }
    
    adultEl.value = adult;
    childEl.value = child;
    infantEl.value = infant;
    
    // 요금 정책 계산기 호출!
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
            extraFee += Math.floor(Math.abs(remainingBase) * (bookingConfig.extraGuestPrice * 0.75)); // 아동은 70%
        }
    } else {
        // 이미 성인이 기준인원을 넘었다면 아동은 전원 추가금 (50%)
        extraFee += Math.floor(child * (bookingConfig.extraGuestPrice * 0.75));
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

// ---------------------------------------------------------
// 7. 요청사항
// ---------------------------------------------------------
function addQuickRequest(text) {
    // 우리가 새로 정한 ID로 요소를 찾음
    const textarea = document.getElementById('resvRequest');
    
    if (!textarea) return;

    // 이미 내용이 있다면 줄바꿈(\n) 후 추가, 없으면 바로 추가
    if (textarea.value.trim() === "") {
        textarea.value = text;
    } else {
        // 이미 같은 문구가 포함되어 있는지 체크 (중복 방지 센스!)
        if (textarea.value.includes(text)) {
            if(typeof showToast === 'function') showToast('이미 추가된 요청사항입니다.', 'info');
            return;
        }
        textarea.value += '\n' + text;
    }

    // 텍스트 박스에 포커스를 줘서 입력 중임을 알림
    textarea.focus();
}

// ---------------------------------------------------------
// 8. 예약 데이터 수집 함수 (최종 전송용)
// ---------------------------------------------------------
function collectBookingData() {
    // 투숙객 인원수 (세분화된 컬럼용)
    const adultCnt = parseInt(document.getElementById('adultCount').value);
    const childCnt = parseInt(document.getElementById('childCount').value);
    const infantCnt = parseInt(document.getElementById('infantCount').value);
	const nights = bookingConfig.nights;
	const unitPrice = bookingConfig.unitPrice;

    // 추가 옵션 체크박스 수집
    const addons = [];
    document.querySelectorAll('.service-option input:checked').forEach(cb => {
        addons.push(cb.name); // breakfast, spa, parking 등
    });

    // 최종 데이터 객체 생성 (AccResvVO 구조와 일치시켜야 함)
    const bookingData = {
		// 상품 번호
		tripProdNo: bookingConfig.tripProdNo || document.querySelector('input[name="tripProdNo"]')?.value,
        // 기본 정보
        roomTypeNo: bookingConfig.roomNo,           // 객실 번호
        startDt: bookingConfig.startDt,     // 체크인 날짜
        endDt: bookingConfig.endDt,         // 체크아웃 날짜
		
		//숙박 일수
		stayDays: nights,
        
        // 결제자 정보
        bookerName: document.getElementById('bookerName').value,
        bookerPhone: document.getElementById('bookerPhone').value,
        bookerEmail: document.getElementById('bookerEmail').value,

        // 투숙 정보 (리더가 추가한 새 컬럼들!)
        adultCnt: adultCnt,
        childCnt: childCnt,
        infantCnt: infantCnt,
		
        arriveTime: document.getElementById('arrivalTime').value,
        resvRequest: document.getElementById('resvRequest').value, 

        // 금액 정보
		// 판매 단가
		price: unitPrice,
		roomTotalPrice: unitPrice * nights,
		extraFee: bookingConfig.currentExtraFee || 0,
		// 총 결제 예정 금액
		resvPrice: (unitPrice * nights) + 
                   (bookingConfig.currentExtraFee || 0) + 
                   (bookingConfig.addonsTotal || 0),
        
        // 추가 서비스 (String 하나로 합쳐서 보낼지 리스트로 보낼지 결정 필요)
        resvAddons: addons.join(','),
		
		// 약관 동의 상태 수집 (체크되면 Y, 아니면 N)
		stayTermYn: document.getElementById('stayTerm')?.checked ? 'Y' : 'N',
        privacyAgreeYn: document.getElementById('privacyAgree')?.checked ? 'Y' : 'N',
        refundAgreeYn: document.getElementById('refundAgree')?.checked ? 'Y' : 'N',
        marketAgreeYn: document.getElementById('marketAgree')?.checked ? 'Y' : 'N'
    };

    return bookingData;
}