package kr.or.ddit.mohaeng.login.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.login.service.IMemberService;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/")
public class LoginController {

	@Autowired
	private IMemberService memberService;
	
	/* 메인 화면 */
	@GetMapping("/")
	public String mainPage() {
		return "main/index";
		
	}
	
	/* 로그인 화면 */
	@GetMapping("/member/login")
	public String loginPage() {
	    return "member/login"; // JSP 경로
	}
	
	/* 로그인 기능 */
	// TODO: JWT 적용 시 session loginMember 제거 후 토큰 기반으로 교체
	@PostMapping("/member/login")
	public String login(@RequestParam String memId,
						@RequestParam String memPassword,
						HttpSession session
			) {
		
		String memType = memberService.getMemberType(memId);
		Map<String, Object> loginMember = new HashMap<>();
	    loginMember.put("memId", memId);
	    loginMember.put("memType", memType);
	    loginMember.put("memName", memId);
		
		
		session.setAttribute("loginMember", loginMember);
		
		return "redirect:/";
	}
	
	/* 로그아웃 기능 */
	@GetMapping("/member/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		
		return "redirect:/";
	}
}

