 package kr.or.ddit.mohaeng.support.faq.service;

import java.util.List;

import kr.or.ddit.mohaeng.vo.FaqVO;

public interface IFaqService {


	/**
	 * FAQ목록 조회(사용중인 것만, USE_YN='1')
	 * @return FAQ목록
	 */
	List<FaqVO> getFaqList();


	/**
	 * faq 카테고리별 조회
	 * @param faqCategoryCd 카테고리 코드
	 * @return faq목록
	 */
	List<FaqVO> getFaqlistByCategory(String faqCategoryCd);


	/**
	 * faq 상세 조회
	 * @param faqNo faq 번호
	 * @return faq상세 정보
	 */
	FaqVO getFaqDetail(int faqNo);

	/**
	 * faq 검색
	 * @param keyword 검색 키워드
	 * @return faq목록
	 */
	List<FaqVO> searchFaq(String keyword);

}
