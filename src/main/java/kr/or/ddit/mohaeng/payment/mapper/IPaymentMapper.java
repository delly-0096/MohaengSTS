package kr.or.ddit.mohaeng.payment.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.PaymentVO;

@Mapper
public interface IPaymentMapper {
	public int insertPayment(PaymentVO paymentVO);

}
