package kr.or.ddit.mohaeng.common.exception;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import kr.or.ddit.mohaeng.report.exception.DuplicateReportException;

@RestControllerAdvice
public class ApiExceptionHandler {

	@ExceptionHandler(DuplicateReportException.class)
	public ResponseEntity<?> handleDuplicateReport(DuplicateReportException e) {
		Map<String, String> errorResponse = new HashMap<>();
		errorResponse.put("message", e.getMessage());

		return ResponseEntity.status(409).body(e.getMessage());
	}
}