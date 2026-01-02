package kr.or.ddit.mohaeng.support.inquiry.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.support.inquiry.service.IInquiryService;
import kr.or.ddit.mohaeng.vo.InquiryVO;

/**
 * 기존의 지저분한 세션 타입 체크(instanceof)를 제거하고
 * Spring Security 표준(@AuthenticationPrincipal)을 사용하여
 * 데이터 누락 방지 및 코드 가독성을 확보함.
 */
@Controller
public class SupportInquiryController {

    @Autowired
    private IInquiryService inquiryService;

    /**
     * 문의 목록 조회 및 작성 페이지 통합 처리
     * @param userDetails : Spring Security에서 주입해주는 인증 정보 (핵심)
     */
    @GetMapping({"/support/inquiry", "/support/business/inquiries"})
    public String inquiryList(
            @RequestParam(defaultValue = "history") String tab,
            @RequestParam(defaultValue = "all") String category,
            @RequestParam(defaultValue = "1") int page,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            HttpServletRequest request, Model model) {

        /* 1. 카테고리 정보 로드 (글쓰기/필터용) */
        model.addAttribute("categoryList", inquiryService.getInquiryCategoryList());

        /* 2. 로그인 여부 및 이메일 데이터 추출 (세션 직접 접근 불필요) */
        if (userDetails == null) {
            return "redirect:/member/login";
        }

        // CustomUserDetails 내부의 MemberVO에서 정보를 바로 꺼냄
        int memNo = userDetails.getMember().getMemNo();
        String memEmail = userDetails.getMember().getMemEmail();


        /* 3. DB 조회를 위한 파라미터 셋팅 */
        Map<String, Object> params = new HashMap<>();
        params.put("memNo", memNo);
        params.put("category", category);
        params.put("pageSize", 10);
        params.put("offset", (page - 1) * 10);

        /* 4. 문의 목록 및 페이징 계산 */
        int totalCount = inquiryService.getInquiryCountByCategory(params);
        int totalPages = (totalCount > 0) ? (int) Math.ceil((double) totalCount / 10) : 1;

        /* 5. 뷰(JSP)로 보낼 데이터 바인딩 */
        model.addAttribute("inquiryList", inquiryService.getInquiryListByCategory(params));
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("currentTab", tab);
        model.addAttribute("currentCategory", category);

        System.out.println("DEBUG - 로그인 이메일: " + memEmail);

        // [수정 포인트] JSP의 value="${loginEmail}"에 정확히 매칭됨
        model.addAttribute("loginEmail", memEmail);

        /* 6. URL에 따른 경로 분기 (삼항연산자로 단축) */
        return request.getRequestURI().contains("/business")
               ? "mypage/business/inquiryList"
               : "support/inquiry";
    }

    /**
     * 1:1 문의 등록 처리 (AJAX 전송용)
     */
    @PostMapping("/support/inquiry")
    @ResponseBody
    public Map<String, Object> submitInquiry(
            @RequestBody InquiryVO inquiry,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        Map<String, Object> result = new HashMap<>();

        if (userDetails == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        /* 작성자 정보 강제 주입 (서버 데이터 우선) */
        inquiry.setMemNo(userDetails.getMember().getMemNo());

        // 이메일이 빈칸이면 현재 로그인된 계정 이메일로 셋팅
        if (inquiry.getInqryEmail() == null || inquiry.getInqryEmail().isEmpty()) {
            inquiry.setInqryEmail(userDetails.getMember().getMemEmail());
        }

        inquiry.setInqryStatus("waiting"); // 기본값: 답변 대기
        inquiry.setDelYn("N");             // 기본값: 미삭제

        int insertResult = inquiryService.insertInquiry(inquiry);

        result.put("success", insertResult > 0);
        result.put("message", insertResult > 0 ? "문의가 등록되었습니다." : "등록에 실패했습니다.");

        return result;
    }

    /**
     * 문의 상세 조회 (상세 내역 보기 클릭 시)
     */
    @GetMapping("/support/inquiry/detail/{inqryNo}")
    @ResponseBody
    public Map<String, Object> getInquiryDetail(
            @PathVariable int inqryNo,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        Map<String, Object> result = new HashMap<>();

        if (userDetails == null) {
            result.put("success", false);
            return result;
        }

        InquiryVO inquiry = inquiryService.getInquiryDetail(inqryNo);

        /* 보안 체크: 작성자 본인만 열람 가능하도록 검증 */
        if (inquiry != null && inquiry.getMemNo() == userDetails.getMember().getMemNo()) {
            result.put("success", true);
            result.put("inquiry", inquiry);
        } else {
            result.put("success", false);
            result.put("message", "권한이 없습니다.");
        }
        return result;
    }
}