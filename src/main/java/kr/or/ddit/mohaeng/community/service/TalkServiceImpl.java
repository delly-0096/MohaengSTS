package kr.or.ddit.mohaeng.community.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.community.mapper.ITalkMapper;
import kr.or.ddit.mohaeng.file.mapper.IFileMapper;
import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.vo.BoardFileVO;
import kr.or.ddit.mohaeng.vo.BoardTagVO;
import kr.or.ddit.mohaeng.vo.BoardVO;
import kr.or.ddit.mohaeng.vo.NoticeFileVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.TalkFileVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public  class TalkServiceImpl implements ITalkService{
		
        @Autowired
		private ITalkMapper iTalkMapper;
        
        @Autowired
        private IFileMapper iFileMapper;
        
        @Autowired
        private IFileService iFileService;
        
 
        
        @Value("${kr.or.ddit.mohaeng.upload.path}")
        private String uploadTalkPath;

		
        
        
        public BoardVO selectBoard(int boardNo) {  
        	iTalkMapper.incrementHit(boardNo); // 게시글 조회수 증가
        	return iTalkMapper.selectTalk(boardNo); // 게시글 번호에 해당하는 게시글 정보 가져오기
        }


		/*
		 * @Override public int selectBoardCount(PaginationInfoVO<BoardVO> pagingVO) {
		 * 
		 * return iTalkMapper.selectBoardCount(pagingVO); }
		 */
		
		//페이징이용
		@Override
		public List<BoardVO> selectTalkList(PaginationInfoVO<BoardVO> pagingVO) {

			return iTalkMapper.selectTalkList(pagingVO);
		}

		@Override
		public int selectTalkCount(PaginationInfoVO<BoardVO> pagingVO) {

			return iTalkMapper.selectTalkCount(pagingVO);
		}

	

		@Override
		public int updateTalk(BoardVO vo) {

		    // 1) 게시글 업데이트
		    int cnt = iTalkMapper.updateTalk(vo);

		    if (cnt > 0) {
		        // 2) 기존 태그 삭제 (mapper 필요)
		        iTalkMapper.deleteTalkTags(vo.getBoardNo());

		        // 3) 새 태그 등록
		        if (vo.getBoardTagList() != null && !vo.getBoardTagList().isEmpty()) {

		            List<BoardTagVO> tagList = new java.util.ArrayList<>();

		            for (BoardTagVO t : vo.getBoardTagList()) {
		                if (t == null) continue;
		                if (t.getBoardTagName() == null) continue;

		                String name = t.getBoardTagName().trim();
		                if (name.isEmpty()) continue;

		                BoardTagVO tagVO = new BoardTagVO();
		                tagVO.setBoardNo(vo.getBoardNo());
		                tagVO.setBoardTagName(name);

		                tagList.add(tagVO);
		            }

		            if (!tagList.isEmpty()) {
		                iTalkMapper.insertTalkTags(tagList);
		            }
		        }
		    }

		    return cnt;
		}

		@Override
		public int deleteTalk(int boardNo) {

			return iTalkMapper.deleteTalk(boardNo);
		}


		@Override
		public BoardFileVO getFileInfo(int fileNo) {
			return iTalkMapper.getFileInfo(fileNo);
		}


		/**
		 *글등록
		 */
		@Override
		public ServiceResult insertTalk(BoardVO vo) {
			ServiceResult result = null;
			
			if(vo.getBoardFile() != null) {
				Map<String, String> uploadInfo = new HashMap<>();
				
				uploadInfo.put("fileGbCd", "BOARD");
				uploadInfo.put("filePath", "/talk");
				
				int attachNo = iFileService.saveFileList(vo.getBoardFile(),uploadInfo,vo.getRegId());
				
				if(attachNo !=0) {
					vo.setAttachNo(attachNo);
				}
			}
			
			int status = iTalkMapper.insertTalk(vo);
			
			if(status !=0) {
				// 태그를 등록
				// vo안에 있는 boardNo, 태그들 꺼내서 게시판 태그 테이블에 등록
				if (vo.getBoardTagList() != null && !vo.getBoardTagList().isEmpty()) {

		            // 1) boardNo 주입 + 빈값 제거 + trim
		            List<BoardTagVO> tagList = new java.util.ArrayList<>();
		            for (BoardTagVO t : vo.getBoardTagList()) {
		                if (t == null) continue;
		                if (t.getBoardTagName() == null) continue;

		                String name = t.getBoardTagName().trim();
		                if (name.isEmpty()) continue;

		                BoardTagVO tagVO = new BoardTagVO();
		                tagVO.setBoardNo(vo.getBoardNo());
		                tagVO.setBoardTagName(name);
		                tagList.add(tagVO);
		            }

		            // 2) 실제 insert (mapper에 메서드 필요)
		            if (!tagList.isEmpty()) {
		                iTalkMapper.insertTalkTags(tagList); // ✅ 너희 mapper에 추가해야 함
		            }
		        }

		        result = ServiceResult.OK;
		    } else {
		        result = ServiceResult.FAILED;
		    }

		    return result;
		}
		
		
		private void boardfileUpload(List<BoardFileVO> boardFileList, int attachNo) throws Exception{
			if(boardFileList != null&&boardFileList.size()>0) {
				for(BoardFileVO boardFileVO: boardFileList) {
					if(boardFileVO.getItem().isEmpty()) {
						throw new IllegalAccessException("업로드 한 파일이 존재하지 않습니다.");
					}
					String saveName = UUID.randomUUID().toString()+"_" + boardFileVO.getFileName().replace("", "_");
					String saveLocate = uploadTalkPath + attachNo;
					File file = new File(saveLocate);
					if(!file.exists()) {// 업로드를 하기 위한 폴더 구조가 존재하지 않을때
						file.mkdirs();//폴더 생성
					}
					//업로드를 위한 완성된 경로 작성
					saveLocate += "/" +saveName;
					
					boardFileVO.setAttachNo(attachNo);     // 게시글 번호 설정
					boardFileVO.setFileSavepath(saveLocate); // 파일 업로드 경로 설정
					iFileMapper.insertAttachFile(null);
															//게시글 파일 데이터 추가
					
					File saveFile = new File(saveLocate);
					boardFileVO.getItem().transferTo(saveFile);//파일 복사
					
				}
			}
		 }

		@Override
		public int saveFileList(List<MultipartFile> boardFile, Map<String, String> uploadInfo, int int1) {

			return 0;
		}

		@Override
		public BoardVO selectTalk(int boardNo) {
			return iTalkMapper.selectTalk(boardNo);
		}


	
		

	


	

	

	
        
        
        
		
}
