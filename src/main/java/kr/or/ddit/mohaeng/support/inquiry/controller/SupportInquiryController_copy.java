package kr.or.ddit.mohaeng.support.inquiry.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.mypage.inquiries.service.IMyInquiryService;
import kr.or.ddit.mohaeng.support.inquiry.service.IInquiryService;
import kr.or.ddit.mohaeng.vo.CodeVO;
import kr.or.ddit.mohaeng.vo.InquiryVO;
import kr.or.ddit.mohaeng.vo.MemberVO;

/**
 * 고객지원 - 1:1 문의 컨트롤러
 */
//@Controller
@RequestMapping("/support")
public class SupportInquiryController_copy {

	@Autowired
	private IInquiryService inquiryService;

	/**
	 * 고객지원 > 1:1 문의 페이지
	 * @param tab 탭 (history, write)
	 * @param category 카테고리 필터
	 * @param page 페이지 번호
	 * @param session 세션
	 * @param model 모델
	 * @return 1:1 문의 페이지
	 */
	@GetMapping("/inquiry")
	public String inquiry(
			@RequestParam(defaultValue = "history") String tab,
			@RequestParam(defaultValue = "all") String category,
			@RequestParam(defaultValue = "1") int page,
			HttpSession session, Model model
			) {

		// 1. 공통 데이터 조회: 로그인 안 해도 '문의 카테고리'는 알아야 글쓰기 준비가 됨
		List<CodeVO> categoryList = inquiryService.getInquiryCategoryList();
		model.addAttribute("categoryList", categoryList);

		// 2. 로그인 세션 관리
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");

		// 3. 로그인 된 경우만 개인 맞춤 '문의 내역'을 DB에서 가져옴
		if (loginMember != null) {
			Map<String, Object> params = new HashMap<>();
			params.put("memNo", loginMember.getMemNo());//누구 글인지
			params.put("category", category); //어떤 카테고리 인지(회원/계정, 일정/예약 등등..)
			params.put("pageSize", 10); // 한 페이지에 10개만!
			params.put("offset", (page-1)*10); // 어디서부터 시작할지!

			// 카테고리별 문의 목록 조회
			List<InquiryVO> inquiryList = inquiryService.getInquiryListByCategory(params);
			int totalCount = inquiryService.getInquiryCountByCategory(params);
			// 페이지 정보 계산
			int totalPages = (totalCount>0)?(int)Math.ceil((double)totalCount/10):1;

			model.addAttribute("inquiryList", inquiryList);
			model.addAttribute("totalCount", totalCount);
			model.addAttribute("curerntPage", page);
			model.addAttribute("totalPages", totalPages);

		}

		model.addAttribute("currentTab", tab);
		model.addAttribute("cuttentCategory", category);

		return "support/inquiry";
	}

	/**
	 * 문의 작성 처리
	 * @param inquiry 문의 정보
	 * @param session 세션
	 * @return 처리결과 JSON
	 */
	@PostMapping("/inquiry")
	@ResponseBody
	public Map<String, Object> submitInquiry(
			@RequestBody InquiryVO inquiry, HttpSession session){
		// 1. 응답 결과를 담을 바구니(Map) 생성-(ajax는 성공여부/메세지등을 데이터로 넘겨줌)
		Map<String, Object> result = new HashMap<>();

		// 2. [보안] 로그인 체크
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		if (loginMember == null) {
			result.put("success", false);
			result.put("message", "로그인이 필요합니다.");
			result.put("redirect", "/member/login");
			return result;
		}

		// 3. [데이터 보정] 작성자 정보 설정
	    // 화면에서 넘어온 데이터 외에, 서버가 알고 있는 회원번호를 VO에 강제로 주입
		inquiry.setMemNo(loginMember.getMemNo());

		// 4. [방어 로직] 이메일 누락 처리
		// 이메일이 없으면 회원 이메일 사용
		if (inquiry.getInqryEmail() == null || inquiry.getInqryEmail().isEmpty()) {
			inquiry.setInqryEmail(loginMember.getMemEmail());
		}

		// 5. [DB 실행] 문의 등록 서비스 호출
		int insertResult = inquiryService.insertInquiry(inquiry);

		// 6. [결과 처리] 성공/실패에 따른 응답 메시지
		if (insertResult>0) {
			result.put("success", true);
			result.put("message", "문의가 등록되었습니다. 빠른 시일 내에 답변드리겠습니다.");
		} else {
			result.put("success", false);
			result.put("message", "문의 등록에 실패했습니다. 다시 시도해주세요.");
		}
		return result;
	}


	/**
	 * 문의 상세 조회(ajax)
	 * @param inqryNo 문의 번호
	 * @param session
	 * @return 문의 상세 정보 JSON
	 */
	@GetMapping("/inquiry/detail/{inquryNo}")
	@ResponseBody // 데이터를 JSON으로 반환 (AJAX용)
	public Map<String, Object> getInquiryDetail(@PathVariable int inqryNo, HttpSession session){
		Map<String, Object> result = new HashMap<>();

		// 1. [보안]로그인 체크
		//(로그인하지 않은 사용자가 주소창에 직접 번호를 쳐서 들어오는 것을 방지)
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		if (loginMember == null) {
			result.put("success", false);
			result.put("message", "로그인이 필요합니다.");
			return result;
		}

		// 2. [DB 조회] 문의 번호(PK)로 단건 조회 실행
		InquiryVO inquiry = inquiryService.getInquiryDetail(inqryNo);

		// 3. [핵심 보안] 권한 체크 (본인 확인)
		// DB에서 가져온 글의 회원번호(inquiry.getMemNo())와 현재 로그인한 사람의 회원번호(loginMember.getMemNo()) 비교
		if (inquiry !=null && inquiry.getMemNo() == loginMember.getMemNo()) {
			// 본인이 쓴 글이 맞다면 데이터 전송
			result.put("success", true);
			result.put("inquiry", inquiry); // 조회된 VO 객체 통째로 담기
		} else {
			// 글이 없거나, 다른 사람의 글 번호를 입력해서 접근한 경우
			result.put("success", false);
			result.put("message", "권한이 없습니다.");
		}
		// 4. JSON 응답 반환
	    // 성공 시: {"success": true, "inquiry": { ...글 정보... }}
	    // 실패 시: {"success": false, "message": "권한이 없습니다."}
		return result;
	}
}
