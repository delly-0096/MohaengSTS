package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class LikesVO {
    private int likesKey;        
    private String likesCatCd;    
    private int memNo;
    private boolean status;
}
