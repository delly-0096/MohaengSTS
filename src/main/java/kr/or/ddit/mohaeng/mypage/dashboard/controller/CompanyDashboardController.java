package kr.or.ddit.mohaeng.mypage.dashboard.controller;

import java.util.List;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.mypage.dashboard.service.CompanyDashboardService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.CompanyDashboardVO;
import kr.or.ddit.mohaeng.vo.PaymentVO;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CompanyDashboardController {

  private final CompanyDashboardService service;
 
  @ResponseBody
  @GetMapping("/api/company/dashboard")
  public CompanyDashboardVO dashboard(@AuthenticationPrincipal CustomUserDetails user) {
		/* int compNo = user.getCompNo(); */
	int memNo = user.getMemNo();
    return service.getDashboard(memNo);
  }
  
  @GetMapping("/mypage/business/products")
  public String productsView() {
      return "mypage/business/products";
  }
  
  @GetMapping("/mypage/business/dashboard")
  		public String dashboardView(@AuthenticationPrincipal CustomUserDetails user, Model model) {
	  int memNo = user.getMemNo();
	  // 회사번호를 가져오는 코드가 현재 없어서 임시로 해결. 나중에 기업회원 테이블 및 회사 정보 테이블 조회하는 코드 필요
		/* int compNo= user.getCompNo(); */
	  System.out.println("memNo=" + user.getMemNo());
		/* System.out.println("compNo=" + user.getCompNo()); */
	  System.out.println("principal=" + user);

	  
	  CompanyDashboardVO dashboard = service.getDashboard(memNo);
	  model.addAttribute("dashboard", dashboard);
	  List<PaymentVO> paymentList = service.selectPaymentList(memNo);
	  model.addAttribute("paymentList", paymentList);
	  
	  System.out.println("dashboard : " + dashboard);
	
	  return "mypage/business/dashboard";
  }
  
  @GetMapping("/mypage/business/notifications")
	public String notificationsView() {
		return "mypage/business/notifications";
}
  
}
