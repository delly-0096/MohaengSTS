package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class RegionVO {
    private Long rgnNo;       // RGN_NO
    private String rgnNm;     // RGN_NM
    private String rgnDetail; // RGN_DETAIL
    private String rgnDesc;   // RGN_DESC

    private Long attachNo;    // ATTACH_NO
    private String latitude;  // LATITUDE
    private String longitude; // LONGITUDE

    private String regId;     // REG_ID
    private String regDt;     // REG_DT (테이블이 VARCHAR2라 String)
    private String modId;     // MOD_ID
    private String modDt;     // MOD_DT

    private String popRgnYn;  // POP_RGN_YN
    private String defaultImg; // DEFAULT_IMG
}
