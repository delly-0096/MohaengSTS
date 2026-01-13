package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class RefundLogVO {
	// 환불
	
	private String refundNo; // 환불키
	private int payNo; // 결제키
	private int refundAmt; // 환불금액
	private Date regDt; // 환불일시
	private int refundPoint; // 환불포인트
}
