package kr.or.ddit.mohaeng.community.travellog.comments.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.community.travellog.comments.mapper.ICommentsMapper;
import kr.or.ddit.mohaeng.vo.CommentsVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommentsServiceImpl implements ICommentsService {

	private final ICommentsMapper mapper;

	@Override
	public List<CommentsVO> list(String targetType, Long targetNo, Long loginMemberNo) {
		return mapper.selectCommentsByTarget(targetType, targetNo, loginMemberNo);
	}

	@Override
	@Transactional
	public int write(String targetType, Long targetNo, Long writerNo, String content, Long parentCmntNo) {
		CommentsVO vo = new CommentsVO();
		vo.setTargetType(targetType);
		vo.setTargetNo(targetNo);
		vo.setWriterNo(writerNo);
		vo.setParentCmntNo(parentCmntNo);
		vo.setCmntContent(content);
		return mapper.insertComment(vo);
	}

	@Override
	@Transactional
	public boolean update(Long cmntNo, Long writerNo, String content) {
		return mapper.updateCommentContent(cmntNo, writerNo, content) == 1;
	}

	@Override
	@Transactional
	public boolean delete(Long cmntNo, Long writerNo) {
		return mapper.softDeleteComment(cmntNo, writerNo) == 1;
	}
}
