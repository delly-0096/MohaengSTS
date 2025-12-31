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
                    <h1>${notice.ntcTitle}</h1>
                    <div class="notice-detail-meta">
                        <span><i class="bi bi-calendar3 me-1"></i> ${notice.regDt}</span>
                        <span><i class="bi bi-eye me-1"></i> ${notice.viewCnt}</span>
                    </div>
                </div>

                <div class="notice-detail-body">
                 ${notice.ntcContent}
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
