package kr.or.ddit.mohaeng.mypage.payments.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.vo.MyPaymentsVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface IMyPaymentsService {
    public Map<String, Object> getPaymentStats(int memNo);
    public List<MyPaymentsVO> getMyPaymentList(int memNo);
    
    // 페이징VO를 활용한 목록 조회시
	public int selectMyPaymentsCount(PaginationInfoVO<MyPaymentsVO> pagingVO);
	public List<MyPaymentsVO> selectMyPaymentsList(PaginationInfoVO<MyPaymentsVO> pagingVO);
	
	// 영수증 마스터 정보 (결제 기본 정보 및 회원 정보)
	public Map<String, Object> selectPaymentMaster(int payNo);
	// 영수증 상세 품목 리스트 (구매한 상품들)
	public List<Map<String, Object>> selectReceiptDetailList(int payNo);
	public void updateFileUseN(String filePath);
	public Long processReviewFiles(MultipartFile[] files, int memNo, Long existingAttachNo);
}