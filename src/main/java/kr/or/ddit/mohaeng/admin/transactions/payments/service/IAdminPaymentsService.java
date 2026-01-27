package kr.or.ddit.mohaeng.admin.transactions.payments.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.vo.AdminPaymentsVO;

public interface IAdminPaymentsService {
	public List<AdminPaymentsVO> selectAdminPaymentList(Map<String, Object> params);
	public Map<String, Object> getPaymentStats();
}
