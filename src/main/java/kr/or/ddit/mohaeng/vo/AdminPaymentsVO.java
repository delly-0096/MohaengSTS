package kr.or.ddit.mohaeng.vo;
import java.time.LocalDateTime;
import lombok.Data;
@Data
public class AdminPaymentsVO {
    // 결제 기본 정보
    private int payNo;
    private String orderNo;     // 가공된 주문번호 (YYYYMMDD + sequence)
    private LocalDateTime payDt;
    private String payStatus;   // WAIT, DONE, CANCEL
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
    private String useDate;
    private String optionInfo;
    private String bzmnNm;      // 업체명
    private String brno;        // 사업자번호
    private String compTel;     // 업체연락처
    // 환불 관련 정보
    private LocalDateTime cancelDt;
    private String cancelReason;
    private int originalPrice;
}