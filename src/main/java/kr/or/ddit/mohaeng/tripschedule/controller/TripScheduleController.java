package kr.or.ddit.mohaeng.tripschedule.controller;

import java.net.http.HttpResponse;
import java.util.List;import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.mohaeng.login.controller.LoginController;
import kr.or.ddit.mohaeng.tripschedule.service.ITripScheduleService;
import kr.or.ddit.util.Params;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
@RequestMapping("/schedule")
public class TripScheduleController {
	
	@Autowired
	ITripScheduleService tripScheduleService;
	
	@GetMapping("/search")
	public String search(Model model) {
		Params params = new Params();
//		List<Map<String, Object>> regionList = tripScheduleService.selectRegionList();
		model.addAttribute("popRegionList", tripScheduleService.selectPopRegionList());
//		System.out.println(regionList);
		return "schedule/search";
	}
	
	@ResponseBody
	@GetMapping("/regionList")
	public ResponseEntity<List> searchRegionList(Model model) {
		
//		model.addAttribute("regionList", tripScheduleService.selectRegionList());
//		System.out.println(regionList);
		return new ResponseEntity<List>(tripScheduleService.selectRegionList(), HttpStatus.OK);
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
