package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class TripRecordBlockVO {
    private Integer order;      // RCD_ORDER
    private String blockType;   // TEXT/IMAGE/DIVIDER
    private String targetPk;    // 지금은 TO_CHAR(RCD_CONN_NO) 들어있음

    // TEXT
    private String text;

    // IMAGE
    private String desc;
    private String imgPath;     // FILE_PATH
    // 필요하면 imgName도 추가 가능
}
