package kr.or.ddit.mohaeng.business.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.tour.vo.TripProdVO;

@Mapper
public interface IBusinessProductMapper {

	/**
	 * <p>본인 판매 상품 목록 조회</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProd
	 * @return 본인 상품
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
	 * <p>본인 판매 상품 목록 상세</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProd
	 * @return 본인 상품
	 */
	public TripProdVO detailProduct(int tripProdNo);
	
	/**
	 * <p>본인 판매 상품 목록 상세</p>
	 * @author sdg
	 * @date 2026-01-18
	 * @param tripProd
	 * @return 본인 상품
	 */
	public TripProdVO retrieveProductDetail(TripProdVO tripProd);

	
	/**
	 * <p>상품 판매 상태 변경</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProd
	 * @return 결과 0, 1
	 */
	public int updateProductStatus(TripProdVO tripProd);

	/**
	 * <p>판매 상품 삭제</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProd
	 * @return 결과 0, 1
	 */
	public int deleteProductStatus(TripProdVO tripProd);

	
}
