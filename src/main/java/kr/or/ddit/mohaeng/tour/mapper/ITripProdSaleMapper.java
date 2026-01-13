package kr.or.ddit.mohaeng.tour.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;

@Mapper
public interface ITripProdSaleMapper {
	public TripProdSaleVO getSale(int tripProdNo);
}
