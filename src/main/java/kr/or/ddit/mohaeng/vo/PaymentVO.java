package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class PaymentVO {
	// 결제
	
	private String payNo; 		// 결제키
	private int memNo; 			// 회원키
	private int payTotalAmt; 	// 결제금액
	private int usePoint;		// 사용포인트
	private String payMethodCd; // 공통코드
	private Date payDt; 		// 결제일시
	private String payStatus; 	// 결제상태(Y,N,WAIT)
	private Date cancelDt; 		// 취소일시
	private String cancelReason;// 취소사유
	
	// 토스 api용 변수
	private int amount; 		// 가격
	private String orderId;		// 주문
	private String paymentKey;	// payment 키
}
