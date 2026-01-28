package kr.or.ddit.mohaeng.vo;
import java.time.LocalDateTime;
import lombok.Data;
@Data
public class AdminPaymentsVO {
    // 결제 기본 정보
    private int payNo;
    private String orderNo;     // 가공된 주문번호 (YYYYMMDD + sequence)
    private String payDt;       // String으로 변경 (쿼리에서 포맷팅됨 - T 제거)
    private String payStatus;   // WAIT, DONE, CANCEL (동적 판별)
    private int payTotalAmt;
    private int usePoint;
    private String payMethodCd;
    private String tid;
    
    // 회원 정보 (관리자용 추가)
    private int memNo;
    private String memName;
    private String memEmail;
    private String memTel;
    
    // 상품 및 판매자 정보
    private String prodName;
    private String thumbImg;
    private String useDateInfo;  // "2024.01.20 | 2명" 형식
    private String bzmnNm;      // 업체명
    private String brno;        // 사업자번호
    private String compTel;     // 업체연락처
    
    // 금액 관련 (추가)
    private int discount;       // 할인 금액
    private int originalPrice;  // 상품 원가 (PROD_TOTAL_PRICE)
    
    // 환불 관련 정보
    private LocalDateTime cancelDt;
    private String cancelReason;
    private int cancelFee;
    private int refundAmount;
}