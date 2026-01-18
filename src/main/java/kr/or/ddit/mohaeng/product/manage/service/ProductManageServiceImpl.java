package kr.or.ddit.mohaeng.product.manage.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.product.manage.mapper.IProductManageMapper;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
public class ProductManageServiceImpl implements IProductManageService {

	@Autowired
	private IProductManageMapper manageMapper;
	
	@Override
	public List<TripProdVO> getProductlist(TripProdVO tripProd) {
		return manageMapper.getProductlist(tripProd);
	}
	
	@Override
	public TripProdVO getProductAggregate(TripProdVO tripProd) {
		return manageMapper.getProductAggregate(tripProd);
	}
	
	@Override
	public TripProdVO detailProduct(int tripProdNo) {
		return manageMapper.detailProduct(tripProdNo);
	}
	
	@Override
	public TripProdVO retrieveProductDetail(TripProdVO tripProd) {
		return manageMapper.retrieveProductDetail(tripProd);
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
