package kr.or.ddit.mohaeng.mypage.statistics.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.mypage.statistics.mapper.IStatisticsMapper;
import kr.or.ddit.util.Params;

@Service
public class StatisticsServiceImpl implements IStatisticsService{

	@Autowired
	IStatisticsMapper statisticsMapper;
	
	@Override
	public List<Params> selectProdSg(Params params) {
		return statisticsMapper.selectProdSg(params);
	}

	@Override
	public List<Params> selectSalesTrend(Params params) {
		return statisticsMapper.selectSalesTrend(params);
	}

	@Override
	public List<Params> selectReservation(Params params) {
		return statisticsMapper.selectReservation(params);
	}

	@Override
	public Params selectGenderRatio(Params params) {
		return statisticsMapper.selectGenderRatio(params);
	}

	@Override
	public Params selectSalesStatsByAge(Params params) {
		return statisticsMapper.selectSalesStatsByAge(params);
	}

}
