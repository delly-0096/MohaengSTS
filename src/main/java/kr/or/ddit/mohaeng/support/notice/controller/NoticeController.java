package kr.or.ddit.mohaeng.support.notice.controller;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


import kr.or.ddit.mohaeng.support.notice.service.INoticeService;
import kr.or.ddit.mohaeng.vo.NoticeVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/support/notice")
@Slf4j
public class NoticeController {
	
	@Autowired
	private INoticeService noticeService;
	
	//공지사항 목록화면
	@RequestMapping
	public String noticeForm(
			@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false) String searchWord,
			@RequestParam(required = false, defaultValue = "all") String ntcType,
			Model model) {
		log.info("noticeForm()....  실행"); 
//		List<NoticeVO> noticeList = noticeService.selectNoticeList();
//		model.addAttribute("noticeList",noticeList);
//		log.info("noticeForm() 실행, size={}", noticeList.size());

		PaginationInfoVO<NoticeVO> pagingVO = new PaginationInfoVO<>();
		
		// 검색 시 추가
		if(StringUtils.isNotBlank(searchWord)) {
			pagingVO.setSearchWord(searchWord);
			model.addAttribute("searchWord", searchWord);
		}
		if(StringUtils.isNotBlank(ntcType)) {
			pagingVO.setSearchType(ntcType);
			model.addAttribute("ntcType", ntcType);
		}
		
		pagingVO.setCurrentPage(currentPage);
		int totalRecord = noticeService.selectNoticeCount(pagingVO);
		pagingVO.setTotalRecord(totalRecord);
		List<NoticeVO> dataList = noticeService.selectNoticeList(pagingVO);
		pagingVO.setDataList(dataList);
		
		model.addAttribute("pagingVO", pagingVO);
		return "support/notice";
	}
    
	//게시판 상세화면  
	@GetMapping("/detail")
	public String noticeDetail(@RequestParam int ntcNo, Model model) {
		log.info("noticeDetail");
		NoticeVO noticeVO = noticeService.selectNotice(ntcNo) ;
		model.addAttribute("notice",noticeVO);
		return "support/notice-detail";
	} 
	
	//관리자페이지 공지사항 파일 가져오기
	

	
	
}
