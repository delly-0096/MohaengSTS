package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class FlightReservationVO {
	// 항공 예약
	
	private int reserveNo;      // 항공예약키
	private int fltProdId;   	// 항공권 키 - 일자 + 순서 (db변경해야됨) - sequence로 사용
	private int memNo;          // 예약자
	private int payNo;       // 결제번호 - payment 테이블의 시퀀스
	private int totalPrice;
	
	
}
