package kr.or.ddit.mohaeng.log.config;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.mohaeng.log.mapper.ILogMapper;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.SystemLogVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class LogAopConfig {

	// 로그 적용할 매퍼
	private final ILogMapper logMapper;

    /**
     * <p>에러로그남길것</p>
     * @author sdg
     * @date 2026-01-28
     * @param customUser memId받을 것
     * @param joinPoint
     * @return
     * @throws Throwable
     */
    @Around("execution(* kr.or.ddit.mohaeng..*Controller.*(..))")
    public Object loggingMaster(
    		ProceedingJoinPoint joinPoint) throws Throwable {

        // 1. 정보 수집 (어떤 클래스의 어떤 메서드인가?)
        String className = joinPoint.getTarget().getClass().getSimpleName(); // 예: AuthService
        String methodName = joinPoint.getSignature().getName();              // 예: login
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        String ip = request.getRemoteAddr();


        // 실제로 테스트 할때는 주석처리해야지 로그 쌓임
        int i = 0;
        if(i == 0) {
        	return joinPoint.proceed();
        }

        // searchRegionList 작업이 정상 처리되었습니다. - loginPage 작업이 정상 처리되었습니다.
        // 로그 안남길 메서드 정제 - mainPage 작업이 정상 처리되었습니다.
        if (methodName.equals("unreadCount") || methodName.equals("searchRegionList")
        		|| methodName.equals("mainPage") || methodName.equals("loginPage")) {
        	return joinPoint.proceed();
        }

        // method가 있는것

        String id = "GUEST";	// 사용자 id - 기본은 비회원
//        int memNo = customUser.getMember().getMemNo();	// 사용자 번호

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        log.info("auth : {}", auth);
        if (auth != null && auth.isAuthenticated()) {
            Object principal = auth.getPrincipal();

            // 시큐리티가 익명 사용자에게 주는 이름이 "anonymousUser"입니다.
            if (principal instanceof CustomUserDetails) {
                id = ((CustomUserDetails) principal).getMember().getMemId(); // 회원 ID
                log.info("auth id : {}", id);
            }
        }
        log.info("id : {}", id);


        SystemLogVO systemLogVO = new SystemLogVO();// 로그 담을 객체
        systemLogVO.setSystemLogMem(id);			// 클래스 사용자
        systemLogVO.setSource(className); 			// UI의 '소스' 항목으로 들어감
        systemLogVO.setIp(ip); // UI의 'IP' 항목
        log.info("db 넣기전 systemLogVo : {}", systemLogVO);

        Object result;
        try {
            result = joinPoint.proceed(); // 2. 실제 컨트롤러 기능 실행

            systemLogVO.setLevel("INFO");
            systemLogVO.setMsg(methodName + " (정상 수행)");
            logMapper.insertSystemLog(systemLogVO); // DB 저장!
            log.info("info 내용 주입 : {}", systemLogVO);
        } catch (Exception e) {
        	systemLogVO.setLevel("ERROR");
        	systemLogVO.setMsg("[" + methodName + "] 에러 발생: " + e.getMessage()); // 상세 에러 내용
            logMapper.insertSystemLog(systemLogVO); // DB 저장!
            log.error ("error 내용 주입 : {}", systemLogVO);
            throw e;
        }
        return result;
    }
}
