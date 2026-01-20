package kr.or.ddit.mohaeng.community.chat.enums;

public enum ChatMessageType {

    CHAT("일반 메시지"),
    ENTER("입장"),
    LEAVE("퇴장"),
    IMAGE("이미지"),
    FILE("파일"),
    SYSTEM("시스템"),
    REPORT("신고");

    private final String description;

    ChatMessageType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
