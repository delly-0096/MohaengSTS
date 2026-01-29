package kr.or.ddit.mohaeng.admin.statistics.members.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.util.Params;

@Mapper
public interface IAdminMembersMapper {
	
	public Params summary(Params params);

	public List<Params> growth(Params params);

	public Params hwyhbp(Params params);

	public Params ibdgij(Params params);

	public List<Params> jybbp(Params params);

	public List<Params> yrdbbp(Params params);

	public List<Params> cggihw(Params params);
	
}
