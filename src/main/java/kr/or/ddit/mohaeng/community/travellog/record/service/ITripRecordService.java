package kr.or.ddit.mohaeng.community.travellog.record.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.community.travellog.record.dto.PagedResponse;
import kr.or.ddit.mohaeng.community.travellog.record.dto.TripRecordCreateReq;
import kr.or.ddit.mohaeng.community.travellog.record.dto.TripRecordUpdateReq;
import kr.or.ddit.mohaeng.vo.TripRecordDetailVO;
import kr.or.ddit.mohaeng.vo.TripRecordListVO;

public interface ITripRecordService {

//    PagedResponse<TripRecordListVO> list(int page, int size, String keyword, String openScopeCd, Long loginMemNo);
	PagedResponse<TripRecordListVO> list(int page, int size, String keyword, String openScopeCd, String filter, Long loginMemNo);


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

	void updateWithCover(long rcdNo, TripRecordUpdateReq req, Long loginMemNo, MultipartFile coverFile);

	long createWithBlocks(
	        TripRecordCreateReq req,
	        Long memNo,
	        MultipartFile coverFile,
	        java.util.List<MultipartFile> bodyFiles,
	        java.util.List<kr.or.ddit.mohaeng.community.travellog.record.dto.TripRecordBlockReq> blocks
	);
	
	List<kr.or.ddit.mohaeng.vo.TripRecordBlockVO> blocks(long rcdNo);


}
