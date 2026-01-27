package kr.or.ddit.mohaeng.admin.transactions.payments.mapper;

import java.util.List;
import java.util.Map;
import kr.or.ddit.mohaeng.vo.AdminPaymentsVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IAdminPaymentsMapper {
    // 결제 목록 조회
    List<AdminPaymentsVO> selectAdminPaymentList(Map<String, Object> params);
    
    // 통계 데이터 조회
    Map<String, Object> getPaymentStats();
}