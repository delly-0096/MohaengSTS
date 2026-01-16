package kr.or.ddit.mohaeng.community.travellog.record.dto;

import lombok.Data;

@Data
public class TripRecordBlockReq {
    // 공통
    private String id;       // data-block-id (문자열로도 들어올 수 있음)
    private String type;     // text/image/divider/day-header/place 등

    // text
    private String content;

    // image
    private String caption;
    private Integer fileIdx; // bodyFiles 배열에서 꺼낼 인덱스(프론트에서 넣어줘야 함)

    // day-header
    private String day;
    private String date;

    // place
    private String name;
    private String address;
    private String image;    // 장소 대표 이미지 URL(샘플/외부 URL이면 그냥 문자열로 저장)
}
