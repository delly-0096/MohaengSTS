package kr.or.ddit.mohaeng.admin.report.service;

import java.util.List;

import kr.or.ddit.mohaeng.vo.CodeVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.ReportVO;

public interface IAReportService {

	//공통 코드 그룹별 조회
    List<CodeVO> getCodeByGroup(String cdgr);

    //신고 상세 조회
	ReportVO getReportDetail(Long rptNo);

	//신고 처리(제제 적용)
	/* - REPORT 테이블 업데이트
     * - 콘텐츠 숨김 처리
     * - BLACKLIST인 경우만 MEM_BLACKLIST INSERT */
	int processReport(ReportVO reportVO);

	//신고 기각
	int rejectReport(ReportVO reportVO);

	//신고 목록 조회 (페이징, 필터링)
	void getReportList(PaginationInfoVO<ReportVO> pagInfoVO);

	//블랙리스트 해제
    //- RELEASE_YN = 'Y'로 업데이트
	int releaseBlackList(int blacklistNo);

}
