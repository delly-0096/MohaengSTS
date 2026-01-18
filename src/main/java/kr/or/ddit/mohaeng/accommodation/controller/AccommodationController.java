package kr.or.ddit.mohaeng.accommodation.controller;

import java.beans.Customizer;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.accommodation.service.IAccommodationService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.CompanyVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/")
public class AccommodationController {

	@Autowired
	private IAccommodationService accService;
	
	/**
	 * 전체 목록 가져오기
	 * @param acc
	 * @param areaCode
	 * @param model
	 * @return
	 */
	@GetMapping("/product/accommodation")
	public String accommodationPage(
			AccommodationVO acc,
			@RequestParam(value="areaCode", required=false) String areaCode,
			@RequestParam(value="keyword", required=false) String keyword,
			Model model) {
		
		// 날짜가 없으면 기본값(오늘~내일) 세팅 (권장)
	    if(acc.getStartDate() == null) {
	        acc.setStartDate(LocalDate.now().toString());
	        acc.setEndDate(LocalDate.now().plusDays(1).toString());
	    }
	    
	    acc.setAreaCode(areaCode);
	    acc.setKeyword(keyword);
		
		acc.setPage(1);
	    acc.setPageSize(12);
	    acc.setStartRow(1);
	    acc.setEndRow(12);
		
		AccommodationVO vo = new AccommodationVO();
		vo.setAreaCode(areaCode);
		
		List<AccommodationVO> firstList = accService.selectAccommodationListWithPaging(acc);
		List<AccommodationVO> accList = accService.selectAccommodationList(areaCode);
		int totalCount = accService.selectTotalCount(acc);
	    
		log.info("필터링된 진짜 숙소 개수: {}", totalCount);
	    log.info("넘어온 키워드: {}, 지역코드: {}", keyword, areaCode);
	    model.addAttribute("accList", firstList);
	    model.addAttribute("initialListSize", firstList.size());
	    model.addAttribute("totalCount", totalCount);
	    model.addAttribute("keyword", keyword);
	    model.addAttribute("searchParam", acc);
	    
	    return "product/accommodation";

	}
	
	/**
	 * 목적지 자동 완성용 API
	 */
	@GetMapping("/product/accommodation/api/search-location")
	@ResponseBody
	public List<Map<String, Object>> searchLocation(@RequestParam("keyword") String keyword) {
		if (keyword == null || keyword.trim().isEmpty()) {
	        return new ArrayList<>();
	    }
		// 사용자가 입력한 키워드로 지역명 검색
	    // 예: [{"areaCode": "39", "name": "제주도"}, {"areaCode": "1", "name": "서울"}]
	    return accService.searchLocation(keyword);
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
	
	/**
	 * 숙박 상품 상세 페이지
	 */
	@GetMapping("/product/accommodation/{accNo}")
	public String accommodationDetail(
			@PathVariable("accNo") int accNo,
			@AuthenticationPrincipal  CustomUserDetails user,
			Model model) {
				
		// 숙소 상세 정보
		AccommodationVO detail = accService.getAccommodationDetail(accNo);
		// 숙소 객실 타입 정보
		List<RoomTypeVO> rooms = accService.getRoomList(accNo);
		// 숙소 보유시설 정보
		AccFacilityVO facility = accService.getAccFacility(accNo);
		
		int compNo = detail.getCompNo();
		// 판매자 정보
        CompanyVO seller = accService.getSellerStatsByAccNo(detail.getCompNo());
		
		model.addAttribute("acc", detail);
		model.addAttribute("rooms", rooms);
	    model.addAttribute("facility", facility);
        model.addAttribute("seller", seller);
		
		return "product/accommodation-detail";
	}
	
	/**
	 * 숙소 예약 페이지
	 */
	@GetMapping("/product/accommodation/{accNo}/booking")
	public String accommodationBooking(
			@PathVariable("accNo") int accNo,
			@RequestParam("roomNo") int roomTypeNo,
	        @RequestParam Map<String, String> bookingData, // 날짜, 인원 등을 한 번에 맵으로 받기
	        Model model) {
	    
		AccommodationVO acc = accService.getAccommodationDetail(accNo);
        RoomTypeVO room = accService.getRoomTypeDetail(roomTypeNo);
		
	    // 넘어온 예약 데이터를 모델에 담아서 결제 화면에 뿌려주기
        model.addAttribute("acc", acc);
        model.addAttribute("room", room);
	    model.addAttribute("bookingData", bookingData);
	    
	    return "product/accommodation-booking";
	}

	
}

