package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class RoomFacilityVO {

	/**
	 * 객실 타입 키
	 */
	private int roomTypeNo;
	/**
	 * 에어컨유무(Y,N)
	 */
	private String airConYn; 
	/**
	 * TV 유무(Y,N)
	 */	
	private String tvYn;
	/**
	 * 미니바 유무(Y,N)
	 */
	private String minibarYn; 
	/**
	 *  냉장고 유무(Y,N)
	 */
	private String fridgeYn; 
	/**
	 *  금고 유무(Y,N)
	 */
	private String safeBoxYn;
	/**
	 *  헤어드라이 유무(Y,N)
	 */
	private String hairDryerYn;
	/**
	 * 욕조 유무(Y,N)
	 */
	private String bathtubYn; 
	/**
	 * 세면도구 유무(Y,N) 
	 */
	private String toiletriesYn; 
}
