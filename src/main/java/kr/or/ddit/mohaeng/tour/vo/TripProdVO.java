package kr.or.ddit.mohaeng.tour.vo;

import java.util.Date;

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
    private String sortBy;
    
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
    
}
