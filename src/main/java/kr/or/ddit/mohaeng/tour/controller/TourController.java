package kr.or.ddit.mohaeng.tour.controller;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.product.inquiry.service.ITripProdInquiryService;
import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;
import kr.or.ddit.mohaeng.product.review.service.IProdReviewService;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;
import kr.or.ddit.mohaeng.tour.service.ISearchLogService;
import kr.or.ddit.mohaeng.tour.service.ITripProdInfoService;
import kr.or.ddit.mohaeng.tour.service.ITripProdSaleService;
import kr.or.ddit.mohaeng.tour.service.ITripProdService;
import kr.or.ddit.mohaeng.tour.vo.SearchLogVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.MemberVO;

@Controller
@RequestMapping("/tour")
public class TourController {
    
    @Autowired
    private ITripProdService tripProdService;
    
    @Autowired
    private ITripProdSaleService saleService;
    
    @Autowired
    private ITripProdInfoService infoService;

    @Autowired
    private IProdReviewService reviewService;

    @Autowired
    private ITripProdInquiryService inquiryService;
    
    @Autowired
    private ISearchLogService searchLogService;

    /**
     * 목록 페이지
     */
    @GetMapping
    public String tour(TripProdVO tp, Model model) {
        List<TripProdVO> tpList = tripProdService.list(tp);
        int totalCount = tripProdService.getTotalCount(tp);
        
        // 인기 키워드 조회
        List<SearchLogVO> keywords = searchLogService.getKeywords();
        
        model.addAttribute("tpList", tpList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("tp", tp);
        model.addAttribute("keywords", keywords);
        
        return "product/tour";
    }
    
    /**
     * 추가 데이터
     */
    @GetMapping("/more")
    @ResponseBody
    public Map<String, Object> loadMore(TripProdVO tp) {
        // 검색 로그 저장
        if (tp.getKeyword() != null && !tp.getKeyword().trim().isEmpty() && tp.getPage() == 1) {
            SearchLogVO logVO = new SearchLogVO();
            logVO.setKeyword(tp.getKeyword().trim());
            searchLogService.insertSearchLog(logVO);
        }
        
        List<TripProdVO> tpList = tripProdService.list(tp);
        int totalCount = tripProdService.getTotalCount(tp);
        
        Map<String, Object> result = new HashMap<>();
        result.put("tpList", tpList);
        result.put("totalCount", totalCount);
        result.put("hasMore", (tp.getPage() * tp.getPageSize()) < totalCount);
        
        return result;
    }

    /**
     * 상세 페이지
     */
    @GetMapping("/{tripProdNo}")
    public String tourDetail(@PathVariable int tripProdNo, Model model, RedirectAttributes ra) {
        TripProdVO tp = tripProdService.detail(tripProdNo);
        
        if (tp == null) {
            ra.addFlashAttribute("message", "존재하지 않는 상품입니다.");
            return "redirect:/tour";
        }
        
        // 판매 정보
        TripProdSaleVO sale = saleService.getSale(tripProdNo);
        
        // 이용 안내
        TripProdInfoVO info = infoService.getInfo(tripProdNo);
        
        // 리뷰 목록 + 통계
        List<ProdReviewVO> review = reviewService.getReviewPaging(tripProdNo, 1, 5);
        ProdReviewVO reviewStat = reviewService.getStat(tripProdNo);
        
        // 문의 목록
        List<TripProdInquiryVO> inquiry = inquiryService.getInquiryPaging(tripProdNo, 1, 5);
        int inquiryCount = inquiryService.getInquiryCount(tripProdNo);
        
        model.addAttribute("tp", tp);
        model.addAttribute("sale", sale);
        model.addAttribute("info", info);
        model.addAttribute("review", review);
        model.addAttribute("reviewStat", reviewStat);
        model.addAttribute("inquiry", inquiry);
        model.addAttribute("inquiryCount", inquiryCount);
        
        return "product/tour-detail";
    }
    
    /**
     * 리뷰 더보기
     */
    @GetMapping("/{tripProdNo}/reviews")
    @ResponseBody
    public Map<String, Object> loadMoreReviews(
            @PathVariable int tripProdNo,
            @RequestParam(defaultValue = "2") int page,
            HttpSession session) {
        
        int pageSize = 5;
        List<ProdReviewVO> reviews = reviewService.getReviewPaging(tripProdNo, page, pageSize);
        ProdReviewVO stat = reviewService.getStat(tripProdNo);
        
        int totalCount = stat != null ? stat.getReviewCount() : 0;
        int loadedCount = page * pageSize;
        
        // 로그인 사용자 정보 추가
        Integer loginMemNo = null;
        Object loginMember = session.getAttribute("loginMember");
        if (loginMember != null) {
            if (loginMember instanceof Map) {
                Object memNo = ((Map<?, ?>) loginMember).get("memNo");
                if (memNo instanceof Number) {
                    loginMemNo = ((Number) memNo).intValue();
                }
            } else if (loginMember instanceof MemberVO) {
                loginMemNo = ((MemberVO) loginMember).getMemNo();
            }
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("reviews", reviews);
        result.put("hasMore", loadedCount < totalCount);
        result.put("loginMemNo", loginMemNo);
        
        return result;
    }
    
    /**
     * 문의 등록
     */
    @PostMapping("/{tripProdNo}/inquiry")
    @ResponseBody
    public Map<String, Object> insertInquiry(
            @PathVariable int tripProdNo,
            @RequestBody TripProdInquiryVO vo,
            HttpSession session) {
        
        Map<String, Object> result = new HashMap<>();
        
        Object loginMember = session.getAttribute("loginMember");
        if (loginMember == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        Integer memNo = null;
        String nickname = null;
        
        if (loginMember instanceof Map) {
            Object memNoObj = ((Map<?, ?>) loginMember).get("memNo");
            if (memNoObj instanceof Number) {
                memNo = ((Number) memNoObj).intValue();
            }
            Object nicknameObj = ((Map<?, ?>) loginMember).get("nickname");
            if (nicknameObj != null) {
                nickname = nicknameObj.toString();
            }
        } else if (loginMember instanceof MemberVO) {
            MemberVO member = (MemberVO) loginMember;
            memNo = member.getMemNo();
            
            // MemUserVO에서 닉네임 가져오기
            if (member.getMemUser() != null) {
                nickname = member.getMemUser().getNickname();
            }
        }
        
        if (memNo == null) {
            result.put("success", false);
            result.put("message", "회원 정보를 확인할 수 없습니다.");
            return result;
        }
        
        try {
            vo.setTripProdNo(tripProdNo);
            vo.setInquiryMemNo(memNo);
            
            TripProdInquiryVO inserted = inquiryService.insertInquiry(vo);
            
            // 닉네임 설정
            if (nickname != null) {
                inserted.setInquiryNickname(nickname);
            }
            
            result.put("success", true);
            result.put("message", "문의가 등록되었습니다.");
            result.put("inquiry", inserted);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "문의 등록에 실패했습니다.");
        }
        
        return result;
    }
    
    /**
     * 문의 수정
     */
    @PostMapping("/{tripProdNo}/inquiry/update")
    @ResponseBody
    public Map<String, Object> updateInquiry(
            @PathVariable int tripProdNo,
            @RequestBody TripProdInquiryVO vo,
            HttpSession session) {
        
        Map<String, Object> result = new HashMap<>();
        
        Object loginMember = session.getAttribute("loginMember");
        if (loginMember == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        Integer memNo = null;
        if (loginMember instanceof Map) {
            Object memNoObj = ((Map<?, ?>) loginMember).get("memNo");
            if (memNoObj instanceof Number) {
                memNo = ((Number) memNoObj).intValue();
            }
        } else if (loginMember instanceof MemberVO) {
            memNo = ((MemberVO) loginMember).getMemNo();
        }
        
        if (memNo == null) {
            result.put("success", false);
            result.put("message", "회원 정보를 확인할 수 없습니다.");
            return result;
        }
        
        try {
            vo.setInquiryMemNo(memNo);
            int updated = inquiryService.updateInquiry(vo);
            
            if (updated > 0) {
                result.put("success", true);
                result.put("message", "문의가 수정되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "수정 권한이 없거나 답변 완료된 문의입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "문의 수정에 실패했습니다.");
        }
        
        return result;
    }

    /**
     * 문의 삭제
     */
    @PostMapping("/{tripProdNo}/inquiry/delete")
    @ResponseBody
    public Map<String, Object> deleteInquiry(
            @PathVariable int tripProdNo,
            @RequestBody Map<String, Integer> params,
            HttpSession session) {
        
        Map<String, Object> result = new HashMap<>();
        
        Object loginMember = session.getAttribute("loginMember");
        if (loginMember == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        Integer memNo = null;
        if (loginMember instanceof Map) {
            Object memNoObj = ((Map<?, ?>) loginMember).get("memNo");
            if (memNoObj instanceof Number) {
                memNo = ((Number) memNoObj).intValue();
            }
        } else if (loginMember instanceof MemberVO) {
            memNo = ((MemberVO) loginMember).getMemNo();
        }
        
        if (memNo == null) {
            result.put("success", false);
            result.put("message", "회원 정보를 확인할 수 없습니다.");
            return result;
        }
        
        try {
            int prodInqryNo = params.get("prodInqryNo");
            int deleted = inquiryService.deleteInquiry(prodInqryNo, memNo);
            
            if (deleted > 0) {
                result.put("success", true);
                result.put("message", "문의가 삭제되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "삭제 권한이 없거나 답변 완료된 문의입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "문의 삭제에 실패했습니다.");
        }
        
        return result;
    }
    
    // 문의 더보기
    @GetMapping("/{tripProdNo}/inquiries")
    @ResponseBody
    public Map<String, Object> loadMoreInquiries(
            @PathVariable int tripProdNo,
            @RequestParam(defaultValue = "2") int page,
            HttpSession session) {
        
        int pageSize = 5;
        List<TripProdInquiryVO> inquiries = inquiryService.getInquiryPaging(tripProdNo, page, pageSize);
        int totalCount = inquiryService.getInquiryCount(tripProdNo);
        int loadedCount = page * pageSize;
        
        // 로그인 사용자 정보 (비밀글 처리용)
        Integer loginMemNo = null;
        Object loginMember = session.getAttribute("loginMember");
        if (loginMember != null) {
            if (loginMember instanceof Map) {
                Object memNo = ((Map<?, ?>) loginMember).get("memNo");
                if (memNo instanceof Number) {
                    loginMemNo = ((Number) memNo).intValue();
                }
            } else if (loginMember instanceof MemberVO) {
                loginMemNo = ((MemberVO) loginMember).getMemNo();
            }
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("inquiries", inquiries);
        result.put("hasMore", loadedCount < totalCount);
        result.put("loginMemNo", loginMemNo);
        
        return result;
    }
    
    /**
     * 문의 답변 등록
     */
    @PostMapping("/{tripProdNo}/inquiry/reply")
    @ResponseBody
    public Map<String, Object> insertReply(
            @PathVariable int tripProdNo,
            @RequestBody Map<String, Object> param,
            HttpSession session) {
        
        Map<String, Object> result = new HashMap<>();
        
        Object loginMember = session.getAttribute("loginMember");
        if (loginMember == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        // 기업회원 체크
        String memType = null;
        Integer memNo = null;
        
        if (loginMember instanceof Map) {
            Map<?, ?> memberMap = (Map<?, ?>) loginMember;
            memType = (String) memberMap.get("memType");
            Object memNoObj = memberMap.get("memNo");
            if (memNoObj instanceof Number) {
                memNo = ((Number) memNoObj).intValue();
            }
        }
        
        if (!"BUSINESS".equals(memType)) {
            result.put("success", false);
            result.put("message", "기업회원만 답변할 수 있습니다.");
            return result;
        }
        
        try {
            int prodInqryNo = Integer.parseInt(param.get("prodInqryNo").toString());
            String replyCn = (String) param.get("replyCn");
            
            TripProdInquiryVO vo = new TripProdInquiryVO();
            vo.setProdInqryNo(prodInqryNo);
            vo.setReplyCn(replyCn);
            vo.setReplyMemNo(memNo);
            
            int updated = inquiryService.insertReply(vo);
            
            if (updated > 0) {
                result.put("success", true);
                result.put("message", "답변이 등록되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "답변 등록에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "답변 등록 중 오류가 발생했습니다.");
        }
        
        return result;
    }
    
    /**
     * 문의 답변 수정
     */
    @PostMapping("/{tripProdNo}/inquiry/reply/update")
    @ResponseBody
    public Map<String, Object> updateReply(
            @PathVariable int tripProdNo,
            @RequestBody Map<String, Object> param,
            HttpSession session) {
        
        Map<String, Object> result = new HashMap<>();
        
        Object loginMember = session.getAttribute("loginMember");
        if (loginMember == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        String memType = null;
        Integer memNo = null;
        
        if (loginMember instanceof Map) {
            Map<?, ?> memberMap = (Map<?, ?>) loginMember;
            memType = (String) memberMap.get("memType");
            Object memNoObj = memberMap.get("memNo");
            if (memNoObj instanceof Number) {
                memNo = ((Number) memNoObj).intValue();
            }
        }
        
        if (!"BUSINESS".equals(memType)) {
            result.put("success", false);
            result.put("message", "기업회원만 수정할 수 있습니다.");
            return result;
        }
        
        try {
            int prodInqryNo = Integer.parseInt(param.get("prodInqryNo").toString());
            String replyCn = (String) param.get("replyCn");
            
            TripProdInquiryVO vo = new TripProdInquiryVO();
            vo.setProdInqryNo(prodInqryNo);
            vo.setReplyCn(replyCn);
            vo.setReplyMemNo(memNo);
            
            int updated = inquiryService.updateReply(vo);
            
            if (updated > 0) {
                result.put("success", true);
                result.put("message", "답변이 수정되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "수정 권한이 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "답변 수정 중 오류가 발생했습니다.");
        }
        
        return result;
    }

    /**
     * 문의 답변 삭제
     */
    @PostMapping("/{tripProdNo}/inquiry/reply/delete")
    @ResponseBody
    public Map<String, Object> deleteReply(
            @PathVariable int tripProdNo,
            @RequestBody Map<String, Object> param,
            HttpSession session) {
        
        Map<String, Object> result = new HashMap<>();
        
        Object loginMember = session.getAttribute("loginMember");
        if (loginMember == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        String memType = null;
        Integer memNo = null;
        
        if (loginMember instanceof Map) {
            Map<?, ?> memberMap = (Map<?, ?>) loginMember;
            memType = (String) memberMap.get("memType");
            Object memNoObj = memberMap.get("memNo");
            if (memNoObj instanceof Number) {
                memNo = ((Number) memNoObj).intValue();
            }
        }
        
        if (!"BUSINESS".equals(memType)) {
            result.put("success", false);
            result.put("message", "기업회원만 삭제할 수 있습니다.");
            return result;
        }
        
        try {
            int prodInqryNo = Integer.parseInt(param.get("prodInqryNo").toString());
            
            int deleted = inquiryService.deleteReply(prodInqryNo, memNo);
            
            if (deleted > 0) {
                result.put("success", true);
                result.put("message", "답변이 삭제되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "삭제 권한이 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "답변 삭제 중 오류가 발생했습니다.");
        }
        
        return result;
    }

    @GetMapping("/{tripProdNo}/booking")
    public String booking(@PathVariable int tripProdNo) {
        return "product/booking";
    }

    @GetMapping("/complete/{tripProdNo}")
    public String complete(@PathVariable int tripProdNo) {
        return "product/complete";
    }

    @GetMapping("/complete")
    public String completeBooking() {
        return "product/complete";
    }
}