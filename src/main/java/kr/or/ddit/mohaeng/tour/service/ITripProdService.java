package kr.or.ddit.mohaeng.tour.service;

import java.util.List;

import kr.or.ddit.mohaeng.tour.vo.TripProdPlaceVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.CompanyVO;

public interface ITripProdService {
	public List<TripProdVO> list(TripProdVO tp);
	public int getTotalCount(TripProdVO tp);
	public TripProdVO detail(int tripProdNo);
	public CompanyVO getSellerStats(int compNo);
	public TripProdPlaceVO getPlace(int tripProdNo);
	public int updateExpiredStatus();
	public void updateAttachNo(int tripProdNo, int attachNo);
}
