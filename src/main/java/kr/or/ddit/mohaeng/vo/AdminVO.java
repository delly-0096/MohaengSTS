package kr.or.ddit.mohaeng.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class AdminVO {
	// 회원번호로 관리??
	private int memNo;
	private String memId;
	private String memPassword; 
	private String memName;
	private String memEmail;
	
	private String memProfile;
	private int point;
	
	private String memStatus;
	private String delYn;		// 탈퇴 여부
	private String wdrwResn;	// 탈퇴이유
	private int enabled;		// 계정 활성화 여부
	
	private String memSnsYn;
	private String snsType;
	private String snsId;
	
	private Date regDt;
	private Date udtDt;
	private Date wdrwDt;	// 탈퇴일
	
	
	// 관리자용
	private int posiNo;
	private String deptName;
	
	
	private List<AdminAuthVO> authList;
	
	// 직책
//	private String posiCd;
//	private String posiName;
//	private String posiDesc;
//	private String auth;
//	private String useYn;
}
