package kr.or.ddit.mohaeng.admin.settlements.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface IAdminSettlementsMapper {
	
	// 정산 목록
	public  List<Map<String, Object>> selectSettleList();

	// 기업 정보 및 정산 요약 조회
	public Map<String, Object> getSettleEnterpriseInfo(int saleNo);

    // 상품별 매출 요약
	public List<Map<String, Object>> getProductSalesSummary(@Param("compNo") int compNo, @Param("settleMonth") String settleMonth);

    // 개별 주문 상세 내역 리스트
	public List<Map<String, Object>> getSettleOrderDetailList(@Param("compNo") int compNo, @Param("settleMonth") String settleMonth);

	// 정산 완료 update
	public void updateSettleStatus(int saleNo);

	// 정산 완료 시 정산 데이터 저장
	public void insertSettlementHistory(int saleNo, int settlePay, int compNo);
}
