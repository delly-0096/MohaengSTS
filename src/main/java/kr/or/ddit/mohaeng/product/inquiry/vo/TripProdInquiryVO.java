package kr.or.ddit.mohaeng.product.inquiry.vo;

import java.util.Date;

import lombok.Data;

@Data
public class TripProdInquiryVO {
    private int prodInqryNo;        // 상품문의질문번호 (PK)
    private int tripProdNo;         // 여행상품일련키 (FK)
    private int inquiryMemNo;       // 문의작성자 (FK)
    private String inquiryCtgry;    // 문의카테고리
    private String prodInqryTitle;  // 문의제목
    private String prodInqryCn;     // 문의내용
    private String inqryStatus;     // 상태 (WAIT/DONE)
    private String secretYn;        // 비밀글 여부 (Y/N)
    private Date regDt;             // 작성일
    private Date modDt;             // 수정일
    private String delYn;           // 삭제여부 (Y/N)
    private Date delDt;             // 삭제일
    private String replyCn;         // 답변내용
    private Integer replyMemNo;     // 답변자
    private Date replyDt;           // 답변일자
    private Date replyModDt;        // 답변수정일자
    
    // 조회용 (MEM_USER 조인)
    private String inquiryNickname; // 문의작성자 닉네임
}
