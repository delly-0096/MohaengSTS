package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class RoomVO {

	/**
	 * 객실 정보 키
	 */
	private int roomInfoNo;
	/**
	 * 객실타입키
	 */
	private int roomTypeNo; 
	/**
	 * 숙소키
	 */	
	private int accNo; 
	/**
	 * 객실사용가능여부(Y/N)
	 */
	private String useUn;
}
