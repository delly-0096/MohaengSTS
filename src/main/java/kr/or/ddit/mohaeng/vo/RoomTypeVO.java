package kr.or.ddit.mohaeng.vo;

import java.util.List;

import lombok.Data;

@Data
public class RoomTypeVO {
	
	/**
	 * 할인율
	 */
	private int discount; 
	/**
	 * 기준인원수 초과비용
	 */	
	private int extraGuestFee;
	/**
	 * 기준값 m2
	 */
	private int roomSize; 
	/**
	 *  Y / N
	 */
	private String breakfastYn; 
	/**
	 * 객실타입키
	 */	
	private int roomTypeNo; 
	/**
	 * 객실명
	 */
	private String roomName; 
	/**
	 * 표시되는 기본 인원
	 */
	private int baseGuestCount;
	/**
	 * 1객실 숙박 가능 최대 인원
	 */
	private int maxGuestCount; 
	/**
	 * 1객실당 침대 수
	 */
	private int bedCount; 
	/**
	 * 싱글/더블/퀸/킹
	 */
	private String bedTypeCd;
	/**
	 * 숙소 소유 최대 객실 수
	 */
	private int totalRoomCount;
	/**
	 * 객실가격
	 */
	private int price; 
	/**
	 * 숙소 번호
	 */
	private int accNo;
	
	
	private RoomFeatureVO feature;
    private RoomFacilityVO facility;
    
    private int maxDiscount;
    private int minPrice;    // 최저가
    private int finalPrice;  // 할인 적용가
}
