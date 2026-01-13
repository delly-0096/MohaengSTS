package kr.or.ddit.mohaeng.vo;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class PagedResponseVO<T> {
    private int page;
    private int size;
    private int total;
    private List<T> items;
}
