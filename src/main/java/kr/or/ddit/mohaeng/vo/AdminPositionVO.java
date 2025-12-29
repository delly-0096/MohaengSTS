package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AdminPositionVO {
	
	// position - 관리자 권한
	private int posiNo;
	private String posiCd;
	private String posiName;
	private String posiDesc;
	private String auth;
	private String useYn;
	
	
}
