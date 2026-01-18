package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AccFacilityVO {

	/**
	 * 숙소키
	 */
	private int accNo; 
	/**
	 * WiFi 제공 여부
	 */
	private String wifiYn;
	/**
	 * 주차 가능 여부
	 */
	private String parkingYn; 
	/**
	 *  조식 제공 여부
	 */
	private String breakfastYn; 
	/**
	 * 수영장 유무
	 */
	private String poolYn; 
	/**
	 * 헬스장/피트니스 유무
	 */
	private String gymYn; 
	/**
	 *  스파 시설 유무
	 */
	private String spaYn; 
	/**
	 * 내부 식당 유무
	 */
	private String restaurantYn;
	/**
	 * 바/라운지 유무
	 */
	private String barYn;
	/**
	 *  룸서비스 가능 여부
	 */
	private String roomServiceYn; 
	/**
	 * 세탁 서비스 제공 여부
	 */
	private String laundryYn;
	/**
	 * 지정 흡연구역 유무
	 */
	private String smokingAreaYn; 
	/**
	 * 반려동물 입실 가능 여부
	 */
	private String petFriendlyYn;
}
