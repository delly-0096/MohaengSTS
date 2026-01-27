package kr.or.ddit.mohaeng.admin.refunds.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IAdminRefundsMapper {

	// 전체 목록 가져오기
	public List<Map<String, Object>> getRefundDetailList(Map<String, Object> params);

	// 환불 승인 시 결제 상태를 'REFUNDED'로 업데이트
	public int updateStatusToApproved(Map<String, Object> params);

	// 환불 완료 후 상세 이력을 REFUND_LOG 테이블에 기록
	public int insertRefundLog(Map<String, Object> params);

	// 결제 시 사용했던 포인트를 해당 회원의 잔액으로 다시 복구
	public void restoreMemberPoint(Map<String, Object> params);

	// 환불 거절 시 결제 상태를 'REJECTED'로 변경하고 거절 사유 기록
	public int updateStatusToRejected(Map<String, Object> params);

}
