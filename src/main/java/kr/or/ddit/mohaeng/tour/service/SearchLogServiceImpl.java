package kr.or.ddit.mohaeng.tour.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.tour.mapper.ISearchLogMapper;
import kr.or.ddit.mohaeng.tour.vo.SearchLogVO;

@Service
public class SearchLogServiceImpl implements ISearchLogService {

	@Autowired
    private ISearchLogMapper mapper;
	
	@Override
	public List<SearchLogVO> getKeywords() {
		return mapper.getKeywords(7, 8);
	}

	@Override
	public void insertSearchLog(SearchLogVO vo) {
		mapper.insertSearchLog(vo);
	}

}
