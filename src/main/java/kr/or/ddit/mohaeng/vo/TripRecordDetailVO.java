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

    // 로그인 사용자 기준 상태(비로그인/기업회원이면 false로 내려도 됨)
    private Boolean liked;
    private Boolean bookmarked;
    
    private String coverPath; // "/travellog/cover/....jpg"

    private String nickname; // MEM_USER.NICKNAME
    private String deleteYn;  	 // DELETE_YN
    
    private Long myLiked;

}
