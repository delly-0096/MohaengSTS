package kr.or.ddit.mohaeng.mypage.notifications.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.vo.AlarmVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface IAlarmService {
	
	

	public int getUnreadCount(int memNo);
	public boolean readOne(int memNo, int alarmNo);

	List<AlarmVO> getAlarmList(PaginationInfoVO<AlarmVO> pagingVO);

	public int getAlarmCount(PaginationInfoVO<AlarmVO> pagingVO);
	public int countUnread(int memNo);
	public void testInsert(int memNo);
	public List<AlarmVO> selectAlramList(int memNo);
	public void readAll(int memNo);
	public boolean readOne(Map<String, Object> param);
	public void readAll(Map<String, Object> param);



}