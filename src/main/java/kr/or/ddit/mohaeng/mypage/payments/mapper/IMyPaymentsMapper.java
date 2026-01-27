package kr.or.ddit.mohaeng.mypage.payments.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.MyPaymentsVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Mapper
public interface IMyPaymentsMapper {
    // 상단 통계 카드 데이터 조회
    public Map<String, Object> selectPaymentStats(int memNo);
    // 통합 결제 내역 리스트 조회
    public List<MyPaymentsVO> selectMyPaymentList(int memNo);

    public int selectMyPaymentsCount(PaginationInfoVO<MyPaymentsVO> pagingVO);
    public List<MyPaymentsVO> selectMyPaymentsList(PaginationInfoVO<MyPaymentsVO> pagingVO);
    
    public Map<String, Object> selectPaymentMaster(int payNo);
    public List<Map<String, Object>> selectReceiptDetailList(int payNo);
	public void updateFileUseN(String filePath);
	
	Long nextAttachNo();
    Long nextFileNo();
    int insertAttachFile(Map<String, Object> params);
    int insertAttachFileDetail(Map<String, Object> params);
}