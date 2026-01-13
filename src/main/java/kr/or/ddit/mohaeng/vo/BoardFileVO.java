package kr.or.ddit.mohaeng.vo;

import org.apache.commons.io.FileUtils;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class BoardFileVO {
   
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
	private String fileGbCd;            
    private String mimeType;
    private int regId;
    private String regDt;
    private String useYn;
    
    public BoardFileVO() {
    	
    }
    
    public BoardFileVO(MultipartFile item) {
    	this.item = item;
    	this.fileName = item.getOriginalFilename();
    	this.fileSize = item.getSize();
    	this.mimeType = item.getContentType();
    	this.fileFancysize = FileUtils.byteCountToDisplaySize(fileSize);
    }
    
    public void setFileSize(long fileSize) {
    	this.fileSize = fileSize;
    	this.fileFancysize = FileUtils.byteCountToDisplaySize(fileSize);
    }
}
