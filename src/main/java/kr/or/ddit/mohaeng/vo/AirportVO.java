package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AirportVO {
	// 공항
	private int airlineNo;       // 공항키
	private String airlineName;  // 공항명
	private String iataCode;     // 공항 IATA 코드
	private String cityName;     // 지역
	private String zip;          // 공항 우편번호
	private String addr1;        // 공항 주소
	private String addr2;        // 공항 상세주소
}
