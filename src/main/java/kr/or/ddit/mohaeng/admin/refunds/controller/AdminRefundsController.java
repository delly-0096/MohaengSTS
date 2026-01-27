package kr.or.ddit.mohaeng.admin.refunds.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.admin.refunds.service.IAdminRefundsService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/admin/transactions/refunds")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminRefundsController {

	@Autowired
	private IAdminRefundsService adminRefundsService;
	
	// 전체 목록 조회
	@GetMapping
	public ResponseEntity<?> getRefundList(@RequestParam Map<String, Object> params) {
	    // 관리자용 취소/환불 목록 조회
	    List<Map<String, Object>> refundList = adminRefundsService.getRefundList(params);
	    
	    // 통계 데이터도 같이 묶어서 보내주기
	    Map<String, Object> response = new HashMap<>();
	    response.put("list", refundList);
	    response.put("totalCount", refundList.size());
	    
	    return ResponseEntity.ok(response);
	}
	
	// 결제상태를 REFUNDED로 바꾸고 로그 기록
    @PostMapping("/approve")
    public ResponseEntity<?> approveRefund(@RequestBody Map<String, Object> params) {
        int result = adminRefundsService.processApprove(params);
        return ResponseEntity.ok(result);
    }

    // 결제상태를 REJECTED로 바꾸고 거절 사유 업데이트
    @PostMapping("/reject")
    public ResponseEntity<?> rejectRefund(@RequestBody Map<String, Object> params) {
        // params: payNo, rejectReason
        int result = adminRefundsService.processReject(params);
        return ResponseEntity.ok(result);
    }
}
