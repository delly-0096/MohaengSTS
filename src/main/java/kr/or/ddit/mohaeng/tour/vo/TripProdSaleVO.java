package kr.or.ddit.mohaeng.tour.vo;

import lombok.Data;

@Data
public class TripProdSaleVO {
    private int tripProdNo;         // 여행상품일련키 (PK, FK)
    private int price;              // 판매가
    private Integer netprc;         // 정가
    private Integer discount;       // 할인율 (%)
    private Integer leadTime;       // 총소요시간 (1,3,6,24)
    private Integer totalStock;     // 총 재고량
    private Integer curStock;       // 현재 재고량
}
