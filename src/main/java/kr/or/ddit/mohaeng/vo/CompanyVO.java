package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class CompanyVO {

	private int compNo; 			/* 회사키 */
	private int memNo; 				/* 회원키 */
	private String brno; 			/* 사업자등록번호 */
	private String prmmiMnno; 		/* 통신판매업 신고번호 */
	private String bzmnNm; 			/* 상호명 */
	private String rprsvNm;		    /* 대표자 성명 */
	private String rprsvEmladr; 	/* 대표자 이메일 */
	private String compZip; 		/* 회사우편번호 */
	private String compAddr1; 		/* 회사주소 */
	private String compAddr2; 		/* 회사 상세주소 */
	private String compUrl; 		/* 회사홈페이지주소 */
	private String compTel; 		/* 회사연락처 */
	private String bankCd; 			/* 정산은행 */
	private String depositor; 		/* 예금주 */
	private String accountNo; 		/* 계좌정보 */
	private int compBizFile; 		/* 사업자 등록증 파일 */
	private String industryCd; 		/* 업종 */
	private String compIntro; 		/* 기업 소개 */
}
