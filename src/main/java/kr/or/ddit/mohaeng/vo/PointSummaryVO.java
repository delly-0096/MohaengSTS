package kr.or.ddit.mohaeng.vo;

import lombok.Data;

//회원별 포인트 요약(조회 전용)
@Data
public class PointSummaryVO {

	private int memNo; //회원번호
	private String memName; // 회원명
	private String memEamil; // 회원 이메일
	private int totalPoint; //총 보유 포인트
	private int earnMonthPoint; //이번달 적립 포인트
	private int useMonthPoint; //이번달 사용 포인트
	private int expireSoonPoint; //만료예정 포인트(이번달)
	private int totalEarn; //누적 적립 포인트
	private int totalUse; //누적 사용 포인트

	//검색용
	private String searchKeyword;

	// 페이징 - PointSummaryVO 타입 지정
    private PaginationInfoVO<PointSummaryVO> paginationVO;
    //이 바구니에는 회원별 요약 정보(이름, 이메일, 총액 등) 목록이 담김.
    //관리자 페이지에서 "전체 회원들의 포인트 현황 리스트"를 만들 때 사용
}
