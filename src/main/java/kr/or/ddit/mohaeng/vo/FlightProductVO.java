package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class FlightProductVO {
	// 항공 상품
	
	private int fltProdId;			// 항공권 번호	
	private int airlineId;          // 항공사 ID
	private int checkedBaggage;  	// 무료 위탁 수하물 - 몇키로 인지입력 15 or 20
	private int carryOnBaggage;  	// 기내 수하물 - 10kg
	private int extraBaggagePrice;	// 추가 위탁 수하물 비용 2000원
	
}
