package kr.or.ddit.mohaeng.accommodation.dto;

import lombok.Data;

@Data
public class TourApiItemDTO {
    private String contentid;   // 우리 DB의 API_CONTENT_ID로 갈 녀석
    private String title;       // 숙소명
    private String addr1;       // 주소
    private String addr2;		// 상세 주소
    private String zipcode;     // 우편번호
    private String firstImage;  // 이미지 URL
    private String areacode;	// 지역코드
    private String sigungucode; // 시군구코드
    private String cat1;		// 대분류
    private String cat2;		// 중분류
    private String cat3;		// 소분류
    private int createdtime;	//
    private String mapx;		// 경도
    private String mapy;		// 위도
    private String lDongRegnCd;
    private String lDongSignguCd;
    private String contenttypeid;
    private String tel;

}
