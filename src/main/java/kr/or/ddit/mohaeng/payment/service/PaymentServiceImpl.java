package kr.or.ddit.mohaeng.payment.service;

import java.nio.charset.StandardCharsets;
import java.time.OffsetDateTime;
import java.util.Base64;
import java.util.HashMap;
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

import kr.or.ddit.mohaeng.payment.mapper.IPaymentMapper;
import kr.or.ddit.mohaeng.vo.FlightPassengersVO;
import kr.or.ddit.mohaeng.vo.FlightProductVO;
import kr.or.ddit.mohaeng.vo.PaymentVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PaymentServiceImpl implements IPaymentService {

	@Autowired
	private IPaymentMapper mapper;
	
	// 결제
	@Override
	@Transactional
	public Map<String, Object> confirmPayment(PaymentVO paymentVO) {
		log.info("PaymentServiceImpl - confirmPayment {}", paymentVO);
		
		// api - 요청
		String url = "https://api.tosspayments.com/v1/payments/confirm";		// 요청 주소
		String widgetSecretKey = "test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6";		// 요청 키
        byte[] encodedBytes = Base64.getEncoder().encode((widgetSecretKey + ":").getBytes(StandardCharsets.UTF_8));
        String authorizations = "Basic " + new String(encodedBytes);			// 암호화된 키를 이용해서 권한 설정
		
		RestTemplate restTemplate = new RestTemplate();
		
		HttpHeaders headers = new HttpHeaders();								// 헤더에 정보 담기
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", authorizations);

        // 4. 바디 설정 (토스 API 규격에 맞는 필드만 구성)
        Map<String, Object> params = new HashMap<>();
        params.put("orderId", paymentVO.getOrderId());
        params.put("amount", paymentVO.getAmount());
        params.put("paymentKey", paymentVO.getPaymentKey());

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(params, headers);		// 헤더, 바디 담기

        try {
            // 5. API 요청 (POST)
            // 응답 결과를 Map으로 받으면 편리합니다. 필요시 전용 VO를 만드셔도 됩니다.
            ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);

            if (response.getStatusCode() == HttpStatus.OK) {	// server 연결 성공
            	Map<String, Object> responseBody = response.getBody();

            	
                log.info("결제 승인 API 성공: {}", response.getBody());
                
                // api 에서 가져올 정보
                // memNo이미 존재
                paymentVO.setPayNo(responseBody.get("orderId").toString());
                paymentVO.setPaymentKey(responseBody.get("paymentKey").toString()); // 아직 필요유무 모름
                int amount = (int) responseBody.get("totalAmount");
                paymentVO.setPayTotalAmt(amount);	// 숫자
                paymentVO.setPayMethodCd(responseBody.get("method").toString());

                String approvedAtStr = responseBody.get("approvedAt").toString();
                OffsetDateTime payDt = OffsetDateTime.parse(approvedAtStr);
                paymentVO.setPayDt(payDt);	// 날짜
                paymentVO.setPayStatus(responseBody.get("status").toString());
                
                int discount = responseBody.get("discount") == null ? 0 : (int) responseBody.get("discount");
                paymentVO.setUsePoint(discount);	// 사용포인트
                // 취소 사유 2개는 패스
                
                log.info("paymentVO : {}", paymentVO);
                
                int payResult = mapper.insertPayment(paymentVO);
                
                // 응답 받은 데이터(response.getBody())를 PaymentVO에 셋팅하거나 가공하여 insert/update
                // 예: paymentVO.setPayStatus("Y");
                // int row = paymentMapper.insertPayment(paymentVO);
                
                // 결제 상세 정보 담기
                // payNo = orderId로 세팅
                // memNo 불러오려면?
                // payTotalAmt = price
                // payMethodCd = method = rksvusrufwp, 
                // payStatus = status로 세팅 (DONE이 결제 한 것)
                // payDt = approvedAt로 세팅
                // 
                
                
                
                // 항공권 담기
                for(FlightProductVO flightProductVO : paymentVO.getFlightProductList()) {
                	// 해당 정보와 일치하는 항공권 있는지 확인하기. 없으면 insert
                }
                
                // 예약 정보 담기
//                for(FlightReservationVO flightReservationVO : paymentVO.getFlightReservationList()) {
//                	// 얘도 한번 확인하기
//                	// orderId가 결제번호!
//                }
                
                // 탑승객 정보 담기
                for(FlightPassengersVO flightPassengersVO : paymentVO.getFlightPassengersList()) {
                	// 얘도 한번 확인
                }
                
                return responseBody; 
            } else {
                log.error("결제 승인 API 실패: {}", response.getStatusCode());
                return null;
            }
        } catch (Exception e) {
            log.error("API 호출 중 예외 발생: {}", e.getMessage());
            return null;
        }
	}
}
