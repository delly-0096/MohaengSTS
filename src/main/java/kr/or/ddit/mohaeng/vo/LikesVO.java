package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class LikesVO {
    private Long likesKey;        // 대상키 (RCD_NO)
    private String likesCatCd;    // 'TRIP_RECORD'
    private Long memNo;
}
