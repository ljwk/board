package org.devl.service;

import org.springframework.web.multipart.MultipartFile;

public class UploadedFile {

	private MultipartFile file;
	// 한번에 다수개의 파일을 받을 때는 List<MultipartFile> files 와 같이 선언하면 된다

	public MultipartFile getFile() {
		return file;
	}

	public void setFile(MultipartFile file) {
		this.file = file;
	}
}