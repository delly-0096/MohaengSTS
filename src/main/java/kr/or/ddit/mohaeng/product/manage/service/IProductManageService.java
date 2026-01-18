package kr.or.ddit.mohaeng.product.manage.service;

import java.util.List;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;

public interface IProductManageService {
	
	/**
	 * <p>본인 상품 목록 조회</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProd 고객키
	 * @return 상품목록
	 */
	public List<TripProdVO> getProductlist(TripProdVO tripProd);

	/**
	 * <p>기업 상품 현황 통계</p>
	 * @author sdg
	 * @date 2026-01-18
	 * @param tripProd 회원id
	 * @return 총 상품 갯수, 판매중인 상품 갯수, 판매중지중인 상품 갯수, 전체 판매 건수
	 */
	public TripProdVO getProductAggregate(TripProdVO tripProd);
	
	/**
	 * <p>본인 상품 상세 조회</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProdNo
	 * @return 해당 id의 상품
	 */
	public TripProdVO detailProduct(int tripProdNo);
	
	/**
	 * <p>본인 상품 상세 조회</p>
	 * @author sdg
	 * @date 2026-01-18
	 * @param tripProd 상품 id
	 * @return 해당 상품의 정보
	 */
	public TripProdVO retrieveProductDetail(TripProdVO tripProd);
	
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
