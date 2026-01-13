package kr.or.ddit.mohaeng.mypage.bookmarks.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mypage")
public class MyBookmarksController {

    /**
     * 북마크 페이지
     */
    @GetMapping("/bookmarks")
    public String bookmarks() {
        return "mypage/bookmarks";
    }
    
}
