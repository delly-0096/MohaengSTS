package kr.or.ddit.mohaeng.admin.refunds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.admin.refunds.mapper.IAdminRefundsMapper;

@Service
public class AdminRefundsServiceImpl implements IAdminRefundsService{

	@Autowired
	private IAdminRefundsMapper adminRefundsMapper;
	
	/**
	 * 전체 목록 가져오기
	 */
	@Override
	public List<Map<String, Object>> getRefundList(Map<String, Object> params) {
		return adminRefundsMapper.getRefundDetailList(params); 
	}
	
	/**
	 * 환불 승인 하기
	 */
	@Transactional
	public int approveRefund(Map<String, Object> params) {
	    // 1. 결제 상태 변경 (PENDING -> REFUNDED)
	    int updateResult = adminRefundsMapper.updateStatusToApproved(params);
	    
	    // 2. 환불 이력 생성 (INSERT)
	    int insertResult = adminRefundsMapper.insertRefundLog(params);
	    
	    return (updateResult > 0 && insertResult > 0) ? 1 : 0;
	}

	/**
	 * 	결제상태를 REFUNDED로 바꾸고 로그 기록
	 */
	@Override
	@Transactional
	public int processApprove(Map<String, Object> params) {
		params.put("status", "REFUNDED"); 
        int updateRes = adminRefundsMapper.updateStatusToApproved(params);

        // 2. 환불 이력(REFUND_LOG) 생성
        int logRes = adminRefundsMapper.insertRefundLog(params);

        // 3. 포인트가 있다면 회원 포인트 복구 (선택 사항)
        if (Integer.parseInt(String.valueOf(params.get("refundPoint"))) > 0) {
        	adminRefundsMapper.restoreMemberPoint(params);
        }

        return (updateRes > 0 && logRes > 0) ? 1 : 0;
	}

	/**
	 * 결제상태를 REJECTED로 바꾸고 거절 사유 업데이트
	 */
	@Override
	@Transactional
	public int processReject(Map<String, Object> params) {
		params.put("status", "REJECTED");
        return adminRefundsMapper.updateStatusToRejected(params);
	}
	
	
}
