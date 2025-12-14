#include "SceneGraphMixerController.h"
#include <QDebug>
#include <QUuid>
#include <QTimer> // For polling

// Backend Includes
#include "SceneGraphManager.h"
#include "NodeExecutionGraph.h"
#include "IExecutableNode.h"

namespace NeuralStudio {
namespace UI {

SceneGraphMixerController::SceneGraphMixerController(QObject *parent) : QObject(parent)
{
	/// MOCK DATA is initialized only if no manager is set after a delay,
	/// or we can keep it as a placeholder until the first real update comes in.
	initializeMockData();

	// Create a polling timer for backend sync (since signals aren't fully wired yet)
	QTimer *timer = new QTimer(this);
	connect(timer, &QTimer::timeout, this, &SceneGraphMixerController::updateFromBackend);
	timer->start(100); // 10Hz UI update
}

void SceneGraphMixerController::setManager(NeuralStudio::SceneGraph::SceneGraphManager *manager)
{
	if (m_manager != manager) {
		m_manager = manager;
		qDebug() << "SceneGraphMixerController: Connected to Backend Manager.";

		// Clear mock data on first connection
		m_layers.clear();
		emit layersChanged();

		// Trigger immediate update
		updateFromBackend();
	}
}

void SceneGraphMixerController::forceUpdate()
{
	updateFromBackend();
}

void SceneGraphMixerController::updateFromBackend()
{
	if (!m_manager)
		return;
	auto graph = m_manager->getNodeGraph();
	if (!graph)
		return;

	QVariantList newLayers;
	std::vector<std::string> nodeIds = graph->getNodeIds();

	for (const auto &id : nodeIds) {
		auto node = graph->getNode(id);
		if (!node)
			continue;

		const auto &meta = node->getMetadata();

		// Map Backend Type String to UI Enum
		int uiType = UnknownNode;
		std::string typeStr = node->getNodeType(); // e.g. "VideoNode"
		if (typeStr == "VideoNode")
			uiType = VideoNode;
		else if (typeStr == "AudioNode")
			uiType = AudioNode;
		else if (typeStr == "CameraNode")
			uiType = CameraNode;
		else if (typeStr == "ThreeDModelNode")
			uiType = ThreeDModelNode;
		else if (typeStr == "ImageNode")
			uiType = ImageNode;
		else if (typeStr == "ScriptNode")
			uiType = ScriptNode;
		else if (typeStr == "MLNode")
			uiType = MLNode;
		else if (typeStr == "LLMNode")
			uiType = LLMNode;
		else if (typeStr == "GraphicsNode")
			uiType = GraphicsNode;

		// Create UI Object
		QVariantMap layer;
		layer["id"] = QString::fromStdString(id);
		layer["name"] = QString::fromStdString(meta.displayName.empty() ? id : meta.displayName);
		layer["type"] = uiType;

		// Colors: Convert 0xAARRGGBB to Hex String
		// Simple hack for now or use meta.nodeColorRGB
		layer["color"] = QString("#%1").arg(meta.nodeColorRGB & 0xFFFFFF, 6, 16, QChar('0'));

		// Properties - Try to fetch from Pins if available, or Node Data
		// This assumes standard pin naming conventions
		if (node->hasPinData("opacity")) {
			try {
				layer["opacity"] = std::any_cast<float>(node->getPinData("opacity"));
			} catch (...) {
				layer["opacity"] = 1.0f;
			}
		} else {
			layer["opacity"] = 1.0f;
		}

		bool visible = true;
		if (node->hasPinData("active")) {
			try {
				visible = std::any_cast<bool>(node->getPinData("active"));
			} catch (...) {
			}
		}
		layer["visible"] = visible;

		// Z-Index might be a custom property not on pins.
		// For now, default to 0.
		layer["zIndex"] = 0;

		newLayers.append(layer);
	}

	// Simple Diff Check could be added here to avoid spamming signals
	// For now, just replace
	if (newLayers != m_layers) {
		m_layers = newLayers;
		m_rootNodes = m_layers; // Flat hierarchy for now
		emit layersChanged();
		emit rootNodesChanged();
	}
}

QString SceneGraphMixerController::getNodeTypeString(int typeVal) const
{
	switch (typeVal) {
	case VideoNode:
		return "Video";
	case AudioNode:
		return "Audio";
	case CameraNode:
		return "Camera";
	case ThreeDModelNode:
		return "3D Model";
	case ImageNode:
		return "Image";
	case ScriptNode:
		return "Script";
	case MLNode:
		return "ML Model";
	case LLMNode:
		return "LLM Agent";
	case GraphicsNode:
		return "Graphics";
	default:
		return "Unknown";
	}
}

void SceneGraphMixerController::initializeMockData()
{
	// Keep Mock Data logic for testing when backend is null
	// ... (Previous Mock Data Implementation)
	// For brevity, using the previous logic but ensuring it doesn't overwrite if manager exists.
	if (m_manager)
		return;

	// (Standard Mock Data here - abbreviated for this edit block as I am replacing the whole file logic roughly)
	// Re-pasting the mock data generation so it remains valid purely for this tool call context

	// 1. Live Camera Feed (CameraNode)
	QVariantMap layer1;
	layer1["id"] = QUuid::createUuid().toString();
	layer1["name"] = "Studio Cam A";
	layer1["type"] = CameraNode;
	layer1["opacity"] = 1.0;
	layer1["visible"] = true;
	layer1["zIndex"] = 0;
	layer1["color"] = "#FF5555";

	QVariantMap layer2;
	layer2["id"] = QUuid::createUuid().toString();
	layer2["name"] = "Lower Thirds";
	layer2["type"] = ImageNode;
	layer2["opacity"] = 1.0;
	layer2["visible"] = true;
	layer2["zIndex"] = 1;
	layer2["color"] = "#55FF55";

	m_layers.append(layer1);
	m_layers.append(layer2);

	m_rootNodes = m_layers;
	emit layersChanged();
}

void SceneGraphMixerController::setLayerOpacity(const QString &nodeId, float opacity)
{
	if (m_manager) {
		auto graph = m_manager->getNodeGraph();
		if (graph) {
			auto node = graph->getNode(nodeId.toStdString());
			if (node) {
				// Push to backend
				node->setPinData("opacity", opacity);
			}
		}
		// Trigger immediate UI refresh (speculative execution)
		// In real system, wait for next poll usually
		forceUpdate();
	} else {
		// Mock Logic
		for (int i = 0; i < m_layers.size(); ++i) {
			QVariantMap layer = m_layers[i].toMap();
			if (layer["id"].toString() == nodeId) {
				layer["opacity"] = opacity;
				m_layers[i] = layer;
				emit layersChanged();
				return;
			}
		}
	}
}

void SceneGraphMixerController::setLayerZOrder(const QString &nodeId, int zIndex)
{
	// Similar logic for Z-Order
	if (m_manager) {
		// Backend Z-Order logic not strictly defined in IExecutableNode yet
		// Would likely require a specific "SceneNode" interface cast
	} else {
		for (int i = 0; i < m_layers.size(); ++i) {
			QVariantMap layer = m_layers[i].toMap();
			if (layer["id"].toString() == nodeId) {
				layer["zIndex"] = zIndex;
				m_layers[i] = layer;
				emit layersChanged();
				return;
			}
		}
	}
}

void SceneGraphMixerController::toggleLayerVisibility(const QString &nodeId)
{
	if (m_manager) {
		auto graph = m_manager->getNodeGraph();
		if (graph) {
			auto node = graph->getNode(nodeId.toStdString());
			if (node) {
				// Check observable state
				bool current = true;
				if (node->hasPinData("active")) {
					try {
						current = std::any_cast<bool>(node->getPinData("active"));
					} catch (...) {
					}
				}
				node->setPinData("active", !current);
			}
		}
		forceUpdate();
	} else {
		for (int i = 0; i < m_layers.size(); ++i) {
			QVariantMap layer = m_layers[i].toMap();
			if (layer["id"].toString() == nodeId) {
				layer["visible"] = !layer["visible"].toBool();
				m_layers[i] = layer;
				emit layersChanged();
				return;
			}
		}
	}
}

void SceneGraphMixerController::reparentNode(const QString &childId, const QString &parentId)
{
	// Stub
}

void SceneGraphMixerController::toggleVirtualCam()
{
	if (m_virtualCamStatus == Connected) {
		m_virtualCamStatus = Disconnected;
	} else {
		m_virtualCamStatus = Connected;
	}
	emit virtualCamStatusChanged();
}

} // namespace UI
} // namespace NeuralStudio
