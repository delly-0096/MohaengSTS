package kr.or.ddit.mohaeng.admin.settlements.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.admin.settlements.mapper.IAdminSettlementsMapper;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminSettlementsServiceImpl implements IAdminSettlementsService {

	@Autowired
	public IAdminSettlementsMapper adminSettMapper;
	
	/**
	 * 전체 목록 불러오기
	 */
	@Override
	public List<Map<String, Object>> getSettleList() {
	    log.info("정산 목록 조회를 시작합니다.");
	    
	    // 쿼리 결과를 리스트 형태로 반환
	    List<Map<String, Object>> settleList = adminSettMapper.selectSettleList();
	    
	    log.info("조회된 정산 건수: {}건", settleList.size());
	    return settleList;
	}
	
	/**
	 * 모달 상세창 불러오기
	 */
	@Override
	public Map<String, Object> getSettleDetailModal(int saleNo) {
		// 1. 기업 기본 정보 및 정산 요약 데이터 가져오기
	    Map<String, Object> enterpriseInfo = adminSettMapper.getSettleEnterpriseInfo(saleNo);
	    
	    // 데이터가 아예 없을 경우를 대비한 널 체크
	    if (enterpriseInfo == null || enterpriseInfo.isEmpty()) {
	        return null; 
	    }

	    try {
	        /* * [핵심 수정] 
	         * 1. 쿼리에 COMP_NO가 없다면 추가해야 함!
	         * 2. MyBatis 설정(카멜케이스)에 따라 키값을 정확히 매칭해야 함.
	         */
	        
	        // String.valueOf를 쓰면 null일 때 "null"을 반환해서 터지는 건 막아주지만, 
	        // 여기선 비즈니스 로직상 값이 꼭 있어야 하므로 안전하게 캐스팅!
	        Object rawCompNo = enterpriseInfo.get("compNo"); // 쿼리 별칭 확인 필요!
	        Object rawMonth = enterpriseInfo.get("settleMonth");

	        if (rawCompNo == null || rawMonth == null) {
	            System.out.println("⚠️ 필수 데이터(회사번호 또는 정산월)가 누락되었습니다.");
	            System.out.println("⚠️ 데이터는 왔는데 키값이 여전히 안 맞나봐! -> " + enterpriseInfo.keySet());
	            return null;
	        }

	        int compNo = Integer.parseInt(rawCompNo.toString());
	        String settleMonth = rawMonth.toString();

	        // 2. 상품별 매출 요약 데이터
	        List<Map<String, Object>> productSummary = adminSettMapper.getProductSalesSummary(compNo, settleMonth);
	        
	        // 3. 주문 상세 내역
	        List<Map<String, Object>> orderDetails = adminSettMapper.getSettleOrderDetailList(compNo, settleMonth);

	        // 4. 최종 Map 구성
	        Map<String, Object> finalResult = new HashMap<>();
	        finalResult.put("enterprise", enterpriseInfo);     
	        finalResult.put("productSummary", productSummary != null ? productSummary : new ArrayList<>()); 
	        finalResult.put("orderDetails", orderDetails != null ? orderDetails : new ArrayList<>()); 
	        
	        return finalResult;

	    } catch (Exception e) {
	        e.printStackTrace(); // 어디서 터졌는지 로그 확인용
	        return null;
	    }
	}
	
	/**
	 * 정산 완료 후 정산 데이터 저장
	 */
	@Transactional
	@Override
	public void approveSettlement(int saleNo, int compNo, int settlePay) {
	    // 1. 상태값 업데이트
		adminSettMapper.updateSettleStatus(saleNo);
	    
	    // 2. 결산 이력 저장
		adminSettMapper.insertSettlementHistory(saleNo, settlePay, compNo);
	}

	/**
	 * 일괄 정산 처리 완료
	 */
	@Override
	@Transactional
	public void approveBatchSettlement(List<Map<String, Object>> targets) {
		for (Map<String, Object> target : targets) {
            // 리액트에서 보낸 키값(saleNo, compNo, settlePay) 그대로 꺼내기
            int saleNo = Integer.parseInt(target.get("saleNo").toString());
            int compNo = Integer.parseInt(target.get("compNo").toString());
            // Double로 먼저 파싱 후 소수점 까지 읽은 뒤 int로 강제 형변환해서 소수점을 버림
            int settlePay = (int) Double.parseDouble(target.get("settlePay").toString());

            // 우리가 이미 만들어둔 개별 정산 로직을 재사용!
            this.approveSettlement(saleNo, compNo, settlePay);
        }
		
	}

}
