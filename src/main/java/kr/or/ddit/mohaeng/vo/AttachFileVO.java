package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class AttachFileVO {

	private int attachNo; 		/* 첨부파일상세고유키 */
	private int regId; 			/* 등록자 아이디 */
	private String regDt; 		/* 등록일시 */
}
