package kr.or.ddit.mohaeng.accommodation.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.accommodation.service.IAccommodationService;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;
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
			AccommodationVO acc,
			@RequestParam(value="areaCode", required=false) String areaCode,
			Model model) {
		
		acc.setPage(1);
	    acc.setPageSize(12);
	    acc.setStartRow(1);
	    acc.setEndRow(12);
		
		AccommodationVO vo = new AccommodationVO();
		vo.setAreaCode(areaCode);
		
		List<AccommodationVO> firstList = accService.selectAccommodationListWithPaging(acc);
		List<AccommodationVO> accList = accService.selectAccommodationList(areaCode);
		int totalCount = accService.selectTotalCount(acc);
	    
	    log.info("조회된 숙소 개수: {}", accList.size());
	    model.addAttribute("accList", firstList);
	    model.addAttribute("initialListSize", firstList.size()); // JS에서 체크용
	    model.addAttribute("totalCount", totalCount);
	    
	    return "product/accommodation";

	}
	
	/**
	 * 숙소 추가 데이터 로드 (인피니티 스크롤용 API)
	 */
	@GetMapping("/product/accommodation/more")
	@ResponseBody // 리턴값을 페이지가 아닌 JSON 데이터로 쏴줌!
	public Map<String, Object> loadMore(AccommodationVO acc) {
	    // 1. 페이징 계산 (AccommodationVO에 page와 pageSize 필드가 있다고 가정)
	    // 만약 VO에 없다면 파라미터로 따로 받아도 돼!
	    int startRow = (acc.getPage() - 1) * acc.getPageSize() + 1;
	    int endRow = acc.getPage() * acc.getPageSize();
	    
	    acc.setStartRow(startRow);
	    acc.setEndRow(endRow);

	    // 2. DB에서 해당 페이지 데이터와 전체 개수 가져오기
	    List<AccommodationVO> accList = accService.selectAccommodationListWithPaging(acc);
	    int totalCount = accService.selectTotalCount(acc);

	    // 3. 응답 데이터 조립 (팀원 스타일!)
	    Map<String, Object> result = new HashMap<>();
	    result.put("accList", accList);
	    result.put("totalCount", totalCount);
	    // 현재까지 불러온 데이터가 전체보다 적으면 true
	    result.put("hasMore", (acc.getPage() * acc.getPageSize()) < totalCount);

	    return result;
	}
	
	// 숙박 상품 상세 페이지
	@GetMapping("/product/accommodation/{accNo}")
	public String accommodationDetail(@PathVariable("accNo") int accNo, Model model) {
		AccommodationVO detail = accService.getAccommodationDetail(accNo);
		
		// 해당 숙소의 객실(RoomType) 리스트 조회
		List<RoomTypeVO> rooms = accService.getRoomList(accNo);
		
		model.addAttribute("acc", detail);
		model.addAttribute("rooms", rooms);
		
		return "product/accommodation-detail";
	}
	
	@GetMapping("/product/accommodation-booking")
	public String accommodationBooking() {
		return "product/accommodation-booking";
	}

	
}

