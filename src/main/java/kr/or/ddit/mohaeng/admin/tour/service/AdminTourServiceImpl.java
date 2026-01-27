package kr.or.ddit.mohaeng.admin.tour.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.admin.tour.mapper.IAdminTourMapper;
import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional(readOnly = true)
public class AdminTourServiceImpl implements IAdminTourService {
	
	@Autowired
    private IAdminTourMapper adminTourMapper;

    @Override
    public void getTourList(PaginationInfoVO<TripProdVO> pagInfoVO) {
        int totalRecord = adminTourMapper.getTourCount(pagInfoVO);
        pagInfoVO.setTotalRecord(totalRecord);
        
        List<TripProdVO> dataList = adminTourMapper.getTourList(pagInfoVO);
        pagInfoVO.setDataList(dataList);
    }

    @Override
    public TripProdVO getTourDetail(int tripProdNo) {
        TripProdVO tour = adminTourMapper.selectTourBase(tripProdNo);
        
        if (tour == null) {
            return null;
        }
        
        // 예약 가능 시간 목록
        List<ProdTimeInfoVO> timeInfoList = adminTourMapper.selectTimeInfoList(tripProdNo);
        if (timeInfoList == null) {
            timeInfoList = new ArrayList<>();
        }
        tour.setProdTimeList(timeInfoList);
        
        // 이미지 목록
        if (tour.getAttachNo() != null && tour.getAttachNo() != 0) {
            List<AttachFileDetailVO> imageList = adminTourMapper.selectTourImages(tour.getAttachNo());
            tour.setImageList(imageList);
        }
        
        return tour;
    }

    @Override
    @Transactional
    public int approveTour(int tripProdNo) {
        log.info("{}번 투어 상품 승인", tripProdNo);
        return adminTourMapper.updateApproveStatus(tripProdNo);
    }

    @Override
    @Transactional
    public int toggleSaleStatus(Map<String, Object> params) {
        log.info("{}번 상품 상태 변경 (DEL_YN: {})", 
                params.get("tripProdNo"), params.get("delYn"));
        return adminTourMapper.toggleSaleStatus(params);
    }

    @Override
    @Transactional
    public int deleteTour(int tripProdNo) {
        log.info("투어 삭제: tripProdNo={}", tripProdNo);
        return adminTourMapper.logicalDeleteTripProd(tripProdNo);
    }
    
    @Override
    public Map<String, Object> getTourStats() {
        return adminTourMapper.getTourStats();
    }
}
