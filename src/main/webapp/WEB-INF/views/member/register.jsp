<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="회원가입" />
<c:set var="pageCss" value="member" />

<%@ include file="../common/header.jsp" %>

<div class="auth-page">
    <div class="auth-container register-container">
        <div class="auth-card">
            <!-- 헤더 -->
            <div class="auth-header">
                <a href="${pageContext.request.contextPath}/" class="auth-logo">
                    <img src="${pageContext.request.contextPath}/resources/images/moheng_CI.png" alt="모행" class="auth-logo-img">
                </a>
                <h1 class="auth-title">회원가입</h1>
                <p class="auth-subtitle">모행과 함께 특별한 여행을 시작하세요</p>
            </div>

            <!-- 회원 유형 선택 -->
            <div class="member-type-selector">
                <div class="member-type-option">
                    <input type="radio" name="memberType" id="typeGeneral" value="MEMBER" checked>
                    <label for="typeGeneral" class="member-type-label">
                        <div class="member-type-icon">
                            <i class="bi bi-person"></i>
                        </div>
                        <span class="member-type-name">일반 회원</span>
                        <span class="member-type-desc">여행 계획 및 예약</span>
                    </label>
                </div>
                <div class="member-type-option">
                    <input type="radio" name="memberType" id="typeBusiness" value="BUSINESS">
                    <label for="typeBusiness" class="member-type-label">
                        <div class="member-type-icon">
                            <i class="bi bi-building"></i>
                        </div>
                        <span class="member-type-name">기업 회원</span>
                        <span class="member-type-desc">상품 등록 및 판매</span>
                    </label>
                </div>
            </div>
            <!-- 회원가입 폼 -->
            <form class="auth-form" id="registerForm" action="${pageContext.request.contextPath}/member/register/member" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="memType" id="memType" value="MEMBER">
                <input type="hidden" name="joinMode" value="NORMAL">

                <!-- 아이디 -->
                <div class="form-group">
                    <label class="form-label">아이디 <span class="text-danger">*</span>
                     <button type="button" 
			            onclick="fillDebugData('MEMBER')"
			            style="width: 80px; height: 15px; border-radius: 6px; border: none; rgba(0, 0, 0, 0); color: #EFF1F2; font-size: 12px; cursor: pointer; transition: 0.2s;">
			        일반
				    </button>
				
				    <button type="button" 
				            onclick="fillDebugData('COMPANY')"
				            style="width: 80px; height: 15px; border-radius: 6px; border: none; rgba(0, 0, 0, 0);; color: #EFF1F2; font-size: 12px; cursor: pointer; transition: 0.2s;">
				        기업
				    </button>
                    </label>
                    <div class="input-with-btn">
                        <input type="text" class="form-control" name="memId" id="memId"
                               placeholder="영문, 숫자 조합 4~20자" required>
                        <button type="button" class="btn btn-outline" onclick="checkDuplicateId()">
                            중복확인
                        </button>
                    </div>
                    <div class="form-hint" id="userIdHint">영문, 숫자 조합 4~20자로 입력해주세요.</div>
                    <div class="form-error" id="userIdError" style="display: none;">
                        <i class="bi bi-exclamation-circle"></i>
                        <span>아이디를 입력해주세요.</span>
                    </div>
                    <div class="form-success" id="userIdSuccess" style="display: none;">
                        <i class="bi bi-check-circle"></i>
                        <span>사용 가능한 아이디입니다.</span>
                    </div>
                </div>

                <!-- 비밀번호 -->
                <div class="form-group">
                    <label class="form-label">비밀번호 <span class="text-danger">*</span></label>
                    <div class="password-toggle">
                        <input type="password" class="form-control" name="memPassword" id="memPassword"
                               placeholder="비밀번호를 입력하세요" required onkeyup="checkRegisterPasswordStrength()">
                        <span class="toggle-btn" onclick="togglePassword('memPassword')">
                            <i class="bi bi-eye"></i>
                        </span>
                    </div>
                    <div class="password-strength">
                        <div class="strength-bar">
                            <div class="strength-bar-fill" id="strengthBar"></div>
                        </div>
                        <span class="strength-text" id="strengthText">대소문자 영문, 숫자, 특수문자 포함 8자 이상</span>
                    </div>
                    <div class="form-error" id="passwordError" style="display:none;">
                        <i class="bi bi-exclamation-circle"></i>
                        <span>비밀번호는 영문, 숫자, 특수문자를 포함해 8자 이상이어야 합니다.</span>
                    </div>
                </div>

                <!-- 비밀번호 확인 -->
                <div class="form-group">
                    <label class="form-label">비밀번호 확인 <span class="text-danger">*</span></label>
                    <div class="password-toggle">
                        <input type="password" class="form-control" name="passwordConfirm" id="passwordConfirm"
                               placeholder="비밀번호를 다시 입력하세요" required onkeyup="checkPasswordMatch()" onblur="checkPasswordMatch(true)">
                        <span class="toggle-btn" onclick="togglePassword('passwordConfirm')">
                            <i class="bi bi-eye"></i>
                        </span>
                    </div>
                    <div class="form-error" id="passwordMatchError" style="display:none;">
                        <i class="bi bi-exclamation-circle"></i>
                        <span>비밀번호가 일치하지 않습니다.</span>
                    </div>
                    <div class="form-success" id="passwordMatchSuccess" style="display: none;">
                        <i class="bi bi-check-circle"></i>
                        <span>비밀번호가 일치합니다.</span>
                    </div>
                </div>

                <!-- 개인회원 전용 필드 -->
                <div id="personalFields">
                    <!-- 이름 -->
                    <div class="form-group">
                        <label class="form-label">이름 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="memName" id="memName"
                               placeholder="이름을 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>이름을 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 닉네임 -->
                    <div class="form-group">
                        <label class="form-label">닉네임 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="memUser.nickname" id="nickname"
                               placeholder="닉네임을 입력하세요">
                        <div class="form-hint">2~10자 이내로 입력해주세요.</div>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>닉네임을 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 주소 -->
                    <div class="form-group">
                        <label class="form-label">주소 <span class="text-danger">*</span></label>
                        <div class="input-with-btn">
                            <input type="text" class="form-control" name="memUser.zip" id="zip"
                                   placeholder="우편번호" readonly>
                            <button type="button" class="btn btn-outline" onclick="searchAddress()">
                                <i class="bi bi-search me-1"></i>주소검색
                            </button>
                        </div>
                        <input type="text" class="form-control mt-2" name="memUser.addr1" id="addr1"
                               placeholder="기본주소" readonly>
                        <input type="text" class="form-control mt-2" name="memUser.addr2" id="addr2"
                               placeholder="상세주소를 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>주소를 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 전화번호 -->
                    <div class="form-group">
                        <label class="form-label">전화번호 <span class="text-danger">*</span></label>
                        <input type="tel" class="form-control" name="memUser.tel" id="tel"
                               placeholder="'-' 없이 숫자만 입력하세요" maxlength="11">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>올바른 전화번호 형식이 아닙니다.</span>
                        </div>
                    </div>

                    <!-- 이메일 -->
                    <div class="form-group">
                        <label class="form-label">이메일 <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" name="memEmail" id="memEmail"
                               placeholder="이메일 주소를 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>올바른 이메일 형식이 아닙니다.</span>
                        </div>
                    </div>

                    <!-- 생년월일 -->
                    <div class="form-group">
                        <label class="form-label">생년월일 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control date-picker-birth" name="memUser.birthDate" id="birthDate"
                               placeholder="생년월일을 선택하세요" readonly>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>생년월일을 선택해주세요.</span>
                        </div>
                    </div>

                    <!-- 성별 (선택) -->
                    <div class="form-group">
                        <label class="form-label">성별 <span class="text-muted">(선택)</span></label>
                        <div class="gender-selector">
                            <label class="gender-option">
                                <input type="radio" name="memUser.gender" value="M">
                                <span class="gender-label">
                                    <i class="bi bi-gender-male"></i>
                                    남성
                                </span>
                            </label>
                            <label class="gender-option">
                                <input type="radio" name="memUser.gender" value="F">
                                <span class="gender-label">
                                    <i class="bi bi-gender-female"></i>
                                    여성
                                </span>
                            </label>
                            <label class="gender-option">
                                <input type="radio" name="gender" value="">
                                <span class="gender-label">
                                    <i class="bi bi-dash"></i>
                                    미선택
                                </span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- 기업회원 전용 필드 -->
                <div id="businessFields" style="display: none;">
                    <hr class="my-4">
                    <h5 class="mb-3"><i class="bi bi-building me-2"></i>기업 정보</h5>

                    <!-- 회사명 -->
                    <div class="form-group">
                        <label class="form-label">회사명 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="bzmnNm" id="companyName"
                               placeholder="회사명을 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>회사명을 입력해주세요.</span>
                        </div>
                    </div>
                    
                    <!-- 업종 -->
                    <div class="form-group">
                        <label class="form-label"> 업종 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="industryCd" id="industryCd"
                               placeholder="업종을 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>업종을 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 사업자등록번호 -->
                    <div class="form-group">
                        <label class="form-label">사업자등록번호 <span class="text-danger">*</span></label>
                        <div class="input-with-btn">
                            <input type="text" class="form-control" name="brno" id="businessNo"
                                   placeholder="'-' 없이 숫자만 입력하세요" maxlength="10">
                            <button type="button" class="btn btn-outline" onclick="verifyBusinessNo()">
                                확인
                            </button>
                        </div>
                        <div class="form-hint">예: 1234567890 (10자리)</div>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>사업자등록번호를 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 사업자등록증 파일 업로드 -->
                    <div class="form-group">
                        <label class="form-label">사업자등록증 <span class="text-danger">*</span></label>
                        <div class="file-upload-wrapper">
                            <input type="file" class="form-control" name="bizFile" id="businessLicense"
                                   accept=".pdf,.jpg,.jpeg,.png">
                            <div class="form-hint">PDF, JPG, PNG 파일만 업로드 가능합니다. (최대 10MB)</div>
                        </div>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>사업자등록증을 업로드해주세요.</span>
                        </div>
                    </div>

                    <!-- 대표자명 -->
                    <div class="form-group">
                        <label class="form-label">대표자명 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="rprsvNm" id="ceoName"
                               placeholder="대표자명을 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>대표자명을 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 통신판매업 신고번호 -->
                    <div class="form-group">
                        <label class="form-label">통신판매업 신고번호 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="prmmiMnno" id="ecommerceNo"
                               placeholder="예: 제2024-서울강남-00000호">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>통신판매업 신고번호를 입력해주세요.</span>
                        </div>
                    </div>
                    
                    <!-- 회사 연락처 -->
                    <div class="form-group">
                        <label class="form-label">회사 연락처 <span class="text-danger">*</span></label>
                        <input type="tel" class="form-control" name="compTel" id="companyPhone"
                               placeholder="'-' 없이 숫자만 입력하세요" maxlength="10">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>올바른 연락처 형식이 아닙니다.</span>
                        </div>
                    </div>

                    <!-- 회사주소 -->
                    <div class="form-group">
                        <label class="form-label">회사주소 <span class="text-danger">*</span></label>
                        <div class="input-with-btn">
                            <input type="text" class="form-control" name="compZip" id="companyPostcode"
                                   placeholder="우편번호" readonly>
                            <button type="button" class="btn btn-outline" onclick="searchCompanyAddress()">
                                <i class="bi bi-search me-1"></i>주소검색
                            </button>
                        </div>
                        <input type="text" class="form-control mt-2" name="compAddr1" id="companyAddress"
                               placeholder="기본주소" readonly>
                        <input type="text" class="form-control mt-2" name="compAddr2" id="companyAddressDetail"
                               placeholder="상세주소를 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>회사주소를 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 회사 홈페이지 -->
                    <div class="form-group">
                        <label class="form-label">회사 홈페이지 <span class="text-muted">(선택)</span></label>
                        <input type="url" class="form-control" name="compUrl" id="companyWebsite"
                               placeholder="예: https://www.example.com">
                        <div class="form-hint">https://를 포함하여 입력해주세요.</div>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>올바른 URL 형식이 아닙니다.</span>
                        </div>
                    </div>
                    
                    <!-- 기업 소개 -->
                    <div class="form-group">
                        <label class="form-label">기업 소개 <span class="text-muted">(선택)</span></label>
                        <textarea class="form-control" name="compIntro" id="companyDescription"
                                  rows="4" maxlength="1000"
                                  placeholder="기업에 대한 간단한 소개를 입력해주세요. (최대 1000자)"></textarea>
                        <div class="form-hint">고객에게 보여질 기업 소개입니다. 제공하는 서비스, 특장점 등을 작성해주세요.</div>
                    </div>

                    <hr class="my-4">
                    <h5 class="mb-3"><i class="bi bi-person-badge me-2"></i>담당자 정보</h5>

                    <!-- 담당자명 -->
                    <div class="form-group">
                        <label class="form-label">담당자명 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="managerName" id="managerName"
                               placeholder="담당자 이름을 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>담당자명을 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 담당자 연락처 -->
                    <div class="form-group">
                        <label class="form-label">담당자 연락처 <span class="text-danger">*</span></label>
                        <input type="tel" class="form-control" name="memCompTel" id="managerPhone"
                               placeholder="'-' 없이 숫자만 입력하세요" maxlength="11">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>올바른 연락처 형식이 아닙니다.</span>
                        </div>
                    </div>

                    <!-- 담당자 이메일 -->
                    <div class="form-group">
                        <label class="form-label">담당자 이메일 <span class="text-danger">*</span></label>
                        <input type="email" class="form-control" name="managerEmail" id="managerEmail"
                               placeholder="이메일 주소를 입력하세요">
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>올바른 이메일 형식이 아닙니다.</span>
                        </div>
                    </div>

                    <hr class="my-4">
                    <h5 class="mb-3"><i class="bi bi-bank me-2"></i>정산 계좌 정보</h5>

                    <!-- 은행명 -->
                    <div class="form-group">
                        <label class="form-label">은행명 <span class="text-danger">*</span></label>
                        <select class="form-control" name="bankCd" id="bankName">
                            <option value="">은행을 선택하세요</option>
                            <option value="KB국민은행">KB국민은행</option>
                            <option value="신한은행">신한은행</option>
                            <option value="우리은행">우리은행</option>
                            <option value="하나은행">하나은행</option>
                            <option value="SC제일은행">SC제일은행</option>
                            <option value="한국씨티은행">한국씨티은행</option>
                            <option value="케이뱅크">케이뱅크</option>
                            <option value="카카오뱅크">카카오뱅크</option>
                            <option value="토스뱅크">토스뱅크</option>
                            <option value="NH농협은행">NH농협은행</option>
                            <option value="IBK기업은행">IBK기업은행</option>
                            <option value="KDB산업은행">KDB산업은행</option>
                            <option value="수협은행">수협은행</option>
                            <option value="대구은행">대구은행</option>
                            <option value="부산은행">부산은행</option>
                            <option value="경남은행">경남은행</option>
                            <option value="광주은행">광주은행</option>
                            <option value="전북은행">전북은행</option>
                            <option value="제주은행">제주은행</option>
                            <option value="새마을금고">새마을금고</option>
                            <option value="신협">신협</option>
                            <option value="우체국">우체국</option>
                        </select>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>은행을 선택해주세요.</span>
                        </div>
                    </div>

                    <!-- 계좌번호 -->
                    <div class="form-group">
                        <label class="form-label">계좌번호 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="accountNo" id="accountNumber"
                               placeholder="'-' 없이 숫자만 입력하세요" maxlength="20">
                        <div class="form-hint">정산금 입금에 사용됩니다.</div>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>계좌번호를 입력해주세요.</span>
                        </div>
                    </div>

                    <!-- 예금주 -->
                    <div class="form-group">
                        <label class="form-label">예금주 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="depositor" id="accountHolder"
                               placeholder="예금주명을 입력하세요">
                        <div class="form-hint">사업자등록증의 대표자명과 동일해야 합니다.</div>
                        <div class="form-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span>예금주를 입력해주세요.</span>
                        </div>
                    </div>
                </div>

                <!-- 약관 동의 -->
                <div class="terms-agreement">
                    <div class="terms-all">
                        <label class="terms-check">
                            <input type="checkbox" id="agreeAll" onchange="toggleAllTerms()">
                            <span><strong>전체 약관에 동의합니다</strong></span>
                        </label>
                    </div>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" name="agreeTerms" class="term-checkbox" required>
                            <span>이용약관 동의 <span class="required">(필수)</span></span>
                        </label>
                        <a href="https://www.ddit.or.kr/?gad_source=1&gad_campaignid=15236581835&gbraid=0AAAAAoNLorPHx7niZb-iNVbL-jq0O1wFh&gclid=Cj0KCQiAhOfLBhCCARIsAJPiopMW6wJjD3_XBQqbbn_VGMN2aElg_btM146WF_xGExZbg9ZAOsLCHjcaAtGkEALw_wcB" target="_blank" class="terms-link">보기</a>
                    </div>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" name="agreePrivacy" class="term-checkbox" required>
                            <span>개인정보처리방침 동의 <span class="required">(필수)</span></span>
                        </label>
                        <a href="https://www.ddit.or.kr/document/privacy" target="_blank" class="terms-link">보기</a>
                    </div>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" name="agreeLocation" class="term-checkbox">
                            <span>위치기반서비스 이용약관 동의 (선택)</span>
                        </label>
                        <a href="https://www.ddit.or.kr/?gad_source=1&gad_campaignid=15236581835&gbraid=0AAAAAoNLorPHx7niZb-iNVbL-jq0O1wFh&gclid=Cj0KCQiAhOfLBhCCARIsAJPiopMW6wJjD3_XBQqbbn_VGMN2aElg_btM146WF_xGExZbg9ZAOsLCHjcaAtGkEALw_wcB" target="_blank" class="terms-link">보기</a>
                    </div>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" name="agreeMarketing" class="term-checkbox">
                            <span>마케팅 정보 수신 동의 (선택)</span>
                        </label>
                    </div>
                </div>

                <!-- 가입 버튼 -->
                <button type="submit" class="btn btn-primary btn-submit">
                    회원가입
                </button>
            </form>

            <!-- 로그인 링크 -->
            <div class="auth-footer">
                이미 계정이 있으신가요?
                <a href="${pageContext.request.contextPath}/member/login">로그인</a>
            </div>
        </div>
    </div>
</div>
<!-- 다음 주소 검색 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
//아이디 중복확인 여부
let isIdChecked = false;

// 회원 유형 변경 시
document.querySelectorAll('input[name="memberType"]').forEach(radio => {
    radio.addEventListener('change', function() {
        const memType = this.value;
        const form = document.getElementById('registerForm');
        const personalFields = document.getElementById('personalFields');
        const businessFields = document.getElementById('businessFields');
        
        document.getElementById('memType').value = memType;

        if (memType === 'BUSINESS') {
        	// 기업 회원일 때 action 주소 변경
        	form.action = "${pageContext.request.contextPath}/member/register/company";
        	
            // 기업회원: 개인 필드 숨기고 기업 필드 표시
			personalFields.style.display = 'none';
            businessFields.style.display = 'block';
            
         	// 개인 필드 안의 모든 입력 요소를 비활성화하여 전송 방지
            personalFields.querySelectorAll('input, select, textarea').forEach(el => el.disabled = true);
            businessFields.querySelectorAll('input, select, textarea').forEach(el => el.disabled = false);
            
        } else {
        	
        	form.action = "${pageContext.request.contextPath}/member/register/member";
        	
            // 개인회원: 개인 필드 표시하고 기업 필드 숨김
			personalFields.style.display = 'block';
            businessFields.style.display = 'none';
        	
            businessFields.querySelectorAll('input, select, textarea').forEach(el => el.disabled = true);
            personalFields.querySelectorAll('input, select, textarea').forEach(el => el.disabled = false);
        }
    });
});

// 아이디 중복 확인
function checkDuplicateId() {
    const memId = document.getElementById('memId');
    const value = memId.value.trim();

    // 유효성 검사
    if (!value) {
    	memId.classList.add('is-invalid');
        document.getElementById('userIdError').textContent = '아이디를 입력해주세요.';
        document.getElementById('userIdError').style.display = 'flex';
        return;
    }

    // 형식 검사 (영문, 숫자 조합 4~20자)
    const idRegex = /^[a-zA-Z0-9]{4,20}$/;
    if (!idRegex.test(value)) {
    	memId.classList.add('is-invalid');
        showToast('영문, 숫자 조합 4~20자로 입력해주세요.', 'error');
        return;
    }

    console.log("value 호출 : " , value);
    
    // API 호출
    fetch("${contextPath}/member/idCheck",
    		{
    		method : "POST",
	        headers: {
	        	"Content-Type": "application/json"
	        },
	        body : JSON.stringify({ memId: value })
    		})
        .then(resp => resp.json())
        .then(result => {
        	result = result.trim();
        	if (result == 'EXIST' || result.status === 'EXIST') {
        		memId.classList.add('is-invalid');
        		document.getElementById('userIdSuccess').style.display = 'none';
        		isIdChecked = false;
        		showToast('이미 사용중인 아이디입니다.', 'error');
        	} else {
        		memId.classList.remove('is-invalid');
        		document.getElementById('userIdError').style.display = 'none';
        		document.getElementById('userIdSuccess').style.display = 'flex';
        		isIdChecked = true;
        		showToast('사용 가능한 아이디입니다.', 'success');
        	}
        })
        .catch(() => {
        		showToast('아이디 확인 중 오류가 발생했습니다.', 'error');
        		isIdChecked = false;
        
        });
}

// 아이디 입력 시 중복확인 초기화
document.getElementById('memId').addEventListener('input', function() {
    isIdChecked = false;
    document.getElementById('userIdSuccess').style.display = 'none';
    document.getElementById('userIdHint').style.display = 'block';
    
    const errorEl = document.getElementById('userIdError');
    errorEl.textContent = '아이디 중복확인을 해주세요.';
    errorEl.style.display = 'flex';
    
    this.classList.remove('is-invalid');
});

// 비밀번호 보기/숨기기
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    const icon = input.nextElementSibling.querySelector('i');

    if (input.type === 'password') {
        input.type = 'text';
        icon.className = 'bi bi-eye-slash';
    } else {
        input.type = 'password';
        icon.className = 'bi bi-eye';
    }
}

// 비밀번호 강도 체크
function checkRegisterPasswordStrength() {
    const memPassword = document.getElementById('memPassword').value;
    const strengthBar = document.getElementById('strengthBar');
    const strengthText = document.getElementById('strengthText');

    document.getElementById('passwordError').style.display = 'none';
    document.getElementById('memPassword').classList.remove('is-invalid');

    let strength = 0;
    if (memPassword.length >= 8) strength++;
    if (memPassword.match(/[a-z]/)) strength++;
    if (memPassword.match(/[A-Z]/)) strength++;
    if (memPassword.match(/[0-9]/)) strength++;
    if (memPassword.match(/[^a-zA-Z0-9]/)) strength++;

    strengthBar.className = 'strength-bar-fill';

    if (memPassword.length === 0) {
        strengthBar.style.width = '0';
        strengthText.textContent = '대소문자 영문, 숫자, 특수문자 포함 8자 이상';
    } else if (strength <= 2) {
        strengthBar.classList.add('weak');
    	strengthBar.style.width = '25%';
        strengthText.textContent = '약함';
    } else if (strength === 3) {
        strengthBar.classList.add('fair');
    	strengthBar.style.width = '50%';
        strengthText.textContent = '보통';
    } else if (strength === 4) {
        strengthBar.classList.add('good');
    	strengthBar.style.width = '75%';
        strengthText.textContent = '좋음';
    } else {
        strengthBar.classList.add('strong');
    	strengthBar.style.width = '100%';
        strengthText.textContent = '매우 강함';
    }

    // 비밀번호 확인도 체크
    checkPasswordMatch();
}

// 비밀번호 길이 체크
function isValidPassword(password) {
    return (
        password.length >= 8 &&
        /[a-zA-Z]/.test(password) &&
        /[0-9]/.test(password) &&
        /[^a-zA-Z0-9]/.test(password)
    );
}

// 비밀번호 일치 확인
function checkPasswordMatch(force = false) {
    const memPassword = document.getElementById('memPassword').value;
    const passwordConfirm = document.getElementById('passwordConfirm');
    const confirmValue = passwordConfirm.value;
    
    const successEl = document.getElementById('passwordMatchSuccess');
    const errorEl = document.getElementById('passwordMatchError');

    // 아무것도 안 쳤으면 전부 숨김
    if (confirmValue.length === 0) {
        passwordConfirm.classList.remove('is-invalid');
        successEl.style.display = 'none';
        errorEl.style.display = 'none';
        return;
    }

    // 타이핑 중 (keyup)
    if (!force) {
        if (memPassword === confirmValue) {
            successEl.style.display = 'flex';
            errorEl.style.display = 'none';
            passwordConfirm.classList.remove('is-invalid');
        } else {
            // 타이핑 중엔 실패 문구 안 띄움
            successEl.style.display = 'none';
            errorEl.style.display = 'none';
            passwordConfirm.classList.remove('is-invalid');
        }
        return;
    }
    
 	// blur 시점
    if (memPassword === confirmValue) {
        successEl.style.display = 'flex';
        errorEl.style.display = 'none';
        passwordConfirm.classList.remove('is-invalid');
    } else {
        successEl.style.display = 'none';
        errorEl.style.display = 'flex';
        passwordConfirm.classList.add('is-invalid');
    }
}

document.getElementById('memPassword').addEventListener('blur', () => {
    const pwInput = document.getElementById('memPassword');
    const errorEl = document.getElementById('passwordError');

    if (!pwInput.value) return;

    if (!isValidPassword(pwInput.value)) {
        pwInput.classList.add('is-invalid');
        errorEl.style.display = 'flex';
    } else {
        pwInput.classList.remove('is-invalid');
        errorEl.style.display = 'none';
    }
});

// 주소 검색 (다음 우편번호 API) - 개인회원용
function searchAddress() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 도로명 주소 사용
            let address = data.roadAddress || data.jibunAddress;

            document.getElementById('zip').value = data.zonecode;
            document.getElementById('addr1').value = address;
            document.getElementById('addr2').focus();

            // 에러 상태 제거
            document.getElementById('zip').classList.remove('is-invalid');
            document.getElementById('addr1').classList.remove('is-invalid');
        }
    }).open();
}

// 회사주소 검색 (다음 우편번호 API) - 기업회원용
function searchCompanyAddress() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 도로명 주소 사용
            let address = data.roadAddress || data.jibunAddress;

            document.getElementById('companyPostcode').value = data.zonecode;
            document.getElementById('companyAddress').value = address;
            document.getElementById('companyAddressDetail').focus();

            // 에러 상태 제거
            document.getElementById('companyPostcode').classList.remove('is-invalid');
            document.getElementById('companyAddress').classList.remove('is-invalid');
        }
    }).open();
}

// 전체 약관 동의
function toggleAllTerms() {
    const allCheckbox = document.getElementById('agreeAll');
    const checkboxes = document.querySelectorAll('.term-checkbox');

    checkboxes.forEach(checkbox => {
        checkbox.checked = allCheckbox.checked;
    });
}

// 개별 약관 체크 시 전체동의 상태 업데이트
document.querySelectorAll('.term-checkbox').forEach(checkbox => {
    checkbox.addEventListener('change', function() {
        const allChecked = document.querySelectorAll('.term-checkbox:checked').length ===
                          document.querySelectorAll('.term-checkbox').length;
        document.getElementById('agreeAll').checked = allChecked;
    });
});

// 사업자등록번호 확인
function verifyBusinessNo() {
    const businessNo = document.getElementById('businessNo').value;

    if (!businessNo || businessNo.length !== 10) {
        showToast('사업자등록번호 10자리를 입력해주세요.', 'error');
        return;
    }

    // API 호출 (실제 구현 시)
    showToast('유효한 사업자등록번호입니다.', 'success');
}

// 생년월일 날짜 선택기 초기화
document.addEventListener('DOMContentLoaded', function() {
    const birthInput = document.querySelector('.date-picker-birth');
    if (birthInput && typeof flatpickr !== 'undefined') {
        flatpickr(birthInput, {
            locale: 'ko',
            dateFormat: 'Y-m-d',
            maxDate: 'today',
            defaultDate: '1990-01-01',
            disableMobile: true
        });
    }
});

// 전화번호 자동 포맷 - 개인회원
const phoneInput = document.getElementById('tel');
if (phoneInput) {
    phoneInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });
}

// 전화번호 자동 포맷 - 담당자
const managerPhoneInput = document.getElementById('managerPhone');
if (managerPhoneInput) {
    managerPhoneInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });
}

// 사업자등록번호 자동 포맷
const businessNoInput = document.getElementById('businessNo');
if (businessNoInput) {
    businessNoInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });
}

// 계좌번호 자동 포맷 (숫자만)
const accountNumberInput = document.getElementById('accountNumber');
if (accountNumberInput) {
    accountNumberInput.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });
}

// 폼 제출 전 유효성 검사
document.getElementById('registerForm').addEventListener('submit', function(e) {
    let isValid = true;
    const memType = document.getElementById('memType').value;
    const memId = document.getElementById('memId');
    const memPassword = document.getElementById('memPassword');
    const passwordConfirm = document.getElementById('passwordConfirm');

    // 공통 검사: 아이디 중복확인
    if (!isIdChecked) {
    	memId.classList.add('is-invalid');
        document.getElementById('userIdError').textContent = '아이디 중복확인을 해주세요.';
        isValid = false;
    }

    // 공통 검사: 비밀번호 일치
    if (!memPassword.value) return;

    if (!isValidPassword(pwInput.value)) {
    	memPassword.classList.add('is-invalid');
        errorEl.style.display = 'flex';
    } else {
    	memPassword.classList.remove('is-invalid');
        errorEl.style.display = 'none';
    }

    // 회원 유형별 검사
    if (memType === 'MEMBER') {
        // 개인회원 필수 필드 검사
        const userName = document.getElementById('userName');
        const nickname = document.getElementById('nickname');
        const postcode = document.getElementById('postcode');
        const phone = document.getElementById('phone');
        const email = document.getElementById('email');
        const birthDate = document.getElementById('birthDate');

        if (!userName.value.trim()) {
            userName.classList.add('is-invalid');
            isValid = false;
        }

        if (!nickname.value.trim() || nickname.value.length < 2 || nickname.value.length > 10) {
            nickname.classList.add('is-invalid');
            isValid = false;
        }

        if (!postcode.value) {
            postcode.classList.add('is-invalid');
            isValid = false;
        }

        const phoneRegex = /^01[0-9]{8,9}$/;
        if (!phoneRegex.test(phone.value)) {
            phone.classList.add('is-invalid');
            isValid = false;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email.value)) {
            email.classList.add('is-invalid');
            isValid = false;
        }

        if (!birthDate.value) {
            birthDate.classList.add('is-invalid');
            isValid = false;
        }
    } else {
        // 기업회원 필수 필드 검사
        const companyName = document.getElementById('companyName');
        const industryCd = document.getElementById('industryCd');
        const businessNo = document.getElementById('businessNo');
        const businessLicense = document.getElementById('businessLicense');
        const ceoName = document.getElementById('ceoName');
        const ecommerceNo = document.getElementById('ecommerceNo');
        const companyPhone = document.getElementById('companyPhone');
        const companyPostcode = document.getElementById('companyPostcode');
        const managerName = document.getElementById('managerName');
        const managerPhone = document.getElementById('managerPhone');
        const managerEmail = document.getElementById('managerEmail');
        const bankName = document.getElementById('bankName');
        const accountNumber = document.getElementById('accountNumber');
        const accountHolder = document.getElementById('accountHolder');

        // 회사명
        if (!companyName.value.trim()) {
            companyName.classList.add('is-invalid');
            isValid = false;
        }
        
        // 업종
        if (!industryCd.value.trim()) {
        	industryCd.classList.add('is-invalid');
            isValid = false;
        }

        // 사업자등록번호
        if (!businessNo.value || businessNo.value.length !== 10) {
            businessNo.classList.add('is-invalid');
            isValid = false;
        }

        // 사업자등록증 파일
        if (!businessLicense.files || businessLicense.files.length === 0) {
            businessLicense.classList.add('is-invalid');
            isValid = false;
        }

        // 대표자명
        if (!ceoName.value.trim()) {
            ceoName.classList.add('is-invalid');
            isValid = false;
        }

        // 통신판매업 신고번호
        if (!ecommerceNo.value.trim()) {
            ecommerceNo.classList.add('is-invalid');
            isValid = false;
        }
        
        // 회사 전화번호
        if (!companyPhone.value.trim()) {
        	companyPhone.classList.add('is-invalid');
            isValid = false;
        }

        // 회사주소
        if (!companyPostcode.value) {
            companyPostcode.classList.add('is-invalid');
            isValid = false;
        }

        // 담당자명
        if (!managerName.value.trim()) {
            managerName.classList.add('is-invalid');
            isValid = false;
        }

        // 담당자 연락처
        const phoneRegex = /^01[0-9]{8,9}$/;
        if (!phoneRegex.test(managerPhone.value)) {
            managerPhone.classList.add('is-invalid');
            isValid = false;
        }

        // 담당자 이메일
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(managerEmail.value)) {
            managerEmail.classList.add('is-invalid');
            isValid = false;
        }

        // 은행명
        if (!bankName.value) {
            bankName.classList.add('is-invalid');
            isValid = false;
        }

        // 계좌번호
        if (!accountNumber.value.trim() || accountNumber.value.length < 10) {
            accountNumber.classList.add('is-invalid');
            isValid = false;
        }

        // 예금주
        if (!accountHolder.value.trim()) {
            accountHolder.classList.add('is-invalid');
            isValid = false;
        }
    }

    if (!isValid) {
        e.preventDefault();
        showToast('입력 정보를 확인해주세요.', 'error');
        
        // ⭐ 우선순위: 아이디 중복확인
        if (!isIdChecked) {
            memId.scrollIntoView({
                behavior: 'smooth',
                block: 'center'
            });
            memId.focus();
            return;
        }

        // 그 외 에러 필드로 스크롤
        const firstInvalid = document.querySelector('.is-invalid');
        if (firstInvalid) {
            firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    }
});

// 입력 시 에러 상태 제거
document.querySelectorAll('.form-control').forEach(input => {
    input.addEventListener('input', function() {
        this.classList.remove('is-invalid');
    });
});

function fillDebugData(type) {
    // 1. 공통 필드 입력 (아이디, 비밀번호 등)
    document.getElementById('memId').value = type === 'MEMBER' ? 'hojin0202' : 'sonointer';
    document.getElementById('memPassword').value = 'qwer1234!';
    document.getElementById('passwordConfirm').value = 'qwer1234!';
    
    // 비밀번호 체크 함수들이 있다면 강제 호출 (UI 업데이트용)
    if(typeof checkRegisterPasswordStrength === 'function') checkRegisterPasswordStrength();
    if(typeof checkPasswordMatch === 'function') checkPasswordMatch();

    if (type === 'MEMBER') {
        // --- 일반회원 데이터 ---
        document.getElementById('memType').value = 'MEMBER';
        // 필드 노출 (전환 로직이 있다면 호출)
        document.getElementById('personalFields').style.display = 'block';
        document.getElementById('businessFields').style.display = 'none';

        document.getElementById('memName').value = '안호진';
        document.getElementById('nickname').value = '호빵';
        document.getElementById('zip').value = '34908';
        document.getElementById('addr1').value = '대전 중구 계룡로 846 4층';
        document.getElementById('addr2').value = '403호';
        document.getElementById('tel').value = '01012345678';
        document.getElementById('memEmail').value = 'etlz1323@gmail.com';
        document.getElementById('birthDate').value = '1995-02-02';
        
        // 성별 라디오 버튼 선택 (남성)
        const genderRadio = document.querySelector('input[name="memUser.gender"][value="M"]');
        if(genderRadio) genderRadio.checked = true;

    } else if (type === 'COMPANY') {
        // --- 기업회원 데이터 ---
        document.getElementById('memType').value = 'COMPANY'; // hidden 값 변경
        // 필드 노출
        document.getElementById('personalFields').style.display = 'none';
        document.getElementById('businessFields').style.display = 'block';

        // 기업 정보
        document.getElementById('companyName').value = '(주)소노인터내셔널';
        document.getElementById('industryCd').value = '휴양 콘도미니엄업';
        document.getElementById('businessNo').value = '2208115022';
        document.getElementById('ceoName').value = '서준혁';
        document.getElementById('ecommerceNo').value = '제2024-강원홍천-0011호';
        document.getElementById('companyPhone').value = '15884888';
        document.getElementById('companyPostcode').value = '25102';
        document.getElementById('companyAddress').value = '강원특별자치도 홍천군 서면 한치골길 262';
        document.getElementById('companyAddressDetail').value = '비발디파크';
        document.getElementById('companyWebsite').value = 'https://www.sonohotelsresorts.com';
        document.getElementById('companyDescription').value = '연과 하나되는 최고의 휴식처, 국내 최대 규모의 리조트 네트워크를 자랑합니다.';

        // 담당자 정보
        document.getElementById('managerName').value = '김모행';
        document.getElementById('managerPhone').value = '01098765432';
        document.getElementById('managerEmail').value = 'sono_reserve@sono.com';

        // 계좌 정보
        document.getElementById('bankName').value = '우리은행';
        document.getElementById('accountNumber').value = '1002999888777';
        document.getElementById('accountHolder').value = '(주)소노인터내셔널';
    }
}

function resetForm() {
    document.getElementById('registerForm').reset();
}

</script>
<%-- <c:set var="pageJs" value="member" /> --%>
<%@ include file="../common/footer.jsp" %>