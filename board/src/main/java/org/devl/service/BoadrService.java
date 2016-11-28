package org.devl.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.devl.DAO.BoardDAO;
import org.devl.DAO.FileDAO;
import org.devl.VO.BoardVO;
import org.devl.VO.FileVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class BoadrService {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<BoardVO> getList(int page) {
		int a = (page - 1) * 10 + 1;
		int b = a + 9;

		BoardDAO dao = sqlSessionTemplate.getMapper(BoardDAO.class);
		Map<String, Integer> map = new HashMap<>();
		map.put("a", a);
		map.put("b", b);
		return dao.list(map);
	}

	public boolean save(BoardVO boardVO) {
		FileVO fileVO = new FileVO();

		BoardDAO boardDAO = sqlSessionTemplate.getMapper(BoardDAO.class);
		boardVO.setRegdate(new Date(new java.util.Date().getTime()));
		System.out.println(boardVO.getParent());
		if (boardDAO.save(boardVO)) {
			MultipartFile file = boardVO.getUploadedFile();
			System.out.println(file);
			// 파일 있을때
			if (file != null && file.getSize() > 0) {
				fileVO.setNum(boardVO.getNum());
				fileVO.setAuthor(boardVO.getAuthor());
				fileSave(file, fileVO);
			}
			return true;
		}
		return false;
	}

	private void fileSave(MultipartFile file, FileVO fileVO) {
		InputStream inputStream = null;
		OutputStream outputStream = null;
		
		fileVO = fileDetail(file, fileVO);
		
		FileDAO fileDAO = sqlSessionTemplate.getMapper(FileDAO.class);
		if (fileDAO.save(fileVO)) {
			try {
				inputStream = file.getInputStream();

				File newFile = new File("e:/test/upload/" + fileVO.getId());
				if (!newFile.exists()) {
					newFile.createNewFile();
				}
				outputStream = new FileOutputStream(newFile);
				int read = 0;
				byte[] bytes = new byte[1024];

				while ((read = inputStream.read(bytes)) != -1) {
					outputStream.write(bytes, 0, read);
				}
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					outputStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	private FileVO fileDetail(MultipartFile file, FileVO fileVO) {
		int extPath = file.getOriginalFilename().lastIndexOf(".");
		String ext = file.getOriginalFilename().substring(extPath + 1, file.getOriginalFilename().length());
		String fileName = file.getOriginalFilename().split("." + ext)[0];
		fileVO.setExt(ext);
		fileVO.setFilename(fileName);
		fileVO.setId(String.valueOf(System.currentTimeMillis()));
		fileVO.setFilesize(String.valueOf(file.getSize()));
		System.out.println("file id : " + fileVO.getId());
		return fileVO;
	}

	public BoardVO oneContent(int num) {
		BoardDAO boardDAO = sqlSessionTemplate.getMapper(BoardDAO.class);
		return boardDAO.getContent(num);
	}
	
	public Map<String, Object> getContent(int num) {
		BoardDAO boardDAO = sqlSessionTemplate.getMapper(BoardDAO.class);
		FileDAO fileDAO = sqlSessionTemplate.getMapper(FileDAO.class);
		Map<String, Object> map = new HashMap<>();
		map.put("board", boardDAO.getContent(num));
		map.put("filedata", fileDAO.getFiledata(num));
		map.put("reple", getReples(num));
		return map;
	}

	public byte[] getFile(String filename) throws IOException {
		File file = new File("e:/test/upload/" + filename);
		return org.springframework.util.FileCopyUtils.copyToByteArray(file);
	}

	public BoardVO getModifyContent(int num) {
		Map<String, Object> map = getContent(num);
		FileVO fileVO = (FileVO) map.get("filedata");
		if (fileVO != null) {
			((BoardVO) map.get("board")).setFilename(fileVO.getFilename() + "." + fileVO.getExt());
		}
		((BoardVO) map.get("board")).setModify(true);
		return (BoardVO) map.get("board");
	}

	public boolean update(BoardVO boardVO) {
		FileDAO  fileDAO = sqlSessionTemplate.getMapper(FileDAO.class);
		if (boardVO.getUploadedFile() != null && boardVO.getUploadedFile().getSize() > 0){
			FileVO fileVO = new FileVO();

			// 기존 파일 존재
			if (boardVO.getFilename() == null) {
				System.out.println("새로 저장");
				fileVO.setAuthor(boardVO.getAuthor());
				fileSave(boardVO.getUploadedFile(), fileVO);
			// 기존 파일 없음
			} else {
				fileVO.setNum(boardVO.getNum());
				System.out.println("존재");
				fileUpdate(boardVO.getUploadedFile(), fileVO);
			}
		}
		
		if (boardVO.isDeletefile()) {
			System.out.println("del seq");
			fileDelete(fileDAO.getFiledata(boardVO.getNum()).getId());
			fileDAO.delete(boardVO.getNum());
		}
		System.out.println("BoardService/update/last");
		BoardDAO boardDAO = sqlSessionTemplate.getMapper(BoardDAO.class);
		
		return boardDAO.update(boardVO);
	}

	private void fileUpdate(MultipartFile file, FileVO fileVO) {
		InputStream inputStream = null;
		OutputStream outputStream = null;
		
		fileVO = fileDetail(file, fileVO);
		FileDAO fileDAO = sqlSessionTemplate.getMapper(FileDAO.class);
		fileDelete(fileDAO.getFiledata(fileVO.getNum()).getId());
		if (fileDAO.update(fileVO)) {
			try {
				inputStream = file.getInputStream();

				File newFile = new File("e:/test/upload/" + fileVO.getId());
				if (!newFile.exists()) {
					newFile.createNewFile();
				}
				outputStream = new FileOutputStream(newFile);
				int read = 0;
				byte[] bytes = new byte[1024];

				while ((read = inputStream.read(bytes)) != -1) {
					outputStream.write(bytes, 0, read);
				}
				
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					outputStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	public Object getTotal() {
		BoardDAO boardDAO = sqlSessionTemplate.getMapper(BoardDAO.class);
		return (int) Math.ceil(boardDAO.getTotal() / 10.0);
	}

	public Map<String, Object> search(String word, String key, int page) {
		int a = (page - 1) * 10 + 1;
		int b = a + 9;
		System.out.println(a + ":" + b);
		BoardDAO boardDAO = sqlSessionTemplate.getMapper(BoardDAO.class);
		Map<String, Object> map = new HashMap<>();
		map.put("a", a);
		map.put("b", b);
		map.put("word", word);
		map.put("key", key);

		if ((map = boardDAO.search(map)) == null) {
			map = new HashMap<>();
			map.put("list", new ArrayList<>());
			map.put("total", 0);
			System.out.println(map.get("list").getClass());
		} else {
			System.out.println(map.get("total").getClass());
			map.replace("total", (int) Math.ceil(Integer.parseInt((String) map.get("total")) / 10.0));
		}
		return map;
	}

	public boolean deleteContent(int num) {
		BoardDAO boardDAO = sqlSessionTemplate.getMapper(BoardDAO.class);
		FileDAO fileDAO = sqlSessionTemplate.getMapper(FileDAO.class);
		FileVO fileVO = fileDAO.getFiledata(num); 
		if (fileVO != null) {
			System.out.println(fileVO.getId());
			fileDelete(fileVO.getId());
			fileDAO.delete(num);
		}
		
		boardDAO.deleteContent(num);
		return true;
	}

	public List<BoardVO> getReples(int num) {
		BoardDAO boardDAO = sqlSessionTemplate.getMapper(BoardDAO.class);
		return boardDAO.getReples(num);
	}
	
	private boolean fileDelete(String filename) {
		File file = new File("e:/test/upload/" + filename);
		return file.delete();
	}

}
