package kr.or.ddit.mohaeng.login.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.MemberVO;

@Mapper
public interface IMemberMapper {

	public MemberVO selectByMemId(String memId);

	public MemberVO selectById(@Param("username") String username);

}
