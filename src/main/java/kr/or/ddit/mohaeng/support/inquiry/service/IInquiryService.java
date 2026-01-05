package kr.or.ddit.mohaeng.support.inquiry.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.vo.CodeVO;
import kr.or.ddit.mohaeng.vo.InquiryVO;


public interface IInquiryService {


	// ========== 고객지원용 (카테고리별 필터) ==========

	/**
	 * 문의 목록 조회 (카테고리별)
	 * @param params (memNo, category, pageSize, offset)
	 * @return 문의 목록
	 */
	public List<InquiryVO> getInquiryListByCategory(Map<String, Object> params);

	/**
	 * 문의 개수 조회 (카테고리별)
	 * @param params (memNo, category)
	 * @return 문의 개수
	 */
	public int getInquiryCountByCategory(Map<String, Object> params);

	// ========== 공통 ==========

	/**
	 * 문의 상세 조회
	 * @param inqryNo 문의번호
	 * @return 문의 상세
	 */
	public InquiryVO getInquiryDetail(int inqryNo);

	/**
	 * 문의 등록
	 * @param inquiry 문의 정보
	 * @return 등록 결과 (성공: 1, 실패: 0)
	 */
	public int insertInquiry(InquiryVO inquiry);

	/**
	 * 문의 카테고리 목록 조회
	 * @return 카테고리 목록
	 */
	public List<CodeVO> getInquiryCategoryList();



	/**
	 * 문의 첨부파일 저장
	 * @param inqryNo
	 * @param files
	 * @return
	 */
	public int saveInquiryAttachments(int inqryNo, List<MultipartFile> files);

	// 첨부파일 목록 조회 메서드 추가
	public List<Map<String, Object>> getAttachFileList(int inqryNo);

}