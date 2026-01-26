package kr.or.ddit.mohaeng.main;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.tripschedule.service.ITripScheduleService;
import kr.or.ddit.mohaeng.vo.TripScheduleVO;

@Controller
@RequestMapping("/")
public class MainController {
	
	@Autowired
	ITripScheduleService tripScheduleService;

	/* 메인 화면 */
	@GetMapping("/")
	public String mainPage() {
		return "main/index";
	}
	
	/* 내 일정 */
	@ResponseBody
	@GetMapping("/api/schedule/list")
	public List<TripScheduleVO> getScheduleList(
			@AuthenticationPrincipal CustomUserDetails user
			) {
		if (user == null) return null;
		
		// 현재 로그인한 사용자의 일정 리스트를 가져와서 리턴
	    int memNo = user.getMember().getMemNo();
	    return tripScheduleService.selectTripScheduleList(memNo);
	}
	

	
}
