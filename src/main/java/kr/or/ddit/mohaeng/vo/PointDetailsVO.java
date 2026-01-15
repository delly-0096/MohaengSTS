package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;


// 포인트 상세 내역
@Data
public class PointDetailsVO {

	private int pointDetailsNo; 	 // 포인트내역번호 (PK)
	private int memNo; 				 // 회원번호 (FK)
	private int pointPolNo;			 // 포인트 정책번호 (FK)
	private String pointType;		 // 포인트 증감유형 ('+' 적립, '-' 차감)
	private int pointAmt;			 // 변동 포인트
	private String pointDesc;		 // 포인트 내역 설명
	private String pointTarget;		 // 포인트 발생 테이블명 (TRIP_RECORD, PROD_REVIEW, PAYMENT, REFUND_LOG 등)
	private int pointTargetId;		 // 포인트 발생 테이블 키값
	private int remainPoint;		 // 잔여 포인트 (FIFO 차감용 - 해당 레코드의 남은 포인트)
	private Date pntExpireDt;		 // 포인트 만료일(6개월)
	private Date regDt;				 // 포인트 등록일자

	 // 결과 조회용 추가 필드 (JOIN)

	private String memName; 		// 회원명
	private String memEmail;		// 회원 이메일
	private int currentBalance; 	// 현재 총 잔액( 화면에 잔액 나오게. 안쓸수도 있음)

}
