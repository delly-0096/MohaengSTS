package kr.or.ddit.mohaeng.vo;

import java.util.Date;
import lombok.Data;

@Data
public class CommentsVO {

    // ===== DB columns =====
    private Long cmntNo;
    private String targetType;     // 'TRIP_RECORD'
    private Long targetNo;         // rcdNo
    private Long writerNo;         // member_no
    private Long parentCmntNo;     // null = 댓글, not null = 대댓글
    private String cmntContent;
    private int cmntStatus;    // 0:정상, 1:삭제(소프트삭제) 등
    private Date regDt;
    private Date modDt;

    // ===== View fields (join/derived) =====
    private String writerId;       // mem_id
    private String nickname;       // nickname
    private int depth;         // 0:댓글, 1:대댓글 (LEVEL-1)
    private int likeCount;     // 댓글 좋아요 수
    private int myLiked;       // 내가 좋아요 했는지(0/1)
    private int isWriter;      // 내가 작성자인지(0/1)
    
    private Long rootCmntNo;   // 최상위 부모 댓글 번호 (CONNECT_BY_ROOT)
    
 // ===== View fields (join/derived) =====
    private String profilePath;   // "/profiles/....jpg" 같은 파일 풀 경로(또는 경로+파일명)


}
