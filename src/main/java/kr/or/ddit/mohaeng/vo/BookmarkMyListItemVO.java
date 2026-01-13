package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class BookmarkMyListItemVO {
    private Long rcdNo;
    private String rcdTitle;
    private Long writerMemNo;
    private String writerName;    // 필요 없으면 쿼리에서 제외 가능
    private Date regDt;

    // 목록에 count 같이 보여주고 싶으면 사용 (원하면 쿼리에 포함)
    private Integer likeCount;
    private Integer commentCount;
    private Integer bookmarkCount;
}
