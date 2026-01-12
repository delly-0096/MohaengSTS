package kr.or.ddit.mohaeng.admin.inquiry.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.admin.inquiry.service.IAQnaService;
import kr.or.ddit.mohaeng.vo.InquiryVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/inquiry")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminQnaController {

	@Autowired
	private IAQnaService qnaService;


    /**
     * 관리자용 1:1 문의 목록 조회(검색/필터/페이징)
     */
	@GetMapping
	public ResponseEntity<PaginationInfoVO<InquiryVO>> aInquiryList(
			PaginationInfoVO<InquiryVO> pagingVO, InquiryVO inquiryVO){

		log.info("페이징 정보: {}", pagingVO);
		log.info("검색/필터 정보: {}", inquiryVO);

		// 서비스로 두 객체를 전달하여 페이징 처리가 완료된 pagingVO를 받는다
		PaginationInfoVO<InquiryVO> result = qnaService.aInquiryList(pagingVO,inquiryVO);

		return ResponseEntity.ok(result);
	}
	/**
	 * 관리자용 1:1 문의 상세 조회
	 */
	@GetMapping("/{inqryNo}")
	public ResponseEntity<?> aInquiryDetail(@PathVariable int inqryNo){
		// 문의 내용 + 첨부파일 목록을 한 번에 반환
		return ResponseEntity.ok(qnaService.aInquiryDetail(inqryNo));
	}

    /**
     * 관리자 답변 등록 + 알람 생성
     */
	@PutMapping("/reply")
	public ResponseEntity<?> aInquiryReply(@RequestBody InquiryVO inquiryVO){
		// 답변 저장 후 사용자에게 알림 발송 로직 포함
		int result = qnaService.aInquiryReply(inquiryVO);
		return result > 0 ? ResponseEntity.ok("답변이 등록되었습니다"):ResponseEntity.status(500).body("답변 등록이 실패했습니다");
	}
    /**
     * 관리자 문의 삭제(논리 삭제) + 알람 생성
     */
	@DeleteMapping("/{inqryNo}")
	public ResponseEntity<?> aInquiryDelete(
			@PathVariable int inqryNo,@RequestParam String alarmCont){
		// 삭제 처리 후 사용자에게 알림 발송 로직 포함
		int result = qnaService.aInquiryDelete(inqryNo,alarmCont);
		return result > 0 ? ResponseEntity.ok("문의가 삭제되었습니다"): ResponseEntity.status(500).body("삭제 처리가 실패했습니다.");
	}

}
