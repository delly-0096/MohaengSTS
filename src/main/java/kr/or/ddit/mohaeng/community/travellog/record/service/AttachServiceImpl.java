package kr.or.ddit.mohaeng.community.travellog.record.service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.Locale;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.community.travellog.record.mapper.ITripRecordMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AttachServiceImpl implements IAttachService {

	private final ITripRecordMapper mapper;

	// 기존 properties 그대로 사용
	@Value("${kr.or.ddit.mohaeng.upload.path}")
	private String uploadRoot; 

	@Override
	@Transactional
	public Long saveAndReturnAttachNo(MultipartFile file, long loginMemNo) {
		if (file == null || file.isEmpty())
			return null;

		// 1) 시퀀스 채번
		Long attachNo = mapper.nextAttachNo();
		Long fileNo = mapper.nextFileNo();
		if (attachNo == null || fileNo == null) {
			throw new RuntimeException("첨부 시퀀스 채번 실패(SEQ_ATTACH_FILE / SEQ_ATTACH_FILE_DETAIL 확인)");
		}

		// 2) 파일 정보
		String originalName = safeOriginalName(file.getOriginalFilename());
		String ext = extractExt(originalName);
		String mimeType = safeMimeType(file.getContentType());

		if (ext.isBlank())
			ext = guessExtFromMime(mimeType);

		String saveName = UUID.randomUUID().toString() + (ext.isBlank() ? "" : "." + ext);

		// 3) DB 경로
		LocalDate today = LocalDate.now();
		String datePath = String.format("/%04d/%02d/%02d", today.getYear(), today.getMonthValue(),
				today.getDayOfMonth());
		String dbFilePath = "/travellog/cover" + datePath + "/" + saveName;

		// 4) 디스크 저장 경로: uploadRoot + (dbFilePath)
		String root = normalizeRoot(uploadRoot);
		Path diskPath = Paths.get(root, dbFilePath.replaceFirst("^/", "").replace("/", java.io.File.separator));
		Path diskDir = diskPath.getParent();

		try {
			Files.createDirectories(diskDir);
			file.transferTo(diskPath.toFile());

			// 5) DB insert
			int a = mapper.insertAttachFile(attachNo, loginMemNo);
			if (a != 1)
				throw new RuntimeException("ATTACH_FILE 저장 실패");

			int d = mapper.insertAttachFileDetail(fileNo, attachNo, saveName, // FILE_NAME
					originalName, // FILE_ORIGINAL_NAME
					ext.isBlank() ? "bin" : ext, // FILE_EXT NOT NULL
					file.getSize(), dbFilePath, // FILE_PATH (DB에 저장될 경로)
					"ATTACH", // FILE_GB_CD 
					mimeType, // MIMY_TYPE
					"Y", // USE_YN
					loginMemNo);
			if (d != 1)
				throw new RuntimeException("ATTACH_FILE_DETAIL 저장 실패");

			return attachNo;

		} catch (Exception e) {
			// 실패 시 파일 삭제 시도
			try {
				Files.deleteIfExists(diskPath);
			} catch (Exception ignore) {
			}
			throw new RuntimeException("파일 저장 중 오류: " + e.getMessage(), e);
		}
	}

	private String normalizeRoot(String root) {
		if (root == null || root.isBlank())
			return "C:/upload/";
		// 끝에 / 또는 \ 없으면 붙이기
		if (root.endsWith("/") || root.endsWith("\\"))
			return root;
		return root + "/";
	}

	private String safeOriginalName(String name) {
		if (name == null || name.isBlank())
			return "file";
		name = name.replace("\\", "/");
		int idx = name.lastIndexOf('/');
		return (idx >= 0) ? name.substring(idx + 1) : name;
	}

	private String extractExt(String filename) {
		if (filename == null)
			return "";
		int dot = filename.lastIndexOf('.');
		if (dot < 0 || dot == filename.length() - 1)
			return "";
		return filename.substring(dot + 1).toLowerCase(Locale.ROOT);
	}

	private String safeMimeType(String contentType) {
		return (contentType == null || contentType.isBlank()) ? "application/octet-stream" : contentType;
	}

	private String guessExtFromMime(String mime) {
		if (mime == null)
			return "";
		return switch (mime) {
		case "image/jpeg" -> "jpg";
		case "image/png" -> "png";
		case "image/gif" -> "gif";
		case "image/webp" -> "webp";
		default -> "";
		};
	}
}
