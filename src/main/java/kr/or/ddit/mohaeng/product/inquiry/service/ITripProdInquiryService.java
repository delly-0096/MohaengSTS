package kr.or.ddit.mohaeng.product.inquiry.service;

import java.util.List;

import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;

public interface ITripProdInquiryService {
	public List<TripProdInquiryVO> getInquiryPaging(int tripProdNo, int i, int j);
	public int getInquiryCount(int tripProdNo);
	public TripProdInquiryVO insertInquiry(TripProdInquiryVO vo);
	public int updateInquiry(TripProdInquiryVO vo);
	public int deleteInquiry(int prodInqryNo, int inquiryMemNo);
	public int insertReply(TripProdInquiryVO vo);
	public int updateReply(TripProdInquiryVO vo);
	public int deleteReply(int prodInqryNo, int replyMemNo);
}
