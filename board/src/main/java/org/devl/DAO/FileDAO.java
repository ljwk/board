package org.devl.DAO;

import org.devl.VO.FileVO;

public interface FileDAO {
	public boolean save(FileVO fileVO);

	public FileVO getFiledata(int num);

	public boolean update(FileVO fileVO);

	public boolean delete(int num);
}
