 package kr.or.ddit.mohaeng.support.notice.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.support.notice.service.INoticeService;
import kr.or.ddit.mohaeng.vo.BoardVO;
import kr.or.ddit.mohaeng.vo.NoticeFileVO;
import kr.or.ddit.mohaeng.vo.NoticeVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
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
     public List<NoticeVO> list(
    			@RequestParam(name = "page", required= false, defaultValue = "1") int currentPage
    			) {
    	 PaginationInfoVO<NoticeVO> pagingVO = new PaginationInfoVO<>();
    	 
    	 // 검색시 추가
    	 
    	 pagingVO.setCurrentPage(currentPage);
  		 int totalRecord = noticeService.selectNoticeCount(pagingVO);
  		 pagingVO.setTotalRecord(totalRecord);
    	 List<NoticeVO> list= noticeService.selectNoticeList(pagingVO);
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
    public ResponseEntity<byte[]> thumbnail(@PathVariable int fileNo) {
        NoticeFileVO f = noticeService.getFileInfo(fileNo);
        if (f == null) return ResponseEntity.notFound().build();

        // DB에 FILE_PATH가 "/notice/xxx.png" 형태면 그걸 그대로 쓰는게 제일 안전
        // (너 여행톡에서 filePath=/talk/uuid.png 로 들어오는 것처럼)
        String fullPath = uploadPath + f.getFilePath(); // ex) C:/mohaeng/upload + /notice/uuid.png

        try (InputStream in = new FileInputStream(fullPath)) {
            HttpHeaders headers = new HttpHeaders();

            // DB에 mimeType 컬럼이 있으면 그걸 쓰자
            String mime = f.getMimeType();
            if (StringUtils.isBlank(mime)) mime = "application/octet-stream";
            headers.setContentType(MediaType.parseMediaType(mime));

            return new ResponseEntity<>(IOUtils.toByteArray(in), headers, HttpStatus.OK);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }
}

