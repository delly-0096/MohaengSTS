package kr.or.ddit.mohaeng.tour.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 투어/체험/티켓 상품 컨트롤러
 */
@Controller
@RequestMapping("/tour")
public class TourController {

    /**
     * 목록 페이지
     */
    @GetMapping
    public String tour() {
        return "product/tour";
    }

    /**
     * 상세 페이지
     */
    @GetMapping("/{id}")
    public String tourDetail(@PathVariable Long id) {
        // TODO: 상품 ID로 데이터 조회
        return "product/tour-detail";
    }

    /**
     * 예약 페이지
     */
    @GetMapping("/{id}/booking")
    public String booking(@PathVariable Long id) {
        // TODO: 상품 ID로 데이터 조회
        return "product/booking";
    }

    /**
     * 예약 완료 페이지 (투어)
     */
    @GetMapping("/complete/{id}")
    public String complete(@PathVariable Long id) {
        // TODO: 예약 ID로 데이터 조회
        return "product/complete";
    }

    /**
     * 예약 완료 페이지 (공통)
     */
    @GetMapping("/complete")
    public String completeBooking() {
        return "product/complete";
    }
}
