package kr.or.ddit.mohaeng.support.notice.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.vo.NoticeFileVO;
import kr.or.ddit.mohaeng.vo.NoticeVO;


public interface INoticeService {

  public NoticeVO selectNotice(int ntcNo);

  public List<NoticeVO> selectNoticeList();

  public int insertNotice(NoticeVO noticeVO);

  public int updateNotice(NoticeVO noticeVO);

  public int deleteNotice(int ntcNo);
	

}
