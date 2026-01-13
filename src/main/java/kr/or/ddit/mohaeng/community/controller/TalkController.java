package kr.or.ddit.mohaeng.community.controller;

import java.io.FileInputStream;
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
import org.springframework.security.core.annotation.AuthenticationPrincipal;
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
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.community.service.ITalkService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.BoardFileVO;
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
    
    @Value("${file.upload-path}")
    String uploadPath;

	private Integer boardNo;
    
    @RequestMapping
    public String communityForm(
    		@RequestParam(name = "page", required= false, defaultValue = "1") int currentPage,
  			@RequestParam(required = false) String searchWord,
   			@RequestParam(required = false, defaultValue = "all") String ntcType,
   			Model model) {
      log.info("communityForm()...실행");
      PaginationInfoVO<BoardVO> pagingVO = new PaginationInfoVO<>();
      
      // 검색시 추가
      if(StringUtils.isNoneBlank(searchWord)) {
    	  pagingVO.setSearchWord(searchWord);
    	  pagingVO.setSearchType(ntcType);
    	  model.addAttribute("searchWord", searchWord);
    	  model.addAttribute("ntcType", ntcType);
      }
      
      pagingVO.setCurrentPage(currentPage);
      int totalRecord = talkService.selectTalkCount(pagingVO);
      pagingVO.setTotalRecord(totalRecord);
      //게시판 목록
      List<BoardVO> dataList = talkService.selectTalkList(pagingVO);
      pagingVO.setDataList(dataList);
      
      model.addAttribute("pagingVO", pagingVO); 
      return "community/talk";
    }
 
    
	// 게시판 상세화면
    public String talkDetail(@RequestParam int boardNo,Model model) {
    	log.info("talkDetail");
    	//상세화면
    	BoardVO boardVO = talkService.selectBoard(boardNo);
    	model.addAttribute("boardVO",boardVO);
    	return "community/talk";
    }
    
    // talk상세조회
    @GetMapping("/detail")
    public String detail(@RequestParam int boardNo) {
    	BoardVO boardVO = talkService.selectTalk(boardNo);
    	return "community/talk";
    }
    
    // 글 작성폼 페이지 이동
    @GetMapping("/write")
    public String talkWrite() {
    	return "community/talk-write";
    }
    
    //talk 등록
    @ResponseBody
    @PostMapping("/insert")
    public ResponseEntity<String> insert(
    		@RequestBody BoardVO vo,
    		@AuthenticationPrincipal CustomUserDetails user
    		) {
        log.info("insert 실행: {}", vo);
        
        vo.setWriterNo(user.getMemNo());
        ServiceResult result = talkService.insertTalk(vo);
        if (result == ServiceResult.OK) {
        	return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
        }else {
        	return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
        }
    }

    	
    	
 
    // talk 수정
    @PutMapping("/{boardNo}")
    public int update(@PathVariable int boarNo, @RequestBody BoardVO vo) {
    	vo.setBoardNo(boardNo);
    	int cnt = talkService.updateTalk(vo);
    	log.info("check:{}",vo);
    	return talkService.updateTalk(vo);
    }
    //talk 삭제
    @DeleteMapping("/{boardNo}")
    public int delete(@PathVariable int boardNo) {
     return talkService.deleteTalk(boardNo);
    
}
    @GetMapping("/thumbnail/{fileNo}")
    public ResponseEntity<byte[]> display(@PathVariable int fileNo){
    	InputStream in = null;
    	ResponseEntity<byte[]> entity = null;
    	
    	BoardFileVO boardFileVO = talkService.getFileInfo(fileNo);
    	
    	try {
			//파일 확장자에 알맞는 mediaType가져오기
    		MediaType mType = MediaType.IMAGE_JPEG;
    		HttpHeaders headers = new HttpHeaders();
    		
    		in = new FileInputStream(uploadPath + "talk/" + boardFileVO.getFileName());
    		headers.setContentType(mType);
    		entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in),headers,HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}finally {
			try {
				in.close();
			} catch (Exception e) {
			   e.printStackTrace();
			}
		}
    	return entity;		
    }
    
}  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  