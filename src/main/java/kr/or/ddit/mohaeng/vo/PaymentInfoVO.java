package kr.or.ddit.mohaeng.vo;

import java.time.OffsetDateTime;

import lombok.Data;

@Data
public class PaymentInfoVO {
	// 결제 상세정보
	
	private int payNo; 				// 결제키
	private String tid; 			// 거래고유번호
	private String payMethodType; 	// 결제상세수단
	private String cardCorpCode; 	// 카드사코드
	private String authNo; 			// 승인번호
	private String vbankNum; 		// 가상계좌번호
	private OffsetDateTime vbankExpDt; 		// 가상계좌만료일
	private String resCode; 		// 응답코드
	private String resMsg; 			// 결제결과 메시지
	private String payRawData; 		// 전체응답전문
}
