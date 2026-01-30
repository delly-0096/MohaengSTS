<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<c:set var="pageTitle" value="1:1 문의" />
<c:set var="pageCss" value="support" />
<c:set var="newLine" value="
" />

<%@ include file="../common/header.jsp" %>

<div class="support-page">
    <div class="container">
        <!-- 헤더 -->
        <div class="support-header">
            <h1><i class="bi bi-chat-dots me-3"></i>1:1 문의</h1>
            <p>궁금한 점이 있으시면 문의해주세요</p>
        </div>

        <!-- 고객지원 네비게이션 -->
        <div class="support-nav">
            <a href="${pageContext.request.contextPath}/support/faq" class="support-nav-item">
                <i class="bi bi-question-circle me-2"></i>FAQ
            </a>
            <a href="${pageContext.request.contextPath}/support/notice" class="support-nav-item">
                <i class="bi bi-megaphone me-2"></i>공지사항
            </a>
            <a href="${pageContext.request.contextPath}/support/inquiry" class="support-nav-item active">
                <i class="bi bi-chat-dots me-2"></i>1:1 문의
            </a>
        </div>

        <div class="inquiry-container">
            <!-- 탭 -->
            <div class="inquiry-tabs">
                <button class="inquiry-tab ${currentTab == 'history' ? 'active' : ''}" data-tab="history">문의 내역</button>
                <button class="inquiry-tab ${currentTab == 'write' ? 'active' : ''}" data-tab="write">문의 작성</button>
            </div>


            <!-- 문의 작성 폼 -->
            <div class="inquiry-content-area" id="writeTab" style="display: ${currentTab == 'write' ? 'block' : 'none'};">
                <div class="inquiry-form">
                    <h3><i class="bi bi-pencil me-2"></i>문의하기
                    	<!-- 디버그 버튼 -->
		                 <button type="button" onclick="fillInquiryData()"
					            style="width: 110px; height: 35px; border-radius: 6px; border: none; background: rgba(0, 0, 0, 0); color: #EFF1F2; font-size: 11px; cursor: pointer; transition: 0.2s;"
					            title="문의 내용 자동 입력">
					        문의
					    </button>
                    </h3>

                    <form id="inquiryForm" enctype="multipart/form-data">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">문의 유형 <span class="text-danger">*</span></label>
                                    <select class="form-control form-select" id="inqryCtgryCd" required>
                                        <option value="">선택해주세요</option>
                                        <c:forEach var="category" items="${categoryList}">
                                            <option value="${category.cd}">${category.cdName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">관련 예약번호 (선택)</label>
                                    <input type="text" class="form-control" id="inquiryTargetNo" placeholder="예약번호가 있다면 입력해주세요">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">제목 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="inqryTitle" placeholder="문의 제목을 입력해주세요" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">문의 내용 <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="inqryCn" rows="8" placeholder="문의하실 내용을 상세히 작성해주세요" required></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label">첨부파일 (선택)</label>
                            <input type="file" class="form-control" id="attachFile" multiple accept="image/*,.pdf,.doc,.docx">
                            <!--div 추가함  -->
                            <div id="filePreviewContainer" class="mt-3 d-flex flex-wrap gap-2"></div>
                            <small class="text-muted">최대 5개, 각 10MB 이하 (이미지, PDF, DOC 파일)</small>
                        </div>

                        <div class="form-group">
                            <label class="form-label">답변 받을 이메일 <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="inqryEmail" value="${loginEmail}" placeholder="이메일을 입력해주세요" required>
                            <small class="text-muted">답변 알림이 발송됩니다.</small>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="agreePrivacy" required>
                            <label class="form-check-label" for="agreePrivacy">
                                개인정보 수집 및 이용에 동의합니다. <a href="#" class="text-primary">내용 보기</a>
                            </label>
                        </div>

                        <button type="submit" class="btn btn-primary btn-lg w-100">
                            <i class="bi bi-send me-2"></i>문의 등록
                        </button>
                    </form>

                    <div class="alert alert-info mt-4">
                        <i class="bi bi-info-circle me-2"></i>
                        <strong>안내사항</strong>
                        <ul class="mb-0 mt-2 ps-3">
                            <li>문의 답변은 평일 09:00~18:00에 순차적으로 처리됩니다.</li>
                            <li>주말 및 공휴일에 접수된 문의는 다음 영업일에 답변됩니다.</li>
                            <li>긴급 문의는 AI 챗봇을 이용해주세요.</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- 문의 내역 -->
            <div class="inquiry-content-area" id="historyTab" style="display: ${currentTab == 'history' ? 'block' : 'none'};">
                <c:choose>
                    <c:when test="${not empty sessionScope.loginMember}">
                        <!-- 카테고리 필터 -->
                        <div class="faq-categories mb-4">
                            <button class="faq-category ${empty currentCategory || currentCategory == 'all' ? 'active' : ''}"
                                    onclick="changeCategory('all')">전체</button>
                            <c:forEach var="category" items="${categoryList}">
                                <button class="faq-category ${currentCategory == category.cd ? 'active' : ''}"
                                        onclick="changeCategory('${category.cd}')">${category.cdName}</button>
                            </c:forEach>
                        </div>

                        <div class="inquiry-list">
                            <c:choose>
                                <c:when test="${empty inquiryList}">
                                    <div class="text-center py-5" style="color: #999;">
                                        <i class="bi bi-inbox" style="font-size: 48px;"></i>
                                        <p class="mt-3">문의 내역이 없습니다.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="inquiry" items="${inquiryList}">
                                        <!-- 문의 아이템 -->
                                        <div class="inquiry-item">
                                            <div class="inquiry-item-header">
                                                <div class="inquiry-item-info">
                                                    <h4 class="inquiry-item-title">${inquiry.inqryTitle}</h4>
                                                    <div class="inquiry-item-meta">
                                                        <span class="badge bg-secondary me-2">${inquiry.categoryName}</span>
                                                        ${inquiry.regDtStr}
                                                    </div>
                                                </div>
                                                <c:choose>
                                                    <c:when test="${inquiry.inqryStatus == 'answered'}">
                                                        <span class="inquiry-status answered">답변완료</span>
                                                    </c:when>
                                                    <c:when test="${inquiry.inqryStatus == 'waiting'}">
                                                        <span class="inquiry-status waiting">답변대기</span>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                            <div class="inquiry-item-body">
                                                <div class="inquiry-content">
                                                    <div class="inquiry-content-label">문의 내용</div>
                                                    <p>${fn:replace(inquiry.inqryCn, newLine, '<br>')}</p>
                                                </div>
                                                <!--첨부파일  -->
												<div class="attachArea" data-inqry-no="${inquiry.inqryNo}"></div>

                                                <c:if test="${inquiry.inqryStatus == 'answered' && not empty inquiry.replyCn}">
                                                    <div class="inquiry-answer">
                                                        <div class="inquiry-content-label">답변 (${inquiry.replyDtStr})</div>
                                                        <p>${fn:replace(inquiry.replyCn, newLine, '<br>')}</p>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- 페이지네이션 -->
                        <c:if test="${totalPages > 0}">
                            <div class="pagination-container">
                                <nav>
                                    <ul class="pagination">
                                        <!-- 이전 페이지 -->
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="javascript:goToPage(${currentPage - 1})">
                                                <i class="bi bi-chevron-left"></i>
                                            </a>
                                        </li>

                                        <!-- 페이지 번호 -->
                                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                            <li class="page-item ${currentPage == pageNum ? 'active' : ''}">
                                                <a class="page-link" href="javascript:goToPage(${pageNum})">${pageNum}</a>
                                            </li>
                                        </c:forEach>

                                        <!-- 다음 페이지 -->
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="javascript:goToPage(${currentPage + 1})">
                                                <i class="bi bi-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="bi bi-lock" style="font-size: 64px; color: var(--gray-light);"></i>
                            <h4 class="mt-3">로그인이 필요합니다</h4>
                            <p class="text-muted mb-4">문의 내역을 확인하려면 로그인해주세요.</p>
                            <a href="${pageContext.request.contextPath}/member/login" class="btn btn-primary">
                                <i class="bi bi-box-arrow-in-right me-2"></i>로그인
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>

// 탭 전환 함수
function switchTab(tabName) {
    const url = '${pageContext.request.contextPath}/support/inquiry';
    const params = new URLSearchParams();
    params.append('tab', tabName);

    // 현재 카테고리 유지
    if (tabName === 'history') {
        params.append('category', '${currentCategory}');
        params.append('page', '${currentPage}');
    }

    window.location.href = url + '?' + params.toString();
}

// 페이지 로드 시 URL 해시 확인
document.addEventListener('DOMContentLoaded', function() {
    if (window.location.hash === '#write') {
        switchTab('write');
    }
});

// 탭 클릭 이벤트
document.querySelectorAll('.inquiry-tab').forEach(tab => {
    tab.addEventListener('click', function() {
        const tabName = this.dataset.tab;
        switchTab(tabName);
    });
});

// 문의 아코디언
document.querySelectorAll('.inquiry-item-header').forEach(header => {
    header.addEventListener('click', function() {
        const item = this.closest('.inquiry-item');
        item.classList.toggle('active');
    });
});

// 카테고리 변경
function changeCategory(category) {
    const url = '${pageContext.request.contextPath}/support/inquiry';
    const params = new URLSearchParams();
    params.append('tab', 'history');
    params.append('category', category);
    params.append('page', '1');
    window.location.href = url + '?' + params.toString();
}

// 페이지 이동
function goToPage(page) {
    if (page < 1 || page > ${totalPages}) return;

    const url = '${pageContext.request.contextPath}/support/inquiry';
    const params = new URLSearchParams();
    params.append('tab', 'history');
    params.append('category', '${currentCategory}');
    params.append('page', page);
    window.location.href = url + '?' + params.toString();
}

// 문의 등록 폼
// 수정된 코드
document.getElementById('inquiryForm').addEventListener('submit', function(e) {
    e.preventDefault();

    // 로그인 체크
    const isLoggedIn = ${not empty sessionScope.loginMember};
    if (!isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
            sessionStorage.setItem('returnUrl', window.location.href);
            window.location.href = '${pageContext.request.contextPath}/member/login';
        }
        return;
    }

    // FormData 사용 (파일 포함)
    const formData = new FormData();
    formData.append('inqryCtgryCd', document.getElementById('inqryCtgryCd').value);
    formData.append('inqryTitle', document.getElementById('inqryTitle').value);
    formData.append('inqryCn', document.getElementById('inqryCn').value);
    formData.append('inqryEmail', document.getElementById('inqryEmail').value);

    const targetNo = document.getElementById('inquiryTargetNo').value;
    if (targetNo) {
        formData.append('inquiryTargetNo', targetNo);
    }

    // ✅ selectedFiles 배열에서 파일 추가
    if (selectedFiles.length > 0) {
        selectedFiles.forEach(file => {
            formData.append('files', file);
        });
    }

    // AJAX 요청
    fetch('${pageContext.request.contextPath}/support/inquiry', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        console.log('detail response:', data);
        if (data.success) {
            alert(data.message);
            // ✅ 폼 제출 성공 후 selectedFiles 초기화
            selectedFiles = [];
            document.getElementById('filePreviewContainer').innerHTML = '';
            window.location.href = '${pageContext.request.contextPath}/support/inquiry?tab=history';
        } else {
            alert(data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('문의 등록 중 오류가 발생했습니다.');
    });
});
/*추가함  */
let selectedFiles = [];

document.getElementById('attachFile').addEventListener('change', function(e) {
    const container = document.getElementById('filePreviewContainer');
    const newFiles = Array.from(e.target.files);

    if (selectedFiles.length + newFiles.length > 5) {
        alert("파일은 최대 5개까지만 업로드 가능합니다.");
        e.target.value = "";
        return;
    }

    newFiles.forEach(file => {
        selectedFiles.push(file);
    });

    renderFilePreview();
    e.target.value = "";
});

// ✅ 파일 미리보기 렌더링 함수
function renderFilePreview() {
    const container = document.getElementById('filePreviewContainer');
    container.innerHTML = '';

    selectedFiles.forEach((file, index) => {
        const fileItem = document.createElement('div');
        fileItem.style.cssText = "width: 100px; position: relative; border: 1px solid #ddd; padding: 5px; border-radius: 5px; text-align: center;";

        // 삭제 버튼 추가
        const removeBtn = document.createElement('button');
        removeBtn.innerHTML = '×';
        removeBtn.type = 'button';
        removeBtn.style.cssText = "position: absolute; top: 0; right: 0; background: red; color: white; border: none; border-radius: 50%; width: 20px; height: 20px; cursor: pointer;";
        removeBtn.onclick = function() {
            selectedFiles.splice(index, 1);
            renderFilePreview();
        };
        fileItem.appendChild(removeBtn);

        // 이미지 미리보기
        if (file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = function(event) {
                const img = document.createElement('img');
                img.src = event.target.result;
                img.style.cssText = "width: 100%; height: 80px; object-fit: cover; border-radius: 3px;";
                fileItem.prepend(img);
            };
            reader.readAsDataURL(file);
        } else {
            const icon = document.createElement('div');
            icon.innerHTML = '<i class="bi bi-file-earmark-text" style="font-size: 2rem; color: #666;"></i>';
            fileItem.appendChild(icon);
        }

        const fileName = document.createElement('div');
        fileName.innerText = file.name;
        fileName.style.cssText = "font-size: 11px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-top: 5px;";
        fileItem.appendChild(fileName);

        container.appendChild(fileItem);
    });
}
 /*카피본  */
/*
document.getElementById('attachFile').addEventListener('change', function(e) {
    const container = document.getElementById('filePreviewContainer');
    container.innerHTML = ''; // 기존 미리보기 초기화

    const files = e.target.files;

    if (files.length > 5) {
        alert("파일은 최대 5개까지만 업로드 가능합니다.");
        this.value = ""; // 선택 초기화
        return;
    }

    Array.from(files).forEach((file, index) => {
        const reader = new FileReader();

        // 파일 아이템을 담을 div 생성
        const fileItem = document.createElement('div');
        fileItem.style.cssText = "width: 100px; position: relative; border: 1px solid #ddd; padding: 5px; border-radius: 5px; text-align: center;";

        // 이미지 파일인 경우 미리보기 생성
        if (file.type.startsWith('image/')) {
            reader.onload = function(event) {
                const img = document.createElement('img');
                img.src = event.target.result;
                img.style.cssText = "width: 100%; height: 80px; object-fit: cover; border-radius: 3px;";
                fileItem.prepend(img);
            };
            reader.readAsDataURL(file);
        } else {
            // 이미지가 아닌 경우 아이콘과 파일명 표시
            const icon = document.createElement('div');
            icon.innerHTML = '<i class="bi bi-file-earmark-text" style="font-size: 2rem; color: #666;"></i>';
            fileItem.appendChild(icon);
        }

        // 파일 이름 표시 (글씨)
        const fileName = document.createElement('div');
        fileName.innerText = file.name;
        fileName.style.cssText = "font-size: 11px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-top: 5px;";
        fileItem.appendChild(fileName);

        container.appendChild(fileItem);
    });
}); */

/*다운로드용  */
function loadAttachFiles(inqryNo, targetDiv) {

//    fetch(`${pageContext.request.contextPath}/support/inquiry/detail/${inqryNo}`)
      fetch(contextPath + '/support/inquiry/detail/' + inqryNo)
         .then(res => res.json())
         .then(data => {
        	 console.log('attachFiles:', data.inquiry.attachFiles);
        	 console.log(data.inquiry.attachFiles[0]);
             if (!data.success || !data.inquiry.attachFiles) return;

             let html = '<ul class="attachment-list">';

             data.inquiry.attachFiles.forEach((file) => {
            	 html += `
            		    <li>
            		        <span>\${file.FILE_ORIGINAL_NAME}</span>
            		        <a href="${contextPath}/support/inquiry/download?fileNo=\${file.FILE_NO}">
            		            [다운로드]
            		        </a>
            		    </li>
            		`;
             });
             html +='</ul>';
             targetDiv.innerHTML = html;
         });
}
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.attachArea').forEach(div => {
        const inqryNo = div.dataset.inqryNo;
        if (inqryNo) {
            loadAttachFiles(inqryNo, div);
        }
    });
});

/* 디버그 버튼 */
function fillInquiryData() {
    // 1. 문의 유형 (두 번째 옵션 선택 - 보통 '일반문의'나 '예약문의')
    const categorySelect = document.getElementById('inqryCtgryCd');
    if(categorySelect && categorySelect.options.length > 1) {
        categorySelect.selectedIndex = 2; 
    }
    
    // 2. 관련 예약번호
    document.getElementById('inquiryTargetNo').value = '';
    
    // 3. 제목
    document.getElementById('inqryTitle').value = '숙소 예약 후 일정 변경을 하려면 어떻게 해야 하나요';
    
    // 4. 내용
    document.getElementById('inqryCn').value = 
        "안녕하세요!\n" +
        "이번에 '모행'을 통해서 숙소를 예약했구요\n" +
        "혹시라도 일정이 변경되면 어떻게 해야하나 싶어서 문의 드립니다\n" +
        "답변 기다리겠습니다";
    
    // 5. 답변 받을 이메일 (값이 없을 때만 채움)
    const emailInput = document.getElementById('inqryEmail');
    if(!emailInput.value) {
        emailInput.value = 'romantic_dev@naver.com';
    }
    
    // 6. 개인정보 동의 체크
    const agreeCheck = document.getElementById('agreePrivacy');
    if(agreeCheck) {
        agreeCheck.checked = true;
    }
    
    console.log("Inquiry form filled successfully!");
}
</script>

<c:set var="pageJs" value="support" />
<%@ include file="../common/footer.jsp" %>