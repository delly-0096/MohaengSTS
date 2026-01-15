package kr.or.ddit.mohaeng.mypage.point.service;

import java.util.List;

import kr.or.ddit.mohaeng.vo.PointDetailsVO;
import kr.or.ddit.mohaeng.vo.PointSearchVO;
import kr.or.ddit.mohaeng.vo.PointSummaryVO;

public interface IPointService {

	PointSummaryVO pointSummary(int memNo);

	int pointHistoryCount(PointSearchVO searchVO);

	List<PointDetailsVO> pointHistory(PointSearchVO searchVO);

}
