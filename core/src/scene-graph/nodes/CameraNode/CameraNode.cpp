#include "CameraNode.h"
#include "NodeFactory.h"

namespace NeuralStudio {
namespace SceneGraph {

// Register with Factory
namespace {
std::shared_ptr<IExecutableNode> createCameraNode(const std::string &id)
{
	return std::make_shared<CameraNode>(id);
}
struct CameraNodeRegistrar {
	CameraNodeRegistrar() { NodeFactory::registerNodeType("CameraNode", createCameraNode); }
};
static CameraNodeRegistrar registrar;
} // namespace

CameraNode::CameraNode(const std::string &id) : BaseNodeBackend(id, "CameraNode") {}

bool CameraNode::initialize(const NodeConfig &config)
{
	// Define Output Ports
	// Visual Output (Right)
	addOutput("visual_out", "Visual Out", DataType{DataCategory::Media, "Texture"});

	// Audio Output (Bottom)
	addOutput("audio_out", "Audio Out", DataType{DataCategory::Media, "Audio"});
	return true;
}

ExecutionResult CameraNode::process(ExecutionContext &ctx)
{
	// Logic to capture frame from m_deviceId and setPinData("visual_out", texture)
	// For now, no-op or placeholder
	return ExecutionResult::success();
}

void CameraNode::setDeviceId(const std::string &deviceId)
{
	m_deviceId = deviceId;
	// Trigger re-initialization of camera source
}

std::string CameraNode::getDeviceId() const
{
	return m_deviceId;
}

} // namespace SceneGraph
} // namespace NeuralStudio
