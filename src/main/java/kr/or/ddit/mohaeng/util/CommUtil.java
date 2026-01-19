package kr.or.ddit.mohaeng.util;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class CommUtil {
	
	/**
     * 두 날짜 사이의 일수 차이를 계산합니다.
     * @param startDateStr 시작 날짜 (yyyy-MM-dd)
     * @param endDateStr 종료 날짜 (yyyy-MM-dd)
     * @return 두 날짜 사이의 총 일수 (절대값)
     */
    public static int calculateDaysBetween(String startDateStr, String endDateStr) {
        // 1. 문자열을 LocalDate 객체로 파싱
        // 기본 포맷이 yyyy-MM-dd인 경우 ISO_LOCAL_DATE를 사용하여 별도 포맷 지정 없이 파싱 가능합니다.
        LocalDate startDate = LocalDate.parse(startDateStr);
        LocalDate endDate = LocalDate.parse(endDateStr);

        // 2. 두 날짜 사이의 일수 계산
        // ChronoUnit.DAYS.between(시작, 종료)는 종료일에서 시작일을 뺍니다.
        // 항상 양수 값을 원하시면 Math.abs()를 사용하세요.
        // 해당 메소드의 결과값은 차이를 계산하기 때문에 총 몇일인지가 아니라 총 일수 -1인 상태니 결과 +1을 해야 총 일정을 만들 수 있음
        return (int) Math.abs(ChronoUnit.DAYS.between(startDate, endDate));
    }
	
}
