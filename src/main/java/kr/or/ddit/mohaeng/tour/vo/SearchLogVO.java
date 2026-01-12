package kr.or.ddit.mohaeng.tour.vo;

import java.util.Date;

import lombok.Data;

@Data
public class SearchLogVO {
    private int searchLogNo;
    private String keyword;
    private Date regDt;
    
    // 집계
    private int searchCount;
}
