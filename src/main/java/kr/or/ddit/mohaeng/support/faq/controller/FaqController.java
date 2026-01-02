package kr.or.ddit.mohaeng.support.faq.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.support.faq.service.IFaqService;
import kr.or.ddit.mohaeng.vo.FaqVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/support/faq")
public class FaqController {

	@Autowired
	private IFaqService faqService;

	/**
	 * FAQ 목록 페이지
	 * @param model
	 * @return
	 */
	@GetMapping
	public String faqList(Model model) {
		log.info("FAQ 목록 페이지 요청");
		List<FaqVO> faqList = faqService.getFaqList();
		model.addAttribute("faqList", faqList);
		return "support/faq";
	}

	/**
	 * FAQ 카테고리별 조회 (AJAX)
	 * @param faqCategoryCd
	 * @return
	 */
	@GetMapping("/category/{faqCategoryCd}")
	@ResponseBody
	public List<FaqVO> getFaqByCategory(String faqCategoryCd){
		 log.info("FAQ 카테고리별 조회:", faqCategoryCd);
		 return faqService.getFaqlistByCategory(faqCategoryCd);
	}


	/**
	 * FAQ 상세 조회 (AJAX)
	 * @param faqNo
	 * @return
	 */
	@GetMapping("/{faqNo}")
	@ResponseBody
	public FaqVO getFaqDetail(int faqNo) {
		log.info("FAQ 상세 조회:",faqNo);
		return faqService.getFaqDetail(faqNo);
	}

	/**
	 * FAQ 검색 (AJAX)
	 * @param keyword
	 * @return
	 */
	@GetMapping("/search")
	@ResponseBody
	public List<FaqVO> searchFaq(String keyword){
		log.info("FAQ 검색:",keyword);
		return faqService.searchFaq(keyword);
	}

}
