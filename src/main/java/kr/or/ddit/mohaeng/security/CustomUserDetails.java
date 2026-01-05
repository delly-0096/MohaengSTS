package kr.or.ddit.mohaeng.security;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import kr.or.ddit.mohaeng.vo.MemberVO;

public class CustomUserDetails implements UserDetails {
	
	private MemberVO member;
	 
    public CustomUserDetails(MemberVO member) {
        this.member = member;
    }

    // 권한
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
	    
		if (member.getAuthList() == null) {
	        return List.of();
	    }

	    return member.getAuthList().stream()
    		.map(auth -> auth.getAuth())
            .filter(a -> a != null && !a.trim().isEmpty())
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
	
	@Override public boolean isAccountNonExpired() { return true; }
    @Override public boolean isAccountNonLocked() { return true; }
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

}
