package kr.or.ddit.mohaeng.tour.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.tour.mapper.IProdTimeInfoMapper;
import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;

@Service
public class ProdTimeInfoServiceImpl implements IProdTimeInfoService {

	@Autowired
    private IProdTimeInfoMapper mapper;
	
	@Override
	public List<ProdTimeInfoVO> getAvailableTimes(int tripProdNo) {
		return mapper.getAvailableTimes(tripProdNo);
	}

}
