package kr.or.ddit.mohaeng.admin.prodinquiry.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;

@Mapper
public interface IAdminInquiryMapper {
    public List<TripProdInquiryVO> getInquiryList(Map<String, Object> params);
    public int getInquiryCount(Map<String, Object> params);
    public Map<String, Object> getInquiryStats(Map<String, Object> params);
    public TripProdInquiryVO getInquiryDetail(int prodInqryNo);
    public int hideInquiry(int prodInqryNo);
    public int unhideInquiry(int prodInqryNo);
    public List<TripProdInquiryVO> getInquiryListForExcel(Map<String, Object> params);
}
