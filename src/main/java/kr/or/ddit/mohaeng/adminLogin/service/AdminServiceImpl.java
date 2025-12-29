package kr.or.ddit.mohaeng.adminLogin.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import kr.or.ddit.mohaeng.adminLogin.mapper.IAdminMapper;
import kr.or.ddit.mohaeng.vo.AdminLoginVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminServiceImpl implements IAdminService{
	
	@Autowired
	private IAdminMapper adminMapper;
	
//	@Autowired
//    private PasswordEncoder passwordEncoder;

	@Override
	public AdminLoginVO login(String loginId, String password) {
		AdminLoginVO admin = adminMapper.selectByLoginId(loginId);
        if (admin == null) return null;
        
        if (!admin.getMemPassword().equals(password)) {
            return null;
        }
        log.info("입력 password = [{}]", password);
        log.info("DB password = [{}]", admin.getMemPassword());

//        if (!passwordEncoder.matches(password, admin.getPassword())) {
//            return null;
//        }

        log.info("admin 조회 결과: {}", admin);
        
        return admin;
	}

}
