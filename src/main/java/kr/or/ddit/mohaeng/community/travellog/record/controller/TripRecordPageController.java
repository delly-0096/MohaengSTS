package kr.or.ddit.mohaeng.community.travellog.record.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.mohaeng.community.travellog.record.service.ITripRecordService;
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
            Model model
    ) {
        // ✅ 지금은 비로그인/로그인 구분 로직을 아직 안 넣는다고 했으니 우선 null로
        Long loginMemNo = null;

        var paged = tripRecordService.list(page, size, keyword, openScopeCd, loginMemNo);

        // ✅ JSP에서 ${paged.content} 로 쓰고 있으니 이름을 "paged"로 맞춰준다
        model.addAttribute("paged", paged);

        return "community/travel-log";
    }

    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/travel-log/write")
    public String writePage() {
        return "community/travel-log-write";
    }
    
    @GetMapping("/travel-log/detail")
    public String detailPage(
            @RequestParam long rcdNo,
            @RequestParam(defaultValue = "true") boolean incView,
            Model model
    ) {
        // ✅ 지금은 로그인 구분 로직 없다고 했으니 우선 null
        Long loginMemNo = null;

        var detail = tripRecordService.detail(rcdNo, loginMemNo, incView);
        model.addAttribute("detail", detail);

        return "community/travel-log-detail";
    }


}
