package kr.or.ddit.mohaeng.login.mapper;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IMemCompMapper {

	/**
	 * 기업회원 존재 여부 확인
	 * @param memNo 회원 번호 (MEMBER.MEM_NO)
	 * @return 존재하면 1
	 */
	public int countByMemNo(Integer memNo);

	/**
	 * 기업회원 승인 여부 확인
	 * @param memNo 회원 번호 (MEMBER.MEM_NO)
	 * @return 승인된 회원이면 1 아닐시 0
	 */
	public int selectAprvYnByMemNo(int memNo);

}
