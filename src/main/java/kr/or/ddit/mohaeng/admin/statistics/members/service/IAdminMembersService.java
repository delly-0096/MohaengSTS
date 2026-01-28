package kr.or.ddit.mohaeng.admin.statistics.members.service;

import java.util.List;

import kr.or.ddit.util.Params;

public interface IAdminMembersService {

	public Params summary(Params params);

	public List<Params> growth(Params params);

}
