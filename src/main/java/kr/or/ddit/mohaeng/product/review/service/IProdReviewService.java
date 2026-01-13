package kr.or.ddit.mohaeng.product.review.service;

import java.util.List;

import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;

public interface IProdReviewService {
	public List<ProdReviewVO> getReviewPaging(int tripProdNo, int page, int pageSize);
	public ProdReviewVO getStat(int tripProdNo);
	public int updateReview(ProdReviewVO vo);
	public int deleteReview(int prodRvNo, int memNo);
	public Integer getReviewAttachNo(int prodRvNo);
	public int updateReviewAttachNo(int prodRvNo, int attachNo);
}
