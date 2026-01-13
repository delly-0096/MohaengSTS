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

// ===== 모바일 메뉴 토글 =====
function toggleMobileMenu() {
    const mobileMenu = document.getElementById('mobileMenu');
    const overlay = document.getElementById('mobileMenuOverlay');
    const body = document.body;

    mobileMenu?.classList.toggle('active');
    overlay?.classList.toggle('active');
    body.classList.toggle('menu-open');
}

// ===== 챗봇 관련 기능 =====
let isChatbotOpen = false;

function toggleChatbot() {
    const chatbotWindow = document.getElementById('chatbotWindow');
    const chatbotBtn = document.getElementById('chatbotBtn');

    isChatbotOpen = !isChatbotOpen;

    if (isChatbotOpen) {
        chatbotWindow?.classList.add('active');
        chatbotBtn?.classList.add('active');
        chatbotBtn.innerHTML = '<i class="bi bi-x-lg"></i>';
        document.getElementById('chatbotInput')?.focus();
    } else {
        chatbotWindow?.classList.remove('active');
        chatbotBtn?.classList.remove('active');
        chatbotBtn.innerHTML = '<i class="bi bi-chat-dots-fill"></i>';
    }
}

function handleChatKeypress(event) {
    if (event.key === 'Enter') {
        sendChatMessage();
    }
}

function sendChatMessage() {
    const input = document.getElementById('chatbotInput');
    const messagesContainer = document.getElementById('chatbotMessages');
    const message = input?.value.trim();

    if (!message) return;

    // 사용자 메시지 추가
    const userMessage = document.createElement('div');
    userMessage.className = 'chat-message user';
    userMessage.textContent = message;
    messagesContainer?.appendChild(userMessage);

    // 입력창 초기화
    input.value = '';

    // 스크롤 하단으로
    messagesContainer.scrollTop = messagesContainer.scrollHeight;

    // AI 응답 시뮬레이션 (실제 구현 시 API 호출)
    setTimeout(() => {
        const botMessage = document.createElement('div');
        botMessage.className = 'chat-message bot';
        botMessage.textContent = getChatbotResponse(message);
        messagesContainer?.appendChild(botMessage);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }, 1000);
}

function getChatbotResponse(message) {
    // 간단한 키워드 기반 응답 (실제 구현 시 AI API 연동)
    const lowerMessage = message.toLowerCase();

    if (lowerMessage.includes('일정') || lowerMessage.includes('계획')) {
        return '여행 일정 계획이 필요하시군요! 상단 메뉴의 "일정 계획" > "일정 검색"에서 AI 맞춤 일정 추천을 받아보실 수 있습니다.';
    } else if (lowerMessage.includes('항공') || lowerMessage.includes('비행기')) {
        return '항공권 검색은 "관광 상품" > "항공" 메뉴에서 가능합니다. 출발지, 도착지, 날짜를 입력하시면 최저가 항공권을 찾아드립니다.';
    } else if (lowerMessage.includes('숙소') || lowerMessage.includes('호텔')) {
        return '숙박 검색은 "관광 상품" > "숙박" 메뉴에서 가능합니다. 원하시는 지역과 날짜를 입력해주세요.';
    } else if (lowerMessage.includes('투어') || lowerMessage.includes('체험')) {
        return '다양한 투어와 체험 상품은 "관광 상품" > "투어/체험/티켓" 메뉴에서 확인하실 수 있습니다.';
    } else if (lowerMessage.includes('회원가입') || lowerMessage.includes('가입')) {
        return '회원가입은 우측 상단의 "회원가입" 버튼을 클릭하시면 됩니다. 소셜 로그인(구글, 네이버)도 지원합니다!';
    } else if (lowerMessage.includes('안녕') || lowerMessage.includes('반가')) {
        return '안녕하세요! 모행 AI 챗봇입니다. 여행 계획, 항공권, 숙박, 투어 등 무엇이든 물어보세요!';
    } else {
        return '죄송합니다. 정확한 답변을 드리기 어렵네요. 더 자세한 내용은 FAQ를 확인하시거나 1:1 문의를 이용해주세요.';
    }
}

// ===== Flatpickr 날짜 선택기 초기화 =====
function initFlatpickr() {
    // 날짜 선택기 기본 설정
    const dateInputs = document.querySelectorAll('.date-picker');
    dateInputs.forEach(input => {
        flatpickr(input, {
            locale: 'ko',
            dateFormat: 'Y-m-d',
            minDate: 'today',
            disableMobile: true
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
            disableMobile: true
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

console.log('모행(MOHAENG) Common JS Loaded');
