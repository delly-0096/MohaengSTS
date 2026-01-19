package kr.or.ddit.mohaeng.accommodation.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.accommodation.service.AccommodationBatchService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/")
@RequiredArgsConstructor
public class AdminBatchController {

    private final AccommodationBatchService service;

    @GetMapping("/batch/load-acc-detail")
    @ResponseBody
    public String loadAccDetail() {
        service.updateAccommodationDetailsBatch();
        return "숙소 상세 데이터 로딩 완료";
    }
}
