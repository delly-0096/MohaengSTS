package kr.or.ddit.mohaeng.interceptor;

import java.util.Map;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class TempPasswordInterceptor implements HandlerInterceptor{

	public boolean preHandle(HttpServletRequest request,
							 HttpServletResponse response,
							 Object handler) throws Exception {
		
		HttpSession session = request.getSession(false);
		if(session == null) return true;
		
		@SuppressWarnings("unchecked")
		Map<String, Object> loginMember =
		(Map<String, Object>) session.getAttribute("loginMember");
		
		if(loginMember == null) return true;
		
		String tempPwYn = (String) loginMember.get("tempPwYn");
		
		// 임시 비밀번호 사용자가 아니면 통과
		if (!"Y".equals(tempPwYn)) {
			return true;
		}
		
		String requestUri = request.getRequestURI();
		
		// 허용 경로
		if (
			requestUri.startsWith("/mypage/profile/update") ||
			requestUri.startsWith("/member/logout") ||
			requestUri.startsWith("/error")
			) {
			return true;
		}
		
		response.sendRedirect("/mypage/profile/update");
		return false;
	}
}
