package kr.or.ddit.mohaeng.vo;

import java.util.Date;
import lombok.Data;

@Data
public class ReportVO {
    private Long rptNo;
    private String mgmtType;     
    private String targetType;   
    private Long targetNo;
    private Long reqMemNo;       
    private Long targetMemNo;    
    private String ctgryCd;      
    private String content;      
    private String reqDt;        
    private String procStatus;   
    private String procResult;
    private Long procMemNo;
    private String prodDt;
    private String rejRsn;
    private String adminMemo;
    private Date regDt;
    private Date modDt;
}
