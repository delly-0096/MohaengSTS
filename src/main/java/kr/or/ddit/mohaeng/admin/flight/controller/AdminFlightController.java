package kr.or.ddit.mohaeng.admin.flight.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.admin.accommodation.dto.AdminAccommodationDTO;
import kr.or.ddit.mohaeng.admin.accommodation.service.IAdminAccommodationService;
import kr.or.ddit.mohaeng.flight.service.IFlightService;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController

@CrossOrigin(origins = "http://localhost:7272")
public class AdminFlightController {

	@Autowired
	private IFlightService flightService;
	
	/**
	 * 숙박 관리 목록 조회
	 */
	@GetMapping("/api/admin/products/flight")
	public ResponseEntity<PaginationInfoVO<AccommodationVO>> getFlightList(
			@RequestParam(defaultValue = "1") int currentPage
			,@RequestParam(defaultValue = "") String searchWord
			,@RequestParam(defaultValue = "all") String searchType
			) {
		log.info("숙박관리 목록 조회 : currentPage:{}, searchWord:{}, searchType:{}" , currentPage, searchWord, searchType);
		PaginationInfoVO<AccommodationVO> pagInfoVO = new PaginationInfoVO<>(10, 5);
		pagInfoVO.setCurrentPage(currentPage);
		pagInfoVO.setSearchWord(searchWord);
		if (!"all".equals(searchType)) {
			pagInfoVO.setSearchType(searchType);
		}
//		adminAccService.getAccommodationList(pagInfoVO);
		return ResponseEntity.ok(pagInfoVO);
	}
	
	/**
	 * 숙박 상세 조회
	 */
//	@GetMapping("/{tripProdNo}")
//	public ResponseEntity<AccommodationVO> getAccommodationDetail(@PathVariable("tripProdNo") int tripProdNo){
//		log.debug("[ADMIN][ACCOMMODATION] detail request tripProdNo={}", tripProdNo);
//		
//		AccommodationVO accommodationDetail =
//				adminAccService.getAccommodationDetail(tripProdNo);
//		
//		if(accommodationDetail == null) {
//			return ResponseEntity.notFound().build();
//		}
//		
//		return ResponseEntity.ok(accommodationDetail);
//	}
	

}
