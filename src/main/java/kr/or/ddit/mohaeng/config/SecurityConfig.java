package kr.or.ddit.mohaeng.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.security.servlet.PathRequest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import jakarta.servlet.DispatcherType;
import kr.or.ddit.mohaeng.filter.TokenAuthenticationFilter;
import kr.or.ddit.mohaeng.security.CustomAccessDeniedHandler;
import kr.or.ddit.mohaeng.security.CustomLoginFailureHandler;
import kr.or.ddit.mohaeng.security.CustomLoginSuccessHandler;
import kr.or.ddit.mohaeng.security.CustomUserDetailsService;
import kr.or.ddit.mohaeng.util.TokenProvider;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {
	
	@Autowired
	private CustomUserDetailsService customUserDetailsService;
	
	@Autowired
	private TokenProvider tokenProvider;
	
	// 허용 url test
	private static final String[] PASS_URL = {
			"/",
			"/member/login",
			"/error",
			"/mohaeng",
			"/.well-known/**"		// 크롬 개발자 도구로의 요청
	};
	
	
	// 허용할 리엑트 요청 url 테스트용
	private static final String[] REACT_PASS_URL = {
			"/api/admin/login"

		};
	
	SecurityConfig(TokenProvider tokenProvider, CustomUserDetailsService customUserDetailsService) {
		this.tokenProvider = tokenProvider;
		this.customUserDetailsService = customUserDetailsService;
	}

	// 정적 리소스 허용
	@Bean
	public WebSecurityCustomizer configure() {
		return (web) -> web.ignoring()
				.requestMatchers(PathRequest.toStaticResources().atCommonLocations())
				.requestMatchers("/resources/**");	// 정적 리소스
	}
	
	// 시큐리티 체인 - react 처리용
	@Order(1)
	@Bean
	protected SecurityFilterChain filterChainReact(HttpSecurity http) throws Exception {
		http.csrf((csrf) -> csrf.disable());
		http.formLogin((login) -> login.disable());
		http.httpBasic((basic) -> basic.disable());
		http.headers( 
				(config) -> config.frameOptions((fOpt) -> fOpt.sameOrigin())
		);
		
		http.sessionManagement(
				(management) -> management.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
			);
		http.addFilterBefore(new TokenAuthenticationFilter(tokenProvider), UsernamePasswordAuthenticationFilter.class);
		http.securityMatcher("/api/react/**")
			.authorizeHttpRequests(
			(authorize) -> 
				authorize.dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ASYNC).permitAll()
						.requestMatchers(REACT_PASS_URL).permitAll()
						.anyRequest().authenticated()
		);
		return http.build();
	}
	
	// 
	@Order(2)
	@Bean
	protected SecurityFilterChain filterChainSession(HttpSecurity http) throws Exception {
		// csrf 토큰 보내기
		// 로그인 페이지에 <sec:csrfInput/>이거 계속 담기
		
		// 세션 기반으로 동작할 필터 체인의 1차 방어선
		http.securityMatcher("/**")
				.authorizeHttpRequests(
					(authorize) -> 
						authorize.dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ASYNC).permitAll()
								.requestMatchers(PASS_URL).permitAll()
								.anyRequest().authenticated()
					);

		http.exceptionHandling((exception) -> exception.accessDeniedHandler(new CustomAccessDeniedHandler()));
		
		// 7. 사용자 정의 로그인 페이지
		http.httpBasic((hbasic) -> hbasic.disable());
		http.formLogin(
			(login) -> login.loginPage("/member/login")
							.loginProcessingUrl("/member/login")
							.successHandler(new CustomLoginSuccessHandler())	// 로그인 성공 처리자
							.failureHandler(new CustomLoginFailureHandler())	// 로그인 실패 처리자
		);
		
		http.sessionManagement(session->session.maximumSessions(1));	// 최대 접근 세션 개수
		
		http.logout(
			(logout) -> logout.logoutUrl("/logout")
								.invalidateHttpSession(true)	// 로그아웃 시, session 삭제
								.logoutSuccessUrl("/member/login")
								// .deleteCookies("JSESSION_ID", "remember-me")	// 로그아웃 시, 쿠키 삭제
		);
		
		return http.build();
	}
	
	@Bean
	protected AuthenticationManager authenticationManager(
			BCryptPasswordEncoder bCryptPasswordEncoder
			) {
		DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
		authProvider.setUserDetailsService(customUserDetailsService);
		authProvider.setPasswordEncoder(bCryptPasswordEncoder);
		return new ProviderManager(authProvider);
	}
	
	
	@Bean
	protected PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
}
