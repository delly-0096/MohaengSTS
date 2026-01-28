package kr.or.ddit.mohaeng.mypage.dashboard.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.mypage.dashboard.mapper.ICompanyDashboardMapper;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.CompanyDashboardVO;
import kr.or.ddit.mohaeng.vo.PaymentVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CompanyDashboardServiceImpl implements CompanyDashboardService {

  private final ICompanyDashboardMapper mapper;

  @Override
  public CompanyDashboardVO getDashboard(int compNo) {

	CompanyDashboardVO vo = new CompanyDashboardVO();
	CompanyDashboardVO.Kpi kpi = mapper.selectKpi(compNo); 

    vo.setKpi(mapper.selectKpi(compNo));
    System.out.println("🔥 KPI = " + kpi);
    System.out.println("compNo=" + compNo);
    
    List<TripProdVO> myProducts = mapper.selectMyProductList(compNo);
    vo.setProductList(myProducts);										// 내 상품현황 
    vo.setMonthlySalesChart(mapper.selectMonthlySalesChart(compNo, 6));	// 최근 6개월간 매출 현황
    vo.setCategoryRatio(mapper.selectCategoryRatio(compNo));			// 상품 카테고리 현황
    
    vo.setUpcomingReservations(mapper.selectUpcomingReservations(compNo));
    vo.setRecentReviews(mapper.selectRecentReviews(compNo));
    vo.setTodayArrivalCount(mapper.selectTodayArrivalCount(compNo));
   
    // 오늘 도착 예정 건수 세팅
    int todayCount = mapper.selectTodayArrivalCount(compNo);
    vo.setTodayArrivalCount(todayCount);

	/*
	 * vo.setTopProducts(mapper.selectTopProducts(compNo, 5));
	 */
    return vo;
  }

  @Override 
  public List<PaymentVO> selectPaymentList(int memNo) {
	  System.out.println("memNo=" + memNo);
	return mapper.selectPaymentList(memNo);
  }

  @Override
  public int selectPaymentCount(int memNo) {
	
	return mapper.selectPaymentCount(memNo);
  }

  @Override
  public List<PaymentVO> selectPaymentListPaging(int memNo, int startRow, int endRow) {
    return mapper.selectPaymentListPaging(memNo, startRow, endRow);
  }
 
}
