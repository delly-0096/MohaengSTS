package kr.or.ddit.mohaeng.file.service;

import java.io.File;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.file.mapper.IFileMapper;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.AttachFileVO;

public interface IFileService {

	/**
	 *	<p> 기업회원 가입시 파일 업로드 </p>
	 *	@date 2026.01.02
	 *	@author kdrs
	 *	@param bizFile 기업회원이 업로드 한 파일, memNo 기업회원 계정 no
	 *	@return 업로드 처리
	 */
	public int uploadBizFile(MultipartFile file, int memNo);

	/**
	 *	<p> 프로필 파일 저장 </p>
	 *	@date 2026.01.02
	 *	@author kdrs
	 *	@param profileImage 프로필 이미지 파일
	 * @param regId 
	 * @return 업로드 처리
	 */
	public int saveFile(MultipartFile profileImage, int regId);

	/**
	 * <p> 프로필 이미지 첨부파일 상세 조회 </p>
	 * @date 2025.01.02
	 * @author kdrs
	 * @param attachNo 첨부파일 고유 번호
	 * @return 프로필 이미지 첨부파일 상세 정보
	 */
	public void deleteProfileFile(int memNo);

	public AttachFileDetailVO getProfileFile(Integer attachNo);
}
