package kr.or.ddit.mohaeng.product.manage.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.product.manage.mapper.IProductMangeMapper;
import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdPlaceVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccOptionVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.BusinessProductsVO;
import kr.or.ddit.mohaeng.vo.RoomFacilityVO;
import kr.or.ddit.mohaeng.vo.RoomFeatureVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;
import kr.or.ddit.mohaeng.vo.RoomVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProductMangeServiceImpl implements IProductMangeService {


	// 투어같은 상품 조회
	@Autowired
	private IProductMangeMapper manageMapper;
	
	@Override
	public List<BusinessProductsVO> getProductlist(BusinessProductsVO businessProducts) {
		return manageMapper.getProductlist(businessProducts);
	}
	
	@Override
	public List<AccommodationVO> getAccommodationList(BusinessProductsVO businessProducts) {
		return manageMapper.getAccommodationList(businessProducts);
	}
	
	@Override
	public TripProdVO getProductAggregate(TripProdVO tripProd) {
		return manageMapper.getProductAggregate(tripProd);
	}
	
	@Override
	public BusinessProductsVO getProductDetail(BusinessProductsVO businessProducts) {
		
		// 상품 정보, 상품 이용안내, 상품 가격, 여행 상품 관광지
		BusinessProductsVO prodVO = manageMapper.retrieveProductDetail(businessProducts);
		log.info("retrieveProductDetail-retrieveProductDetail : {}", prodVO);

		// 숙소 타입일 경우에는 이렇게
		if(prodVO.getProdCtgryType().equals("accommodation")) {
			int accNo = 0;
			if(businessProducts.getAccNo() != 0) {
				accNo = businessProducts.getAccNo();
			}
			
			AccommodationVO accommodationvo = new AccommodationVO();
			accommodationvo.setAccNo(accNo);
			
			AccommodationVO accommodation = manageMapper.retrieveAccomodationDetail(accommodationvo);
			prodVO.setAccommodation(accommodation);
			log.info("retrieveAccomodationDetail : {}", accommodation.getRoomTypeList().size());
			
			List<AttachFileDetailVO> accommodationImages = new ArrayList<>();
			
			int fileNo = accommodation.getAccFileNo() != 0 ? accommodation.getAccFileNo() : 0;
			accommodationImages = manageMapper.retrieveProdImages(businessProducts);	// 여기에 들어있는 것은 accFileNo
			// 숙소용 사진은 accommodation에 있음
			// accommodation에 있는 것
			if(accommodationImages != null && accommodationImages.size() > 0) {
				prodVO.setImageList(accommodationImages);
			}
			
		// 숙소가 아닐때는 이렇게
		} else {
			List<ProdTimeInfoVO> prodTimeList = manageMapper.retrieveProdTimeList(prodVO);
			log.info("retrieveProductDetail-retrieveProdTimeList : {}", prodTimeList);
			
			if(prodTimeList != null && prodTimeList.size() > 0) {
				prodVO.setProdTimeList(prodTimeList);
				log.info("prod setProdTimeList : {}", prodVO.getProdTimeList());
			}
			
			List<AttachFileDetailVO> productImages = new ArrayList<>();
			
			// 상품 사진
			if (prodVO.getAttachNo() != null && prodVO.getAttachNo() > 0) {
				productImages = manageMapper.retrieveProdImages(prodVO);
				log.info("getAttachFileDetails : {}", productImages);
			}
			
			if(productImages != null && productImages.size() > 0) {
				prodVO.setImageList(productImages);
			}
		}
		
		
		return prodVO;
	}
	
	@Override
	@Transactional
	public ServiceResult modifyProduct(BusinessProductsVO businessProducts) {
		ServiceResult result = null;
		
		log.info("modifyProduct 실행");
	
		int tripProdNo = businessProducts.getTripProdNo();
		int baseStatus = 0;
		// 변수 바뀔수도, 1대1관계들 update -> 상품, 상품 이용안내, 상품 가격, 상품 장소
		// 상품
		int productstatus = 0;	// 1 , 0
		productstatus = manageMapper.modifyTripProduct(businessProducts);
		log.info("productstatus : {}", productstatus);
		
		// 숙박
		if(businessProducts.getProdCtgryType() != null && businessProducts.getProdCtgryType().equals("accommodation")) {
			
			// 여기에 숙박과 관련된 모든 정보 있음
			int accStatus = 0;
			AccommodationVO accommodation = businessProducts.getAccommodation();
			log.info("accommodation : {}", accommodation);
			int accNo = businessProducts.getAccNo();
			accommodation.setTripProdNo(tripProdNo);
			
			// accommodation update
			// 업데이트
			
			int optionStatus = 0;
			// 1 대 n
			// accOption update
			List<AccOptionVO> accOptionList = accommodation.getAccOptionList();
			log.info("accOptionList : {}", accOptionList);
			for(AccOptionVO accOptionVO : accOptionList) {
				accOptionVO.setAccNo(accNo);
			}
			
			int accFacilityStatus = 0;
			// 1대1
			// accFacility update 이걸로 하기
			AccFacilityVO accFacilityVO = accommodation.getAccFacility();
			accFacilityVO.setAccNo(accNo);
			
			
			int roomTypeStatus = 0;
			// accommodation과 1대n
			// 예약 내역이 없으면 삭제 하기 ??
			// roomType update 
			List<RoomTypeVO> roomTypeList = accommodation.getRoomTypeList();
			for(RoomTypeVO roomTypeVO : roomTypeList) {
				int roomCnt = roomTypeVO.getTotalRoomCount();	// 이만큼 roomList가 돌거임
				roomTypeStatus = 0;
				roomTypeVO.setAccNo(accNo);
				// update
				// roomType과 1대1
				// roomFacility update
				
				
				// roomType과 1대 n
				// 객실 수 줄였을때 없데이트 되는건가???
				// room update
				List<RoomVO> roomList = roomTypeVO.getRoomList();
				
				RoomFacilityVO roomFacilityVO = roomTypeVO.getFacility(); 
				
				// roomType과 1대1
				// roomFeature update
				RoomFeatureVO roomFeatureVO = roomTypeVO.getFeature();
			}

			// 예약은 못건들일거야.
			// 각자 어떻게 해야될지 모르것따.
			
			
			if (baseStatus == 4) {
		        log.info("수정 최종 성공");
		        return ServiceResult.OK;
		    } else {
		        log.error("수정 실패");
		        return ServiceResult.FAILED;
		    }
		}else {
			// 상품 가격
			int saleStatus = 0;
			TripProdSaleVO prodSaleVO = businessProducts.getProdSale();
			prodSaleVO.setTripProdNo(tripProdNo);
			saleStatus = manageMapper.modifyProdSale(prodSaleVO);
			log.info("saleStatus : {}", saleStatus);
			
			// 상품 이용안내
			int infoStatus = 0;
			TripProdInfoVO prodInfoVO = businessProducts.getProdInfo();
			prodInfoVO.setTripProdNo(tripProdNo);
			infoStatus = manageMapper.modifyProdInfo(prodInfoVO);
			log.info("infoStatus : {}", infoStatus);
			
			// 상품 장소
			int placeStatus = 0;
			TripProdPlaceVO prodPlaceVO = businessProducts.getProdPlace();
			prodPlaceVO.setTripProdNo(tripProdNo);
			placeStatus = manageMapper.modifyProdPlace(prodPlaceVO);
			log.info("placeStatus : {}", placeStatus);
			
			// 결과 비교
			baseStatus = productstatus + saleStatus + infoStatus + placeStatus;	// 4
			// 숙소 
			
			// 예약가능시간(예약 가능 시간)
			int productTimetatus = 0;
			productTimetatus = manageMapper.deleteProdTimeInfo(businessProducts);
			log.info("deleteProdInfo : {}", productTimetatus);
			
			// 예약시간 수정
			List<ProdTimeInfoVO> prodTimeInfoVO = businessProducts.getProdTimeList();
			log.info("prodTimeInfoVO.길이 : {}", prodTimeInfoVO);
			boolean isTimeSuccess = true; // 시간 처리 성공 여부 플래그
			if (prodTimeInfoVO != null && !prodTimeInfoVO.isEmpty()) {
				for(ProdTimeInfoVO timeInfo : prodTimeInfoVO) {
					timeInfo.setTripProdNo(tripProdNo);
				}
				
				int insertCount = manageMapper.insertProdTimeInfo(prodTimeInfoVO);
				log.info("시간 등록 개수: {}, 기대 개수: {}", insertCount, prodTimeInfoVO.size());
				
				if (insertCount != prodTimeInfoVO.size()) {
					isTimeSuccess = false;
				}
			}
	
			if (baseStatus == 4 && isTimeSuccess) {
		        log.info("수정 최종 성공");
		        return ServiceResult.OK;
		    } else {
		        log.error("수정 실패");
		        return ServiceResult.FAILED;
		    }
		}
	}
	
	@Override
	public ServiceResult updateProductStatus(TripProdVO tripProd) {
		ServiceResult result = null;
		log.info("updateProductStatus 실행 : {}", tripProd);
		if (tripProd.getApproveStatus().equals("판매중")) {
			tripProd.setApproveStatus("판매중지");
		} else {
			tripProd.setApproveStatus("판매중");
		}
		
		int status = manageMapper.updateProductStatus(tripProd);
		log.info("status : {}", status);
		if(status > 0) {
			return result = ServiceResult.OK;
		} else {
			return result = ServiceResult.FAILED;
		}
	}

	@Override
	public ServiceResult deleteProductStatus(TripProdVO tripProd) {
		ServiceResult result = null;
		log.info("updateProductStatus 실행 : {}", tripProd);
		
		int status = manageMapper.deleteProductStatus(tripProd);
		log.info("status : {}", status);
		if(status > 0) {
			return result = ServiceResult.OK;
		} else {
			return result = ServiceResult.FAILED;
		}
	}

}
