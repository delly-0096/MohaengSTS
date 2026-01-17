package kr.or.ddit.mohaeng.product.manage.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.tour.vo.TripProdVO;

@Mapper
public interface IProductManageMapper {

	/**
	 * <p>본인 판매 상품 목록 조회</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param prodVO
	 * @return 본인 상품
	 */
	public List<TripProdVO> getProductlist(TripProdVO prodVO);
	
	/**
	 * <p>본인 판매 상품 목록 상세</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param prodVO
	 * @return 본인 상품
	 */
	public TripProdVO detailProduct(int tripProdNo);
	
	/**
	 * <p>상품 판매 상태 변경</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param prodVO
	 * @return 결과 0, 1
	 */
	public int updateProductStatus(TripProdVO prodVO);

	/**
	 * <p>판매 상품 삭제</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param prodVO
	 * @return 결과 0, 1
	 */
	public int deleteProductStatus(TripProdVO prodVO);



	
}
