package kr.or.ddit.mohaeng.mypage.dashboard.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
	

	public List<MonthlySalesPoint> selectMonthlySalesChart(int compNo, int i);

	public List<TopTripProd> selectTopProducts(int compNo, int i);
}