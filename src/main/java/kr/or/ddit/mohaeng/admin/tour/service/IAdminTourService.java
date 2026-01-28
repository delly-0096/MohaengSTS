package kr.or.ddit.mohaeng.admin.tour.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface IAdminTourService {
	public void getTourList(PaginationInfoVO<TripProdVO> pagInfoVO);
    public List<TripProdVO> getTourListAll(Map<String, Object> params);
    public TripProdVO getTourDetail(int tripProdNo);
    public int approveTour(int tripProdNo);
    public int toggleSaleStatus(Map<String, Object> params);
    public int deleteTour(int tripProdNo);
    public Map<String, Object> getTourStats();
}
