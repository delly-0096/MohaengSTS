package kr.or.ddit.mohaeng.report.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.mohaeng.report.service.IReportService;
import kr.or.ddit.mohaeng.vo.ReportVO;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/report")
public class ReportApiController {

    private final IReportService reportService;

    // ✅ 일반회원만 신고 가능
    @PostMapping
    @PreAuthorize("hasAuthority('ROLE_MEMBER')")
    public ResponseEntity<?> create(@RequestBody ReportVO req,
                                    Authentication authentication) {

    	if (req.getTargetNo() == null || req.getTargetNo() <= 0) {
            return ResponseEntity.badRequest().body("targetNo is required");
        }
        if (req.getTargetType() == null || req.getTargetType().isBlank()) {
            return ResponseEntity.badRequest().body("targetType is required");
        }
    	
        Long memNo = reportService.resolveMemNo(authentication);

        req.setReqMemNo(memNo);
        req.setMgmtType("REPORT");
        req.setProcStatus("WAIT");

        int inserted = reportService.createReport(req);
        return ResponseEntity.ok(inserted); // ✅ 1이면 정상 insert
    }

}
