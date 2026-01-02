package kr.or.ddit.mohaeng.adminLogin.service;

import java.time.Duration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


import kr.or.ddit.mohaeng.adminLogin.mapper.IAdminMapper;
import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.util.TokenProvider;
import kr.or.ddit.mohaeng.vo.AdminLoginVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminServiceImpl implements IAdminService{
	
	@Autowired
	private IAdminMapper adminMapper;
	
	@Autowired
    private PasswordEncoder passwordEncoder;

	@Override
	public AdminLoginVO login(String loginId, String password) {
		
		AdminLoginVO admin = adminMapper.selectByLoginId(loginId);
        log.info("admin 조회 결과: {}", admin);
        
        if(admin == null) {
        	return null;
        }
        
        if(!passwordEncoder.matches(password, admin.getMemPassword())) {
        	return null;
        }
        
        return admin;
	}

}
