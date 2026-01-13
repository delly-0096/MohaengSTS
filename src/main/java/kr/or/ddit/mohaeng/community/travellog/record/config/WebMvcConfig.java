package kr.or.ddit.mohaeng.community.travellog.record.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${kr.or.ddit.upload.path}")
    private String uploadRoot;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String root = uploadRoot;
        if (!root.endsWith("/") && !root.endsWith("\\")) {
            root += "/";
        }

        registry.addResourceHandler("/files/**")
                .addResourceLocations("file:" + root)
                .setCachePeriod(3600);
    }
}
