package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class FlightPassengersVO {
	private int passengerId; // 탑승객 식별 ID
	private int flightSeatNo; // 좌석정보 키
	private int reserveNo; // 예약 번호
	private String lastName; // 성
	private String firstName; // 이름
	
	
	private Date birthDate; // 탑승객 생년월일
	private String gender; // 성별 (M/F)
	private String passengersType; // 승객 구분 (성인/소아/유아)
	
	private int baggagePrice; // 추가수하물가격
	private int extraBaggage; // 추가 수하물 무게(KG)
	private String flightSeat; // 좌석 번호
}
