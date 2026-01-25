package kr.or.ddit.mohaeng.admin.settlements.service;

import java.util.List;
import java.util.Map;

public interface IAdminSettlementsService {

	/**
	 * 전체 목록 가져오기
	 */
	List<Map<String, Object>> getSettleList();
	
	/**
	 *  모달 상세 내역 가져오기
	 */
	public Map<String, Object> getSettleDetailModal(int saleNo);

	/**
	 * 정산 완료 후 정산 데이터 저장
	 */
	public void approveSettlement(int saleNo, int compNo, int settlePay);

	/**
	 * 일괄 정산 완료 처리
	 */
	public void approveBatchSettlement(List<Map<String, Object>> targets);

}
