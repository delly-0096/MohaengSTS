package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor // 파라미터 없는 기본생성자
@AllArgsConstructor //모든 필드를 다 받는 생성자
public class CodeGroupVO {

	// CODE_GROUP 테이블
    private String cdgr;            // 코드그룹
    private String cdgrName;        // 코드그룹명
    private String cdgrDesc;        // 설명
    private Date udtDt;             // 수정일자
}
