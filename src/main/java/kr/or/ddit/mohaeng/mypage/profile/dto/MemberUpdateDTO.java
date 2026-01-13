package kr.or.ddit.mohaeng.mypage.profile.dto;


import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MemberUpdateDTO {
	
	// 식별자
    private int memNo;
    private int fileNo;

    // MemberVO 관련 (계정/기본정보)
    private String memName;
    private String memEmail;
    private Integer memProfile;
    private MultipartFile profileImage; // 파일 업로드 처리용
    private boolean profileImageDeleted;
    private String currentPassword;     	// 본인 확인용
    private String newPassword;         	// 변경할 비밀번호
    private String confirmPassword;  	    // 변경 비밀번호 확인 (검증용)
    

    // MemUserVO 관련 (상세 정보)
    private String nickname;
    private String birthDate;
    private String gender;
    private String zip;           		
    private String addr1;             
    private String addr2;       	
    private String tel;              
    
    // MemCompVO 관련 (상세 정보)
	private String memCompTel; 			// 기업회원 연락처
	private String memCompEmail; 		// 기업회원 이메일
    
	// CompanyVO 관련 (상세 정보)
	private int compNo; 			/* 회사키 */
	private String brno; 			/* 사업자등록번호 */
	private String prmmiMnno; 		/* 통신판매업 신고번호 */
	private String bzmnNm; 			/* 상호명 */
	private String rprsvNm;		    /* 대표자 성명 */
	private String rprsvEmladr; 	/* 대표자 이메일 */
	private String compZip; 		/* 회사우편번호 */
	private String compAddr1; 		/* 회사주소 */
	private String compAddr2; 		/* 회사 상세주소 */
	private String compUrl; 		/* 회사홈페이지주소 */
	private String compTel; 		/* 회사연락처 */
	private String bankCd; 			/* 정산은행 */
	private String depositor; 		/* 예금주 */
	private String accountNo; 		/* 계좌정보 */
	private int compBizFile; 		/* 사업자 등록증 파일 */
	private String industryCd; 		/* 업종 */
	private String compIntro; 		/* 기업 소개 */
    
    // 알림/마케팅 설정 (필요시 추가)
    private String notifyReservation;	// 예약 확정/취소 알림 (이메일)
    private String notifySchedule;		// 여행 일정 리마인드 알림 (이메일)
    private String notifyCommunity;		// 커뮤니티 댓글/답글 알림 (이메일)
    private String notifyPoint;			// 포인트 적립/사용 알림 (이메일)
    private String notifyInquiry;		// 문의 답변 알림 (이메일)
}
