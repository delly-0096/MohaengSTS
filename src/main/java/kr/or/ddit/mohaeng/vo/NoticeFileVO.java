package kr.or.ddit.mohaeng.vo;

import org.apache.commons.io.FileUtils;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class NoticeFileVO {
	
	private MultipartFile item;
	private int fileNo;
	private String fileName;
	private long fileSize;
	private String fileFancysize;
	private String fileSavepath;
	private int fileDowncount;
	private int attachNo;
	private String fileSaveName; // 임시저장파일장소
	private String fileOriginalName;
	private String fileExt;
    private String filePath;
	private String fileGbCd;            // NOTICE
    private String mimeType;
    private int regId;
    private String regDt;
    private String useYn;
    
    public NoticeFileVO() {
		
	}
	 
	public NoticeFileVO(MultipartFile item) {
		this.item = item;
		this.fileName = item.getOriginalFilename();  //원본명
		this.fileSize = item.getSize();  			//바이트 용량
		this.mimeType = item.getContentType();		//mime 타입	
		this.fileFancysize = FileUtils.byteCountToDisplaySize(fileSize); //보기좋게 변환
		
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
		this.fileFancysize = FileUtils.byteCountToDisplaySize(fileSize);
	}
	
	
	
}
