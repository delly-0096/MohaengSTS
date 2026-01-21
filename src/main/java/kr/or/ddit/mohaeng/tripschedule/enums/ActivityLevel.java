package kr.or.ddit.mohaeng.tripschedule.enums;

public enum ActivityLevel {
	RELAXED("여유롭게", "하루 2-3곳"),
    MODERATE("적당히", "하루 4-5곳"),
    BUSY("알차게", "하루 6곳 이상");

    private final String name;
    private final String description;

    ActivityLevel(String name, String description) {
        this.name = name;
        this.description = description;
    }

    public String getName() { return name; }
    public String getDescription() { return description; }
}
