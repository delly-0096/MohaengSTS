package kr.or.ddit.mohaeng.admin.report.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.admin.report.service.IAReportService;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.ReportVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/report")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminReportController {

	@Autowired
	private IAReportService reportService;

	/**
	 * 화면 초기 로드 시 필요한 공통 코드 및 설정 데이터 조회
	 * GET /api/admin/report/setup
	 */
	@GetMapping("/setup")
	public ResponseEntity<Map<String, Object>> getSetupData(){
		log.info("신고 관리 설정 데이터 조회 (공통 코드 등)");
		Map<String, Object> setupData = new HashMap<>();

		// 처리 상태 코드 (WAIT, DONE)
		setupData.put("procStatus", reportService.getCodeByGroup("REPORT_PROC_STATUS"));

		// 신고 출처 코드 (TRIP_PROD, TRIP_RECORD, BOARD, COMMENT, CHAT)
		setupData.put("targetType", reportService.getCodeByGroup("REPORT_TARGET_TYPE"));

		// 제재 수위 코드 (WARNING, TEMP_BAN_7, TEMP_BAN_30, BLACKLIST, REJECTED)
		setupData.put("procResult", reportService.getCodeByGroup("REPORT_PROC_RESULT"));

		// 신고 사유 코드 (SPAM, ABUSE, FALSE, COPYRIGHT, PRIVACY, ADVERTISE, ETC)
		setupData.put("ctgry", reportService.getCodeByGroup("REPORT_REASON"));

		return ResponseEntity.ok(setupData);
	}

	/**
	 * 신고 목록 조회 (페이징, 필터링)
	 * GET /api/admin/report?page=1&searchWord=&procStatus=&targetType=&procResult=
	 */
	@GetMapping
	public ResponseEntity<PaginationInfoVO<ReportVO>> getReportList(
			@RequestParam(defaultValue = "1") int currentPage,
			@RequestParam(defaultValue = "") String searchWord,
			@RequestParam(defaultValue = "all") String procStatus,
			@RequestParam(defaultValue = "all") String targetType,
			@RequestParam(defaultValue = "all") String procResult) {

		log.info("신고 목록 조회 : currentPage:{}, searchWord:{}, procStatus:{}, targetType:{}, procResult:{}",currentPage, searchWord, procStatus, targetType, procResult);

		PaginationInfoVO<ReportVO> pagInfoVO = new PaginationInfoVO<>(10, 5);
		pagInfoVO.setCurrentPage(currentPage);
		pagInfoVO.setSearchWord(searchWord);

		// 필터 설정
		Map<String, String> filters = new HashMap<>();
		if (!"all".equals(procStatus)) {
			filters.put("procStatus", procStatus);
		}
		if (!"all".equals(targetType)) {
			filters.put("targetType", targetType);
		}
		if (!"all".equals(procResult)) {
			filters.put("procResult", procResult);
		}
		pagInfoVO.setFilters(filters);

		reportService.getReportList(pagInfoVO);

		return ResponseEntity.ok(pagInfoVO);
	}

	/**
	 * 신고 상세 조회
	 * GET /api/admin/report/1
	 */
	@GetMapping("/{rptNo}")
	public ResponseEntity<ReportVO> getReportDetail(@PathVariable Long rptNo){
		log.info("신고 상세 조회 - rptNo: {}", rptNo);

		ReportVO reportVO = reportService.getReportDetail(rptNo);

		if (reportVO == null) {
			return ResponseEntity.notFound().build();
		}
		return ResponseEntity.ok(reportVO);
	}

	/**
	 * 신고 처리 (제재 적용)
     * PUT /api/admin/report/{rptNo}/process
     *
	 * procResult 값:
	 * - WARNING: 경고 (콘텐츠 숨김)
	 * - BAN_7: 7일 이용정지 (콘텐츠 숨김 + 계정 7일 차단)
	 * - BAN_30: 30일 이용정지 (콘텐츠 숨김 + 계정 30일 차단)
	 * - BLACKLIST: 영구 정지 (콘텐츠 숨김 + 계정 영구 차단)
	 */
	@PutMapping("/{rptNo}/process")
	public ResponseEntity<Map<String, Object>> processReport(
			@PathVariable Long rptNo, @RequestBody ReportVO reportVO){

		log.info("신고 처리 요청 - rptNo: {}, procResult: {}", rptNo, reportVO.getProcResult());

		Map<String, Object> response = new HashMap<>();

		try {
			// 필수 항목 검증
			if (reportVO.getProcResult()==null ||reportVO.getProcResult().trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "제재 유형은 필수 선택 항목입니다.");
				return ResponseEntity.badRequest().body(response);
			}
			// 정해진 벌칙이 맞는지 확인 : procResult 값 검증 (CODE 테이블 기준)
			String procResult =  reportVO.getProcResult();
			if (!procResult.equals("WARNING")&& !procResult.equals("BAN_7")&& !procResult.equals("BAN_30") && !procResult.equals("BLACKLIST")) {
				response.put("success", false);
				response.put("message","유효하지 않은 제재 유형입니다.");
				return ResponseEntity.badRequest().body(response);
			}

			if (reportVO.getAdminMemo() == null || reportVO.getAdminMemo().trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "처리 사유는 필수 입력 항목입니다.");
				return ResponseEntity.badRequest().body(response);
			}

			reportVO.setRptNo(rptNo);
			reportVO.setProcStatus("DONE");

			int result = reportService.processReport(reportVO);
			if (result>0) {
				response.put("success", true);
				response.put("message", "신고가 처리되었습니다.");
				return ResponseEntity.ok(response);
			} else {
				response.put("success", false);
				response.put("message", "신고 처리에 실패했습니다.");
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
			}
		} catch (Exception e) {
			log.error("신고 처리 중 오류 발생", e);
			response.put("success", false);
			response.put("message", "신고 처리 중 오류가 발생했습니다:"+e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	/**
	 * 신고 기각
     * POST /api/admin/report/reject
     * { "rptNo": 1,
     *   "rejRsn": "신고 사유가 타당하지 않습니다." }
	 */
	@PutMapping("/{rptNo}/reject")
	public ResponseEntity<Map<String, Object>> rejectReport(
			@PathVariable Long rptNo, @RequestBody ReportVO reportVO){
		log.info("신고 기각 요청 - rptNo:{}", rptNo);

		Map<String, Object> response =  new HashMap<>();

		try {
			if (reportVO.getRejRsn() == null || reportVO.getRejRsn().trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "기각 사유는 필수 입력 항목입니다.");
				return ResponseEntity.badRequest().body(response);
			}

			reportVO.setRptNo(rptNo);
			reportVO.setProcStatus("DONE");
			reportVO.setProcResult("REJECTED");

			int result = reportService.rejectReport(reportVO);

			if (result > 0) {
				response.put("success", true);
				response.put("message", "신고가 기각되었습니다.");
				return ResponseEntity.ok(response);
			} else {
				response.put("success", false);
				response.put("message", "신고 기각에 실패했습니다.");
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
			}
		} catch (Exception e) {
			log.error("신고 기각 중 오류 발생", e);
			response.put("success", false);
			response.put("message", "신고 기각 중 오류가 발생했습니다:"+e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

    /**
     * 블랙리스트 해제
     * DELETE /api/admin/report/blacklist/{targetMemNo}
     *
     * - 신고 목록에서 제재 수위 "영구 정지"로 필터링된 항목의 해제 버튼 클릭 시
     * - MEM_BLACKLIST 테이블에서 해당 회원의 RELEASE_YN = 'Y'로 업데이트
     */
	@PutMapping("/blacklist/{blacklistNo}")
	public ResponseEntity<Map<String, Object>> releaseBlackList(@PathVariable int blacklistNo){
		log.info("블랙리스트 해제 요청 - blacklistNo: {}", blacklistNo);

		Map<String, Object> response = new HashMap<>();

		try {
			int result = reportService.releaseBlackList(blacklistNo);

			if (result > 0) {
				response.put("success", true);
				response.put("message", "신고 처리(번호:" + blacklistNo + ")가 성공적으로 해제되었습니다.");
				return ResponseEntity.ok(response);
			} else {
				response.put("success", false);
				response.put("message", "블랙리스트 해제에 실패했습니다. (회원 정보 확인 필요)");
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
			}
		} catch (Exception e) {
			log.error("블랙리스트 해제 중 오류 발생", e);
			response.put("success", false);
			response.put("message", "블랙리스트 해제 중 오류가 발생했습니다: "+e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
}
