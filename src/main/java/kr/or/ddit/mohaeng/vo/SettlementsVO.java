package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class SettlementsVO {

	private int settleNo; /* 결산번호 */
	private int settlePay; /* 결산금액 */
	private Date settleDt; /* 결산일자(한달별로) */
}
