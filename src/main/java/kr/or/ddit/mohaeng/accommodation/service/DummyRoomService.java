package kr.or.ddit.mohaeng.accommodation.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import kr.or.ddit.mohaeng.accommodation.mapper.IAccommodationMapper;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.RoomFacilityVO;
import kr.or.ddit.mohaeng.vo.RoomFeatureVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class DummyRoomService  {

	 private final IAccommodationMapper accMapper;

	    @Transactional
	    public void createDummyRooms(AccommodationVO acc) {
	        log.info("더미 객실 생성 시작 (accNo={})", acc.getAccNo());

	        createRoomTypeFull(acc, "스탠다드룸", 2, 4, 70000, 20, "N", 3);
	        createRoomTypeFull(acc, "디럭스룸", 2, 4, 120000, 35, "Y", 2);

	        log.info("더미 객실 생성 완료 (accNo={})", acc.getAccNo());
	    }

	    private void createRoomTypeFull(AccommodationVO acc, String name,
	                                    int base, int max, int price, int size,
	                                    String breakfastYn, int roomCount) {

	        RoomTypeVO roomType = new RoomTypeVO();
	        roomType.setAccNo(acc.getAccNo());
	        roomType.setRoomName(name);
	        roomType.setBaseGuestCount(base);
	        roomType.setMaxGuestCount(max);
	        roomType.setBedCount(1);
	        roomType.setBedTypeCd("DOUBLE");
	        roomType.setTotalRoomCount(roomCount);
	        roomType.setPrice(price);
	        roomType.setDiscount(0);
	        roomType.setExtraGuestFee(20000);
	        roomType.setRoomSize(size);
	        roomType.setBreakfastYn(breakfastYn);

	        accMapper.insertRoomType(roomType);
	        int roomTypeNo = roomType.getRoomTypeNo();

	        insertDummyRoomFacility(roomTypeNo);
	        insertDummyRoomFeature(roomTypeNo);
	        insertDummyRooms(roomTypeNo, 3);
	    }

		private void insertDummyRoomFacility(int roomTypeNo) {
	        RoomFacilityVO f = new RoomFacilityVO();
	        f.setRoomTypeNo(roomTypeNo);
	        f.setAirConYn("Y");
	        f.setTvYn("Y");
	        f.setMinibarYn("N");
	        f.setFridgeYn("Y");
	        f.setSafeBoxYn("N");
	        f.setHairDryerYn("Y");
	        f.setBathtubYn("Y");
	        f.setToiletriesYn("Y");

	        accMapper.insertRoomFacility(f);
	    }

	    
	    public void insertDummyRoomFeature(int roomTypeNo) {

	        RoomFeatureVO feature = new RoomFeatureVO();
	        feature.setRoomTypeNo(roomTypeNo);

	        // 기본값: 더미니까 전부 보수적으로 N
	        feature.setFreeCancelYn("N");
	        feature.setOceanViewYn("N");
	        feature.setMountainViewYn("N");
	        feature.setCityViewYn("N");
	        feature.setLivingRoomYn("N");
	        feature.setTerraceYn("N");
	        feature.setNonSmokingYn("Y");   // 보통 기본은 금연
	        feature.setKitchenYn("N");

	        accMapper.insertRoomFeature(feature);
	    }

	    private void insertDummyRooms(int roomTypeNo, int count) {
	        for (int i = 0; i < count; i++) {
	            accMapper.insertRoom(roomTypeNo);
	        }
	    }
	
}
