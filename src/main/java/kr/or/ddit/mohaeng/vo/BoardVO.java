package kr.or.ddit.mohaeng.vo;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class BoardVO {
	
	private Integer boardNo;

	private String boardCtgryCd;
	private int writerNo;
	private int attachNo;
	
	private String boardTitle;
	private String boardContent;
	
	private int viewCnt;
	private int likeCnt;
	
	private String noticeYn;
	private String pinYn;
	private String delYn;
	private Date delDt;
	
	private Date regDt;
	private Date modDt;
	private int regId;
	private String modId;

	
	private List<BoardTagVO> boardTagList;
	private List<BoardFileVO> boardFileList;
	private List<MultipartFile> boardFile;
	
	// 작성자 정보
	private String writerId;        // MEM_USER.MEM_ID
	private String writerNickname; // MEMBER.NICKNAME
}
