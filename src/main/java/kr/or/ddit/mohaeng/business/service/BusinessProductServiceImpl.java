package kr.or.ddit.mohaeng.business.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.business.mapper.IBusinessProductMapper;
import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdPlaceVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.BusinessProductsVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BusinessProductServiceImpl implements IBusinessProductService {


	// 투어같은 상품 조회
	@Autowired
	private IBusinessProductMapper businessMapper;
	
	@Override
	public List<BusinessProductsVO> getProductlist(BusinessProductsVO businessProducts) {
		return businessMapper.getProductlist(businessProducts);
	}
	
	@Override
	public List<AccommodationVO> getAccommodationList(BusinessProductsVO businessProducts) {
		return businessMapper.getAccommodationList(businessProducts);
	}
	
	@Override
	public TripProdVO getProductAggregate(TripProdVO tripProd) {
		return businessMapper.getProductAggregate(tripProd);
	}
	
	@Override
	public BusinessProductsVO retrieveProductDetail(BusinessProductsVO businessProducts) {
		// 상품 정보, 상품 이용안내, 상품 가격, 여행 상품 관광지
		BusinessProductsVO prodVO = businessMapper.retrieveProductDetail(businessProducts); 
		// 나머지 1대다 매칭 후 보내기
		log.info("retrieveProductDetail-retrieveProductDetail : {}", prodVO);
		
		// 상품 이용안내 별, 예약가능시간(예약 가능 시간)
		List<ProdTimeInfoVO> prodTimeList = businessMapper.retrieveProdTimeList(prodVO);
		log.info("retrieveProductDetail-retrieveProdTimeList : {}", prodTimeList);
		
		if(prodTimeList.size() > 0 && prodTimeList != null) {
			prodVO.setProdTimeList(prodTimeList);
			log.info("prod setProdTimeList : {}", prodVO.getProdTimeList());
		}
		
		// 상품 사진
		List<AttachFileDetailVO> productImages = new ArrayList<>();
		
		if (prodVO.getAttachNo() != null && prodVO.getAttachNo() > 0) {
            productImages = businessMapper.retrieveProdImages(prodVO);
			log.info("getAttachFileDetails : {}", productImages);
        }
		
		if(productImages != null && productImages.size() > 0) {
			prodVO.setImageList(productImages);
		}
		
		// 숙소 정보
		
		return prodVO;
	}
	
	@Override
//	@Transactional
	public ServiceResult modifyProduct(BusinessProductsVO businessProducts) {
		ServiceResult result = null;
		
		int tripProdNo = businessProducts.getTripProdNo();
		// 변수 바뀔수도, 1대1관계들 update -> 상품, 상품 이용안내, 상품 가격, 상품 장소
		// 상품
		int productstatus = 0;	// 1 , 0
		productstatus = businessMapper.modifyTripProduct(businessProducts);
		log.info("productstatus : {}", productstatus);
		
		
		// 상품 가격
		int saleStatus = 0;
		TripProdSaleVO prodSaleVO = businessProducts.getProdSale();
		prodSaleVO.setTripProdNo(tripProdNo);
		saleStatus = businessMapper.modifyProdSale(prodSaleVO);
		log.info("saleStatus : {}", saleStatus);
		
		// 상품 이용안내
		int infoStatus = 0;
		TripProdInfoVO prodInfoVO = businessProducts.getProdInfo();
		prodInfoVO.setTripProdNo(tripProdNo);
		infoStatus = businessMapper.modifyProdInfo(prodInfoVO);
		log.info("infoStatus : {}", infoStatus);
		
		// 상품 장소
		int placeStatus = 0;
		TripProdPlaceVO prodPlaceVO = businessProducts.getProdPlace();
		prodPlaceVO.setTripProdNo(tripProdNo);
		placeStatus = businessMapper.modifyProdPlace(prodPlaceVO);
		log.info("placeStatus : {}", placeStatus);
		
		// 결과 비교
		int baseStatus = productstatus + saleStatus + infoStatus + placeStatus;	// 4
		// 숙소 
		
		// 예약가능시간(예약 가능 시간)
		int productTimetatus = 0;
		productTimetatus = businessMapper.deleteProdTimeInfo(businessProducts);
		log.info("deleteProdInfo : {}", productTimetatus);
		
		// 예약시간 수정
		List<ProdTimeInfoVO> prodTimeInfoVO = businessProducts.getProdTimeList();
		log.info("prodTimeInfoVO.길이 : {}", prodTimeInfoVO);
		boolean isTimeSuccess = true; // 시간 처리 성공 여부 플래그
		if (prodTimeInfoVO != null && !prodTimeInfoVO.isEmpty()) {
			for(ProdTimeInfoVO timeInfo : prodTimeInfoVO) {
				timeInfo.setTripProdNo(tripProdNo);
			}
			
			int insertCount = businessMapper.insertProdTimeInfo(prodTimeInfoVO);
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
		
		// 숙소 정보는 나중에
//		int accomStatus = 0;
		
//		return null;
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
		
		int status = businessMapper.updateProductStatus(tripProd);
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
		
		int status = businessMapper.deleteProductStatus(tripProd);
		log.info("status : {}", status);
		if(status > 0) {
			return result = ServiceResult.OK;
		} else {
			return result = ServiceResult.FAILED;
		}
	}

}
