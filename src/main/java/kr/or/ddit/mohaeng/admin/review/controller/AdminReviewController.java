package kr.or.ddit.mohaeng.admin.review.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.admin.review.service.IAReviewService;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/reviews")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminReviewController {

	@Autowired
	private IAReviewService reviewService;

	/**
	 * 리뷰 목록 조회 (검색, 필터, 페이징)
	 */
	@GetMapping
	public ResponseEntity<?> getReviews(
			 @RequestParam(required = false) String searchKeyword
			,@RequestParam(required = false) Integer ratingFilter
			,@RequestParam(required = false, defaultValue = "all") String statusFilter
			,@RequestParam(required = false) String startDate
			,@RequestParam(required = false) String endDate
			,@RequestParam(defaultValue = "1") int currentPage){
		log.info("=== 관리자 리뷰 목록 조회 ===");
        log.info("검색어: {}, 평점: {}, 상태: {}, 기간: {} ~ {}, 페이지: {}",
                searchKeyword, ratingFilter, statusFilter, startDate, endDate, currentPage);

        try {
        	// PaginationInfoVO 생성 (페이지당 10개, 블록 5개)
        	PaginationInfoVO<ProdReviewVO> pagInfoVO = new PaginationInfoVO<>(10,5);

        	// 검색 조건 설정
        	ProdReviewVO searchVO = new ProdReviewVO();
        	searchVO.setSearchKeyword(searchKeyword);
        	searchVO.setRatingFilter(ratingFilter);
        	searchVO.setStatusFilter(statusFilter);
        	searchVO.setStartDate(startDate);
        	searchVO.setEndDate(endDate);

        	// 전체 개수 조회
        	int totalRecord = reviewService.getReviewCount(searchVO);
        	pagInfoVO.setTotalRecord(totalRecord);
        	pagInfoVO.setCurrentPage(currentPage);

        	// startRow, endRow 설정
        	searchVO.setStartRow(pagInfoVO.getStartRow());
        	searchVO.setEndRow(pagInfoVO.getEndRow());

        	// 리뷰 목록 조회
        	List<ProdReviewVO> reviews = reviewService.getReviewList(searchVO);
        	pagInfoVO.setDataList(reviews);

        	log.info("리뷰 목록 조회 완료:{}건/전체{}건", reviews.size(), totalRecord);
        	return ResponseEntity.ok(pagInfoVO);

		} catch (Exception e) {
			 log.error("리뷰 목록 조회 실패", e);
			 return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", "리뷰 목록 조회에 실패했습니다."));
		}
	}
	/**
	 * 리뷰 통계 조회
	 */
	@GetMapping("/statistics")
	public ResponseEntity<Map<String, Object>> getStatistics(
			 @RequestParam(required = false) String startDate
			,@RequestParam(required = false) String endDate){

		log.info("=== 리뷰 통계 조회 ===");
		log.info("기간:{}~{}", startDate, endDate);

		try {
			//새로운 검색용 가방 만듬
			ProdReviewVO searchVO = new ProdReviewVO();
			searchVO.setStartDate(startDate);
			searchVO.setEndDate(endDate);

			//항목별 점수판 만들기 (ex)[전체갯수:100개], [평균별점:4.5점]...)
			Map<String, Object> statistics = reviewService.getReviewStatistics(searchVO);

			log.info("통계 조회 완료:{}",statistics);
			return ResponseEntity.ok(statistics);

		} catch (Exception e) {
			log.error("통계 조회 실패", e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error","통계 조회에 실패했습니다"));
		}
	}

	/**
	 * 평점별 리뷰 개수 조회
	 */
	@GetMapping("/rating-counts")
	public ResponseEntity<Map<String, Object>> getRatingCounts(
			 @RequestParam(required = false) String startDate
			 ,@RequestParam(required = false) String endDate){

		log.info("=== 기간별 평점 개수 조회: {} ~ {} ===", startDate, endDate);

		try {
			//날짜를 담을 가방 만듬
			ProdReviewVO searchVO = new ProdReviewVO();
			searchVO.setStartDate(startDate);
			searchVO.setEndDate(endDate);

			//날짜에 적힌 기간에 해당하는 내용 담아오기
			Map<String, Object> ratingCounts = reviewService.getRatingCounts(searchVO);

			log.info("평점별 개수 조회 완료: {}", ratingCounts);
			return ResponseEntity.ok(ratingCounts);

		} catch (Exception e) {
			log.error("평점별 개수 조회 실패", e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", "평점별 개수 조회에 실패했습니다."));
		}
	}

	/**
	 * 리뷰 상세 조회
	 */
	@GetMapping("/{prodRvNo}")
	public ResponseEntity<?> getReviewDetail(@PathVariable int prodRvNo){

		log.info("=== 리뷰 상세 조회 ===");
		log.info("리뷰 번호:{}",prodRvNo);

		try {
			ProdReviewVO review = reviewService.getReviewDetail(prodRvNo);

			if (review == null) {
				log.warn("리뷰를 찾을 수 없음:{}",prodRvNo);
				return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error","리뷰를 찾을 수 없습니다"));
			}
			log.info("리뷰 상세 조회 완료:{}", review.getProdRvNo());
			return ResponseEntity.ok(review);
		} catch (Exception e) {
			log.error("리뷰 상세 조회 실패", e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error","리뷰 상세 조회에 실패했습니다"));
		}
	}

	/**
	 * 리뷰 상태 변경(게시-숨김)
	 */
	@PatchMapping("/{prodRvNo}/status")
	public ResponseEntity<Map<String, Object>> updateReviewStatus(
			@PathVariable int prodRvNo
		   ,@RequestBody Map<String, String> request){ //변경내용이 들어있는 쪽지

		String reviewStatus = request.get("reviewStatus");

		log.info("=== 리뷰 상태 변경 ===");
		log.info("리뷰 번호:{}, 변경할 상태:{}", prodRvNo, reviewStatus);

		//유효성 검사
		if (reviewStatus == null || (!reviewStatus.equals("ACTIVE") && !reviewStatus.equals("HIDDEN"))) {
			log.warn("잘못된 상태 값:{}", reviewStatus);
			return ResponseEntity.badRequest().body(Map.of("error","유효하지 않은 상태 값입니다.(ACTIVE 또는 HIDDEN만 가능)"));
		}
		try {
			int result = reviewService.updateReviewStatus(prodRvNo, reviewStatus); //prodRvNo번호를 reviewStatus상태로 변경

			if (result > 0) {
				log.info("리뷰 상태 변경 완료:{}->{}", prodRvNo, reviewStatus);
				return ResponseEntity.ok(Map.of("success",true,
						"message",reviewStatus.equals("ACTIVE")?"리뷰가 게시되었습니다":"리뷰가 숨김 처리되었습니다"));
			}else {
				log.warn("리뷰 상태 변경 실패:{}",prodRvNo);
				return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error","리뷰를 찾을 수 없습니다"));
			}

		} catch (Exception e) {
			log.error("리뷰 상태 변경 실패", e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error","리뷰 상태 변경에 실패했습니다"));
		}
	}


	/**
	 * 리뷰 삭제(실제delete)
	 */
	@DeleteMapping("/{prodRvNo}")
	public ResponseEntity<Map<String, Object>> deleteReview(@PathVariable int prodRvNo){
		log.info("=== 리뷰 삭제 ===");
		log.info("리뷰 번호:{}",prodRvNo);

		try {
			int result = reviewService.deleteReview(prodRvNo);

			if (result > 0) {
				log.info("리뷰 삭제 완료",prodRvNo);
				return ResponseEntity.ok(Map.of("success",true,"message","리뷰가 삭제되었습니다"));
			} else {
				log.info("리뷰 삭제 실패:{}",prodRvNo);
				return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error","리뷰를 찾을 수 없습니다"));
			}
		} catch (Exception e) {
			log.error("리뷰 삭제 실패",e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error","리뷰 삭제에 실패했습니다"));
		}
	}

	/**
	 * 신고된 리뷰 목록 조회
	 */
	@GetMapping("/reported")
	public ResponseEntity<?> getReportedReviews(
			@RequestParam(defaultValue = "1") int currentPage){

		log.info("=== 신고된 리뷰 목록 조회 ===");
		log.info("페이지:{}",currentPage);

		try {
			// PaginationInfoVO 생성 (페이지당 10개, 블록 5개)
			PaginationInfoVO<ProdReviewVO> pagInfoVO = new PaginationInfoVO<>(10,5);

			ProdReviewVO searchVO = new ProdReviewVO();
			searchVO.setStatusFilter("reported");

			//전체 개수 조회
			int totalRecord = reviewService.getReviewCount(searchVO);
			pagInfoVO.setTotalRecord(totalRecord);
			pagInfoVO.setCurrentPage(currentPage);

			// startRow, endRow 설정
			searchVO.setStartRow(pagInfoVO.getStartRow());
			searchVO.setEndRow(pagInfoVO.getEndRow());

			// 리뷰 목록 조회
        	List<ProdReviewVO> reviews = reviewService.getReviewList(searchVO);
        	pagInfoVO.setDataList(reviews);

        	log.info("신고된 리뷰 조회 완료:{}건", reviews.size());
        	return ResponseEntity.ok(pagInfoVO);

		} catch (Exception e) {
			log.error("신고된 리뷰 목록 조회 실패",e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error","신고된 리뷰 목록 조회에 실패했습니다"));
		}
	}
}
