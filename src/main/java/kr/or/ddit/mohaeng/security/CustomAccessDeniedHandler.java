package kr.or.ddit.mohaeng.security;

import java.io.IOException;
import java.security.Principal;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.access.AccessDeniedHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler {
	
	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		
		 Authentication auth = SecurityContextHolder.getContext().getAuthentication();

	        // 인증 자체가 없으면 로그인으로
	        if (auth == null || !auth.isAuthenticated()) {
	            response.sendRedirect("/member/login");
	            return;
	        }

	        Object principal = auth.getPrincipal();

	        // CustomUserDetails가 아닐 경우 (익명 등)
	        if (!(principal instanceof CustomUserDetails)) {
	            response.sendRedirect("/accessError");
	            return;
	        }

	        CustomUserDetails userDetails = (CustomUserDetails) principal;
	        var member = userDetails.getMember();

	        log.warn("⛔ AccessDenied 발생 - memId={}, uri={}",
	                member.getMemId(), request.getRequestURI());

	        // 🔥 SNS 회원 + 가입 미완성 → SNS 완료 페이지로 강제 이동
	        if ("Y".equals(member.getMemSnsYn())
	                && "N".equals(member.getJoinCompleteYn())) {

	            log.info("➡ SNS 미완성 회원 접근 차단 → /member/sns/complete");
	            response.sendRedirect("/member/sns/complete");
	            return;
	        }

	        // 그 외 권한 문제
	        response.sendRedirect("/accessError");
	}

}
