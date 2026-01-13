package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class TripRecordVO {
    private Long rcdNo;          // RCD_NO
    private Long schdlNo;        // SCHDL_NO (nullable)
    private Long memNo;          // MEM_NO
    private String rcdTitle;     // RCD_TITLE
    private String rcdContent;   // RCD_CONTENT (CLOB) -> String
    private Long viewCnt;        // VIEW_CNT
    private String tripDaysCd;   // TRIP_DAYS_CD
    private String locCd;        // LOC_CD
    private Long attachNo;       // ATTACH_NO
    private Date regDt;          // REG_DT
    private Date startDt;        // START_DT
    private Date endDt;          // END_DT
    private String openScopeCd;  // OPEN_SCOPE_CD
    private String mapDispYn;    // MAP_DISP_YN
    private String replyEnblYn;  // REPLY_ENBL_YN
    private String deleteYn;  	 // DELETE_YN
}
