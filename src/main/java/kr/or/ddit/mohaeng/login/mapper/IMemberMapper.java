package kr.or.ddit.mohaeng.login.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.MemberVO;

@Mapper
public interface IMemberMapper {

	public MemberVO selectByMemId(String memId);

}
