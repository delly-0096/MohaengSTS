package kr.or.ddit.mohaeng.tour.service;

import java.util.List;

import kr.or.ddit.mohaeng.tour.vo.TripProdVO;

public interface ITripProdService {
	public List<TripProdVO> list(TripProdVO tp);
	public int getTotalCount(TripProdVO tp);
	public TripProdVO detail(int tripProdNo);
}
