package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class RoomFeatureVO {

	/**
	 * 객실타입키
	 */
	private int roomTypeNo;
	/**
	 * 무료 취소 가능 여부 (Y/N)
	 */	
	private String freeCancelYn;
	/**
	 * 바다 전망 여부 (Y/N)
	 */
	private String oceanViewYn; 
	/**
	 *  산 전망 여부 (Y/N)
	 */
	private String mountainViewYn;
	/**
	 * 도시 전망 여부(Y/N)
	 */
	private String cityViewYn; 
	/**
	 * 거실 공간 유무 (Y/N)
	 */
	private String livingRoomYn; 
	/**
	 * 테라스/발코니 유무 (Y/N)
	 */
	private String terraceYn; 
	/**
	 * 금연 객실 여부 (Y/N)
	 */
	private String nonSmokingYn;
	/**
	 * 취사 가능 여부 (Y/N)
	 */
	private String kitchenYn;
}
