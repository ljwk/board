package org.devl.DAO;

import org.devl.VO.UserVO;

public interface UserDAO {
	public int duplicate(String id);

	public boolean join(UserVO userVO);

	public UserVO eqUser(String id);
	
}
