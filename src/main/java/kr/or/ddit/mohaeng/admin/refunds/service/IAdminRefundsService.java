package kr.or.ddit.mohaeng.admin.refunds.service;

import java.util.List;
import java.util.Map;

public interface IAdminRefundsService {

	// 전체 목록 가져오기
	public List<Map<String, Object>> getRefundList(Map<String, Object> params);
	
	// 환불 승인 하기
	public int approveRefund(Map<String, Object> params);

	// 결제상태를 REFUNDED로 바꾸고 로그 기록
	public int processApprove(Map<String, Object> params);

	// 결제상태를 REJECTED로 바꾸고 거절 사유 업데이트
	public int processReject(Map<String, Object> params);

}
