package kr.or.ddit.mohaeng.admin.prodinquiry.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;

public interface IAdminInquiryService {
    public List<TripProdInquiryVO> getInquiryList(Map<String, Object> params);
    public int getInquiryCount(Map<String, Object> params);
    public Map<String, Object> getInquiryStats(Map<String, Object> params);
    public TripProdInquiryVO getInquiryDetail(int prodInqryNo);
    public int hideInquiry(int prodInqryNo);
    public int unhideInquiry(int prodInqryNo);
    public List<TripProdInquiryVO> getInquiryListForExcel(Map<String, Object> params);
}
