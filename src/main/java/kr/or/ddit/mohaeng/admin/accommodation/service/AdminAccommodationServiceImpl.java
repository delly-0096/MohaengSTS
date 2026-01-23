package kr.or.ddit.mohaeng.admin.accommodation.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.admin.accommodation.mapper.IAdminAccommodationMapper;
import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccOptionVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.RoomFacilityVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional(readOnly = true)
public class AdminAccommodationServiceImpl implements IAdminAccommodationService{
	
	@Autowired
	private IAdminAccommodationMapper adminAccMapper;
	
	/**
	 * 숙박 전체 목록 조회
	 * @author kdrs
	 * @date 2026.01.22
	 */
	@Override
	public void getAccommodationList(PaginationInfoVO<AccommodationVO> pagInfoVO) {
		int totalRecord = adminAccMapper.getAccommodationCount(pagInfoVO);
		
		pagInfoVO.setTotalRecord(totalRecord);
		// 명단 추출 : 창고에서 명단 가져와 리스트 작성
		List<AccommodationVO> dataList = adminAccMapper.getAccommodationList(pagInfoVO);
		// 리스트 pagInfoVO에 담기=>화면으로 보낼것임
		pagInfoVO.setDataList(dataList);
		
	}

	/**
	 * 숙박 상세 조회
	 * @author kdrs
	 * @date 2026.01.23
	 */
	@Override
	public AccommodationVO getAccommodationDetail(int tripProdNo) {
		
		// 상품 + 숙소
		AccommodationVO accommodation = 
				adminAccMapper.selectAccommodationBase(tripProdNo);
		int accNo = accommodation.getAccNo();
		
		if (accommodation == null) {
			return null;
		}
		
	    // 이미지
	    if (accommodation.getAccFileNo() != 0) {
	        List<AttachFileDetailVO> images =
	                adminAccMapper.selectAccommodationImages(
	                        accommodation.getAccFileNo()
	                );
	        accommodation.setImageList(images);
	    }
	    
		// 객실 목록
	    List<RoomTypeVO> roomTypeList = adminAccMapper.selectRoomTypesByTripProdNo(tripProdNo);
	    if (roomTypeList == null) {
	        roomTypeList = new ArrayList<>();
	    }
	    accommodation.setRoomTypeList(roomTypeList);
		
		// 숙박 시설
		AccFacilityVO facility =
				adminAccMapper.selectAccommodationFacilityByTripProdNo(tripProdNo);
		accommodation.setAccFacility(facility);
		
		// 객실 시설
		if (!roomTypeList.isEmpty()) {
	        List<RoomFacilityVO> roomFacilityList = adminAccMapper.selectRoomFacilitiesByTripProdNo(tripProdNo);
	        if (roomFacilityList != null) {
	            Map<Integer, RoomFacilityVO> facilityMap = roomFacilityList.stream()
	                .collect(Collectors.toMap(RoomFacilityVO::getRoomTypeNo, f -> f, (existing, replacement) -> existing));
	            
	            for (RoomTypeVO room : roomTypeList) {
	                room.setFacility(facilityMap.get(room.getRoomTypeNo()));
	            }
	        }
	    }
		
		List<AccOptionVO> accOptionList = adminAccMapper.selectAccommodationOptionByTripProdNo(tripProdNo);
	    accommodation.setAccOptionList(accOptionList);
		
		return accommodation;
	}

}
