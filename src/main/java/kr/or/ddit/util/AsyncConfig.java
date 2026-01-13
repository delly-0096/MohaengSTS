package kr.or.ddit.util;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import java.util.concurrent.Executor;

@Configuration
@EnableAsync // 여기서 켜기 (메인 클래스 지저분해지니까)
public class AsyncConfig {

    @Bean(name="asyncTaskExecutor")
    public Executor asyncTaskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);   // 기본 스레드 5개
        executor.setMaxPoolSize(20);   // 최대 20개까지만 증가
        executor.setQueueCapacity(50); // 대기열 50개
        executor.setThreadNamePrefix("Tour-Async-");
        executor.initialize();
        return executor;
    }
}