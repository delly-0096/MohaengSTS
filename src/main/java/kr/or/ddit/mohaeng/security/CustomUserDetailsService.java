package kr.or.ddit.mohaeng.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.adminLogin.mapper.IAdminMapper;
import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.vo.CustomUser;
import kr.or.ddit.mohaeng.vo.MemberVO;

@Service
public class CustomUserDetailsService implements UserDetailsService {
	// 로그인
	// 매칭할 mapper 필요
	
	@Autowired
    private IMemberMapper memberMapper;   // 예시
	
    @Autowired
    private IAdminMapper adminMapper;     // 예시
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		System.out.println("username : " + username);
		  // 1. 일반/기업/관리자 통합 조회
        MemberVO member = memberMapper.selectById(username);
        System.out.println("member : " + member);
        
        if (member == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
        }

        // 2. CustomUser로 감싸서 반환
        return new CustomUser(member);
		
	}

}
