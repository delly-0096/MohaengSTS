package kr.or.ddit.mohaeng.config;

import java.util.List;

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
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

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
		http.cors(cors -> cors.configurationSource(corsConfigurationSource()))
			.csrf((csrf) -> csrf.disable())
			.formLogin((login) -> login.disable())
			.httpBasic((basic) -> basic.disable())
			.headers( 
					(config) -> config.frameOptions((fOpt) -> fOpt.sameOrigin())
			);
		
		http.sessionManagement(
				(management) -> management.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
			);
		http.addFilterBefore(new TokenAuthenticationFilter(tokenProvider), UsernamePasswordAuthenticationFilter.class);
		http.securityMatcher("/api/admin/**")
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
		
	    http.securityMatcher("/**")
        .authorizeHttpRequests(authorize ->
            authorize
                .dispatcherTypeMatchers(
                    DispatcherType.FORWARD,
                    DispatcherType.ASYNC
                ).permitAll()
                .requestMatchers(PASS_URL).permitAll()
                .requestMatchers("/member/login").permitAll()
                .anyRequest().authenticated()
        )
        .csrf(csrf -> csrf.disable())   // 일단 테스트용
        .formLogin(form -> form.disable())
        .httpBasic(hbasic -> hbasic.disable());

    http.exceptionHandling(exception ->
        exception.accessDeniedHandler(new CustomAccessDeniedHandler())
    );

    http.sessionManagement(session ->
        session.maximumSessions(1)
    );

    http.logout(logout ->
        logout.logoutUrl("/logout")
            .invalidateHttpSession(true)
            .logoutSuccessUrl("/member/login")
    );

    return http.build();
	}
	
	@Bean
	protected CorsConfigurationSource corsConfigurationSource() {
	    CorsConfiguration config = new CorsConfiguration();
	    config.setAllowedOrigins(List.of("http://localhost:7272"));
	    config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
	    config.setAllowedHeaders(List.of("*"));
	    config.setAllowCredentials(true);

	    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
	    source.registerCorsConfiguration("/**", config);
	    return source;
	    
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
