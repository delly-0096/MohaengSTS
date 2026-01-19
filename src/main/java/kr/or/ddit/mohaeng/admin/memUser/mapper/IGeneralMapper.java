package kr.or.ddit.mohaeng.admin.memUser.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.AlarmConfigVO;
import kr.or.ddit.mohaeng.vo.MarketingConsentVO;
import kr.or.ddit.mohaeng.vo.MemUserVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;


@Mapper
public interface IGeneralMapper {

	int getMemCount(PaginationInfoVO<MemberVO> pagInfoVO);

	List<MemberVO> getMemList(PaginationInfoVO<MemberVO> pagInfoVO);

	MemberVO getMemDetail(int memNo);

	int insertMember(MemUserVO memUserVO);

	void insertMemberAuth(int memNo);

	int insertMember(MemberVO member);

	void insertAlarmConfig(AlarmConfigVO alarmConfig);

	void insertMarketingConsent(MarketingConsentVO marketingConsent);

}
