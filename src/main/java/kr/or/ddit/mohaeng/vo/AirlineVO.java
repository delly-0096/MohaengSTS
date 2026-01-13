package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AirlineVO {
	// 항공사 - 10개
	private String airlineId;	// 항공사 id - icao -> 절대 안변하는 코드
	private String airlineNm;	// 항공사명
	private String iataCode;      // 항공사 IATA 코드
	private String airlineLogo;   // 로고
}
