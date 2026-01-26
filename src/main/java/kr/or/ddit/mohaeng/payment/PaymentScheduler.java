package kr.or.ddit.mohaeng.payment;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.or.ddit.mohaeng.payment.service.IPaymentService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class PaymentScheduler {
	
	@Autowired
    private IPaymentService service;
	
	// 매일 자정에 실행
    @Scheduled(cron = "0 0 0 * * *")
    public void updateSettleStatus() {
        int count = service.updateSettleStatus();
        log.info("정산상태 변경 완료: {}건", count);
    }
}
