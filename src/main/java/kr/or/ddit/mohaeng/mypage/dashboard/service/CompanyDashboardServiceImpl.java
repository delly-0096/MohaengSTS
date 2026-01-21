package kr.or.ddit.mohaeng.mypage.dashboard.service;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.mypage.dashboard.mapper.ICompanyDashboardMapper;
import kr.or.ddit.mohaeng.vo.CompanyDashboardVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CompanyDashboardServiceImpl implements CompanyDashboardService {

  private final ICompanyDashboardMapper mapper;

  @Override
  public CompanyDashboardVO getDashboard(int compNo) {
    CompanyDashboardVO vo = new CompanyDashboardVO();
    vo.setKpi(mapper.selectKpi(compNo));
    vo.setMonthlySalesChart(mapper.selectMonthlySalesChart(compNo, 6));
    vo.setTopProducts(mapper.selectTopProducts(compNo, 5));
    return vo;
  }
}
