package kr.or.ddit.mohaeng.community.travellog.report.mapper;

import org.apache.ibatis.annotations.Mapper;
import kr.or.ddit.mohaeng.vo.ReportVO;

@Mapper
public interface IReportMapper {
    int insertReport(ReportVO report);
    
    int existsDuplicateReport(ReportVO report);
}
