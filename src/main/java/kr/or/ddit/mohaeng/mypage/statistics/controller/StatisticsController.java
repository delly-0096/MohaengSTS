package kr.or.ddit.mohaeng.mypage.statistics.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

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
			@AuthenticationPrincipal CustomUserDetails customUser,
			Model model
			) {
		
		int memNo = customUser.getMember().getMemNo();
		Params params = new Params();
		params.put("memNo", memNo);
//		
		List<Params> prodSgList = statisticsService.selectProdSg(params);
		System.out.println("selectProdSg : " + prodSgList);
		
		model.addAttribute("prodSgList", prodSgList);
		
		return "mypage/business/statistics";
	}

	@PostMapping("/statistics/prodSgList")
	public ResponseEntity<?> searchStatistics(
			@AuthenticationPrincipal CustomUserDetails customUser,
			@RequestBody Map<String, Object> dataMap) {
		
		System.out.println("dataMap : " + dataMap);
		int memNo = customUser.getMember().getMemNo();
		Params params = new Params();
		params.put("memNo", memNo);
		if(dataMap.get("startDate") != null) {
			params.put("startDate", dataMap.get("startDate"));
			params.put("endDate", dataMap.get("endDate"));
		}
		
		List<Params> prodSgList = statisticsService.selectProdSg(params);
		
		return new ResponseEntity<List<Params>>(prodSgList,HttpStatus.OK);
	}
}
