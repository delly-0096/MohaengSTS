package kr.or.ddit.mohaeng.alarm.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.AlarmVO;

@Mapper
public interface IAlarmMapper {
	public int insertAlarm(AlarmVO alarm);
}
