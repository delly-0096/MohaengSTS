package kr.or.ddit.mohaeng.admin.inquiry.service;

import java.util.Map;

import kr.or.ddit.mohaeng.vo.InquiryVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface IAQnaService {

	// 1. 관리자 문의 목록 조회 (검색/필터/페이징 포함)
	PaginationInfoVO<InquiryVO> aInquiryList(PaginationInfoVO<InquiryVO> pagingVO, InquiryVO inquiryVO);

	// 2. 관리자 문의 상세 조회 (내용 + 첨부파일)
	InquiryVO aInquiryDetail(int inqryNo);

	// 3. 관리자 답변 등록 + 답변 알림 생성
	int aInquiryReply(InquiryVO inquiryVO);

	// 4. 관리자 문의 삭제 + 삭제 사유 알림 생성
	int aInquiryDelete(int inqryNo, String reason);



}
