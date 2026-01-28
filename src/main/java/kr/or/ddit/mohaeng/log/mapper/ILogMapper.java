package kr.or.ddit.mohaeng.log.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.LogVO;
import kr.or.ddit.mohaeng.vo.SystemLogVO;

@Mapper
public interface ILogMapper {
	
	/**
	 * <p>로그 저장</p>
	 * @author sdg
	 * @date 2026-01-28
	 * @param vo 로그 정보
	 */
	public void insertLog(LogVO vo);
	
	/**
	 * <p>시스템 로그 저장</p>
	 * @author sdg
	 * @date 2026-01-28
	 * @param vo 로그 정보
	 */
	public void insertSystemLog(SystemLogVO vo);

}
