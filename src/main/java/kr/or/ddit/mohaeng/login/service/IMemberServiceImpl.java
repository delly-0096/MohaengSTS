package kr.or.ddit.mohaeng.login.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.login.mapper.IMemCompMapper;
import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.vo.MemberVO;

@Service
public class IMemberServiceImpl implements IMemberService {


	@Autowired
    private IMemberMapper memberMapper;

	@Autowired
    private IMemCompMapper memCompMapper;

    /**
     * 로그인 후 회원 타입 판별
     */
	@Override
	public String getMemberType(String memId) {

		MemberVO member = memberMapper.selectByMemId(memId);

		if(member == null) {
			throw new RuntimeException("존재하지 않는 회원입니다!");
		}

		int memNo = member.getMemNo();

		int compCount = memCompMapper.countByMemNo(memNo);

        if (compCount > 0) {
            return "BUSINESS";
        } else {
            return "PERSONAL";
        }
	}

}
