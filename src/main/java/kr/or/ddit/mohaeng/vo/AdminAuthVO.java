package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AdminAuthVO {
	
	private int memNo;
	
	private int posiNo;
	private String deptName;
	
	// position - 관리자 권한
	private String posiName;
	private String posiDesc;
	private String auth;
	private String useYn;
}
