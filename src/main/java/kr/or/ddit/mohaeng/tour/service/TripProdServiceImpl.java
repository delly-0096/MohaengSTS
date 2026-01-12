package kr.or.ddit.mohaeng.tour.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.tour.mapper.ITripProdMapper;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;

@Service
public class TripProdServiceImpl implements ITripProdService {
	
	@Autowired
	private ITripProdMapper mapper;

	@Override
	public List<TripProdVO> list(TripProdVO tp) {
		return mapper.list(tp);
	}

	@Override
	public int getTotalCount(TripProdVO tp) {
		return mapper.getTotalCount(tp);
	}

	@Override
	public TripProdVO detail(int tripProdNo) {
		mapper.increase(tripProdNo);
		return mapper.detail(tripProdNo);
	}

}
