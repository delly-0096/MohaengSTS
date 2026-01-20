package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

//Record(기록)
// 포인트 상세 내역
//서버가 DB에서 꺼내와 사용자에게 던지는 결과지(영수증)
@Data
public class PointDetailsVO {

	private int pointDetailsNo; 	 // 포인트내역번호 (PK) "이 기록의 고유 번호(PK)는 123번이야"
	private int memNo; 				 // 회원번호 (FK)
	private int pointPolNo;			 // 포인트 정책번호 (FK)
	private String pointType;		 // 포인트 증감유형 ('+' 적립, '-' 차감) . 이미 결정된 내역(기록의 의미)
	private int pointAmt;			 // 변동 포인트 "그때 변동된 금액은 500원이었어"
	private String pointDesc;		 // 포인트 내역 설명 . 이미 결정된 내역(기록의 의미)
	private String pointTarget;		 // 포인트 발생 테이블명 (TRIP_RECORD, PROD_REVIEW, PAYMENT, REFUND_LOG 등)
	private int pointTargetId;		 // 포인트 발생 테이블 키값 "리뷰 작성으로 받은 포인트라고 적혀있네"
	private int remainPoint;		 // 잔여 포인트 (FIFO 차감용 - 해당 레코드의 남은 포인트) : 유효기간 체크를 위한 값
	private Date pntExpireDt;		 // 포인트 만료일(6개월)
	private Date regDt;				 // 포인트 등록일자 "발생한 날짜는 2024-05-20이야"

	 // 결과 조회용 추가 필드 (JOIN)

	private String memName; 		// 회원명
	private String memEmail;		// 회원 이메일
	private int currentBalance; 	// 현재 총 잔액( 화면에 잔액 나오게. 안쓸수도 있음)

}
