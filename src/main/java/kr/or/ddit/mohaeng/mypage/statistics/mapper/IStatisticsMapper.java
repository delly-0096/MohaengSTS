package kr.or.ddit.mohaeng.mypage.statistics.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.util.Params;

@Mapper
public interface IStatisticsMapper {

	public List<Params> selectProdSg(Params params);

	public List<Params> selectSalesTrend(Params params);

	public List<Params> selectReservation(Params params);

}
