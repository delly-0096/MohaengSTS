package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class FlightPassengersVO {
	
	private int passengerId; 	// 탑승객 식별 ID - 시퀀스
	
	private long reserveNo;     // 예약번호
	private String lastName; 	// 성
	private String firstName; 	// 이름
	
	private Date birthDate; 	   // 탑승객 생년월일
	private String gender; 		   // 성별 (M/F)
	private String passengersType; // 승객 구분 (성인/소아/유아)
	
	private int baggagePrice;  // 추가수하물가격
	private int extraBaggage;  // 추가 수하물 무게(KG)
	private String flightSeat; // 좌석 번호
	
	// db에 없는 정보
	private String outSeat;		// 가는편 좌석
	private String inSeat;		// 오는편 좌석	- NONE 나오면 왕복아님
	
	private int extraBaggageOutbound;	// 가는편 추가 수하물
	private int extraBaggageInbound;	// 오는편 추가 수하물
}
