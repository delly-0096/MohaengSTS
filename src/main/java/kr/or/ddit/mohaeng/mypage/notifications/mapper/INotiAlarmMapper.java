package kr.or.ddit.mohaeng.mypage.notifications.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.AlarmVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Mapper
public interface INotiAlarmMapper {

    int selectAlarmCount(PaginationInfoVO<AlarmVO> pagingVO);

    List<AlarmVO> selectAlarmList(PaginationInfoVO<AlarmVO> pagingVO);

	public void insertAlarm(AlarmVO alarm);
	
	// 헤더에 알람 목록 가져오기 위한 이벤트
	public List<AlarmVO> selectAlramList(int memNo);
	
	public int updateAllRead(int memNo);

	public List<AlarmVO> selectUnreadList(int memNo);
	

    int selectUnreadCount(@Param("memNo") int memNo);

    void insertAlarm(AlarmVO alarm);

    List<AlarmVO> selectAlramList(@Param("memNo") int memNo);

    int updateAllRead(@Param("memNo") int memNo);

	int updateReadOne(Map<String, Object> param);

	void updateAllRead(Map<String, Object> param);
}
