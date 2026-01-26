package kr.or.ddit.mohaeng.mypage.notifications.controller;

import java.util.Map;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.mypage.notifications.service.IAlarmService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/alarm")
public class AlarmApiController {

	    private final IAlarmService alarmService;

	    @GetMapping("/unread-count")
	    public int unreadCount(@AuthenticationPrincipal CustomUserDetails user) {
	    	int memNo= user.getMemNo();
	      return alarmService.getUnreadCount(memNo);
	    }

	    @PostMapping("/read")
	    public Map<String, Object> read(
	        @AuthenticationPrincipal CustomUserDetails user,
	        @RequestBody Map<String, Integer> body
	    ) {
	      int alarmNo = body.getOrDefault("alarmNo", 0);
	      boolean ok = alarmService.readOne(user.getMemNo(), alarmNo);
	      return Map.of("ok", ok);
	    }
	    @PostMapping("/test-insert")
	    public String testInsert(@AuthenticationPrincipal CustomUserDetails user){
	        alarmService.testInsert(user.getMemNo());
	        return "ok";
	    }

	  
}
