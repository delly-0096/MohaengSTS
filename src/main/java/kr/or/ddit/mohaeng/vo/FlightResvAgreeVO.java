package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class FlightResvAgreeVO {
	// 항공이용약관 동의
	
	private int reserveNo;              // 항공예약키
	private String ticketPurchAgreeYn;  // 구매 약관 동의 여부 (Y/N)
	private String privacyCollAgreeYn;  // 개인정보 관련 동의 여부
	private String cancelRefundAgreeYn; // 규정 확인 동의 여부
	private String mktRecvAgreeYn;      // 마케팅 활용 동의 여부
	private Date regDtA;				// 등록일자
}
