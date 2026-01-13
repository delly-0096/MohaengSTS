package kr.or.ddit.mohaeng.product.inquiry.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;

@Mapper
public interface ITripProdInquiryMapper {
	public List<TripProdInquiryVO> getInquiryPaging(Map<String, Object> params);
	public int getInquiryCount(int tripProdNo);
	public int insertInquiry(TripProdInquiryVO vo);
	public int updateInquiry(TripProdInquiryVO vo);
	public int deleteInquiry(@Param("prodInqryNo") int prodInqryNo, @Param("inquiryMemNo") int inquiryMemNo);
	public int insertReply(TripProdInquiryVO vo);
	public int updateReply(TripProdInquiryVO vo);
	public int deleteReply(@Param("prodInqryNo") int prodInqryNo, @Param("replyMemNo") int replyMemNo);
	public TripProdInquiryVO getInquiryById(int prodInqryNo);
}
