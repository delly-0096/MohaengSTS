package kr.or.ddit.mohaeng.support.notice.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.vo.NoticeFileVO;
import kr.or.ddit.mohaeng.vo.NoticeVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;


public interface INoticeService {

  public NoticeVO selectNotice(int ntcNo);

  public List<NoticeVO> selectNoticeList();

  public ServiceResult insertNotice(NoticeVO noticeVO) throws Exception;

  public int updateNotice(NoticeVO noticeVO);

  public int deleteNotice(int ntcNo);

  public NoticeFileVO getFileInfo(int fileNo);

  // 페이징 이용
  public int selectNoticeCount(PaginationInfoVO<NoticeVO> pagingVO);
  public List<NoticeVO> selectNoticeList(PaginationInfoVO<NoticeVO> pagingVO);
	

}
