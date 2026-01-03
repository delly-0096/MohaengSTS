package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class MemUserVO {
	private int memNo; 					/* 회원키 */
	private String nickname; 			/* 닉네임 */
	private String birthDate; 			/* 생년월일 */
	private String gender; 				/* 성별 */
	private String zip; 				/* 우편번호 */
	private String addr1; 				/* 주소 */
	private String addr2; 				/* 상세주소 */
	private String tel; 				/* 전화번호 */
}
