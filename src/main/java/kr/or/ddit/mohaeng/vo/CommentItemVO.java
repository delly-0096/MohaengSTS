package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class CommentItemVO {
    private Long cmntNo;
    private String targetType;
    private Long targetNo;

    private Long writerNo;
    private String writerId;   // MEMBER.MEM_ID 조인해서 보여주기

    private Long parentCmntNo;

    private String cmntContent;
    private Integer cmntStatus;

    private String regDt;
    private String modDt;

    // 화면용
    private Integer depth;     // 0=댓글, 1=대댓글
    private Integer childCount;
}
