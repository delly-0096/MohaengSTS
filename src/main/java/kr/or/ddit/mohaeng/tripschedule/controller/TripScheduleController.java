package kr.or.ddit.mohaeng.tripschedule.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
@RequestMapping("/schedule")
public class TripScheduleController {
	
	@GetMapping("/search")
	public String search() {
		return "schedule/search";
	}
	
	@GetMapping("/planner")
	public String planner() {
		return "schedule/planner";
	}
	
//	@GetMapping("/search")
//	public String getMethodName() {
//		return "schedule/search";
//	}
	
	
}
