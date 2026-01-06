package kr.or.ddit.mohaeng.mypage.inquiries.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.vo.CodeVO;
import kr.or.ddit.mohaeng.vo.InquiryVO;

public interface IMyInquiryService {

	// ========== 마이페이지용 (상태별 필터) ==========

	/**
	 * 문의 목록 조회(상태별)
	 * @param params (memNo, filter, months, pageSize, offset)
	 * @return 문의 목록
	 */
	public List<InquiryVO> getInquiryList(Map<String, Object> params);


	/**
	 * 문의 개수 조회 (상태별)
	 * @param params (memNo, filter, months)
	 * @return 문의 개수
	 */
	public int getInquiryCount(Map<String, Object> params);

	/**
	 * 문의 통계 조회
	 * @param memNo 회원번호
	 * @return 통계 정보 (total, answered, waiting)
	 */
	public Map<String, Integer> getInquiryStats(int memNo);



}
