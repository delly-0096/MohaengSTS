package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ReportVO {

    private Long rptNo;         // RPT_NO
    private String mgmtType;    // MGMT_TYPE (REPORT/APPLY)
    private String targetType;  // TARGET_TYPE (TRIP_RECORD, COMMENT, ...)
    private Long targetNo;      // TARGET_NO
    private Long reqMemNo;      // REQ_MEM_NO
    private Long targetMemNo;   // TARGET_MEM_NO (optional)
    private String ctgryCd;     // CTGRY_CD
    private String content;     // CONTENT
    private String reqDt;       // REQ_DT (VARCHAR2)

    private String procStatus;  // PROC_STATUS (WAIT/PROCESS/DONE/REJECT)
    private String procResult;  // PROC_RESULT
    private Long procMemNo;     // PROC_MEM_NO
    private String prodDt;      // PROD_DT
    private String rejRsn;      // REJ_RSN
    private String adminMemo;   // ADMIN_MEMO

    private Date regDt;         // REG_DT (DATE)
    private Date modDt;         // MOD_DT (DATE)
}
