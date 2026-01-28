package kr.or.ddit.mohaeng.admin.transactions.payments.mapper;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import kr.or.ddit.mohaeng.vo.AdminPaymentsVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
@Mapper
public interface IAdminPaymentsMapper {
    Map<String, Object> selectAdminPaymentStats();
    int selectAdminPaymentsCount(PaginationInfoVO<AdminPaymentsVO> pagingVO);
    List<AdminPaymentsVO> selectAdminPaymentsList(PaginationInfoVO<AdminPaymentsVO> pagingVO);
}