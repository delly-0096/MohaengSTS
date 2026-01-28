package kr.or.ddit.mohaeng.mypage.dashboard.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.CompanyDashboardVO;
import kr.or.ddit.mohaeng.vo.CompanyDashboardVO.MonthlySalesPoint;
import kr.or.ddit.mohaeng.vo.CompanyDashboardVO.TopTripProd;
import kr.or.ddit.mohaeng.vo.PaymentVO;

@Mapper
public interface ICompanyDashboardMapper {
	/* public CompanyDashboardVO.Kpi selectKpi(@Param("compNo") int compNo); */
	public CompanyDashboardVO.Kpi selectKpi(int memNo);

	/*
	 * public List<CompanyDashboardVO.MonthlySalesPoint>
	 * selectMonthlySalesChart(@Param("compNo") int compNo, @Param("months") int
	 * months); public List<CompanyDashboardVO.TopTripProd>
	 * selectTopProducts(@Param("compNo") int compNo, @Param("limit") int limit);
	 * public int selectSellingProductCount(@Param("compNo") int compNo);
	 */
	public List<PaymentVO> selectPaymentList(int memNo);
	public List<TopTripProd> selectTopProducts(Map<String, Object> topParam);
	public List<TopTripProd> selectTopProducts(int compNo, int i);
	
	// 매출현황
	public List<MonthlySalesPoint> selectMonthlySalesChart(int compNo, int i);

	// 내 상품현황
	public List<TripProdVO> selectMyProductList(int compNo);

	// 상품 카테고리 현황
	public List<Map<String, Object>> selectCategoryRatio(int compNo);

	// 다가오는 예약 현황
	public List<Map<String, Object>> selectUpcomingReservations(int compNo);

	// 최근 리뷰
	public List<Map<String, Object>> selectRecentReviews(int compNo);

	// 오늘 이용 상품 수
	public int selectTodayArrivalCount(int compNo);
	
	//페이징
	public int selectPaymentCount(int memNo);

	List<PaymentVO> selectPaymentListPaging(
	    @Param("memNo") int memNo,
	    @Param("startRow") int startRow,
	    @Param("endRow") int endRow
	);

}