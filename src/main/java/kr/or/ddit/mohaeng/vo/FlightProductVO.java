package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class FlightProductVO {
	// 항공 상품
	
	private int fltProdId;			// 항공권 번호	
	private int tripProdNo;         // 여행상품일련키
	private int airlineId;          // 항공사 ID
	private String checkedBaggage;  // 무료 위탁 수하물
	private String carryOnBaggage;  // 기내 수하물
	private String entYn;           // 기내식(Y,N)
	private String entertainYn;     // 엔터테이먼트(Y,N)
	private String wifiYn;          // 기내 WiFi(Y,N)
	private String usbPwrYAn;       // USB 충전(Y,N)
}
