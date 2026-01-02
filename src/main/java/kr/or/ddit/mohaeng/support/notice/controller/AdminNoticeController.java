package kr.or.ddit.mohaeng.support.notice.controller;

import java.util.List;

import org.eclipse.tags.shaded.org.apache.bcel.generic.RETURN;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
@RequestMapping("/api/admin/notices")
public class AdminNoticeController {
     @Autowired	
	 private INoticeService noticeService;
	 
  //관리자 목록조회
     @GetMapping
     public List<NoticeVO> list() {
    	 return noticeService.selectNoticeList();
     }
     
  //관리자 등록 
    public  int insert(@RequestBody NoticeVO vo) {
    	vo.setRegId("admin");
    	return noticeService.insertNotice(vo);
    
    	
    }
    // 관리자 수정
    @PutMapping("/{ntcNo}")
    public int update(@PathVariable int ntcNo, @RequestBody NoticeVO vo) {
    	vo.setNtcNo(ntcNo);
    	return noticeService.updateNotice(vo);
    	
    }
    
    //관리자 삭제
    @DeleteMapping("/{ntcNo}")
    public int delete(@PathVariable int ntcNo) {
    	return noticeService.deleteNotice(ntcNo);
    }     
}
