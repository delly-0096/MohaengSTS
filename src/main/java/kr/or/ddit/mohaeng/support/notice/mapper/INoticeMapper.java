package kr.or.ddit.mohaeng.support.notice.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.NoticeFileVO;
import kr.or.ddit.mohaeng.vo.NoticeVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Mapper
public interface INoticeMapper {

 public void incrementHit(int ntcNo);

 public NoticeVO selectNotice(int ntcNo);

 public List<NoticeVO> selectNoticeList();
 
 public int insertNotice(NoticeVO noticeVO);

 public int updateNotice(NoticeVO noticeVO);

 public int deleteNotice(int ntcNo);

 public NoticeFileVO getFileInfo(int fileNo);

 public List<NoticeFileVO> selectNoticeFileList(int attachNo);

 public int selectNoticeCount(PaginationInfoVO<NoticeVO> pagingVO);

 public List<NoticeVO> selectNoticeList(PaginationInfoVO<NoticeVO> pagingVO);
  
}
