package kr.or.ddit.mohaeng.login.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.captchaApi.service.ICaptchaAPIService;
import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.login.service.IMemberService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/")
public class LoginController {

	private static int CAPTCHA_THRESHOLD = 3;
	
	@Autowired
	private IMemberService memberService;
	
	@Autowired
	private ICaptchaAPIService captchaService;
	
	@Autowired
	private IMemberMapper memberMapper;
	
	/* 로그인 화면 */
	@GetMapping("/member/login")
	public String loginPage() {
		log.info("loginPage() 실행");
	    return "member/login"; // JSP 경로
	}
	
	/* 회원 로그인 기능 */
	// TODO: JWT 적용 시 session loginMember 제거 후 토큰 기반으로 교체
	@PostMapping("/member/login")
	public String login(@RequestParam String username,
						@RequestParam String password,
						@RequestParam String memberType,
						HttpSession session,
						HttpServletRequest request,
						HttpServletResponse response,
						RedirectAttributes ra
			) {
		log.info("login() 실행");
		
		
		Integer failCnt = (Integer) session.getAttribute("LOGIN_FAIL_CNT");
		if (failCnt == null) failCnt = 0;
		
		// CAPTCHA 검증
		if (failCnt >= CAPTCHA_THRESHOLD) {
		    boolean captchaOk = captchaService.verify(request);
		    log.info("captcha response = {}", captchaOk);

		    if (!captchaOk) {
		        ra.addFlashAttribute("needCaptcha", true);
		        ra.addFlashAttribute("errorMessage",
		            "보안 인증에 실패했습니다. 다시 시도해주세요.");
		        return "redirect:/member/login";
		    }
		}
		
		
		String memType = memberService.getMemberType(username);
		
		//존재하지 않는 로그인
		if(memType == null) {
			ra.addFlashAttribute("errorMessage", "입력하신 아이디로 가입된 회원이 없습니다.");
			ra.addFlashAttribute("memId", username);
			ra.addFlashAttribute("memberType", memberType);
			
			return "redirect:/member/login";
		}
		
		// 기업회원 승인 대기
		if("BUSINESS_NOT_APPROVED".equals(memType)) {
			ra.addFlashAttribute("errorMessage",
			        "기업회원 승인 대기 중입니다. <br> 관리자 승인 후 로그인할 수 있습니다.");

			return "redirect:/member/login";
		}
		
		// 회원 유형 불일치
		if(!memType.equals(memberType)) {
			ra.addFlashAttribute("errorMessage", "해당 회원의 유형이 일치하지 않습니다.");
			ra.addFlashAttribute("memId", username);
			ra.addFlashAttribute("memberType", memberType);
			
			return "redirect:/member/login";
		}
		
		
		// 비밀번호 불일치
		boolean passwordMatched = memberService.checkPassword(username, password);
		
		if (!passwordMatched) {

		    failCnt++;
		    session.setAttribute("LOGIN_FAIL_CNT", failCnt);

		    if (failCnt >= CAPTCHA_THRESHOLD) {
		        ra.addFlashAttribute("needCaptcha", true);
		        ra.addFlashAttribute("errorMessage", "비밀번호를 여러 번 틀렸습니다. <br> 보안 인증을 진행해주세요.");
		    } else {
		        ra.addFlashAttribute("errorMessage", "비밀번호가 올바르지 않습니다.");
		    }

		    ra.addFlashAttribute("memId", username);
		    ra.addFlashAttribute("memberType", memberType);
		    return "redirect:/member/login";
		}
		
	

		Map<String, Object> loginMember = new HashMap<>();
	    loginMember.put("memId", username);
	    loginMember.put("memType", memType);
	    loginMember.put("memName", username);
		
		session.setAttribute("loginMember", loginMember);
		session.removeAttribute("LOGIN_FAIL_CNT");
		
		var authorities = java.util.List.of(new SimpleGrantedAuthority("ROLE_" + memType));
		MemberVO member = memberMapper.selectById(username);
		CustomUserDetails userDetails = new CustomUserDetails(member);
		Authentication auth =
			    new UsernamePasswordAuthenticationToken(
			        userDetails,
			        null,
			        userDetails.getAuthorities()
			    );

	    SecurityContext context = SecurityContextHolder.createEmptyContext();
	    context.setAuthentication(auth);
	    SecurityContextHolder.setContext(context);

	    new HttpSessionSecurityContextRepository().saveContext(context, request, response);
		
		return "redirect:/";
	}
	
	/* 로그아웃 기능 */
	@GetMapping("/member/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		
		return "redirect:/";
	}
}

