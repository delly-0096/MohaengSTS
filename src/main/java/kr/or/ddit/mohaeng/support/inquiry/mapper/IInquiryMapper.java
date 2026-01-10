package kr.or.ddit.mohaeng.support.inquiry.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.CodeVO;
import kr.or.ddit.mohaeng.vo.InquiryVO;

//문의 Mapper
@Mapper
public interface IInquiryMapper {

	 // ========== 마이페이지용 (상태별 조회) ==========

		//문의 목록 조회 (상태별)
		public List<InquiryVO> selectInquiryList(Map<String, Object> params);

		//문의 개수 조회 (상태별)
		public int selectInquiryCount(Map<String, Object> params);

		//전체 문의 개수
		public Integer selectTotalCount(int memNo);

		//답변 완료 문의 개수
		public Integer selectAnsweredCount(int memNo);

		//답변 대기 문의 개수
		public Integer selectWaitingCount(int memNo);


	  // ========== 고객지원용 (카테고리별 조회) ==========

		//문의 목록 조회 (카테고리별)
		public int selectInquiryCountByCategory(Map<String, Object> params);

		//문의 개수 조회 (카테고리별)
		public List<InquiryVO> selectInquiryListByCategory(Map<String, Object> params);


	  // ========== 공통 ==========

		//문의 상세 조회
		public InquiryVO selectInquiryDetail(int inqryNo);

		//문의 등록
		public int insertInquiry(InquiryVO inquiry);

		//문의 카테고리 목록 조회
		public List<CodeVO> selectInquiryCategoryList();

		//첨부파일 정보 저장(ATTACH_FILE 테이블)
		public void insertAttachFile(Map<String, Object> attachFileMap);

		//문의 첨부파일 개수 업데이트
		public void updateInquiryAttachCount( @Param("attachNo") int inqryNo, @Param("inqryNo")int savedCount);

		// 첨부파일 상세 정보 저장 (ATTACH_FILE_DETAIL 테이블)
		public void insertAttachFileDetail(Map<String, Object> fileDetailMap);

		//첨부파일 목록 조회
		public List<Map<String, Object>> selectAttachFileList(int inqryNo);

		//다운로드용
		public Map<String, Object> selectAttachFile(int fileNo);



}
