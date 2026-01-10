package kr.or.ddit.mohaeng.mypage.inquiries.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.mypage.inquiries.service.IMyInquiryService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.InquiryVO;
import kr.or.ddit.mohaeng.vo.MemberVO;

//@Controller
@RequestMapping("/mypage")
public class MyInquiryController_copy2 {

	@Autowired
	private IMyInquiryService iInquiryService;


	/**
     * 마이페이지 > 문의 내역 (Spring Security 적용 버전)
     */
	@GetMapping({"/inquiries", "/business/inquiries"})
	public String inquriesList(
			@RequestParam(defaultValue = "all") String filter,
			@RequestParam(defaultValue = "3") int months,
			@RequestParam(defaultValue = "1") int page,
			@AuthenticationPrincipal CustomUserDetails userDetails, // Security 정보 주입
			HttpServletRequest request, Model model) {

		// 1. 로그인 체크 (UserDetails가 없으면 로그인 페이지로)
		if (userDetails == null) {
			return "redirect:/member/login";
		}

		// 2. 회원 번호 추출 (이미 시큐리티에 담긴 검증된 정보 사용)
		int memNo = userDetails.getMember().getMemNo();

		// 3. 데이터 조회 파라미터 셋팅
		Map<String, Object> params = new HashMap<>();
		params.put("memNo", memNo);
		params.put("filter", filter);
		params.put("months", months);
		params.put("pageSize", 10);
		params.put("offset", (page-1)*10);

		//[데이터 조회]
		//서비스에게 일을 시켜서 결과를 받아옴
		List<InquiryVO> inquiryList = iInquiryService.getInquiryList(params); //문의 목록 조회
		int totalCount = iInquiryService.getInquiryCount(params); //전체 문의 갯수 조회
		Map<String, Integer> status = iInquiryService.getInquiryStats(memNo); //통계 정보 조회(전체/답변완료/답변대기)

		//[페이징 계산] 전체 페이지 수 구하기
		int totalPages = (totalCount>0)?(int)Math.ceil((double)totalCount/10):1;

		//[바구니 담기] HTML화면에서 사용할 수 있도록 Model에 데이터를 담기
		model.addAttribute("inquiryList", inquiryList); //글 목록
		model.addAttribute("totalCount",totalCount); //총 개수
		model.addAttribute("status", status); //통계 정보
		model.addAttribute("currentPage", page ); // 현재 내가 보고 있는 페이지
		model.addAttribute("totalPages", totalPages); //마지막 페이지 번호
		model.addAttribute("currentFilter", filter); // 화면의 필터 상태를 유지하기 위해 다시 보냄
		model.addAttribute("currentMonths", months); // 화면의 조회기간 상태를 유지하기 위해 다시 보냄

		// 7. 경로 분기 (일반 마이페이지 vs 기업 마이페이지)
		// URL에 /business가 포함되어 있다면 기업용 경로, 아니면 일반 경로 반환
		return request.getRequestURI().contains("/business") ? "mypage/business/inquiries" : "mypage/inquiries";

	}

}
