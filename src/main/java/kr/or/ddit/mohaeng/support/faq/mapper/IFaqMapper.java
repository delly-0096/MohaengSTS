package kr.or.ddit.mohaeng.support.faq.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.FaqVO;

@Mapper
public interface IFaqMapper {



    /* =====================
     * 사용자용 FAQ
     * ===================== */

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

	// FAQ 조회수 증가
	public int incrementViews(int faqNo);



    /* =====================
     * 관리자용 FAQ
     * ===================== */

	//관리자 FAQ 목록 조회 (전체 + 조건 검색)
	public List<FaqVO> aFaqList(FaqVO searchVO);

	//관리자 FAQ 등록
	public int insertAFaq(FaqVO faqVO);

	//관리자 FAQ 수정
	public int updateAFaq(FaqVO faqVO);

	//관리자 FAQ 삭제
	public int deleteAFaq(int faqNo);


    /* =====================
     * 관리자용 FAQ (기능성 - 순서 및 상태)
     * ===================== */
	public int updateAFaqUseYn(@Param("faqNo")int faqNo, @Param("useYn") String useYn);

	public void updateAFaqOrder(FaqVO faqVO);



}
