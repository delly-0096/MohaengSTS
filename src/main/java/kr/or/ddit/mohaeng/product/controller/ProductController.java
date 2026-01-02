package kr.or.ddit.mohaeng.product.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.mohaeng.flight.service.IFlightService;
import kr.or.ddit.mohaeng.vo.AirlineVO;
import kr.or.ddit.mohaeng.vo.AirportVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/product")
public class ProductController {
	
	@Autowired
	private IFlightService flightService;
	
	
	@GetMapping("/manage")
	public String productManage(Model model) {
		// 공항정보 전송
		 List<AirportVO> airportList = flightService.getAirportList();
		
		// 항공사 정보 전송
		List<AirlineVO> airlineList = flightService.getAirlineList();
		
		
		model.addAttribute("airportList", airportList);
		model.addAttribute("airlineList", airlineList);
		
		return "product/manage";
	}
	
	
	
	
}
