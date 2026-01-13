<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="공지사항" />
<c:set var="pageCss" value="support" />

<%@ include file="../common/header.jsp" %>

<div class="support-page">
    <div class="container">
        <!-- 헤더 -->
        <div class="support-header">
            <h1><i class="bi bi-megaphone me-3"></i>공지사항</h1>
            <p>모행의 새로운 소식을 확인하세요</p>
        </div>

        <!-- 고객지원 네비게이션 -->
        <div class="support-nav">
            <a href="${pageContext.request.contextPath}/support/faq" class="support-nav-item">
                <i class="bi bi-question-circle me-2"></i>FAQ
            </a>
            <a href="${pageContext.request.contextPath}/support/notice" class="support-nav-item active">
                <i class="bi bi-megaphone me-2"></i>공지사항
            </a>
            <a href="${pageContext.request.contextPath}/support/inquiry" class="support-nav-item">
                <i class="bi bi-chat-dots me-2"></i>1:1 문의
            </a>
        </div>

        <div class="notice-container">
            <!-- 공지사항 상세 -->
            <div class="notice-detail">
                <div class="notice-detail-header">
                    <div class="mb-3">
                        <span class="notice-badge notice">공지</span>
                    </div>
                    <h1>[공지] 개인정보 처리방침 개정 안내</h1>
                    <div class="notice-detail-meta">
                        <span><i class="bi bi-calendar3 me-1"></i> 2024.03.15</span>
                        <span><i class="bi bi-eye me-1"></i> 1,234</span>
                    </div>
                </div>

                <div class="notice-detail-body">
                    <p>안녕하세요, 모행입니다.</p>
                    <br>
                    <p>개인정보 처리방침이 아래와 같이 개정될 예정임을 안내드립니다.</p>
                    <br>
                    <h4>1. 개정 사유</h4>
                    <p>개인정보 보호법 개정에 따른 처리방침 변경</p>
                    <br>
                    <h4>2. 주요 변경 사항</h4>
                    <ul>
                        <li>개인정보 수집 항목 명확화</li>
                        <li>개인정보 보유 기간 상세 안내</li>
                        <li>제3자 제공 동의 절차 강화</li>
                        <li>이용자 권리 행사 방법 구체화</li>
                    </ul>
                    <br>
                    <h4>3. 시행일</h4>
                    <p>2024년 4월 1일부터 시행</p>
                    <br>
                    <h4>4. 문의</h4>
                    <p>개정된 개인정보 처리방침에 대한 문의사항은 고객센터(1588-0000) 또는 1:1 문의를 통해 문의해 주시기 바랍니다.</p>
                    <br>
                    <p>앞으로도 이용자의 개인정보 보호를 위해 최선을 다하겠습니다.</p>
                    <br>
                    <p>감사합니다.</p>
                </div>

                <div class="notice-detail-footer">
                    <a href="${pageContext.request.contextPath}/support/notice" class="btn btn-outline">
                        <i class="bi bi-list me-2"></i>목록으로
                    </a>
                    <div class="d-flex gap-2">
                        <button class="btn btn-outline" onclick="history.back()">
                            <i class="bi bi-chevron-left me-1"></i>이전글
                        </button>
                        <button class="btn btn-outline">
                            다음글<i class="bi bi-chevron-right ms-1"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<c:set var="pageJs" value="support" />
<%@ include file="../common/footer.jsp" %>
