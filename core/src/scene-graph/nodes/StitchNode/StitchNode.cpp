#include "StitchNode.h"
#include "NodeFactory.h"

namespace NeuralStudio {
namespace SceneGraph {

StitchNode::StitchNode(const std::string &nodeId) : BaseNodeBackend(nodeId, "Stitch")
{
	// Setup metadata
	NodeMetadata meta;
	meta.displayName = "STMap Stitch";
	meta.category = "Video";
	meta.description = "Fisheye to equirectangular stitching using STMap UV remapping";
	meta.tags = {"stitching", "fisheye", "360", "stmap"};
	meta.nodeColorRGB = 0xFF4488FF; // Blue
	meta.icon = ":/icons/nodes/stitch.svg";
	meta.supportsGPU = true;
	meta.supportsCPU = false;
	meta.computeRequirement = ComputeRequirement::Medium;
	meta.estimatedMemoryMB = 100;
	setMetadata(meta);

	// Define pins
	addInput("video_in", "Video Input", DataType::Texture2D());
	addInput("stmap", "STMap Texture", DataType::Texture2D());
	addOutput("video_out", "Stitched Output", DataType::Texture2D());
}

bool StitchNode::initialize(const NodeConfig &config)
{
	m_initialized = true;
	return true;
}

ExecutionResult StitchNode::process(ExecutionContext &ctx)
{
	if (!m_initialized) {
		return ExecutionResult::failure("StitchNode not initialized");
	}

	// Create STMapLoader lazily
	// if (!m_stmapLoader && ctx.renderer) { ... }

	// Get input texture
	auto *inputTexture = getInputData<QRhiTexture *>("video_in");
	if (!inputTexture || !*inputTexture) {
		return ExecutionResult::failure("No input texture");
	}

	// Pass through
	QRhiTexture *outputTexture = *inputTexture;

	// Set output
	setOutputData("video_out", outputTexture);

	return ExecutionResult::success();
}

void StitchNode::cleanup()
{
	m_stmapLoader.reset();
	m_renderer = nullptr;
	m_initialized = false;
}

REGISTER_NODE_TYPE(StitchNode, "Stitch")

} // namespace SceneGraph
} // namespace NeuralStudio
