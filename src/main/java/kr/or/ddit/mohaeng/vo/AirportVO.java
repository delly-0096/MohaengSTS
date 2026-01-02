package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AirportVO {
	// 공항
	
	private int airportNo;		 // 공항키
	private String airportNm;	 // 공항명
	private String airportId;	 // 공항 id
	
	
	private String iataCode;     // 공항 IATA 코드 - 하드
	private String cityName;     // 지역	          - 지역명 가져오기
	private String zip;          // 공항 우편번호  - 지도로 가져오기
	private String addr1;        // 공항 주소	  - 지도로 가져오기
	private String addr2;        // 공항 상세주소  - 지도로 가져오기
}
