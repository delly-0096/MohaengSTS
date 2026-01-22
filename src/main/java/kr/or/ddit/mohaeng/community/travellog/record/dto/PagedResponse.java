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

	public List<T> getList() {
		return content;
	}

	public long getTotal() {
		return totalElements;
	}
}
