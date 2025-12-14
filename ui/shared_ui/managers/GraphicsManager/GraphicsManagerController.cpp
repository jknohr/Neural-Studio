#include "GraphicsManagerController.h"
#include "../../blueprint/core/NodeGraphController.h"
#include <QDir>
#include <QDebug>
#include <QFileInfo>
#include <QUuid>

namespace NeuralStudio {
namespace Blueprint {

GraphicsManagerController::GraphicsManagerController(QObject *parent) : UI::BaseManagerController(parent)
{
	m_graphicsDirectory = QDir::currentPath() + "/assets/graphics";

	// Initialize 11 graphics variants
	m_graphicsVariants = {
		"graphicsimage",             // Generic raster
		"graphicsvector",            // SVG, PDF
		"graphicstexture",           // 3D textures
		"graphicshdr",               // HDR/EXR
		"graphicssprite",            // Sprite sheets
		"graphicsicon",              // Icon files
		"graphicsgeneratornoise",    // Procedural noise
		"graphicsgeneratorgradient", // Gradient generator
		"graphicsgeneratorpattern",  // Pattern generator
		"graphicsscreenshot",        // Screenshot
		"graphicscanvas"             // Drawing canvas
	};

	scanGraphics();
}

GraphicsManagerController::~GraphicsManagerController() {}

void GraphicsManagerController::scanGraphics()
{
	m_availableGraphics.clear();
	QDir graphicsDir(m_graphicsDirectory);

	if (!graphicsDir.exists()) {
		qWarning() << "Graphics directory does not exist:" << m_graphicsDirectory;
		emit availableGraphicsChanged();
		emit graphicsChanged();
		return;
	}

	QStringList filters;
	filters << "*.png" << "*.jpg" << "*.jpeg" << "*.svg" << "*.webp" << "*.bmp" << "*.gif"
		<< "*.exr" << "*.hdr" << "*.tga" << "*.dds" << "*.ico" << "*.icns";
	QFileInfoList files = graphicsDir.entryInfoList(filters, QDir::Files);

	for (const QFileInfo &fileInfo : files) {
		QVariantMap graphic;
		graphic["name"] = fileInfo.baseName();
		graphic["path"] = fileInfo.absoluteFilePath();
		graphic["size"] = fileInfo.size();
		graphic["format"] = fileInfo.suffix().toUpper();

		// Auto-detect variant type
		QString detectedVariant = detectGraphicsVariant(fileInfo.absoluteFilePath());
		graphic["detectedVariant"] = detectedVariant;

		bool inUse = false;
		for (const QString &nodeId : managedNodes()) {
			if (getResourceForNode(nodeId) == fileInfo.absoluteFilePath()) {
				inUse = true;
				graphic["nodeId"] = nodeId;
				graphic["managed"] = true;
				break;
			}
		}
		graphic["inUse"] = inUse;

		m_availableGraphics.append(graphic);
	}

	qDebug() << "Found" << m_availableGraphics.size() << "graphics," << managedNodes().size() << "managed nodes";
	emit availableGraphicsChanged();
	emit graphicsChanged();
}

QString GraphicsManagerController::generateNodeId() const
{
	return QUuid::createUuid().toString(QUuid::WithoutBraces);
}

QString GraphicsManagerController::detectGraphicsVariant(const QString &filePath) const
{
	QFileInfo fileInfo(filePath);
	QString baseName = fileInfo.baseName().toLower();
	QString suffix = fileInfo.suffix().toLower();

	// Detect by file extension
	if (suffix == "svg" || suffix == "pdf" || suffix == "ai" || suffix == "eps")
		return "graphicsvector";
	if (suffix == "exr" || suffix == "hdr" || suffix == "rgbe")
		return "graphicshdr";
	if (suffix == "dds" || suffix == "ktx" || suffix == "tga")
		return "graphicstexture";
	if (suffix == "ico" || suffix == "icns")
		return "graphicsicon";

	// Detect by filename
	if (baseName.contains("sprite") || baseName.contains("atlas"))
		return "graphicssprite";
	if (baseName.contains("icon"))
		return "graphicsicon";
	if (baseName.contains("texture") || baseName.contains("normal") || baseName.contains("roughness"))
		return "graphicstexture";

	// Default to generic image
	return "graphicsimage";
}

void GraphicsManagerController::createGraphicsNode(const QString &graphicPath, const QString &variantType)
{
	if (!m_graphController)
		return;

	// Generate unique UUID for this node instance
	QString nodeId = generateNodeId();

	// Create node with specific variant type
	QString variantToUse = variantType.isEmpty() ? detectGraphicsVariant(graphicPath) : variantType;

	m_graphController->createNode("GraphicsNode", 0.0f, 0.0f);
	m_graphController->setNodeProperty(nodeId, "nodeId", nodeId);
	m_graphController->setNodeProperty(nodeId, "variantType", variantToUse);
	m_graphController->setNodeProperty(nodeId, "graphicPath", graphicPath);

	QVariantMap metadata;
	metadata["graphicPath"] = graphicPath;
	metadata["variantType"] = variantToUse;
	trackNode(nodeId, graphicPath, metadata);

	scanGraphics();
	qDebug() << "GraphicsManager created node:" << nodeId << "variant:" << variantToUse;
}

void GraphicsManagerController::createGraphicsNodeVariant(const QString &variantType, float x, float y)
{
	if (!m_graphController)
		return;

	// Generate unique UUID
	QString nodeId = generateNodeId();

	// Create generator/screenshot/canvas node (no file)
	m_graphController->createNode("GraphicsNode", x, y);
	m_graphController->setNodeProperty(nodeId, "nodeId", nodeId);
	m_graphController->setNodeProperty(nodeId, "variantType", variantType);

	QVariantMap metadata;
	metadata["variantType"] = variantType;
	trackNode(nodeId, "", metadata);

	qDebug() << "GraphicsManager created variant node:" << nodeId << "variant:" << variantType;
}

} // namespace Blueprint
} // namespace NeuralStudio
