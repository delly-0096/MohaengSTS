package kr.or.ddit.mohaeng.tour.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.tour.vo.TripProdInfoVO;

@Mapper
public interface ITripProdInfoMapper {
	public TripProdInfoVO getInfo(int tripProdNo);
}
