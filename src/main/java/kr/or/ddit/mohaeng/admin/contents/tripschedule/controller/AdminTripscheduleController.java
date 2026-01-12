package kr.or.ddit.mohaeng.admin.contents.tripschedule.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.admin.contents.tripschedule.service.IAdminTripscheduleService;
import kr.or.ddit.util.Params;


@CrossOrigin(origins = "http://localhost:7272", allowCredentials = "true")
@RestController
@RequestMapping("/api/admin/schedule")
public class AdminTripscheduleController {
	
	@Autowired
	IAdminTripscheduleService tripscheduleService;
	
	@PostMapping("/list")
	public ResponseEntity<Map<String, Object>> list(@RequestBody(required = false) Params params) {
		
		ResponseEntity<Map<String, Object>> entity = null;
		Map<String, Object> resultMap = new HashMap<>();
//		ServiceResult result = blogService.signup(memberVO);
		List<Params> adminScheduleList = tripscheduleService.selectAdminScheduleList();
		System.out.println("adminScheduleList : " + adminScheduleList);
		resultMap.put("scheduleList", adminScheduleList);
		entity = new ResponseEntity<>(resultMap, HttpStatus.OK);
		
//		entity = new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		
		return entity;
	}
}
