package kr.or.ddit.mohaeng.tour.vo;

import java.util.Date;
import java.util.List;

import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;
import lombok.Data;

@Data
public class TripProdVO {
	private int tripProdNo;          // 여행상품일련키 (PK)
    private int compNo;              // 회사키
    private int memNo;               // 기업회원키
    private String prodCtgryType;    // 상품카테고리 (tour, activity, ticket, class, transfer)
    private String approveStatus;    // 여행상품상태 (판매중, 판매중지)
    private String tripProdTitle;    // 상품제목
    private String tripProdContent;  // 상품 설명
    private Date saleStartDt;        // 상품판매시작일
    private Date saleEndDt;          // 상품판매종료일
    private Integer attachNo;        // 대표이미지 (첨부파일 고유아이디)
    private Integer viewCnt;         // 조회수
    private Date regDt;              // 등록일자
    private Date modDt;              // 수정일자
    private String aprvYn;           // 승인여부 (Y, N, NULL)
    private String rejRsn;           // 반려사유
    private Date rejDt;              // 반려일시
    private Date resDt;              // 응답일자
    private String delYn;            // 삭제여부 (Y, N)
    private Date delDt;              // 삭제일자
    private String ctyNm;            // 지역

    // 인피니티 스크롤 페이징용
    private int page = 1;        	// 현재 페이지
    private int pageSize = 12;   	// 페이지당 개수
    
    // 검색용
    private String keyword;			// 검색어
    private String destination;    	// 여행지 검색어
    private String category;       	// 카테고리
    private String tourDate;       	// 이용 희망일
    private Integer people;        	// 인원수
    
    // 가격대 필터용
    private Integer priceMin;
    private Integer priceMax;
    
    // 정렬용
    private String sortBy = "recommend";
    
    // 가격, 정가, 할인율, 소요시간(카테고리형태)
    private Integer price;
    private Integer netprc;
    private Integer discount;
    private Integer leadTime;
    
    // 재고
    private Integer totalStock;
    private Integer curStock;
    
    // 평점, 리뷰수, 추천수
    private Double avgRating;
    private Integer reviewCount;
    private Integer recommendCount;
    
    // 대표 이미지
    private String thumbImage;
    
    
    // 기업용으로 추가
    // 1대1 위에 존재
    private TripProdSaleVO prodSale;	// 상품 판매 정보
    
    // 1대1
	private TripProdInfoVO prodInfo;
    private String prodRuntime;     // 운영시간
    private String prodDuration;    // 소요시간
    private Integer prodMinPeople;  // 최소인원
    private Integer prodMaxPeople;  // 최대인원
    private String prodLimAge;      // 연령제한
    private String prodInclude;     // 포함사항
    private String prodExclude;     // 불포함사항
    private String prodNotice;      // 유의사항
	
	
	// 상품 이용 안내	-- 예약 가능시간이랑 1대1
	private List<ProdTimeInfoVO> prodTimeList;			// 예약 가능 시간 
	private List<ProdReviewVO> prodReviewList;			// 상품 리부 내역
	private List<TripProdInquiryVO> prodInquiryList;	// 상품 문의 내역
//    private 
	
	// 통계용 변수
    private int totalCount;		// 총 상품 수
    private int approveCount;	// 판매중인 상품 수
    private int unapproveCount;	// 판매중지 상품 수
    private int totalSales;		// 총 판매량
    
    // 대시보드
    private String title; 		// 제목
    private int viewCount; 		// 조회수
    private int resvCount;      // 예약수
    private double rating;      // 평점
}
