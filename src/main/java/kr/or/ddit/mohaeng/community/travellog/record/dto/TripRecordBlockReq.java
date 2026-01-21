package kr.or.ddit.mohaeng.community.travellog.record.dto;

import lombok.Data;

@Data
public class TripRecordBlockReq {
    // 공통
    private String id;       // data-block-id (문자열로도 들어올 수 있음)
    private String type;     // TEXT/IMAGE/PLACE/DIVIDER
    private int order;

    // text
    private String content;

    // image
    private String caption;
    private int fileIdx; // bodyFiles 배열에서 꺼낼 인덱스(프론트에서 넣어줘야 함)

    // PLACE
    private Long plcNo;
    private int day;
    private String date;
    private String name;
    private String address;
    private String image;
    private Double rating;
    
    private Long attachNo;
}
