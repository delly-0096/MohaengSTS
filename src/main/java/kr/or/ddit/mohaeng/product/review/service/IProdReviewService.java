package kr.or.ddit.mohaeng.product.review.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;

public interface IProdReviewService {
	public List<ProdReviewVO> getReviewPaging(int tripProdNo, int page, int pageSize);
	public ProdReviewVO getStat(int tripProdNo);
}
