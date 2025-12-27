package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;
@Data
public class FlightScheduleVO {
	// 운항 일정
	
	private int scheduleNo;       // 항공일정키
	private String fltProdId;     // 
	private String flightSymbol;  // 항공편번호
	private int depAirportId;     // 출발공항
	private int arrAirportId;     // 도착공항
	private String depTime;       // 출발시간
	private String arrtime;       // 도착시간
	private String domesticDays;  // 월/화/수 등
	private Date startDt;         // 운항시작일
	private Date endDt;           // 운항종료일
	private String acftNm;        // 기종
}
