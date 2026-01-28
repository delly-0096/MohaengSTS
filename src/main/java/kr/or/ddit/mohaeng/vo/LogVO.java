package kr.or.ddit.mohaeng.vo;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class LogVO {
	private Long logNo;				// 로그번호
    private String memNo;			// 회원 번호
    private String logType;			// 로그 유형
    private String logDesc;			// 활동 상세
    private String target;			// 대상 테이블
    private String targetId;		// 테이블 키값
    private String accessIp;		// 접속 ip
    private LocalDateTime regDt;	// 생성일시
}
