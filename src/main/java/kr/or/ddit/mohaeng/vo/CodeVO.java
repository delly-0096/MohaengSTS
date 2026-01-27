package kr.or.ddit.mohaeng.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor // 파라미터 없는 기본생성자
@AllArgsConstructor //모든 필드를 다 받는 생성자
public class CodeVO {

	private String cd;     // 코드
	private String cdgr;   // 코드그룹
	private String cdName; // 코드명
	private String cdDesc; // 코드설명
	private String cdYn;   // 사용여부(Y,N)
	private String regId;  // 등록자
	private String regDt;  // 등록일자
	private String udtId;  // 수정자
	private String udtDt;  // 수정일자

}
