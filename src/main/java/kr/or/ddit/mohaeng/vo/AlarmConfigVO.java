package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class AlarmConfigVO {

	private int memNo;           // 회원키
    private String rsvtAlarmYn;  // 예약 확정/취소 알림 (이메일) 체크 여부
    private String schdAlarmYn;  // 여행 일정 리마인드 알림 (이메일) 체크 여부
    private String commAlarmYn;  // 커뮤니티 댓글/답글 알림 (이메일) 체크 여부
    private String pntAlarmYn;   // 포인트 적립/사용 알림 (이메일) 체크 여부
    private String qnaAlarmYn;   // 문의 답변 알림 (이메일) 체크 여부
    private Date udtDt;			 // 수정일자

}
