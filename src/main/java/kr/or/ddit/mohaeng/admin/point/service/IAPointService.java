package kr.or.ddit.mohaeng.admin.point.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.vo.PointDetailsVO;
import kr.or.ddit.mohaeng.vo.PointSearchVO;
import kr.or.ddit.mohaeng.vo.PointSummaryVO;

public interface IAPointService {

	Map<String, Object> aPointStats();

	int memberPointSummaryCount(PointSummaryVO summaryVO);

	List<PointSummaryVO> memberPointSummary(PointSummaryVO summaryVO);

	int allPointHistoryCount(PointSearchVO searchVO);

	List<PointDetailsVO> getAllPointHistory(PointSearchVO searchVO);

}
