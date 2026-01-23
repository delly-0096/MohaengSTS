package kr.or.ddit.mohaeng.tour.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.tour.mapper.ITripProdMapper;
import kr.or.ddit.mohaeng.tour.vo.TripProdPlaceVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.CompanyVO;

@Service
public class TripProdServiceImpl implements ITripProdService {
	
	@Autowired
	private ITripProdMapper mapper;

	@Override
	public List<TripProdVO> list(TripProdVO tp) {
		return mapper.list(tp);
	}

	@Override
	public int getTotalCount(TripProdVO tp) {
		return mapper.getTotalCount(tp);
	}

	@Override
	public TripProdVO detail(int tripProdNo) {
		mapper.increase(tripProdNo);
		return mapper.detail(tripProdNo);
	}

	@Override
	public CompanyVO getSellerStats(int compNo) {
		return mapper.getSellerStats(compNo);
	}

	@Override
	public TripProdPlaceVO getPlace(int tripProdNo) {
		return mapper.getPlace(tripProdNo);
	}

	@Override
	public int updateExpiredStatus() {
		return mapper.updateExpiredStatus();
	}

	@Override
	public void updateAttachNo(int tripProdNo, int attachNo) {
		mapper.updateAttachNo(tripProdNo, attachNo);
	}

	@Override
	public boolean checkBookmark(int memNo, int tripProdNo) {
		return mapper.checkBookmark(memNo, tripProdNo) > 0;
	}

	@Override
	public int insertBookmark(int memNo, String type, int tripProdNo) {
	    int restored = mapper.restoreBookmark(memNo, tripProdNo);
	    
	    if (restored == 0) {
	        return mapper.insertBookmark(memNo, type, tripProdNo);
	    }
	    
	    return restored;
	}

	@Override
	public int deleteBookmark(int memNo, int tripProdNo) {
		return mapper.deleteBookmark(memNo, tripProdNo);
	}
	
	/**
	 * 숙박 북마크
	 */

	@Override
	public boolean checkAccommodationBookmark(int memNo, int tripProdNo) {
		return mapper.checkBookmark(memNo, tripProdNo) > 0;
	}

	@Override
	public int insertAccommodationBookmark(int memNo, String type, int tripProdNo) {
	    int restored = mapper.restoreAccommodationBookmark(memNo, tripProdNo);
	    
	    if (restored == 0) {
	        return mapper.insertAccommodationBookmark(memNo, type, tripProdNo);
	    }
	    
	    return restored;
	}

	@Override
	public int deleteAccommodationBookmark(int memNo, int tripProdNo) {
		return mapper.deleteAccommodationBookmark(memNo, tripProdNo);
	}
}
