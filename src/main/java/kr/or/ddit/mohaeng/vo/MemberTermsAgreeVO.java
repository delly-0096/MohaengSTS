package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class MemberTermsAgreeVO {

	private int agreeNo;              // 동의이력키
    private int memNo;                // 회원키
    private String useTermYn;         // 이용약관 동의 여부 (Y/N)
    private String privacyPolicyYn;   // 개인정보처리방침 동의 여부 (Y/N)
    private String locationTermYn;    // 위치 및 활동 규정 동의 여부 (Y/N)
    private String marketingYn;       // 마케팅 정보 수신 동의 여부 (Y/N)
    private Date regDt;               // 등록일자
    private Date udtDt;               // 수정일자
}
