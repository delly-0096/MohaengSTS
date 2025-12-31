package kr.or.ddit.mohaeng.support.notice.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


import kr.or.ddit.mohaeng.support.notice.service.INoticeService;
import kr.or.ddit.mohaeng.vo.NoticeVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/support/notice")
@Slf4j
public class NoticeController {
	
	@Autowired
	private INoticeService noticeService;
	
	//공지사항 목록화면
	@GetMapping("")
	public String noticeForm(Model model) {
		List<NoticeVO> noticeList = noticeService.selectNoticeList();
		model.addAttribute("noticeList",noticeList);
		log.info("noticeForm()....  실행");
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
	
	
	
}
