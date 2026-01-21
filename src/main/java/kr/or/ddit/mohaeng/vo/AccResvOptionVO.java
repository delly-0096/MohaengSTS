package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AccResvOptionVO {

	/**
	 * 객실 예약 키
	 */
	private int accResvNo; 
	/**
	 * 추가 옵션 키
	 */
	private int accOptionNo; 
	
	
	private String accOptionNm;    // 옵션 이름 (JOIN용)
    private int accOptionPrice;    // 옵션 가격 (JOIN용)
}
