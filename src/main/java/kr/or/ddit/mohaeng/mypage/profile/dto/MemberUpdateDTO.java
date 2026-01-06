package kr.or.ddit.mohaeng.mypage.profile.dto;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;
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
    private String currentPassword;     // 본인 확인용
    private String newPassword;         // 변경할 비번

    // MemUserVO 관련 (상세 정보)
    private String nickname;
    private String birthDate;
    private String gender;
    private String zip;           		 // JSP의 zip과 매칭
    private String addr1;             // JSP의 addr1과 매칭
    private String addr2;       // JSP의 addr2과 매칭
    private String tel;               // JSP의 tel과 매칭
    
    // 알림/마케팅 설정 (필요시 추가)
    private String notifyReservation;	// 예약 확정/취소 알림 (이메일)
    private String notifySchedule;		// 여행 일정 리마인드 알림 (이메일)
    private String notifyCommunity;		// 커뮤니티 댓글/답글 알림 (이메일)
    private String notifyPoint;			// 포인트 적립/사용 알림 (이메일)
    private String notifyInquiry;		// 문의 답변 알림 (이메일)
}
