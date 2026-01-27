package kr.or.ddit.mohaeng.admin.review.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;

@Mapper
public interface IAReviewMapper {

	//조건에 맞는 리뷰의 총 개수. 페이징 처리 계산을 위해 사용
	int getReviewCount(ProdReviewVO searchVO);

	//조건에 맞는 리뷰 목록을 리스트 형태로 가져옴.
	List<ProdReviewVO> getReviewList(ProdReviewVO searchVO);

	//특정 상품의 평균 별점을 계산
	Double getAvgRating(ProdReviewVO searchVO);

	//해당 리뷰들이 받은 추천(좋아요) 총합
	int getTotalRecommendCount(ProdReviewVO searchVO);

	//해당 리뷰가 신고당한 횟수
	int getReportedCount(ProdReviewVO searchVO);

	//리뷰 번호(prodRvNo) 하나로 상세 내용
	ProdReviewVO getReviewDetail(int prodRvNo);

	//리뷰의 상태(공개/숨김 등)를 변경
	int updateReviewStatus(ProdReviewVO updateVO);

	//리뷰를 완전히 삭제하거나 논리 삭제
	int deleteReview(int prodRvNo);

}
