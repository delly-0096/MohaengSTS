package kr.or.ddit.mohaeng.community.travellog.comments.dto;

import lombok.Data;

@Data
public class CommentCreateReq {
    private String content;
    private Long parentCmntNo; // null이면 일반댓글, 값 있으면 대댓글
}
