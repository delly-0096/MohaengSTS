package kr.or.ddit.mohaeng.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class NoticeVO {
	
	private int ntcNo;					//공지사항 번호
	private String ntcTitle;			//공지사항 제목
	private String ntcContent;			//공지사항 내용
	private String regId;				//등록자
	private String regDt;				//등록일자
	private String ntcType;				//카테고리
	private int viewCnt;				//조회수
	private String status;				//삭제여부
	private int attachNo;				//첨부파일
	private String delYn;				//삭제여부
	private String delDt;				//삭제일

	//깃테스트
	//기존에 추가된 파일들 중, 삭제하겠다고 체크한 파일 번호가 저장될 필드

	private Integer[] delFileNo;
	//notice(1):noticeFile(n)의 관계성으로 1개의 게시글에 추가된 파일 목록을 관리
	private List<MultipartFile> ntcFile;
	private List<NoticeFileVO> noticeFileList; 
	private int fileCount; //게시글에 포함된
	/*
	 * private List<NoticeFileVO> noticeFileList; private int fileCount; //게시글에 포함된
	 * 파일 갯수
	 * 
	 * public void setNtcFile(MultipartFile[] ntcFile) { this.ntcFile = ntcFile;
	 * if(ntcFile != null) { List<NoticeFileVO> noticeFileList = new ArrayList<>();
	 * for(MultipartFile item:ntcFile) {
	 * if(StringUtils.isBlank(item.getOriginalFilename())) { continue; }
	 * NoticeFileVO noticeFileVO = new NoticeFileVO(item);
	 * noticeFileList.add(noticeFileVO); } this.noticeFileList=noticeFileList;
	 * 
	 * } }
	 */
	
	
	
	
	
	
	
	
	

}
