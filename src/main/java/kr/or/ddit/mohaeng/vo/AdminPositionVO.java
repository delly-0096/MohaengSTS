package kr.or.ddit.mohaeng.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class AdminPositionVO {
	// 회원번호로 관리??
	private int memNo;
	
	// 직책
	private String posiCd;
	private String posiName;
	private String posiDesc;
	private String auth;
	private String useYn;
}
