package org.devl.java;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class csstest {

	@RequestMapping("/test")
	public String test() {
		return "/material/testcase.html";
	}
}
