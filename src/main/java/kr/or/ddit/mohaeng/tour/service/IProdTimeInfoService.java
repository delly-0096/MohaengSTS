package kr.or.ddit.mohaeng.tour.service;

import java.util.List;

import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;

public interface IProdTimeInfoService {
	public List<ProdTimeInfoVO> getAvailableTimes(int tripProdNo);
}
