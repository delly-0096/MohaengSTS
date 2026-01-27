package kr.or.ddit.mohaeng.vo;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class MyPaymentsVO {
    // 공통 정보
    private int payNo;
    private LocalDateTime payDt;
    private String payStatus;
    private int payTotalAmt;
    private int usePoint;
    private String payMethodCd;
    private String tid;         // PaymentInfo의 거래고유번호
    private String resMsg;      // PaymentInfo의 결과 메시지(상품명 대용)

    // 가공 정보 (UI 표시용)
    private String prodName;    // 실제 화면에 뿌려질 상품명
    private String useDate;     // 이용 시작일
    private String useTime;     // 이용 시간
    private String optionInfo;  // '2명', '3박' 등 인원/박수 정보
    private String thumbImg;    // 최종 이미지 경로
    private String category;    // 'FLIGHT', 'HOTEL', 'TOUR'

    // 영수증/환불 정보 (필기 내용 반영)
    private int originalPrice;  // 원가 (실결제 + 포인트)
    private int discountAmt;    // 할인금액
    private int earnedPoints;   // 적립포인트 (실결제 * 0.1)
    private LocalDateTime cancelDt;
    private String cancelReason;
    
    private String tel;
}
