package kr.or.ddit.mohaeng.vo;

import java.util.Date;
import java.util.List;

import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;
import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;
import lombok.Data;

/**
 * 기업용 상품 vo 클래스
 */
@Data
public class CompProdVO {
	
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
    
    private TripProdSaleVO prodSale;	// 상품 판매 정보
    
	private TripProdInfoVO prodInfo;					// 상품 이용 안내	-- 예약 가능시간이랑 1대1
	
	
	
	private List<ProdTimeInfoVO> prodTimeList;			// 예약 가능 시간 
	private List<ProdReviewVO> prodReviewList;			// 상품 리부 내역
	private List<TripProdInquiryVO> prodInquiryList;	// 상품 문의 내역
    
	// 1:1
	// 숙소 객체
	// 숙소 보유시설
	
	// 1:n
	// 추가옵션 list
	// 객실 타입 list
	// 객실 내 시설 list (객실타입과 1:1)
	// 객실 내 특징 list (객실타입과 1:1)
	// 객실 
}
