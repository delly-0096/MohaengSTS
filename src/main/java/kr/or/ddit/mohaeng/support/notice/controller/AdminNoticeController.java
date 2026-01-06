package kr.or.ddit.mohaeng.support.notice.controller;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.support.notice.service.INoticeService;
import kr.or.ddit.mohaeng.vo.NoticeVO;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@CrossOrigin(origins = {"http://localhost:7272"},
allowCredentials = "true")
@RequestMapping("/api/admin/notices")
public class AdminNoticeController {
     @Autowired	
	 private INoticeService noticeService;
	 
  //관리자 목록조회
     @GetMapping
     public List<NoticeVO> list() {
    	 List<NoticeVO> list= noticeService.selectNoticeList();
    	 log.info("list:"+ list);
    	 return list;
     }
     
  //관리자 등록 
     @PostMapping
    public  int insert(@RequestBody NoticeVO vo) {
    	 log.info("vo{}",  vo);      
    	vo.setRegId("9001");
    	return noticeService.insertNotice(vo);
    
    	
    }
    // 관리자 수정
    @PutMapping("/{ntcNo}")
    public int update(@PathVariable int ntcNo, @RequestBody NoticeVO vo) {
    	vo.setNtcNo(ntcNo);
    	log.info("체킁: {}",vo);
    	return noticeService.updateNotice(vo);
    	
    }
    
    //관리자 삭제
    @DeleteMapping("/{ntcNo}")
    public int delete(@PathVariable int ntcNo) {
    	return noticeService.deleteNotice(ntcNo);
    }     
}
