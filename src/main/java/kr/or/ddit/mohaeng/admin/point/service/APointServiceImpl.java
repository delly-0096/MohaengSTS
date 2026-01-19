package kr.or.ddit.mohaeng.admin.point.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.admin.point.mapper.IAPointMapper;
import kr.or.ddit.mohaeng.vo.PointDetailsVO;
import kr.or.ddit.mohaeng.vo.PointSearchVO;
import kr.or.ddit.mohaeng.vo.PointSummaryVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class APointServiceImpl implements IAPointService {

	@Autowired
	private IAPointMapper aPointMapper;

	@Override
	public Map<String, Object> aPointStats() {
		// DB에서 직접 SUM 연산된 결과들을 Map 형태로 받음
		return aPointMapper.aPointStats();
	}

	@Override
	public int memberPointSummaryCount(PointSummaryVO summaryVO) {
		// 검색 키워드가 포함된 전체 회원 수
		return aPointMapper.memberPointSummaryCount(summaryVO);
	}

	@Override
	public List<PointSummaryVO> memberPointSummaryList(PointSummaryVO summaryVO) {
		// 페이징과 검색이 적용된 회원별 포인트 요약 리스트
		return aPointMapper.memberPointSummaryList(summaryVO);
	}

	@Override
	public int allPointHistoryCount(PointSearchVO searchVO) {
		// 전체 내역 중 필터링 조건에 맞는 행의 개수
		return aPointMapper.allPointHistoryCount(searchVO);
	}

	@Override
	public List<PointDetailsVO> allPointHistory(PointSearchVO searchVO) {
		// 전체 내역 리스트(관리자는 모든 회원의 내역을 보니까)
		return aPointMapper.allPointHistory(searchVO);
	}

}
