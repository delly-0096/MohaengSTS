package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class RegionVO {
    private Long rgnNo;       
    private String rgnNm;     
    private String rgnDetail; 
    private String rgnDesc;   
    private Long attachNo;    
    private String latitude;  
    private String longitude; 
    private String regId;     
    private String regDt;     
    private String modId;     
    private String modDt;     
    private String popRgnYn;  
    private String defaultImg;
}
