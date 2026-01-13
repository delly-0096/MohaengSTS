package kr.or.ddit.mohaeng.admin.inquiry.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.AlarmVO;
import kr.or.ddit.mohaeng.vo.InquiryVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Mapper
public interface IQnaMapper {

	// 1. 목록 카운트 (멀티 파라미터 대응)
    int aInquiryCount(@Param("paging") PaginationInfoVO<InquiryVO> pagingVO, @Param("inquiry") InquiryVO inquiryVO);

    // 2. 목록 조회 (멀티 파라미터 대응)
    List<InquiryVO> aInquiryList(@Param("paging") PaginationInfoVO<InquiryVO> pagingVO, @Param("inquiry") InquiryVO inquiryVO);

    // 3. 상세 조회
    InquiryVO aInquiryDetail(int inqryNo);

    // 4. 첨부파일 목록
    List<Map<String, Object>> aAttachFileList(int inqryNo);

    // 5. 답변 등록
    int aInquiryReply(InquiryVO inquiryVO);

    // 6. 문의 삭제
    int inquiryDelete(int inqryNo);

    // 7. 알람 통합 인서트
    void insertAlarm(AlarmVO alarm);

    //다운로드용
	Map<String, Object> selectAttachFile(int fileNo);


}
