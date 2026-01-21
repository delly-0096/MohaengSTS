package kr.or.ddit.mohaeng.tripschedule.enums;

import lombok.Getter;
import java.util.Collections;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Getter
public enum RegionCode {
    SEOUL(1, "서울"),
    INCHEON(2, "인천"),
    DAEJEON(3, "대전"),
    DAEGU(4, "대구"),
    GWANGJU(5, "광주"),
    BUSAN(6, "부산"),
    ULSAN(7, "울산"),
    SEJONG(8, "세종특별자치시"),
    GYEONGGI(31, "경기도"),
    GANGWON(32, "강원특별자치도"),
    CHUNGBUK(33, "충청북도"),
    CHUNGNAM(34, "충청남도"),
    GYEONGBUK(35, "경상북도"),
    GYEONGNAM(36, "경상남도"),
    JEONBUK(37, "전북특별자치도"), 
    JEONNAM(38, "전라남도"), 
    JEJU(39, "제주도");

    private final int rgnNo;
    private final String rgnNm;

    RegionCode(int rgnNo, String rgnNm) {
        this.rgnNo = rgnNo;
        this.rgnNm = rgnNm;
    }
    
    // (핵심) 역추적을 위한 Map 생성
    private static final Map<Integer, RegionCode> RGN_NO_MAP =
            Collections.unmodifiableMap(Stream.of(values())
                    .collect(Collectors.toMap(RegionCode::getRgnNo, Function.identity())));

    /**
     * 코드(int)로 지역 명칭(String)을 바로 가져오기
     */
    public static String getNameByNo(int rgnNo) {
    	System.out.println("rgnNo : " + rgnNo);
        return Optional.ofNullable(RGN_NO_MAP.get(rgnNo))
                .map(RegionCode::getRgnNm)
                .orElse("알 수 없는 지역"); // 데이터가 없을 경우 기본값
    }
}