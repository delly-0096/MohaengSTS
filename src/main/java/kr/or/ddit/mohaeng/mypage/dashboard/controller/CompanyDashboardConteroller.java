package kr.or.ddit.mohaeng.mypage.dashboard.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.mypage.dashboard.service.CompanyDashboardService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.CompanyDashboardVO;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CompanyDashboardConteroller {

  private final CompanyDashboardService service;

  @ResponseBody
  @GetMapping("/api/company/dashboard")
  public CompanyDashboardVO dashboard(@AuthenticationPrincipal CustomUserDetails user) {
    int compNo = user.getCompNo();
    return service.getDashboard(compNo);
  }
  
  @GetMapping("/mypage/business/products")
  public String productsView() {
      return "mypage/business/products";
  }
  
  @GetMapping("/mypage/business/dashboard")
  		public String dashboardView() {
	  		return "mypage/business/dashboard";
  }
  
  @GetMapping("/mypage/business/notifications")
	public String notificationsView() {
		return "mypage/business/notifications";
}
  
}
