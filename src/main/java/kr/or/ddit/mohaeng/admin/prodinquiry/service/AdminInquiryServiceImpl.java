package kr.or.ddit.mohaeng.admin.prodinquiry.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.admin.prodinquiry.mapper.IAdminInquiryMapper;
import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminInquiryServiceImpl implements IAdminInquiryService {

    @Autowired
    private IAdminInquiryMapper mapper;

    @Override
    public List<TripProdInquiryVO> getInquiryList(Map<String, Object> params) {
        return mapper.getInquiryList(params);
    }

    @Override
    public int getInquiryCount(Map<String, Object> params) {
        return mapper.getInquiryCount(params);
    }

    @Override
    public Map<String, Object> getInquiryStats(Map<String, Object> params) {
        return mapper.getInquiryStats(params);
    }

    @Override
    public TripProdInquiryVO getInquiryDetail(int prodInqryNo) {
        return mapper.getInquiryDetail(prodInqryNo);
    }

    @Override
    public int hideInquiry(int prodInqryNo) {
        return mapper.hideInquiry(prodInqryNo);
    }

    @Override
    public int unhideInquiry(int prodInqryNo) {
        return mapper.unhideInquiry(prodInqryNo);
    }

    @Override
    public List<TripProdInquiryVO> getInquiryListForExcel(Map<String, Object> params) {
        return mapper.getInquiryListForExcel(params);
    }
}
