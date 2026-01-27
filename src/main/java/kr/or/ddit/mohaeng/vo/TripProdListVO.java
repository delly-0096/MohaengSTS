package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class TripProdListVO {
    private Integer prodListNo;    // 구입상품목록번호 (PK)
    private Integer payNo;         	// 결제번호 (FK)
    private Integer tripProdNo;    // 여행상품일련번호 (FK)
    private String tripProdName;	// 여행상품일련번호에 따른 여행상품명
    private Integer unitPrice;     // 판매단가
    private Integer discountAmt;   // 할인금액
    private Integer payPrice;      // 실결제금액
    private Integer quantity;      // 수량
    private String resvDt;         // 이용일자
    private String useTime;        // 이용시작시간
    private String rsvMemo;        // 요청사항
    
    
	// 결제자 정보 호출
	private String memName;
	private String memEmail;
	// memUser
	private String tel;
	private String nickname;
}
