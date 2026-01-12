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
	public Map<Integer, TripProdSaleVO> getSaleList(List<Integer> prodNos) {
		Map<Integer, TripProdSaleVO> result = new HashMap<>();
        if (prodNos == null || prodNos.isEmpty()) {
            return result;
        }
        List<TripProdSaleVO> list = mapper.getSaleList(prodNos);
        for (TripProdSaleVO sale : list) {
            result.put(sale.getTripProdNo(), sale);
        }
        return result;
	}

	@Override
	public TripProdSaleVO getSale(int tripProdNo) {
		return mapper.getSale(tripProdNo);
	}

}
