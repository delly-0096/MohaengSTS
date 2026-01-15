package kr.or.ddit.mohaeng.schedule.bookmarks.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/schedule")
public class ScheBookmarkController {

    /**
     * 내 북마크 페이지
     */
    @GetMapping("/bookmark")
    public String bookmark() {
        return "schedule/bookmark";
    }
}
