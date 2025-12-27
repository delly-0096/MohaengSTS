package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@NoArgsConstructor //기본생성자
@AllArgsConstructor //전체 생성자
public class FaqVO {

	private int faqNo;
	private String faqCategoryCd;
	private String faqTitle;
	private String faqContent;
	private int faqOrder;
	private String status;
	private String useYn;
	private String regId;
	private Date regDt;


}
