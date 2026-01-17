package kr.or.ddit.mohaeng.product.manage.service;

import java.util.List;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;

public interface IProductManageService {
	
	/**
	 * <p>본인 상품 목록 조회</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param prodVO
	 * @return
	 */
	public List<TripProdVO> getProductlist(TripProdVO prodVO);

	/**
	 * <p>본인 상품 상세 조회</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProdNo
	 * @return
	 */
	public TripProdVO detailProduct(int tripProdNo);
	
	/**
	 * <p>상품 판매 상태 변경</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param prodVO
	 * @return
	 */
	public ServiceResult updateProductStatus(TripProdVO prodVO);

	/**
	 * <p>판매 상품 삭제</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param prodVO
	 * @return
	 */
	public ServiceResult deleteProductStatus(TripProdVO prodVO);



}
