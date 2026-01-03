package kr.or.ddit.mohaeng.flight.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.flight.service.IFlightService;
import kr.or.ddit.mohaeng.vo.AirportVO;
import kr.or.ddit.mohaeng.vo.FlightScheduleVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/product/flight")
public class FlightController {

	@Autowired
	private IFlightService service;
	
	@GetMapping("")
	public String flightPage(Model model) {
		
//		List<FlightScheduleVO> flightList = service.getFlightList();
//		for(FlightScheduleVO flight : flightList) {
//			System.out.println(flight.getEconomyCharge());
//			log.info("금액");
//		}
//		model.addAttribute("flightList", flightList);
		return "product/flight";
	}
	
	
	@ResponseBody
	@GetMapping("/search")
	public List<AirportVO> searchAirport(@RequestParam(required = false) String keyword){
//		log.info("searchAirport 실행", keyword);
		return service.selectAirportList(keyword);
	}
	
	@ResponseBody
	@PostMapping("/searchFlight")
	public List<FlightScheduleVO>searchFlight(@RequestBody FlightScheduleVO flightSchedule){
		System.out.println("flight service다 : " + flightSchedule);
		
		return service.getFlightList(flightSchedule);
	}
	
	
	// POST로 보내기
	@GetMapping("/booking")
	public String flightBooking() {
		return "product/flightBooking";
	}
}
