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
    private Double avgRating;
    private Integer reviewCount;
    private Integer recommendCount;
    
    // 리뷰 이미지 목록
    private List<String> reviewImages;
}
