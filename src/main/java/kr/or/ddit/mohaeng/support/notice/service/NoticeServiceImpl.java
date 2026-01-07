package kr.or.ddit.mohaeng.support.notice.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.file.mapper.IFileMapper;
import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.support.notice.mapper.INoticeMapper;
import kr.or.ddit.mohaeng.vo.NoticeFileVO;
import kr.or.ddit.mohaeng.vo.NoticeVO;
import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor 
@Transactional
public class NoticeServiceImpl  implements INoticeService{
	
    @Autowired
	private IFileMapper iFileMapper;
	
	@Autowired
	private INoticeMapper noticeMapper;
	
	@Autowired
	private IFileService iFileService;
	
	
	@Value("${file.upload-notice-path}")
	private String uploadNoticePath;
	
	/*
	 * 공지사항 게시판 1페이지
	 */
	
	
	/*
	 * List 1페이지 공지사항 게시글 번호에 해당하는 게시글
	 */
	@Override
	public NoticeVO selectNotice(int ntcNo) {
		noticeMapper.incrementHit(ntcNo); // 게시글 조회수 증가
		return noticeMapper.selectNotice(ntcNo); //게시글 번호에 해당하는 게시글 정보 가져오기
	}

	@Override
	public List<NoticeVO> selectNoticeList() {
		
		return noticeMapper.selectNoticeList();
	}
	
	//관리자 등록
	
	

	//관리자 인서트 등록
	@Override
	public ServiceResult insertNotice(NoticeVO noticeVO) throws Exception{
		ServiceResult result = null;
		
		if(noticeVO.getNtcFile() != null) {
			Map<String, String> uploadInfo = new HashMap<>(); 
			
			uploadInfo.put("fileGbCd", "NOTICE");
			uploadInfo.put("filePath", "/notice");
			
			int attachNo = iFileService.saveFileList(noticeVO.getNtcFile(), uploadInfo, Integer.parseInt(noticeVO.getRegId()));
			
			if(attachNo != 0) {
				noticeVO.setAttachNo(attachNo);
			}
		}
		
		int status = noticeMapper.insertNotice(noticeVO);
		
		if(status != 0) {
			//등록성공
			//게시글 안에 저장되어 넘어온 데이터를 업로드
			result = ServiceResult.OK;
		} else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	private void noticefileUpload(List<NoticeFileVO> noticeFileList, int attachNo) throws Exception{
		if(noticeFileList != null&&noticeFileList.size()>0) {
			for(NoticeFileVO noticefileVO: noticeFileList) {
				if(noticefileVO.getItem().isEmpty()) {
					throw new IllegalAccessException("업로드 한 파일이 존재하지 않습니다.");
				}
				String saveName = UUID.randomUUID().toString()+"_" + noticefileVO.getFileName().replace("", "_");
				String saveLocate = uploadNoticePath + attachNo;
				File file = new File(saveLocate);
				if(!file.exists()) {// 업로드를 하기 위한 폴더 구조가 존재하지 않을때
					file.mkdirs();//폴더 생성
				}
				//업로드를 위한 완성된 경로 작성
				saveLocate += "/" +saveName;
				
				noticefileVO.setAttachNo(attachNo);     // 게시글 번호 설정
				noticefileVO.setFileSavepath(saveLocate); // 파일 업로드 경로 설정
				iFileMapper.insertAttachFile(null);   //게시글 파일 데이터 추가
				
				File saveFile = new File(saveLocate);
				noticefileVO.getItem().transferTo(saveFile);//파일 복사
				
			}
		}
		

	}

	@Override
	public int updateNotice(NoticeVO noticeVO) {
		return noticeMapper.updateNotice(noticeVO);
		
	}

	@Override
	public int deleteNotice(int ntcNo) {
		
		return noticeMapper.deleteNotice(ntcNo);
		
	}

	@Override
	public NoticeFileVO getFileInfo(int fileNo) {
		return noticeMapper.getFileInfo(fileNo);
	}


}
 