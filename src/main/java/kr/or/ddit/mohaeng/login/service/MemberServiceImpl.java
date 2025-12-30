package kr.or.ddit.mohaeng.login.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.login.mapper.IMemCompMapper;
import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.vo.MemberVO;

@Service
public class MemberServiceImpl implements IMemberService {



	@Autowired
    private IMemberMapper memberMapper;
	
	@Autowired
    private IMemCompMapper memCompMapper;
	
	@Autowired
	private PasswordEncoder passwordEncoder;

    MemberServiceImpl(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }
	
	/**
	 *	<p> 로그인 </p>
	 *	@date 2025.12.28
	 *	@author kdrs
	 *	@param memId 회원 로그인 아이디 정보
	 *	@return 회원 아이디가 존재하면 회원 타입 판별
	 */
	@Override
	public String getMemberType(String memId) {
		MemberVO member = memberMapper.selectByMemId(memId);
		
	    if (member == null) {
	        return null; // 로그인 실패
	    }
		
		int memNo = member.getMemNo();
		int compCount = memCompMapper.countByMemNo(memNo);
		
		if (compCount > 0) {
			int approved = memCompMapper.selectAprvYnByMemNo(memNo); // 승인된 기업회원인지 아닌지 유무 판별
		        if (approved == 0) {
		            return "BUSINESS_NOT_APPROVED";
		        }
        	return "BUSINESS";
        }
		
		return "PERSONAL";
	}

	/**
	 *	<p> 비밀번호 체크 </p>
	 *	@date 2025.12.29
	 *	@author kdrs
	 *	@param memId 회원 아이디 정보, memPassword 회원 비밀번호 정보
	 *	@return 회원이 직접 입력한 비밀번호와 암호화된 비밀번호 체크
	 */
	@Override
	public boolean checkPassword(String memId, String memPassword) {
		
		MemberVO member = memberMapper.selectByMemId(memId);
	    if (member == null) return false;

	    String encodedPassword = member.getMemPassword(); // DB 암호문

	    return passwordEncoder.matches(memPassword, encodedPassword);
	}


}
