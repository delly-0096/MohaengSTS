package kr.or.ddit.mohaeng.admin.review.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.admin.review.mapper.IAReviewMapper;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AReviewServiceImpl implements IAReviewService{

	@Autowired
	private IAReviewMapper reviewMapper;

	// application.properties에서 logging.level.kr.or.ddit=debug로 바꾸면 log.debug가 보임


	@Override
	public int getReviewCount(ProdReviewVO searchVO) {
		log.debug("리뷰 개수 조회-searchVO:{}", searchVO);// logging.level.kr.or.ddit=debug로 바꾸면 보임
		return reviewMapper.getReviewCount(searchVO);
	}

	@Override
	public List<ProdReviewVO> getReviewList(ProdReviewVO searchVO) {
		log.debug("리뷰 목록 조회-searchVO:{}", searchVO);
		return reviewMapper.getReviewList(searchVO);
	}

	//통계치 종합 세트( 관리자 페이지 상단 )
	@Override
	public Map<String, Object> getReviewStatistics(ProdReviewVO searchVO) {
		log.debug("리뷰 통계 조회-searchVO:{}", searchVO);

		Map<String, Object> statistics = new HashMap<>();

		//전체 리뷰 수
		int totalCount = reviewMapper.getReviewCount(searchVO);
		statistics.put("totalCount", totalCount);

		//평균 평점
		Double avgRating = reviewMapper.getAvgRating(searchVO);
		statistics.put("avgRating", avgRating != null ? avgRating : 0.0);

		//추천 리뷰 수(rcmdtnYn = 'Y')
		int totalRecommendCount = reviewMapper.getTotalRecommendCount(searchVO);
		statistics.put("totalRecommendCount", totalRecommendCount);

		//신고된 리뷰 수(reviewStatus = 'REPORTED')
		int reportedCount = reviewMapper.getReportedCount(searchVO);
		statistics.put("reportedCount", reportedCount);

		log.debug("통계 결과:{}", statistics);
		return statistics;
	}

	@Override
	public Map<String, Object> getRatingCounts(ProdReviewVO searchVO) {
		log.debug("평점별 리뷰 개수 조회-searchVO:{}", searchVO);

		Map<String, Object> ratingCounts = new HashMap<>();

		//전체 리뷰 수
		int totalCount = reviewMapper.getReviewCount(searchVO);
		ratingCounts.put("all", totalCount);

		//평점별 개수 세기(1점~5점)
		for (int rating = 1; rating <= 5; rating++) {
			//복사본 만들기
			ProdReviewVO ratingVO = new ProdReviewVO();
			ratingVO.setStartDate(searchVO.getStartDate());
			ratingVO.setEndDate(searchVO.getEndDate());
			ratingVO.setRatingFilter(rating); //복사본에 별점이 'n'것만 세어서 담아라고 함

			int count = reviewMapper.getReviewCount(ratingVO);
			ratingCounts.put("rating"+rating, count);
		}
		log.debug("평점별 개수:{}", ratingCounts);
		return ratingCounts;
	}

	@Override
	public ProdReviewVO getReviewDetail(int prodRvNo) {
		log.debug("리뷰 상세 조회-prodRvNo:{}", prodRvNo);
		return reviewMapper.getReviewDetail(prodRvNo);
	}

	@Override
	@Transactional
	public int updateReviewStatus(int prodRvNo, String reviewStatus) {
		log.debug("리뷰 상태 변경 - prodRvNo:{}, reviewStatus:{}", prodRvNo, reviewStatus);

		ProdReviewVO updateVO = new ProdReviewVO();
		updateVO.setProdRvNo(prodRvNo);
		updateVO.setReviewStatus(reviewStatus);

		int result = reviewMapper.updateReviewStatus(updateVO);

		log.debug("상태 변경 결과:{}",result);
		return result;
	}

	@Override
	@Transactional
	public int deleteReview(int prodRvNo) {
		log.debug("리뷰 삭제 - prodRvNo:{}", prodRvNo);

		int result = reviewMapper.deleteReview(prodRvNo);
		log.debug("삭제 결과:{}", result);
		return result;
	}

}
