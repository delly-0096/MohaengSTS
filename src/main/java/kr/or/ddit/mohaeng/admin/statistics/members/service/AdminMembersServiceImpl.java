package kr.or.ddit.mohaeng.admin.statistics.members.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.admin.statistics.members.mapper.IAdminMembersMapper;
import kr.or.ddit.util.Params;

@Service
public class AdminMembersServiceImpl implements IAdminMembersService {

	@Autowired
	IAdminMembersMapper adminMembersMapper;
	
	@Override
	public Params summary(Params params) {
		return adminMembersMapper.summary(params);
	}
	
	@Override
	public List<Params> growth(Params params) {
		return adminMembersMapper.growth(params);
	}

	@Override
	public Params hwyhbp(Params params) {
		return adminMembersMapper.hwyhbp(params);
	}
	
	@Override
	public Params ibdgij(Params params) {
		return adminMembersMapper.ibdgij(params);
	}
	
	@Override
	public List<Params> jybbp(Params params) {
		return adminMembersMapper.jybbp(params);
	}
	
	@Override
	public List<Params> yrdbbp(Params params) {
		return adminMembersMapper.yrdbbp(params);
	}
	
	@Override
	public List<Params> cggihw(Params params) {
		return adminMembersMapper.cggihw(params);
	}
}
