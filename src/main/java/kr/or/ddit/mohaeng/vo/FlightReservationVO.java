package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class FlightReservationVO {
	// 항공 예약
	
	private int reserveNo;      // 항공예약키
	private String fltProdId;     	 // 항공권 키 - 일자 + 순서 (db변경해야됨)
	private int memNo;          // 예약자
	private String payNo;       // 결제번호 - payment 테이블
	private int totalPrice;
	
	
}
