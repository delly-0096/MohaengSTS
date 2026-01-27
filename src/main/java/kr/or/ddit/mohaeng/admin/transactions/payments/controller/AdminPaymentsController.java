package kr.or.ddit.mohaeng.admin.transactions.payments.controller;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import kr.or.ddit.mohaeng.admin.transactions.payments.service.IAdminPaymentsService;
import kr.or.ddit.mohaeng.vo.AdminPaymentsVO;

@RestController
@RequestMapping("/api/admin/transactions/payments")
@CrossOrigin(origins = "http://localhost:7272", allowCredentials = "true")
public class AdminPaymentsController {

    @Autowired
    private IAdminPaymentsService service;

    // 결제 리스트 조회 (페이징, 검색, 필터 포함)
	/*
	 * @GetMapping("/list") public List<AdminPaymentsVO>
	 * getPaymentList(@RequestParam Map<String, Object> params) { // params에는 page,
	 * searchTerm, dateFilter, statusFilter가 담겨옴 return
	 * service.selectAdminPaymentList(params); }
	 */
    @GetMapping("/list")
    public List<AdminPaymentsVO> getPaymentList(@RequestParam Map<String, Object> params) {
        List<AdminPaymentsVO> list = service.selectAdminPaymentList(params);
        
        // 만약 DB 결과가 null이면 리액트가 에러 나지 않게 빈 리스트[]를 던져줌
        if (list == null) {
            return new java.util.ArrayList<>(); 
        }
        return list;
    }
    

    // 통계 데이터 조회
    @GetMapping("/stats")
    public Map<String, Object> getStats() {
        return service.getPaymentStats();
    }
    
    
}