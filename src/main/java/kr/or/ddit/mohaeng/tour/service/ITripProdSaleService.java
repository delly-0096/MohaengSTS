package kr.or.ddit.mohaeng.tour.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;

public interface ITripProdSaleService {
	public Map<Integer, TripProdSaleVO> getSaleList(List<Integer> prodNos);
	public TripProdSaleVO getSale(int tripProdNo);
}
