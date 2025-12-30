package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AdminLoginVO {

	//Member
	private int memNo;
	private String memId;
	private String memPassword;
	private String memName;
	
	// Member_admin
	private Integer posiNo;
	private String deptName;
	
	// Member_auth
	private String auth;
}
