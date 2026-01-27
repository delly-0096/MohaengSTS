package kr.or.ddit.mohaeng.product.inquiry.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.alarm.service.AlarmService;
import kr.or.ddit.mohaeng.product.inquiry.mapper.ITripProdInquiryMapper;
import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TripProdInquiryServiceImpl implements ITripProdInquiryService {

	@Autowired
    private ITripProdInquiryMapper mapper;
	
	@Autowired
    private AlarmService alarmService;

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
        TripProdInquiryVO inserted = mapper.getInquiryById(vo.getProdInqryNo());
        
        // 기업회원에게 문의 발생 알림
        try {
            // 상품의 판매자(기업회원) memNo 조회
            Integer sellerMemNo = mapper.getSellerMemNo(vo.getTripProdNo());
            String productName = mapper.getProductName(vo.getTripProdNo());
            
            if (sellerMemNo != null) {
                alarmService.sendNewInquiryAlarm(sellerMemNo, productName, vo.getTripProdNo());
            }
        } catch (Exception e) {
            log.error("문의 발생 알림 전송 실패: {}", e.getMessage());
        }
        
        return inserted;
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
		int result = mapper.insertReply(vo);
        
        // 문의 작성자에게 답변 알림
        if (result > 0) {
            try {
                // 문의 정보 조회 (작성자 memNo, 상품번호)
                TripProdInquiryVO inquiry = mapper.getInquiryById(vo.getProdInqryNo());
                String productName = mapper.getProductName(inquiry.getTripProdNo());
                
                alarmService.sendInquiryReplyAlarm(
                    inquiry.getInquiryMemNo(),  // 문의 작성자
                    productName,
                    inquiry.getTripProdNo()
                );
            } catch (Exception e) {
                log.error("답변 알림 전송 실패: {}", e.getMessage());
            }
        }
        
        return result;
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
