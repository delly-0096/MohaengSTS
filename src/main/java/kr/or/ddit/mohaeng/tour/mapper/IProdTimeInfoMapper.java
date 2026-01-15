package kr.or.ddit.mohaeng.tour.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;

@Mapper
public interface IProdTimeInfoMapper {
	public List<ProdTimeInfoVO> getAvailableTimes(int tripProdNo);
}
