package kr.or.ddit.mohaeng.community.travellog.record.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.community.travellog.record.dto.TripRecordCreateReq;
import kr.or.ddit.mohaeng.vo.TripRecordDetailVO;
import kr.or.ddit.mohaeng.vo.TripRecordListVO;
import kr.or.ddit.mohaeng.vo.TripRecordVO;

@Mapper
public interface ITripRecordMapper {

    long selectTripRecordListCount(Map<String, Object> param);
    List<TripRecordListVO> selectTripRecordList(Map<String, Object> param);
    TripRecordDetailVO selectTripRecordDetail(Map<String, Object> param);

    int insertTripRecord(@Param("req") TripRecordCreateReq req, @Param("memNo") long memNo);

    void increaseViewCnt(long rcdNo);
    Long selectWriterMemNo(long rcdNo);

    // 커버(대표이미지) attachNo 업데이트
    int updateCoverAttachNo(@Param("rcdNo") long rcdNo,
                            @Param("attachNo") Long attachNo);

    void updateTripRecord(TripRecordVO vo);
    void deleteTripRecord(long rcdNo);

    // ===== 첨부(ATTACH_FILE / ATTACH_FILE_DETAIL) =====
    // ⚠️ 아래 2개 시퀀스명은 너희 프로젝트 DB에 맞게 XML에서 변경해줘야 함
    Long nextAttachNo(); // 예: SEQ_ATTACH_FILE.NEXTVAL
    Long nextFileNo();   // 예: SEQ_ATTACH_FILE_DETAIL.NEXTVAL

    int insertAttachFile(@Param("attachNo") long attachNo,
                         @Param("regId") long regId);

    int insertAttachFileDetail(@Param("fileNo") long fileNo,
                               @Param("attachNo") long attachNo,
                               @Param("fileName") String fileName,
                               @Param("originalName") String originalName,
                               @Param("ext") String ext,
                               @Param("size") long size,
                               @Param("path") String path,
                               @Param("fileGbCd") String fileGbCd,
                               @Param("mimyType") String mimyType,
                               @Param("useYn") String useYn,
                               @Param("regId") long regId);
    
    int insertHashtags(@org.apache.ibatis.annotations.Param("rcdNo") long rcdNo,
            @org.apache.ibatis.annotations.Param("tags") java.util.List<String> tags);
    
    long nextConnNo();

    int insertTripRecordSeq(
        @Param("connNo") long connNo,
        @Param("rcdNo") long rcdNo,
        @Param("order") int order,
        @Param("blockType") String blockType,
        @Param("targetPk") String targetPk   // ✅ String
    );

    long nextTourPlaceReviewSeq();

    int insertTourPlaceReview(
    	    @Param("placeReviewNo") long placeReviewNo,   
    	    @Param("rcdConnNo") long rcdConnNo,
    	    @Param("memNo") long memNo,
    	    @Param("plcNo") Long plcNo,
    	    @Param("reviewConn") String reviewConn,
    	    @Param("rating") double rating
    	);
    
    int insertTripRecordTxt(
        @Param("connNo") long connNo,
        @Param("text") String text
    );

    int insertTripRecordImg(
        @Param("connNo") long connNo,
        @Param("attachNo") Long attachNo,
        @Param("desc") String desc
    );
    
    void upsertHashtagText(@org.apache.ibatis.annotations.Param("rcdNo") long rcdNo,
            @org.apache.ibatis.annotations.Param("tagText") String tagText);

    List<kr.or.ddit.mohaeng.vo.TripRecordBlockVO> selectTripRecordBlocks(@Param("rcdNo") long rcdNo);


}
