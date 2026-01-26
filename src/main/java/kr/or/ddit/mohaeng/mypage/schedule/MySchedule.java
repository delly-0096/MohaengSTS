package kr.or.ddit.mohaeng.mypage.schedule;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.tripschedule.service.ITripScheduleService;
import kr.or.ddit.mohaeng.vo.TripScheduleVO;

@Controller
@RequestMapping("/mypage/schedules")
public class MySchedule {
	
	@Autowired
	ITripScheduleService tripScheduleService;
	
	@GetMapping("")
	public String Schedule(@AuthenticationPrincipal CustomUserDetails customUser, Model model) {
		int memNo = customUser.getMember().getMemNo();
		
		List<TripScheduleVO> scheduleList = tripScheduleService.selectTripScheduleList(memNo);
		for(TripScheduleVO schedule : scheduleList) {
			System.out.println("scheduleList:  " + schedule.getModDt());
		}
		model.addAttribute("scheduleList", scheduleList);
		
		return "mypage/schedules";
	}
	
}
