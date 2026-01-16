package kr.or.ddit.mohaeng.accommodation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import ch.qos.logback.core.model.Model;
import kr.or.ddit.mohaeng.accommodation.service.IAccommodationService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/")
public class AccommodationController {

	@Autowired
	private IAccommodationService accService;
	
	@GetMapping("/product/accommodation")
	public String accommodationPage() {
		return "product/accommodation";
	}
	
	@GetMapping("/product/accommodationBooking")
	public String accommodationBooking() {
		return "product/accommodation-booking";
	}

	@GetMapping("/product/accommodationDetail")
	public String accommodationDetail() {
		return "product/accommodation-detail";
	}
	
	@GetMapping("/list")
    public String getList(Model model) {
        // 1. 여기서 API 동기화 메서드를 실행하거나, 
        // 2. 이미 DB에 저장된 데이터를 Service를 통해 가져와서
        // List<AccommodationVO> list = accService.selectList();
        
        // model.addAttribute("accList", list);
        return "accommodation/list"; // 네가 만든 JSP 경로
    }
}

