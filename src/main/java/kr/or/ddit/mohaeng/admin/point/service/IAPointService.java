package kr.or.ddit.mohaeng.admin.point.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.PointDetailsVO;
import kr.or.ddit.mohaeng.vo.PointSearchVO;
import kr.or.ddit.mohaeng.vo.PointSummaryVO;

public interface IAPointService {

	//--- 조회 -----

	/**
	 * 관리자 대시보드 상단 통계(총 발급, 사용, 만료, 잔액 합계)
	 */
	Map<String, Object> aPointStats();

	/**
	 * 전체 회원별 포인트 보유 현황 개수 (검색 포함)
	 */
	int memberPointSummaryCount(PointSummaryVO summaryVO);

	/**
	 * 전체 회원별 포인트 보유 현황 목록 조회
	 */
	List<PointSummaryVO> memberPointSummaryList(PointSummaryVO summaryVO);

	/**
	 * 시스템 전체 포인트 발생 내역 개수 (필터링 포함)
	 */
	int allPointHistoryCount(PointSearchVO searchVO);

	/**
	 * 시스템 전체 포인트 발생 상세 내역 목록 조회
	 */
	List<PointDetailsVO> allPointHistory(PointSearchVO searchVO);




}
