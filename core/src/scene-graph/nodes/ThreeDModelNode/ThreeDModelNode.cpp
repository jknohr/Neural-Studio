#include "ThreeDModelNode.h"
#include "SceneManager.h"
#include "NodeFactory.h"
#include <iostream>

namespace NeuralStudio {
namespace SceneGraph {

ThreeDModelNode::ThreeDModelNode(const std::string &id) : BaseNodeBackend(id, "ThreeDModelNode")
{
	// Define Outputs - 3D model is a visual source
	addOutput("visual_out", "Visual Output", DataType(DataCategory::Media, "Mesh"));
}

ThreeDModelNode::~ThreeDModelNode()
{
	// Cleanup from SceneManager handled in dedicated cleanup method with context
}

ExecutionResult ThreeDModelNode::process(ExecutionContext &ctx)
{
	if (m_dirty) {
		if (ctx.sceneManager) {
			if (m_modelPath.empty()) {
				return ExecutionResult::failure("Model path is empty.");
			}

			// Check for USD extension
			std::string ext = m_modelPath.substr(m_modelPath.find_last_of(".") + 1);
			if (ext == "usd" || ext == "usda" || ext == "usdc" || ext == "usdz") {
				std::cout << "ThreeDModelNode: Opening USD Stage " << m_modelPath << std::endl;
				if (ctx.sceneManager->OpenUsdStage(m_modelPath)) {
					// In the future, we might return a Stage Root ID, but for now
					// the Stage Manager holds the singleton stage.
					m_sceneObjectId = 9999; // Dummy ID to indicate success
				}
			} else {
				// Standard Mesh Loading Logic (Placeholder)
				// e.g. m_sceneObjectId = context.sceneManager->LoadModel(m_modelPath);
				std::cout << "ThreeDModelNode: Loading Mesh " << m_modelPath << std::endl;
			}

			// Reset dirty flag
			m_dirty = false;
		}
	}

	// Pass scene object ID to output
	if (m_sceneObjectId > 0) {
		setOutputData("Visual Out", m_sceneObjectId);
	}
}

void ThreeDModelNode::setModelPath(const std::string &path)
{
	if (m_modelPath != path) {
		m_modelPath = path;
		m_dirty = true;
	}
}

std::string ThreeDModelNode::getModelPath() const
{
	return m_modelPath;
}

} // namespace SceneGraph
} // namespace NeuralStudio
