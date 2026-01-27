package kr.or.ddit.mohaeng.admin.tour.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Mapper
public interface IAdminTourMapper {
	public int getTourCount(PaginationInfoVO<TripProdVO> pagInfoVO);
	public List<TripProdVO> getTourList(PaginationInfoVO<TripProdVO> pagInfoVO);
	public TripProdVO selectTourBase(int tripProdNo);
	public List<ProdTimeInfoVO> selectTimeInfoList(int tripProdNo);
	public List<AttachFileDetailVO> selectTourImages(int attachNo);
	public int updateApproveStatus(int tripProdNo);
	public int toggleSaleStatus(Map<String, Object> params);
	public int logicalDeleteTripProd(int tripProdNo);
	public Map<String, Object> getTourStats();
}
