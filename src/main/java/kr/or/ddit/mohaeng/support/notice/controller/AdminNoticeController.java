package kr.or.ddit.mohaeng.support.notice.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.support.notice.service.INoticeService;
import kr.or.ddit.mohaeng.vo.NoticeFileVO;
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
	 

     @Value("${file.upload-path}")
     String uploadPath;
     
  //관리자 목록조회
     @GetMapping
     public List<NoticeVO> list() {
    	 List<NoticeVO> list= noticeService.selectNoticeList();
    	 log.info("list:"+ list);
    	 return list;
     }
     
     //관리자 상세조회
     @GetMapping("/{ntcNo}")
     public NoticeVO detail(@PathVariable int ntcNo) {
    	 NoticeVO noticeVO = noticeService.selectNotice(ntcNo);
    	 return noticeVO;
     }
     
  //관리자 등록 
    @PostMapping
    public  int insert(NoticeVO vo) throws Exception {
    	 log.info("insert문 실행 vo{}",  vo);      
    	vo.setRegId("9001");
    	ServiceResult result = noticeService.insertNotice(vo);
    	int status = 0;
    	if(result == ServiceResult.OK) {
    		status = 1;
    	}else{
    		status = -1;
    	}
    	return status;
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
    

	@GetMapping("/thumbnail/{fileNo}")
	public ResponseEntity<byte[]> display(@PathVariable int fileNo){
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;
		
		// itemId에 해당하는 이미지 파일명을 얻어온다.
		NoticeFileVO noticeFileVO = noticeService.getFileInfo(fileNo);
		
		try {
			// 파일 확장자에 알맞는 MediaType 가져오기
			MediaType mType = MediaType.IMAGE_JPEG;
			HttpHeaders headers = new HttpHeaders();
			
			in = new FileInputStream(uploadPath + "notice/" + noticeFileVO.getFileName());
			headers.setContentType(mType);
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		}catch(Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}finally {
			try {
				in.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return entity;
	}
}
