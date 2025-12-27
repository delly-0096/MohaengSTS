package kr.or.ddit.mohaeng.support.faq.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.FaqVO;

@Mapper
public interface IFaqMapper {


	/**
	 * FAQ 목록 조회 (USE_YN='1'인 것만)
	 * @return  FAQ 목록
	 */
	public List<FaqVO> selectFaqList();

	/**
	 * FAQ 카테고리별 조회
	 * @param faqCategoryCd 카테고리 코드
	 * @return FAQ 목록
	 */
	public List<FaqVO> selectFaqListByCategory(String faqCategoryCd);


	/**
	 * FAQ 상세 조회
	 * @param faqNo FAQ 번호
	 * @return FAQ 상세
	 */
	public FaqVO selectFaqDetail(int faqNo);

	/**
	 * FAQ 검색
	 * @param keyword 검색 키워드
	 * @return FAQ 목록
	 */
	public List<FaqVO> searchFaq(String keyword);

}
