package kr.or.ddit.mohaeng.vo;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import lombok.Getter;

@Getter
public class CustomUser extends User {

	// 관리자
	private AdminVO admin;

	public CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
	}

	// 관리자
	public CustomUser(AdminVO admin) {
		super(admin.getMemId(), admin.getMemPassword(), 
				admin.getAuthList().stream()
				.map(auth -> new SimpleGrantedAuthority(auth.getAuth())).collect(Collectors.toList()));
		this.admin = admin;
	}
	
	// 일반
//	public CustomUser(일반회원) {
//		super(admin.getMemId(), admin.getMemPassword(), 
//				admin.getAuthList().stream()
//				.map(auth -> new SimpleGrantedAuthority(auth.getAuth())).collect(Collectors.toList()));
//		this.admin = admin;
//	}
	
	// 기업
//	public CustomUser(기업회원) {
//		super(admin.getMemId(), admin.getMemPassword(), 
//				admin.getAuthList().stream()
//				.map(auth -> new SimpleGrantedAuthority(auth.getAuth())).collect(Collectors.toList()));
//		this.admin = admin;
//	}

}
