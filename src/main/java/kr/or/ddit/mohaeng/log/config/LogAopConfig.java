package kr.or.ddit.mohaeng.log.config;

import java.time.LocalDateTime;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.mohaeng.log.mapper.ILogMapper;
import kr.or.ddit.mohaeng.vo.LogVO;
import lombok.RequiredArgsConstructor;

@Aspect
@Component
@RequiredArgsConstructor
public class LogAopConfig {

	@Autowired
	private ILogMapper logMapper;

    /**
     * <p>에러로그남길것</p>
     * @author sdg
     * @date 2026-01-28
     * @param joinPoint
     * @return
     * @throws Throwable
     */
    @Around("execution(* kr.or.ddit.mohaeng..controller.*Controller.*(..))")
    public Object loggingMaster(ProceedingJoinPoint joinPoint) throws Throwable {
        
        // 1. 정보 수집 (어떤 클래스의 어떤 메서드인가?)
        String className = joinPoint.getTarget().getClass().getSimpleName(); // 예: AuthService
        String methodName = joinPoint.getSignature().getName();              // 예: login
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        
        LogVO vo = new LogVO();
//        vo.setSource(className); // UI의 '소스' 항목으로 들어감
        vo.setAccessIp(request.getRemoteAddr()); // UI의 'IP' 항목
        vo.setRegDt(LocalDateTime.now());

        Object result;
        try {
            result = joinPoint.proceed(); // 2. 실제 컨트롤러 기능 실행

            // 성공 로그 (INFO)
//            vo.setLevel("INFO");
//            vo.setMsg(methodName + " 작업이 정상 처리되었습니다.");
            logMapper.insertLog(vo); // DB 저장!

        } catch (Exception e) {
            // 3. 에러 발생 시 자동 감지 (ERROR)
//            vo.setLevel("ERROR");
//            vo.setMsg("[" + methodName + "] 에러 발생: " + e.getMessage()); // 상세 에러 내용
//            logMapper.insertSystemLog(vo); // DB 저장!
            throw e; 
        }

        return result;
    }
}
