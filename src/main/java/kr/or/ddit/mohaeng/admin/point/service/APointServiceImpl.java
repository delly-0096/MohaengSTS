package kr.or.ddit.mohaeng.admin.point.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.vo.PointDetailsVO;
import kr.or.ddit.mohaeng.vo.PointSearchVO;
import kr.or.ddit.mohaeng.vo.PointSummaryVO;


@Service
public class APointServiceImpl implements IAPointService {

	@Override
	public Map<String, Object> aPointStats() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int memberPointSummaryCount(PointSummaryVO summaryVO) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<PointSummaryVO> memberPointSummary(PointSummaryVO summaryVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int allPointHistoryCount(PointSearchVO searchVO) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<PointDetailsVO> getAllPointHistory(PointSearchVO searchVO) {
		// TODO Auto-generated method stub
		return null;
	}

}
