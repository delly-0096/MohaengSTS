package kr.or.ddit.mohaeng.tour.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.tour.mapper.ITripProdInfoMapper;
import kr.or.ddit.mohaeng.tour.vo.TripProdInfoVO;

@Service
public class TripProdInfoServiceImpl implements ITripProdInfoService {

	@Autowired
    private ITripProdInfoMapper mapper;
	
	@Override
	public TripProdInfoVO getInfo(int tripProdNo) {
		return mapper.getInfo(tripProdNo);
	}

}
