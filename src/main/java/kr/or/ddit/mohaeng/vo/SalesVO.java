package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class SalesVO {
    private Integer saleNo;         // 매출번호 (PK)
    private Integer prodListNo;     // 구입상품목록번호 (FK)
    private Date settleDate;        // 결산일
    private Date saleDt;            // 매출일자
    private Integer netSales;       // 실제매출액
    private String settleStatCd;    // 정산상태 코드(정산대기,정산가능,정산완료,취소)
}
