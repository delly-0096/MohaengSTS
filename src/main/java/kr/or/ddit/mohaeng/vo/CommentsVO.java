package kr.or.ddit.mohaeng.vo;

import java.util.Date;
import lombok.Data;

@Data
public class CommentsVO {
    private Long cmntNo;
    private String targetType;   
    private Long targetNo;       
    private Long writerNo;       
    private Long parentCmntNo;   
    private String cmntContent;
    private int cmntStatus;    	
    private Date regDt;
    private Date modDt;
    private String writerId;     
    private String nickname;     
    private int depth;         
    private int likeCount;     
    private int myLiked;       
    private int isWriter;      
    private Long rootCmntNo;   
    private String profilePath;  
}
