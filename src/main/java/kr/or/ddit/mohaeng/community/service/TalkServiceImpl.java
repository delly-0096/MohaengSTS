package kr.or.ddit.mohaeng.community.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.community.mapper.ITalkMapper;
import kr.or.ddit.mohaeng.file.mapper.IFileMapper;
import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.vo.BoardVO;

@Service
public class TalkServiceImpl implements ITalkService{
		
        @Autowired
		private ITalkMapper iTalkMapper;
        
        @Autowired
        private IFileMapper iFileMapper;
        
        @Autowired
        private IFileService iFileService;
        
        @Value("${file.upload-notice-path}")
        private String uploadNoticePath;
        
        
        public BoardVO selectTalkList(int boardNo) {
        	iTalkMapper.incrementHit(boardNo); // 게시글 조회수 증가
        	return iTalkMapper.selectTalkList(boardNo); // 게시글 번호에 해당하는 게시글 정보 가져오기
        }


		@Override
		public List<BoardVO> selectTalkList() {
			// TODO Auto-generated method stub
			return null;
		}
        
        
        
		
}
