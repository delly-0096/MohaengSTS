package kr.or.ddit.mohaeng.support.faq.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.support.faq.mapper.IFaqMapper;
import kr.or.ddit.mohaeng.vo.FaqVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FaqServiceImpl implements IFaqService {

	@Autowired
	private IFaqMapper faqMapper;

	@Override
	public List<FaqVO> getFaqList() {
		log.info("FAQ목록 조회");
		return faqMapper.selectFaqList();
	}

	@Override
	public List<FaqVO> getFaqlistByCategory(String faqCategoryCd) {
		log.info("faq 카테고리별 조회:",faqCategoryCd);
		return faqMapper.selectFaqListByCategory(faqCategoryCd);
	}

	@Override
	public FaqVO getFaqDetail(int faqNo) {
		log.info("faq 상세 조회:",faqNo);
		return faqMapper.selectFaqDetail(faqNo);
	}

	@Override
	public List<FaqVO> searchFaq(String keyword) {
		log.info("faq 검색:",keyword);
		return faqMapper.searchFaq(keyword);
	}

}
