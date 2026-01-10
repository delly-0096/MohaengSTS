package kr.or.ddit.mohaeng.login.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.RememberMeServices;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.rememberme.TokenBasedRememberMeServices;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
	private RememberMeServices rememberMeServices;

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


	    String profilePath = member.getMemProfilePath();

	    loginMember.put("tempPwYn", member.getTempPwYn());
	   
	    if (profilePath != null) {
	        // 텍스트에서 /resources 부분을 제거하여 /upload/... 만 남김
	        profilePath = profilePath.replace("/resources", "");
	    }
	    loginMember.put("memProfile", profilePath);


		session.setAttribute("loginMember", loginMember);
		session.removeAttribute("LOGIN_FAIL_CNT");
	
		// 회원 타입에 따라 권한 생성
		List<GrantedAuthority> authorities = new ArrayList<>();

		/*
		 * if ("BUSINESS".equals(memType)) { authorities.add(new
		 * SimpleGrantedAuthority("BUSINESS")); } else { authorities.add(new
		 * SimpleGrantedAuthority("MEMBER")); }
		 */
		CustomUserDetails userDetails =
		        new CustomUserDetails(member);

		// Authentication 생성
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

	    String rememberMe = request.getParameter("remember-me");

	    if ("on".equals(rememberMe)) {
	        // 시큐리티의 Remember-Me 서비스를 수동으로 호출하여 토큰을 생성하고 DB에 저장
	        rememberMeServices.loginSuccess(request, response, auth);
	        log.info("Remember-Me 토큰 생성 및 DB 저장 완료");
	    }

	    
	    // 임시 비밀번호 로그인 여부 확인
	    if ("Y".equals(member.getTempPwYn())) {
	        ra.addFlashAttribute(
	            "warningMessage",
	            "임시 비밀번호로 로그인하셨습니다. 비밀번호를 반드시 변경해주세요."
	        );
	        return "redirect:/mypage/profile"; // 내 정보 수정 페이지
	    }
		
		return "redirect:/";
	}

	/* 회원가입 화면 */
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
  
	/* 기업 회원가입 기능*/
	@PostMapping("/register/company")
	public String registerCompany(MemberVO memberVO, CompanyVO companyVO, MultipartFile bizFile,
							Model model, RedirectAttributes ra) {
		log.info("registerBusiness() 실행...!");

		// 기업회원 가입
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

	/* 아이디 중복 확인 */
	@PostMapping("/idCheck")
	public ResponseEntity<ServiceResult> idCheck(@RequestBody Map<String, String> map) {
		log.info("idCheck() 실행...!");
		log.info("id : {}", map.get("memId"));
		ServiceResult result = memberService.idCheck(map.get("memId"));
		return new ResponseEntity<ServiceResult>(result, HttpStatus.OK);

	}

	/* 아이디 비밀번호 찾기 화면 */
	@GetMapping("/find")
	public String findPage() {
		log.info("findPage() 실행...!");
	    return "member/find";
	}

	/* 아이디 찾기 */
	@PostMapping("/find/id")
	@ResponseBody
	public ResponseEntity<String> findId(@RequestBody MemberVO memberVO) {
		ResponseEntity<String> entity = null;
		
		String foundId = memberService.findIdProcess(memberVO);
		
		if(foundId != null) {
			String maskedId = foundId.replaceAll("(?<=.{2}).", "*");
			entity = ResponseEntity.ok(maskedId);
		} else {
			entity = ResponseEntity.badRequest().build();
		}
		
		return entity;
		
	}
	
	/* 비밀번호 찾기 */
	@PostMapping("/find/password")
	@ResponseBody
	public ResponseEntity<String> findPassword(@RequestBody MemberVO memberVO) {

		boolean isValid = memberService.findPasswordProcess(memberVO);

	    if (isValid) {
	    	try {
	        memberService.sendPasswordResetMail(memberVO);
	        return ResponseEntity.ok("임시 비밀번호를 이메일로 발송했습니다. 로그인 후 비밀번호를 변경해주세요.");
	    	} catch(Exception e) {
	    		return ResponseEntity.internalServerError().body("메일 발송 중 오류가 발생했습니다.");
	    	}
	    	
	    } else {
	    	// 사용자 정보 불일치 시
	        return ResponseEntity.badRequest().body("입력하신 정보가 일치하지 않습니다.");
	    }
	}
	
	/* 로그아웃 기능 */
	@GetMapping("/logout")
	public String logout(HttpServletRequest request, HttpServletResponse response, Authentication auth) {
		if (auth != null) {
	        // 시큐리티 로그아웃 핸들러 실행 (세션 삭제 등)
	        new SecurityContextLogoutHandler().logout(request, response, auth);

	        // 자동 로그인 토큰 삭제 (DB 및 쿠키)
	        rememberMeServices.loginFail(request, response);
	        log.info("로그아웃 완료: 자동 로그인 토큰 및 쿠키 삭제");
	    }
	    return "redirect:/";
	}
}
