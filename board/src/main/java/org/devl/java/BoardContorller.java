package org.devl.java;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.devl.VO.BoardVO;
import org.devl.VO.FileVO;
import org.devl.service.BoadrService;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/main")
public class BoardContorller {

	@Autowired
	private BoadrService boardService;

	// @RequestMapping(value = "/set")
	// public String set(Authentication auth){
	// User user = (User)auth.getPrincipal();
	// System.out.println(user.getName());
	// return "redirect:home";
	// }

	@RequestMapping(value = "/home")
	public String home(Model model, @RequestParam(defaultValue = "1") int page, @RequestParam(required = false) String word, @RequestParam(value = "select", required = false) String key) {
		if (word == null) {
			model.addAttribute("list", boardService.getList(page));
			model.addAttribute("total", boardService.getTotal());
		} else {
			model.addAttribute("word", word);
			model.addAttribute("select", key);
			Map<String, Object> result = boardService.search(word, key, page);
			model.addAttribute("list", result.get("list"));
			model.addAttribute("total", result.get("total"));
		}
		model.addAttribute("page", page);
		return "/board/list";
	}

	@RequestMapping(value = "/write", method = RequestMethod.GET)
	public String write(Model model) {
		System.out.println("쓰기");
		model.addAttribute("boardVO", new BoardVO());
		return "/board/write";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/write", method = RequestMethod.POST)
	@ResponseBody
	public String write(BoardVO boardVO, BindingResult result, Model model) {
		// fileValidator.validate(boardVO.getUploadedFile(), result);
		System.out.println(boardVO.getTitle());
		System.out.println(boardVO.getUploadedFile());
		JSONObject obj = new JSONObject(new HashMap<String, Object>());

		if (!boardVO.isModify()) {
			System.out.println("BoardController/isModify.false");
			obj.put("result", boardService.save(boardVO));
			obj.put("way", "home");
			return obj.toJSONString();
		} else {
			System.out.println("BoardController/isModify.true");
			obj.put("result", boardService.update(boardVO));
			obj.put("way", "content?num=" + boardVO.getNum());
			return obj.toJSONString();
		}
	}

	@RequestMapping(value = "/writeReple", method = RequestMethod.POST)
	public String writeReple(BoardVO boardVO, Model model, Authentication auth, @RequestParam("parent") int parent) {
		System.out.println("리플 게시글" + boardVO.getNum());
		if (boardVO.isModify()) {
			if (auth.getName().equals(boardService.oneContent(boardVO.getNum()).getAuthor())) {
				System.out.println("수정" + boardVO.getContent());
				boardService.update(boardVO);
			} else {
				return "/security/denied";
			}
		} else {
			System.out.println(boardVO.getContent());
			boardService.save(boardVO);
		}
		model.addAttribute("reples", boardService.getReples(parent));
		return "/board/repleSet";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/content", method = RequestMethod.GET)
	public String content(Model model, @ModelAttribute("num") int num) {
		Map<String, Object> map = boardService.getContent(num);
		model.addAttribute("content", (BoardVO) map.get("board"));
		model.addAttribute("filedata", (FileVO) map.get("filedata"));
		model.addAttribute("reples", (List<BoardVO>) map.get("reple"));
		return "/board/content";
	}

	@RequestMapping(value = "/download")
	@ResponseBody
	public byte[] getFile(HttpServletResponse response, @RequestParam String id, @RequestParam String rfile, Authentication auth) throws IOException {

		byte[] bytes = boardService.getFile(id);

		// 한글은 http 헤더에 사용할 수 없기때문에 파일명은 영문으로 인코딩하여 헤더에 적용한다
		String fn = new String(rfile.getBytes(), "iso_8859_1");

		response.setHeader("Content-Disposition", "attachment; filename=\"" + fn + "\"");
		response.setContentLength(bytes.length);
		// response.setContentType("image/jpeg");

		return bytes;
	}

	@RequestMapping(value = "/modify")
	public String modify(Model model, @ModelAttribute("num") int num, Authentication auth) {
		BoardVO boardVO = boardService.oneContent(num);
		if (auth.getName().equals(boardVO.getAuthor())) {
			model.addAttribute("boardVO", boardService.getModifyContent(num));
			return "/board/write";
		} else {
			return "/security/denied";
		}
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/delete")
	@ResponseBody
	public String delete(Model model, @RequestParam("num") int num, Authentication auth) {
		JSONObject obj = new JSONObject();
		System.out.println("asdfasdf");
		BoardVO vo = boardService.oneContent(num);
		if (auth.getName().equals(vo.getAuthor())) {
			if (boardService.deleteContent(num)) {
				System.out.println(0);
				obj.put("result", 0);
				if (vo.getTitle() != null) {
					obj.put("way", "home");
				} else {
					obj.put("way", "");
				}
			} else {
				System.out.println(1);
				obj.put("result", 1);
			}
		} else {
			System.out.println(2);
			obj.put("result", 2);
		}
		return obj.toJSONString();
	}
}