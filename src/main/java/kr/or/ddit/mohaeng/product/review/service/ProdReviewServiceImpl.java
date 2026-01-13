package kr.or.ddit.mohaeng.product.review.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.product.review.mapper.IProdReviewMapper;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;

@Service
public class ProdReviewServiceImpl implements IProdReviewService {

	@Autowired
    private IProdReviewMapper mapper;

	@Override
	public List<ProdReviewVO> getReviewPaging(int tripProdNo, int page, int pageSize) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("tripProdNo", tripProdNo);
	    params.put("startRow", (page - 1) * pageSize);
	    params.put("endRow", page * pageSize);
	    return mapper.getReviewPaging(params);
	}

	@Override
	public ProdReviewVO getStat(int tripProdNo) {
		return mapper.getStat(tripProdNo);
	}

	@Override
	public int updateReview(ProdReviewVO vo) {
		return mapper.updateReview(vo);
	}

	@Override
	public int deleteReview(int prodRvNo, int memNo) {
		return mapper.deleteReview(prodRvNo, memNo);
	}

	@Override
	public Integer getReviewAttachNo(int prodRvNo) {
		return mapper.getReviewAttachNo(prodRvNo);
	}

	@Override
	public int updateReviewAttachNo(int prodRvNo, int attachNo) {
		return mapper.updateReviewAttachNo(prodRvNo, attachNo);
	}

}
