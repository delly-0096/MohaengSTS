package kr.or.ddit.mohaeng.mypage.payments.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.mypage.payments.mapper.IMyPaymentsMapper;
import kr.or.ddit.mohaeng.vo.MyPaymentsVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Service
public class MyPaymentsServiceImpl implements IMyPaymentsService {

    @Autowired
    private IMyPaymentsMapper myPaymentsMapper;

    @Override
    public Map<String, Object> getPaymentStats(int memNo) {
        // 상단 4개 카드 데이터 (전체, 완료, 예정, 총금액) 조회
        return myPaymentsMapper.selectPaymentStats(memNo);
    }

    @Override
    public List<MyPaymentsVO> getMyPaymentList(int memNo) {
        // 항공, 숙소, 투어가 통합된 결제 리스트 조회
        return myPaymentsMapper.selectMyPaymentList(memNo);
    }

	@Override
	public int selectMyPaymentsCount(PaginationInfoVO<MyPaymentsVO> pagingVO) {
		return myPaymentsMapper.selectMyPaymentsCount(pagingVO);
	}

	@Override
	public List<MyPaymentsVO> selectMyPaymentsList(PaginationInfoVO<MyPaymentsVO> pagingVO) {
		return myPaymentsMapper.selectMyPaymentsList(pagingVO);
	}

	@Override
	public Map<String, Object> selectPaymentMaster(int payNo) {
	    return myPaymentsMapper.selectPaymentMaster(payNo);
	}

	@Override
	public List<Map<String, Object>> selectReceiptDetailList(int payNo) {
	    return myPaymentsMapper.selectReceiptDetailList(payNo);
	}
}