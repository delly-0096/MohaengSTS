package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class AccResvAgreeVO {

	/**
	 * 객실예약키
	 */
	private int accResvNo;
	/**
	 *  숙박 이용약관 동의 여부 (Y/N)
	 */	
	private String stayTermYn;
	/**
	 * 개인정보 수집 및 이용 동의 여부 (Y/N)
	 */
	private String privacyAgreeYn; 
	/**
	 *  취소 및 환불 규정 동의 여부 (Y/N)
	 */
	private String refundAgreeYn; 
	/**
	 * 마케팅 정보 수신 동의 여부 (Y/N) 
	 */
	private String marketAgreeYn; 
	/**
	 * 동의 일시 및 등록 시간
	 */
	private Date regDt;
}
