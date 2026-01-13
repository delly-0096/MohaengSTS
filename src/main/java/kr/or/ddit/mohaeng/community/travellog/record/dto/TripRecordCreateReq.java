package kr.or.ddit.mohaeng.community.travellog.record.dto;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.util.List;

@Data
public class TripRecordCreateReq {
	private Long rcdNo;
    private Long schdlNo;        // nullable
    private String rcdTitle;
    private String rcdContent;

    private String tripDaysCd;
    private String locCd;
    private Long attachNo;

    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date startDt;

    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date endDt;

    private String openScopeCd;  // PUBLIC/PRIVATE
    private String mapDispYn;    // Y/N
    private String replyEnblYn;  // Y/N
    
    private List<String> tags;
}
