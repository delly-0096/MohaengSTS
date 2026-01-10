package kr.or.ddit.mohaeng.file.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.AttachFileVO;
import kr.or.ddit.mohaeng.vo.NoticeFileVO;

@Mapper
public interface IFileMapper {

    

	/**
     * <p> 첨부파일 마스터 정보 등록 </p>
     * @date 2026.01.02
     * @author kdrs
     * @param attachVO 첨부파일 마스터 정보
     */
	public void insertAttachFile(AttachFileVO attachVO);

    /**
     * <p> 첨부파일 상세 정보 등록 </p>
     * @date 2026.01.02
     * @author kdrs
     * @param detailVO 첨부파일 상세 정보
     */
	public void insertAttachFileDetail(AttachFileDetailVO detailVO);

    /**
    * <p> 프로필 이미지 첨부파일 상세 조회 </p>
    * @date 2026.01.02
    * @author kdrs
    * @param attachNo 첨부파일 고유 번호
    * @return 프로필 이미지 첨부파일 상세 정보
    */
	public AttachFileDetailVO selectProfileFileDetail(Integer attachNo);

    /**
     * <p> 첨부파일 상세 정보 삭제 </p>
     * @date 2026.01.02
     * @author kdrs
     * @param attachNo 첨부파일 고유 번호
     */
	public void deleteAttachFileDetail(Integer attachNo);

    /**
     * <p> 첨부파일 마스터 정보 삭제 </p>
     * @date 2026.01.02
     * @author kdrs
     * @param attachNo 첨부파일 고유 번호
     */
	public void deleteAttachFile(Integer attachNo);
	
	/*
	 * 일반페이지 공지사항 파일목록 조회
	 */
	public List<NoticeFileVO> selectNoticeFileList(int attachNo);
	
}
