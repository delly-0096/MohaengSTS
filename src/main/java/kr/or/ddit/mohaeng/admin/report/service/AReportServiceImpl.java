package kr.or.ddit.mohaeng.admin.report.service;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.ReportVO;

@Service
public class AReportServiceImpl implements IAReportService {

	@Override
	public Object getCodeByGroup(String string) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ReportVO getReportDetail(Long rptNo) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int processReport(ReportVO reportVO) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int rejectReport(ReportVO reportVO) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int releaseBlackList(int blacklistNo) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void getReportList(PaginationInfoVO<ReportVO> pagInfoVO) {
		// TODO Auto-generated method stub

	}



}
