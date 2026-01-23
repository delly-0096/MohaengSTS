package kr.or.ddit.mohaeng.mypage.notifications.service;

import java.util.List;

import kr.or.ddit.mohaeng.vo.AlarmVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface INotificationsAlarmService {

	public int selectAlarmCount(PaginationInfoVO<AlarmVO> pagingVO);

	public List<AlarmVO> selectAlarmList(PaginationInfoVO<AlarmVO> pagingVO);

}
