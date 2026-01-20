package kr.or.ddit.mohaeng.mypage.payments.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mypage")
public class MyPaymentsController {

    /**
     * 결제 내역 페이지
     */
    @GetMapping("/payments")
    public String payments() {
        return "mypage/payments";
    }
    
}
