package kr.or.ddit.mohaeng.report.service;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.report.exception.DuplicateReportException;
import kr.or.ddit.mohaeng.report.mapper.IReportMapper;
import kr.or.ddit.mohaeng.vo.ReportVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReportServiceImpl implements IReportService {

    private final IReportMapper reportMapper;

    @Override
    @Transactional
    public int createReport(ReportVO report) {

        if (report.getMgmtType() == null) report.setMgmtType("REPORT");
        if (report.getProcStatus() == null) report.setProcStatus("WAIT");

        // DB에서 SYSDATE 사용
        report.setReqDt(null);

        // 중복 신고 체크
        int exists = reportMapper.existsDuplicateReport(report);
        if (exists == 1) {
            throw new DuplicateReportException("이미 신고한 내역이 존재합니다.");
        }

        return reportMapper.insertReport(report);
    }

    @Override
    public Long resolveMemNo(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
            || "anonymousUser".equals(String.valueOf(authentication.getPrincipal()))) {
            throw new IllegalStateException("로그인이 필요합니다.");
        }

        return (long) ((kr.or.ddit.mohaeng.security.CustomUserDetails)
                authentication.getPrincipal())
                .getMember()
                .getMemNo();
    }
}
