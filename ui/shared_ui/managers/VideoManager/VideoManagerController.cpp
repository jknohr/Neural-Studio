#include "VideoManagerController.h"
#include "../../blueprint/core/NodeGraphController.h"
#include <QDir>
#include <QDebug>
#include <QFileInfo>
#include <QUuid>

namespace NeuralStudio {
namespace Blueprint {

VideoManagerController::VideoManagerController(QObject *parent) : UI::BaseManagerController(parent)
{
	m_videosDirectory = QDir::currentPath() + "/assets/videos";

	// Initialize 11 video variants
	m_videoVariants = {
		"videofile",              // Generic video
		"videofilecinematic",     // Cinema/ProRes
		"videofiletutorial",      // Tutorial videos
		"videofilevr360",         // 360° VR
		"videofilestereoscopic",  // 3D stereoscopic
		"videofilepointcloud",    // Volumetric
		"videostreamcamera",      // Live camera
		"videostreamscreen",      // Screen capture
		"videostreamnetwork",     // Network stream
		"videostreamvr180",       // VR180
		"videostreamstereoscopic" // Live 3D
	};

	scanVideos();
}

VideoManagerController::~VideoManagerController() {}

void VideoManagerController::scanVideos()
{
	m_availableVideos.clear();
	QDir videosDir(m_videosDirectory);

	if (!videosDir.exists()) {
		qWarning() << "Videos directory does not exist:" << m_videosDirectory;
		emit availableVideosChanged();
		emit videosChanged();
		return;
	}

	QStringList filters;
	filters << "*.mp4" << "*.avi" << "*.mov" << "*.mkv" << "*.webm"
		<< "*.m4v" << "*.flv" << "*.wmv" << "*.mpg" << "*.mpeg";
	QFileInfoList files = videosDir.entryInfoList(filters, QDir::Files);

	for (const QFileInfo &fileInfo : files) {
		QVariantMap video;
		video["name"] = fileInfo.baseName();
		video["path"] = fileInfo.absoluteFilePath();
		video["size"] = fileInfo.size();
		video["format"] = fileInfo.suffix().toUpper();

		// Auto-detect variant type
		QString detectedVariant = detectVideoVariant(fileInfo.absoluteFilePath());
		video["detectedVariant"] = detectedVariant;

		bool inUse = false;
		for (const QString &nodeId : managedNodes()) {
			if (getResourceForNode(nodeId) == fileInfo.absoluteFilePath()) {
				inUse = true;
				video["nodeId"] = nodeId;
				video["managed"] = true;
				break;
			}
		}
		video["inUse"] = inUse;

		m_availableVideos.append(video);
	}

	qDebug() << "Found" << m_availableVideos.size() << "videos," << managedNodes().size() << "managed nodes";
	emit availableVideosChanged();
	emit videosChanged();
}

QString VideoManagerController::generateNodeId() const
{
	return QUuid::createUuid().toString(QUuid::WithoutBraces);
}

QString VideoManagerController::detectVideoVariant(const QString &filePath) const
{
	QFileInfo fileInfo(filePath);
	QString baseName = fileInfo.baseName().toLower();
	QString suffix = fileInfo.suffix().toLower();

	// Detect VR/3D variants from filename
	if (baseName.contains("360") || baseName.contains("vr360"))
		return "videofilevr360";
	if (baseName.contains("3d") || baseName.contains("sbs") || baseName.contains("tb"))
		return "videofilestereoscopic";
	if (baseName.contains("cinema") || baseName.contains("prores") || baseName.contains("log"))
		return "videofilecinematic";
	if (baseName.contains("tutorial") || baseName.contains("lesson"))
		return "videofiletutorial";
	if (baseName.contains("pointcloud") || baseName.contains("volumetric"))
		return "videofilepointcloud";

	// Default to generic video file
	return "videofile";
}

void VideoManagerController::createVideoNode(const QString &videoPath, const QString &variantType)
{
	if (!m_graphController)
		return;

	// Generate unique UUID for this node instance
	QString nodeId = generateNodeId();

	// Create node with specific variant type
	QString variantToUse = variantType.isEmpty() ? detectVideoVariant(videoPath) : variantType;

	m_graphController->createNode("VideoNode", 0.0f, 0.0f);
	m_graphController->setNodeProperty(nodeId, "nodeId", nodeId);
	m_graphController->setNodeProperty(nodeId, "variantType", variantToUse);
	m_graphController->setNodeProperty(nodeId, "videoPath", videoPath);

	QVariantMap metadata;
	metadata["videoPath"] = videoPath;
	metadata["variantType"] = variantToUse;
	trackNode(nodeId, videoPath, metadata);

	scanVideos();
	qDebug() << "VideoManager created node:" << nodeId << "variant:" << variantToUse;
}

void VideoManagerController::createVideoNodeVariant(const QString &variantType, float x, float y)
{
	if (!m_graphController)
		return;

	// Generate unique UUID
	QString nodeId = generateNodeId();

	// Create stream/generator node (no file)
	m_graphController->createNode("VideoNode", x, y);
	m_graphController->setNodeProperty(nodeId, "nodeId", nodeId);
	m_graphController->setNodeProperty(nodeId, "variantType", variantType);

	QVariantMap metadata;
	metadata["variantType"] = variantType;
	trackNode(nodeId, "", metadata);

	qDebug() << "VideoManager created variant node:" << nodeId << "variant:" << variantType;
}

} // namespace Blueprint
} // namespace NeuralStudio
