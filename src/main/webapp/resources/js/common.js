/**
 * 모행(MOHAENG) - 공통 JavaScript
 * 개인 맞춤형 관광 서비스 웹 플랫폼
 */

// ===== 전역 변수 =====
const contextPath = document.querySelector('meta[name="context-path"]')?.content || '';

// ===== 문서 로드 완료 시 실행 =====
document.addEventListener('DOMContentLoaded', function() {
    initHeader();
    initFlatpickr();
    initAnimations();
    initTravelTypeTabs();
    initChatbotVisibility();
    initLocationAutocomplete();
});

// ===== 헤더 관련 기능 =====
function initHeader() {
    const header = document.getElementById('header');

    // 스크롤 시 헤더 스타일 변경
    window.addEventListener('scroll', function() {
        if (window.scrollY > 50) {
            header?.classList.add('scrolled');
        } else {
            header?.classList.remove('scrolled');
        }
    });
}

// ====== 투명 헤더 상태 부여 ======
const header = document.getElementById("header");

function updateHeaderState() {
  if (window.scrollY === 0) {
    header.classList.add("header--transparent");
    header.classList.remove("header--solid");
  } else {
    header.classList.remove("header--transparent");
    header.classList.add("header--solid");
  }
}

// 🔥 최초 로드 시 한 번 실행
document.addEventListener("DOMContentLoaded", updateHeaderState);

// 스크롤 시 계속 갱신
window.addEventListener("scroll", updateHeaderState);


// ===== 사이드 메뉴 토글 =====
function toggleSideMenu() {
    const sideMenu = document.getElementById('sideMenu');
    const overlay = document.getElementById('sideMenuOverlay');
    const hamburgerBtn = document.getElementById('hamburgerBtn');
    const body = document.body;

    sideMenu?.classList.toggle('active');
    overlay?.classList.toggle('active');
    hamburgerBtn?.classList.toggle('active');
    body.classList.toggle('menu-open');
}

// ===== 사이드 메뉴 섹션 토글 =====
function toggleMenuSection(element) {
    const section = element.closest('.side-menu-section');

    // 다른 열린 섹션 닫기 (아코디언 효과)
    const allSections = document.querySelectorAll('.side-menu-section');
    allSections.forEach(sec => {
        if (sec !== section && sec.classList.contains('open')) {
            sec.classList.remove('open');
        }
    });

    // 현재 섹션 토글
    section?.classList.toggle('open');
}

// ===== 챗봇 관련 기능 =====
let isChatbotOpen = false;

// 대화 내용 저장
function saveChatHistory() {
    const messagesContainer = document.getElementById('chatbotMessages');
    if (messagesContainer) {
        const key = 'chatbotHistory_' + (typeof chatbotUserKey !== 'undefined' ? chatbotUserKey : 'guest');
        sessionStorage.setItem(key, messagesContainer.innerHTML);
    }
}

// 대화 내용 불러오기
function loadChatHistory() {
    const messagesContainer = document.getElementById('chatbotMessages');
    const key = 'chatbotHistory_' + (typeof chatbotUserKey !== 'undefined' ? chatbotUserKey : 'guest');
    const savedHistory = sessionStorage.getItem(key);
    
    if (messagesContainer && savedHistory) {
        messagesContainer.innerHTML = savedHistory;
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
        return true;
    }
    return false;
}

// 대화 내용 삭제
function clearChatHistory() {
    const key = 'chatbotHistory_' + (typeof chatbotUserKey !== 'undefined' ? chatbotUserKey : 'guest');
    sessionStorage.removeItem(key);
    const messagesContainer = document.getElementById('chatbotMessages');
    if (messagesContainer) {
        messagesContainer.innerHTML = '';
    }
    addBotMessage('안녕하세요! 모행 AI 챗봇입니다. 🤖<br>여행에 관해 무엇이든 물어보세요!');
}

// ===== AI 챗봇 기능 =====
function initFloatingChatbot() {
    const messagesContainer = document.getElementById('chatbotMessages');
    if (!messagesContainer) return;

	// 저장된 대화가 있으면 불러오기, 없으면 환영 메시지
	const hasHistory = loadChatHistory();

	if (!hasHistory) {
	    messagesContainer.innerHTML = '';
	    addBotMessage('안녕하세요! 모행 AI 챗봇입니다. 🤖<br>여행에 관해 무엇이든 물어보세요!');
	}
}

async function sendChatMessage() {
    const input = document.getElementById('chatbotInput');
    const message = input.value.trim();
    
    if (!message) return;
    
    // 사용자 메시지 표시
    addUserMessage(message);
    input.value = '';
    
    // 로딩 표시
    showTypingIndicator();
    
    try {
        const response = await fetch(contextPath + '/api/chatbot', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ message: message })
        });
        
        const data = await response.json();
        
        // 로딩 제거
        hideTypingIndicator();
        
        // 봇 응답 표시
        addBotMessage(data.message);
        
        // 페이지 이동이 필요한 경우
        if (data.redirectUrl) {
            addNavigateButton(data.redirectUrl);
        }
        
    } catch (error) {
        console.error('Error:', error);
        hideTypingIndicator();
        addBotMessage('죄송해요, 오류가 발생했어요. 다시 시도해 주세요.');
    }
}

function addUserMessage(message) {
    const messagesContainer = document.getElementById('chatbotMessages');
    const messageDiv = document.createElement('div');
    messageDiv.className = 'chat-message user';
    messageDiv.textContent = message;
    messagesContainer.appendChild(messageDiv);
    scrollToBottom();

	// 대화 내용 저장
	saveChatHistory();
}

function addBotMessage(message) {
    const messagesContainer = document.getElementById('chatbotMessages');
    const messageDiv = document.createElement('div');
    messageDiv.className = 'chat-message bot';
    messageDiv.innerHTML = message;
    messagesContainer.appendChild(messageDiv);
    scrollToBottom();

	// 대화 내용 저장
	saveChatHistory();
}

function addNavigateButton(url) {
    const messagesContainer = document.getElementById('chatbotMessages');
    const btnDiv = document.createElement('div');
    btnDiv.className = 'chat-navigate-btn';
    btnDiv.innerHTML = `
        <button onclick="window.location.href='${contextPath}${url}'">
            <i class="bi bi-arrow-right-circle"></i> 페이지로 이동
        </button>
    `;
    messagesContainer.appendChild(btnDiv);
    scrollToBottom();

	// 대화 내용 저장
	saveChatHistory();
}

function showTypingIndicator() {
    const messagesContainer = document.getElementById('chatbotMessages');
    const typingDiv = document.createElement('div');
    typingDiv.id = 'typingIndicator';
    typingDiv.className = 'chat-message bot typing-indicator';
    typingDiv.innerHTML = '<span></span><span></span><span></span>';
    messagesContainer.appendChild(typingDiv);
    scrollToBottom();
}

function hideTypingIndicator() {
    const typing = document.getElementById('typingIndicator');
    if (typing) typing.remove();
}

function scrollToBottom() {
    const messagesContainer = document.getElementById('chatbotMessages');
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

function toggleChatbot() {
    const chatbotWindow = document.getElementById('chatbotWindow');
    const chatbotBtn = document.getElementById('chatbotBtn');

    isChatbotOpen = !isChatbotOpen;

    if (isChatbotOpen) {
        chatbotWindow?.classList.add('active');
        chatbotBtn?.classList.add('active');
        chatbotBtn.innerHTML = '<i class="bi bi-x-lg"></i>';
        initFloatingChatbot();
    } else {
        chatbotWindow?.classList.remove('active');
        chatbotBtn?.classList.remove('active');
        chatbotBtn.innerHTML = '<i class="bi bi-chat-dots-fill"></i>';
    }
}

// ===== 여행 유형 탭 초기화 =====
function initTravelTypeTabs() {
    const tabs = document.querySelectorAll('.travel-type-tab');
    const searchFormContainer = document.querySelector('.search-form-container');

    if (!tabs.length || !searchFormContainer) return;

    tabs.forEach(tab => {
        tab.addEventListener('click', function() {
            // 모든 탭 비활성화
            tabs.forEach(t => t.classList.remove('active'));
            // 현재 탭 활성화
            this.classList.add('active');

            // 국내여행 테마 적용
            searchFormContainer.classList.remove('theme-domestic');
            searchFormContainer.classList.add('theme-domestic');
        });
    });
}

// ===== 지역 자동완성 =====
const locationData = {
    domestic: [
        { name: '서울', sub: '서울특별시', code: 'SEL' },
        { name: '부산', sub: '부산광역시', code: 'PUS' },
        { name: '인천', sub: '인천광역시', code: 'ICN' },
        { name: '대구', sub: '대구광역시', code: 'TAE' },
        { name: '대전', sub: '대전광역시', code: 'DJJ' },
        { name: '광주', sub: '광주광역시', code: 'KWJ' },
        { name: '울산', sub: '울산광역시', code: 'USN' },
        { name: '세종', sub: '세종특별자치시', code: 'SEJ' },
        { name: '제주', sub: '제주특별자치도', code: 'CJU' },
        { name: '경주', sub: '경상북도', code: 'GJU' },
        { name: '강릉', sub: '강원도', code: 'GNE' },
        { name: '속초', sub: '강원도', code: 'SOK' },
        { name: '춘천', sub: '강원도', code: 'CHC' },
        { name: '여수', sub: '전라남도', code: 'YSU' },
        { name: '순천', sub: '전라남도', code: 'SCH' },
        { name: '목포', sub: '전라남도', code: 'MKP' },
        { name: '전주', sub: '전라북도', code: 'JJU' },
        { name: '군산', sub: '전라북도', code: 'KUS' },
        { name: '안동', sub: '경상북도', code: 'ADG' },
        { name: '포항', sub: '경상북도', code: 'POH' },
        { name: '통영', sub: '경상남도', code: 'TYG' },
        { name: '거제', sub: '경상남도', code: 'GEJ' },
        { name: '창원', sub: '경상남도', code: 'CHW' },
        { name: '수원', sub: '경기도', code: 'SUW' },
        { name: '용인', sub: '경기도', code: 'YOI' },
        { name: '가평', sub: '경기도', code: 'GPY' },
        { name: '파주', sub: '경기도', code: 'PJU' },
        { name: '양양', sub: '강원도', code: 'YNY' },
        { name: '평창', sub: '강원도', code: 'PCH' },
        { name: '태안', sub: '충청남도', code: 'TAN' },
        { name: '보령', sub: '충청남도', code: 'BRG' },
        { name: '단양', sub: '충청북도', code: 'DNY' },
        { name: '충주', sub: '충청북도', code: 'CJJ' }
    ]
};

function initLocationAutocomplete() {
    const inputs = document.querySelectorAll('.location-autocomplete');

    inputs.forEach(input => {
        const dropdown = input.nextElementSibling;
        if (!dropdown || !dropdown.classList.contains('autocomplete-dropdown')) return;

        let selectedIndex = -1;

        // 입력 이벤트
        input.addEventListener('input', function() {
            const query = this.value.trim();
            showAutocomplete(dropdown, query, getCurrentTravelType());
            selectedIndex = -1;
        });

        // 포커스 이벤트
        input.addEventListener('focus', function() {
            const query = this.value.trim();
            showAutocomplete(dropdown, query, getCurrentTravelType());
        });

        // 키보드 네비게이션
        input.addEventListener('keydown', function(e) {
            const items = dropdown.querySelectorAll('.autocomplete-item');

            if (e.key === 'ArrowDown') {
                e.preventDefault();
                selectedIndex = Math.min(selectedIndex + 1, items.length - 1);
                updateSelection(items, selectedIndex);
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                selectedIndex = Math.max(selectedIndex - 1, 0);
                updateSelection(items, selectedIndex);
            } else if (e.key === 'Enter' && selectedIndex >= 0) {
                e.preventDefault();
                items[selectedIndex]?.click();
            } else if (e.key === 'Escape') {
                hideAutocomplete(dropdown);
            }
        });

        // 외부 클릭 시 닫기
        document.addEventListener('click', function(e) {
            if (!input.contains(e.target) && !dropdown.contains(e.target)) {
                hideAutocomplete(dropdown);
            }
        });
    });
}

function getCurrentTravelType() {
    const activeTab = document.querySelector('.travel-type-tab.active');
    return activeTab?.dataset.type || 'all';
}

function showAutocomplete(dropdown, query, travelType) {
    // 국내 여행지만 필터링
    const results = filterLocations(locationData.domestic, query, false);
    renderAutocomplete(dropdown, results, query, 'domestic');
}

function filterLocations(locations, query, isOverseas) {
    if (!query) {
        // 빈 쿼리일 때는 인기 지역 표시 (상위 8개)
        return locations.slice(0, 8).map(loc => ({ ...loc, isOverseas }));
    }

    const lowerQuery = query.toLowerCase();
    return locations
        .filter(loc =>
            loc.name.toLowerCase().includes(lowerQuery) ||
            loc.sub.toLowerCase().includes(lowerQuery)
        )
        .slice(0, 10)
        .map(loc => ({ ...loc, isOverseas }));
}

function renderAutocomplete(dropdown, results, query, travelType) {
    let html = '';

    if (results.length > 0) {
        html = results.map(loc => createItemHtml(loc, query)).join('');
    } else {
        html = createEmptyHtml(query);
    }

    dropdown.innerHTML = html;
    dropdown.classList.add('active');

    // 클릭 이벤트 바인딩
    dropdown.querySelectorAll('.autocomplete-item').forEach(item => {
        item.addEventListener('click', function() {
            const input = dropdown.previousElementSibling;
            input.value = this.dataset.name;
            hideAutocomplete(dropdown);
        });
    });
}

function createItemHtml(location, query) {
    const highlightedName = highlightMatch(location.name, query);

    return `
        <div class="autocomplete-item" data-name="${location.name}" data-code="${location.code}">
            <div class="autocomplete-item-icon">
                <i class="bi bi-geo-alt"></i>
            </div>
            <div class="autocomplete-item-info">
                <div class="autocomplete-item-name">${highlightedName}</div>
                <div class="autocomplete-item-sub">${location.sub}</div>
            </div>
        </div>
    `;
}

function createEmptyHtml(query) {
    return `
        <div class="autocomplete-empty">
            <i class="bi bi-search"></i>
            "${query}"에 대한 검색 결과가 없습니다.
        </div>
    `;
}

function highlightMatch(text, query) {
    if (!query) return text;
    const regex = new RegExp(`(${escapeRegex(query)})`, 'gi');
    return text.replace(regex, '<mark>$1</mark>');
}

function escapeRegex(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function updateSelection(items, index) {
    items.forEach((item, i) => {
        item.classList.toggle('selected', i === index);
    });

    // 선택된 항목으로 스크롤
    if (items[index]) {
        items[index].scrollIntoView({ block: 'nearest' });
    }
}

function hideAutocomplete(dropdown) {
    dropdown.classList.remove('active');
}

// ===== 챗봇 가시성 관리 =====
let isChatbotHidden = sessionStorage.getItem('chatbotHidden') === 'true';

function initChatbotVisibility() {
    const chatbotFloating = document.querySelector('.chatbot-floating');
    if (!chatbotFloating) return;
	
    // 저장된 상태 복원
    if (isChatbotHidden) {
        chatbotFloating.classList.add('hidden');
    }
}

function hideChatbot() {
    const chatbotFloating = document.querySelector('.chatbot-floating');

    // 챗봇 창이 열려있으면 먼저 닫기
    if (isChatbotOpen) {
        toggleChatbot();
    }

    chatbotFloating?.classList.add('hidden');
    isChatbotHidden = true;
    sessionStorage.setItem('chatbotHidden', 'true');
}

function showChatbotFromMenu() {
    // 챗봇 플로팅 버튼 복원 (초기 상태)
    const chatbotFloating = document.querySelector('.chatbot-floating');
    chatbotFloating?.classList.remove('hidden');
    isChatbotHidden = false;
    sessionStorage.setItem('chatbotHidden', 'false');

    // 챗봇 창 열기
    if (!isChatbotOpen) {
        toggleChatbot();
    }
}

// ===== Flatpickr 날짜 선택기 초기화 =====
function initFlatpickr() {
    // 날짜 선택기 기본 설정 (미래 날짜용 - 예약일 등)
    const dateInputs = document.querySelectorAll('.date-picker');
    dateInputs.forEach(input => {
        flatpickr(input, {
            locale: 'ko',
            dateFormat: 'Y-m-d',
            minDate: 'today',
            disableMobile: true,
            position: 'below'
        });
    });

    // 날짜 범위 선택기
    const dateRangeInputs = document.querySelectorAll('.date-range-picker');
    dateRangeInputs.forEach(input => {
        flatpickr(input, {
            locale: 'ko',
            dateFormat: 'Y-m-d',
            minDate: 'today',
            mode: 'range',
            disableMobile: true,
            position: 'below',
            static: false,
            appendTo: undefined
        });
    });

    // 생년월일 선택기 (과거 날짜용)
    const birthdateInputs = document.querySelectorAll('.birthdate-picker');
    birthdateInputs.forEach(input => {
        flatpickr(input, {
            locale: 'ko',
            dateFormat: 'Y-m-d',
            maxDate: 'today',
            disableMobile: true,
            position: 'below',
            defaultDate: '1990-01-01'
        });
    });
}

// ===== 스크롤 애니메이션 =====
function initAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-fade-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.animate-on-scroll').forEach(el => {
        observer.observe(el);
    });
}

// ===== 유틸리티 함수 =====

// 천 단위 콤마 포맷
function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

// 날짜 포맷 (YYYY-MM-DD)
function formatDate(date) {
    const d = new Date(date);
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// 날짜 차이 계산 (일 단위)
function getDaysDiff(startDate, endDate) {
    const start = new Date(startDate);
    const end = new Date(endDate);
    const diffTime = Math.abs(end - start);
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
}

// 로그인 필요 체크 및 리다이렉트
function requireLogin(returnUrl) {
    const isLoggedIn = document.body.dataset.loggedIn === 'true';

    if (!isLoggedIn) {
        const url = returnUrl || window.location.href;
        sessionStorage.setItem('returnUrl', url);
        showLoginAlert();
        return false;
    }
    return true;
}

// 로그인 필요 알림
function showLoginAlert() {
    if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
        window.location.href = contextPath + '/member/login';
    }
}

// 토스트 메시지 표시
function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.className = `toast-message toast-${type}`;
    toast.innerHTML = `
        <i class="bi bi-${getToastIcon(type)} me-2"></i>
        <span>${message}</span>
    `;

    document.body.appendChild(toast);

    setTimeout(() => toast.classList.add('show'), 10);
    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

function getToastIcon(type) {
    const icons = {
        success: 'check-circle-fill',
        error: 'x-circle-fill',
        warning: 'exclamation-triangle-fill',
        info: 'info-circle-fill'
    };
    return icons[type] || icons.info;
}

// 로딩 스피너 표시/숨김
function showLoading() {
    const loader = document.createElement('div');
    loader.id = 'globalLoader';
    loader.className = 'global-loader';
    loader.innerHTML = `
        <div class="loader-spinner">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2">잠시만 기다려주세요...</p>
        </div>
    `;
    document.body.appendChild(loader);
}

function hideLoading() {
    const loader = document.getElementById('globalLoader');
    if (loader) {
        loader.remove();
    }
}

// 확인 모달
function showConfirm(message, onConfirm, onCancel) {
    const modal = document.createElement('div');
    modal.className = 'confirm-modal-overlay';
    modal.innerHTML = `
        <div class="confirm-modal">
            <div class="confirm-modal-body">
                <i class="bi bi-question-circle text-primary mb-3" style="font-size: 48px;"></i>
                <p>${message}</p>
            </div>
            <div class="confirm-modal-footer">
                <button class="btn btn-outline" onclick="closeConfirm(false)">취소</button>
                <button class="btn btn-primary" onclick="closeConfirm(true)">확인</button>
            </div>
        </div>
    `;

    document.body.appendChild(modal);

    window.confirmCallback = { onConfirm, onCancel };
}

function closeConfirm(confirmed) {
    const modal = document.querySelector('.confirm-modal-overlay');
    if (modal) {
        modal.remove();
    }

    if (confirmed && window.confirmCallback?.onConfirm) {
        window.confirmCallback.onConfirm();
    } else if (!confirmed && window.confirmCallback?.onCancel) {
        window.confirmCallback.onCancel();
    }

    window.confirmCallback = null;
}

// 북마크 토글
function toggleBookmark(itemType, itemId, button) {
    if (!requireLogin()) return;

    const isBookmarked = button.classList.contains('active');

    fetch(`${contextPath}/api/bookmark/${itemType}/${itemId}`, {
        method: isBookmarked ? 'DELETE' : 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            button.classList.toggle('active');
            const icon = button.querySelector('i');
            if (icon) {
                icon.className = isBookmarked ? 'bi bi-bookmark' : 'bi bi-bookmark-fill';
            }
            showToast(isBookmarked ? '북마크가 해제되었습니다.' : '북마크에 추가되었습니다.', 'success');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('오류가 발생했습니다.', 'error');
    });
}

// 좋아요 토글
function toggleLike(itemType, itemId, button) {
    if (!requireLogin()) return;

    const isLiked = button.classList.contains('active');

    fetch(`${contextPath}/api/like/${itemType}/${itemId}`, {
        method: isLiked ? 'DELETE' : 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            button.classList.toggle('active');
            const icon = button.querySelector('i');
            const countSpan = button.querySelector('.like-count');

            if (icon) {
                icon.className = isLiked ? 'bi bi-heart' : 'bi bi-heart-fill';
            }
            if (countSpan) {
                countSpan.textContent = data.likeCount;
            }
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('오류가 발생했습니다.', 'error');
    });
}

// ===== AJAX 공통 함수 =====
function ajaxGet(url, callback) {
    fetch(contextPath + url)
        .then(response => response.json())
        .then(data => callback(null, data))
        .catch(error => callback(error, null));
}

function ajaxPost(url, data, callback) {
    fetch(contextPath + url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => callback(null, data))
    .catch(error => callback(error, null));
}

// ===== 폼 유효성 검사 =====
function validateForm(formElement) {
    const inputs = formElement.querySelectorAll('[required]');
    let isValid = true;

    inputs.forEach(input => {
        if (!input.value.trim()) {
            isValid = false;
            input.classList.add('is-invalid');
        } else {
            input.classList.remove('is-invalid');
        }
    });

    return isValid;
}

// 이메일 유효성 검사
function isValidEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

// 전화번호 유효성 검사
function isValidPhone(phone) {
    const re = /^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$/;
    return re.test(phone.replace(/-/g, ''));
}

// 비밀번호 강도 체크
function checkPasswordStrength(password) {
    let strength = 0;

    if (password.length >= 8) strength++;
    if (password.match(/[a-z]/)) strength++;
    if (password.match(/[A-Z]/)) strength++;
    if (password.match(/[0-9]/)) strength++;
    if (password.match(/[^a-zA-Z0-9]/)) strength++;

    return strength; // 0-5 점
}

// ===== 디바운스 함수 =====
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// ===== 스로틀 함수 =====
function throttle(func, limit) {
    let inThrottle;
    return function(...args) {
        if (!inThrottle) {
            func.apply(this, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

// ===== 이미지 미리보기 =====
function previewImage(input, previewElement) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            previewElement.src = e.target.result;
            previewElement.style.display = 'block';
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// ===== 클립보드 복사 =====
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        showToast('클립보드에 복사되었습니다.', 'success');
    }).catch(err => {
        console.error('Failed to copy:', err);
        showToast('복사에 실패했습니다.', 'error');
    });
}

// ===== URL 파라미터 가져오기 =====
function getUrlParameter(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

// ===== 페이지 맨 위로 스크롤 =====
function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
}

// ===== 신고 기능 =====
var reportData = {
    type: '', // product, post, comment, chatroom
    targetId: '',
    targetTitle: ''
};

// 신고 모달 열기
function openReportModal(type, targetId, targetTitle) {
    // 로그인 체크
    if (typeof isLoggedIn !== 'undefined' && !isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = contextPath + '/member/login';
        }
        return;
    }

    reportData.type = type;
    reportData.targetId = targetId;
    reportData.targetTitle = targetTitle || '';

    // 신고 대상 정보 표시
    var targetLabel = '';
    switch(type) {
        case 'product': targetLabel = '신고 대상 상품'; break;
        case 'post': targetLabel = '신고 대상 게시글'; break;
        case 'comment': targetLabel = '신고 대상 댓글'; break;
        case 'chatroom': targetLabel = '신고 대상 채팅방'; break;
        default: targetLabel = '신고 대상';
    }

    var targetLabelEl = document.getElementById('reportTargetLabel');
    var targetContentEl = document.getElementById('reportTargetContent');
    if (targetLabelEl) targetLabelEl.textContent = targetLabel;
    if (targetContentEl) targetContentEl.textContent = targetTitle || '(내용 없음)';

    // 폼 초기화
    var form = document.getElementById('reportForm');
    if (form) form.reset();

    // 선택 상태 초기화
    document.querySelectorAll('.report-reason-item').forEach(function(item) {
        item.classList.remove('selected');
    });

    // 모달 열기
    var modal = document.getElementById('reportModalOverlay');
    if (modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }
}

// 신고 모달 닫기
function closeReportModal() {
    var modal = document.getElementById('reportModalOverlay');
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = '';
    }
}

// 신고 사유 선택
function selectReportReason(element) {
    document.querySelectorAll('.report-reason-item').forEach(function(item) {
        item.classList.remove('selected');
    });
    element.classList.add('selected');

    var radio = element.querySelector('input[type="radio"]');
    if (radio) radio.checked = true;
}

// 신고 제출
function submitReport() {
    var selectedReason = document.querySelector('input[name="reportReason"]:checked');
    var detailText = document.getElementById('reportDetail')?.value?.trim() || '';

    if (!selectedReason) {
        showToast('신고 사유를 선택해주세요.', 'warning');
        return;
    }

    var reason = selectedReason.value;

    // 기타 사유인 경우 상세 내용 필수
    if (reason === 'other' && !detailText) {
        showToast('기타 사유를 입력해주세요.', 'warning');
        document.getElementById('reportDetail').focus();
        return;
    }

    // 신고 데이터
    var submitData = {
        type: reportData.type,
        targetId: reportData.targetId,
        reason: reason,
        detail: detailText
    };

    console.log('신고 데이터:', submitData);

    // TODO: 실제 API 호출로 변경
    // 성공 시뮬레이션
    closeReportModal();
    showToast('신고가 접수되었습니다. 검토 후 조치하겠습니다.', 'success');
}

// 신고 모달 초기화 (문서 로드 시)
document.addEventListener('DOMContentLoaded', function() {
    // 오버레이 클릭 시 닫기
    var overlay = document.getElementById('reportModalOverlay');
    if (overlay) {
        overlay.addEventListener('click', function(e) {
            if (e.target === overlay) {
                closeReportModal();
            }
        });
    }

    // ESC 키로 닫기
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeReportModal();
        }
    });
});

console.log('모행(MOHAENG) Common JS Loaded');
