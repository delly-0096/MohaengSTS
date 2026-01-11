package kr.or.ddit.mohaeng.admin.login.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.AdminLoginVO;

@Mapper
public interface IAdminMapper {

	public AdminLoginVO selectByLoginId(String loginId);

}
