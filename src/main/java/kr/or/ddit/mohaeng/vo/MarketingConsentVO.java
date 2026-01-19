package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class MarketingConsentVO {

	private int memNo;               // 회원번호
    private String emailConsentYn;   // 이메일 수신 동의 여부
    private String smsConsentYn;     // SMS 수신 동의 여부
    private String pushConsentYn;    // 푸시 알림 수신 동의 여부
    private Date udtDt;              // 수정일자
}
