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
    
    private Long myLiked; // 로그인한 일반회원이 이 글을 좋아요 했으면 1, 아니면 0
    
    private String profilePath; // 작성자 프로필 이미지 경로 ("/.../xxx.jpg")

}
