package kr.or.ddit.mohaeng.admin.servicestats.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IAdminServiceStatsMapper {
	public Long getTotalRevenue(Map<String, Object> params);
	public int getTotalOrders(Map<String, Object> params);
	public Long getTotalViews();
	public Double getAvgRating(Map<String, Object> params);
	public int getTotalReviews(Map<String, Object> params);
	public List<Map<String, Object>> getDailyTrend(Map<String, Object> params);
	public List<Map<String, Object>> getCategoryStats(Map<String, Object> params);
	public List<Map<String, Object>> getProductPerformance(Map<String, Object> params);
	public List<Map<String, Object>> getPopularDestinations(Map<String, Object> params);
	public List<Map<String, Object>> getRatingDistribution(Map<String, Object> params);
}
