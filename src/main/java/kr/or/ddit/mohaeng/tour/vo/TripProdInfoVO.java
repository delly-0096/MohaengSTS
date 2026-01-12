package kr.or.ddit.mohaeng.tour.vo;

import lombok.Data;

@Data
public class TripProdInfoVO {
    private int tripProdNo;         // 여행상품일련키 (PK, FK)
    private String prodRuntime;     // 운영시간
    private String prodDuration;    // 소요시간
    private Integer prodMinPeople;  // 최소인원
    private Integer prodMaxPeople;  // 최대인원
    private String prodLimAge;      // 연령제한
    private String prodInclude;     // 포함사항
    private String prodExclude;     // 불포함사항
    private String prodNotice;      // 유의사항
}
