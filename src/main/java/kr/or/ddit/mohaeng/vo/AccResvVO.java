package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class AccResvVO {

	/**
	 * 예약인원
	 */
	private int resvCnt; /*  */
	/**
	 * 예약일시
	 */	
	private Date regDt; 
	/**
	 * 객실예약키
	 */
	private int accResvNo; 
	/**
	 * 객실타입키
	 */
	private int roomTypeNo; 
	/**
	 * 예약자키
	 */
	private int resvMemNo;
	/**
	 * 숙박시작일
	 */
	private Date startDt; 
	/**
	 * 숙박종료일
	 */
	private Date endDt;
	/**
	 * 숙박일수
	 */
	private int stayDays; 
	/**
	 * 예약상태
	 */
	private String ResvStatus;
}
