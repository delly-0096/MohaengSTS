<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="글쓰기 - 여행톡" />
<c:set var="pageCss" value="community" />

<%@ include file="../common/header.jsp" %>

<div class="community-page">
    <div class="container">
        <!-- 헤더 -->
        <div class="community-header">
            <h1><i class="bi bi-pencil-square me-3"></i>글쓰기</h1>
            <p>여행 이야기를 자유롭게 나눠보세요</p>
        </div>

        <!-- 글쓰기 폼 -->
        <div class="write-container">
            <form id="writeForm" class="write-form">
                <!-- 말머리 선택 -->
                <div class="form-group">
                    <label class="form-label">말머리 <span class="text-danger">*</span></label>
                    <select class="form-control form-select" id="category" name="category" required>
                        <option value="">말머리를 선택하세요</option>
                        <option value="free">자유게시판</option>
                        <option value="companion">동행 구하기</option>
                        <option value="info">정보 공유</option>
                        <option value="qna">여행 Q&A</option>
                        <option value="review">후기</option>
                    </select>
                </div>

                <!-- 제목 -->
                <div class="form-group">
                    <label class="form-label">제목 <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="title" name="title"
                           placeholder="제목을 입력하세요" maxlength="100" required>
                    <small class="text-muted"><span id="titleCount">0</span>/100</small>
                </div>

                <!-- 동행 구하기 추가 정보 -->
                <div id="companionInfo" class="companion-info" style="display: none;">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-label">여행 지역</label>
                                <input type="text" class="form-control" id="destination" name="destination"
                                       placeholder="예: 제주도, 오사카">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-label">여행 기간</label>
                                <input type="text" class="form-control date-range-picker" id="travelDate" name="travelDate"
                                       placeholder="여행 날짜 선택">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-label">모집 인원</label>
                                <select class="form-control form-select" id="memberCount" name="memberCount">
                                    <option value="">선택</option>
                                    <option value="1">1명</option>
                                    <option value="2">2명</option>
                                    <option value="3">3명</option>
                                    <option value="4">4명 이상</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 내용 -->
                <div class="form-group">
                    <label class="form-label">내용 <span class="text-danger">*</span></label>
                    <textarea class="form-control" id="content" name="content" rows="15"
                              placeholder="내용을 입력하세요" required></textarea>
                    <small class="text-muted"><span id="contentCount">0</span>자</small>
                </div>

                <!-- 파일 첨부 -->
                <div class="form-group">
                    <label class="form-label">파일 첨부</label>
                    <div class="file-upload-area" id="fileUploadArea">
                        <input type="file" id="fileInput" name="files" multiple accept="image/*" style="display: none;">
                        <div class="file-upload-placeholder" onclick="document.getElementById('fileInput').click()">
                            <i class="bi bi-cloud-upload"></i>
                            <p>클릭하여 이미지를 업로드하거나<br>이미지를 드래그하세요</p>
                            <small>JPG, PNG, GIF (최대 10MB, 5개까지)</small>
                        </div>
                    </div>
                    <div class="file-preview-list" id="filePreviewList"></div>
                </div>

                <!-- 태그 -->
                <div class="form-group">
                    <label class="form-label">태그</label>
                    <input type="text" class="form-control" id="tags" name="tags"
                           placeholder="태그를 입력하고 Enter를 누르세요">
                    <div class="tag-list" id="tagList"></div>
                    <small class="text-muted">최대 5개까지 등록 가능</small>
                </div>

                <!-- 버튼 -->
                <div class="write-actions">
                    <button type="button" class="btn btn-outline" onclick="cancelWrite()">취소</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-2"></i>등록하기
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
// 말머리 변경 시 동행 구하기 추가 정보 표시
document.getElementById('category').addEventListener('change', function() {
    const companionInfo = document.getElementById('companionInfo');
    if (this.value === 'companion') {
        companionInfo.style.display = 'block';
    } else {
        companionInfo.style.display = 'none';
    }
});

// 제목 글자수 카운트
document.getElementById('title').addEventListener('input', function() {
    document.getElementById('titleCount').textContent = this.value.length;
});

// 내용 글자수 카운트
document.getElementById('content').addEventListener('input', function() {
    document.getElementById('contentCount').textContent = this.value.length;
});

// 태그 입력
const tagList = [];
document.getElementById('tags').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        const tag = this.value.trim();

        if (tag && tagList.length < 5 && !tagList.includes(tag)) {
            tagList.push(tag);
            renderTags();
            this.value = '';
        } else if (tagList.length >= 5) {
            showToast('태그는 최대 5개까지 등록 가능합니다.', 'warning');
        } else if (tagList.includes(tag)) {
            showToast('이미 등록된 태그입니다.', 'warning');
        }
    }
});

function renderTags() {
    const container = document.getElementById('tagList');
    container.innerHTML = tagList.map((tag, index) =>
        '<span class="tag-item">#' + tag +
        '<button type="button" onclick="removeTag(' + index + ')"><i class="bi bi-x"></i></button></span>'
    ).join('');
}

function removeTag(index) {
    tagList.splice(index, 1);
    renderTags();
}

// 파일 업로드
const fileInput = document.getElementById('fileInput');
const fileUploadArea = document.getElementById('fileUploadArea');
const filePreviewList = document.getElementById('filePreviewList');
let selectedFiles = [];

fileInput.addEventListener('change', function() {
    handleFiles(this.files);
});

// 드래그 앤 드롭
fileUploadArea.addEventListener('dragover', function(e) {
    e.preventDefault();
    this.classList.add('dragover');
});

fileUploadArea.addEventListener('dragleave', function(e) {
    e.preventDefault();
    this.classList.remove('dragover');
});

fileUploadArea.addEventListener('drop', function(e) {
    e.preventDefault();
    this.classList.remove('dragover');
    handleFiles(e.dataTransfer.files);
});

function handleFiles(files) {
    const maxFiles = 5;
    const maxSize = 10 * 1024 * 1024; // 10MB

    Array.from(files).forEach(file => {
        if (selectedFiles.length >= maxFiles) {
            showToast('파일은 최대 5개까지 첨부 가능합니다.', 'warning');
            return;
        }

        if (file.size > maxSize) {
            showToast(file.name + '의 크기가 10MB를 초과합니다.', 'error');
            return;
        }

        if (!file.type.startsWith('image/')) {
            showToast('이미지 파일만 업로드 가능합니다.', 'error');
            return;
        }

        selectedFiles.push(file);
        addFilePreview(file, selectedFiles.length - 1);
    });
}

function addFilePreview(file, index) {
    const reader = new FileReader();
    reader.onload = function(e) {
        const preview = document.createElement('div');
        preview.className = 'file-preview-item';
        preview.innerHTML =
            '<img src="' + e.target.result + '" alt="' + file.name + '">' +
            '<button type="button" class="remove-btn" onclick="removeFile(' + index + ')">' +
            '<i class="bi bi-x"></i></button>' +
            '<span class="file-name">' + file.name + '</span>';
        filePreviewList.appendChild(preview);
    };
    reader.readAsDataURL(file);
}

function removeFile(index) {
    selectedFiles.splice(index, 1);
    renderFilePreviews();
}

function renderFilePreviews() {
    filePreviewList.innerHTML = '';
    selectedFiles.forEach((file, index) => {
        addFilePreview(file, index);
    });
}

// 폼 제출
document.getElementById('writeForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const category = document.getElementById('category').value;
    const title = document.getElementById('title').value.trim();
    const content = document.getElementById('content').value.trim();

    if (!category) {
        showToast('말머리를 선택해주세요.', 'error');
        return;
    }

    if (!title) {
        showToast('제목을 입력해주세요.', 'error');
        return;
    }

    if (!content) {
        showToast('내용을 입력해주세요.', 'error');
        return;
    }

    // 실제 구현 시 FormData로 서버 전송
    showToast('게시글이 등록되었습니다.', 'success');

    setTimeout(() => {
        window.location.href = '${pageContext.request.contextPath}/community/talk';
    }, 1000);
});

// 취소
function cancelWrite() {
    if (confirm('작성 중인 내용이 저장되지 않습니다.\n정말 취소하시겠습니까?')) {
        window.location.href = '${pageContext.request.contextPath}/community/talk';
    }
}
</script>

<%@ include file="../common/footer.jsp" %>
