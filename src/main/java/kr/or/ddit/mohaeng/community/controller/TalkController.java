package kr.or.ddit.mohaeng.community.controller;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.mohaeng.community.service.ITalkService;
import kr.or.ddit.mohaeng.vo.BoardVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/community/talk")
public class TalkController {
	
    @Autowired
	private ITalkService talkService;
    
    //여행톡 목록화면
    
    @RequestMapping
    public String communityForm(
    		@RequestParam(name = "page", required= false, defaultValue = "1") int currentPage,
  			@RequestParam(required = false) String searchWord,
   			@RequestParam(required = false, defaultValue = "all") String ntcType,
   			Model model) {
      log.info("noticeForm()...실행");
      PaginationInfoVO<BoardVO> pagingVO = new PaginationInfoVO<>();
      
      // 검색시 추가
      if(StringUtils.isNoneBlank(searchWord)) {
    	  pagingVO.setSearchWord(searchWord);
    	  model.addAttribute("searchWord", searchWord);
    	  
      }
      
      pagingVO.setCurrentPage(currentPage);
      int totalRecord = ITalkService.selectBoardCount(pagingVO);
      pagingVO.setTotalRecord(totalRecord);
      List<BoardVO> dataList = ITalkService.selectNoticeList(pagingVO);
      return "community/talk";
    }
	
}
  