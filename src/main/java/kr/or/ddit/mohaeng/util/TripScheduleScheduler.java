package kr.or.ddit.mohaeng.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.or.ddit.mohaeng.tripschedule.service.ITripScheduleService;
import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class TripScheduleScheduler {
	
	@Autowired
	ITripScheduleService tripScheduleService;
	
	@Scheduled(cron = "0 0 12 * * *")
    public void updateTripSchedule() {
//		tripScheduleService.tripSchedule
		log.info("실은 이시간에 스케쥴러가 돌고있습니다. 이 부분은 나중에 여행일정 업데이트 코드 들어갈 예정");
    }
}
