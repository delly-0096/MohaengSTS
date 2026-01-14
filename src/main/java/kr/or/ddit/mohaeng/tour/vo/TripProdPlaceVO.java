package kr.or.ddit.mohaeng.tour.vo;

import lombok.Data;

@Data
public class TripProdPlaceVO {
    private int prodPlcNo;      // 여행상품 관광지키 (PK)
    private int tripProdNo;     // 여행상품일련키 (FK)
    private String addr1;       // 관광지 주소
    private String addr2;       // 관광지 상세주소
}
