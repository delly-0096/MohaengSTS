package kr.or.ddit.mohaeng.vo;

import java.util.List;

import lombok.Data;

@Data
public class AdminVO {

	private int memNo;
	private int posiNo;
	private String deptName;
	
	private List<AdminPositionVO> positionList;
}
