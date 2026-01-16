package kr.or.ddit.mohaeng.vo;

import java.util.List;

import lombok.Data;

@Data
public class CommentVO {
	

	    private int cmntNo;
	    private String targetType;     // 'TALK' 고정으로 쓸 거면 String 유지
	    private int targetNo;          // = boardNo
	    private int writerNo;
	    private Integer parentCmntNo;  // null 가능
	    private String cmntContent;
	    private int cmntStatus;
	    private String regDt;          // 너 ERD가 VARCHAR라면 String, DATE로 바꾸면 Date/LocalDateTime 추천
	    private String modDt;
	    
	    
	    int commentNo;
	    String commentContent;
	    String writerNickname;
	    

	    List<CommentVO> replyList; // 대댓글
	    
	    // ✅ DB 컬럼 아님 (계층 조회 결과)
	    private int depth;
	}



