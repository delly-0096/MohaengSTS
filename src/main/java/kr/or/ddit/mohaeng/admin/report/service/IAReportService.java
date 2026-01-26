package kr.or.ddit.mohaeng.admin.report.service;

import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.ReportVO;

public interface IAReportService {

	Object getCodeByGroup(String string);

	ReportVO getReportDetail(Long rptNo);

	int processReport(ReportVO reportVO);

	int rejectReport(ReportVO reportVO);

	int releaseBlackList(int blacklistNo);

	void getReportList(PaginationInfoVO<ReportVO> pagInfoVO);


}
