package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class CommentsVO {
    private Long cmntNo;
    private String targetType;     // "TRIP_RECORD"
    private Long targetNo;         // rcdNo
    private Long writerNo;         // memNo
    private Long parentCmntNo;     // null이면 원댓글, 있으면 대댓글(1단계)
    private String cmntContent;
    private Integer cmntStatus;    // 0:정상, 1:삭제, 2:신고(예시)
    private String regDt;          // VARCHAR2(30)
    private String modDt;          // VARCHAR2(20)

    // 목록 출력용(조인 컬럼 - DB컬럼 아님)
    private String writerName;
}
