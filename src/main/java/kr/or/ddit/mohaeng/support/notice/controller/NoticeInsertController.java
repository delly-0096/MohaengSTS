

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.mohaeng.support.notice.service.INoticeService;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/support/notice")
@Slf4j
public class NoticeInsertController {

	@Autowired
	private INoticeService noticeService;
	
	//공지사항 목록화면 
	@GetMapping("/notice.do")
	public String noticeForm() {
		
		return "support/notice";
		
	}
	
	
	
	public String noticeInsert(NoticeVO noticeVo,)
}
