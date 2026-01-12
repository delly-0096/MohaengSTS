package kr.or.ddit.mohaeng.product.inquiry.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.product.inquiry.mapper.ITripProdInquiryMapper;
import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;

@Service
public class TripProdInquiryServiceImpl implements ITripProdInquiryService {

	@Autowired
    private ITripProdInquiryMapper mapper;

	@Override
	public List<TripProdInquiryVO> getInquiryPaging(int tripProdNo, int page, int pageSize) {
        Map<String, Object> params = new HashMap<>();
        params.put("tripProdNo", tripProdNo);
        params.put("startRow", (page - 1) * pageSize);
        params.put("endRow", page * pageSize);
        return mapper.getInquiryPaging(params);
	}

	@Override
	public int getInquiryCount(int tripProdNo) {
		return mapper.getInquiryCount(tripProdNo);
	}

	@Override
	public TripProdInquiryVO insertInquiry(TripProdInquiryVO vo) {
		mapper.insertInquiry(vo);
		return vo;
	}

	@Override
	public int updateInquiry(TripProdInquiryVO vo) {
	    return mapper.updateInquiry(vo);
	}

	@Override
	public int deleteInquiry(int prodInqryNo, int inquiryMemNo) {
	    return mapper.deleteInquiry(prodInqryNo, inquiryMemNo);
	}

	@Override
	public int insertReply(TripProdInquiryVO vo) {
		return mapper.insertReply(vo);
	}

	@Override
	public int updateReply(TripProdInquiryVO vo) {
		return mapper.updateReply(vo);
	}

	@Override
	public int deleteReply(int prodInqryNo, int replyMemNo) {
		return mapper.deleteReply(prodInqryNo, replyMemNo);
	}

}
