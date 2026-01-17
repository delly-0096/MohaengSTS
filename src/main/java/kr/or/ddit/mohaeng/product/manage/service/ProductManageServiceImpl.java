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
	public List<TripProdVO> getProductlist(TripProdVO prodVO) {
		return manageMapper.getProductlist(prodVO);
	}
	
	@Override
	public TripProdVO detailProduct(int tripProdNo) {
		return manageMapper.detailProduct(tripProdNo);
	}
	
	@Override
	public ServiceResult updateProductStatus(TripProdVO prodVO) {
		ServiceResult result = null;
		log.info("updateProductStatus 실행 : {}", prodVO);
		if (prodVO.getApproveStatus().equals("판매중")) {
			prodVO.setApproveStatus("판매중지");
		} else {
			prodVO.setApproveStatus("판매중");
		}
		
		int status = manageMapper.updateProductStatus(prodVO);
		log.info("status : {}", status);
		if(status > 0) {
			return result = ServiceResult.OK;
		} else {
			return result = ServiceResult.FAILED;
		}
	}

	@Override
	public ServiceResult deleteProductStatus(TripProdVO prodVO) {
		ServiceResult result = null;
		log.info("updateProductStatus 실행 : {}", prodVO);
		
		int status = manageMapper.deleteProductStatus(prodVO);
		log.info("status : {}", status);
		if(status > 0) {
			return result = ServiceResult.OK;
		} else {
			return result = ServiceResult.FAILED;
		}
	}





	
	
}
