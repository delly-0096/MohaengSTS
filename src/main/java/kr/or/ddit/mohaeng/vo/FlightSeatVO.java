package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class FlightSeatVO {
	// 좌석
	private int flightseatNo; 	// 좌석정보키
	private int fltProdId; 		// 항공권 번호
	private int seatGradeCd;	// 일등석/비지니스/이코노미
	private int remainSeat; 	// 잔여 좌석수
	private int seatPrice; 		// 가격
}
