package kr.or.ddit.mohaeng.mypage.dashboard.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.mypage.dashboard.service.CompanyDashboardService;
import kr.or.ddit.mohaeng.mypage.notifications.service.INotificationsAlarmService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.AlarmVO;
import kr.or.ddit.mohaeng.vo.CompanyDashboardVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.PaymentVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class CompanyDashboardController {

  private final CompanyDashboardService service;
  
  @Autowired
  private INotificationsAlarmService notificationsAlarmService;
 
  @ResponseBody
  @GetMapping("/api/company/dashboard")
  public CompanyDashboardVO dashboard(@AuthenticationPrincipal CustomUserDetails user) {
	  return service.getDashboard(user.getMemNo());
  }
  
  @GetMapping("/mypage/business/products")
  public String productsView() {
      return "mypage/business/products";
  }
  
  	@GetMapping("/mypage/business/dashboard")
  		public String dashboardView(@AuthenticationPrincipal CustomUserDetails user, Model model , 
  				                    @RequestParam(name="page", defaultValue="1") int page) {
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
	  
	  PaginationInfoVO<PaymentVO> pagingVO = new PaginationInfoVO<>(10, 5); // screenSize=10, blockSize=5
	  pagingVO.setCurrentPage(page);

	  int totalCount = service.selectPaymentCount(memNo);
	  pagingVO.setTotalRecord(totalCount);

	  List<PaymentVO> pagingPaymentList =
	      service.selectPaymentListPaging(memNo, pagingVO.getStartRow(), pagingVO.getEndRow());

	  model.addAttribute("pagingVO", pagingVO);
	  model.addAttribute("pagingPaymentList", pagingPaymentList);
	  
	  ///mypage/business/notifications의 알림내역 목록 시작
	  PaginationInfoVO<AlarmVO> pagingVO2 = new PaginationInfoVO<>();
	  pagingVO2.setMemNo(user.getMemNo());
	  pagingVO2.setEndRow(10);
	  pagingVO2.setStartRow(1);
	  log.info("notifications memNo={}", user.getMemNo());
	  List<AlarmVO> list = notificationsAlarmService.selectAlarmList(pagingVO2); 
	  log.info("list:{}" + list);
	  model.addAttribute("alarmList",list);
	  

	  ///mypage/business/notifications의 알림내역 목록 끝
	  
	  System.out.println("dashboard : " + dashboard);
	
	  return "mypage/business/dashboard";
  }
  
  
	/*
	 * @GetMapping("/mypage/business/notifications") public String
	 * notificationsView() { return "mypage/business/notifications"; }
	 */
  
}
