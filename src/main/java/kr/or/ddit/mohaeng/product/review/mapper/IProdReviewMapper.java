package kr.or.ddit.mohaeng.product.review.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;

@Mapper
public interface IProdReviewMapper {
	public List<ProdReviewVO> getReviewPaging(Map<String, Object> params);
	public ProdReviewVO getStat(int tripProdNo);
	public int updateReview(ProdReviewVO vo);
	public int deleteReview(@Param("prodRvNo") int prodRvNo, @Param("memNo") int memNo);
	public Integer getReviewAttachNo(int prodRvNo);
	public int updateReviewAttachNo(@Param("prodRvNo") int prodRvNo, @Param("attachNo") int attachNo);
	public int insertReview(ProdReviewVO vo);
}
