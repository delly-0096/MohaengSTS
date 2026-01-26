package kr.or.ddit.mohaeng.mypage.sales.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.vo.SalesVO;

public interface ISalesService {
	public Map<String, Object> getSalesStats(int memNo);
	public List<SalesVO> getMonthlySales(SalesVO salesVO);
	public SalesVO getIndustryComparison(SalesVO salesVO);
	public Map<String, Object> getSalesList(SalesVO salesVO);
    public Map<String, Object> getProductSalesData(SalesVO salesVO);
    public int requestSettle(List<Integer> prodNoList);
}
