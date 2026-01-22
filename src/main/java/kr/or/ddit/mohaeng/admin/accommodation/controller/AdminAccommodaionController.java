package kr.or.ddit.mohaeng.admin.accommodation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.admin.accommodation.service.IAdminAccommodationService;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/products/accommodations")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminAccommodaionController {

	@Autowired
	private IAdminAccommodationService adminAccService;
	
	/**
	 * 숙박 관리 목록 조회
	 */
	
	public ResponseEntity<PaginationInfoVO<AccommodationVO>> getAccommodationList(
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
		adminAccService.getAccommodationList(pagInfoVO);
		return ResponseEntity.ok(pagInfoVO);
	}
}
