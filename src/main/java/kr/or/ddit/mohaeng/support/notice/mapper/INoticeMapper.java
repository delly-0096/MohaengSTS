package kr.or.ddit.mohaeng.support.notice.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.NoticeVO;

@Mapper
public interface INoticeMapper {

 public void incrementHit(int ntcNo);

 public NoticeVO selectNotice(int ntcNo);

 public List<NoticeVO> selectNoticeList();
 
 public int insertNotice(NoticeVO noticeVO);

 public int updateNotice(NoticeVO noticeVO);

 public int deleteNotice(int ntcNo);
  
}
