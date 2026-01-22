package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class BookmarkVO {
    private Long bmkNo;            // 북마트 번호
    private String contentType;      // 북마크 타입
    private Long memNo;            // 북마크한 사람
    private Long contentId;         // 북마크 대상
    private Date regDt;            // 북마크한 시점
    private String delYn;         // 북마크 삭제 여부
    private Date delDt;            // 북마크 삭제 시점
    
    // 북마크 목록을 가져오기 위한 Custom 필드
    private int bmkDayCount;      // 타입 일정일때 박수(2박)
    private String addr1;         // 숙소 및 투어시 주소정보
    private int price;            // 숙소 및 투어시 상품가격
    private String title;         // 일정명, 상품명
}