#include "IDGenerator.h"
#include <iostream>
#include <cassert>

using namespace NeuralStudio;

int main()
{
	std::cout << "=== Universal ID Generator Test ===" << std::endl;

	// Generate various IDs
	auto audioClipId = IDGenerator::generateNode("AU", "CLIP");
	std::cout << "Audio Clip Node:    " << audioClipId << std::endl;
	assert(audioClipId.substr(0, 7) == "NAUCLIP");

	auto videoFileId = IDGenerator::generateNode("VD", "FILE");
	std::cout << "Video File Node:    " << videoFileId << std::endl;
	assert(videoFileId.substr(0, 7) == "NVDFILE");

	auto pipelineId = IDGenerator::generatePipeline("AU", "STRM");
	std::cout << "Audio Stream Pipeline: " << pipelineId << std::endl;
	assert(pipelineId.substr(0, 7) == "PAUSTRM");

	auto edgeId = IDGenerator::generateEdge("VI", "DATA");
	std::cout << "Visual Data Edge:   " << edgeId << std::endl;
	assert(edgeId.substr(0, 7) == "EVIDATA");

	auto controllerId = IDGenerator::generateController("BP");
	std::cout << "Blueprint Controller: " << controllerId << std::endl;
	assert(controllerId.substr(0, 7) == "CBP0000");

	std::cout << "\n=== Parsing Test ===" << std::endl;

	Species species = IDGenerator::parseSpecies(audioClipId);
	std::cout << "Species: " << static_cast<char>(species) << std::endl;
	assert(species == Species::Node);

	std::string type = IDGenerator::parseType(audioClipId);
	std::cout << "Type: " << type << std::endl;
	assert(type == "AU");

	std::string arch = IDGenerator::parseArchetype(audioClipId);
	std::cout << "Archetype: " << arch << std::endl;
	assert(arch == "CLIP");

	std::string uuid = IDGenerator::parseUUID(audioClipId);
	std::cout << "UUID: " << uuid << std::endl;
	assert(uuid.length() == 36);

	std::cout << "\n=== Validation Test ===" << std::endl;

	assert(IDGenerator::isValid(audioClipId));
	assert(IDGenerator::isNodeID(audioClipId));
	assert(!IDGenerator::isPipelineID(audioClipId));
	assert(IDGenerator::isPipelineID(pipelineId));
	assert(IDGenerator::isEdgeID(edgeId));

	assert(!IDGenerator::isValid("INVALID"));
	assert(!IDGenerator::isValid("N"));

	std::cout << "All validation tests passed!" << std::endl;

	std::cout << "\n=== All Tests Passed! ===" << std::endl;
	return 0;
}
