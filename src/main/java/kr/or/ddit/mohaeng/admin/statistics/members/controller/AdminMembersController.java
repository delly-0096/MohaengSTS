package kr.or.ddit.mohaeng.admin.statistics.members.controller;

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

import kr.or.ddit.mohaeng.admin.statistics.members.service.IAdminMembersService;
import kr.or.ddit.util.Params;

@CrossOrigin(origins = "http://localhost:7272", allowCredentials = "true")
@RestController
@RequestMapping("/api/admin/members")
public class AdminMembersController {
	
	@Autowired
	IAdminMembersService membersService;
	
	@PostMapping("/summary")
	public ResponseEntity<Map<String, Object>> summary(@RequestBody(required = false) Params params) {
		
		ResponseEntity<Map<String, Object>> entity = null;
		Map<String, Object> resultMap = new HashMap<>();
		
//		ServiceResult result = blogService.signup(memberVO);
		
		Params summary = membersService.summary(params);
//		System.out.println("adminScheduleList : " + adminScheduleList);
//		resultMap.put("scheduleList", adminScheduleList);
		
		entity = new ResponseEntity<>(summary, HttpStatus.OK);
		
//		entity = new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		
		return entity;
	}
	
	@PostMapping("/growth")
	public ResponseEntity<List<Params>> growth(@RequestBody(required = false) Params params) {
		
		ResponseEntity<List<Params>> entity = null;
		Map<String, Object> resultMap = new HashMap<>();
		
//		ServiceResult result = blogService.signup(memberVO);
		
		List<Params> growth = membersService.growth(params);
//		System.out.println("adminScheduleList : " + adminScheduleList);
//		resultMap.put("scheduleList", adminScheduleList);
		
		entity = new ResponseEntity<List<Params>>(growth, HttpStatus.OK);
		
//		entity = new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		
		return entity;
	}
	
	@PostMapping("/hwyhbp")
	public ResponseEntity<Params> hwyhbp(@RequestBody(required = false) Params params) {
		
		ResponseEntity<Params> entity = null;
		Map<String, Object> resultMap = new HashMap<>();
		
		Params hwyhbp = membersService.hwyhbp(params);
		
		entity = new ResponseEntity<Params>(hwyhbp, HttpStatus.OK);
		
		return entity;
	}
	
	@PostMapping("/ibdgij")
	public ResponseEntity<Params> ibdgij(@RequestBody(required = false) Params params) {
		
		ResponseEntity<Params> entity = null;
		Map<String, Object> resultMap = new HashMap<>();
		
		Params ibdgij = membersService.ibdgij(params);
		
		entity = new ResponseEntity<Params>(ibdgij, HttpStatus.OK);
		
		return entity;
	}
	
	@PostMapping("/jybbp")
	public ResponseEntity<List<Params>> jybbp(@RequestBody(required = false) Params params) {
		
		ResponseEntity<List<Params>> entity = null;
		Map<String, Object> resultMap = new HashMap<>();
		
		List<Params> jybbp = membersService.jybbp(params);
		
		entity = new ResponseEntity<List<Params>>(jybbp, HttpStatus.OK);
		
		return entity;
	}
	
	@PostMapping("/yrdbbp")
	public ResponseEntity<List<Params>> yrdbbp(@RequestBody(required = false) Params params) {
		
		ResponseEntity<List<Params>> entity = null;
		Map<String, Object> resultMap = new HashMap<>();
		
		List<Params> yrdbbp = membersService.yrdbbp(params);
		
		entity = new ResponseEntity<List<Params>>(yrdbbp, HttpStatus.OK);
		
		return entity;
	}
	
	@PostMapping("/cggihw")
	public ResponseEntity<List<Params>> cggihw(@RequestBody(required = false) Params params) {
		
		ResponseEntity<List<Params>> entity = null;
		Map<String, Object> resultMap = new HashMap<>();
		
		List<Params> cggihw = membersService.cggihw(params);
		
		entity = new ResponseEntity<List<Params>>(cggihw, HttpStatus.OK);
		
		return entity;
	}
}
