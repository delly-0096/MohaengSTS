package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class BlacklistVO {

	private Long blacklistNo;        // 블랙리스트 번호 (PK)
    private Long blacklistMemNo;     // 블랙리스트 회원 번호
    private String penaltyTypeCd;    // 제재 구분 코드 (BLACKLIST)
    private String memberType;       // 일반회원/기업회원 (MEM_USER/MEM_COMP)
    private String banReason;        // 제재 사유
    private Date startDt;       // 정지 시작일
    private Date endDt;         // 정지 해제 예정일 (영구 정지는 NULL)
    private String releaseYn;        // 해제 여부 (Y/N)
}
