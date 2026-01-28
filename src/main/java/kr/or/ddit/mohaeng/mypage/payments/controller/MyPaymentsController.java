package kr.or.ddit.mohaeng.mypage.payments.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.mypage.payments.service.IMyPaymentsService;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;
import kr.or.ddit.mohaeng.vo.MyPaymentsVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Controller
@RequestMapping("/mypage/payments")
public class MyPaymentsController {
    
    @Autowired
    private IMyPaymentsService myPaymentsService;
    
    @Autowired
    private kr.or.ddit.mohaeng.product.review.service.IProdReviewService reviewService; 

    @GetMapping("/list")
    public String paymentList(
            @RequestParam(name="page", required = false, defaultValue = "1") int currentPage, 
            @RequestParam(required = false, defaultValue = "all") String contentType,        
            HttpSession session, Model model) {
        
        Map<String, Object> loginMember = (Map<String, Object>) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        int memNo = Integer.parseInt(String.valueOf(loginMember.get("memNo")));

        // 페이징 및 필터링 리스트 조회 로직
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
        
        // 결제 기본 정보 (마스터)
        result.put("master", myPaymentsService.selectPaymentMaster(payNo));
        // 상세 품목 리스트
        result.put("details", myPaymentsService.selectReceiptDetailList(payNo));
        
        return result;
    }
    
    /**
     * 후기 등록 
     */
    @PostMapping("/review/insert")
    @ResponseBody
    public Map<String, Object> insertReview(ProdReviewVO vo, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        Integer memNo = getMemNo(session);
        
        try {
            vo.setMemNo(memNo);
            
            // 서비스에서 파일 저장 및 DB Insert 로직 수행
            int status = reviewService.insertReview(vo); 
            
            if(status > 0) {
                result.put("success", true);
                result.put("message", "후기가 등록되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "등록에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "서버 오류 발생: " + e.getMessage());
        }
        return result;
    }

    /**
     * 마이페이지용 후기 수정
     */
    @PostMapping("/review/update")
    @ResponseBody
    public Map<String, Object> updateReview(
        ProdReviewVO vo, 
        @RequestParam(value = "deletedFiles", required = false) List<String> deletedFiles,
        HttpSession session
    ) {
        Map<String, Object> result = new HashMap<>();
        try {
            Integer memNo = getMemNo(session);
            vo.setMemNo(memNo);

            // 삭제 요청된 파일들 USE_YN = 'N' 처리
            if (deletedFiles != null && !deletedFiles.isEmpty()) {
                for (String filePath : deletedFiles) {
                    myPaymentsService.updateFileUseN(filePath); 
                }
            }

            // 리뷰 정보 수정 및 신규 이미지 추가 (보강된 서비스 호출)
            int status = reviewService.updateReview(vo); 

            if(status > 0) {
                result.put("success", true);
                result.put("message", "후기가 수정되었습니다.");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "수정 중 오류 발생");
        }
        return result;
    }
    
    @PostMapping("/review/delete")
    @ResponseBody
    public Map<String, Object> deleteReview(@RequestBody Map<String, Integer> payload, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        // JSON 데이터에서 prodRvNo 추출
        Integer prodRvNo = payload.get("prodRvNo");
        Integer memNo = getMemNo(session); // 세션에서 회원 번호 가져오기
        
        try {
            // 서비스 호출 (상태를 'HIDDEN'으로 바꾸거나 실제 삭제 수행)
            int deleted = reviewService.deleteReview(prodRvNo, memNo);
            
            if (deleted > 0) {
                result.put("success", true);
                result.put("message", "후기가 삭제되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "삭제 권한이 없거나 이미 삭제된 후기입니다.");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "삭제 중 오류가 발생했습니다.");
        }
        return result;
    }
    
    /**
     * 로그인 세션에서 memNo를 안전하게 추출하는 메서드
     */
    private Integer getMemNo(HttpSession session) {
        Object loginMember = session.getAttribute("loginMember");
        if (loginMember == null) {
            return null;
        }
        
        // 세션 저장 방식(Map 또는 VO)에 따라 처리
        if (loginMember instanceof java.util.Map) {
            Object memNoObj = ((java.util.Map<?, ?>) loginMember).get("memNo");
            if (memNoObj instanceof Number) {
                return ((Number) memNoObj).intValue();
            }
        } else if (loginMember instanceof kr.or.ddit.mohaeng.vo.MemberVO) {
            return ((kr.or.ddit.mohaeng.vo.MemberVO) loginMember).getMemNo();
        }
        
        return null;
    }

}