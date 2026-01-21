package kr.or.ddit.mohaeng.tripschedule.enums;

public enum AccommType {
	HOTEL("호텔"),
    RESORT("리조트"),
    PENSION("펜션"),
    GUESTHOUSE("게스트하우스"),
    AIRBNB("에어비앤비"),
    CAMPING("캠핑");

    private final String description;

    AccommType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
