package kr.or.ddit.mohaeng.community.controller;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Arrays;
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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.community.service.CommentService;
import kr.or.ddit.mohaeng.community.service.ITalkService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.BoardFileVO;
import kr.or.ddit.mohaeng.vo.BoardVO;
import kr.or.ddit.mohaeng.vo.CommentVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/community/talk")
public class TalkController {

	@Autowired
	private ITalkService talkService;

	// 여행톡 목록화면

	@Value("${file.upload-path}")
	String uploadPath;

	@Autowired
	private CommentService commentService;

	@RequestMapping
	public String communityForm(@RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false) Integer boardNo, @RequestParam(required = false) String searchWord,
			@RequestParam(required = false, defaultValue = "all") String ntcType, Model model) {
		log.info("communityForm()...실행");
		PaginationInfoVO<BoardVO> pagingVO = new PaginationInfoVO<>();

		// 검색시 추가
		if (StringUtils.isNoneBlank(searchWord)) {
			pagingVO.setSearchWord(searchWord);
			pagingVO.setSearchType(ntcType);
			model.addAttribute("searchWord", searchWord);
			model.addAttribute("ntcType", ntcType);
		}

		pagingVO.setCurrentPage(currentPage);
		int totalRecord = talkService.selectTalkCount(pagingVO);
		pagingVO.setTotalRecord(totalRecord);
		// 게시판 목록
		List<BoardVO> dataList = talkService.selectTalkList(pagingVO);
		pagingVO.setDataList(dataList);

		model.addAttribute("pagingVO", pagingVO);
		if (boardNo != null) {
			BoardVO boardVO = talkService.selectTalk(boardNo);
			model.addAttribute("boardVO", boardVO);
		}
		return "community/talkList";
	}

	// 게시판 상세화면
	
	  @GetMapping("/detail") public String talkDetail(@RequestParam int
	  boardNo,Model model) { //talkDetail boardNo : 11
	  log.info("talkDetail boardNo : {}", boardNo); //상세화면
	  
	  BoardVO boardVO = talkService.selectBoard(boardNo);
	  
	  log.info("talkDetail boardVO : {}", boardVO); //상세화면
	  
	  model.addAttribute("boardVO",boardVO); List<CommentVO> comments =
	  commentService.getTalkComments(boardNo); model.addAttribute("comments",
	  comments);
	  
	  return "community/talk"; }
	 
	/*
	 * @GetMapping("/detail") public String talkDetail(@RequestParam int boardNo,
	 * Model model) {
	 * 
	 * BoardVO boardVO = talkService.selectTalk(boardNo); // 너희 상세 조회 로직
	 * model.addAttribute("boardVO", boardVO);
	 * 
	 * // ✅ 댓글 목록 조회 List<CommentVO> commentList =
	 * commentService.getTalkComments(boardNo); model.addAttribute("commentList",
	 * commentList);
	 * 
	 * return "community/comment"; // 너희 JSP 경로 }
	 */

	// 글 작성폼 페이지 이동
	@GetMapping("/write")
	public String talkWrite() {
		return "community/talk-write";
	}

	// talk 등록
	@ResponseBody
	@PostMapping("/insert")
	public ResponseEntity<String> insert(BoardVO vo, @AuthenticationPrincipal CustomUserDetails user) {

		log.info("insert 실행: {}", vo);

		if (user == null) {
			System.out.println("여기에 왔음11111");
			log.error("로그인 정보가 없습니다!");
			return new ResponseEntity<>("LOGIN_REQUIRED", HttpStatus.UNAUTHORIZED);
		}
		System.out.println("여기에 왔음22222");
		log.info("로그인 회원번호: {}", user.getMemNo());
		vo.setWriterNo(user.getMemNo());
		vo.setRegId(user.getMemNo());

		ServiceResult result = talkService.insertTalk(vo);
		if (result == ServiceResult.OK) {

			return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
		} else {
			return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		}
	}

	// talk 수정
	// talk 수정
	@PutMapping("/{boardNo}")
	@ResponseBody
	public int update(@PathVariable int boardNo, @RequestBody BoardVO vo) {
		vo.setBoardNo(boardNo); // ✅ URL의 boardNo를 vo에 세팅
		int cnt = talkService.updateTalk(vo); // ✅ 1번만 호출
		log.info("update: {}", vo);
		return cnt;
	}

	@GetMapping("/download/{fileNo}")
	public ResponseEntity<byte[]> download(@PathVariable int fileNo) {
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;

		BoardFileVO boardFileVO = talkService.getFileInfo(fileNo);

		try {
			HttpHeaders headers = new HttpHeaders();

			// 다운로드는 보통 octet-stream으로 주는게 무난
			headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);

			// ✅ 다운로드는 attachment
			headers.add("Content-Disposition", "attachment; filename=\"" + boardFileVO.getFileOriginalName() + "\"");

			in = new FileInputStream(uploadPath + "talk/" + boardFileVO.getFileName());
			entity = new ResponseEntity<>(IOUtils.toByteArray(in), headers, HttpStatus.OK);

		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		} finally {
			try {
				if (in != null)
					in.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return entity;
	}

	@GetMapping("/preview/{fileNo}")
	public ResponseEntity<byte[]> preview(@PathVariable int fileNo) {
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;

		BoardFileVO boardFileVO = talkService.getFileInfo(fileNo);

		try {
			HttpHeaders headers = new HttpHeaders();

			// ✅ mimeType이 DB에 있으면 그걸로 Content-Type 지정 (추천)
			MediaType mType = MediaType.IMAGE_JPEG;
			if (boardFileVO.getMimeType() != null && !boardFileVO.getMimeType().isBlank()) {
				mType = MediaType.parseMediaType(boardFileVO.getMimeType());
			}
			headers.setContentType(mType);

			// ✅ 미리보기는 inline
			headers.add("Content-Disposition", "inline; filename=\"" + boardFileVO.getFileOriginalName() + "\"");

			in = new FileInputStream(uploadPath + "talk/" + boardFileVO.getFileName());
			entity = new ResponseEntity<>(IOUtils.toByteArray(in), headers, HttpStatus.OK);

		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		} finally {
			try {
				if (in != null)
					in.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return entity;
	}

}
