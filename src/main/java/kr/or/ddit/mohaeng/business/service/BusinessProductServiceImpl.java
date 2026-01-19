package kr.or.ddit.mohaeng.business.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.business.mapper.IBusinessProductMapper;
import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.BusinessProductsVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BusinessProductServiceImpl implements IBusinessProductService {

	@Autowired
	private IBusinessProductMapper businessMapper;
	
	@Override
	public List<TripProdVO> getProductlist(TripProdVO tripProd) {
		return businessMapper.getProductlist(tripProd);
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
		
		// 변수 바뀔수도, 1대1관계들 update -> 상품, 상품 이용안내, 상품 가격, 상품 장소
		int productstatus = 0;	// 1 , 0
		productstatus = businessMapper.modifyProduct(businessProducts);
		log.info("productstatus : {}", productstatus);
		
		
		// 예약가능시간(예약 가능 시간)
		int productTimetatus = 0;	
		productTimetatus = businessMapper.deleteProdTimeInfo(businessProducts);
		log.info("deleteProdInfo : {}", productTimetatus);
		
		// bookingTimes를 다 세팅해야됨 잊지말자
		List<ProdTimeInfoVO> prodTimeInfoVO = businessProducts.getProdTimeList();
		
		log.info("prodTimeInfoVO.길이 : {}", prodTimeInfoVO.size());
		if (productTimetatus != 0) {
			productTimetatus = 0;
			productstatus = businessMapper.insertProdTimeInfo(prodTimeInfoVO);
			log.info("insertProdTimeInfo : {}", productstatus);
		}
		
		if(productstatus == 1 && productTimetatus == prodTimeInfoVO.size()) {
			return result = ServiceResult.OK;
		}else {
			return result = ServiceResult.FAILED;
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
