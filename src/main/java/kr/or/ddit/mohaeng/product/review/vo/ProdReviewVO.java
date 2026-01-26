package kr.or.ddit.mohaeng.product.review.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class ProdReviewVO {
    private int prodRvNo;           // 상품리뷰키 (PK)
    private int tripProdNo;         // 여행상품일련키 (FK)
    private Integer memNo;          // 이용 회원 (FK)
    private String prodReview;      // 리뷰내용
    private Date prodRegdate;       // 등록일자
    private Date prodUdtdate;       // 수정일자
    private Integer rating;         // 별점 점수
    private Integer attachNo;       // 리뷰이미지
    private String rcmdtnYn;        // 추천여부 (Y/N)

    // 조회용 (MEM_USER 조인)
    private String nickname;        // 작성자 닉네임
    private String profileImage;    // 프로필 이미지 경로

    // 평균별점, 리뷰수, 추천수
    private Double avgRating; // 평균별점
    private Integer reviewCount; // 리뷰수
    private Integer recommendCount; // 상품별 추천수
    //[관리자용-추가]
    private Integer totalRecommendCount; // 통계용 전체 추천수

    // 리뷰 이미지 목록
    private List<String> reviewImages;

    // ===== 관리자 페이지용 추가 필드 =====
    private String reviewStatus; // 리뷰 상태 (ACTIVE/HIDDEN/REPORTED) - CODE 테이블 참조 : DB 컬럼값

    // 조회용 (MEMBER 조인)
    private String memName;      // 작성자 이름

    // 조회용 (TRIP_PROD 조인)
    private String tripProdTitle; //상품명
    private String prodCtgryType; //상품 카테고리(accommodation/transfer/class/tour/tour/ticket/activity)

    // 조회용 (COMPANY 조인)
    private Integer compNo;  // 회사키
    private String bzmnNm;   // 기업명 (상호명)

    // 검색 및 필터용
    private String searchKeyword; //검색어
    private Integer ratingFilter; //평점 필터(1~5)
    private String statusFilter;// 상태 필터(all/active/hidden/reported) : 검색조건
    private String startDate; // 시작일
    private String endDate; // 종료일

    // 페이징용 (PaginationInfoVO 사용)
    private int startRow; // 시작 row
    private int endRow; // 끝 row

    
    // 후기 작성 시 이미지 파일을 담기 위한 필드 (컨트롤러에서 자동 바인딩)
    private org.springframework.web.multipart.MultipartFile[] uploadFiles;

    // [조회용] 작성일자를 'yyyy.MM.dd' 형식의 문자열로 받기 위함
    private String displayDate;

    // [조회용] 리뷰 이미지 중 첫 번째 이미지만 대표로 보여줄 때 사용
    private String firstImage;

    // [삭제용] 파일 개별 삭제 시 사용할 파일 번호 리스트
    private List<Integer> delFileNoList;
    
}
