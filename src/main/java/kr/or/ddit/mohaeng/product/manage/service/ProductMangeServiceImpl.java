package kr.or.ddit.mohaeng.product.manage.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.product.inquiry.service.ITripProdInquiryService;
import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;
import kr.or.ddit.mohaeng.product.manage.mapper.IProductMangeMapper;
import kr.or.ddit.mohaeng.product.review.service.IProdReviewService;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;
import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdPlaceVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccOptionVO;
import kr.or.ddit.mohaeng.vo.AccResvOptionVO;
import kr.or.ddit.mohaeng.vo.AccResvVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.BusinessProductsVO;
import kr.or.ddit.mohaeng.vo.RoomFacilityVO;
import kr.or.ddit.mohaeng.vo.RoomFeatureVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;
import kr.or.ddit.mohaeng.vo.RoomVO;
import kr.or.ddit.mohaeng.vo.TripProdListVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProductMangeServiceImpl implements IProductMangeService {


	// 투어같은 상품 조회
	@Autowired
	private IProductMangeMapper manageMapper;
	
	// 사진 저장용
	@Autowired
	private IFileService fileService;
	
	// 문의 내역 가져오기
	@Autowired
	private ITripProdInquiryService inquiryService;
	
	// 리뷰 내역 가져오기
	@Autowired
	private IProdReviewService prodReviewService;
	
	@Override
	public List<BusinessProductsVO> getProductlist(BusinessProductsVO businessProducts) {
		return manageMapper.getProductlist(businessProducts);
	}
//	
//	@Override
//	public List<AccommodationVO> getAccommodationList(BusinessProductsVO businessProducts) {
//		return manageMapper.getAccommodationList(businessProducts);
//	}
	
	@Override
	public TripProdVO getProductAggregate(TripProdVO tripProd) {
		return manageMapper.getProductAggregate(tripProd);
	}
	
	@Override
	public BusinessProductsVO getProductDetail(BusinessProductsVO businessProducts) {
		
		// 상품 정보, 상품 이용안내, 상품 가격, 여행 상품 관광지
		BusinessProductsVO prodVO = manageMapper.retrieveProductDetail(businessProducts);
		log.info("retrieveProductDetail-retrieveProductDetail : {}", prodVO);
		
		int tripProdNo = prodVO.getTripProdNo();
		
		// 숙소 타입일 경우에는 이렇게
		if(prodVO.getProdCtgryType().equals("accommodation")) {
			int accNo = 0;
			if(businessProducts.getAccNo() != 0) {
				accNo = businessProducts.getAccNo();
			}
			
			AccommodationVO accommodationvo = new AccommodationVO();
			accommodationvo.setAccNo(accNo);
			
			AccommodationVO accommodation = manageMapper.retrieveAccomodationDetail(accommodationvo);
			log.info("accommodation : 불러왔다 : {}", accommodation);
			log.info("accommodation : 객실 타입 불러왔다 : {}", accommodation.getRoomTypeList());
			
//			prodVO.setAccommodation(accommodation);
			log.info("retrieveAccomodationDetail : {}", accommodation.getRoomTypeList().size());
			
			List<AttachFileDetailVO> accommodationImages = new ArrayList<>();
			
			int fileNo = accommodation.getAccFileNo() != 0 ? accommodation.getAccFileNo() : 0;
			accommodationImages = manageMapper.retrieveProdImages(businessProducts);	// 여기에 들어있는 것은 accFileNo
			// 숙소용 사진은 accommodation에 있음
			// accommodation에 있는 것
			if(accommodationImages != null && accommodationImages.size() > 0) {
				prodVO.setImageList(accommodationImages);
			}
			
			// 숙소 예약 내역
			List<AccResvVO> accResvList = new ArrayList<>();
			accResvList = manageMapper.getAccResvList(accommodationvo);
			log.info("accResvList : {} ", accResvList);
			if(accResvList != null && accResvList.size() > 0 ) {
				for(RoomTypeVO roomTypeVO : accommodation.getRoomTypeList()) {
					List<AccResvVO> filteredResv = new ArrayList<>();
				    for (AccResvVO accResvVO : accResvList) {
				        if (roomTypeVO.getRoomTypeNo() == accResvVO.getRoomTypeNo()) {
				            filteredResv.add(accResvVO);
				        }
				    }
				    roomTypeVO.setAccResvList(filteredResv);
				}
			}
			prodVO.setAccommodation(accommodation);
			
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
			
			// 예약 내역 = tripProdList
			List<TripProdListVO> prodList = new ArrayList<>();
			prodList = manageMapper.getReservation(businessProducts);	// 번호
			log.info("prodList : {}", prodList);
			prodVO.setProdList(prodList);
		}
		
		// 리뷰
		List<ProdReviewVO> prodReviewList = new ArrayList<>();
		prodReviewList = 
				prodReviewService.getReviewPaging(tripProdNo, 1, 100);
		
		log.info("prodReviewList : {}", prodReviewList);
		prodVO.setProdReviewList(prodReviewList);
		
		// 문의사항
		List<TripProdInquiryVO> inquiryList = new ArrayList<>();
		inquiryList = 
				inquiryService.getInquiryPaging(tripProdNo, 1, 100);
		log.info("inquiryList : {}", inquiryList);
		prodVO.setProdInquiryList(inquiryList);
		
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
			accStatus = manageMapper.modifyAccommodation(accommodation);
			
			
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
			
			// 사진 숙소일경우 accommodation의 accFileNo없는 파일은 insert 
			// -> 기존nos에 있는 것들과 비교해서 같은 attachNo부여하고 index로 
			
			
			
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
			
			// 사진 정보 List<MultipartFile> 받고 attachDetail에서 관리하기 -> 새로운 파일에 attachNo 설정해주기
			
			// 예약가능시간(예약 가능 시간)
			int productTimetatus = 0;
			productTimetatus = manageMapper.deleteProdTimeInfo(businessProducts);
			log.info("deleteProdInfo : {}", productTimetatus);
			
			// 예약시간 수정
			List<ProdTimeInfoVO> prodTimeInfoVO = businessProducts.getProdTimeList();
			log.info("prodTimeInfoVO.길이 : {}", prodTimeInfoVO);
			boolean isTimeSuccess = true; // 시간 처리 성공 여부 플래그
			int totalSuccess = 0;
//			int size
			if (prodTimeInfoVO != null && !prodTimeInfoVO.isEmpty()) {
				int insertCount = 0;
				
				for(ProdTimeInfoVO timeInfo : prodTimeInfoVO) {
					timeInfo.setTripProdNo(tripProdNo);
					insertCount += manageMapper.insertProdTimeInfo(timeInfo);
				}
				
				if(insertCount > 0 ) {
					totalSuccess += insertCount; 
				}
				
				log.info("시간 등록 개수: {}, 기대 개수: {}", insertCount, prodTimeInfoVO.size());
				
				if (totalSuccess != prodTimeInfoVO.size()) {
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

	@Override
	@Transactional
	public ServiceResult insertProduct(BusinessProductsVO businessProducts, List<MultipartFile> uploadFiles) {
		ServiceResult result = null;
		
		// 기업번호 세팅
		log.info("insertProduct - 기업번호 얻기");
		int compNo = manageMapper.getComp(businessProducts.getMemNo());
		log.info("insertProduct - 기업번호 얻기 : {}", compNo);
		businessProducts.setCompNo(compNo);
		
		String category = businessProducts.getProdCtgryType();
		
		// 사진 등록 
		int attachNo = 0;
		if(category != null && category.equals("accommodation")) {
			attachNo = fileService.saveFiles(uploadFiles, "product", "ACCOMMODATION", businessProducts.getMemNo());
			businessProducts.getAccommodation().setAccFileNo(attachNo);
			log.info("사진 등록은 ?? : {}", attachNo);
		}
		
		if(category != null && !category.equals("accommodation")) {
			attachNo = fileService.saveFiles(uploadFiles, "product", "PRODUCT", businessProducts.getMemNo());
			businessProducts.setAttachNo(attachNo);
		}
		
		
		int status = 0;
		// 상품 등록
		status = manageMapper.insertTripProudct(businessProducts);
		log.info("insertProduct - 상품 등록");
		if(status <= 0) {
			return result = ServiceResult.FAILED;
		}
		status = 0;
		
		int tripProdNO = businessProducts.getTripProdNo();	// 등록해서 얻은 tripProdkey
		
		// 숙소 등록
		if(category != null && category.equals("accommodation")) {
			AccommodationVO accommodationVO = businessProducts.getAccommodation();
			accommodationVO.setTripProdNo(tripProdNO);
			return insertAccommodationDetail(accommodationVO);
			
		}else {
			// 상품 등록
			return insertTripProductDetail(businessProducts, tripProdNO);
		}
	}
	
	
	/**
	 * <p>상품판매정보, 상품이용안내, 여행 상품 관광지 등록</p>
	 * @author sdg
	 * @date 2026-01-25
	 * @param businessProducts 상품
	 * @param tripProdNo 상품 번호
	 * @return ok, failed
	 */
	private ServiceResult insertTripProductDetail(BusinessProductsVO businessProducts, int tripProdNO) {
		ServiceResult result = null;
		if(tripProdNO == 0) {
			return result = ServiceResult.FAILED;
		}
		
		int status = 0;
		
		log.info("insertProduct - insertTripProductDetail  상품 판매정보 등록");
		
		// 상품 판매 정보
		TripProdSaleVO prodSaleVO = businessProducts.getProdSale();
		prodSaleVO.setTripProdNo(tripProdNO);
		int netprc = prodSaleVO.getNetprc();
		int price = prodSaleVO.getPrice() != 0 ? prodSaleVO.getPrice() : 0;
		int discount = (prodSaleVO.getDiscount() != null && prodSaleVO.getDiscount() != 0 ) ? prodSaleVO.getDiscount() : 0;
		
		if(discount > 0) {
			price = netprc - discount;
			prodSaleVO.setPrice(price);
		} else {
			prodSaleVO.setPrice(netprc);
		}
		
		
		status = manageMapper.insertTripProdSale(prodSaleVO);
		if(status <= 0) {
			log.error("insertProduct - insertTripProductDetail 상품 판매정보 등록 실패");
			return result = ServiceResult.FAILED;
		}
		log.info("insertProduct - insertTripProductDetail 상품 판매정보 등록 성공");
		status = 0;

		
		// 상품 관광지 정보
		TripProdPlaceVO placeVO = businessProducts.getProdPlace();
		placeVO.setTripProdNo(tripProdNO);
		log.info("insertProduct - insertTripProductDetail 상품 관광지 정보 등록");
		status= manageMapper.insertTripProdPlace(placeVO);
		if(status <= 0) {
			log.error("insertProduct - insertTripProductDetail 상품 관광지 정보 등록 실패");
			return result = ServiceResult.FAILED;
		}
		log.info("insertProduct - insertTripProductDetail 상품 관광지 정보 등록 성공");
		status = 0;
		
		// 상품 이용안내
		TripProdInfoVO prodInfoVO = businessProducts.getProdInfo();
		prodInfoVO.setTripProdNo(tripProdNO);
		log.info("insertProduct - insertTripProductDetail 상품 이용안내 정보 등록");
		status = manageMapper.insertTripProdInfo(prodInfoVO);
		if(status <= 0) {
			log.error("insertProduct - insertTripProductDetail 상품 이용안내 정보 등록 실패");
			return result = ServiceResult.FAILED;
		}
		
		log.info("insertProduct - insertTripProductDetail 상품 이용안내 정보 등록 성공");
		status = 0;
		
		// 여행 가능 시간 정보
		List<ProdTimeInfoVO> prodTimeInfoList = businessProducts.getProdTimeList();
		if(prodTimeInfoList == null && prodTimeInfoList.size() <= 0) {
			// 없어도 가능하게 해?
			return result = ServiceResult.FAILED;
		}
		// 정보 있을때
		return insertTripProdTimeInfo(prodTimeInfoList, tripProdNO);
	}
	
	/**
	 * <p>예약 가능 시간 등록</p>
	 * @author sdg
	 * @date 2026-01-26
	 * @param prodTimeInfoList	숙소 시간 정보
	 * @param tripProdNO 		상품 키
	 * @return
	 */
	private ServiceResult insertTripProdTimeInfo(List<ProdTimeInfoVO> prodTimeInfoList, int tripProdNO) {
		ServiceResult result = null;
		int status = 0;
		int totalSuccess = 0;
		int count = prodTimeInfoList.size();
		
		for(ProdTimeInfoVO prodTimeInfoVO : prodTimeInfoList) {
			prodTimeInfoVO.setTripProdNo(tripProdNO);
			status = manageMapper.insertProdTimeInfo(prodTimeInfoVO);
			log.info("insertProduct - insertTripProdTimeInfo 예약 가능 시간 등록 성공");
			if(status <= 0) {
				log.error("insertProduct - insertTripProdTimeInfo 예약 가능 시간 등록 실패");
				return result = ServiceResult.FAILED;
			}else {
				totalSuccess += status;
				log.info("예약 시간 등록 성공 (현재 {}/{}건)", totalSuccess, count);
			}
			
		}
		
		return (count == totalSuccess) ? ServiceResult.OK : ServiceResult.FAILED;
	}
	
	
	/**
	 * <p>숙소, 숙소 보유시설, 숙소 옵션목록 등록</p>
	 * @author sdg
	 * @date 2026-01-25
	 * @param accommodationVO 숙소 상품 
	 * @return ok, failed
	 */
	private ServiceResult insertAccommodationDetail(AccommodationVO accommodationVO) {
		ServiceResult result = null;
		int status = 0;
		log.info("insertProduct - insertAccommodationDetail  숙소 등록");
		status = manageMapper.insertAccommodation(accommodationVO);
		if(status <= 0) {
			log.error("insertProduct - insertAccommodationDetail 숙소 등록 실패");
			return result = ServiceResult.FAILED;
		}
		log.info("insertProduct - insertAccommodationDetail 숙소 등록 성공");
		status = 0;
		
		// 숙소 기본키
		int accNo = accommodationVO.getAccNo();
		
		// 숙소 보유시설
		AccFacilityVO accFacilityVO = accommodationVO.getAccFacility();
		accFacilityVO.setAccNo(accNo);
		log.info("insertProduct - insertAccommodationDetail  숙소 보유시설 등록");
		status = manageMapper.insertAccFacility(accFacilityVO);
		if(status <= 0) {
			log.error("insertProduct - insertAccommodationDetail 숙소 보유시설등록 실패");
			return result = ServiceResult.FAILED;
		}
		log.info("insertProduct - insertAccommodationDetail 숙소 보유시설등록 성공");
		status = 0;
				
		// 숙소 옵션 
		List<AccOptionVO> optionList = accommodationVO.getAccOptionList();
		if(optionList != null && optionList.size() > 0) {
			log.info("insertProduct - insertAccommodationDetail 숙소 옵션 등록");
			// 키 세팅 하기
			for(AccOptionVO accOptionVO : optionList) {
				accOptionVO.setAccNo(accNo);
				status = manageMapper.insertAccOption(accOptionVO);
			}
			if(status <= 0) {
				log.error("insertProduct - insertAccommodationDetail 숙소 옵션 등록 실패");
				return result = ServiceResult.FAILED;
			}
			log.info("insertProduct - insertAccommodationDetail 숙소 옵션 등록 성공");
		}
		status = 0;
		
		// 방 타입 list - roomFacility, roomFeature
		List<RoomTypeVO> roomTypeList = accommodationVO.getRoomTypeList();
		if(roomTypeList != null && roomTypeList.size() > 0) {
			return insertRoomTypes(roomTypeList, accNo);
		}
		return result = ServiceResult.OK;
	}

	
	/**
	 * <p>객실 타입, 객실 내 특징, 객실 내 시설</p>
	 * @param roomTypeList 객실 타입 객체
	 * @param accNo	숙소 기본키
	 * @return ok, failed
	 */
	private ServiceResult insertRoomTypes(List<RoomTypeVO> roomTypeList, int accNo) {
		ServiceResult result = null;
		log.info("insertProduct - insertRoomTypes 객실 타입 등록");
		
		int status = 0;
		for(RoomTypeVO roomTypeVO : roomTypeList) {
			roomTypeVO.setAccNo(accNo);
			status = manageMapper.insertRoomType(roomTypeVO);
			if(status <= 0) {
				log.error("insertProduct - insertRoomTypes 객실 타입 등록 실패");
				return result = ServiceResult.FAILED;
			}
			log.info("insertProduct - insertRoomTypes 객실 타입 등록 성공");
			status = 0;
			
			int roomTypeNo = roomTypeVO.getRoomTypeNo();
			
			// 객실 내 시설
			RoomFacilityVO facilityVO = roomTypeVO.getFacility();
			facilityVO.setRoomTypeNo(roomTypeNo);
			if(facilityVO != null) {
				log.info("insertProduct - insertRoomTypes 객실 내 시설 등록");
				status = manageMapper.insertRoomFcaility(facilityVO);
				if(status <= 0) {
					log.error("insertProduct - insertRoomTypes 객실 내 시설 등록 실패");
					return result = ServiceResult.FAILED;
				}
				log.info("insertProduct - insertRoomTypes 객실 내 시설 등록 성공");
				status = 0;
			}
			
			// 객실 내 특징
			RoomFeatureVO featureVO = roomTypeVO.getFeature();
			featureVO.setRoomTypeNo(roomTypeNo);
			if(featureVO != null) {
				log.info("insertProduct - insertRoomTypes 객실 내 특징 등록");
				status = manageMapper.insertRoomFeature(featureVO);
				if(status <= 0) {
					log.error("insertProduct - insertRoomTypes 객실 내 특징 등록 실패");
					return result = ServiceResult.FAILED;
				}
				log.info("insertProduct - insertRoomTypes 객실 내 특징 등록 성공");
				status = 0;
			}
			
			// 객실 등록 (객실타입의 수 만큼의 객실 생성)
			int roomStatus = 0; 
			roomStatus = insertRoom(roomTypeVO, roomTypeNo);
			if(roomStatus <= 0) {
				log.error("객실 등록 실패");
				return result = ServiceResult.FAILED;
			}
			log.info("객실 등록 성공");
		}
		
		return result = ServiceResult.OK;
	}

	
	/**
	 * <p>객실</p>
	 * @param roomTypeVO 객실 타입 정보
	 * @param roomTypeNo 객실키
	 * @return 1, 0
	 */
	private int insertRoom(RoomTypeVO roomTypeVO, int roomTypeNo) {
		int count = roomTypeVO.getTotalRoomCount(); // 생성해야 할 객실 수
	    int successCount = 0;

	    log.info("insertProduct - insertRoom 시작 (생성 개수: {})", count);

	    for (int i = 1; i <= count; i++) {
	        RoomVO roomVO = new RoomVO();
	        roomVO.setRoomTypeNo(roomTypeNo);
	        
	        int status = manageMapper.insertRoom(roomVO);
	        if (status > 0) {
	            successCount++;
	        }
	    }

	    log.info("insertProduct - insertRoom 완료 (성공: {} / 전체: {})", successCount, count);

	    // 모든 객실이 정상 등록되었는지 확인
	    return (successCount == count) ? 1 : 0;
	}

}
