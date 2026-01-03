<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="결제 완료" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>

<div class="booking-page">
    <div class="container">
        <!-- 결제 단계 -->
        <div class="booking-steps">
            <div class="booking-step completed">
                <div class="step-icon"><i class="bi bi-check"></i></div>
                <span>결제 정보</span>
            </div>
            <div class="booking-step completed">
                <div class="step-icon"><i class="bi bi-check"></i></div>
                <span>결제</span>
            </div>
            <div class="booking-step active">
                <div class="step-icon">3</div>
                <span>완료</span>
            </div>
        </div>

        <!-- 결제 완료 -->
        <div class="payment-complete">
            <div class="complete-icon">
                <i class="bi bi-check-lg"></i>
            </div>
            <h1 class="complete-title">결제가 완료되었습니다!</h1>
            <p class="complete-message">
                결제 확인 메일이 <strong>${sessionScope.loginUser.email}</strong>으로 발송되었습니다.<br>
                즐거운 여행 되세요!
            </p>

            <div class="complete-details">
                <h4>결제 상세</h4>
                <div class="detail-row">
                    <span class="label">결제번호</span>
                    <span class="value"><strong>MH2024032012345</strong></span>
                </div>
                <div class="detail-row">
                    <span class="label">상품명</span>
                    <span class="value">제주 스쿠버다이빙 체험</span>
                </div>
                <div class="detail-row">
                    <span class="label">이용일시</span>
                    <span class="value">2024.03.20 (수) 14:00</span>
                </div>
                <div class="detail-row">
                    <span class="label">인원</span>
                    <span class="value">2명</span>
                </div>
                <div class="detail-row">
                    <span class="label">결제금액</span>
                    <span class="value"><strong class="text-primary">136,000원</strong></span>
                </div>
                <div class="detail-row">
                    <span class="label">결제수단</span>
                    <span class="value">신용카드</span>
                </div>
            </div>

            <div class="alert alert-warning mb-4">
                <i class="bi bi-exclamation-triangle me-2"></i>
                <strong>이용 안내</strong>
                <ul class="mb-0 mt-2 ps-3">
                    <li>예약 시간 10분 전까지 현장에 도착해주세요.</li>
                    <li>수영복, 타월을 지참해주세요.</li>
                    <li>기상 악화 시 일정이 변경될 수 있습니다.</li>
                </ul>
            </div>

            <div class="complete-actions">
                <a href="${pageContext.request.contextPath}/mypage/payments" class="btn btn-outline btn-lg">
                    <i class="bi bi-receipt me-2"></i>결제 내역 보기
                </a>
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg">
                    <i class="bi bi-house me-2"></i>홈으로
                </a>
            </div>
        </div>
    </div>
</div>

<c:set var="pageJs" value="product" />
<%@ include file="../common/footer.jsp" %>
