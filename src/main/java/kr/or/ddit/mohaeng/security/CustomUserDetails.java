package kr.or.ddit.mohaeng.security;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;

import kr.or.ddit.mohaeng.vo.MemberVO;

public class CustomUserDetails implements UserDetails, OAuth2User {
	
	private MemberVO member;
	private Map<String, Object> attributes;
	private Collection<? extends GrantedAuthority> authorities;
	 
    public CustomUserDetails(MemberVO member) {
        this.member = member;
    }
    
    public CustomUserDetails(
            MemberVO member,
            Collection<? extends GrantedAuthority> authorities,
            Map<String, Object> attributes
    ) {
        this.member = member;
        this.authorities = authorities;
        this.attributes = attributes;
    }
    
    
    // 권한
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		System.out.println("### getAuthorities CALLED ###");
	    
	    // OAuth 로그인에서 직접 주입된 권한이 있으면 그거 사용
	    if (authorities != null && !authorities.isEmpty()) {
	        return authorities;
	    }
	    
	    // 일반 로그인 (DB 기반)
	    return member.getAuthList().stream()
	            .map(a -> a.getAuth())
	            .filter(a -> a != null && !a.isBlank())
	            .map(a -> a.startsWith("ROLE_") ? a : "ROLE_" + a)
	            .map(SimpleGrantedAuthority::new)
	            .toList();
	}
	
	// Security가 쓰는 ID
	@Override
	public String getUsername() {
		return member.getMemId();
	}
	
	@Override
	public String getPassword() {
		return member.getMemPassword();
	}
	
	// 계정 만료 여부 (탈퇴/삭제 시 false 처리 가능)
	@Override public boolean isAccountNonExpired() {
		return !"WITHDRAWN".equals(member.getMemStatus()) && !"DELETE".equals(member.getMemStatus());
	}
	// 계정 잠금 여부 (정지 상태일 때 false)
	@Override public boolean isAccountNonLocked() { 
    	// 상태가 'PAUSED'(정지)가 아니면 true (잠기지 않음)
    	return !"PAUSED".equals(member.getMemStatus()); 
    }
    @Override public boolean isCredentialsNonExpired() { return true; }
    
    @Override
    public boolean isEnabled() {
        return member.getEnabled() == 1;
    }

    public String getMemName() {
        return member.getMemName();
    }

    public MemberVO getMember() {
        return member;
    }
	
    // ===== 프로필 이미지 경로 =====
    public String getMemProfilePath() {
    	String path = member.getMemProfilePath();
        if (path == null) return null;

        // /resources 제거
        return path.replace("/resources", "");
    }

    // ===== 임시 비밀번호 저장 Y/N =====
	public String getTempPwYn() {
		return member.getTempPwYn() == null ? "N" : member.getTempPwYn();
	}


	@Override
	public Map<String, Object> getAttributes() {
	    return attributes;
	}


	@Override
	public String getName() {
		return member.getMemId();
	}
	
	public int getMemNo() {
		return member.getMemNo();
	}
	
	/*
	 * public int getCompNo() {
	 * 
	 * return 0; }
	 */
	

}