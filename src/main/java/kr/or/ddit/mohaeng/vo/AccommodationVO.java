package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AccommodationVO {

	/**
	 * 숙소키
	 */
	private int accNo; 
	/**
	 * 여행 상품 일련키
	 */
	private int tripProdNo; 
	/**
	 * 숙소명
	 */
	private String accName;
	/**
	 * 숙소 유형(호텔,리조트,펜션...)
	 */
	private String accCatCd; 
	/**
	 * 숙소 이미지 번호
	 */
	private int accFileNo; 
	/**
	 * 숙소 성급
	 */
	private int starGrade; 
	/**
	 * 숙소 우편번호 (앞자리 0 가능)
	 */
	private String zip; 
	/**
	 * 숙소 주소
	 */
	private String addr1; 
	/**
	 * 숙소 상세주소
	 */
	private String addr2;
	/**
	 * 총 객실 수 
	 */
	private String totalRoomCnt; 
	/**
	 * API 키
	 */
	private String apiContentId;
	/**
	 * 숙소 이미지 경로
	 */
	private String accFilePath;
	/**
	 * 경도
	 */
	private String mapx; 
	/**
	 * 위도
	 */	
	private String mapy;
	/**
	 * 지역 코드
	 */
    private String areaCode;	
    /**
     * 시군구 코드
     */
    private String sigunguCode; 
    /**
     * 법정동 코드
     */
    private String ldongRegnCd;
    /**
     * 법정동 시군구 코드
     */
    private String ldongSignguCd; 
    
    
    // ACC_FACILITY
    private String wifiYn; /* WiFi 제공 여부 */
    private String parkingYn; /* 주차 가능 여부 */
    private String breakfastYn; /* 조식 제공 여부 */
    private String poolYn; /* 수영장 유무 */
    private String gymYn; /* 헬스장/피트니스 유무 */
    private String spaYn; /* 스파 시설 유무 */
    private String restaurantYn; /* 내부 식당 유무 */
    private String barYn; /* 바/라운지 유무 */
    private String roomServiceYn; /* 룸서비스 가능 여부 */
    private String laundryYn; /* 세탁 서비스 제공 여부 */
    private String smokingAreaYn; /* 지정 흡연구역 유무 */
    private String petFriendlyYn; /* 반려동물 입실 가능 여부 */
    
    // ROOM_TYPE
    private int maxDiscount;
    private int minPrice;    // 최저가
    private int discount;    // 할인율
    private int finalPrice;  // 할인 적용가
}
