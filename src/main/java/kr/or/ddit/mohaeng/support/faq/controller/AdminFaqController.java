package kr.or.ddit.mohaeng.support.faq.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.support.faq.service.IFaqService;
import kr.or.ddit.mohaeng.vo.FaqVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/support/faq")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminFaqController {

	@Autowired
	private IFaqService faqService;

	 // 관리자 FAQ 목록 조회
	@GetMapping
	public ResponseEntity<List<FaqVO>> aFaqList(FaqVO searchVO){
		return ResponseEntity.ok(faqService.aFaqList(searchVO));
	}

	// FAQ 등록
	@PostMapping
	public ResponseEntity<Integer> insertAFaq(@RequestBody FaqVO faqVO){
		// SecurityContext에서 현재 로그인한 사용자 정보 가져오기
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

	    // regId에 memNo를 String으로 세팅
		faqVO.setRegId(String.valueOf(userDetails.getMember().getMemNo()));

		log.debug(" faq 인자값 :  {}", faqVO);
		return ResponseEntity.ok(faqService.insertAFaq(faqVO));
	}

	// FAQ 수정
	@PutMapping("/{faqNo}") //@PutMapping이란 기존 내용 수정시 사용. 요청을 여러번 보내도 데이터 늘어나지 않음.
	public ResponseEntity<Integer> updateAFaq(@PathVariable int faqNo, @RequestBody FaqVO faqVO){
		faqVO.setFaqNo(faqNo);
		return ResponseEntity.ok(faqService.updateAFaq(faqVO));
	}

	// 활성 / 비활성 변경
	@PatchMapping("/{faqNo}/use-yn") //@PatchMapping이란 지우개로 한 글자만 고치는 것~
	public ResponseEntity<Void> updateAFaqUseYn(@PathVariable int faqNo, @RequestParam String useYn){
		faqService.updateAFaqUseYn(faqNo,useYn);
		return ResponseEntity.ok().build();
	}

	// 순서 변경 (swap)
	@PatchMapping("/order")
	public ResponseEntity<Void> updateAFaqOrder(@RequestParam int currentFaqNo, @RequestParam int targetFaqNo){
		faqService.updateAFaqOrder(currentFaqNo, targetFaqNo);
		return ResponseEntity.ok().build();
	}

	// FAQ 삭제
	@DeleteMapping("/{faqNo}")
	public ResponseEntity<Integer> deleteAFaq(@PathVariable int faqNo){
		return ResponseEntity.ok(faqService.deleteAFaq(faqNo));
	}

	//관리자용 조회수 증가
	@PatchMapping("/{faqNo}/views")
	@ResponseBody
    public void incrementAdminViews(@PathVariable("faqNo") int faqNo) {
        log.info("관리자 페이지에서 FAQ {}번 조회수 증가 요청", faqNo);
        faqService.incrementViews(faqNo);
    }

}
