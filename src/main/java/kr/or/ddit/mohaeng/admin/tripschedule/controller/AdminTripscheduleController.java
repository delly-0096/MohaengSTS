package kr.or.ddit.mohaeng.admin.tripschedule.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/admin/schedule")
public class AdminTripscheduleController {
	
	@PostMapping("/test")
	public ResponseEntity<?> test() {
		System.out.println("HELLO!!!!!!WORD!!!!!!");
		return ResponseEntity.ok(1);
	}
}
