package kr.or.ddit.mohaeng.vo;

import lombok.Data;

//Filter
//검색 조건용 포인트. 사용자가 서버에 던지는 질문지(주문서)
//마이페이지나 관리자 상세 조회에서 내가 원하는 기록만 골라내기 위한 검색 조건 바구니
@Data
public class PointSearchVO {

	private Integer memNo;
	private String pointType; //"적립(+)만 볼래? 사용(-)만 볼래?"
	private String pointTarget; //"결제(PAYMENT) 내역만 골라내줘"
	private String searchKeyword; //"내역 설명에 '이벤트'가 들어간 걸 찾아줘"
    private String startDate; //"이 날짜 이후 기록부터 보여줘"
    private String endDate; //"이 날짜 이전 기록까지만 보여줘"
    private String period; //'최근 3개월', '최근 1년' 등 미리 정의된 기간을 쉽게 설정하기 위한 값

    // PaginationVO 사용
    private PaginationInfoVO<PointDetailsVO> paginationVO;
    //이 바구니에는 포인트 상세 내역(날짜, 금액, 사유 등) 목록이 담김.
    //주로 마이페이지의 "포인트 이용 내역 리스트"를 만들 때 사용
}