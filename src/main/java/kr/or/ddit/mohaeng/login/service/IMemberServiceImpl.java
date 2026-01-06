package kr.or.ddit.mohaeng.login.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.login.mapper.IMemCompMapper;
import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.mypage.profile.dto.MemberUpdateDTO;
import kr.or.ddit.mohaeng.vo.CompanyVO;
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

	@Override
	public boolean checkPassword(String memId, String memPassword) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public ServiceResult register(MemberVO memberVO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ServiceResult idCheck(String memId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ServiceResult registerCompany(MemberVO memberVO, CompanyVO companyVO, MultipartFile bizFile) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public MemberVO findById(String memId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateMemberProfile(MemberUpdateDTO updateDTO) {
		// TODO Auto-generated method stub
		
	}

}
