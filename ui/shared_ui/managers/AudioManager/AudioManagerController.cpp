#include "AudioManagerController.h"
#include "../../blueprint/core/NodeGraphController.h"
#include <QDir>
#include <QDebug>
#include <QFileInfo>
#include <QUuid>

namespace NeuralStudio {
namespace Blueprint {

AudioManagerController::AudioManagerController(QObject *parent) : UI::BaseManagerController(parent)
{
	m_audioDirectory = QDir::currentPath() + "/assets/audio";

	// Initialize available variant types
	m_audioVariants << "audioclip"
			<< "audioclipmusic"
			<< "audioclippodcast"
			<< "audioclipfx"
			<< "audiostream"
			<< "audiostreammusic"
			<< "audiostreampodcast"
			<< "audiostreamvoicecall";

	scanAudio();
}

AudioManagerController::~AudioManagerController() {}

QString AudioManagerController::generateNodeId()
{
	// Generate UUID for unique node identification
	return QUuid::createUuid().toString(QUuid::WithoutBraces);
}

QString AudioManagerController::detectAudioCategory(const QString &filePath)
{
	QFileInfo fileInfo(filePath);
	QString baseName = fileInfo.baseName().toLower();

	// Simple heuristic detection based on filename
	if (baseName.contains("music") || baseName.contains("song") || baseName.contains("track")) {
		return "audioclipmusic";
	} else if (baseName.contains("podcast") || baseName.contains("episode") || baseName.contains("voice")) {
		return "audioclippodcast";
	} else if (baseName.contains("fx") || baseName.contains("sfx") || baseName.contains("effect") ||
		   baseName.contains("sound")) {
		return "audioclipfx";
	}

	// Default to generic audio clip
	return "audioclip";
}

void AudioManagerController::scanAudio()
{
	m_availableAudio.clear();
	QDir audioDir(m_audioDirectory);

	if (!audioDir.exists()) {
		qWarning() << "Audio directory does not exist:" << m_audioDirectory;
		emit availableAudioChanged();
		emit audioChanged();
		return;
	}

	QStringList filters;
	filters << "*.wav" << "*.mp3" << "*.ogg" << "*.flac" << "*.aac" << "*.m4a";
	QFileInfoList files = audioDir.entryInfoList(filters, QDir::Files);

	for (const QFileInfo &fileInfo : files) {
		QVariantMap audio;
		audio["name"] = fileInfo.baseName();
		audio["path"] = fileInfo.absoluteFilePath();
		audio["size"] = fileInfo.size();
		audio["format"] = fileInfo.suffix().toUpper();

		// Determine audio type/quality
		QString suffix = fileInfo.suffix().toLower();
		if (suffix == "flac" || suffix == "wav") {
			audio["type"] = "Lossless";
			audio["quality"] = "Lossless";
		} else {
			audio["type"] = "Compressed";
			audio["quality"] = "Lossy";
		}

		// Detect suggested variant type
		audio["suggestedVariant"] = detectAudioCategory(fileInfo.absoluteFilePath());

		// Check if file is in use by any managed node
		bool inUse = false;
		for (const QString &nodeId : managedNodes()) {
			if (getResourceForNode(nodeId) == fileInfo.absoluteFilePath()) {
				inUse = true;
				audio["nodeId"] = nodeId;
				audio["managed"] = true;
				break;
			}
		}
		audio["inUse"] = inUse;

		m_availableAudio.append(audio);
	}

	qDebug() << "Found" << m_availableAudio.size() << "audio files," << managedNodes().size() << "managed nodes";
	emit availableAudioChanged();
	emit audioChanged();
}

void AudioManagerController::createAudioNode(const QString &audioPath, const QString &variantType)
{
	if (!m_graphController)
		return;

	// Generate unique UUID for this node instance
	QString nodeId = generateNodeId();

	// Create node with specific variant type
	QString createdNodeId = m_graphController->createNode("AudioNode", 0.0f, 0.0f);
	if (createdNodeId.isEmpty()) {
		qWarning() << "Failed to create AudioNode";
		return;
	}

	// Set node properties
	m_graphController->setNodeProperty(createdNodeId, "nodeId", nodeId);           // Set UUID
	m_graphController->setNodeProperty(createdNodeId, "variantType", variantType); // Set variant
	m_graphController->setNodeProperty(createdNodeId, "audioPath", audioPath);     // Set audio file

	// Track node in manager
	QVariantMap metadata;
	metadata["audioPath"] = audioPath;
	metadata["variantType"] = variantType;
	metadata["nodeId"] = nodeId; // Store UUID in metadata
	trackNode(createdNodeId, audioPath, metadata);

	scanAudio();
	qDebug() << "AudioManager created node:" << createdNodeId << "with UUID:" << nodeId << "variant:" << variantType
		 << "audio:" << audioPath;
}

void AudioManagerController::createAudioNodeVariant(const QString &variantType, float x, float y)
{
	if (!m_graphController)
		return;

	// Create node for stream/mic variants that don't have audio files
	QString nodeId = generateNodeId();

	QString createdNodeId = m_graphController->createNode("AudioNode", x, y);
	if (createdNodeId.isEmpty()) {
		qWarning() << "Failed to create AudioNode variant";
		return;
	}

	// Set variant type and UUID
	m_graphController->setNodeProperty(createdNodeId, "nodeId", nodeId);
	m_graphController->setNodeProperty(createdNodeId, "variantType", variantType);

	// Track node
	QVariantMap metadata;
	metadata["variantType"] = variantType;
	metadata["nodeId"] = nodeId;
	trackNode(createdNodeId, variantType, metadata); // Use variant as resourceId

	qDebug() << "AudioManager created variant node:" << createdNodeId << "with UUID:" << nodeId
		 << "variant:" << variantType;
}

} // namespace Blueprint
} // namespace NeuralStudio
