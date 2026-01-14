package kr.or.ddit.mohaeng.vo;

import lombok.Data;

//검색 조건용 포인트
@Data
public class PointSearchVO {

	private Integer memNo;
	private String pointType;
	private String pointTarget;
	private String searchKeyword;
    private String startDate;
    private String endDate;
    private String period;

    // PaginationVO 사용
    private PaginationInfoVO<PointDetailsVO> paginationVO;
    //이 바구니에는 포인트 상세 내역(날짜, 금액, 사유 등) 목록이 담김.
    //주로 마이페이지의 "포인트 이용 내역 리스트"를 만들 때 사용
}