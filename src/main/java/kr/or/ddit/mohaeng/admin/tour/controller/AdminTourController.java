package kr.or.ddit.mohaeng.admin.tour.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.admin.tour.service.IAdminTourService;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/products/tours")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminTourController {
	
	@Autowired
    private IAdminTourService adminTourService;

	/**
     * 투어 관리 목록 조회 (페이징 + 필터)
     */
    @GetMapping
    public ResponseEntity<PaginationInfoVO<TripProdVO>> getTourList(
            @RequestParam(defaultValue = "1") int currentPage,
            @RequestParam(defaultValue = "") String searchWord,
            @RequestParam(defaultValue = "all") String searchType,
            @RequestParam(defaultValue = "all") String searchStatus,
            @RequestParam(defaultValue = "all") String searchRegion
    ) {
        log.info("투어관리 목록 조회: page={}, word={}, type={}, status={}, region={}", 
                currentPage, searchWord, searchType, searchStatus, searchRegion);

        PaginationInfoVO<TripProdVO> pagInfoVO = new PaginationInfoVO<>(10, 5);
        pagInfoVO.setCurrentPage(currentPage);
        pagInfoVO.setSearchWord(searchWord);
        pagInfoVO.setSearchType(searchType);
        pagInfoVO.setSearchStatus(searchStatus);
        pagInfoVO.setSearchRegion(searchRegion);

        adminTourService.getTourList(pagInfoVO);
        return ResponseEntity.ok(pagInfoVO);
    }

    /**
     * 엑셀 다운로드용 전체 목록 조회
     */
    @GetMapping("/excel")
    public ResponseEntity<List<TripProdVO>> getTourListForExcel(
            @RequestParam(defaultValue = "") String searchWord,
            @RequestParam(defaultValue = "all") String searchType,
            @RequestParam(defaultValue = "all") String searchStatus,
            @RequestParam(defaultValue = "all") String searchRegion
    ) {
        log.info("투어 엑셀 다운로드: word={}, type={}, status={}, region={}", 
                searchWord, searchType, searchStatus, searchRegion);

        Map<String, Object> params = new HashMap<>();
        params.put("searchWord", searchWord);
        params.put("searchType", searchType);
        params.put("searchStatus", searchStatus);
        params.put("searchRegion", searchRegion);

        List<TripProdVO> list = adminTourService.getTourListAll(params);
        return ResponseEntity.ok(list);
    }

    /**
     * 투어 상세 조회
     */
    @GetMapping("/{tripProdNo}")
    public ResponseEntity<TripProdVO> getTourDetail(@PathVariable("tripProdNo") int tripProdNo) {
        log.info("[ADMIN][TOUR] 상세 조회: tripProdNo={}", tripProdNo);

        TripProdVO tourDetail = adminTourService.getTourDetail(tripProdNo);

        if (tourDetail == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(tourDetail);
    }

    /**
     * 상품 최종 승인
     */
    @PatchMapping("/approve/{tripProdNo}")
    public ResponseEntity<?> approve(@PathVariable int tripProdNo) {
        log.info("투어 승인 요청: tripProdNo={}", tripProdNo);
        
        int result = adminTourService.approveTour(tripProdNo);
        if (result > 0) {
            return ResponseEntity.ok("승인 완료!");
        }
        return ResponseEntity.status(500).body("승인 실패..");
    }

    /**
     * 판매 상태 토글
     */
    @PatchMapping("/toggle-sale")
    public ResponseEntity<?> toggleSale(@RequestBody Map<String, Object> params) {
        log.info("투어 상태 토글: {}", params);
        
        int result = adminTourService.toggleSaleStatus(params);
        return ResponseEntity.ok(result);
    }

    /**
     * 투어 삭제
     */
    @DeleteMapping("/delete/{tripProdNo}")
    public ResponseEntity<?> delete(@PathVariable int tripProdNo) {
        log.info("투어 삭제 요청: tripProdNo={}", tripProdNo);
        
        int result = adminTourService.deleteTour(tripProdNo);
        if (result > 0) {
            return ResponseEntity.ok("삭제 완료!");
        }
        return ResponseEntity.status(500).body("삭제 실패..");
    }
    
    /**
     * 투어 통계 조회
     */
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getTourStats() {
        log.info("투어 통계 조회");
        Map<String, Object> stats = adminTourService.getTourStats();
        return ResponseEntity.ok(stats);
    }
}
