package kr.or.ddit.mohaeng.admin.accommodation.controller;

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
	@GetMapping
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
	
	/**
	 * 숙박 상세 조회
	 */
	@GetMapping("/{tripProdNo}")
	public ResponseEntity<AccommodationVO> getAccommodationDetail(@PathVariable("tripProdNo") int tripProdNo){
		log.debug("[ADMIN][ACCOMMODATION] detail request tripProdNo={}", tripProdNo);
		
		AccommodationVO accommodationDetail =
				adminAccService.getAccommodationDetail(tripProdNo);
		
		if(accommodationDetail == null) {
			return ResponseEntity.notFound().build();
		}
		
		return ResponseEntity.ok(accommodationDetail);
	}
	
	// 상품 최종 승인
    @PatchMapping("/approve/{tripProdNo}")
    public ResponseEntity<?> approve(@PathVariable int tripProdNo) {
        int result = adminAccService.approveAccommodation(tripProdNo);
        if(result > 0) return ResponseEntity.ok("승인 완료!");
        return ResponseEntity.status(500).body("승인 실패..");
    }

    // 판매 상태 토글 (판매중 <-> 중지)
    @PatchMapping("/toggle-sale")
    public ResponseEntity<?> toggleSale(@RequestBody Map<String, Object> params) {
        // params: { tripProdNo: 123, delYn: 'Y' }
        int result = adminAccService.toggleSaleStatus(params);
        return ResponseEntity.ok(result);
    }
    
    // 2. 숙소 수정
    @PutMapping("/update")
    public ResponseEntity<?> update(@RequestBody AdminAccommodationDTO accDto) {
        log.info("숙소 수정 요청: {}", accDto.getAccNo());
        int result = adminAccService.updateAccommodation(accDto);
        if(result > 0) return ResponseEntity.ok("수정 완료!");
        return ResponseEntity.status(500).body("수정 실패..");
    }

    // 3. 숙소 삭제 (논리 삭제: delYn = 'Y')
    @DeleteMapping("/delete/{tripProdNo}")
    public ResponseEntity<?> delete(@PathVariable int tripProdNo) {
        log.info("숙소 삭제 요청: {}", tripProdNo);
        int result = adminAccService.deleteAccommodation(tripProdNo);
        if(result > 0) return ResponseEntity.ok("삭제 완료!");
        return ResponseEntity.status(500).body("삭제 실패..");
    }
}
