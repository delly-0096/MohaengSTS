package kr.or.ddit.mohaeng.admin.review.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;

@Mapper
public interface IAReviewMapper {

	int getReviewCount(ProdReviewVO searchVO);

	List<ProdReviewVO> getReviewList(ProdReviewVO searchVO);

	Double getAvgRating(ProdReviewVO searchVO);

	int getTotalRecommendCount(ProdReviewVO searchVO);

	int getReportedCount(ProdReviewVO searchVO);

	ProdReviewVO getReviewDetail(int prodRvNo);

	int updateReviewStatus(ProdReviewVO updateVO);

	int deleteReview(int prodRvNo);

}
