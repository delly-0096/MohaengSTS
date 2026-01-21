package kr.or.ddit.mohaeng.business.service;

import java.util.List;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.BusinessProductsVO;

public interface IBusinessProductService {
	
	/**
	 * <p>본인 상품 목록 조회</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProd (memNo)
	 * @return 상품목록
	 */
	public List<BusinessProductsVO> getProductlist(BusinessProductsVO businessProducts);
	/**
	 * <p>기업 상품 현황 통계</p>
	 * @author sdg
	 * @date 2026-01-18
	 * @param tripProd (memNo)
	 * @return 총 상품 갯수, 판매중인 상품 갯수, 판매중지중인 상품 갯수, 전체 판매 건수
	 */
	public TripProdVO getProductAggregate(TripProdVO tripProd);

	
	/**
	 * <p>숙박상품 조회</p>
	 * @author sdg
	 * @date 2026-01-19
	 * @param businessProducts (memNo)
	 * @return 숙박상품목록
	 */
	public List<AccommodationVO> getAccommodationList(BusinessProductsVO businessProducts);

	
	/**
	 * <p>본인 상품 상세 조회</p>
	 * @author sdg
	 * @date 2026-01-18
	 * @param businessProducts 상품 정보
	 * @return 해당 상품의 정보
	 */
	public BusinessProductsVO getProductDetail(BusinessProductsVO businessProducts);
	
	/**
	 * <p>판매 상품 정보 수정</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProd 상품 정보
	 * @return ok, badRequest
	 */
	public ServiceResult modifyProduct(BusinessProductsVO businessProducts);
	
	/**
	 * <p>상품 판매 상태 변경</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProd 상품 id, 판매여부
	 * @return ok, badRequest
	 */
	public ServiceResult updateProductStatus(TripProdVO tripProd);

	/**
	 * <p>판매 상품 삭제</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProd 상품id
	 * @return ok, badRequest
	 */
	public ServiceResult deleteProductStatus(TripProdVO tripProd);

}
