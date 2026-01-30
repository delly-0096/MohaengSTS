package kr.or.ddit.mohaeng.admin.transactions.payments.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.vo.AdminPaymentsVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface IAdminPaymentsService {
    Map<String, Object> getAdminPaymentDashboard();
    PaginationInfoVO<AdminPaymentsVO> getAdminPaymentsList(PaginationInfoVO<AdminPaymentsVO> pagingVO);
    
    Map<String, Object> getPaymentDetail(int payNo);
    List<Map<String, Object>> getReceiptDetailList(int payNo);
}