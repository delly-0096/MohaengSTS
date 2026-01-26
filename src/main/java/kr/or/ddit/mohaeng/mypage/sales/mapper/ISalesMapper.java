package kr.or.ddit.mohaeng.mypage.sales.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.SalesVO;

@Mapper
public interface ISalesMapper {
	public Integer getThisMonthSales(int memNo);
	public Integer getLastMonthSales(int memNo);
	public Integer getPendingSettle(int memNo);
	public Integer getLastMonthSettle(int memNo);
	public List<SalesVO> getMonthlySales(SalesVO salesVO);
	public SalesVO getIndustryComparison(SalesVO salesVO);
	public List<SalesVO> getSalesList(SalesVO salesVO);
	public int getSalesCount(SalesVO salesVO);
	public SalesVO getSalesSummary(SalesVO salesVO);
	public List<SalesVO> getProductSalesList(SalesVO salesVO);
	public int getProductSalesCount(SalesVO salesVO);
	public SalesVO getProductSalesSummary(SalesVO salesVO);
	public int updateSettleComplete(Map<String, Object> params);
}
