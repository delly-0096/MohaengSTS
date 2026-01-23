package kr.or.ddit.mohaeng.mypage.notifications.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.mypage.notifications.mapper.INotiAlarmMapper;
import kr.or.ddit.mohaeng.vo.AlarmVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Service
public class NotificationsAlarmServiceImpl implements INotificationsAlarmService {

    @Autowired
    private INotiAlarmMapper notiAlarmMapper;

    @Override
    public int selectAlarmCount(PaginationInfoVO<AlarmVO> pagingVO) {
        return notiAlarmMapper.selectAlarmCount(pagingVO);
    }

    @Override
    public List<AlarmVO> selectAlarmList(PaginationInfoVO<AlarmVO> pagingVO) {
        return notiAlarmMapper.selectAlarmList(pagingVO);
    }
}

