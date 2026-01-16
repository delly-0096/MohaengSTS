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
    private String areacode;	
    /**
     * 시군구 코드
     */
    private String sigungucode; 
}
