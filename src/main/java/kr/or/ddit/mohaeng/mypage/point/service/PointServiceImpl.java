package kr.or.ddit.mohaeng.mypage.point.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.vo.PointDetailsVO;
import kr.or.ddit.mohaeng.vo.PointSearchVO;
import kr.or.ddit.mohaeng.vo.PointSummaryVO;

@Service
public class PointServiceImpl implements IPointService {

	@Override
	public PointSummaryVO pointSummary(int memNo) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int pointHistoryCount(PointSearchVO searchVO) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<PointDetailsVO> pointHistory(PointSearchVO searchVO) {
		// TODO Auto-generated method stub
		return null;
	}

}
