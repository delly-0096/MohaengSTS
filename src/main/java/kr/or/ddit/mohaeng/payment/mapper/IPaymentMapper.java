package kr.or.ddit.mohaeng.payment.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.PaymentInfoVO;
import kr.or.ddit.mohaeng.vo.PaymentVO;

@Mapper
public interface IPaymentMapper {

	public int insertPayment(PaymentVO paymentVO);	// 결제 정보 입력
	public int insertPaymentInfo(PaymentInfoVO paymentInfo);	// 결제 상세정보 추가
	public int insertPoint(MemberVO member);	// 포인트 적립
}
