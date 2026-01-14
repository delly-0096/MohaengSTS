package kr.or.ddit.mohaeng.common.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import kr.or.ddit.mohaeng.community.travellog.report.exception.DuplicateReportException;

@RestControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(DuplicateReportException.class)
    public ResponseEntity<?> handleDuplicateReport(DuplicateReportException e) {
        return ResponseEntity.status(409).body(e.getMessage());
    }
}