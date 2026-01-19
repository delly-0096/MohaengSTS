package kr.or.ddit.mohaeng.business.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.business.mapper.IBusinessProductMapper;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
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
	public TripProdVO detailProduct(int tripProdNo) {
		return businessMapper.detailProduct(tripProdNo);
	}
	
	@Override
	public TripProdVO retrieveProductDetail(TripProdVO tripProd) {
		TripProdVO prodVO = businessMapper.retrieveProductDetail(tripProd); 
		// 나머지 1대다 매칭 후 보내기
		
		return prodVO;
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
