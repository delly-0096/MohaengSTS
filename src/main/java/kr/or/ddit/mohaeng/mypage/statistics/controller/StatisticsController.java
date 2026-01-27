package kr.or.ddit.mohaeng.mypage.statistics.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import kr.or.ddit.mohaeng.mypage.statistics.service.IStatisticsService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.util.Params;

@Controller
public class StatisticsController {
	
	@Autowired
	IStatisticsService statisticsService;
//	
	@GetMapping("/mypage/business/statistics")
	public String Statistics(
			@AuthenticationPrincipal CustomUserDetails customUser
			) {
		
		int memNo = customUser.getMember().getMemNo();
		Params params = new Params();
		params.put("memNo", memNo);
//		
		List<Params> selectProdSg = statisticsService.selectProdSg(params);
		
		return "mypage/business/statistics";
	}
}
