package kr.or.ddit.mohaeng.adminLogin.controller.conn;

import java.time.Duration;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.adminLogin.dto.AdminLoginRequest;
import kr.or.ddit.mohaeng.adminLogin.service.IAdminService;
import kr.or.ddit.mohaeng.captchaApi.service.ICaptchaAPIService;
import kr.or.ddit.mohaeng.util.TokenProvider;
import kr.or.ddit.mohaeng.vo.AdminLoginVO;
import kr.or.ddit.mohaeng.vo.MemberAuthVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@CrossOrigin(origins = "http://localhost:7272",
		  allowCredentials = "true")
@RestController
@RequestMapping("/api/admin")
public class ConnetController {
	
	@Autowired
	private IAdminService adminService;
	
	@Autowired
	private ICaptchaAPIService captchaService;
	
	@Autowired
	private TokenProvider tokenProvider;

	@PostMapping("/login")
	public ResponseEntity<?> login (@RequestBody AdminLoginRequest req,
											HttpSession session
									) {
		
		log.info("login() 실행...!");
			
		Integer failCnt = (Integer) session.getAttribute("ADMIN_FAIL_CNT");
        if (failCnt == null) failCnt = 0;
        
		log.info("failCnt={}", failCnt);
		log.info("captchaToken={}", req.getCaptchaToken());
        
        // 실패 1회 이상이면 캡챠 검증
        if (failCnt >= 3 && req.getCaptchaToken() == null) {
        	return ResponseEntity.badRequest().body(Map.of(
        			"message", "보안 인증을 진행해주세요.",
        			"needCaptcha", true
        			));
        }
        
        if (failCnt >= 3) {
        	boolean captchaOk = captchaService.adminVerify(req.getCaptchaToken());
        	if (!captchaOk) {
        		return ResponseEntity.badRequest().body(Map.of(
        				"message", "보안 인증에 실패했습니다.",
        				"needCaptcha", true
        				));
        	}
        }
        
        boolean captchaOk = captchaService.adminVerify(req.getCaptchaToken());
        log.info("captchaOk={}", captchaOk);
        
        // 로그인 인증
        AdminLoginVO admin = adminService.login(
            req.getLoginId(),
            req.getPassword()
        );
        
        // 로그인 실패
        if (admin == null) {
        	session.setAttribute("ADMIN_FAIL_CNT", failCnt + 1);
        	return ResponseEntity.status(401).body(Map.of(
        			"message", "아이디 또는 비밀번호가 올바르지 않습니다.",
        			"needCaptcha", failCnt + 1 >= 1
        			));
        }
        
    	// 1. 권한 생성
        List<GrantedAuthority> authorities =
            List.of(new SimpleGrantedAuthority("ROLE_ADMIN"));

        // 2. Authentication 직접 생성
        UsernamePasswordAuthenticationToken authentication =
            new UsernamePasswordAuthenticationToken(
                admin.getMemId(),     // principal (보통 username)
                null,                 // credentials (이미 검증 끝)
                authorities
            );

        
        // 로그인 성공
        session.removeAttribute("ADMIN_FAIL_CNT");
        
        // memberVO == 로그인에 성공한 관리자 계정
        MemberVO member = new MemberVO();
        member.setMemId(admin.getMemId());
        member.setMemNo(admin.getMemNo());
        
        MemberAuthVO auth = new MemberAuthVO();
        auth.setAuth("ROLE_ADMIN");
        member.setAuthList(List.of(auth));
        
        String token = tokenProvider.generateToken(member, Duration.ofMinutes(30)); 
       
        Map<String, Object> body = new HashMap();
        body.put("access_token", token);
        body.put("tokenType", "Bearer ");
        body.put("department", admin.getDeptName());
        
        return ResponseEntity.ok(body);
    }
	
}
