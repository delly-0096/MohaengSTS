package kr.or.ddit.mohaeng.accommodation.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.mohaeng.accommodation.service.IAccommodationService;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/")
public class AccommodationController {

	@Autowired
	private IAccommodationService accService;
	
	// 전체 목록 가져오기
	@GetMapping("/product/accommodation")
	public String accommodationPage(
			@RequestParam(value="areaCode", required=false) String areaCode,
			@RequestParam(value="sigunguCode", required=false) String sigunguCode,
			Model model) {
		
		AccommodationVO vo = new AccommodationVO();
		vo.setAreaCode(areaCode);
		vo.setSigunguCode(sigunguCode);
		
		List<AccommodationVO> accList = accService.selectAccommodationList();
	    
	    log.info("조회된 숙소 개수: {}", accList.size());
	    model.addAttribute("accList", accList);
	    
	    return "product/accommodation";

	}
	
	@GetMapping("/product/accommodation-booking")
	public String accommodationBooking() {
		return "product/accommodation-booking";
	}

	@GetMapping("/product/accommodation-detail")
	public String accommodationDetail() {
		return "product/accommodation-detail";
	}
	
}

