package kr.or.ddit.mohaeng.product.manage.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdPlaceVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccOptionVO;
import kr.or.ddit.mohaeng.vo.AccResvVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.BusinessProductsVO;
import kr.or.ddit.mohaeng.vo.RoomFacilityVO;
import kr.or.ddit.mohaeng.vo.RoomFeatureVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;
import kr.or.ddit.mohaeng.vo.RoomVO;
import kr.or.ddit.mohaeng.vo.TripProdListVO;

@Mapper
public interface IProductMangeMapper {

	/**
	 * <p>본인 판매 상품 목록 조회</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param product 회원id
	 * @return 본인 상품
	 */
	public List<BusinessProductsVO> getProductlist(BusinessProductsVO businessProducts);
	
	/**
	 * <p>등록된 숙소 정보 조회</p>
	 * @author sdg
	 * @date 2026-01-24
	 * @param accommodationVO api 키
	 * @return 본인 상품
	 */
	public AccommodationVO existsByApiContentId(AccommodationVO accommodationVO);
	
	/**
	 * <p>기업 상품 현황 통계</p>
	 * @author sdg
	 * @date 2026-01-18
	 * @param product 회원id
	 * @return 총 상품 갯수, 판매중인 상품 갯수, 판매중지중인 상품 갯수, 전체 판매 건수
	 */
	public TripProdVO getProductAggregate(TripProdVO product);
	
	/**
	 * <p>본인 판매 상품 목록 상세</p>
	 * @author sdg
	 * @date 2026-01-18
	 * @param businessProducts 상품 일련번호
	 * @return 상품 정보, 상품 이용안내, 상품 가격, 상품 관광지
	 */
	public BusinessProductsVO retrieveProductDetail(BusinessProductsVO businessProducts);
	
	/**
	 * <p>숙박 상품 상세 정보 가져오기</p>
	 * @author sdg
	 * @date 2026-01-21
	 * @param tripProd
	 * @return 결과 0, 1
	 */
	public AccommodationVO retrieveAccomodationDetail(AccommodationVO accommodationvo);
	
	/**
	 * <p>본인 판매 상품 목록 상세</p>
	 * @author sdg
	 * @date 2026-01-19
	 * @param businessProducts 상품 일련번호
	 * @return 상품 예약 가능 시간
	 */
	public List<ProdTimeInfoVO> retrieveProdTimeList(BusinessProductsVO businessProducts);
	
	/**
	 * <p>본인 판매 상품 사진 목록</p>
	 * @author sdg
	 * @date 2026-01-19
	 * @param tripProd 대표이미지 
	 * @return 상품 사진 목록
	 */
	public List<AttachFileDetailVO> retrieveProdImages(BusinessProductsVO businessProducts);

	/**
	 * <p>판매중인 상품 정보 변경</p>
	 * @author sdg
	 * @date 2026-01-20
	 * @param businessProducts
	 * @return 결과 0, 1
	 */
	public int modifyTripProduct(BusinessProductsVO businessProducts);

	/**
	 * <p>판매중인 상품 가격 정보 변경</p>
	 * @author sdg
	 * @date 2026-01-20
	 * @param prodSaleVO
	 * @return 결과 0, 1
	 */
	public int modifyProdSale(TripProdSaleVO prodSaleVO);
	
	/**
	 * <p> 상품 이용안내 정보 변경</p>
	 * @author sdg
	 * @date 2026-01-20
	 * @param prodInfoVO
	 * @return 결과 0, 1
	 */
	public int modifyProdInfo(TripProdInfoVO prodInfoVO);
	
	/**
	 * <p>상품 장소 정보 변경</p>
	 * @author sdg
	 * @date 2026-01-20
	 * @param prodPlaceVO
	 * @return 결과 0, 1
	 */
	public int modifyProdPlace(TripProdPlaceVO prodPlaceVO);

	// 숙소 - 1대다 = delete -> insert 로 수정
	/**
	 * <p>숙소 정보 변경</p>
	 * @author sdg
	 * @date 2026-01-20
	 * @param accommodationVO 총객실 수, 체크인, 체크아웃
	 * @return 결과 0, 1
	 */
	public int modifyAccommodation(AccommodationVO accommodationVO);
	
	/**
	 * 숙소와 1대 다
	 * <p>추가 옵션 정보 변경</p>
	 * @author sdg
	 * @date 2026-01-20
	 * @param accommodationVO
	 * @return 결과 0, 1
	 */
	public int modifyAccOption(AccOptionVO accOptionVO);
	
	/**
	 * 숙소와 1대 다
	 * <p>추가 옵션 정보 변경 / 추가</p>
	 * @author sdg
	 * @date 2026-01-20
	 * @param accommodationVO
	 * @return 결과 0, 1
	 */
	public int insertAccOption(AccOptionVO accOptionVO);

	
	// 만약 예약한 건 수 가 있다면 해당 건은 삭제는 불가
	/** 숙소와 1대다
	 * <p>객실 타입 정보 변경</p>
	 * @author sdg
	 * @date 2026-01-20
	 * @param roomTypeVO
	 * @return 결과 0, 1
	 */
	public int modifyRoomType(List<RoomTypeVO> roomTypeVO);
	
	/** 숙소와 1대1
	 * <p>숙박 보유시설 정보 변경</p>
	 * @author sdg
	 * @date 2026-01-20
	 * @param accFacilityVO
	 * @return 결과 0, 1
	 */
	public int modifyAccFacility(AccFacilityVO accFacilityVO);
	
	
	
	/** 객실타입과 1대1
	 * <p>객실 내 시설 정보 변경</p>
	 * @author sdg
	 * @date 2026-01-20
	 * @param roomFacilityVO
	 * @return 결과 0, 1
	 */
	public int modifyRoomFacility(RoomFacilityVO roomFacilityVO);
	
	/** 객실타입과 1대1
	 * <p>객실 내 특징 정보 변경</p>
	 * @author sdg
	 * @date 2026-01-20
	 * @param roomFeatureVO
	 * @return 결과 0, 1
	 */
	public int modifyRoomFeature(RoomFeatureVO roomFeatureVO);
	
	/** 객실타입과 1대 다
	 * <p>객실 정보 변경</p>
	 * @author sdg
	 * @date 2026-01-20
	 * @param accFacilityVO
	 * @return 결과 0, 1
	 */
	public int modifyRoom(RoomVO roomVO);
	
	
	// 예약 가능 시간
	/**
	 * <p>예약 가능 시간 삭제</p>
	 * @author sdg
	 * @date 2026-01-19
	 * @param tripProd 상품일련번호(tripProdNo)
	 * @return 결과 0, 1
	 */
	public int deleteProdTimeInfo(BusinessProductsVO businessProducts);

	/**
	 * <p>예약 가능 시간 추가</p>
	 * @author sdg
	 * @date 2026-01-19
	 * @param tripProd 상품일련번호(tripProdNo)
	 * @return 결과 0, 1
	 */
	public int insertProdTimeInfo(ProdTimeInfoVO prodTimeInfoVO);

	
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

	/**
	 * <p>기업번호 얻기</p>
	 * @author sdg
	 * @date 2026-01-25
	 * @param memNo 회원 번호
	 * @return 결과 0, 1
	 */
	public int getComp(int memNo);
	
	/**
	 * <p>상품 등록</p>
	 * @author sdg
	 * @date 2026-01-25
	 * @param businessProducts 상품 정보
	 * @return 결과 0, 1
	 */
	public int insertTripProudct(BusinessProductsVO businessProducts);

	/**
	 * <p>숙소 등록</p>
	 * @author sdg
	 * @date 2026-01-25
	 * @param accommodationVO 숙소 정보
	 * @return 결과 0, 1
	 */
	public int insertAccommodation(AccommodationVO accommodationVO);

	/**
	 * <p>숙소 보유 시설 등록</p>
	 * @author sdg
	 * @date 2026-01-25
	 * @param accFacilityVO 숙소 보유시설 정보
	 * @return 결과 0, 1
	 */
	public int insertAccFacility(AccFacilityVO accFacilityVO);

	/**
	 * <p>객실 타입 등록</p>
	 * @author sdg
	 * @date 2026-01-25
	 * @param roomTypeVO 객실 타입 정보
	 * @return 결과 0, 1
	 */
	public int insertRoomType(RoomTypeVO roomTypeVO);
	
	/**
	 * <p>객실 내 시설 등록</p>
	 * @author sdg
	 * @date 2026-01-25
	 * @param facilityVO 객실 내 시설 정보
	 * @return 결과 0, 1
	 */
	public int insertRoomFcaility(RoomFacilityVO facilityVO);
	
	/**
	 * <p>객실 내 특징 등록</p>
	 * @author sdg
	 * @date 2026-01-25
	 * @param featureVO 객실 내 특징 정보
	 * @return 결과 0, 1
	 */
	public int insertRoomFeature(RoomFeatureVO featureVO);
	
	/**
	 * <p>객실 등록</p>
	 * @author sdg
	 * @date 2026-01-25
	 * @param roomVO 객실 정보
	 * @return 결과 0, 1
	 */
	public int insertRoom(RoomVO roomVO);

	
	/**
	 * <p>상품 판매 정보 등록</p>
	 * @author sdg
	 * @date 2026-01-26
	 * @param prodSaleVO 상품 판매 정보
	 * @return 결과 0, 1
	 */
	public int insertTripProdSale(TripProdSaleVO prodSaleVO);

	/**
	 * <p>상품 관광지 정보 등록</p>
	 * @author sdg
	 * @date 2026-01-26
	 * @param placeVO 상품 관광지 정보
	 * @return 결과 0, 1
	 */
	public int insertTripProdPlace(TripProdPlaceVO placeVO);

	/**
	 * <p>상품 이용안내 정보 등록</p>
	 * @author sdg
	 * @date 2026-01-26
	 * @param prodInfoVO 상품 이용안내 정보
	 * @return 결과 0, 1
	 */
	public int insertTripProdInfo(TripProdInfoVO prodInfoVO);

	/**
	 * <p>상품 예약 내역 가져오기</p>
	 * @author sdg
	 * @date 2026-01-26
	 * @param businessProducts (tripProdNo)
	 * @return 예약 내역
	 */
	public List<TripProdListVO> getReservation(BusinessProductsVO businessProducts);

	
	/**
	 * <p>숙소 예약 내역 가져오기</p>
	 * @author sdg
	 * @date 2026-01-26
	 * @param accommodationvo (accNo)
	 * @return 결과 0, 1
	 */
	public List<AccResvVO> getAccResvList(AccommodationVO accommodationvo);
	
}
