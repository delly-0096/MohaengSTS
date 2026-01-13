package kr.or.ddit.mohaeng.tour.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.tour.mapper.ITripProdSaleMapper;
import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;

@Service
public class TripProdSaleServiceImpl implements ITripProdSaleService {
	
	@Autowired
    private ITripProdSaleMapper mapper;

	@Override
	public TripProdSaleVO getSale(int tripProdNo) {
		return mapper.getSale(tripProdNo);
	}

}
