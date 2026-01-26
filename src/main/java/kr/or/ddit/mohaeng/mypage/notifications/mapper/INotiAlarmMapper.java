package kr.or.ddit.mohaeng.mypage.notifications.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.AlarmVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Mapper
public interface INotiAlarmMapper {

	public int selectAlarmCount(PaginationInfoVO<AlarmVO> pagingVO);

	public List<AlarmVO> selectAlarmList(PaginationInfoVO<AlarmVO> pagingVO);
	
	int updateReadOne (@Param("memNo") int memNo,
					   @Param("alarmNo") int alarmNo);
	int selectUnreadCount(int memNo);

	public void insertAlarm(AlarmVO alarm);


		
	
	}


