package kr.or.ddit.mohaeng.mypage.sales.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.mypage.sales.mapper.ISalesMapper;
import kr.or.ddit.mohaeng.vo.SalesVO;

@Service
public class SalesServiceImpl implements ISalesService {
	
	@Autowired
	private ISalesMapper mapper;

	@Override
	public Map<String, Object> getSalesStats(int memNo) {
		Map<String, Object> stats = new HashMap<>();
        
        // 이번 달 매출
        Integer thisMonth = mapper.getThisMonthSales(memNo);
        thisMonth = (thisMonth != null) ? thisMonth : 0;
        stats.put("thisMonthSales", thisMonth);
        
        // 지난 달 매출
        Integer lastMonth = mapper.getLastMonthSales(memNo);
        lastMonth = (lastMonth != null) ? lastMonth : 0;
        stats.put("lastMonthSales", lastMonth);
        
        // 전월 대비 증감률
        double growthRate = 0;
        if (lastMonth > 0) {
            growthRate = ((double)(thisMonth - lastMonth) / lastMonth) * 100;
        } else if (thisMonth > 0) {
            growthRate = 100;
        }
        stats.put("growthRate", Math.round(growthRate * 10) / 10.0);
        
        // 정산 예정액
        Integer pendingSettle = mapper.getPendingSettle(memNo);
        stats.put("pendingSettle", (pendingSettle != null) ? pendingSettle : 0);
        
        // 지난달 정산액
        Integer lastMonthSettle = mapper.getLastMonthSettle(memNo);
        stats.put("lastMonthSettle", (lastMonthSettle != null) ? lastMonthSettle : 0);
        
        return stats;
	}

	@Override
	public List<SalesVO> getMonthlySales(SalesVO salesVO) {
		return mapper.getMonthlySales(salesVO);
	}

	@Override
	public SalesVO getIndustryComparison(SalesVO salesVO) {
		return mapper.getIndustryComparison(salesVO);
	}

	@Override
	public Map<String, Object> getSalesList(SalesVO salesVO) {
		Map<String, Object> result = new HashMap<>();
        
        // 목록 조회
        List<SalesVO> list = mapper.getSalesList(salesVO);
        result.put("list", list);
        
        // 총 건수
        int totalCount = mapper.getSalesCount(salesVO);
        result.put("totalCount", totalCount);
        
        // 총 페이지 수
        int totalPages = (int) Math.ceil((double) totalCount / salesVO.getPageSize());
        result.put("totalPages", totalPages);
        
        // 합계 조회
        SalesVO summary = mapper.getSalesSummary(salesVO);
        result.put("summary", summary);
        
        return result;
	}

	@Override
	public Map<String, Object> getProductSalesData(SalesVO salesVO) {
		Map<String, Object> result = new HashMap<>();
	    
	    // 목록 조회
	    List<SalesVO> list = mapper.getProductSalesList(salesVO);
	    result.put("list", list);
	    
	    // 총 건수
	    int totalCount = mapper.getProductSalesCount(salesVO);
	    result.put("totalCount", totalCount);
	    
	    // 총 페이지 수
	    int totalPages = (int) Math.ceil((double) totalCount / salesVO.getProductPageSize());
	    result.put("totalPages", totalPages);
	    
	    // 합계 조회
	    SalesVO summary = mapper.getProductSalesSummary(salesVO);
	    result.put("summary", summary);
	    
	    return result;
	}

	@Override
	public int requestSettle(List<Integer> prodNoList) {
		Map<String, Object> params = new HashMap<>();
	    params.put("prodNoList", prodNoList);
	    return mapper.updateSettleComplete(params);
	}

}
