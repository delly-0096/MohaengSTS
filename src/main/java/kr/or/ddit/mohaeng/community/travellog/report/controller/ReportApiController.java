package kr.or.ddit.mohaeng.community.travellog.report.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.mohaeng.community.travellog.report.service.IReportService;
import kr.or.ddit.mohaeng.vo.ReportVO;

@RestController
@RequestMapping("/api/community/travel-log/reports")
public class ReportApiController {

    private final IReportService reportService;

    public ReportApiController(IReportService reportService) {
        this.reportService = reportService;
    }

    // 1) 신고 등록 (MEMBER만)
    @PreAuthorize("hasAuthority('MEMBER')")
    @PostMapping
    public ResponseEntity<ReportVO> create(@RequestBody CreateReq req, Authentication authentication) {
        Long memNo = extractMemNo(authentication);

        ReportVO vo = new ReportVO();
        vo.setMgmtType("REPORT");
        vo.setTargetType(req.getTargetType());
        vo.setTargetNo(req.getTargetNo());
        vo.setReqMemNo(memNo);
        vo.setTargetMemNo(req.getTargetMemNo()); // null이면 서비스에서 자동 조회 시도
        vo.setCtgryCd(req.getCtgryCd());
        vo.setContent(req.getContent());

        ReportVO saved = reportService.createReport(vo);
        return ResponseEntity.ok(saved);
    }

    // 2) 내 신고 목록
    @PreAuthorize("hasAuthority('MEMBER')")
    @GetMapping("/my")
    public ResponseEntity<IReportService.MyReportPageResult> my(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Authentication authentication
    ) {
        Long memNo = extractMemNo(authentication);
        return ResponseEntity.ok(reportService.listMyReports(memNo, page, size));
    }

    // 3) 신고 상세(본인 것만)
    @PreAuthorize("hasAuthority('MEMBER')")
    @GetMapping("/{rptNo}")
    public ResponseEntity<ReportVO> detail(@PathVariable Long rptNo, Authentication authentication) {
        Long memNo = extractMemNo(authentication);
        return ResponseEntity.ok(reportService.getMyReportDetail(memNo, rptNo));
    }

    // 4) 신고 취소(삭제) - WAIT만
    @PreAuthorize("hasAuthority('MEMBER')")
    @DeleteMapping("/{rptNo}")
    public ResponseEntity<Void> cancel(@PathVariable Long rptNo, Authentication authentication) {
        Long memNo = extractMemNo(authentication);
        reportService.cancelMyReport(memNo, rptNo);
        return ResponseEntity.ok().build();
    }

    // ===== 요청 DTO =====
    public static class CreateReq {
        private String targetType;     // TRIP_RECORD / COMMENT
        private Long targetNo;
        private String ctgryCd;
        private String content;
        private Long targetMemNo;      // optional(없으면 서버가 자동 계산 시도)

        public String getTargetType() { return targetType; }
        public void setTargetType(String targetType) { this.targetType = targetType; }

        public Long getTargetNo() { return targetNo; }
        public void setTargetNo(Long targetNo) { this.targetNo = targetNo; }

        public String getCtgryCd() { return ctgryCd; }
        public void setCtgryCd(String ctgryCd) { this.ctgryCd = ctgryCd; }

        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }

        public Long getTargetMemNo() { return targetMemNo; }
        public void setTargetMemNo(Long targetMemNo) { this.targetMemNo = targetMemNo; }
    }

    // ===== 로그인 사용자 memNo 추출(유틸 제거, int/Integer/Long 전부 안전 처리) =====
    private Long extractMemNo(Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            throw new IllegalStateException("인증 정보가 없습니다.");
        }

        Object principal = authentication.getPrincipal();

        // 1) CustomUser (kr.or.ddit.mohaeng.vo.CustomUser) 우선 처리
        try {
            if (principal instanceof kr.or.ddit.mohaeng.vo.CustomUser customUser) {
                Object memNoObj = customUser.getMember().getMemNo();
                if (memNoObj instanceof Number n) return n.longValue();
            }
        } catch (Throwable ignored) {}

        // 2) CustomUserDetails 대비
        try {
            if (principal instanceof kr.or.ddit.mohaeng.security.CustomUserDetails cud) {
                Object memNoObj = cud.getMember().getMemNo();
                if (memNoObj instanceof Number n) return n.longValue();
            }
        } catch (Throwable ignored) {}

        throw new IllegalStateException("principal에서 memNo를 추출할 수 없습니다. principal 타입: " + principal.getClass());
    }
}
