package kr.or.ddit.mohaeng.community.travellog.report.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.community.travellog.report.mapper.IReportMapper;
import kr.or.ddit.mohaeng.vo.ReportVO;

@Service
public class ReportServiceImpl implements IReportService {

    private final IReportMapper reportMapper;

    public ReportServiceImpl(IReportMapper reportMapper) {
        this.reportMapper = reportMapper;
    }

    private static final DateTimeFormatter REQ_DT_FMT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");

    @Override
    @Transactional
    public ReportVO createReport(ReportVO req) {
        // 1) 필수값 검증(가벼운 수준)
        if (req.getReqMemNo() == null) throw new IllegalArgumentException("reqMemNo는 필수입니다.");
        if (req.getTargetType() == null || req.getTargetType().isBlank()) throw new IllegalArgumentException("targetType은 필수입니다.");
        if (req.getTargetNo() == null) throw new IllegalArgumentException("targetNo는 필수입니다.");
        if (req.getCtgryCd() == null || req.getCtgryCd().isBlank()) throw new IllegalArgumentException("ctgryCd는 필수입니다.");

        // 2) 중복 신고 방지 (WAIT 상태 중복 차단)
        int exists = reportMapper.existsWaitReport(req.getReqMemNo(), req.getTargetType(), req.getTargetNo());
        if (exists > 0) {
            throw new IllegalStateException("이미 동일 대상에 대해 처리 대기(WAIT) 상태의 신고가 존재합니다.");
        }

        // 3) targetMemNo 없으면 서버에서 자동 조회(가능한 대상만)
        if (req.getTargetMemNo() == null) {
            Long targetWriter = resolveTargetWriterMemNo(req.getTargetType(), req.getTargetNo());
            req.setTargetMemNo(targetWriter); // 없으면 null로 들어갈 수도 있음(테이블 설계상 허용)
        }

        // 4) 기본값 세팅
        if (req.getMgmtType() == null || req.getMgmtType().isBlank()) req.setMgmtType("REPORT");
        if (req.getProcStatus() == null || req.getProcStatus().isBlank()) req.setProcStatus("WAIT");
        if (req.getReqDt() == null || req.getReqDt().isBlank()) {
            req.setReqDt(LocalDateTime.now().format(REQ_DT_FMT));
        }

        // 5) insert
        reportMapper.insertReport(req);

        // 6) 방금 등록 건 조회(등록 결과를 바로 반환하고 싶으면 다시 select가 필요하지만,
        //    여기서는 rptNo가 시퀀스로 채워졌다고 가정하고 req 객체를 그대로 반환)
        return req;
    }

    private Long resolveTargetWriterMemNo(String targetType, Long targetNo) {
        // targetType은 DB 코멘트에 TRIP_RECORD, COMMENT 등으로 되어있음
        // 우리가 쓰는 댓글 테이블명은 COMMENTS이고, targetType은 "COMMENT"로 받기로 함.
        return switch (targetType) {
            case "TRIP_RECORD" -> reportMapper.selectTripRecordWriterMemNo(targetNo);
            case "COMMENT" -> reportMapper.selectCommentWriterMemNo(targetNo);
            default -> null; // BOARD/TRIP_PROD는 추후 확장
        };
    }

    @Override
    public MyReportPageResult listMyReports(Long reqMemNo, int page, int size) {
        if (page < 1) page = 1;
        if (size < 1) size = 10;

        int total = reportMapper.countMyReports(reqMemNo);
        int offset = (page - 1) * size;
        List<ReportVO> items = reportMapper.listMyReports(reqMemNo, offset, size);

        return new MyReportPageResult(page, size, total, items);
    }

    @Override
    public ReportVO getMyReportDetail(Long reqMemNo, Long rptNo) {
        ReportVO vo = reportMapper.selectMyReportDetail(rptNo, reqMemNo);
        if (vo == null) throw new IllegalStateException("신고 내역을 찾을 수 없습니다.");
        return vo;
    }

    @Override
    @Transactional
    public void cancelMyReport(Long reqMemNo, Long rptNo) {
        String status = reportMapper.selectProcStatusForOwner(rptNo, reqMemNo);
        if (status == null) throw new IllegalStateException("신고 내역을 찾을 수 없습니다.");

        // WAIT 상태일 때만 취소 허용(설계 확정)
        if (!"WAIT".equals(status)) {
            throw new IllegalStateException("처리 대기(WAIT) 상태에서만 신고 취소가 가능합니다. 현재 상태: " + status);
        }

        int deleted = reportMapper.deleteMyReport(rptNo, reqMemNo);
        if (deleted == 0) throw new IllegalStateException("신고 취소에 실패했습니다.");
    }
}
