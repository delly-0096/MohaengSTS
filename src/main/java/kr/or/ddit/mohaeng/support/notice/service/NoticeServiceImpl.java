package kr.or.ddit.mohaeng.support.notice.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.support.notice.mapper.INoticeMapper;
import kr.or.ddit.mohaeng.vo.NoticeVO;

@Service
public class NoticeServiceImpl  implements INoticeService{
	
	@Autowired
	 private INoticeMapper noticeMapper;
	
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
		// TODO Auto-generated method stub
		return noticeMapper.selectNoticeList();
	}

	//관리자 인서트 등록
	@Override
	public int insertNotice(NoticeVO noticeVO) {
		noticeVO.setStatus("n");
		noticeVO.setViewCnt(0);
		return noticeMapper.insertNotice(noticeVO);
		
	}

	@Override
	public int updateNotice(NoticeVO noticeVO) {
		return noticeMapper.updateNotice(noticeVO);
		
	}

	@Override
	public int deleteNotice(int ntcNo) {
		return noticeMapper.deleteNotice(ntcNo);
		
	}

}
 