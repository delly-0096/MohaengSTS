package kr.or.ddit.mohaeng.main;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class MainController {

	/* 메인 화면 */
	@GetMapping("/")
	public String mainPage() {
		return "main/index";
		
	}
	
	/* 내 정보 수정 */
	@GetMapping("/mypage/profile")
	public String myProfile() {
		return "mypage/profile";
	}
	

	
}
