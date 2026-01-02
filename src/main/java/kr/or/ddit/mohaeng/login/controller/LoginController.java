package kr.or.ddit.mohaeng.login.controller;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.captchaApi.service.ICaptchaAPIService;
import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.login.service.IMemberService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.CompanyVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/member")
public class LoginController {

	private static int CAPTCHA_THRESHOLD = 3;

	@Autowired
	private IMemberService memberService;

	@Autowired
	private ICaptchaAPIService captchaService;

	@Autowired
	private IMemberMapper memberMapper;

	/* 로그인 화면 */
	@GetMapping("/login")
	public String loginPage() {
		log.info("loginPage() 실행...!");
	    return "member/login"; // JSP 경로
	}

	/* 회원 로그인 기능 */
	@PostMapping("/login")
	public String login(@RequestParam String username,
						@RequestParam String password,
						@RequestParam String memberType,
						HttpSession session,
						HttpServletRequest request,
						HttpServletResponse response,
						RedirectAttributes ra
			) {
		log.info("login() 실행...!");


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
		MemberVO member = memberMapper.selectById(username);

		Map<String, Object> loginMember = new HashMap<>();
	    loginMember.put("memId", username);
	    loginMember.put("memType", memType);
	    loginMember.put("memName", username);
	    loginMember.put("memNo", member.getMemNo());
	    loginMember.put("memEmail", member.getMemEmail());


		session.setAttribute("loginMember", loginMember);
//		session.setAttribute("memberInfo", member);
		session.removeAttribute("LOGIN_FAIL_CNT");

		var authorities = java.util.List.of(new SimpleGrantedAuthority("ROLE_" + memType));
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

	// 회원가입 화면
	@GetMapping("/register")
	public String registerPage(Model model) {
		log.info("registerPage() 실행...!");
		return "member/register";
	}

	// 일반 회원가입 기능
	@PostMapping("/register/member")
	public String registerMember(MemberVO memberVO, Model model, RedirectAttributes ra) {
		log.info("register() 실행...!");

		// 일반회원 가입
		String goPage = "";
		ServiceResult result = memberService.register(memberVO);

		if (result == ServiceResult.OK) {
		    ra.addFlashAttribute("successMessage", "회원가입이 완료되었습니다. 로그인 해주세요!");
		    ra.addFlashAttribute("memId", memberVO.getMemId());
		    goPage = "redirect:/member/login";
		} else {
		    model.addAttribute("errorMessage", "회원가입 중 오류가 발생했습니다.");
		    model.addAttribute("member", memberVO);
		    goPage = "member/register";
		}


		return goPage;
	}

	// 일반 회원가입 기능
	@PostMapping("/register/company")
	public String registerCompany(MemberVO memberVO, CompanyVO companyVO, MultipartFile bizFile,
							Model model, RedirectAttributes ra) {
		log.info("registerBusiness() 실행...!");

		// 일반회원 가입
		String goPage = "";
		ServiceResult result = memberService.registerCompany(memberVO, companyVO, bizFile);

		if (result == ServiceResult.OK) {
		    ra.addFlashAttribute("successMessage", "회원가입이 완료되었습니다. <br> 승인 후 로그인이 가능합니다.");
		    ra.addFlashAttribute("memId", memberVO.getMemId());
		    goPage = "redirect:/member/login";
		} else {
		    model.addAttribute("errorMessage", "가입 정보를 확인해주세요.");
		    model.addAttribute("member", memberVO);
		    model.addAttribute("company", companyVO);
		    goPage = "member/register";
		}


		return goPage;
	}

	// 아이디 중복확인
	@PostMapping("/idCheck")
	public ResponseEntity<ServiceResult> idCheck(@RequestBody Map<String, String> map) {
		log.info("idCheck() 실행...!");
		log.info("id : {}", map.get("memId"));
		ServiceResult result = memberService.idCheck(map.get("memId"));
		return new ResponseEntity<ServiceResult>(result, HttpStatus.OK);

	}

	// 아이디 & 비밀번호 찾기 화면
	@GetMapping("/find")
	public String findPage() {
		log.info("findPage() 실행...!");
	    return "member/find";
	}


	/* 로그아웃 기능 */
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();

		return "redirect:/";
	}
}

