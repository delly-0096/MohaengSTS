package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class TripRecordVO {
    private Long rcdNo;          
    private Long schdlNo;        
    private Long memNo;          
    private String rcdTitle;     
    private String rcdContent;   
    private Long viewCnt;        
    private String tripDaysCd;   
    private String locCd;        
    private Long attachNo;       
    private Date regDt;          
    private Date startDt;        
    private Date endDt;          
    private String openScopeCd;  
    private String mapDispYn;    
    private String replyEnblYn;  
    private String deleteYn;  	 
}
