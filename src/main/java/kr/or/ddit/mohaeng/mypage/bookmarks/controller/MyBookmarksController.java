package kr.or.ddit.mohaeng.mypage.bookmarks.controller;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.mypage.bookmarks.service.IBookMarkService;
import kr.or.ddit.mohaeng.vo.BookmarkVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MyBookmarksController {

	@Autowired
	private IBookMarkService bookMarkService;
	
	// 마이페이지에서 접근할 때 (통계 노출 Y)
    @RequestMapping("/mypage/bookmarks")
    public String mypageBookmarks(
            @RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(required = false, defaultValue = "all") String contentType,
            HttpSession session, Model model) {
        return processBookmarkList(currentPage, contentType, session, model, "Y");
    }

    // 일정 메뉴에서 접근할 때 (통계 노출 N)
    @RequestMapping("/schedule/bookmark")
    public String scheduleBookmarks(
            @RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(required = false, defaultValue = "all") String contentType,
            HttpSession session, Model model) {
        return processBookmarkList(currentPage, contentType, session, model, "N");
    }

    // 실제 로직을 담당하는 공통 메서드
    private String processBookmarkList(int currentPage, String contentType, 
                                     HttpSession session, Model model, String showStats) {
        Map<String, Object> loginMember = (Map<String, Object>) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        int memNo = Integer.parseInt(String.valueOf(loginMember.get("memNo")));

        // showStats가 'Y'일 때만 통계 조회
        if ("Y".equals(showStats)) {
            Map<String, Object> stats = bookMarkService.selectBookmarkStats(memNo);
            model.addAttribute("stats", stats);
        }
        model.addAttribute("showStats", showStats);

        // 페이징 및 리스트 조회 로직 
        PaginationInfoVO<BookmarkVO> pagingVO = new PaginationInfoVO<>(9, 5);
        pagingVO.setMemNo(memNo);
        if (StringUtils.isNotBlank(contentType)) pagingVO.setSearchType(contentType);
        
        pagingVO.setCurrentPage(currentPage);
        int totalRecord = bookMarkService.selectBookMarkCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);
        pagingVO.setDataList(bookMarkService.selectBookMarkList(pagingVO));

        model.addAttribute("contentType", contentType);
        model.addAttribute("pagingVO", pagingVO);
        
        return "mypage/bookmarks";
    }
	
	@ResponseBody
	@PostMapping({"/mypage/bookmarks/delete", "/schedule/bookmark/delete"})
	public String deleteBookmarks(@RequestBody Map<String, List<Integer>> data, HttpSession session) {
	    Map<String, Object> loginMember = (Map<String, Object>) session.getAttribute("loginMember");
	    if (loginMember == null) return "LOGIN_REQUIRED";

	    int memNo = Integer.parseInt(String.valueOf(loginMember.get("memNo")));
	    List<Integer> bmkNos = data.get("bmkNos");

	    if (bmkNos != null && !bmkNos.isEmpty()) {
	        bookMarkService.deleteBookmarks(memNo, bmkNos);
	        return "SUCCESS";
	    }
	    return "FAIL";
	}
	
    
}
