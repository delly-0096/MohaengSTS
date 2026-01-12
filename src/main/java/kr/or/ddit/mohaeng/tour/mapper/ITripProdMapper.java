package kr.or.ddit.mohaeng.tour.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.tour.vo.TripProdVO;

@Mapper
public interface ITripProdMapper {
	public List<TripProdVO> list(TripProdVO tp);
	public int getTotalCount(TripProdVO tp);
	public void increase(int tripProdNo);
	public TripProdVO detail(int tripProdNo);
}
