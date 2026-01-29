package kr.or.ddit.mohaeng.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.admin.login.mapper.IAdminMapper;
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

		// 일반/기업/관리자 통합 조회
        MemberVO member = memberMapper.selectById(username);

        // 계정 존재 여부 확인
        if (member == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
        }

        // 회원 상태(MEM_STATUS)에 따른 로그인 차단 로직
        // [WAIT] 기업 회원 승인 대기 상태
        if ("WAIT".equals(member.getMemStatus())) {
            throw new DisabledException("승인 대기 중인 계정입니다. 관리자 승인이 완료된 후 로그인이 가능합니다.");
        }

        // [PAUSED] 활동 정지 상태
        if ("PAUSED".equals(member.getMemStatus())) {
            throw new LockedException("운영 정책에 의해 활동이 정지된 계정입니다.");
        }

        // [WITHDRAWN / DELETE] 탈퇴 또는 삭제된 계정 (로그인 불가)
        if ("WITHDRAWN".equals(member.getMemStatus()) || "DELETE".equals(member.getMemStatus())) {
            throw new UsernameNotFoundException("탈퇴하거나 존재하지 않는 계정입니다.");
        }

        // 4. 정상(ACTIVE) 상태인 경우 시큐리티 인증 객체 반환
        // 반환 시 CustomUserDetails 또는 CustomUser 중 실제 작성하신 클래스명에 맞추시면 됩니다.
        return new CustomUserDetails(member);

	}

}
