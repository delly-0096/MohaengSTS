package kr.or.ddit.mohaeng.file.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class FileConfiguration implements WebMvcConfigurer{
	
	@Value("${kr.or.ddit.mohaeng.upload.path}")
    private String uploadPath;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:///" + uploadPath);
        WebMvcConfigurer.super.addResourceHandlers(registry);
        // 원래 file:/// < 슬래시가 3개여야 합니다
    }
}
