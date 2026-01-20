package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AccOptionVO {

	/**
	 * 추가옵션키
	 */
	private int accOptionNo; 
	/**
	 * 숙소 키
	 */
	private int accNo;
	/**
	 * 추가 옵션 명
	 */
	private String accOptionNm; 
	/**
	 * 옵션 별 금액
	 */
	private int accOptionPrice; 
	/**
	 * 옵션 사용 인원단위
	 */
	private int personnelCount; 
}
