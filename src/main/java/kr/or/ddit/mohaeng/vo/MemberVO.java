package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class MemberVO {

	private int memNo; 				/* 회원키 */
	private String memId; 			/* 로그인아이디 */
	private String memPassword; 	/* 비밀번호 */
	private String memName; 		/* 이름 */
	private String memEmail; 		/* 이메일 */
	private int memProfile; 		/* 프로필 */
	private int point; 				/* 마일리지 */
	private String memStatus; 		/* 회원의 계정상태 */
	private String delYn;			/* 탈퇴여부 Y(삭제),  N(미삭제) */
	private String wdrwResn;		/* 탈퇴사유 */
	private int enabled; 			/* 계정사용여부 1(활성), 0(비활성) */
	private String memSnsYn; 		/* SNS로그인 가입여부 Y,  N */
	private String snsType; 		/* SNS 종류 */
	private String snsId; 			/* SNS에서 넘겨주는 고유 식별값 */
	private Date regDt; 			/* 가입일 */
	private Date udtDt; 			/* 수정일 */
	private Date wdrwDt; 			/* 탈퇴일 */
	
	public int getMemNo() {
		return memNo;
	}
	public void setMemNo(int memNo) {
		this.memNo = memNo;
	}
	public String getMemId() {
		return memId;
	}
	public void setMemId(String memId) {
		this.memId = memId;
	}
	public String getMemPassword() {
		return memPassword;
	}
	public void setMemPassword(String memPassword) {
		this.memPassword = memPassword;
	}
	public String getMemName() {
		return memName;
	}
	public void setMemName(String memName) {
		this.memName = memName;
	}
	public String getMemEmail() {
		return memEmail;
	}
	public void setMemEmail(String memEmail) {
		this.memEmail = memEmail;
	}
	public int getMemProfile() {
		return memProfile;
	}
	public void setMemProfile(int memProfile) {
		this.memProfile = memProfile;
	}
	public int getPoint() {
		return point;
	}
	public void setPoint(int point) {
		this.point = point;
	}
	public String getMemStatus() {
		return memStatus;
	}
	public void setMemStatus(String memStatus) {
		this.memStatus = memStatus;
	}
	public String getDelYn() {
		return delYn;
	}
	public void setDelYn(String delYn) {
		this.delYn = delYn;
	}
	public String getWdrwResn() {
		return wdrwResn;
	}
	public void setWdrwResn(String wdrwResn) {
		this.wdrwResn = wdrwResn;
	}
	public int getEnabled() {
		return enabled;
	}
	public void setEnabled(int enabled) {
		this.enabled = enabled;
	}
	public String getMemSnsYn() {
		return memSnsYn;
	}
	public void setMemSnsYn(String memSnsYn) {
		this.memSnsYn = memSnsYn;
	}
	public String getSnsType() {
		return snsType;
	}
	public void setSnsType(String snsType) {
		this.snsType = snsType;
	}
	public String getSnsId() {
		return snsId;
	}
	public void setSnsId(String snsId) {
		this.snsId = snsId;
	}
	public Date getRegDt() {
		return regDt;
	}
	public void setRegDt(Date regDt) {
		this.regDt = regDt;
	}
	public Date getUdtDt() {
		return udtDt;
	}
	public void setUdtDt(Date udtDt) {
		this.udtDt = udtDt;
	}
	public Date getWdrwDt() {
		return wdrwDt;
	}
	public void setWdrwDt(Date wdrwDt) {
		this.wdrwDt = wdrwDt;
	}

	
	
}
