package kr.or.ddit.mohaeng.payment.service;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.vo.PaymentVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PaymentServiceImpl implements IPaymentService {

	// 결제
	@Override
	public ServiceResult confirmPayment(PaymentVO paymentVO) {
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

            if (response.getStatusCode() == HttpStatus.OK) {
                log.info("결제 승인 API 성공: {}", response.getBody());
                
                // 6. DB 저장 로직 (Mapper 호출)
                
                // 응답 받은 데이터(response.getBody())를 PaymentVO에 셋팅하거나 가공하여 insert/update
                // 예: paymentVO.setPayStatus("Y");
                // int row = paymentMapper.insertPayment(paymentVO);
                
                
                return ServiceResult.OK; 
            } else {
                log.error("결제 승인 API 실패: {}", response.getStatusCode());
                return ServiceResult.FAILED;
            }
        } catch (Exception e) {
            log.error("API 호출 중 예외 발생: {}", e.getMessage());
            return ServiceResult.FAILED;
        }
        
        // 이렇게 하면 받을수 있을지도??
//        @Override
//        @Transactional
//        public Map<String, Object> confirmPayment(PaymentVO paymentVO) {
//            // ... (헤더 설정 및 RestTemplate 호출 로직)
//            
//            try {
//                ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
//                
//                if (response.getStatusCode() == HttpStatus.OK) {
//                    Map<String, Object> responseBody = response.getBody();
//                    
//                    // [중요] 여기서 DB 저장을 먼저 수행하세요!
//                    // responseBody에 들어있는 approvedAt, paymentKey 등을 꺼내서 
//                    // paymentMapper.insertPayment(paymentVO) 실행
//                    
//                    return responseBody; // 토스에서 받은 데이터를 그대로 컨트롤러로 반환
//                }
//            } catch (Exception e) {
//                log.error("결제 승인 중 예외 발생", e);
//            }
//            return null; // 실패 시 null 혹은 예외를 던짐
//        }
        
		
		
        // 결과 
//        ServiceResult result = null;
//		return result;
	}

}
