package org.devl.service;

import java.util.HashMap;
import java.util.Map;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;
import javax.servlet.http.HttpSession;

import org.devl.DAO.UserDAO;
import org.devl.VO.EmailVO;
import org.devl.VO.UserVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

	@Autowired
	protected JavaMailSender mailSender;

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	private String sid;
	private Map<String, String> joinList;
	private Map<String, String> timeSheet;
	private RandomKey key;

	public UserService() {
		System.out.println("UserService객체 생성됨");
		joinList = new HashMap<>();
		timeSheet = new HashMap<>();
		key = new RandomKey();
		new Thread(refreshList()).start();
	}

	private Runnable refreshList() {
		return new Runnable() {
			@Override
			public void run() {
				while (true) {
					if (!timeSheet.isEmpty()) {
						for (String e : timeSheet.keySet()) {
							if (System.currentTimeMillis() > Long.valueOf(e.split("=")[1])) {
								joinList.remove(timeSheet.get(e));
								timeSheet.remove(e);
							}
						}
					}
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			}
		};
	}

	public boolean certify(String email, HttpSession session) {
		EmailVO emailVO = new EmailVO();
		String receiver = email; // Receiver.
		String subject = "인증메일 입니다";
		sid = session.getId();
		joinList.put(sid, email);
		// 시간제한 3분
		timeSheet.put(key.key() + "=" + System.currentTimeMillis() + 180000, sid);
		String content = "http://192.168.2.27:8081/board/check?sid=" + sid;

		emailVO.setReceiver(receiver);
		emailVO.setSubject(subject);
		emailVO.setContent(content);

		System.out.println(content);

		try {
			sendMail(emailVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	private boolean sendMail(EmailVO email) throws Exception {
		MimeMessage msg = mailSender.createMimeMessage();
		InternetAddress addr = new InternetAddress("someone@paran.com");
		msg.setFrom(addr); // 송신자를 설정해도 소용없지만 없으면 오류가 발생한다
		msg.setSubject(email.getSubject());
		msg.setText(email.getContent());
		msg.setRecipient(RecipientType.TO, new InternetAddress(email.getReceiver()));

		mailSender.send(msg);
		return true;
	}

	public boolean sideq(String sid2) {
		for (String a : joinList.keySet()) {
			System.out.println(a);
		}
		for (String sid : joinList.keySet()) {
			if (sid.equals(sid2)) {
				return true;
			}
		}
		return false;
	}

	public String getEmail(String sid) {
		return joinList.get(sid);
	}

	public boolean duplicate(String id) {
		UserDAO userDAO = sqlSessionTemplate.getMapper(UserDAO.class);

		if (userDAO.duplicate(id) == 1) {
			return false;
		}
		return true;
	}

	public boolean join(UserVO userVO) {
		userVO.setPermit("ROLE_MEMBER");
		userVO.setPw(new BCryptPasswordEncoder().encode(userVO.getPw()));

		UserDAO userDAO = sqlSessionTemplate.getMapper(UserDAO.class);

		return userDAO.join(userVO);
	}

}