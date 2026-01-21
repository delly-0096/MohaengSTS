package kr.or.ddit.mohaeng.mypage.dashboard.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.CompanyDashboardVO;

@Mapper
public interface ICompanyDashboardMapper {
	
	CompanyDashboardVO.Kpi selectKpi(@Param("compNo") int compNo);

	  List<CompanyDashboardVO.MonthlySalesPoint> selectMonthlySalesChart(
	      @Param("compNo") int compNo,
	      @Param("months") int months
	  );

	  List<CompanyDashboardVO.TopTripProd> selectTopProducts(
	      @Param("compNo") int compNo,
	      @Param("limit") int limit
	  );

	  int selectSellingProductCount(@Param("compNo") int compNo);
	}


