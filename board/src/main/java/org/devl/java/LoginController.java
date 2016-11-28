package org.devl.java;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.devl.VO.UserVO;
import org.devl.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class LoginController {

	@Autowired
	private UserService userService;

	@RequestMapping(value = "/login")
	public String login() {
		return "/security/login";
	}

	@RequestMapping(value = "/join", method = RequestMethod.GET)
	public String joinForm() {
		return "/security/join";
	}

	@RequestMapping(value = "/join", method = RequestMethod.POST)
	public String join(Model model, @Valid UserVO userVO, BindingResult result) {
		userService.join(userVO);
		return "/security/success";
	}

	@RequestMapping(value = "/duplicate", method = RequestMethod.POST)
	@ResponseBody
	public boolean duplicate(@RequestParam String id) {
		return userService.duplicate(id);
	}

	@RequestMapping(value = "/certify")
	public String certify(Model model, @RequestParam String email, HttpSession session) {
		userService.certify(email, session);
		return "/security/timer";
	}

	@RequestMapping(value = "/check")
	public String check(Model model, @RequestParam String sid, HttpSession session) {
		System.out.println(session.getId());
		if (userService.sideq(sid)) {
			model.addAttribute("result", "pass");
			model.addAttribute("email", userService.getEmail(sid));
			return "/security/join";
		}
		return "/security/fail";
	}
	
	@RequestMapping(value = "/logout")
	public String logout() {
		return "/security/logout";
	}
	
	@RequestMapping(value = "/slogout")
	public String slogout() {
		return "/security/logout";
	}
}