package kr.or.ddit.mohaeng.admin.transactions.payments.controller;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import kr.or.ddit.mohaeng.admin.transactions.payments.service.IAdminPaymentsService;
import kr.or.ddit.mohaeng.vo.AdminPaymentsVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
@RestController
@RequestMapping("/api/admin/transactions/payments") // 이미지의 404 경로와 일치시킴
public class AdminPaymentsController {
    @Autowired
    private IAdminPaymentsService adminPaymentsService;
    // 통계 조회 (이미지의 /stats 대응)
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getStats() {
        return ResponseEntity.ok(adminPaymentsService.getAdminPaymentDashboard());
    }
    // 리스트 조회 (이미지의 /list 대응)
    @GetMapping("/list")
    public ResponseEntity<PaginationInfoVO<AdminPaymentsVO>> getPaymentsList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String searchWord,
            @RequestParam(required = false) String searchType) {

        PaginationInfoVO<AdminPaymentsVO> pagingVO = new PaginationInfoVO<>(10, 5);
        pagingVO.setCurrentPage(page);
        pagingVO.setSearchWord(searchWord);
        pagingVO.setSearchType(searchType);

        return ResponseEntity.ok(adminPaymentsService.getAdminPaymentsList(pagingVO));
    }
}