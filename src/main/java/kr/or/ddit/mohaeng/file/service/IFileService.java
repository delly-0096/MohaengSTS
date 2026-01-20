package kr.or.ddit.mohaeng.file.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;

public interface IFileService {

	/**
	 *	<p> 범용 파일 저장하기 </p>
	 *	@date 2026.01.15
	 *	@author kdrs
	 *  @param files 업로드할 파일 리스트
	 *  @param subPath 저장될 하위 폴더 (예: "chat", "profile", "board")
	 *  @param fileGbCd 파일 분류 코드 (예: "CHAT", "PROFILE", "ATTACH")
	 *  @param regId 등록자 No
	 *  @return 생성된 attachNo
	 */
	public int saveFiles(List<MultipartFile> files, String subPath, String fileGbCd, int regId);
	
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
	 * <p> 프로필 이미지 첨부파일 삭제 </p>
	 * @date 2025.01.02
	 * @author kdrs
	 * @param memNo 첨부파일 고유 번호
	 */
	public void deleteProfileFile(int memNo);

	/**
	 * <p> 프로필 이미지 첨부파일 상세 조회 </p>
	 * @date 2026.01.02
	 * @author kdrs
	 * @param attachNo 첨부파일 고유 번호
	 * @return 프로필 이미지 첨부파일 상세 정보 (없을 경우 null)
	 */
	public AttachFileDetailVO getProfileFile(Integer attachNo);

	public int saveFileList(List<MultipartFile> files, Map<String, String> uploadInfo, int regId);
	
	/***
	 * @date 2026.01.15
	 * @author kjh
	 * @param file 단일 파일
	 * @param uploadInfo 업로드 정보(파일 경로 및 파일사용 테이블 : 접근 경로 = filePath, 파일 분류 = fileGbCd)
	 * @param regId(작성자 key)
	 * @return
	 */
	public int saveFile(MultipartFile file, Map<String, String> uploadInfo, int regId);
	
	/**
     * 첨부파일 상세 목록 조회
     */
	public List<AttachFileDetailVO> getAttachFileDetails(int attachNo);

	/**
     * 개별 파일 소프트 삭제
     */
	public int softDeleteFile(int attachNo, int fileNo);

	/**
     * 기존 ATTACH_NO에 파일 추가 (없으면 새로 생성)
     */
	public int addFilesToAttach(Integer attachNo, List<MultipartFile> files, String subPath, String fileGbCd, int regId);

}
