package kr.or.ddit.mohaeng.admin.accommodation.dto;

import lombok.Data;
import java.util.List;

import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;

@Data // Getter, Setter, ToString 등 자동으로 생성해줌!
public class AdminAccommodationDTO {
    // 1. 숙소 기본 정보 (ACCOMMODATION 테이블)
    private int accNo;
    private int tripProdNo;
    private String accName;
    private String accCatCd;
    private String addr1;
    private String addr2;
    private String zip;
    private String tel;
    private String checkInTime;
    private String checkOutTime;
    private String mapx;
    private String mapy;
    private String overview;
    private int starGrade;

    // 2. 판매 및 승인 상태 (TRIP_PRODUCT 테이블 연관)
    private String approveStatus; // "판매중", "승인대기" 등
    private String aprvYn;        // 'Y' or 'N'
    private String delYn;         // 'Y' or 'N'
    private String saleStartDt;
    private String saleEndDt;

    // 3. 연관 데이터 (List로 한 번에 받기)
    private AccFacilityVO accFacility;      // 편의시설 (객체)
    private List<RoomTypeVO> roomTypeList;  // 객실 타입 목록 (리스트)
    private List<String> accOptionList;      // 옵션 목록
}