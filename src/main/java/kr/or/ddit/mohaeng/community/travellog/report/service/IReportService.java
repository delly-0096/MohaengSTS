package kr.or.ddit.mohaeng.community.travellog.report.service;

import java.util.List;

import kr.or.ddit.mohaeng.vo.ReportVO;

public interface IReportService {

    ReportVO createReport(ReportVO req);

    MyReportPageResult listMyReports(Long reqMemNo, int page, int size);

    ReportVO getMyReportDetail(Long reqMemNo, Long rptNo);

    void cancelMyReport(Long reqMemNo, Long rptNo);

    // ===== 목록 응답용 =====
    class MyReportPageResult {
        private final int page;
        private final int size;
        private final int total;
        private final List<ReportVO> items;

        public MyReportPageResult(int page, int size, int total, List<ReportVO> items) {
            this.page = page;
            this.size = size;
            this.total = total;
            this.items = items;
        }
        public int getPage() { return page; }
        public int getSize() { return size; }
        public int getTotal() { return total; }
        public List<ReportVO> getItems() { return items; }
    }
}
