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
}
