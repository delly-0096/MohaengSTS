package kr.or.ddit.mohaeng.admin.settlements.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.admin.settlements.service.IAdminSettlementsService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/transactions/settlements")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminSettlementsController {

	@Autowired
	private IAdminSettlementsService adminSettService;
	
	@GetMapping
    public ResponseEntity<List<Map<String, Object>>> getSettleList() {
        // 전체 정산 목록 반환
        List<Map<String, Object>> list = adminSettService.getSettleList();
        return ResponseEntity.ok(list);
    }
	
	// 정산 상세 모달
	@GetMapping("/{saleNo}")
    public ResponseEntity<Map<String, Object>> getSettleDetail(@PathVariable("saleNo") int saleNo) {
        log.info("정산 상세 모달 데이터 요청 - 판매번호: {}", saleNo);
        
        // Service에서 3가지 쿼리(기업, 상품요약, 주문내역)를 묶은 Map을 반환함
        Map<String, Object> detailData = adminSettService.getSettleDetailModal(saleNo);
        
        if (detailData != null) {
            return ResponseEntity.ok(detailData);
        } else {
            // 데이터가 없을 경우 404 반환
            return ResponseEntity.notFound().build();
        }
    }
	
	// 정산 확정 처리
    @PostMapping("/{saleNo}/approve")
    public ResponseEntity<String> approveSettlement(
        @PathVariable("saleNo") int saleNo, 
        @RequestBody Map<String, Object> params
    ) {
        try {
            // 1. 값 꺼내기 (Map에서 꺼낼 때 키값 대소문자 주의!)
            Object compNoObj = params.get("compNo");
            Object settlePayObj = params.get("settlePay");

            // 2. null 체크 (String.valueOf 보다는 직접 null 체크가 더 명확해!)
            if (compNoObj == null || settlePayObj == null) {
                // 로그를 찍어보면 뭐가 문제인지 바로 알 수 있어
                System.out.println("파라미터 누락 확인 -> compNo: " + compNoObj + ", settlePay: " + settlePayObj);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                     .body("필수 정산 정보가 누락되었습니다. (전달된 키값을 확인하세요)");
            }

            // 3. 안전하게 숫자로 변환
            int compNo = Integer.parseInt(compNoObj.toString());
            int settlePay = Integer.parseInt(settlePayObj.toString());

            // 4. 서비스 호출
            adminSettService.approveSettlement(saleNo, compNo, settlePay);
            
            return ResponseEntity.ok("정산 처리가 완료되었습니다.");

        } catch (NumberFormatException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("전달된 금액이나 번호가 숫자 형식이 아닙니다.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류: " + e.getMessage());
        }
    }
    
    
    // 일괄 정산 확정 처리
    @PostMapping("/batch-approve")
    public ResponseEntity<String> batchApproveSettlement(@RequestBody Map<String, Object> payload) {
        try {
            // 1. 리액트에서 보낸 targets 리스트 추출
            List<Map<String, Object>> targets = (List<Map<String, Object>>) payload.get("targets");
            
            if (targets == null || targets.isEmpty()) {
                return ResponseEntity.badRequest().body("정산할 항목이 선택되지 않았습니다.");
            }

            // 2. 서비스 단으로 통째로 넘기기
            adminSettService.approveBatchSettlement(targets);
            
            return ResponseEntity.ok(targets.size() + "건의 정산 처리가 완료되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("일괄 처리 중 오류 발생: " + e.getMessage());
        }
    }
	
	
}
