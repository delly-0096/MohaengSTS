package kr.or.ddit.mohaeng.payment.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.configurationprocessor.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.flight.service.IFlightService;
import kr.or.ddit.mohaeng.payment.service.IPaymentService;
import kr.or.ddit.mohaeng.vo.PaymentVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/product/payment")
public class PaymentController {
		
	@Autowired
	private IPaymentService service;
	
	/**
	 * @param paymentType : 결제타입(NORMAL : 일반 결제, BILLING : 자동결제, BRANDPAY: 브랜드 페이) 
	 * @param orderId	  : 주문 번호
	 * @param paymentKey  : 결제 키
	 * @param amount	  : 결제 금액
	 * @return
	 */
	@GetMapping("/flight")
	public String flightPayment(
			@RequestParam String paymentType,
			@RequestParam String orderId,
			@RequestParam String paymentKey,
			@RequestParam Long amount,
			Model model
			) {
		
//		log.info("결제  : " + paymentVO.getPaymentType() + ",  " +  paymentVO.getOrderId() + ", " 
//			+ paymentVO.getPaymentKey() + ", " + paymentVO.getAmount());
		log.info("결제  : " + paymentType + ",  " +  orderId + ", " + paymentKey + ", " + amount);

		model.addAttribute("paymentType", paymentType);
		model.addAttribute("orderId", orderId);
		model.addAttribute("paymentKey", paymentKey);
		model.addAttribute("amount", amount);
		model.addAttribute("success", "success");	// 성공 했을때만 전송
		return "product/payment";
	}
	
	/**
	 * 결제 거부당했을때
	 * 
	 * @param code		: error 요인
	 * @param message	: error 메시지
	 * @param orderId	: 주문번호
	 * @param model
	 * @return
	 */
	@GetMapping("/error")
	public String errorPayment(	
			@RequestParam String code,
			@RequestParam String message,
			@RequestParam String orderId,
			Model model
			) {
		
		log.info("결제 실패 : " + code + ", " + message + ", " + orderId);
		
		model.addAttribute("code", code);
		model.addAttribute("message", message);
		model.addAttribute("orderId", orderId);
		model.addAttribute("error", "error");	// 실패 했을때만 전송
		
		return "product/payment";
	}
	
	
	
	/**
	 * <p>항공 상품 결제</p>
	 * @date 2025.01.09
	 * @author sdg
	 * @param paymentVO	json 객체 - 탑승객, 항공권, 예약 객체의 리스트타입
	 * @return api 응답 객체
	 */
	@ResponseBody
	@PostMapping("/flight/confirm")
    public ResponseEntity<Map<String, Object>> confirmFlightPayment(@RequestBody PaymentVO paymentVO) {
		log.info("confirmFlightPayment productList : {}", paymentVO.getFlightProductList());
		log.info("confirmFlightPayment passengersList : {}", paymentVO.getFlightPassengersList());
		Map<String, Object> result = service.confirmPayment(paymentVO);		// 여기서 받는 값을 전송해야됨 - serviceResult타입은 아님
		// 그래서 타입이 뭐냐
		
		if(result != null) {
			return new ResponseEntity<>(result, HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
    }
}
