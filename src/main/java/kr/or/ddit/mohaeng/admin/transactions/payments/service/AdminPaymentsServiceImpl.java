package kr.or.ddit.mohaeng.admin.transactions.payments.service;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.or.ddit.mohaeng.admin.transactions.payments.mapper.IAdminPaymentsMapper;
import kr.or.ddit.mohaeng.vo.AdminPaymentsVO;

@Service
public class AdminPaymentsServiceImpl implements IAdminPaymentsService {

    @Autowired
    private IAdminPaymentsMapper mapper;

    @Override
    public List<AdminPaymentsVO> selectAdminPaymentList(Map<String, Object> params) {
        // 1. 페이지 번호 가져오기 (기본값 1)
        int currentPage = Integer.parseInt(params.getOrDefault("page", "1").toString());
        int size = 5; // 한 페이지에 5건씩

        // 2. Oracle ROWNUM 계산 (1페이지: 1~5, 2페이지: 6~10)
        int startRow = (currentPage - 1) * size + 1;
        int endRow = currentPage * size;

        params.put("startRow", startRow);
        params.put("endRow", endRow);

        return mapper.selectAdminPaymentList(params);
    }

    @Override
    public Map<String, Object> getPaymentStats() {
        return mapper.getPaymentStats();
    }
}