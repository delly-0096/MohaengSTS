package kr.or.ddit.mohaeng.vo;

import lombok.Data;

//회원별 포인트 요약(조회 전용)
//관리자가 회원목록을 볼 때, 각 회원의 상태를 한눈에 파악하기 위한 통계 리포트
@Data
public class PointSummaryVO {

	private int memNo; //회원번호

	//member테이블과 조인
	private String memName; // 회원명
	private String memEmail; // 회원 이메일
	private int totalPoints; //총 보유 포인트 (MEMBER.POINT)

	//가공 또는 집계 데이터(sql의 계산 데이터)
	private int earnedThisMonth; //이번달 적립 포인트 : 이번 달에 얼마나 활발히 활동(적립)했는지 보여주는 지표
	private int usedThisMonth; //이번달 사용 포인트
	private int expireSoonPoint; //만료예정 포인트(이번달)
	private int totalEarned; //누적 적립 포인트 : 회원의 **'충성도'**
	private int totalUsed; //누적 사용 포인트 : 실질적인 **'소비력'**을 의미

	//검색용(파라미터)
	private String searchKeyword; // 이름이나 이메일로 특정 회원을 찾기 위한 검색어

	// 페이징 - PointSummaryVO 타입 지정
    private PaginationInfoVO<PointSummaryVO> paginationVO;
    //이 바구니에는 회원별 요약 정보(이름, 이메일, 총액 등) 목록이 담김.
    //관리자 페이지에서 "전체 회원들의 포인트 현황 리스트"를 만들 때 사용
}
