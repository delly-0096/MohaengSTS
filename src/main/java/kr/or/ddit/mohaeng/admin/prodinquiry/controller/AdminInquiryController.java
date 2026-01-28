package kr.or.ddit.mohaeng.admin.prodinquiry.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.mohaeng.admin.prodinquiry.service.IAdminInquiryService;
import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/inquiries")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminInquiryController {

    @Autowired
    private IAdminInquiryService adminInquiryService;

    /**
     * 문의 목록 조회 (페이징 + 필터)
     */
    @GetMapping
    public ResponseEntity<Map<String, Object>> getInquiryList(
            @RequestParam(defaultValue = "1") int currentPage,
            @RequestParam(required = false) String searchWord,
            @RequestParam(required = false) String searchCategory,
            @RequestParam(required = false) String searchStatus,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {

        Map<String, Object> params = new HashMap<>();
        params.put("currentPage", currentPage);
        params.put("pageSize", 10);
        params.put("searchWord", searchWord);
        params.put("searchCategory", "all".equals(searchCategory) ? null : searchCategory);
        params.put("searchStatus", "all".equals(searchStatus) ? null : searchStatus);
        params.put("startDate", startDate);
        params.put("endDate", endDate);

        // 페이징 계산
        int pageSize = 10;
        int startRow = (currentPage - 1) * pageSize;
        int endRow = currentPage * pageSize;
        params.put("startRow", startRow);
        params.put("endRow", endRow);

        List<TripProdInquiryVO> dataList = adminInquiryService.getInquiryList(params);
        int totalRecord = adminInquiryService.getInquiryCount(params);

        Map<String, Object> result = new HashMap<>();
        result.put("dataList", dataList);
        result.put("totalRecord", totalRecord);
        result.put("currentPage", currentPage);

        return ResponseEntity.ok(result);
    }

    /**
     * 문의 통계 조회
     */
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getInquiryStats(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {

        Map<String, Object> params = new HashMap<>();
        params.put("startDate", startDate);
        params.put("endDate", endDate);

        Map<String, Object> stats = adminInquiryService.getInquiryStats(params);
        return ResponseEntity.ok(stats);
    }

    /**
     * 문의 상세 조회
     */
    @GetMapping("/{prodInqryNo}")
    public ResponseEntity<TripProdInquiryVO> getInquiryDetail(@PathVariable int prodInqryNo) {
        TripProdInquiryVO inquiry = adminInquiryService.getInquiryDetail(prodInqryNo);
        if (inquiry == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(inquiry);
    }

    /**
     * 문의 숨김 처리
     */
    @PatchMapping("/{prodInqryNo}/hide")
    public ResponseEntity<Map<String, Object>> hideInquiry(@PathVariable int prodInqryNo) {
        Map<String, Object> result = new HashMap<>();

        try {
            int updated = adminInquiryService.hideInquiry(prodInqryNo);
            if (updated > 0) {
                result.put("success", true);
                result.put("message", "숨김 처리되었습니다.");
                return ResponseEntity.ok(result);
            } else {
                result.put("success", false);
                result.put("message", "숨김 처리에 실패했습니다.");
                return ResponseEntity.badRequest().body(result);
            }
        } catch (Exception e) {
            log.error("숨김 처리 오류: {}", e.getMessage());
            result.put("success", false);
            result.put("message", "오류가 발생했습니다.");
            return ResponseEntity.internalServerError().body(result);
        }
    }

    /**
     * 문의 숨김 해제
     */
    @PatchMapping("/{prodInqryNo}/unhide")
    public ResponseEntity<Map<String, Object>> unhideInquiry(@PathVariable int prodInqryNo) {
        Map<String, Object> result = new HashMap<>();

        try {
            int updated = adminInquiryService.unhideInquiry(prodInqryNo);
            if (updated > 0) {
                result.put("success", true);
                result.put("message", "숨김 해제되었습니다.");
                return ResponseEntity.ok(result);
            } else {
                result.put("success", false);
                result.put("message", "숨김 해제에 실패했습니다.");
                return ResponseEntity.badRequest().body(result);
            }
        } catch (Exception e) {
            log.error("숨김 해제 오류: {}", e.getMessage());
            result.put("success", false);
            result.put("message", "오류가 발생했습니다.");
            return ResponseEntity.internalServerError().body(result);
        }
    }

    /**
     * 엑셀 다운로드용 전체 목록
     */
    @GetMapping("/excel")
    public ResponseEntity<List<TripProdInquiryVO>> getInquiryListForExcel(
            @RequestParam(required = false) String searchWord,
            @RequestParam(required = false) String searchCategory,
            @RequestParam(required = false) String searchStatus,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {

        Map<String, Object> params = new HashMap<>();
        params.put("searchWord", searchWord);
        params.put("searchCategory", "all".equals(searchCategory) ? null : searchCategory);
        params.put("searchStatus", "all".equals(searchStatus) ? null : searchStatus);
        params.put("startDate", startDate);
        params.put("endDate", endDate);

        List<TripProdInquiryVO> list = adminInquiryService.getInquiryListForExcel(params);
        return ResponseEntity.ok(list);
    }
}
