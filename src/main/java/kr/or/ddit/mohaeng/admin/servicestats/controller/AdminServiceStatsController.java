package kr.or.ddit.mohaeng.admin.servicestats.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.mohaeng.admin.servicestats.service.IAdminServiceStatsService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/stats")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminServiceStatsController {

	@Autowired
    private IAdminServiceStatsService statsService;

    /**
     * 서비스 통계 전체 조회
     * @param period 기간 (today, week, month, 3months, 6months)
     * @param startDate 시작일 (커스텀 기간)
     * @param endDate 종료일 (커스텀 기간)
     */
    @GetMapping("/service")
    public ResponseEntity<Map<String, Object>> getServiceStats(
            @RequestParam(defaultValue = "month") String period,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        
        log.info("서비스 통계 조회 - period: {}, startDate: {}, endDate: {}", period, startDate, endDate);
        
        Map<String, Object> stats = statsService.getServiceStats(period, startDate, endDate);
        
        return ResponseEntity.ok(stats);
    }

    /**
     * KPI 요약 조회
     */
    @GetMapping("/service/summary")
    public ResponseEntity<Map<String, Object>> getSummary(
            @RequestParam(defaultValue = "month") String period,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        
        Map<String, Object> summary = statsService.getSummary(period, startDate, endDate);
        return ResponseEntity.ok(summary);
    }

    /**
     * 일별 추이 데이터
     */
    @GetMapping("/service/daily")
    public ResponseEntity<Map<String, Object>> getDailyTrend(
            @RequestParam(defaultValue = "month") String period,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        
        Map<String, Object> dailyData = statsService.getDailyTrend(period, startDate, endDate);
        return ResponseEntity.ok(dailyData);
    }

    /**
     * 카테고리별 통계
     */
    @GetMapping("/service/category")
    public ResponseEntity<Map<String, Object>> getCategoryStats(
            @RequestParam(defaultValue = "month") String period,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        
        Map<String, Object> categoryData = statsService.getCategoryStats(period, startDate, endDate);
        return ResponseEntity.ok(categoryData);
    }

    /**
     * 상품별 성과 TOP 10
     */
    @GetMapping("/service/products")
    public ResponseEntity<Map<String, Object>> getProductPerformance(
            @RequestParam(defaultValue = "month") String period,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        
        Map<String, Object> productData = statsService.getProductPerformance(period, startDate, endDate);
        return ResponseEntity.ok(productData);
    }

    /**
     * 인기 여행지 TOP 5
     */
    @GetMapping("/service/destinations")
    public ResponseEntity<Map<String, Object>> getPopularDestinations(
            @RequestParam(defaultValue = "month") String period,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        
        Map<String, Object> destData = statsService.getPopularDestinations(period, startDate, endDate);
        return ResponseEntity.ok(destData);
    }

    /**
     * 리뷰/평점 분석
     */
    @GetMapping("/service/reviews")
    public ResponseEntity<Map<String, Object>> getReviewStats(
            @RequestParam(defaultValue = "month") String period,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        
        Map<String, Object> reviewData = statsService.getReviewStats(period, startDate, endDate);
        return ResponseEntity.ok(reviewData);
    }
    
}
