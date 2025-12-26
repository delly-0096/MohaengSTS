package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class SystemLogVO {

	// SYSTEM_LOG 테이블
	
	private int systemLogNo;
	private String level;		// info, warn, error
	private String source;		// 발생지. 클래스명
	private String CLOB;		// 에러 메시지
	private String ip;			// ip 정보
	private Date regDt;			// 발생일
	private int SystemLogMem;	// 회원번호
}
