package kr.or.ddit.mohaeng.payment.service;

import java.nio.charset.StandardCharsets;
import java.time.OffsetDateTime;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import kr.or.ddit.mohaeng.flight.mapper.IFlightMapper;
import kr.or.ddit.mohaeng.payment.mapper.IPaymentMapper;
import kr.or.ddit.mohaeng.vo.FlightPassengersVO;
import kr.or.ddit.mohaeng.vo.FlightProductVO;
import kr.or.ddit.mohaeng.vo.FlightReservationVO;
import kr.or.ddit.mohaeng.vo.FlightResvAgreeVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.PaymentInfoVO;
import kr.or.ddit.mohaeng.vo.PaymentVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PaymentServiceImpl implements IPaymentService {

	@Autowired
	private IPaymentMapper payMapper;

	@Autowired
	private IFlightMapper flightMapper;

	@Override
	@Transactional
	public Map<String, Object> confirmPayment(PaymentVO paymentVO) {
		log.info("PaymentServiceImpl - confirmPayment {}", paymentVO);

		// api - 요청
		String url = "https://api.tosspayments.com/v1/payments/confirm"; // 요청 주소
		String widgetSecretKey = "test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6"; // 요청 키
		byte[] encodedBytes = Base64.getEncoder().encode((widgetSecretKey + ":").getBytes(StandardCharsets.UTF_8));
		String authorizations = "Basic " + new String(encodedBytes); // 암호화된 키를 이용해서 권한 설정

		RestTemplate restTemplate = new RestTemplate();

		HttpHeaders headers = new HttpHeaders(); // 헤더에 정보 담기
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.set("Authorization", authorizations);

		// 4. 바디 설정 (토스 API 규격에 맞는 필드만 구성)
		Map<String, Object> params = new HashMap<>();
		params.put("orderId", paymentVO.getOrderId());
		params.put("amount", paymentVO.getAmount());
		params.put("paymentKey", paymentVO.getPaymentKey());

		HttpEntity<Map<String, Object>> entity = new HttpEntity<>(params, headers); // 헤더, 바디 담기

		// 5. API 요청 (POST)
		ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);

		if (response.getStatusCode() == HttpStatus.OK) { // server 연결 성공
			Map<String, Object> responseBody = response.getBody();
			log.info("결제 승인 API 성공: {}", response.getBody());

			// api 에서 가져올 정보
			// memNo이미 존재
			paymentVO.setPaymentKey(responseBody.get("paymentKey").toString());
			int amount = (int) responseBody.get("totalAmount");
			paymentVO.setPayTotalAmt(amount); // 숫자
			String payMethod = responseBody.get("method").toString(); 
			paymentVO.setPayMethodCd(payMethod);

			String approvedAtStr = responseBody.get("approvedAt").toString();
			OffsetDateTime payDt = OffsetDateTime.parse(approvedAtStr);
			paymentVO.setPayDt(payDt); // 날짜
			String status = responseBody.get("status").toString();
			paymentVO.setPayStatus(status);

			int discount = responseBody.get("discount") == null ? 0 : (int) responseBody.get("discount");
			paymentVO.setUsePoint(discount); // 사용포인트
			// 취소 사유 2개는 = 취소 환불시 사용하기

			log.info("paymentVO : {}", paymentVO);

			int payResult = payMapper.insertPayment(paymentVO);
			log.info("insertPayment : {}", payResult);

			// 결제 상세 정보
			PaymentInfoVO paymentInfo = new PaymentInfoVO();
			log.info("paymentInfo : {}", paymentInfo);
			
			paymentInfo.setPayNo(paymentVO.getPayNo());
			paymentInfo.setTid(paymentVO.getPaymentKey());
			paymentInfo.setResCode(status);
			paymentInfo.setResMsg(status + " " + responseBody.get("orderName"));
			paymentInfo.setPayMethodType(payMethod);
			
			// 카드, 승인번호
			if (responseBody.get("card") != null) {
			    Map<String, Object> card = (Map<String, Object>) responseBody.get("card");
			    paymentInfo.setCardCorpCode(card.get("issuerCode").toString()); // 카드사 코드 (예: 11)
			    paymentInfo.setAuthNo(card.get("approveNo").toString());        // 승인번호
			}else {
				paymentInfo.setCardCorpCode("");  // 카드사 코드 (예: 11)
				paymentInfo.setAuthNo("");        // 승인번호
			}
			
			// 가상 계좌
			if (responseBody.get("virtualAccount") != null) {
			    Map<String, Object> vbank = (Map<String, Object>) responseBody.get("virtualAccount");
			    paymentInfo.setVbankNum(vbank.get("accountNumber").toString());
			    
			    String dueDateStr = vbank.get("dueDate").toString();
			    paymentInfo.setVbankExpDt(OffsetDateTime.parse(dueDateStr));
			}else {
				paymentInfo.setVbankNum("");
				paymentInfo.setVbankExpDt(null);
			}
			paymentInfo.setPayRawData(responseBody.toString());		// 전체 데이터
			
			int paymentInfoResult = payMapper.insertPaymentInfo(paymentInfo);
			log.info("insertPaymentInfo : {}", paymentInfoResult);
			
			
			// 포인트 정책 - 결제 금액의 3%
			int pointResult = 0;
			if(discount == 0) {
				MemberVO member = new MemberVO();
				member.setMemNo(paymentVO.getMemNo());
				double point = (double)amount * 0.03;
				member.setPoint((int) point);
				pointResult = payMapper.insertPoint(member);
				log.info("pointResult 결과 : {}", pointResult);
			}
			
			int minusPointResult = 0;
			if(discount != 0) {
				MemberVO member = new MemberVO();
				member.setMemNo(paymentVO.getMemNo());
				member.setPoint(discount);	// 사용 포인트를 빼는 update
				minusPointResult = payMapper.updatePoint(member);
				log.info("minusPointResult 결과 : {}", minusPointResult);
			}
			
			int result = 0;		// 결제 결과
			if(paymentVO.getProductType().equals("flight")) {
				result = flightPayConfirm(paymentVO);
				log.info("flight pay : {}", result);
				
				int adult = 0;
				int child = 0;
				int infant = 0;
				for(FlightPassengersVO flightPassengers : paymentVO.getFlightPassengersList()) {
					if(flightPassengers.getPassengersType().equals("성인")) {
						adult++;
					} else if (flightPassengers.getPassengersType().equals("소아")) {
						child++;
					} else {
						infant++;
					}
				}
				
				if(adult != 0) {
					String adultInfo = "성인 " + adult + "명";
					responseBody.put("adult", adultInfo);
				}
				if(child != 0) {
					String childInfo = "소아 " + child + "명";
					responseBody.put("child", childInfo);
				}
				if(infant != 0) {
					String infantInfo = "유아 " + infant + "명";
					responseBody.put("infant", infantInfo);
				}
			}

			return responseBody;
		} else {
			log.error("결제 승인 API 실패: {}", response.getStatusCode());
			return null;
		}
	}

	/**
	 * <p>항공상품 결제</p>
	 * @author sdg
	 * @param paymentVO	항공권 정보
	 * @return
	 */
	private int flightPayConfirm(PaymentVO paymentVO) {
		// 항공권 담기 - pk = 시퀀스
		int productResult = 0;
		int extraBaggagePrice = paymentVO.getFlightProductList().get(0).getExtraBaggagePrice(); // 수하물 가격 세팅
		
		for (FlightProductVO flightProductVO : paymentVO.getFlightProductList()) {
			Integer fltProdId = flightMapper.getFlightKey(flightProductVO);
			// 해당 정보와 일치하는 항공권 있는지 확인하기. 없으면 insert
			if(fltProdId != null) {
				flightProductVO.setFltProdId(fltProdId);
			}else {
				productResult = flightMapper.insertFlight(flightProductVO); // 항공권 없으면 insert 있으면 안하기
			}
			log.info("insertFlight getFltProdId {}", flightProductVO.getFltProdId());
			log.info("insertFlight : {}", productResult);
		}

		// fltProdId
		List<FlightReservationVO> flightReservationList = paymentVO.getFlightReservationList(); 
		int depProductNo = paymentVO.getFlightProductList().get(0).getFltProdId(); // 가는편 항공권 키 시퀀스
		log.info("depProductNo {}", depProductNo);
		flightReservationList.get(0).setFltProdId(depProductNo);

		int arrProductNo = 0;
		if (paymentVO.getFlightProductList().size() >= 2) {
			arrProductNo = paymentVO.getFlightProductList().get(1).getFltProdId(); // 오는편 항공권 키 시퀀스
			log.info("arrProductNo {}", arrProductNo);
			flightReservationList.get(1).setFltProdId(arrProductNo);				// 오는편 항공권 키 세팅
		}
		
		// 예약 정보 담기
		int reservationResult = 0;
		for (FlightReservationVO flightReservationVO : flightReservationList) {
			flightReservationVO.setPayNo(paymentVO.getPayNo()); // 결제키
			reservationResult = flightMapper.insertFlightReservation(flightReservationVO);
			log.info("flightReservation insert {}", reservationResult);
		}

		// reservNo
		long depReservationNo = paymentVO.getFlightReservationList().get(0).getReserveNo(); // 가는편 예약키
		long arrReservationNo = 0;
		if (paymentVO.getFlightProductList().size() >= 2) {
			arrReservationNo = paymentVO.getFlightReservationList().get(1).getReserveNo(); // 오는편 예약키
		}

		// 항공이용약관 동의 담기
		int reservationAgreeResult = 0;
		FlightResvAgreeVO flightResvAgreeVO = paymentVO.getFlightResvAgree();
		flightResvAgreeVO.setReserveNo(depReservationNo);
		
		reservationAgreeResult = flightMapper.insertFlightAgree(flightResvAgreeVO);
		log.info("insertFlightAgree dep : {}", reservationAgreeResult);
		if(paymentVO.getFlightReservationList().size() >= 2) {
			flightResvAgreeVO.setReserveNo(arrReservationNo);
			reservationAgreeResult = flightMapper.insertFlightAgree(flightResvAgreeVO);
			log.info("insertFlightAgree arr : {}", reservationAgreeResult);
		}
		
		// 탑승객 정보 담기
		int passengersResult = 0;
		List<FlightPassengersVO> flightPassengerList = paymentVO.getFlightPassengersList();
		// 가는편 insert
		for (FlightPassengersVO flightPassengersVO : flightPassengerList) {
			flightPassengersVO.setReserveNo(depReservationNo);
			flightPassengersVO.setFlightSeat(flightPassengersVO.getOutSeat());
			flightPassengersVO.setExtraBaggage(flightPassengersVO.getExtraBaggageOutbound());
			flightPassengersVO.setBaggagePrice(flightPassengersVO.getExtraBaggage() * extraBaggagePrice);
			passengersResult = flightMapper.insertPassengers(flightPassengersVO); // 출발 탑승객 정보
			log.info("flightPassengers out insert {}", passengersResult);
		}

		// 오는편 insert
		if (paymentVO.getFlightProductList().size() >= 2) {
			for (FlightPassengersVO flightPassengersVO : paymentVO.getFlightPassengersList()) {
				flightPassengersVO.setPassengerId(0); // 초기화 해야 오는편이 받아짐
				flightPassengersVO.setReserveNo(arrReservationNo);
				flightPassengersVO.setFlightSeat(flightPassengersVO.getInSeat());
				flightPassengersVO.setExtraBaggage(flightPassengersVO.getExtraBaggageInbound());
				flightPassengersVO.setBaggagePrice(flightPassengersVO.getExtraBaggage() * extraBaggagePrice);
				passengersResult = flightMapper.insertPassengers(flightPassengersVO); // 도착 탑승객 정보
				log.info("flightPassengers in insert {}", passengersResult);
			}
		}

		int result = productResult + reservationResult + reservationAgreeResult + passengersResult;
		
		return result;
	}

}
