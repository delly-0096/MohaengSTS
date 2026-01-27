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

    int updateReadOne(@Param("memNo") int memNo,
                      @Param("alarmNo") int alarmNo);

    int selectUnreadCount(@Param("memNo") int memNo);

    void insertAlarm(AlarmVO alarm);

    List<AlarmVO> selectAlramList(@Param("memNo") int memNo);

    int updateAllRead(@Param("memNo") int memNo);

	int updateReadOne(Map<String, Object> param);

	void updateAllRead(Map<String, Object> param);
}
