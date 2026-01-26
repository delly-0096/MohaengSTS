package kr.or.ddit.mohaeng.mypage.payments.controller;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.mypage.payments.service.IMyPaymentsService;
import kr.or.ddit.mohaeng.vo.MyPaymentsVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Controller
@RequestMapping("/mypage/payments")
public class MyPaymentsController {
    
    @Autowired
    private IMyPaymentsService myPaymentsService;

    @GetMapping("/list")
    public String paymentList(
            @RequestParam(name="page", required = false, defaultValue = "1") int currentPage, 
            @RequestParam(required = false, defaultValue = "all") String contentType,        
            HttpSession session, Model model) {
        
        Map<String, Object> loginMember = (Map<String, Object>) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        int memNo = Integer.parseInt(String.valueOf(loginMember.get("memNo")));

        // 1. 페이징 및 필터링 리스트 조회 로직
        PaginationInfoVO<MyPaymentsVO> pagingVO = new PaginationInfoVO<>(5, 5);
        pagingVO.setMemNo(memNo);
        if (StringUtils.isNotBlank(contentType)) pagingVO.setSearchType(contentType);
        
        pagingVO.setCurrentPage(currentPage);
        int totalRecord = myPaymentsService.selectMyPaymentsCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);
        
        // 이 메서드가 XML의 'selectMyPaymentsList'를 호출하여 데이터를 가져옵니다.
        pagingVO.setDataList(myPaymentsService.selectMyPaymentsList(pagingVO));

        model.addAttribute("contentType", contentType);
        model.addAttribute("pagingVO", pagingVO);
        
        // 상단 통계 데이터 조회
        model.addAttribute("stats", myPaymentsService.getPaymentStats(memNo));

        return "mypage/payments"; 
    }
    
    @GetMapping("/receiptDetail")
    @ResponseBody
    public Map<String, Object> getReceiptDetail(int payNo) {
        Map<String, Object> result = new HashMap<>();
        
        // 1. 결제 기본 정보 (마스터)
        result.put("master", myPaymentsService.selectPaymentMaster(payNo));
        // 2. 상세 품목 리스트
        result.put("details", myPaymentsService.selectReceiptDetailList(payNo));
        
        return result;
    }
}