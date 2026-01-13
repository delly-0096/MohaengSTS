package kr.or.ddit.mohaeng.community.travellog.record.security;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import kr.or.ddit.mohaeng.community.travellog.record.service.ITripRecordService;
import lombok.RequiredArgsConstructor;

@Component("tripRecordAuth")
@RequiredArgsConstructor
public class TripRecordAuth {

    private final ITripRecordService service;

    public boolean isWriter(long rcdNo, Authentication authentication) {
        Long memNo = AuthPrincipalExtractor.getMemNo(authentication);
        return service.isWriter(rcdNo, memNo);
    }
}
