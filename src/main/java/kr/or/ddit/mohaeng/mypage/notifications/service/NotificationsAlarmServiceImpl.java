package kr.or.ddit.mohaeng.mypage.notifications.service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
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
    	List<AlarmVO> list = notiAlarmMapper.selectAlarmList(pagingVO); 
    	for(AlarmVO alarmVO : list) {
    		alarmVO.setRegDtStr(formatTimeAgo(alarmVO.getRegDt()));
    	}
        return list;
    }
    
    public String formatTimeAgo(Date date) {
        if (date == null) return "";

        // Date를 LocalDateTime으로 변환
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime before = date.toInstant()
                                   .atZone(ZoneId.systemDefault())
                                   .toLocalDateTime();

        Duration duration = Duration.between(before, now);
        long seconds = duration.getSeconds();

        if (seconds < 60) {
            return "방금 전";
        } else if (seconds < 3600) {
            return (seconds / 60) + "분 전";
        } else if (seconds < 86400) {
            return (seconds / 3600) + "시간 전";
        } else if (seconds < 2592000) { // 30일 기준
            return (seconds / 86400) + "일 전";
        } else if (seconds < 31104000) { // 12개월 기준
            return (seconds / 2592000) + "개월 전";
        } else {
            return (seconds / 31104000) + "년 전";
        }
    }
}

