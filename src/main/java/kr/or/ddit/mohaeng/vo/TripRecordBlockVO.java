package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class TripRecordBlockVO {
    private int order;
    private String blockType;
    private String targetPk;

    // TEXT
    private String text;

    // IMAGE
    private Long attachNo;  
    private String desc;
    private String imgPath;

    // PLACE (리뷰)
    private String placeReviewNo;
    private Long plcNo;
    private Double rating;
    private String reviewConn;

    // PLACE (장소 정보)
    private String plcNm;
    private String plcAddr1;
    private String plcAddr2;
    private String defaultImg;
    private Long placeAttachNo;   
    private String placeImgPath;  
}