package kr.or.ddit.mohaeng.file.service;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.file.mapper.IFileMapper;
import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.AttachFileVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FileServiceImpl implements IFileService{

	@Autowired
	private IFileMapper fileMapper; // ATTACH 관련 매퍼
	
	@Autowired
	private IMemberMapper memberMapper;
	
	@Value("${kr.or.ddit.mohaeng.upload.path}") // 설정파일(properties)에 정의된 저장 경로
    private String uploadPath;
	
	/**
	 *	<p> 기업회원 가입시 파일 업로드 </p>
	 *	@date 2026.01.02
	 *	@author kdrs
	 *	@param bizFile 기업회원이 업로드 한 파일, memNo 기업회원 계정 no
	 *	@return 업로드 처리
	 */
	@Override
	@Transactional
	public int uploadBizFile(MultipartFile bizFile, int memNo) {
		if (bizFile == null || bizFile.isEmpty()) return 0;

	    try {
	        // 1. ATTACH_FILE 마스터
	        AttachFileVO attachVO = new AttachFileVO();
	        attachVO.setRegId(memNo);
	        fileMapper.insertAttachFile(attachVO);
	        int attachNo = attachVO.getAttachNo();

	        // 2. 파일 정보
	        String originalName = bizFile.getOriginalFilename();
	        String ext = originalName.substring(originalName.lastIndexOf(".") + 1);
	        String saveName = UUID.randomUUID().toString() + "." + ext;

	        File target = new File(uploadPath + "biz/" + saveName);
	        if (!target.getParentFile().exists()) {
	            target.getParentFile().mkdirs();
	        }

	        // 3. 물리적 저장
	        bizFile.transferTo(target);

	        // 4. ATTACH_FILE_DETAIL
	        AttachFileDetailVO detailVO = new AttachFileDetailVO();
	        detailVO.setAttachNo(attachNo);
	        detailVO.setFileName(saveName);
	        detailVO.setFileOriginalName(originalName);
	        detailVO.setFileExt(ext);
	        detailVO.setFileSize(bizFile.getSize());
	        detailVO.setFilePath("/biz/" + saveName); // 서버 접근 경로
	        detailVO.setFileGbCd("ATTACH");   // 기업 첨부
	        detailVO.setRegId(memNo);

	        fileMapper.insertAttachFileDetail(detailVO);

	        return attachNo;
	    } catch (Exception e) {
	        throw new RuntimeException("파일 업로드 처리 중 에러 발생", e);
	    }
    }

	/**
	 *	<p> 프로필 파일 저장 </p>
	 *	@date 2026.01.02
	 *	@author kdrs
	 *	@param profileImage 프로필 이미지 파일
	 *	@return 업로드 처리
	 */
	@Override
	public int saveFile(MultipartFile file, int regId) {
		if (file == null || file.isEmpty()) return 0;
		
		// ATTACH_FILE (마스터)
		AttachFileVO attachVO = new AttachFileVO();
        attachVO.setRegId(regId); 	// 쿼리의 #{regId}와 매칭
        fileMapper.insertAttachFile(attachVO);
		int attachNo = attachVO.getAttachNo();
		
		// 물리적 파일 저장 준비
		String originalName = file.getOriginalFilename();
		String ext = originalName.substring(originalName.lastIndexOf(".") + 1);
		String saveName = UUID.randomUUID().toString() + "." + ext;	// 파일명 중복 방지
		
		File target = new File(uploadPath + "profile/", saveName);
		if (!target.getParentFile().exists()) {
		    target.getParentFile().mkdirs(); 
		}
		
		try {
			// 물리적 파일 저장
			file.transferTo(target);
			
			// ATTACH_FILE_DETAIL
			AttachFileDetailVO detailVO = new AttachFileDetailVO();
            detailVO.setAttachNo(attachNo);
            detailVO.setFileName(saveName); 								// #{fileName}
            detailVO.setFileOriginalName(originalName); 					// #{fileOriginalName}
            detailVO.setFileExt(ext); 										// #{fileExt}
            detailVO.setFileSize(file.getSize()); 							// #{fileSize}
            detailVO.setFilePath("/profile/" + saveName); 					// 서버 접근 경로 #{filePath}
            detailVO.setFileGbCd("PROFILE"); 								//  파일 분류 fileGbCd
            detailVO.setMimyType(file.getContentType()); 					// #{mimyType}
            detailVO.setRegId(regId); 										// #{regId}
			
            fileMapper.insertAttachFileDetail(detailVO);
		} catch (IOException e) {
            log.error("파일 저장 중 오류 발생: {}", e.getMessage());
            throw new RuntimeException("파일 저장 실패", e);
        }

        return attachNo; // 생성된 마스터 번호 반환
		
	}

	/**
	 * <p> 프로필 파일 삭제 </p>
	 * @date 2026.01.02
	 * @author kdrs
	 * @param memNo 프로필 이미지가 있는 회원 NO
	 * @return 이미지 삭제 처리
	 */
	@Override
	@Transactional
	public void deleteProfileFile(int memNo) {
		
		// 회원의 프로필 첨부파일 번호 조회
		Integer attachNo = memberMapper.selectProfileAttachNo(memNo);
	    if (attachNo == null) return;
	    AttachFileDetailVO detail = fileMapper.selectProfileFileDetail(attachNo);

	    // 실제 파일 삭제
	    if (detail != null && detail.getFileName() != null) {
	        // uploadPath(C:/upload) + 파일명 또는 상대경로
	        File file = new File(uploadPath, detail.getFileName()); 
	        if (file.exists()) {
	            file.delete();
	            log.info("물리 파일 삭제 성공: {}", file.getAbsolutePath());
	        }
	    }

	    // 4. 첨부파일 상세 삭제
	    fileMapper.deleteAttachFileDetail(attachNo);

	    // 5. 첨부파일 마스터 삭제
	    fileMapper.deleteAttachFile(attachNo);

	    // 6. 회원 테이블의 프로필 연결 해제
	    memberMapper.clearMemberProfile(memNo);
		
	}

	/**
	 * <p> 프로필 이미지 첨부파일 상세 조회 </p>
	 * @date 2026.01.02
	 * @author kdrs
	 * @param attachNo 첨부파일 고유 번호
	 * @return 프로필 이미지 첨부파일 상세 정보 (없을 경우 null)
	 */
	@Override
	public AttachFileDetailVO getProfileFile(Integer attachNo) {
	    if (attachNo == null) {
	        return null;
	    }
	    return fileMapper.selectProfileFileDetail(attachNo);
	}
	
	
	@Override
	public int saveFileList(List<MultipartFile> files, Map<String, String> uploadInfo, int regId) {
		if (files == null || files.isEmpty()) return 0;
		
		// ATTACH_FILE (마스터)
		AttachFileVO attachVO = new AttachFileVO();
        attachVO.setRegId(regId); 	// 쿼리의 #{regId}와 매칭
        fileMapper.insertAttachFile(attachVO);
		int attachNo = attachVO.getAttachNo();
		
		for(MultipartFile file : files) {
			// 물리적 파일 저장 준비
			String originalName = file.getOriginalFilename();
			String ext = originalName.substring(originalName.lastIndexOf(".") + 1);
			String saveName = UUID.randomUUID().toString() + "." + ext;	// 파일명 중복 방지
			
			File target = new File(uploadPath + uploadInfo.get("filePath"), saveName);
			if (!target.getParentFile().exists()) {
			    target.getParentFile().mkdirs(); 
			}
			
			try {
				// 물리적 파일 저장
				file.transferTo(target);
				
				// ATTACH_FILE_DETAIL
				AttachFileDetailVO detailVO = new AttachFileDetailVO();
	            detailVO.setAttachNo(attachNo);
	            detailVO.setFileName(saveName); 								// #{fileName}
	            detailVO.setFileOriginalName(originalName); 					// #{fileOriginalName}
	            detailVO.setFileExt(ext); 										// #{fileExt}
	            detailVO.setFileSize(file.getSize()); 							// #{fileSize}
	            detailVO.setFilePath(uploadInfo.get("filePath")  +"/" + saveName); 	// 서버 접근 경로 #{filePath}
	            detailVO.setFileGbCd(uploadInfo.get("fileGbCd")); 								//  파일 분류 fileGbCd
	            detailVO.setMimyType(file.getContentType()); 					// #{mimyType}
	            detailVO.setRegId(regId); 										// #{regId}
				
	            fileMapper.insertAttachFileDetail(detailVO);
			} catch (IOException e) {
	            log.error("파일 저장 중 오류 발생: {}", e.getMessage());
	            throw new RuntimeException("파일 저장 실패", e);
	        }
		}
        return attachNo; // 생성된 마스터 번호 반환
		
	}
}
