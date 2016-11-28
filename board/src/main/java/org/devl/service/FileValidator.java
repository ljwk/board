package org.devl.service;

import org.springframework.stereotype.Service;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.springframework.web.multipart.MultipartFile;

@Service("fileValidator")
public class FileValidator implements Validator {

	public boolean supports(Class<?> arg0) {
		return false;
	}

	public void validate(Object uploadedFile, Errors errors) {

		MultipartFile file = (MultipartFile) uploadedFile;
		System.out.println(file.isEmpty());

		if (file.getSize() == 0) {
			errors.rejectValue("uploadedFile", "uploadForm.selectFile", "파일을 선택해 주세요");
		}
	}
}