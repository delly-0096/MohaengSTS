package kr.or.ddit.mohaeng.mypage.inquiries.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.mypage.inquiries.service.IMyInquiryService;
import kr.or.ddit.mohaeng.vo.InquiryVO;
import kr.or.ddit.mohaeng.vo.MemberVO;

//@Controller
@RequestMapping("/mypage")
public class MyInquiryController_copy {

	@Autowired
	private IMyInquiryService iInquiryService;


	// ==================== 마이페이지 - 문의 내역 ====================

	/**
	 * 마이페이지 > 문의 내역 (조회 전용)
	 * @param filter 필터 (all, answered, waiting)
	 * @param months 조회 기간 (3, 6, 12, 0=전체)
	 * @param page 페이지 번호
	 * @param session 세션
	 * @param model 모델
	 * @return 문의 내역 페이지
	 */
	@GetMapping({"/inquiries", "/business/inquiries"})
	public String inquriesList(
			@RequestParam(defaultValue = "all") String filter,
			@RequestParam(defaultValue = "3") int months,
			@RequestParam(defaultValue = "1") int page,
			HttpSession session, Model model
			) {
				/*
				 * //로그인 체크 MemberVO loginMember = (MemberVO)
				 * session.getAttribute("loginMember"); if (loginMember == null) { return
				 * "redirect:/member/login"; }
				 */

				//로그인 체크
				Object loginObj = session.getAttribute("loginMember");
				if (loginObj == null) {
					return "redirect:/member/login";
				}

			//로그인 타입에 따른 회원번호 추출
			int memNo;

			if (loginObj instanceof MemberVO) {
				// MemberVO 객체인 경우
				memNo = ((MemberVO)loginObj).getMemNo();
			} else if (loginObj instanceof Map) {
				// HashMap인 경우 (LoginController에서 설정한 camelCase 키 사용)
				Object memNoObj = ((Map<?, ?>)loginObj).get("memNo");
				if (memNoObj == null) {
					return "redirect:/member/login";
				}
				memNo = Integer.parseInt(String.valueOf(memNoObj));
			} else {
				return "redirect:/member/login";
			}

		//[주문서 작성]문의 목록 조회 파라미터
		//db에 전달할 조회 조건들을 Map상자에 담음
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

		return "mypage/inquiries";

	}

}
