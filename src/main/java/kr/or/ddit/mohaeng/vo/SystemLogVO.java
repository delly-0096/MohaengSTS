package kr.or.ddit.mohaeng.vo;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class SystemLogVO {
	private Long systemLogNo;		// 시스템 로그 번호
    private String level;			// 로그레벨 - info, warn, error
    private String source;			// 로그 발생 파일 - controller, service
    private String msg;				// 로그메시지
    private String ip;				// 로그발생 ip
    private LocalDateTime regDt;	// 생성일시
    private Long systemLogMem;		// 로그 발생자
}
