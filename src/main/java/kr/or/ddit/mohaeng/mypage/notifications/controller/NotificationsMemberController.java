package kr.or.ddit.mohaeng.mypage.notifications.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.mohaeng.mypage.notifications.service.INotificationsAlarmService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.AlarmVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/mypage")
public class NotificationsMemberController {

	 @Autowired
	    private INotificationsAlarmService notificationsAlarmService;

	    @GetMapping("/notifications")
	    public String page(
	            @RequestParam(name="page", required=false, defaultValue="1") int currentPage,
	            @RequestParam(name="type", required=false, defaultValue="ALL") String type,
	            @AuthenticationPrincipal CustomUserDetails user,
	            Model model
	    ){
	        PaginationInfoVO<AlarmVO> pagingVO = new PaginationInfoVO<>();

	        pagingVO.setMemNo(user.getMemNo());
	        pagingVO.setCurrentPage(currentPage);
	        pagingVO.setSearchType(type);

	        int totalRecord = notificationsAlarmService.selectAlarmCount(pagingVO);
	        pagingVO.setTotalRecord(totalRecord); // ✅ totalRecord 세팅!

	        List<AlarmVO> list = notificationsAlarmService.selectAlarmList(pagingVO);

	        model.addAttribute("pagingVO", pagingVO);
	        model.addAttribute("alarmList", list); // ✅ JSP에서 alarmList로 받기
	        model.addAttribute("type", type);
	        return "mypage/notifications"; // ✅ /WEB-INF/views/mypage/notifications.jsp
	    }
	}

