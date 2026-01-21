package kr.or.ddit.mohaeng.admin.memUser.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.admin.memUser.service.IGeneralService;
import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/members/general")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminGeneralController {

	@Autowired
	private IGeneralService generalService;

	@Autowired
	private IFileService fileService;

	/**
     * [추가] 화면 초기 로드 시 필요한 공통 코드 및 설정 데이터 조회
     * GET /api/admin/members/general/setup
     */
    @GetMapping("/setup")
    public ResponseEntity<Map<String, Object>> getSetupData() {
        log.info("회원 관리 설정 데이터 조회 (공통 코드 등)");
        Map<String, Object> setupData = new HashMap<>();

        // MEMBER_STATUS 그룹의 코드 목록을 가져옴 (서비스에 해당 메서드 구현 필요)
        // 예: [{cd: 'ACTIVE', cdName: '정상'}, {cd: 'DORMANT', cdName: '휴면'} ...]
        setupData.put("statusCodes", generalService.getCodeListByGroup("MEMBER_STATUS"));

        return ResponseEntity.ok(setupData);
    }

    /**
     * 일반회원 목록 조회 (페이징, 검색, 필터)
     * GET /api/admin/members/general?page=1&searchTerm=&statusFilter=all
     */
	@GetMapping
	public ResponseEntity<PaginationInfoVO<MemberVO>> getMemList(
			@RequestParam(defaultValue = "1") int currentPage
			,@RequestParam(defaultValue = "") String searchWord
			,@RequestParam(defaultValue = "all") String searchType){
		log.info("회원 목록 조회 : currentPage:{}, searchWord:{}, searchType:{}",currentPage, searchWord, searchType);
		PaginationInfoVO<MemberVO> pagInfoVO = new PaginationInfoVO<>(10,5);
		pagInfoVO.setCurrentPage(currentPage);
		pagInfoVO.setSearchWord(searchWord);
		if (!"all".equals(searchType)) {
			pagInfoVO.setSearchType(searchType);
		}
		generalService.getMemList(pagInfoVO);
		return ResponseEntity.ok(pagInfoVO);
	}

    /**
     * 일반회원 상세 조회
     * GET /api/admin/members/general/{memNo}
     */
	@GetMapping("/{memNo}")
	public ResponseEntity<MemberVO> getMemDetail(@PathVariable int memNo){
		log.info("회원 상세 조회 - memNo: {}", memNo);

		MemberVO member = generalService.getMemDetail(memNo);

		if (member == null) {
			return ResponseEntity.notFound().build();
		}
		return ResponseEntity.ok(member); //성공시 상태와 회원정보를 보냄
	}

    /**
     * 일반회원 등록
     * POST /api/admin/members/general
     */
	@PostMapping
	public ResponseEntity<Map<String, Object>> registerMember(@RequestBody MemberVO member){
		log.info("회원 등록 요청 - userId: {}, userName: {}",member.getMemId(), member.getMemName());

		Map<String, Object> response = new HashMap<>();

		try {
			// 필수 항목 검증
			// (A) 아이디 검사: 비어있거나 공백만 있으면 탈락!
			if (member.getMemId() == null || member.getMemId().trim().isEmpty()) {
				response.put("success", false);
				response.put("message", "아이디는 필수 입력 항목입니다.");
				return ResponseEntity.badRequest().body(response);
			}

			// [추가] 공통 코드 고려: 회원 상태 기본값 설정 (만약 클라이언트에서 보내온 상태값이 없다면 'ACTIVE'를 기본값으로 세팅)
			if (member.getMemStatus() == null || member.getMemStatus().isEmpty()) {
				member.setMemStatus("ACTIVE");
			}

			// (B) 비밀번호 검사: 대소문자 영문, 숫자, 특수문자 포함 8자 이상이어야 통과!
			String passwordPattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$";
			if (member.getMemPassword() == null || !member.getMemPassword().matches(passwordPattern)) {
				response.put("success", false);
				response.put("message","비밀번호는 대소문자 영문, 숫자, 특수문자 포함 8자 이상이어야 합니다.");
				return ResponseEntity.badRequest().body(response);
			}
			// (C) 닉네임 검사: VO 내부의 MemUser 객체 안에 있는 닉네임까지 꼼꼼히 체크!
			if (member.getMemUser() == null || member.getMemUser().getNickname() == null || member.getMemUser().getNickname().trim().isEmpty()){
				response.put("success", false);
				response.put("message","닉네임은 필수 항목입니다.");
				return ResponseEntity.badRequest().body(response);
			}
			// 회원 등록 (MEMBER, MEM_USER, MEMBER_AUTH, ALARM_CONFIG, MEMBER_TERMS_AGREE, MARKETING_CONSENT)
			// : 총 6개 테이블(권한, 알람, 약관 등)에 데이터가 한 번에 들어감 (트랜잭션 처리 대상)
			int result = generalService.registerMember(member);

			if (result>0) {
				response.put("success", true);
				response.put("message", "회원이 등록되었습니다.");
				response.put("memNo", member.getMemNo());
				return ResponseEntity.ok(response);
			} else {
                response.put("success", false);
                response.put("message", "회원 등록에 실패했습니다.");
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
			}

		} catch (Exception e) {
			log.error("회원 등록 중 오류 발생", e);
			response.put("success",false );
			response.put("message", "회원 등록 중 오류가 발생했습니다: " + e.getMessage() );
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	/**
     * 일반회원 정보 수정
     * PUT /api/admin/members/general/{memNo}
     */
	@PutMapping("/{memNo}")
	public ResponseEntity<Map<String, Object>> updateMember(
			@PathVariable int memNo,
			@RequestBody MemberVO member){
		log.info("회원 정보 수정 - memNo: {}, memId: {}", memNo, member.getMemId());

		Map<String, Object> response = new HashMap<>();

		try {
			member.setMemNo(memNo);
			int result = generalService.updateMember(member);

			if (result>0) {
				response.put("success", true);
				response.put("message", "회원정보가 수정되었습니다.");
				return ResponseEntity.ok(response);
			} else {
				response.put("success", false);
                response.put("message", "회원 정보 수정에 실패했습니다.");
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
			}
		} catch (Exception e) {
			log.error("회원 정보 수정 중 오류 발생", e);
			response.put("success",false );
			response.put("message", "회원 정보 수정 중 오류가 발생했습니다: " + e.getMessage() );
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

    /**
     * 일반회원 비밀번호 변경
     * PUT /api/admin/members/general/{memNo}/password
     */
	@PutMapping("/{memNo}/password")
	public ResponseEntity<Map<String, Object>> changePassword(
			@PathVariable int memNo,
			@RequestBody Map<String, String> passwordBox){

		log.info("비밀번호 변경 요청 - memNo: {}", memNo);

		Map<String, Object> response = new HashMap<>();

		try {
			String newPassword = passwordBox.get("newPassword");
			// 뜻: 영문 대문자, 소문자, 숫자, 특수문자가 모두 들어있고 8자 이상이어야 함!
			String passwordPattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$";

			if (newPassword == null || !newPassword.matches(passwordPattern)) {
				log.warn("규칙에 맞지 않는 비밀번호가 들어왔습니다.");
				response.put("success", false);
				response.put("message", "비밀번호는 영문 대/소문자, 숫자, 특수문자를 포함하여 8자 이상이어야 합니다.");
				return ResponseEntity.badRequest().body(response);
			}
			int result = generalService.changePassword(memNo, newPassword);

			if (result>0) {
				response.put("success", true);
				response.put("message", "비밀번호가 안전하게 변경되었습니다.");
				return ResponseEntity.ok(response);
			} else {
				response.put("success", false);
	            response.put("message", "비밀번호 변경에 실패했습니다. (회원 정보 확인 필요)");
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
			}
		} catch (Exception e) {
			log.error("비밀번호 변경 중 오류 발생", e);
			response.put("success", false);
            response.put("message", "비밀번호 변경 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

    /**
     * 아이디 중복 체크
     * GET /api/admin/members/general/check-id?memId=testuser
     */
	@GetMapping("/check-id")
	public ResponseEntity<Map<String, Object>> checkDuplicateId(@RequestParam String memId){
		log.info("아이디 중복 체크 - memId: {}", memId);

		Map<String, Object> response = new HashMap<>();

		boolean isDuplicate = generalService.checkDuplicateId(memId);

		response.put("isDuplicate", isDuplicate);
		response.put("message", isDuplicate ? "이미 사용중인 아이디입니다." : "사용 가능한 아이디입니다." );

		return ResponseEntity.ok(response);
	}

    /**
     * 이메일 중복 체크
     * GET /api/admin/members/general/check-email?email=test@example.com
     */
	@GetMapping("/check-email")
	public ResponseEntity<Map<String, Object>> checkDuplicateEmail(@RequestParam String memEmail){
		log.info("이메일 중복 체크 - memEmail: {}", memEmail);

		Map<String, Object> response = new HashMap<>();

		boolean isDuplicate = generalService.checkDuplicateEmail(memEmail);

		response.put("isDuplicate", isDuplicate);
		response.put("message", isDuplicate ? "이미 사용중인 이메일입니다." : "사용 가능한 이메일입니다.");

		return ResponseEntity.ok(response);
	}

	/**
	 * 일반회원 목록 엑셀 다운로드
	 * GET /api/admin/members/general/excel?searchWord=&searchType=all
	 */
	@GetMapping("/excel")
	public void downloadExcel(
			HttpServletResponse response,
			@RequestParam(defaultValue = "") String searchWord,
			@RequestParam(defaultValue = "all") String searchType) throws IOException{
		log.info("회원 목록 엑셀 다운로드 - searchWord: {}, searchType: {}", searchWord, searchType);

		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"); //보내는 데이터가 엑셀이라는거 알려주기
		response.setCharacterEncoding("UTF-8");
		response.setHeader("Content-Disposition", "attachment; filename=" + java.net.URLEncoder.encode(
				"일반회원목록_" + new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + ".xlsx","UTF-8"));
		PaginationInfoVO<MemberVO> pagInfoVO = new PaginationInfoVO<>(); //새 공책을 만들고,
		pagInfoVO.setSearchWord(searchWord); //그 공책에 무엇을 찾고 싶은지 적는다.
		if (!"all".equals(searchType)) {
			pagInfoVO.setSearchType(searchType);
		}
	 	generalService.downloadMemberExcel(response.getOutputStream(),pagInfoVO);
	}
	//[추가]프로필 파일 업로드
	@PostMapping("/profile/upload")
	public ResponseEntity<Map<String, Object>> uploadProfile(@RequestParam("file") MultipartFile file, HttpSession session){
		Map<String, Object> response = new HashMap<>();
		try {
			MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
			int regId = loginMember.getMemNo();

			int attachNo = fileService.saveFile(file, regId);

			response.put("success", true);
	        response.put("attachNo", attachNo);
	        return ResponseEntity.ok(response);

		} catch (Exception e) {
			response.put("success", false);
	        response.put("message", "파일 업로드 실패");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}

	}
}
