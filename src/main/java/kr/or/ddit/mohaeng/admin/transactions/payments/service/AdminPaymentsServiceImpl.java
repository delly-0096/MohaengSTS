package kr.or.ddit.mohaeng.admin.transactions.payments.service;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.or.ddit.mohaeng.admin.transactions.payments.mapper.IAdminPaymentsMapper;
import kr.or.ddit.mohaeng.vo.AdminPaymentsVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Service
public class AdminPaymentsServiceImpl implements IAdminPaymentsService {
    
    @Autowired
    private IAdminPaymentsMapper adminMapper;
    
    @Override
    public Map<String, Object> getAdminPaymentDashboard() {
        return adminMapper.selectAdminPaymentStats();
    }
    
    @Override
    public PaginationInfoVO<AdminPaymentsVO> getAdminPaymentsList(PaginationInfoVO<AdminPaymentsVO> pagingVO) {
        int totalRecord = adminMapper.selectAdminPaymentsCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);
        pagingVO.setDataList(adminMapper.selectAdminPaymentsList(pagingVO));
        return pagingVO;
    }
    
    @Override
    public Map<String, Object> getPaymentDetail(int payNo) {
        return adminMapper.selectPaymentDetail(payNo);
    }
    
    @Override
    public List<Map<String, Object>> getReceiptDetailList(int payNo) {
        return adminMapper.selectReceiptDetailList(payNo);
    }
}