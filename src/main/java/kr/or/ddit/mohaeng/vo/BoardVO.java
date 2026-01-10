package kr.or.ddit.mohaeng.vo;

import java.sql.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {
	
	private Integer boardNo;
	private String boardCtgryCd;
	private Integer writerNo;
	private Integer attachNo;
	
	private String boardTitle;
	private String boardContent;
	
	private Integer viewCnt;
	private Integer likeCnt;
	
	private String noticeYn;
	private String pinYn;
	private String delYn;
	private Date delDt;
	
	private Date regDt;
	private Date modDt;
	
	private List<BoardFileVO> boardFileList;
	
	
}
