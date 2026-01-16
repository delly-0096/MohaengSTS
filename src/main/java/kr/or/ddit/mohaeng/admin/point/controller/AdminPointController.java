package kr.or.ddit.mohaeng.admin.point.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.admin.point.service.IAPointService;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.PointDetailsVO;
import kr.or.ddit.mohaeng.vo.PointSearchVO;
import kr.or.ddit.mohaeng.vo.PointSummaryVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/points")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminPointController {

	@Autowired
	private IAPointService pointService;

	/**
	 * [포인트 통계 카드용 데이터] react 상단의 총발급, 총사용, 만료, 현재 잔액 합계
	 */
	@GetMapping("/stats")
	public ResponseEntity<Map<String, Object>> pointStats(){
		//1. 성공/실패 담을 빈박스 만들기
		Map<String, Object> result = new HashMap<>();

		try {
			//2. 데이터 통계 가져오기
			Map<String, Object> stats = pointService.aPointStats();

			//3. 데이터 박스에 포장
			result.put("success", true);
			result.put("data", stats);

			// 성공 도장
			return ResponseEntity.ok(result);

		} catch (Exception e) {
			e.printStackTrace();
			// 실패 포장
			result.put("success", false);
			result.put("message", "통계 조회 중 오류가 발생했습니다.");

			// 실패 도장
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
		}
	}

	/**
	 * 회원들의 포인트 요약정보를 페이지별로 잘라서 보여주는 기능
	 */
	@GetMapping("/members")
	public Map<String, Object> memberPointSummary(
			@RequestParam(required = false) String searchKeyword,
			@RequestParam(defaultValue = "1") int page){
		//1.박스에 담기
		Map<String, Object> result = new HashMap<>();

		try {
			//2. 검색 조건 (검색어를 주문서에 넣기)
			PointSummaryVO summaryVO = new PointSummaryVO();
			summaryVO.setSearchKeyword(searchKeyword);

			//3. 전체 개수 (페이징 자료)
			int totalCount = pointService.memberPointSummaryCount(summaryVO);

			//4. 계산기 가동(PaginationInfoVO)
			PaginationInfoVO<PointSummaryVO> pagingVO = new PaginationInfoVO<>();
			pagingVO.setTotalRecord(totalCount); //전체보고 페이지 수 계산
			pagingVO.setCurrentPage(page); //현재 1페이지 계산

			//5. 계산 결과를 주문서에 넣어 합체
			summaryVO.setPaginationVO(pagingVO);

			//6. 조회
			List<PointSummaryVO> summaryList = pointService.memberPointSummary(summaryVO);

			//7. 계산기 속 dataList에 보관
			pagingVO.setDataList(summaryList);

		    result.put("success", true);
		    result.put("paginationVO", pagingVO);

		} catch (Exception e) {
			e.printStackTrace();

			result.put("success", false);
			result.put("message", "회원 현황 조회 중 오류가 발생했습니다.");
		}

		return result;
	}

	/**
	 * 포인트 내역을 필터링해서 보냄
	 */
	@GetMapping("/history")
	public ResponseEntity<Map<String, Object>> pointHistory(
			@RequestParam(required = false) String searchKeyword,
			@RequestParam(required = false) String pointType,
			@RequestParam(required = false) String pointTarget,
			@RequestParam(required = false) String startDate,
			@RequestParam(required = false) String endDate,
			@RequestParam(defaultValue = "1") int page){

		Map<String, Object> result = new HashMap<>();

		try {
			PointSearchVO searchVO = new PointSearchVO();
			searchVO.setSearchKeyword(searchKeyword);
			//리액트에서 '전체'를 뜻하는 "all"을 보냈다면 null로 바꿔서 DB가 검색 안 하게 배려!
			searchVO.setPointType("all".equals(pointType) ? null : pointType);
			searchVO.setPointTarget("all".equals(pointTarget) ? null : pointTarget);

			searchVO.setStartDate(startDate);
			searchVO.setEndDate(endDate);

			//페이지 계산
			int totalCount = pointService.allPointHistoryCount(searchVO);

			PaginationInfoVO<PointDetailsVO> pagingVO = new PaginationInfoVO<>();
			pagingVO.setTotalRecord(totalCount); // 여기서 totalPage 등이 자동 계산
			pagingVO.setCurrentPage(page); // 여기서 startRow, endRow가 자동 계산

			//데이터 조회
			searchVO.setPaginationVO(pagingVO);
			List<PointDetailsVO> historyList = pointService.allPointHistory(searchVO);

			//최종 포장. pagingVO안에 리스트 넣음
			pagingVO.setDataList(historyList);

			//성공 배송.200번 보냄
			result.put("success", true);
			result.put("paginationVO", pagingVO); //여기 다 들어 있음

			return ResponseEntity.ok(result);

		}catch (Exception e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("message", "포인트 내역 조회 중 서버 오류가 발생했습니다.");

			//실패 도장
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
		}
	}

}
