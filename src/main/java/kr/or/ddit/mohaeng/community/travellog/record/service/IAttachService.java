package kr.or.ddit.mohaeng.community.travellog.record.service;

import org.springframework.web.multipart.MultipartFile;

public interface IAttachService {
    Long saveAndReturnAttachNo(MultipartFile file, long loginMemNo);
}
