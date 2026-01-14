package kr.or.ddit.mohaeng.tour;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.or.ddit.mohaeng.tour.service.ITripProdService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class TripProdScheduler {
	
	@Autowired
    private ITripProdService service;

    // 매일 자정에 실행
    @Scheduled(cron = "0 0 0 * * *")
    public void updateExpiredProducts() {
        int count = service.updateExpiredStatus();
        log.info("만료된 상품 {}개 판매중지 처리 완료", count);
    }
}
