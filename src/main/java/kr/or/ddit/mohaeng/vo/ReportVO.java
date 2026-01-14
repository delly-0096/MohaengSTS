package kr.or.ddit.mohaeng.vo;

import java.util.Date;
import lombok.Data;

@Data
public class ReportVO {
    private Long rptNo;

    private String mgmtType;     // REPORT/APPLY
    private String targetType;   // TRIP_PROD, TRIP_RECORD, BOARD, COMMENT
    private Long targetNo;

    private Long reqMemNo;       // 신고자
    private Long targetMemNo;    // 대상자(선택)

    private String ctgryCd;      // 신고 사유
    private String content;      // 상세 내용

    private String reqDt;        // 문자열(yyyy-MM-dd HH:mm:ss)
    private String procStatus;   // WAIT/PROCESS/DONE/REJECT
    private String procResult;
    private Long procMemNo;
    private String prodDt;
    private String rejRsn;
    private String adminMemo;

    private Date regDt;
    private Date modDt;
}
