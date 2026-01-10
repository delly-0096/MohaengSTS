package kr.or.ddit.mohaeng.support.faq.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.support.faq.mapper.IFaqMapper;
import kr.or.ddit.mohaeng.vo.FaqVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FaqServiceImpl implements IFaqService {

	@Autowired
	private IFaqMapper faqMapper;

	/* =====================
     * 사용자용 FAQ
     * ===================== */

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

	@Transactional
	@Override
	public FaqVO getFaqDetail(int faqNo) {
		log.info("faq 상세 조회 번호: {}", faqNo);
		return faqMapper.selectFaqDetail(faqNo);
	}

	@Override
	public List<FaqVO> searchFaq(String keyword) {
		log.info("faq 검색:",keyword);
		return faqMapper.searchFaq(keyword);
	}


    /* =====================
     * 관리자용 FAQ
     * ===================== */

	@Override
	public List<FaqVO> aFaqList(FaqVO searchVO) {
		return faqMapper.aFaqList(searchVO);
	}

	@Override
	public int insertAFaq(FaqVO faqVO) {
		return faqMapper.insertAFaq(faqVO);
	}

	@Override
	public int updateAFaq(FaqVO faqVO) {
		return faqMapper.updateAFaq(faqVO);
	}

	@Override
	public int updateAFaqUseYn(int faqNo, String useYn) {
		return faqMapper.updateAFaqUseYn(faqNo, useYn);
	}

	//faq순서 변경(swap)
	@Override
	@Transactional
	public void updateAFaqOrder(int currentFaqNo, int targetFaqNo) {
		FaqVO current = faqMapper.selectFaqDetail(currentFaqNo);
		FaqVO target = faqMapper.selectFaqDetail(targetFaqNo);

		if (current !=null && target !=null) {
			int temp = current.getFaqOrder();
			current.setFaqOrder(target.getFaqOrder());
			target.setFaqOrder(temp);

			faqMapper.updateAFaqOrder(current);
			faqMapper.updateAFaqOrder(target);
		}

	}

	@Override
	public int deleteAFaq(int faqNo) {
		return faqMapper.deleteAFaq(faqNo);
	}

	@Override
	public void incrementViews(int faqNo) {
		// 상세조회 시 조회수 증가 포함
		// 단순히 매퍼를 호출하여 DB 값을 1 올립니다.
		faqMapper.incrementViews(faqNo);
	}






}
