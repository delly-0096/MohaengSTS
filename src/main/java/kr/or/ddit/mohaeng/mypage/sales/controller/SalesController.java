package kr.or.ddit.mohaeng.mypage.sales.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.mypage.sales.service.ISalesService;
import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.SalesVO;

@Controller
@RequestMapping("mypage/business/sales")
public class SalesController {

	@Autowired
	private ISalesService service;
	
	/**
     * 매출 집계 페이지
     */
	@GetMapping
    public String salesSummary(HttpSession session, Model model) {
        Integer memNo = getMemNo(session);
        
        if (memNo == null) {
            return "redirect:/member/login";
        }
        
        // 통계 데이터 (상단 카드)
        Map<String, Object> stats = service.getSalesStats(memNo);
        model.addAttribute("stats", stats);
        
        return "mypage/business/sales";
    }
    
	/**
     * 전체 데이터 조회 (AJAX) - 필터 적용
     */
    @GetMapping("/data")
    @ResponseBody
    public Map<String, Object> getSalesData(HttpSession session, SalesVO salesVO) {
        Map<String, Object> result = new HashMap<>();
        
        Integer memNo = getMemNo(session);
        if (memNo == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        salesVO.setMemNo(memNo);
        
        // 월별 매출 추이
        List<SalesVO> monthlySales = service.getMonthlySales(salesVO);
        result.put("monthlySales", monthlySales);
        
        // 동종업계 비교
        SalesVO comparison = service.getIndustryComparison(salesVO);
        result.put("comparison", comparison);
        
        // 상세 내역
        Map<String, Object> salesList = service.getSalesList(salesVO);
        result.put("list", salesList.get("list"));
        result.put("totalCount", salesList.get("totalCount"));
        result.put("totalPages", salesList.get("totalPages"));
        result.put("summary", salesList.get("summary"));
        result.put("success", true);
        
        return result;
    }
    
    /**
     * 매출 목록만 조회 (AJAX) - 페이징, 검색, 필터
     */
    @GetMapping("/list")
    @ResponseBody
    public Map<String, Object> getSalesList(HttpSession session, SalesVO salesVO) {
        Map<String, Object> result = new HashMap<>();
        
        Integer memNo = getMemNo(session);
        if (memNo == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        salesVO.setMemNo(memNo);
        
        result = service.getSalesList(salesVO);
        result.put("success", true);
        
        return result;
    }
    
    /**
     * 상품별 매출 목록 조회 (AJAX)
     */
    @GetMapping("/products")
    @ResponseBody
    public Map<String, Object> getProductSales(HttpSession session, SalesVO salesVO) {
        Map<String, Object> result = new HashMap<>();
        
        Integer memNo = getMemNo(session);
        if (memNo == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        salesVO.setMemNo(memNo);
        
        // page, pageSize 파라미터를 productPage, productPageSize로 매핑
        if (salesVO.getProductPage() == 0) {
            salesVO.setProductPage(1);
        }
        if (salesVO.getProductPageSize() == 0) {
            salesVO.setProductPageSize(10);
        }
        
        result = service.getProductSalesData(salesVO);
        result.put("success", true);
        
        return result;
    }

    /**
     * 정산 요청 (AJAX)
     */
    @PostMapping("/settle")
    @ResponseBody
    public Map<String, Object> requestSettle(HttpSession session, @RequestBody Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();
        
        Integer memNo = getMemNo(session);
        if (memNo == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        try {
            @SuppressWarnings("unchecked")
            List<Integer> prodNoList = (List<Integer>) params.get("prodNoList");
            
            if (prodNoList == null || prodNoList.isEmpty()) {
                result.put("success", false);
                result.put("message", "선택된 상품이 없습니다.");
                return result;
            }
            
            int updated = service.requestSettle(prodNoList);
            
            result.put("success", true);
            result.put("message", updated + "건의 정산이 요청되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "정산 요청에 실패했습니다.");
        }
        
        return result;
    }
    
    /**
     * 세션에서 memNo 추출
     */
    private Integer getMemNo(HttpSession session) {
        Object loginMember = session.getAttribute("loginMember");
        if (loginMember == null) {
            return null;
        }
        
        if (loginMember instanceof Map) {
            Object memNoObj = ((Map<?, ?>) loginMember).get("memNo");
            if (memNoObj instanceof Number) {
                return ((Number) memNoObj).intValue();
            }
        } else if (loginMember instanceof MemberVO) {
            return ((MemberVO) loginMember).getMemNo();
        }
        
        return null;
    }
}
