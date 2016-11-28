package org.devl.DAO;

import java.util.List;
import java.util.Map;

import org.devl.VO.BoardVO;

public interface BoardDAO {
	
	public List<BoardVO> list(Map<String, Integer> map);

	public boolean save(BoardVO boardVO);

	public BoardVO getContent(int num);

	public boolean update(BoardVO boardVO);

	public int getTotal();

	public Map<String, Object> search(Map<String, Object> map);

	public void deleteContent(int num);

	public List<BoardVO> getReples(int num);
}
