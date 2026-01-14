<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="결제 완료" />
<c:set var="pageCss" value="product" />

<%@ include file="../common/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/product.css">

<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="user" />
</sec:authorize>

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
            <div class="booking-step">
                <div class="step-icon">3</div>
                <span>완료</span>
            </div>
        </div>
		
		<c:set var="error" value="${error}" />
		
		<c:if test="${empty error }">
			<input type="hidden" id="paymentType" value="${paymentType }"/>	
			<input type="hidden" id="orderId" value="${orderId }"/>	
			<input type="hidden" id="paymentKey" value="${paymentKey }"/>	
			<input type="hidden" id="amount" value="${amount }"/>	
		</c:if>
		
		<div id="payment-loading" class="text-center py-5">
            <div class="spinner-border text-primary"></div>
            <p>결제 승인 요청 중...</p>
        </div>
		
        <!-- 결제 완료 -->
        <c:if test="${empty error }">
        <div class="payment-complete">
            <div class="complete-icon">
                <i class="bi bi-check-lg"></i>
            </div>
            <h1 class="complete-title">결제가 완료되었습니다!</h1>
            <p class="complete-message">
                결제 확인 메일이 <strong id="memEmail">이메일</strong>으로 발송되었습니다.<br>
                즐거운 여행 되세요!
            </p>

            <div class="complete-details">
                <h4>결제 상세</h4>
                <div class="detail-row">
                    <span class="label">결제번호</span>
                    <span class="value"><strong id="payNo"> </strong></span>
                </div>
                <div class="detail-row">
                    <span class="label">상품명</span>
                    <span class="value" id="orderName"> </span>
                </div>
                <div class="detail-row">
                    <span class="label">이용일시</span>
                    <span class="value" id="payDt"> </span>
                </div>
                <div class="detail-row">
                    <span class="label">인원</span>
                    <span class="value" id="person"> 명</span>
                </div>
                <div class="detail-row">
                    <span class="label">결제금액</span>
                    <span class="value"><strong class="text-primary" id="totalAmount"> </strong>원</span>
                </div>
                <div class="detail-row">
                    <span class="label">결제수단</span>
                    <span class="value" id="method"> </span>
                </div>
            </div>
<!--        
			상품 결제시
		    <div class="alert alert-warning mb-4">
                <i class="bi bi-exclamation-triangle me-2"></i>
                <strong>이용 안내</strong>
                <ul class="mb-0 mt-2 ps-3">
                    <li>예약 시간 10분 전까지 현장에 도착해주세요.</li>
                    <li>수영복, 타월을 지참해주세요.</li>
                    <li>기상 악화 시 일정이 변경될 수 있습니다.</li>
                </ul>
            </div> -->

            <div class="complete-actions">
                <a href="${pageContext.request.contextPath}/mypage/payments" class="btn btn-outline btn-lg">
                    <i class="bi bi-receipt me-2"></i>결제 내역 보기
                </a>
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg">
                    <i class="bi bi-house me-2"></i>홈으로
                </a>
            </div>
        </div>
       
        
    	<!--  결제 실패 시 구간 만들기 -->
		<div class="payment-fail" style="display: none">
            <div class="complete-icon">
      		    <i class="bi bi-check-lg"></i>
            </div>
            <h1 class="fail-title">결제가 실패되었습니다</h1>
            <hr/>
            <p class="fail-message"></p>
			<div class="fail-details">
				<div detail-row>
					<span class="label"></span>
					<span class="value" id="failCode">ㅇㅇ</span>
					${code }
				</div>
				<div detail-row>
				<!-- 						<span class="label">상품명</span>
										<span class="value" id=""></span> -->
	<%-- 			${code } --%>
				</div>
				<div>${orderId }</div>
			</div>
		</div>
		 </c:if>
		
		<c:if test="${not empty error }">
		</c:if>
    </div>
</div>


<script>
let loading = null;

let paymentKey = null;
let orderId = null;
let amount = 0;
let paymentType = null;

// 예약 세션 스토리지 가져올 객체 
let storedData = null;

let flightProduct = null;	// 항공 product storage
let passengers = null;

document.addEventListener("DOMContentLoaded", async function(){
	// api용
	paymentKey = document.querySelector("#paymentKey");
	orderId = document.querySelector("#orderId");
	amount = document.querySelector("#amount");
	paymentType = document.querySelector("#paymentType");
	loading = document.querySelector("#payment-loading");
	
	// db에 넣을 정보
	flightProduct = sessionStorage.getItem("flightProduct");
	passengers = sessionStorage.getItem("passengers");
	reservationList = sessionStorage.getItem("reservationList");
	reserveAgree = sessionStorage.getItem("reserveAgree");
	console.log("flightProduct : ", flightProduct);
	console.log("passengers : ", passengers);
	console.log("reservationList : ", reservationList);
	console.log("reserveAgree : ", reserveAgree);
	
	let payNo = document.querySelector("#payNo");
	let orderName = document.querySelector("#orderName");
	let payDt = document.querySelector("#payDt");
	let person = document.querySelector("#person");
	let totalAmount = document.querySelector("#totalAmount");
	let method = document.querySelector("#method");
	let memEmail = document.querySelector("#memEmail");

	let failCode = document.querySelector("#failCode");
	let message = document.querySelector(".fail-message");
	
	if('${error}' != "error"){
		console.log("user.username : ", "${user.username}");
		const userData = await fetch("/product/flight/user", {
			method : "post",
			headers : {"Content-Type" : "application/json"},
			body : JSON.stringify({memId : "${user.username}"})
		});
		
		console.log("userData : ", userData);
		const customData = await userData.json();
		console.log("customData : ", customData);
		
	    memEmail.innerHTML = customData.memEmail;	// 결제자 이메일 정보 

		if(flightProduct) flightProduct = JSON.parse(flightProduct); 
		
		if(passengers) passengers = JSON.parse(passengers);
		
		if(reservationList) reservationList = JSON.parse(reservationList);
		
		if(reserveAgree) reserveAgree = JSON.parse(reserveAgree);
		
		const requestData = {
	        paymentKey: paymentKey.value,
	        orderId: orderId.value,
	        amount: amount.value,
	        paymentType : paymentType.value,
	        memNo : customData.memNo,
	        flightProductList : flightProduct != null ? flightProduct.flights : null,
	        flightPassengersList : passengers != null ? passengers : null,
       		flightReservationList : reservationList != null ? reservationList : null,
       		flightResvAgree : reserveAgree != null ? reserveAgree : null,
    		productType : "flight"
	    };
		
		console.log("requestData ", requestData);
		
		const response = await fetch("/product/payment/confirm", {
			method : "post",
			headers : {"Content-Type" : "application/json"},
			body : JSON.stringify(requestData)
		});
		
		console.log("response : ", response);
		
	    const resultData = await response.json(); 
		if (response.ok) {
		    console.log("서버에서 받은 API 결과값:", resultData);
		    
			payNo.innerHTML = resultData.orderId;
			orderName.innerHTML = resultData.orderName;

			// 시간 
			const date = new Date(resultData.approvedAt);
			const formattedDate = new Intl.DateTimeFormat('ko-KR', {
			  year: 'numeric',
			  month: 'long',
			  day: 'numeric',
			  weekday: 'long',
			  hour: '2-digit',
			  minute: '2-digit',
			  hour12: true
			}).format(date);

			console.log(formattedDate);
			payDt.innerHTML = formattedDate;
			
			let personParts = [];

			if (resultData.adult) personParts.push(resultData.adult);
			if (resultData.child) personParts.push(resultData.child);
			if (resultData.infant) personParts.push(resultData.infant);

			let personCount = personParts.join(", ");
		    person.innerHTML = personCount;
		    
			totalAmount.innerHTML = (resultData.totalAmount).toLocaleString();
			
			if (resultData.method == '간편결제'){
				method.innerHTML = resultData.easyPay.provider;
			} else{
				method.innerHTML = resultData.method;
			}
		} else {
			// 다시 처리
			alert("이미 처리된 결제 입니다.");
			window.location.href = "/product/flight"
			
			resultData.code;
			document.querySelector(".payment-fail").style.display = "block";
			document.querySelector(".payment-complete").style.display = "none";
			failCode.innerHTML = resultData.code; 
			message.innerHTML = resultData.message; 
			
		    console.error("결제 승인 실패");
		}
		loading.style.display = "none";
		
	}else{
		console.log("error 발생");
		console.log('${error}', '${code}');
		loading.style.display = "none";
		window.location.href = "/product/flight"
	}
});
</script>


<%-- <c:set var="pageJs" value="product" /> --%>
<%@ include file="../common/footer.jsp" %>
