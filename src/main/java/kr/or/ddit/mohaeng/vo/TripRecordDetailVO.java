package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class TripRecordDetailVO {
    private Long rcdNo;
    private Long schdlNo;
    private Long memNo;
    private String memId;
    private String rcdTitle;
    private String rcdContent;
    private Long viewCnt;
    private String tripDaysCd;
    private String locCd;
    private Long attachNo;
    private Date regDt;
    private Date startDt;
    private Date endDt;
    private String openScopeCd;
    private String mapDispYn;
    private String replyEnblYn;
    private Long likeCount;
    private Long commentCount;
    private Long bookmarkCount;
    private Boolean liked;
    private Boolean bookmarked;
    private String coverPath; 
    private String nickname; 
    private String deleteYn;  	
    private Long myLiked;
    private String profilePath; 
    private String locName;
    private String tagName;
    public String getTagName() { return tagName; }
    public void setTagName(String tagName) { this.tagName = tagName; }
    private String schdlNm;
}
