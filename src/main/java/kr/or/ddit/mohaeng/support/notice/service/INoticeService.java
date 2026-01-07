package kr.or.ddit.mohaeng.support.notice.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.vo.NoticeFileVO;
import kr.or.ddit.mohaeng.vo.NoticeVO;


public interface INoticeService {

  public NoticeVO selectNotice(int ntcNo);

  public List<NoticeVO> selectNoticeList();

  public ServiceResult insertNotice(NoticeVO noticeVO) throws Exception;

  public int updateNotice(NoticeVO noticeVO);

  public int deleteNotice(int ntcNo);

  public NoticeFileVO getFileInfo(int fileNo);
	

}
