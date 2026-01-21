package kr.or.ddit.mohaeng.vo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;
import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdPlaceVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;
import lombok.Data;

/**
 * 기업용 상품 vo 클래스
 */
@Data
public class BusinessProductsVO {
	
	private int tripProdNo;          // 여행상품일련키 (PK)
    private int compNo;              // 회사키
    private int memNo;               // 기업회원키
    private String prodCtgryType;    // 상품카테고리 (tour, activity, ticket, class, transfer)
    private String approveStatus;    // 여행상품상태 (판매중, 판매중지)
    private String tripProdTitle;    // 상품제목
    private String tripProdContent;  // 상품 설명
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date saleStartDt;        // 상품판매시작일
    @DateTimeFormat(pattern = "yyyy-MM-dd")
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
    
    
    ////////////////////////////////
    // 대표 이미지
    private String thumbImage;
    private String keyword;			// 검색어

    private int page = 1;       // 현재 페이지
    private int pageSize = 12;  // 페이지당 개수
    
	// 통계용 변수
    private int totalCount;		// 총 상품 수
    private int approveCount;	// 판매중인 상품 수
    private int unapproveCount;	// 판매중지 상품 수
    private int totalSales;		// 총 판매량

    // 화면에 뿌려줄 가격
    private Integer displayPrice;
    // 할인 금액
    
    // 평점, 리뷰수, 추천수
    private Double avgRating;
    private Integer reviewCount;
    private Integer recommendCount;
    /////////////////
    
    // 숙박 키
    private int accNo;
    
    // 1대1
    private TripProdSaleVO prodSale;		// 상품 판매 정보
	private TripProdInfoVO prodInfo;		// 상품 이용 안내	-- 예약 가능시간이랑 1대1
	private TripProdPlaceVO prodPlace;		// 상품 상세 주소		
	private AccommodationVO accommodation;	// 숙소
	private AccFacilityVO accFacility;		// 숙소 보유시설

	// 1:n
	private List<ProdTimeInfoVO> prodTimeList;			// 예약 가능 시간

	private String bookingTimes;					// jsp에서 받을 예약 가능 시간
	public void setBookingTimes(String bookingTimes) {
        this.bookingTimes = bookingTimes;
        
        if (bookingTimes != null && !bookingTimes.isEmpty()) {
            this.prodTimeList = new ArrayList<>();
            
            String[] timeArray = bookingTimes.split(",");
            
            for (String time : timeArray) {
                String trimmedTime = time.trim();
                if(!trimmedTime.isEmpty()) {
                    ProdTimeInfoVO timeVO = new ProdTimeInfoVO();
                    timeVO.setRsvtAvailableTime(trimmedTime);
                    this.prodTimeList.add(timeVO);
                }
            }
        }
    }
	
	private List<TripProdListVO> prodList;				// 구입 상품 내역
	private List<ProdReviewVO> prodReviewList;			// 상품 리뷰 내역
	private List<TripProdInquiryVO> prodInquiryList;	// 상품 문의 내역
    
	private List<AttachFileDetailVO> imageList;			// 전체 사진 가져오기 - attachNo로
	
	private List<AccOptionVO> optionList;				// 추가옵션 - 숙소와 1대n
	private List<AccResvOptionVO> resOptionList;		// 숙소 예약옵션 - 추가옵션과 1대1
	private List<AccResvVO> resList;					// 숙소 예약 - 숙소 예약옵션과 1대1, 객실타입과 1대n

	// 여기 안에 feature, facility가 다 있음
	private List<RoomTypeVO> roomTypeList;				// 객실타입 - 숙소 와 1대n
//	private List<RoomFacilityVO> roomFacilityList;		// 객실 내 시설 - 객싵타입과 1대1
//	private List<RoomFeatureVO> roomFeatureList;		// 객실 내 특징 - 객실 타입과 1대1
	private List<RoomVO> rooms;						// 객실	- 객실타입과 1대n
}
