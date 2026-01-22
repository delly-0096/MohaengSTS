package kr.or.ddit.mohaeng.tour.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.tour.vo.TripProdPlaceVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.CompanyVO;

@Mapper
public interface ITripProdMapper {
	public List<TripProdVO> list(TripProdVO tp);
	public int getTotalCount(TripProdVO tp);
	public void increase(int tripProdNo);
	public TripProdVO detail(int tripProdNo);
	public CompanyVO getSellerStats(int compNo);
	public TripProdPlaceVO getPlace(int tripProdNo);
	public int updateExpiredStatus();
	public void updateAttachNo(@Param("tripProdNo") int tripProdNo, @Param("attachNo") int attachNo);
	public int checkBookmark(@Param("memNo") int memNo, @Param("tripProdNo") int tripProdNo);
	public int insertBookmark(@Param("memNo") int memNo, @Param("type") String type, @Param("tripProdNo") int tripProdNo);
	public int deleteBookmark(@Param("memNo") int memNo, @Param("tripProdNo") int tripProdNo);
	public int restoreBookmark(@Param("memNo") int memNo, @Param("tripProdNo") int tripProdNo);
}
