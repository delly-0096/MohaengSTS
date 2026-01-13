package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class BookmarkVO {
    private Long bmkNo;
    private String bmkType;   // 'TRIP_RECORD'
    private Long memNo;
    private Long prdtNo;      // 여행기록 RCD_NO를 여기 넣어 재사용
    private Date regDt;
    private String delYn;
    private Date delDt;
}