package kr.or.ddit.mohaeng.community.travellog.record.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.mohaeng.community.travellog.record.security.AuthPrincipalExtractor;
import kr.or.ddit.mohaeng.community.travellog.record.service.ITripRecordService;
import kr.or.ddit.mohaeng.vo.TripRecordDetailVO;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/community")
@RequiredArgsConstructor
public class TripRecordPageController {

    private final ITripRecordService tripRecordService;

    @GetMapping("/travel-log")
    public String listPage(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "12") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String openScopeCd,
            Authentication authentication,
            Model model
    ) {
        Long loginMemNo = AuthPrincipalExtractor.getMemNo(authentication); // 비로그인이면 null
        var paged = tripRecordService.list(page, size, keyword, openScopeCd, loginMemNo);

        model.addAttribute("paged", paged);
        model.addAttribute("loginMemNo", loginMemNo);

        return "community/travel-log";
    }

    // ✅ write.jsp 재사용 (CREATE / EDIT)
    // 작성: /community/travel-log/write
    // 수정: /community/travel-log/write?rcdNo=22
    @GetMapping("/travel-log/write")
    public String writePage(
            @RequestParam(required = false) Long rcdNo,
            Authentication authentication,
            Model model
    ) {
        Long loginMemNo = AuthPrincipalExtractor.getMemNo(authentication);
        model.addAttribute("loginMemNo", loginMemNo);

        if (rcdNo != null) {
            TripRecordDetailVO detail = tripRecordService.detail(rcdNo, loginMemNo, false); // 조회수 증가 X

            // ⚠️ detail.getMemNo() 필드명이 실제로 다르면 여기만 바꿔야 함
            boolean isWriter = (loginMemNo != null && loginMemNo.equals(detail.getMemNo()));

            model.addAttribute("detail", detail);
            model.addAttribute("isWriter", isWriter);

            if (!isWriter) {
                return "redirect:/community/travel-log/detail?rcdNo=" + rcdNo;
            }
            model.addAttribute("mode", "EDIT");
        } else {
            model.addAttribute("mode", "CREATE");
        }

        // ✅ 너 write jsp 경로가 "community/travel-log-write.jsp"라면 여기 파일명도 맞춰야 함
        return "community/travel-log-write";
    }

    @GetMapping("/travel-log/detail")
    public String detailPage(
            @RequestParam long rcdNo,
            @RequestParam(defaultValue = "true") boolean incView,
            Authentication authentication,
            Model model
    ) {
        Long loginMemNo = AuthPrincipalExtractor.getMemNo(authentication);

        TripRecordDetailVO detail = tripRecordService.detail(rcdNo, loginMemNo, incView);

        // ⚠️ detail.getMemNo() 필드명이 실제로 다르면 여기만 바꿔야 함
        boolean isWriter = (loginMemNo != null && loginMemNo.equals(detail.getMemNo()));

        model.addAttribute("detail", detail);
        model.addAttribute("loginMemNo", loginMemNo);
        model.addAttribute("isWriter", isWriter);

        model.addAttribute("likeActiveClass", detail.getMyLiked() == 1 ? "active" : "");
        model.addAttribute("likeIconClass", detail.getMyLiked() == 1 ? "bi-heart-fill" : "bi-heart");
        
        model.addAttribute("blocks", tripRecordService.blocks(rcdNo));

        // ✅ 너 detail jsp 파일명에 맞추기
        return "community/travel-log-detail";
    }
    
    
}
