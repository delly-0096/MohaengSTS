package kr.or.ddit.mohaeng.admin.servicestats.service;

import java.util.Map;

public interface IAdminServiceStatsService {
    public Map<String, Object> getServiceStats(String period, String startDate, String endDate);
    public Map<String, Object> getSummary(String period, String startDate, String endDate);
    public Map<String, Object> getDailyTrend(String period, String startDate, String endDate);
    public Map<String, Object> getCategoryStats(String period, String startDate, String endDate);
    public Map<String, Object> getProductPerformance(String period, String startDate, String endDate);
    public Map<String, Object> getPopularDestinations(String period, String startDate, String endDate);
    public Map<String, Object> getReviewStats(String period, String startDate, String endDate);
}
