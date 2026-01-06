package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class FlightReservationVO {
	// 항공 예약
	
	private int reserveNo;      // 항공예약키
	private int scheduleNo;     // 공항일정키
	private int memNo;          // 예약자
	private Date flightDt;      // 탑승일자
	
	private String payNo;       // 결제번호 - payment 테이블
	
}
