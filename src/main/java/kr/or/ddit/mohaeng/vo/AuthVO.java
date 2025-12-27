package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class AuthVO {
	// 권한
	private int memAuthNo;
	private int memNo;
	private String auth;
	private Date regDt;
}
