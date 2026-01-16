package kr.or.ddit.mohaeng.admin.point.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.PointDetailsVO;
import kr.or.ddit.mohaeng.vo.PointSearchVO;
import kr.or.ddit.mohaeng.vo.PointSummaryVO;

@Mapper
public interface IAPointMapper {

	Map<String, Object> aPointStats();

	int memberPointSummaryCount(PointSummaryVO summaryVO);

	List<PointSummaryVO> memberPointSummary(PointSummaryVO summaryVO);

	int allPointHistoryCount(PointSearchVO searchVO);

	List<PointDetailsVO> allPointHistory(PointSearchVO searchVO);

}
