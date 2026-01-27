package kr.or.ddit.mohaeng.admin.tour.service;

import java.util.Map;

import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface IAdminTourService {
	public void getTourList(PaginationInfoVO<TripProdVO> pagInfoVO);
	public TripProdVO getTourDetail(int tripProdNo);
	public int approveTour(int tripProdNo);
	public int toggleSaleStatus(Map<String, Object> params);
	public int deleteTour(int tripProdNo);
	public Map<String, Object> getTourStats();
}
