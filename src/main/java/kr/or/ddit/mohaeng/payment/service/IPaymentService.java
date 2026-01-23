package kr.or.ddit.mohaeng.payment.service;

import java.util.Map;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.vo.PaymentVO;

public interface IPaymentService {
	
	/**
	 * <p>결제</p>
	 * @author sdg
	 * @param paymentVO 결제데이터
	 * @return api 응답 객체
	 */
	public Map<String, Object> confirmPayment(PaymentVO paymentVO);

	/**
	 * 이용일 지나면 정산가능 상태변경
	 */
	public int updateSettleStatus();
}
