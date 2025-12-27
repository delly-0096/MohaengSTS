package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AirlineVO {
	// 항공사
	
	private int airlineNo;        // 항공사 ID
	private String airlineName;   // 항공사명
	private String iataCode;      // 항공사 IATA 코드
	private String airlineLogo;   // 로고
}
