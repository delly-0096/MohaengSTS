package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class MemCompVO {

	private int memNo; 					/* 회원키 */
	private String memCompTel; 			/* 기업회원 연락처 */
	private String memCompEmail; 		/* 기업회원 이메일 */
	private String masterYn; 			/* 관리자여부(Y,N) */
	private String aprvYn;				/* 승인상태(Y,N,NULL(대기)) */
	private String aprvDt;				/* 승인일시 */
	private String rejRsn; 				/* 반려사유 */
}
