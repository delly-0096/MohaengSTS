<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="자주 묻는 질문" />
<c:set var="pageCss" value="support" />

<%@ include file="../common/header.jsp" %>

<div class="support-page">
    <div class="container">
        <!-- 헤더 -->
        <div class="support-header">
            <h1><i class="bi bi-question-circle me-3"></i>자주 묻는 질문</h1>
            <p>궁금하신 내용을 찾아보세요</p>
        </div>

        <!-- 고객지원 네비게이션 -->
        <div class="support-nav">
            <a href="${pageContext.request.contextPath}/support/faq" class="support-nav-item active">
                <i class="bi bi-question-circle me-2"></i>FAQ
            </a>
            <a href="${pageContext.request.contextPath}/support/notice" class="support-nav-item">
                <i class="bi bi-megaphone me-2"></i>공지사항
            </a>
            <a href="${pageContext.request.contextPath}/support/inquiry" class="support-nav-item">
                <i class="bi bi-chat-dots me-2"></i>1:1 문의
            </a>
        </div>

        <div class="faq-container">
            <!-- 검색 -->
            <div class="faq-search">
                <div class="faq-search-input">
                    <input type="text" placeholder="궁금한 내용을 검색해보세요" id="faqSearch">
                    <button class="btn btn-primary">
                        <i class="bi bi-search me-2"></i>검색
                    </button>
                </div>
            </div>

            <!-- 카테고리 -->
            <div class="faq-categories">
                <button class="faq-category active" data-category="all">전체</button>
                <button class="faq-category" data-category="account">회원/계정</button>
                <button class="faq-category" data-category="schedule">일정/예약</button>
                <button class="faq-category" data-category="payment">결제/환불</button>
                <button class="faq-category" data-category="point">포인트</button>
                <button class="faq-category" data-category="service">서비스 이용</button>
            </div>

            <!-- FAQ 리스트 -->
            <div class="faq-list">
                <!-- 회원/계정 -->
                <div class="faq-item" data-category="account">
                    <div class="faq-question">
                        <div class="faq-question-text">
                            <span class="badge bg-info">회원/계정</span>
                            회원가입은 어떻게 하나요?
                        </div>
                        <i class="bi bi-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>
                            모행 회원가입은 아래 방법으로 진행할 수 있습니다.<br><br>
                            1. 홈페이지 우측 상단 '회원가입' 버튼을 클릭합니다.<br>
                            2. 이메일 또는 소셜 계정(구글, 네이버, 카카오)으로 가입할 수 있습니다.<br>
                            3. 필수 정보를 입력하고 이용약관에 동의하면 가입이 완료됩니다.<br><br>
                            기업회원의 경우 사업자등록번호 인증이 필요합니다.
                        </p>
                    </div>
                </div>

                <div class="faq-item" data-category="account">
                    <div class="faq-question">
                        <div class="faq-question-text">
                            <span class="badge bg-info">회원/계정</span>
                            비밀번호를 잊어버렸어요.
                        </div>
                        <i class="bi bi-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>
                            비밀번호 분실 시 아래 방법으로 재설정할 수 있습니다.<br><br>
                            1. 로그인 페이지에서 '비밀번호 찾기'를 클릭합니다.<br>
                            2. 가입 시 사용한 이메일 주소를 입력합니다.<br>
                            3. 이메일로 전송된 링크를 통해 새 비밀번호를 설정합니다.<br><br>
                            소셜 계정으로 가입한 경우, 해당 소셜 서비스에서 비밀번호를 관리해주세요.
                        </p>
                    </div>
                </div>

                <!-- 일정/예약 -->
                <div class="faq-item" data-category="schedule">
                    <div class="faq-question">
                        <div class="faq-question-text">
                            <span class="badge bg-success">일정/예약</span>
                            AI 일정 추천은 어떻게 이용하나요?
                        </div>
                        <i class="bi bi-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>
                            AI 일정 추천 서비스 이용 방법입니다.<br><br>
                            1. 메인 페이지 또는 '일정 계획' 메뉴에서 여행 정보를 입력합니다.<br>
                            2. 여행 스타일, 선호도 등 몇 가지 질문에 답변합니다.<br>
                            3. AI가 맞춤형 여행 일정을 추천해드립니다.<br>
                            4. 추천된 일정을 바로 사용하거나, 원하는 대로 수정할 수 있습니다.<br><br>
                            추천 일정은 내 일정에 저장하여 언제든 확인할 수 있습니다.
                        </p>
                    </div>
                </div>

                <div class="faq-item" data-category="schedule">
                    <div class="faq-question">
                        <div class="faq-question-text">
                            <span class="badge bg-success">일정/예약</span>
                            저장한 일정을 수정하거나 삭제할 수 있나요?
                        </div>
                        <i class="bi bi-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>
                            네, 저장한 일정은 언제든 수정 및 삭제가 가능합니다.<br><br>
                            1. 마이페이지 > '내 일정' 메뉴로 이동합니다.<br>
                            2. 수정하려는 일정의 '편집' 버튼을 클릭합니다.<br>
                            3. 장소 추가/삭제, 일자 변경 등 원하는 대로 수정합니다.<br>
                            4. 수정 완료 후 '저장' 버튼을 클릭하면 변경사항이 적용됩니다.<br><br>
                            삭제된 일정은 복구할 수 없으니 신중하게 결정해주세요.
                        </p>
                    </div>
                </div>

                <!-- 결제/환불 -->
                <div class="faq-item" data-category="payment">
                    <div class="faq-question">
                        <div class="faq-question-text">
                            <span class="badge bg-warning text-dark">결제/환불</span>
                            결제 방법은 어떤 것이 있나요?
                        </div>
                        <i class="bi bi-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>
                            모행에서 지원하는 결제 방법입니다.<br><br>
                            • 신용/체크카드: 국내 발행 카드 모두 사용 가능<br>
                            • 계좌이체: 실시간 계좌이체 지원<br>
                            • 간편결제: 카카오페이, 네이버페이, 토스페이 등<br>
                            • 포인트: 보유 포인트로 결제 가능 (1,000P 이상)<br><br>
                            결제 수단은 상품에 따라 일부 제한될 수 있습니다.
                        </p>
                    </div>
                </div>

                <div class="faq-item" data-category="payment">
                    <div class="faq-question">
                        <div class="faq-question-text">
                            <span class="badge bg-warning text-dark">결제/환불</span>
                            예약을 취소하고 환불받고 싶어요.
                        </div>
                        <i class="bi bi-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>
                            예약 취소 및 환불 정책입니다.<br><br>
                            <strong>일반 취소/환불 규정:</strong><br>
                            • 이용일 7일 전: 100% 환불<br>
                            • 이용일 3~6일 전: 70% 환불<br>
                            • 이용일 1~2일 전: 50% 환불<br>
                            • 이용일 당일: 환불 불가<br><br>
                            취소는 마이페이지 > '결제 내역'에서 가능하며, 환불은 결제 수단에 따라 3~7 영업일 내 처리됩니다.<br>
                            상품별로 환불 정책이 다를 수 있으니, 예약 전 확인해주세요.
                        </p>
                    </div>
                </div>

                <!-- 포인트 -->
                <div class="faq-item" data-category="point">
                    <div class="faq-question">
                        <div class="faq-question-text">
                            <span class="badge bg-primary">포인트</span>
                            포인트는 어떻게 적립되나요?
                        </div>
                        <i class="bi bi-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>
                            포인트 적립 방법입니다.<br><br>
                            • 상품 결제: 결제 금액의 1~3% 적립<br>
                            • 후기 작성: 500P 적립 (사진 포함 시 추가 적립)<br>
                            • 회원가입: 5,000P 적립<br>
                            • 첫 예약: 2,000P 추가 적립<br>
                            • 이벤트 참여: 이벤트별 상이<br><br>
                            적립된 포인트는 이용 완료 후 자동으로 적립됩니다.
                        </p>
                    </div>
                </div>

                <div class="faq-item" data-category="point">
                    <div class="faq-question">
                        <div class="faq-question-text">
                            <span class="badge bg-primary">포인트</span>
                            포인트 유효기간이 있나요?
                        </div>
                        <i class="bi bi-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>
                            네, 포인트는 적립일로부터 1년간 유효합니다.<br><br>
                            • 유효기간이 지난 포인트는 자동 소멸됩니다.<br>
                            • 마이페이지 > '포인트 내역'에서 소멸 예정 포인트를 확인할 수 있습니다.<br>
                            • 소멸 30일 전에 알림을 보내드립니다.<br><br>
                            포인트는 1,000P 이상 보유 시 결제에 사용할 수 있습니다.
                        </p>
                    </div>
                </div>

                <!-- 서비스 이용 -->
                <div class="faq-item" data-category="service">
                    <div class="faq-question">
                        <div class="faq-question-text">
                            <span class="badge bg-secondary">서비스 이용</span>
                            앱으로도 이용할 수 있나요?
                        </div>
                        <i class="bi bi-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>
                            현재 모행은 모바일 웹으로 서비스되고 있으며, 모바일 앱은 준비 중입니다.<br><br>
                            모바일 브라우저에서 mohaeng.com에 접속하시면 모바일에 최적화된 화면으로 이용하실 수 있습니다.<br><br>
                            앱 출시 시 공지사항과 이메일을 통해 안내드리겠습니다.
                        </p>
                    </div>
                </div>

                <div class="faq-item" data-category="service">
                    <div class="faq-question">
                        <div class="faq-question-text">
                            <span class="badge bg-secondary">서비스 이용</span>
                            챗봇은 24시간 이용 가능한가요?
                        </div>
                        <i class="bi bi-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>
                            네, AI 챗봇은 24시간 365일 이용 가능합니다.<br><br>
                            • 여행지 추천, 일정 관련 질문에 답변해드립니다.<br>
                            • 예약, 결제, 환불 등 복잡한 문의는 1:1 문의를 이용해주세요.<br>
                            • 1:1 문의는 평일 09:00~18:00에 답변드립니다.<br><br>
                            화면 우측 하단의 챗봇 아이콘을 클릭하여 이용해보세요.
                        </p>
                    </div>
                </div>
            </div>

            <!-- 추가 문의 안내 -->
            <div class="text-center mt-5">
                <p class="text-muted mb-3">원하는 답변을 찾지 못하셨나요?</p>
                <a href="${pageContext.request.contextPath}/support/inquiry" class="btn btn-outline btn-lg">
                    <i class="bi bi-chat-dots me-2"></i>1:1 문의하기
                </a>
            </div>
        </div>
    </div>
</div>

<script>
// 카테고리 필터링
document.querySelectorAll('.faq-category').forEach(category => {
    category.addEventListener('click', function() {
        document.querySelectorAll('.faq-category').forEach(c => c.classList.remove('active'));
        this.classList.add('active');

        const cat = this.dataset.category;
        const items = document.querySelectorAll('.faq-item');

        items.forEach(item => {
            if (cat === 'all') {
                item.style.display = 'block';
            } else {
                item.style.display = item.dataset.category === cat ? 'block' : 'none';
            }
        });
    });
});

// FAQ 아코디언
document.querySelectorAll('.faq-question').forEach(question => {
    question.addEventListener('click', function() {
        const item = this.closest('.faq-item');
        const wasActive = item.classList.contains('active');

        // 모든 아이템 닫기
        document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('active'));

        // 클릭한 아이템 토글
        if (!wasActive) {
            item.classList.add('active');
        }
    });
});

// 검색
document.getElementById('faqSearch').addEventListener('input', function() {
    const searchText = this.value.toLowerCase();
    const items = document.querySelectorAll('.faq-item');

    items.forEach(item => {
        const text = item.textContent.toLowerCase();
        item.style.display = text.includes(searchText) ? 'block' : 'none';
    });

    // 카테고리 선택 초기화
    document.querySelectorAll('.faq-category').forEach(c => c.classList.remove('active'));
    document.querySelector('.faq-category[data-category="all"]').classList.add('active');
});
</script>

<c:set var="pageJs" value="support" />
<%@ include file="../common/footer.jsp" %>
