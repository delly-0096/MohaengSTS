package kr.or.ddit.mohaeng.admin.servicestats.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.admin.servicestats.mapper.IAdminServiceStatsMapper;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminServiceStatsServiceImpl implements IAdminServiceStatsService {

	@Autowired
    private IAdminServiceStatsMapper statsMapper;

    /**
     * 기간에 따른 시작일/종료일 계산
     */
    private Map<String, String> calculateDateRange(String period, String startDate, String endDate) {
        Map<String, String> dateRange = new HashMap<>();
        LocalDate now = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        
        if (startDate != null && endDate != null) {
            // 커스텀 기간
            dateRange.put("startDate", startDate);
            dateRange.put("endDate", endDate);
        } else {
            // 프리셋 기간
            LocalDate start;
            switch (period) {
                case "today":
                    start = now;
                    break;
                case "week":
                    start = now.minusWeeks(1);
                    break;
                case "month":
                    start = now.minusMonths(1);
                    break;
                case "3months":
                    start = now.minusMonths(3);
                    break;
                case "6months":
                    start = now.minusMonths(6);
                    break;
                default:
                    start = now.minusMonths(1);
            }
            dateRange.put("startDate", start.format(formatter));
            dateRange.put("endDate", now.format(formatter));
        }
        
        return dateRange;
    }

    @Override
    public Map<String, Object> getServiceStats(String period, String startDate, String endDate) {
        Map<String, String> dateRange = calculateDateRange(period, startDate, endDate);
        Map<String, Object> result = new HashMap<>();
        
        result.put("summary", getSummary(period, startDate, endDate));
        result.put("dailyTrend", getDailyTrend(period, startDate, endDate));
        result.put("categoryStats", getCategoryStats(period, startDate, endDate));
        result.put("productPerformance", getProductPerformance(period, startDate, endDate));
        result.put("popularDestinations", getPopularDestinations(period, startDate, endDate));
        result.put("reviewStats", getReviewStats(period, startDate, endDate));
        result.put("dateRange", dateRange);
        
        return result;
    }

    @Override
    public Map<String, Object> getSummary(String period, String startDate, String endDate) {
        Map<String, String> dateRange = calculateDateRange(period, startDate, endDate);
        Map<String, Object> params = new HashMap<>(dateRange);
        
        Map<String, Object> summary = new HashMap<>();
        
        // 총 매출
        Long totalRevenue = statsMapper.getTotalRevenue(params);
        summary.put("totalRevenue", totalRevenue != null ? totalRevenue : 0);
        
        // 총 결제 건수
        int totalOrders = statsMapper.getTotalOrders(params);
        summary.put("totalOrders", totalOrders);
        
        // 평균 객단가
        long avgOrderValue = totalOrders > 0 ? (totalRevenue != null ? totalRevenue / totalOrders : 0) : 0;
        summary.put("avgOrderValue", avgOrderValue);
        
        // 총 조회수
        Long totalViews = statsMapper.getTotalViews();
        summary.put("totalViews", totalViews != null ? totalViews : 0);
        
        // 평균 평점
        Double avgRating = statsMapper.getAvgRating(params);
        summary.put("avgRating", avgRating != null ? Math.round(avgRating * 10) / 10.0 : 0);
        
        // 총 리뷰 수
        int totalReviews = statsMapper.getTotalReviews(params);
        summary.put("totalReviews", totalReviews);
        
        return summary;
    }

    @Override
    public Map<String, Object> getDailyTrend(String period, String startDate, String endDate) {
        Map<String, String> dateRange = calculateDateRange(period, startDate, endDate);
        Map<String, Object> params = new HashMap<>(dateRange);
        
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> dailyData = statsMapper.getDailyTrend(params);
        result.put("data", dailyData);
        
        return result;
    }

    @Override
    public Map<String, Object> getCategoryStats(String period, String startDate, String endDate) {
        Map<String, String> dateRange = calculateDateRange(period, startDate, endDate);
        Map<String, Object> params = new HashMap<>(dateRange);
        
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> categoryData = statsMapper.getCategoryStats(params);
        result.put("data", categoryData);
        
        return result;
    }

    @Override
    public Map<String, Object> getProductPerformance(String period, String startDate, String endDate) {
        Map<String, String> dateRange = calculateDateRange(period, startDate, endDate);
        Map<String, Object> params = new HashMap<>(dateRange);
        
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> productData = statsMapper.getProductPerformance(params);
        result.put("data", productData);
        
        return result;
    }

    @Override
    public Map<String, Object> getPopularDestinations(String period, String startDate, String endDate) {
        Map<String, String> dateRange = calculateDateRange(period, startDate, endDate);
        Map<String, Object> params = new HashMap<>(dateRange);
        
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> destData = statsMapper.getPopularDestinations(params);
        result.put("data", destData);
        
        return result;
    }

    @Override
    public Map<String, Object> getReviewStats(String period, String startDate, String endDate) {
        Map<String, String> dateRange = calculateDateRange(period, startDate, endDate);
        Map<String, Object> params = new HashMap<>(dateRange);
        
        Map<String, Object> result = new HashMap<>();
        
        // 평균 평점
        Double avgRating = statsMapper.getAvgRating(params);
        result.put("avgRating", avgRating != null ? Math.round(avgRating * 10) / 10.0 : 0);
        
        // 총 리뷰 수
        int totalReviews = statsMapper.getTotalReviews(params);
        result.put("totalReviews", totalReviews);
        
        // 평점 분포
        List<Map<String, Object>> ratingDist = statsMapper.getRatingDistribution(params);
        result.put("ratingDistribution", ratingDist);
        
        return result;
    }

}
