package kr.or.ddit.mohaeng.tour.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;

@Mapper
public interface ITripProdSaleMapper {
	public List<TripProdSaleVO> getSaleList(List<Integer> prodNos);
	public TripProdSaleVO getSale(int tripProdNo);
}
