package kr.or.ddit.mohaeng.util;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.or.ddit.mohaeng.tripschedule.service.ITripScheduleService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class TripScheduleScheduler {
	
	private final ChatClient chatClient;
	
	public TripScheduleScheduler(ChatClient.Builder builder) {
		this.chatClient = builder.build();
	}
	
	@Autowired
	ITripScheduleService tripScheduleService;
	
	@Scheduled(cron = "0 0 12 * * *")
    public void updateTripSchedule() {
		log.info("여행일정 상태가 갱신.");
		tripScheduleService.updateTripScheduleState();
		tripScheduleService.updateTourPlaceInfo();
		tripScheduleService.aiInsertStyleKeyword();
    }
	
	@Scheduled(cron = "0 26 11 * * *")
	public void updateTripSchedule2() {
		log.info("자동화 작업 테스트용 스케줄러");
//		tripScheduleService.matchLegalDongCode();
//		tripScheduleService.updateTourPlaceInfo();
//		tripScheduleService.updateDefaultImg();
//		tripScheduleService.aiInsertStyleKeyword();
	}
}
