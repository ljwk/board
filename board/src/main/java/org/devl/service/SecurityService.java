package org.devl.service;

import java.util.ArrayList;
import java.util.List;

import org.devl.DAO.UserDAO;
import org.devl.VO.UserVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class SecurityService implements UserDetailsService {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public UserDetails loadUserByUsername(final String username) throws UsernameNotFoundException {
		System.out.printf("loadUserByUsername(), username=%s \n", username);

		UserVO userVO = sqlSessionTemplate.getMapper(UserDAO.class).eqUser(username);
		if (userVO == null) {
			throw new UsernameNotFoundException("접속자 정보를 찾을 수 없습니다.");
		}

		String password = userVO.getPw();
		String permit = userVO.getPermit();

		GrantedAuthority role = new SimpleGrantedAuthority(permit);

		List<GrantedAuthority> roles = new ArrayList<GrantedAuthority>();
		roles.add(role);
		User user = new User(username, password, roles);

		return user;
	}
}