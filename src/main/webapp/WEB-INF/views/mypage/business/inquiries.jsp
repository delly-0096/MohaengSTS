<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="운영자 문의" />
<c:set var="pageCss" value="mypage" />

<%@ include file="../../common/header.jsp" %>

<div class="mypage business-mypage">
    <div class="container">
        <div class="mypage-container no-sidebar">
            <!-- 메인 콘텐츠 -->
            <div class="mypage-content full-width">
                <div class="mypage-header">
                    <h1>운영자 문의</h1>
                    <p>1:1 문의 내역을 확인하세요</p>
                </div>

                <!-- 통계 카드 -->
                <div class="stats-grid">
                    <div class="stat-card primary">
                        <div class="stat-icon"><i class="bi bi-chat-dots"></i></div>
                        <div class="stat-value">3</div>
                        <div class="stat-label">전체 문의</div>
                    </div>
                    <div class="stat-card secondary">
                        <div class="stat-icon"><i class="bi bi-check-circle"></i></div>
                        <div class="stat-value">2</div>
                        <div class="stat-label">답변 완료</div>
                    </div>
                    <div class="stat-card accent">
                        <div class="stat-icon"><i class="bi bi-hourglass-split"></i></div>
                        <div class="stat-value">1</div>
                        <div class="stat-label">답변 대기</div>
                    </div>
                </div>

                <!-- 탭 -->
                <div class="mypage-tabs">
                    <button class="mypage-tab active" data-filter="all">전체</button>
                    <button class="mypage-tab" data-filter="answered">답변 완료</button>
                    <button class="mypage-tab" data-filter="waiting">답변 대기</button>
                    <a href="${pageContext.request.contextPath}/support/inquiry#write" class="btn btn-primary btn-sm ms-auto">
                        <i class="bi bi-pencil me-1"></i>문의 작성
                    </a>
                </div>

                <!-- 문의 내역 -->
                <div class="content-section">
                    <div class="section-header">
                        <h3><i class="bi bi-list-ul"></i> 문의 내역</h3>
                        <div class="d-flex gap-2">
                            <select class="form-select form-select-sm" style="width: 120px;">
                                <option>최근 3개월</option>
                                <option>최근 6개월</option>
                                <option>최근 1년</option>
                                <option>전체</option>
                            </select>
                        </div>
                    </div>

                    <div class="inquiry-list-mypage">
                        <!-- 문의 1 - 답변 완료 -->
                        <div class="inquiry-item-mypage" data-status="answered">
                            <div class="inquiry-item-header-mypage" onclick="toggleInquiry(this)">
                                <div class="inquiry-info">
                                    <span class="inquiry-category">정산/결제</span>
                                    <h4 class="inquiry-title">정산 금액 확인 요청드립니다.</h4>
                                    <div class="inquiry-meta">
                                        <span>2024.03.10</span>
                                    </div>
                                </div>
                                <div class="inquiry-status-wrap">
                                    <span class="inquiry-status answered">답변완료</span>
                                    <i class="bi bi-chevron-down"></i>
                                </div>
                            </div>
                            <div class="inquiry-body-mypage">
                                <div class="inquiry-question">
                                    <div class="inquiry-label">문의 내용</div>
                                    <p>2월 정산 금액이 예상보다 적게 입금된 것 같습니다. 확인 부탁드립니다.</p>
                                </div>
                                <div class="inquiry-answer-box">
                                    <div class="inquiry-label">답변 <span class="answer-date">2024.03.11 10:15</span></div>
                                    <p>
                                        안녕하세요, 모행입니다.<br><br>
                                        2월 정산 내역 확인했습니다. 취소된 예약 2건(총 85,000원)이 차감되어 정산되었습니다.<br>
                                        상세 내역은 마이페이지 > 매출 집계에서 확인하실 수 있습니다.<br><br>
                                        추가 문의사항이 있으시면 말씀해주세요.<br>
                                        감사합니다.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- 문의 2 - 답변 대기 -->
                        <div class="inquiry-item-mypage" data-status="waiting">
                            <div class="inquiry-item-header-mypage" onclick="toggleInquiry(this)">
                                <div class="inquiry-info">
                                    <span class="inquiry-category">상품 등록</span>
                                    <h4 class="inquiry-title">상품 이미지 업로드 오류</h4>
                                    <div class="inquiry-meta">
                                        <span>2024.03.14</span>
                                    </div>
                                </div>
                                <div class="inquiry-status-wrap">
                                    <span class="inquiry-status waiting">답변대기</span>
                                    <i class="bi bi-chevron-down"></i>
                                </div>
                            </div>
                            <div class="inquiry-body-mypage">
                                <div class="inquiry-question">
                                    <div class="inquiry-label">문의 내용</div>
                                    <p>신규 상품 등록 시 이미지 업로드가 계속 실패합니다. 확인 부탁드립니다.</p>
                                </div>
                            </div>
                        </div>

                        <!-- 문의 3 - 답변 완료 -->
                        <div class="inquiry-item-mypage" data-status="answered">
                            <div class="inquiry-item-header-mypage" onclick="toggleInquiry(this)">
                                <div class="inquiry-info">
                                    <span class="inquiry-category">서비스 이용</span>
                                    <h4 class="inquiry-title">상품 노출 순서 변경 방법</h4>
                                    <div class="inquiry-meta">
                                        <span>2024.02.28</span>
                                    </div>
                                </div>
                                <div class="inquiry-status-wrap">
                                    <span class="inquiry-status answered">답변완료</span>
                                    <i class="bi bi-chevron-down"></i>
                                </div>
                            </div>
                            <div class="inquiry-body-mypage">
                                <div class="inquiry-question">
                                    <div class="inquiry-label">문의 내용</div>
                                    <p>등록한 상품들의 노출 순서를 변경하고 싶습니다. 방법을 알려주세요.</p>
                                </div>
                                <div class="inquiry-answer-box">
                                    <div class="inquiry-label">답변 <span class="answer-date">2024.02.28 14:30</span></div>
                                    <p>
                                        안녕하세요, 모행입니다.<br><br>
                                        상품 노출 순서는 마이페이지 > 내 상품 현황에서 드래그앤드롭으로 변경하실 수 있습니다.<br>
                                        또한 '추천 상품'으로 설정하시면 상단에 우선 노출됩니다.<br><br>
                                        감사합니다.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 페이지네이션 -->
                <div class="pagination-container">
                    <nav>
                        <ul class="pagination">
                            <li class="page-item">
                                <a class="page-link" href="#"><i class="bi bi-chevron-left"></i></a>
                            </li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item">
                                <a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// 탭 필터링
document.querySelectorAll('.mypage-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        document.querySelectorAll('.mypage-tab').forEach(t => t.classList.remove('active'));
        this.classList.add('active');

        const filter = this.dataset.filter;
        const items = document.querySelectorAll('.inquiry-item-mypage');

        items.forEach(item => {
            if (filter === 'all') {
                item.style.display = 'block';
            } else {
                const status = item.dataset.status;
                item.style.display = status === filter ? 'block' : 'none';
            }
        });
    });
});

// 문의 아코디언
function toggleInquiry(header) {
    const item = header.closest('.inquiry-item-mypage');
    item.classList.toggle('active');
}
</script>

<c:set var="pageJs" value="mypage" />
<%@ include file="../../common/footer.jsp" %>
