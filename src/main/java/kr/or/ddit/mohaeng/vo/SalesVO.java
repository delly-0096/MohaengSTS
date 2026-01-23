package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class SalesVO {
    private Integer saleNo;         // 매출번호 (PK)
    private Integer prodListNo;     // 구입상품목록번호 (FK)
    private Date settleDate;        // 결산일
    private Date saleDt;            // 매출일자
    private Integer netSales;       // 실제매출액
    private String settleStatCd;    // 정산상태 코드(정산대기,정산가능,정산완료,취소)
    
    // 조인 정보
    private String tripProdTitle;   // 상품명
    private String buyerName;       // 예약자명
    private Date resvDt;            // 이용일
    private String useTime;         // 이용시간
    private Integer payPrice;       // 결제금액
    private Integer quantity;       // 수량
    private Integer payNo;          // 결제번호
    private Date payDt;             // 결제일시
    
    // 수수료, 정산액 (계산용)
    private Integer commission;     // 수수료
    private Integer settleAmt;      // 정산액 (매출 - 수수료)
    
    // 검색/필터용
    private Integer memNo;          // 기업회원 번호
    private String startDate;       // 조회 시작일
    private String endDate;         // 조회 종료일
    private String status;          // 상태 필터
    private String keyword;         // 검색어
    
    // 페이징용
    private int page = 1;
    private int pageSize = 10;
    
    // 통계용
    private Integer thisMonthSales;     // 이번 달 매출
    private Integer lastMonthSales;     // 지난 달 매출
    private Double growthRate;          // 전월 대비 증감률
    private Integer pendingSettle;      // 정산 예정액
    private Integer lastMonthSettle;    // 지난달 정산액
    
    // 월별 매출 (차트용)
    private String saleMonth;           // 매출 월 (YYYY-MM)
    private Integer monthlyTotal;       // 월별 합계
    
    // 총 건수
    private int totalCount;
    
    // 동종업계 비교용 추가 필드
    private Integer resvCount;          // 예약 수
    private Double avgRating;           // 평균 평점
    private Double rebookingRate;       // 재예약률
    private Double cancelRate;          // 취소율
    private Integer avgSales;           // 업계 평균 매출
    private Integer avgResvCount;       // 업계 평균 예약 수
    private Double industryAvgRating;   // 업계 평균 평점
    private Double avgRebookingRate;    // 업계 평균 재예약률
    private Double avgCancelRate;       // 업계 평균 취소율
    private Integer totalCompanyCnt;    // 전체 업체 수
    private Integer myRank;             // 내 순위
}
