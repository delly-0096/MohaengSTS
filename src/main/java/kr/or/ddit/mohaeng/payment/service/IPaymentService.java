package kr.or.ddit.mohaeng.payment.service;

import java.util.Map;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.vo.PaymentVO;

public interface IPaymentService {
	public Map<String, Object> confirmPayment(PaymentVO paymentVO);
}
