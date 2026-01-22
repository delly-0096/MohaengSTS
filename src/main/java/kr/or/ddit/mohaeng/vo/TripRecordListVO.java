package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class TripRecordListVO {
    private Long rcdNo;
    private String rcdTitle;
    private Date regDt;
    private Long memNo;          
    private String memId;        
    private Long viewCnt;
    private String openScopeCd;
    private Long likeCount;
    private Long commentCount;
    private Long bookmarkCount;
    private String locCd;
    private Long attachNo;
    private String coverPath; 
    private String nickname; 
    private String deleteYn;  	 
    private Long myLiked; 
    private String profilePath; 
    private String locName;
}
