package kr.or.ddit.mohaeng.report.service;

import org.springframework.security.core.Authentication;

import kr.or.ddit.mohaeng.vo.ReportVO;

public interface IReportService {
    int createReport(ReportVO report);
    Long resolveMemNo(Authentication authentication);
}
