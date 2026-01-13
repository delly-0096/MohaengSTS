package kr.or.ddit.mohaeng.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookmarkStatusVO {
    private Long rcdNo;
    private boolean bookmarked;
    private int bookmarkCount;
}
