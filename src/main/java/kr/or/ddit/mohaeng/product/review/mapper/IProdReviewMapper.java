package kr.or.ddit.mohaeng.product.review.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;

@Mapper
public interface IProdReviewMapper {
	public List<ProdReviewVO> getReviewPaging(Map<String, Object> params);
	public ProdReviewVO getStat(int tripProdNo);
}
