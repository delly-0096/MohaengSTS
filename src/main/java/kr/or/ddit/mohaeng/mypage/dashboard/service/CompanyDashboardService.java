package kr.or.ddit.mohaeng.mypage.dashboard.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.vo.CompanyDashboardVO;
import kr.or.ddit.mohaeng.vo.PaymentVO;

@Service
public interface CompanyDashboardService {
	public CompanyDashboardVO getDashboard(int compNo);
	public List<PaymentVO> selectPaymentList(int memNo);
	public int selectPaymentCount(int memNo);
	public List<PaymentVO> selectPaymentListPaging(int memNo, int page, int pageSize);

}
