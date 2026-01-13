package kr.or.ddit.mohaeng.mypage.schedule;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mypage/schedules")
public class MySchedule {
	
	@GetMapping("")
	public String Schedule() {
		
		return "/mypage/schedules";
	}
	
}
