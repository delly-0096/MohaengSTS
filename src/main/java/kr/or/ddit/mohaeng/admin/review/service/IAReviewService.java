package kr.or.ddit.mohaeng.admin.review.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;

public interface IAReviewService {

	//리뷰 전체 개수 조회(검색, 필터 적용)
	int getReviewCount(ProdReviewVO searchVO);

	//리뷰 목록 조회(검색, 필터, 페이징)
	List<ProdReviewVO> getReviewList(ProdReviewVO searchVO);

	//리뷰 통계 조회
	//: 항목별 점수판 만들기(전체 리뷰 수, 평균 평점, 추천 리뷰 수(rcmdtnYn = 'Y'), 신고된 리뷰 수(reviewStatus = 'REPORTED'))
	Map<String, Object> getReviewStatistics(ProdReviewVO searchVO);

	//평점별 리뷰 목록 조회(기간별)
	Map<String, Object> getRatingCounts(ProdReviewVO searchVO);

	//리뷰 상세 조회
	ProdReviewVO getReviewDetail(int prodRvNo);

	//리뷰 상태 변경 (게시 ↔ 숨김) 성공/실패
	int updateReviewStatus(int prodRvNo, String reviewStatus);

	//리뷰 삭제 삭제 (실제 DELETE) 성공/실패
	int deleteReview(int prodRvNo);

}
