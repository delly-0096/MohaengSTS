
 package kr.or.ddit.mohaeng.support.faq.service;




import java.util.List;

import kr.or.ddit.mohaeng.vo.FaqVO;

public interface IFaqService {

	/* =====================
     * 사용자용 FAQ
     * ===================== */


	/**
	 * FAQ목록 조회(사용중인 것만, USE_YN='Y')
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


	/* =====================
     * 관리자용 FAQ
     * ===================== */

	List<FaqVO> aFaqList(FaqVO searchVO);


	int insertAFaq(FaqVO faqVO);


	int updateAFaq(FaqVO faqVO);

    //성공/실패 여부가 매우 중요할 때: int를 반환해서 컨트롤러가 "성공했습니다" 혹은 "대상을 찾을 수 없습니다"라고 판단하게 하기위해.
	int updateAFaqUseYn(int faqNo, String useYn);

    //서비스 내부 로직이 복잡할 때: void로 선언하고, 문제가 생기면 CustomException을 던져서 처리.
	//순서 변경(swap)은 보통 서비스 안에서 두 번의 업데이트가 일어나.
	//그래서 서비스 안에서 @Transactional 걸고 완벽하게 처리할 테니까, 일단 결과 신경 쓰지 마!' 할 때 void를 쓰는 거임.
	void updateAFaqOrder(int currentFaqNo, int targetFaqNo);

	int  deleteAFaq(int faqNo);

	void incrementViews(int faqNo);









}
