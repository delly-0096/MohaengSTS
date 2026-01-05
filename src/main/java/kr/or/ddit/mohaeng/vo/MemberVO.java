package kr.or.ddit.mohaeng.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class MemberVO {

	private int memNo; 				/* 회원키 */
	private String memId; 			/* 로그인아이디 */
	private String memPassword; 	/* 비밀번호 */
	private String memName; 		/* 이름 */
	private String memEmail; 		/* 이메일 */
	private Integer memProfile; 		/* 프로필 */
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
	
	private List<MemberAuthVO> authList;	// 권한 정보
	
	private CompanyVO company;		/* 기업 정보 */
	private MemCompVO memComp;		/* 기업 회원 부가 정보 */
	private MemUserVO memUser;		/* 일반 회원 부가 정보 */
	private MemAdminVO admin;		/* 관리자 */

	private String memProfilePath;
	
}
