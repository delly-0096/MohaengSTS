package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class AlarmVO {

	private int alarmNo;      /* 알림 번호 (PK) - SEQ_ALARM 사용 */
    private int memNo;        /* 수신자 회원번호 - 알림을 받을 사람 */
    private String sender;    /* 발신자 - 시스템 이름 */
    private String alarmType; /* 알림 유형 */
    private String alarmCont; /* 알림 내용 - 사용자에게 보여줄 메시지 */
    private String moveUrl;   /* 클릭 시 이동할 경로 (예: /mypage/inquiry/detail/12) */
    private String readYn;    /* 읽음 여부 - 'N' (안읽음), 'Y' (읽음) */
    private Date readDt;      /* 알림 확인 일시 - 사용자가 알림을 클릭한 시간 */
    private Date regDt;       /* 알림 생성 일시 */
}
