package kr.or.ddit.mohaeng.mypage.notifications.controller;

import java.util.List;

import org.apache.catalina.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.mohaeng.mypage.notifications.service.INotificationsAlarmService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.support.notice.service.INoticeService;
import kr.or.ddit.mohaeng.vo.AlarmVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;
@Slf4j
@Controller
@RequestMapping("/mypage/business")
public class NotificationsAlarmController {
	
	@Autowired
	private INotificationsAlarmService notificationsAlarmService;
	
	/*
	 * 알림 페이지 내역
	 */
	@GetMapping("/notifications")
	public String page(@RequestParam(name="page", required=false, defaultValue = "1")int currentPage,
					   @RequestParam(name="type", required=false, defaultValue="ALL") String type,
					   @AuthenticationPrincipal CustomUserDetails user, Model model){
		
		PaginationInfoVO<AlarmVO> pagingVO = new PaginationInfoVO<>();
		pagingVO.setMemNo(user.getMemNo());
		log.info("notifications memNo={}", user.getMemNo());
		 // 검색시 추가
		  pagingVO.setCurrentPage(currentPage); 
		   pagingVO.setSearchType(type);
		   
		  int totalRecord = notificationsAlarmService.selectAlarmCount(pagingVO);
		  pagingVO.setTotalPage(totalRecord); 
		  
		  List<AlarmVO> list = notificationsAlarmService.selectAlarmList(pagingVO); 
		  log.info("list:{}" + list);
		
		  model.addAttribute("pagingVO", pagingVO);
		  model.addAttribute("alarmList",list);
		  model.addAttribute("type", type);  
		return "mypage/business/notifications";
	}
	
	

}
