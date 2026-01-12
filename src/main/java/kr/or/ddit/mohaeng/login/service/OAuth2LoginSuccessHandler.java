package kr.or.ddit.mohaeng.login.service;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.mohaeng.security.CustomUserDetails;

@Component
public class OAuth2LoginSuccessHandler 
        extends SimpleUrlAuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication
    ) throws IOException, ServletException {

        CustomUserDetails user =
            (CustomUserDetails) authentication.getPrincipal();

        // 🔥 SNS 추가 정보 미완료
        if (!"Y".equals(user.getMember().getJoinCompleteYn())) {
            setDefaultTargetUrl("/member/login?social=required");
        } 
        // ✅ 정상 회원
        else {
            setDefaultTargetUrl("/");
        }

        super.onAuthenticationSuccess(request, response, authentication);
    }
}