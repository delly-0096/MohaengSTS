package kr.or.ddit.mohaeng.community.travellog.record.service;

import kr.or.ddit.mohaeng.community.travellog.record.dto.PagedResponse;
import kr.or.ddit.mohaeng.community.travellog.record.dto.TripRecordCreateReq;
import kr.or.ddit.mohaeng.community.travellog.record.dto.TripRecordUpdateReq;
import kr.or.ddit.mohaeng.vo.TripRecordDetailVO;
import kr.or.ddit.mohaeng.vo.TripRecordListVO;

public interface ITripRecordService {

    PagedResponse<TripRecordListVO> list(int page, int size, String keyword, String openScopeCd, Long loginMemNo);

    TripRecordDetailVO detail(long rcdNo, Long loginMemNo, boolean increaseView);

    long create(TripRecordCreateReq req, long loginMemNo);

    void update(long rcdNo, TripRecordUpdateReq req, long loginMemNo);

    void delete(long rcdNo, long loginMemNo);

    boolean isWriter(long rcdNo, Long loginMemNo);
    
    long createWithFiles(
            TripRecordCreateReq req,
            long loginMemNo,
            org.springframework.web.multipart.MultipartFile coverFile,
            java.util.List<org.springframework.web.multipart.MultipartFile> images
    );

}
