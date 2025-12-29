package kr.or.ddit.mohaeng.adminLogin.controller.conn;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.adminLogin.dto.AdminLoginRequest;
import kr.or.ddit.mohaeng.adminLogin.service.IAdminService;
import kr.or.ddit.mohaeng.captchaApi.service.ICaptchaAPIService;
import kr.or.ddit.mohaeng.vo.AdminLoginVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@CrossOrigin(origins = "http://localhost:5175",
		  allowCredentials = "true")
@RestController
@RequestMapping("/api/admin")
public class ConnetController {
	
	@Autowired
	private IAdminService adminService;
	
	@Autowired
	private ICaptchaAPIService captchaService;

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

        
        // 로그인 성공
        session.removeAttribute("ADMIN_FAIL_CNT");
        session.setAttribute("ADMIN_LOGIN", admin.getMemId());
        
        Map<String, Object> body = new HashMap();
        body.put("loginId", admin.getMemId());
        body.put("name", admin.getMemName());
        body.put("role", admin.getAuth());
        body.put("department", admin.getDeptName());
        
        return ResponseEntity.ok(body);
    }
	
}
