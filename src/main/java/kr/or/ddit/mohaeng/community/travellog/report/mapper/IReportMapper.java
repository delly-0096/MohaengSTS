package kr.or.ddit.mohaeng.community.travellog.report.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.ReportVO;

@Mapper
public interface IReportMapper {

    // ===== 신고 등록 =====
    int insertReport(ReportVO vo);

    // ===== 중복 신고 방지 (WAIT 상태로 이미 신고했는지) =====
    int existsWaitReport(@Param("reqMemNo") Long reqMemNo,
                         @Param("targetType") String targetType,
                         @Param("targetNo") Long targetNo);

    // ===== targetMemNo 서버 자동 세팅용 =====
    Long selectTripRecordWriterMemNo(@Param("rcdNo") Long rcdNo);          // TRIP_RECORD.MEM_NO
    Long selectCommentWriterMemNo(@Param("cmntNo") Long cmntNo);           // COMMENTS.WRITER_NO

    // ===== 내 신고 목록/카운트 =====
    int countMyReports(@Param("reqMemNo") Long reqMemNo);

    List<ReportVO> listMyReports(@Param("reqMemNo") Long reqMemNo,
                                 @Param("offset") int offset,
                                 @Param("size") int size);

    // ===== 신고 상세(본인 것) =====
    ReportVO selectMyReportDetail(@Param("rptNo") Long rptNo,
                                  @Param("reqMemNo") Long reqMemNo);

    // ===== 취소 가능 여부 체크 =====
    String selectProcStatusForOwner(@Param("rptNo") Long rptNo,
                                    @Param("reqMemNo") Long reqMemNo);

    // ===== 신고 취소(삭제) =====
    int deleteMyReport(@Param("rptNo") Long rptNo,
                       @Param("reqMemNo") Long reqMemNo);
}
