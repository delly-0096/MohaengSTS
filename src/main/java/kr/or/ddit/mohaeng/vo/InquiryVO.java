package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class InquiryVO {

	// 1:1문의 테이블 필드
    private int inqryNo;                // 문의 번호
    private String inqryCtgryCd;        // 문의 유형 코드
    private int memNo;                  // 작성자회원번호
    private String inqryStatus;         // 문의상태
    private String inqryTitle;          // 문의제목
    private String inqryCn;             // 문의내용
    private Integer inquiryTargetNo;    // 관련예약번호
    private String inqryEmail;          // 회원가입시이메일
    private Integer attachNo;          // 첨부파일번호
    private Date regDt;                 // 등록일자
    private Date modDt;                 // 수정일자
    private String delYn;               // 삭제여부
    private Date delDt;                 // 삭제일자
    private String replyCn;             // 답변내용
    private Integer replyMemNo;         // 답변작성자
    private Date replyDt;               // 답변등록일
    private Date replyModDt;            // 답변수정일

    // 조인으로 가져올 필드
    private String categoryName;        // 문의 유형명 (CODE.CD_NAME)
    private String memberName;          // 회원명 (MEMBER.MEM_NAME)

    // 화면 표시용
    private String regDtStr;            // 등록일 문자열
    private String replyDtStr;          // 답변일 문자열

    private String filePath; // 추가: 파일 경로를 담을 변수 (DB의 FILE_PATH와 매핑)

}
