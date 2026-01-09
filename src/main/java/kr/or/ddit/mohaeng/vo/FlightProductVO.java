package kr.or.ddit.mohaeng.vo;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
@Data
public class FlightProductVO {
	// 운항 일정
	
	private String fltProdId;     	 // 항공권 키 - 일자 + 순서 (db변경해야됨)
	
	private String airlineId;        // 항공사 ID
	private String flightSymbol;  	 // 항공편번호
	private String depAirportId;     // 출발공항 - id(영문 5자리)
	private String arrAirportId;     // 도착공항 - id(영문 5자리)
	
	@JsonFormat(pattern = "yyyyMMdd HH:mm")
	private LocalDateTime depTime;       // 출발시간
	@JsonFormat(pattern = "yyyyMMdd HH:mm")
	private LocalDateTime arrTime;       // 도착시간
	private String domesticDays;  		 // 월/화/수 등
	
	@JsonFormat(pattern = "yyyyMMdd")
	private LocalDate startDt;         // 운항시작일
	@JsonFormat(pattern = "yyyyMMdd")
	private LocalDate endDt;           // 운항종료일

	
	// 수하물 정보
	private int extraBaggagePrice = 2000;	// 추가 위탁 수하물 비용 2000원
	private int checkedBaggage;  		// 무료 위탁 수하물 - 몇키로 인지입력 15 or 20
	private int carryOnBaggage = 10;	// 기내 수하물 - 10kg
	
	
	//////////////////////////////
	
	// 공항 iata코드 (필요없을수도?)
	private String depIata;			// 출발지 iata코드 ?? 사용여부는 알아서
	private String arrIata;			// 도착지 iata코드


	
	// api에 있는 것들
	private String airlineNm;        // 항공사
	private String depAirportNm;     // 출발공항
	private String arrAirportNm;     // 도착공항
	private int economyCharge;       // 일반요금
	private int prestigeCharge;      // 비즈니스 요금
	
	// 페이징용
	private int pageNo = 1;
	private int numOfRows = 100;
	private String sorting = "";	// 정렬 - 최저가순, 최단시간순, 출발시간순
}