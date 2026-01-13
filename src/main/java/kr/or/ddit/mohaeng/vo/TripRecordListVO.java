package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class TripRecordListVO {
    private Long rcdNo;
    private String rcdTitle;
    private Date regDt;
    private Long memNo;          // writer
    private String memId;        // writer id (username)
    private Long viewCnt;
    private String openScopeCd;

    private Long likeCount;
    private Long commentCount;
    private Long bookmarkCount;
    private String locCd;
    
    private Long attachNo;
    private String coverPath; // "/travellog/cover/....jpg"
    
    private String nickname; // MEM_USER.NICKNAME
    private String deleteYn;  	 // DELETE_YN
}
