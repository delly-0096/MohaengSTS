package kr.or.ddit.mohaeng.alarm.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.alarm.mapper.IAlarmMapper;
import kr.or.ddit.mohaeng.vo.AlarmVO;

@Service
public class AlarmService {
	
	@Autowired
    private IAlarmMapper alarmMapper;
    
    private static final String SENDER = "모행";
    
    /**
     * 포인트 사용 알림 (일반회원)
     */
    public void sendPointUseAlarm(int memNo, int usedPoint) {
        AlarmVO alarm = new AlarmVO();
        alarm.setMemNo(memNo);
        alarm.setSender(SENDER);
        alarm.setAlarmType("POINT");
        alarm.setAlarmCont(String.format("%,d 포인트가 사용되었습니다.", usedPoint));
        alarm.setMoveUrl("/mypage/points");
        alarmMapper.insertAlarm(alarm);
    }
    
    /**
     * 포인트 적립 알림 (일반회원)
     */
    public void sendPointEarnAlarm(int memNo, int earnedPoint) {
        AlarmVO alarm = new AlarmVO();
        alarm.setMemNo(memNo);
        alarm.setSender(SENDER);
        alarm.setAlarmType("POINT");
        alarm.setAlarmCont(String.format("%,d 포인트가 적립되었습니다.", earnedPoint));
        alarm.setMoveUrl("/mypage/points");
        alarmMapper.insertAlarm(alarm);
    }
    
    /**
     * 결제 완료 알림 (일반회원)
     */
    public void sendPaymentCompleteAlarm(int memNo, String orderName, int payNo) {
        AlarmVO alarm = new AlarmVO();
        alarm.setMemNo(memNo);
        alarm.setSender(SENDER);
        alarm.setAlarmType("PAYMENT");
        alarm.setAlarmCont(orderName + " 결제가 완료되었습니다.");
        alarm.setMoveUrl("/mypage/payments/list");
        alarmMapper.insertAlarm(alarm);
    }
    
    /**
     * 문의 답변 알림 (일반회원 - 문의 작성자)
     */
    public void sendInquiryReplyAlarm(int memNo, String productName, int tripProdNo) {
        AlarmVO alarm = new AlarmVO();
        alarm.setMemNo(memNo);
        alarm.setSender(SENDER);
        alarm.setAlarmType("INQUIRY");
        alarm.setAlarmCont("[" + productName + "] 문의에 답변이 등록되었습니다.");
        alarm.setMoveUrl("/tour/" + tripProdNo);
        alarmMapper.insertAlarm(alarm);
    }
    
    /**
     * 상품 문의 발생 알림 (기업회원)
     */
    public void sendNewInquiryAlarm(int compMemNo, String productName, int tripProdNo) {
        AlarmVO alarm = new AlarmVO();
        alarm.setMemNo(compMemNo);
        alarm.setSender(SENDER);
        alarm.setAlarmType("INQUIRY");
        alarm.setAlarmCont("[" + productName + "] 상품에 새로운 문의가 등록되었습니다.");
        alarm.setMoveUrl("/tour/" + tripProdNo);
        alarmMapper.insertAlarm(alarm);
    }
    
    /**
     * 상품 결제 알림 (기업회원)
     */
    public void sendProductSoldAlarm(int compMemNo, String productName, int quantity) {
        AlarmVO alarm = new AlarmVO();
        alarm.setMemNo(compMemNo);
        alarm.setSender(SENDER);
        alarm.setAlarmType("PAYMENT");
        alarm.setAlarmCont("[" + productName + "] 상품이 " + quantity + "건 판매되었습니다.");
        alarm.setMoveUrl("/mypage/business/sales");
        alarmMapper.insertAlarm(alarm);
    }
}
