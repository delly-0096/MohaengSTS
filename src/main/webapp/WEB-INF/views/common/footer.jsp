<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

    </main>
    <!-- 메인 콘텐츠 끝 -->

    <!-- 푸터 -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <!-- 브랜드 정보 -->
                <div class="footer-brand">
                    <a href="${pageContext.request.contextPath}/" class="logo footer-logo">
                        <img src="${pageContext.request.contextPath}/resources/images/moheng_CI.png" alt="모행 - 모두의 여행" class="logo-img">
                    </a>
                    <p class="footer-desc">
                        모두의 여행, 모행<br>
                        AI 기반 개인 맞춤형 관광 서비스 플랫폼으로<br>
                        당신만의 특별한 여행을 계획하세요.
                    </p>
                    <div class="footer-social">
                        <a href="#" class="social-link" title="Instagram">
                            <i class="bi bi-instagram"></i>
                        </a>
                        <a href="#" class="social-link" title="YouTube">
                            <i class="bi bi-youtube"></i>
                        </a>
                        <a href="#" class="social-link" title="Blog">
                            <i class="bi bi-pencil-square"></i>
                        </a>
                        <a href="#" class="social-link" title="Facebook">
                            <i class="bi bi-facebook"></i>
                        </a>
                    </div>
                </div>

                <!-- 서비스 링크 -->
                <div class="footer-section">
                    <h4 class="footer-title">서비스</h4>
                    <div class="footer-links">
                        <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                            <a href="${pageContext.request.contextPath}/schedule/search" class="footer-link">일정 검색</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/product/flight" class="footer-link">항공</a>
                        <a href="${pageContext.request.contextPath}/product/accommodation" class="footer-link">숙박</a>
                        <a href="${pageContext.request.contextPath}/product/tour" class="footer-link">투어/체험/티켓</a>
                        <c:if test="${sessionScope.loginUser.userType ne 'BUSINESS'}">
                            <a href="${pageContext.request.contextPath}/community/talk" class="footer-link">여행톡</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/community/travel-log" class="footer-link">여행기록</a>
                    </div>
                </div>

                <!-- 고객지원 링크 -->
                <div class="footer-section">
                    <h4 class="footer-title">고객지원</h4>
                    <div class="footer-links">
                        <a href="${pageContext.request.contextPath}/support/faq" class="footer-link">자주 묻는 질문</a>
                        <a href="${pageContext.request.contextPath}/support/notice" class="footer-link">공지사항</a>
                        <a href="${pageContext.request.contextPath}/support/inquiry" class="footer-link">1:1 문의</a>
                        <a href="#" class="footer-link" onclick="showChatbotFromMenu(); return false;">챗봇 상담</a>
                    </div>
                </div>

                <!-- 회사 정보 -->
                <div class="footer-section">
                    <h4 class="footer-title">회사</h4>
                    <div class="footer-links">
                        <a href="${pageContext.request.contextPath}/about" class="footer-link">회사 소개</a>
                        <a href="${pageContext.request.contextPath}/business" class="footer-link">기업회원 안내</a>
                        <a href="${pageContext.request.contextPath}/partnership" class="footer-link">제휴 문의</a>
                        <a href="${pageContext.request.contextPath}/recruit" class="footer-link">채용 안내</a>
                    </div>
                </div>
            </div>

            <!-- 푸터 하단 -->
            <div class="footer-bottom">
                <p>&copy; 2024 모행(MOHAENG). All rights reserved.</p>
                <div class="footer-legal">
                    <a href="${pageContext.request.contextPath}/terms" class="footer-link">이용약관</a>
                    <a href="${pageContext.request.contextPath}/privacy" class="footer-link">개인정보처리방침</a>
                    <a href="${pageContext.request.contextPath}/location" class="footer-link">위치기반서비스 이용약관</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- 챗봇 플로팅 버튼 -->
    <div class="chatbot-floating">
        <button class="chatbot-btn" id="chatbotBtn" onclick="toggleChatbot()" title="AI 챗봇">
            <i class="bi bi-chat-dots-fill"></i>
        </button>
    </div>

    <!-- 챗봇 창 (선택지 기반) -->
    <div class="chatbot-window" id="chatbotWindow">
        <div class="chatbot-header">
            <div class="chatbot-title">
                <i class="bi bi-robot me-2"></i>모행 AI 챗봇
            </div>
            <button class="chatbot-close" onclick="toggleChatbot()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="chatbot-messages" id="chatbotMessages">
            <!-- JavaScript로 동적 생성 -->
        </div>
    </div>

    <!-- 신고 모달 -->
    <div class="report-modal-overlay" id="reportModalOverlay">
        <div class="report-modal" onclick="event.stopPropagation()">
            <div class="report-modal-header">
                <h3><i class="bi bi-exclamation-triangle"></i> 신고하기</h3>
                <button class="report-modal-close" onclick="closeReportModal()">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <div class="report-modal-body">
                <form id="reportForm">
                    <!-- 신고 대상 정보 -->
                    <div class="report-target-info">
                        <div class="report-target-label" id="reportTargetLabel">신고 대상</div>
                        <div class="report-target-content" id="reportTargetContent">내용</div>
                    </div>

                    <!-- 신고 사유 선택 -->
                    <div class="report-reason-title">신고 사유를 선택해주세요</div>
                    <div class="report-reason-list">
                        <div class="report-reason-item" onclick="selectReportReason(this)">
                            <input type="radio" name="reportReason" value="spam" id="reason1">
                            <label for="reason1">스팸/광고</label>
                        </div>
                        <div class="report-reason-item" onclick="selectReportReason(this)">
                            <input type="radio" name="reportReason" value="inappropriate" id="reason2">
                            <label for="reason2">음란물/불건전한 내용</label>
                        </div>
                        <div class="report-reason-item" onclick="selectReportReason(this)">
                            <input type="radio" name="reportReason" value="abuse" id="reason3">
                            <label for="reason3">욕설/비방/혐오 표현</label>
                        </div>
                        <div class="report-reason-item" onclick="selectReportReason(this)">
                            <input type="radio" name="reportReason" value="fraud" id="reason4">
                            <label for="reason4">사기/거짓 정보</label>
                        </div>
                        <div class="report-reason-item" onclick="selectReportReason(this)">
                            <input type="radio" name="reportReason" value="copyright" id="reason5">
                            <label for="reason5">저작권 침해</label>
                        </div>
                        <div class="report-reason-item" onclick="selectReportReason(this)">
                            <input type="radio" name="reportReason" value="other" id="reason6">
                            <label for="reason6">기타</label>
                        </div>
                    </div>

                    <!-- 상세 내용 -->
                    <div class="report-detail-wrapper">
                        <label for="reportDetail">상세 내용 (선택)</label>
                        <textarea class="report-detail-textarea" id="reportDetail"
                                  placeholder="신고 사유에 대한 상세 내용을 작성해주세요."></textarea>
                    </div>

                    <!-- 안내 문구 -->
                    <div class="report-notice">
                        <p><i class="bi bi-info-circle"></i>허위 신고 시 서비스 이용이 제한될 수 있습니다. 신고 내용은 검토 후 처리됩니다.</p>
                    </div>
                </form>
            </div>
            <div class="report-modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeReportModal()">취소</button>
                <button type="button" class="btn btn-danger" onclick="submitReport()">
                    <i class="bi bi-exclamation-triangle me-2"></i>신고하기
                </button>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Flatpickr (날짜 선택) -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>

    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/resources/js/common.js"></script>

    <!-- 페이지별 추가 JS -->
    <c:if test="${not empty pageJs}">
        <script src="${pageContext.request.contextPath}/resources/js/${pageJs}.js"></script>
    </c:if>

<c:if test="${empty hasInlineScript}">
</body>
</html>
</c:if>
