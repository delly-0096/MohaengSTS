package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class AttachFileDetailVO {

	private int fileNo; /* 첨부파일상세고유키 */
	private int attachNo; /* 첨부파일고유키 */
	private String fileName; /* 첨부파일명 */
	private String fileOriginalName; /* 첨부파일원본명 */
	private String fileExt; /* 확장자 */
	private long fileSize; /* 사이즈 */
	private String filePath; /* 저장경로 */
	private String fileGbCd; /* 파일분류 */
	private String mimyType; /* 첨부파일  유형 */
	private String useYn; /* 사용여부(Y,N) */
	private int regId; /* 등록자 */
	private Date regDt; /* 등록일시 */
	
}
