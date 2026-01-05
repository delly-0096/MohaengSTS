package kr.or.ddit.mohaeng.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class FileConfiguration implements WebMvcConfigurer{

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:///C:/mohaeng/upload/");
        WebMvcConfigurer.super.addResourceHandlers(registry);
        // 원래 file:/// < 슬래시가 3개여야 합니다
    }
}
