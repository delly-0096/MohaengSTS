package kr.or.ddit.mohaeng.vo;

import java.time.OffsetDateTime;
import java.util.List;

import lombok.Data;

@Data
public class PaymentVO {
	// 결제
	
	private int payNo; 			// 결제키 (결제번호 || 주문번호) -> 각 결제 항목 약자 + 일자로 구현 예정
	private int memNo; 			// 회원키
	private String paymentKey;	// payment 키 - API에서도 사용
	private int payTotalAmt; 	// 결제금액
	private int usePoint;		// 사용포인트
	private String payMethodCd; // 공통코드
	
	
	private OffsetDateTime payDt; 		// 결제일시 - json에서 제공하는 형태
	private String payStatus; 			// 결제상태(Y,N,WAIT)
	private OffsetDateTime cancelDt; 	// 취소일시
	private String cancelReason;		// 취소사유
	
	// 결제할 때 insert할 값들
	private List<FlightProductVO> flightProductList;			// 항공 상품 목록
	private List<FlightPassengersVO> flightPassengersList;		// 항공 탑승객 목록
	private List<FlightReservationVO> flightReservationList;	// 항공 예약 목록
	private FlightResvAgreeVO flightResvAgree;					// 항공 예약 동의 목록
	
	private String productType;									// 상품 타입 (flight, tour 등등) 
	
	// 토스 api용 변수
	private String paymentType;	// 결제 타입
	private long amount; 		// 가격
	private String orderId;		// 주문 - 결제키로 사용됨
	
	private List<TripProdListVO> tripProdList;	// 투어 상품 목록
	private String mktAgreeYn;					// 마케팅 동의
	
	private AccResvVO accResvVO; // 숙소 상품
}
