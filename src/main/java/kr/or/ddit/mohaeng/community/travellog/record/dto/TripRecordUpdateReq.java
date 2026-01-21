package kr.or.ddit.mohaeng.community.travellog.record.dto;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class TripRecordUpdateReq {
    private Long schdlNo;
    private String rcdTitle;
    private String rcdContent;

    private String tripDaysCd;
    private String locCd;
    private Long attachNo;

    private Date startDt;
    private Date endDt;

    private String openScopeCd;
    private String mapDispYn;
    private String replyEnblYn;
    
    private List<String> tags;
}
