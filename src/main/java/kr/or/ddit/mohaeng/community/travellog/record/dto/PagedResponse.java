package kr.or.ddit.mohaeng.community.travellog.record.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class PagedResponse<T> {
    private List<T> content;
    private long totalElements;
    private int page;
    private int size;
    private int totalPages;
    
    // ✅ JSP 호환용 alias
    public List<T> getList() {
        return content;
    }

    // ✅ JSP에서 total로 쓰고 있다면 이것도 alias
    public long getTotal() {
        return totalElements;
    }
}
