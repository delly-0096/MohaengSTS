package kr.or.ddit.mohaeng.mypage.bookmarks.controller;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.mypage.bookmarks.service.IBookMarkService;
import kr.or.ddit.mohaeng.vo.BookmarkVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/mypage/bookmarks")
public class MyBookmarksController {

	@Autowired
	private IBookMarkService bookMarkService;
	
    /**
     * 북마크 페이지
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String bookmarks(
    		@RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
    		@RequestParam(required = false, defaultValue = "all") String contentType,
    		HttpSession session,
    		Model model) {
		
		Map<String, Object> loginMember = (Map<String, Object>) session.getAttribute("loginMember");

		// 3. Map에서 memNo 꺼내기 (Integer 또는 Long일 수 있으므로 안전하게 처리)
		int memNo = Integer.parseInt(String.valueOf(loginMember.get("memNo")));

	    // 3. 통계 데이터 조회
	    // (Mapper 인터페이스의 파라미터 타입도 int로 맞추는 것이 좋습니다)
	    Map<String, Object> stats = bookMarkService.selectBookmarkStats(memNo);
	    model.addAttribute("stats", stats);
	    
    	PaginationInfoVO<BookmarkVO> pagingVO = new PaginationInfoVO<>(9,5);
    	
    	if(StringUtils.isNotBlank(contentType)) {
			pagingVO.setSearchType(contentType);
		}
    	model.addAttribute("contentType", contentType);
    	
    	pagingVO.setCurrentPage(currentPage);
    	int totalRecord = bookMarkService.selectBookMarkCount(pagingVO);
    	pagingVO.setTotalRecord(totalRecord);
    	List<BookmarkVO> dataList = bookMarkService.selectBookMarkList(pagingVO);

    	log.debug("체킁: {}",dataList); // 이게 결과가 있어야 함!
    	pagingVO.setDataList(dataList);
    	
//    	List<BookmarkVO> bookMarkList = bookMarkService.selectBookMarkList();
//    	model.addAttribute("bookMarkList", bookMarkList);
    	
    	model.addAttribute("pagingVO", pagingVO);
        return "mypage/bookmarks";
    }
    
}
