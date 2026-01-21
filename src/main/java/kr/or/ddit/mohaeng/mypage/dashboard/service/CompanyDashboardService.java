package kr.or.ddit.mohaeng.mypage.dashboard.service;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.vo.CompanyDashboardVO;

@Service
public interface CompanyDashboardService {
	  CompanyDashboardVO getDashboard(int compNo);
}
