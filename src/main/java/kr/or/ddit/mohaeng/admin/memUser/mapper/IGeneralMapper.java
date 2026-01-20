package kr.or.ddit.mohaeng.admin.memUser.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.AlarmConfigVO;
import kr.or.ddit.mohaeng.vo.CodeVO;
import kr.or.ddit.mohaeng.vo.MarketingConsentVO;
import kr.or.ddit.mohaeng.vo.MemUserVO;
import kr.or.ddit.mohaeng.vo.MemberTermsAgreeVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;


@Mapper
public interface IGeneralMapper {

	 // 회원 수 조회
	int getMemCount(PaginationInfoVO<MemberVO> pagInfoVO);

	// 회원 목록 조회
	List<MemberVO> getMemList(PaginationInfoVO<MemberVO> pagInfoVO);

	// 회원 상세 조회
	MemberVO getMemDetail(int memNo);

	 // 회원 등록
	int insertMember(MemberVO member);
	void insertMemUser(MemUserVO memUser);
	void insertMemberAuth(int memNo);
	void insertAlarmConfig(AlarmConfigVO alarmConfig);
	void insertMarketingConsent(MarketingConsentVO marketingConsent);
	void insertTermsAgree(MemberTermsAgreeVO termsAgree);

	// 회원 수정
	int updateMember(MemberVO member);
	void updateMemUser(MemUserVO memUser);
	void updateAlarmConfig(AlarmConfigVO alarmConfig);
	void updateTermsAgree(MemberTermsAgreeVO termsAgree);
	void updateMarketingConsent(MarketingConsentVO marketingConsent);

	// 비밀번호 변경
	int changePassword(@Param("param1") int memNo, @Param("param2") String encodedPassword);

	// 중복 체크
	int checkDuplicateId(String memId);
	int checkDuplicateEmail(String memEmail);

	//[코드 관련 추가] 코드 조회
	List<CodeVO> getCodeListByGroup(String cdgr);

	// 엑셀 다운로드용 전체 목록 조회
	List<MemberVO> getAllMemList(PaginationInfoVO<MemberVO> pagInfoVO);
}
