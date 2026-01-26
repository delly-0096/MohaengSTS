package kr.or.ddit.mohaeng.file.controller;

import java.io.FileInputStream;
import java.io.InputStream;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.BoardFileVO;

@Controller
@RequestMapping("/file")
public class FileController {
	
    @Value("${file.upload-path}")
    String uploadPath;
	
	@Autowired
	IFileService fileService;
	
	
	@ResponseBody
	@GetMapping("/searchthumbnail")
	public ResponseEntity<byte[]> searchThumbnail(String path) {
    	InputStream in = null;
    	ResponseEntity<byte[]> entity = null;
    	
    	try {
			//파일 확장자에 알맞는 mediaType가져오기
    		MediaType mType = MediaType.IMAGE_JPEG;
    		HttpHeaders headers = new HttpHeaders();
    		
    		in = new FileInputStream(uploadPath + "/" + path);
    		headers.setContentType(mType);
    		entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in),headers,HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		}finally {
			try {
				in.close();
			} catch (Exception e) {
//			   e.printStackTrace();
			}
		}
		
		return entity;
	}
	
}
