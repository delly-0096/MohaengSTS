package kr.or.ddit.mohaeng.payment.service;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.vo.PaymentVO;

public interface IPaymentService {
	public ServiceResult confirmPayment(PaymentVO paymentVO);
}
