package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AdminPaymentsVO {
    private long payNo;
    private int payTotalAmt;
    private String payDt;
    private String payStatus;
    private String payMethodCd;
    private int usePoint;
    private String tel;
    
    // 결제자 정보
    private String memName;
    private String memEmail;

    private String tid;
    
    // 상품 정보 (숙소/투어 OR 항공)
    private String itemTitle;     // 화면에 보여줄 통합 상품명
    private String bzmnNm;        // 판매자명 
    private String brno;
    private String compTel;
    
    
    private String prodType;      // 'TRIP' 또는 'FLIGHT' 구분용
    private int rnum;
    
    private String productJson;
    
    private String resMsg;
}
