package kr.or.ddit.mohaeng.mypage.statistics.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.util.Params;

public interface IStatisticsService {

	public List<Params> selectProdSg(Params params);

}
