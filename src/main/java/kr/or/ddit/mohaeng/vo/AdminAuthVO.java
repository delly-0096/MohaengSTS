package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AdminAuthVO {
	
	private int memNo;
	private String posiCd;
	private String posiName;
	private String posiDesc;
	private String auth;
	private String useYn;
}
