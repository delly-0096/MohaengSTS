package kr.or.ddit.mohaeng.config;

import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import kr.or.ddit.mohaeng.interceptor.TempPasswordInterceptor;

public class WebMvcConfig implements WebMvcConfigurer {

	private final TempPasswordInterceptor tempPasswordInterceptor;

    public WebMvcConfig(TempPasswordInterceptor tempPasswordInterceptor) {
        this.tempPasswordInterceptor = tempPasswordInterceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(tempPasswordInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/resources/**",
                        "/upload/**",
                        "/css/**",
                        "/js/**",
                        "/images/**"
                );
    }
}