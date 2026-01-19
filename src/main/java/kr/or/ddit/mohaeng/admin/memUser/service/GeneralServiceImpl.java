package kr.or.ddit.mohaeng.admin.memUser.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.admin.memUser.mapper.IGeneralMapper;
import kr.or.ddit.mohaeng.vo.AlarmConfigVO;
import kr.or.ddit.mohaeng.vo.MarketingConsentVO;
import kr.or.ddit.mohaeng.vo.MemberTermsAgreeVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class GeneralServiceImpl implements IGeneralService {


	@Autowired
	private IGeneralMapper generalMapper;

	@Autowired
	private BCryptPasswordEncoder passwordEncoder;

	//전체 인원수 확인해서(Count) 페이지 계산하기 + 지금 필요한 만큼의 명단(List)만 뽑기 => pagInfoVO에 담기
	@Override
	public void getMemList(PaginationInfoVO<MemberVO> pagInfoVO) {
		// 인원파악
		int totalRecord = generalMapper.getMemCount(pagInfoVO);
		// 전체 인원수 기록
		pagInfoVO.setTotalRecord(totalRecord);
		// 명단 추출 : 창고에서 명단 가져와 리스트 작성
		List<MemberVO> dataList = generalMapper.getMemList(pagInfoVO);
		// 리스트 pagInfoVO에 담기=>화면으로 보낼것임
		pagInfoVO.setDataList(dataList);
	}

	@Override
	public MemberVO getMemDetail(int memNo) {
		return generalMapper.getMemDetail(memNo);
	}

	@Transactional
	@Override
	public int registerMember(MemberVO member) {
		// 비밀번호 암호화
		member.setMemPassword(passwordEncoder.encode(member.getMemPassword()));

		//기본값 설정
		member.setJoinCompleteYn("Y"); //"가입 절차 끝났나?" → Yes
		member.setTempPwYn("N"); //"이거 임시 비밀번호인가?" → No, 본인이 직접 정한 거임.
		member.setMemSnsYn("N"); //"구글/카톡 로그인 회원인가?" → No
		member.setEnabled(1); //"이 사람 활동 가능한가?" → 계정사용여부 1(활성), 0(비활성)
		member.setDelYn("N"); //"이 사람 탈퇴했나?" → No

		// MEM_STATUS 대문자 변환(보험용)
		if (member.getMemStatus() != null) {
			member.setMemStatus(member.getMemStatus().toUpperCase());
		}

		// 1. MEMBER 테이블 insert
		int result = generalMapper.insertMember(member);

		// 2. MEM_USER 테이블 insert
		member.getMemUser().setMemNo(member.getMemNo()); //번호표 복사
		generalMapper.insertMember(member.getMemUser()); //db상세 정보 장부에 저장

		// 3. MEMBER_AUTH 테이블 insert (ROLE_MEMBER)
		generalMapper.insertMemberAuth(member.getMemNo());

		 // 4. ALARM_CONFIG 테이블 insert
        AlarmConfigVO alarmConfig = new AlarmConfigVO();
        alarmConfig.setMemNo(member.getMemNo());
        alarmConfig.setRsvtAlarmYn(member.getAlarmConfig().getRsvtAlarmYn());
        alarmConfig.setSchdAlarmYn(member.getAlarmConfig().getSchdAlarmYn());
        alarmConfig.setCommAlarmYn(member.getAlarmConfig().getCommAlarmYn());
        alarmConfig.setPntAlarmYn(member.getAlarmConfig().getPntAlarmYn());
        alarmConfig.setQnaAlarmYn(member.getAlarmConfig().getQnaAlarmYn());
        generalMapper.insertAlarmConfig(alarmConfig);

        // 5. MEMBER_TERMS_AGREE 테이블 insert
		/*
		 * MemberTermsAgreeVO termsAgree = new MemberTermsAgreeVO();
		 * termsAgree.setMemNo(member.getMemNo());
		 * termsAgree.setUseTermYn(member.getmember.getUseTermYn());
		 * termsAgree.setPrivacyPolicyYn(member.getMemUser().getPrivacyPolicyYn());
		 * termsAgree.setLocationTermYn(member.getMemUser().getLocationTermYn());
		 * termsAgree.setMarketingYn(member.getMemUser().getMarketingYn());
		 * generalMapper.insertTermsAgree(termsAgree);
		 */
        // 6. MARKETING_CONSENT 테이블 insert
        MarketingConsentVO marketingConsent = new MarketingConsentVO();
        marketingConsent.setMemNo(member.getMemNo());
        marketingConsent.setEmailConsentYn(member.getMarketingConsent().getEmailConsentYn());
        marketingConsent.setSmsConsentYn(member.getMarketingConsent().getSmsConsentYn());
        marketingConsent.setPushConsentYn(member.getMarketingConsent().getPushConsentYn());
        generalMapper.insertMarketingConsent(marketingConsent);

        return result;
	}

	@Override
	public int updateMember(MemberVO member) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int changePassword(int memNo, String newPassword) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean checkDuplicateId(String memId) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean checkDuplicateEmail(String memEmail) {
		// TODO Auto-generated method stub
		return false;
	}

}
