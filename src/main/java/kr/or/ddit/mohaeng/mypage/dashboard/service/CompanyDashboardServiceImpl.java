package kr.or.ddit.mohaeng.mypage.dashboard.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.mypage.dashboard.mapper.ICompanyDashboardMapper;
import kr.or.ddit.mohaeng.vo.CompanyDashboardVO;
import kr.or.ddit.mohaeng.vo.PaymentVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CompanyDashboardServiceImpl implements CompanyDashboardService {

  private final ICompanyDashboardMapper mapper;

  @Override
  public CompanyDashboardVO getDashboard(int compNo) {
	  CompanyDashboardVO.Kpi kpi = mapper.selectKpi(compNo);
	 
	 

    CompanyDashboardVO vo = new CompanyDashboardVO();
    vo.setKpi(mapper.selectKpi(compNo));
    System.out.println("🔥 KPI = " + kpi);
    System.out.println("compNo=" + compNo);

	/*
	 * vo.setMonthlySalesChart(mapper.selectMonthlySalesChart(compNo, 6));
	 * vo.setTopProducts(mapper.selectTopProducts(compNo, 5));
	 */
    return vo;
  }

  @Override 
  public List<PaymentVO> selectPaymentList(int memNo) {
	  System.out.println("memNo=" + memNo);
	return mapper.selectPaymentList(memNo);
  }
 
}
